<?php

/**
 *  Image 类
 *
 * @package lib
 * @subpackage util
 * @author 张立冰 <roast@php.net>
 */
class Image {

	/**
	 * @var string $fileName 文件名
	 * @access private
	 */
	private $fileName = '';
	
	/**
	 * @var gd resource $imageResource 原图像
	 * @access private
	 */
	private $imageResource = NULL;
	
	/**
	 * @var int $imageWidth 原图像宽
	 * @access private
	 */
	private $imageWidth = NULL;
	
	/**
	 * @var int $imageHeight 原图像高
	 * @access private
	 */
	private $imageHeight = NULL;
	
	/**
	 * @var int $imageType 原图像类型
	 * @access private
	 */
	private $imageType = NULL;
	
	/**
	 * @var int $newResource 新图像
	 * @access private
	 */
	private $newResource = NULL;
	
	/**
	 * @var int $newResType 新图像类型
	 * @access private
	 */
	private $newResType = NULL;
	
	/**
	 * 构造函数
	 * @param string $fileName 文件名
     */
	public function __construct($fileName = NULL) {
		$this->fileName = $fileName;
		if ($this->fileName) {
			$this->getSrcImageInfo();
		}
	}
	
	/**
	 * 取源图像信息
	 * @access private
	 * @return void
	 */
	private function getSrcImageInfo() {
		$info = $this->getImageInfo();
		$this->imageWidth = $info[0];
		$this->imageHeight = $info[1];
		$this->imageType = $info[2];
	}

	/**
	 * 取图像信息
	 * @param string $fileName 文件名
	 * @access private
	 * @return array
	 */
	private function getImageInfo($fileName = NULL) {
		if ($fileName==NULL) {
			$fileName = $this->fileName;
		}
		$info = getimagesize($fileName);
		return $info;
	}

	/**
	 * 创建源图像GD 资源
	 * @access private
	 * @return void
	 */
	private function createSrcImage () {
		$this->imageResource = $this->createImageFromFile();
	}

	/**
	 * 跟据文件创建图像GD 资源
	 * @param string $fileName 文件名
	 * @return gd resource
	 */
    public function createImageFromFile($fileName = NULL) {
		if (!$fileName) {
			$fileName = $this->fileName;
			$imgType = $this->imageType;
		}
        if (!is_readable($fileName) || !file_exists($fileName)) {
            throw new Exception('Unable to open file "' . $fileName . '"');
        }

		if (!$imgType) {
			$imageInfo = $this->getImageInfo($fileName);
			$imgType = $imageInfo[2];
		}
		
        switch ($imgType) {
			case IMAGETYPE_GIF:
				$tempResource = imagecreatefromgif($fileName);
				break;
			case IMAGETYPE_JPEG:
				$tempResource = imagecreatefromjpeg($fileName);
				break;
			case IMAGETYPE_PNG:
				$tempResource = imagecreatefrompng($fileName);
				break;
			case IMAGETYPE_WBMP:
				$tempResource = imagecreatefromwbmp($fileName);
				break;
			case IMAGETYPE_XBM:
				$tempResource = imagecreatefromxbm($fileName);
				break;
			default:
				throw new Exception('Unsupport image type');
        }
		return $tempResource;
    }
	/**
	 * 改变图像大小
	 * @param int $width 宽
	 * @param int $height 高
	 * @param string $flag 按什么方式改变 0=长宽转换成参数指定的 1=按比例缩放，长宽约束在参数指定内，2=以宽为约束缩放，3=以高为约束缩放
	 * @return string
	 */
	public function resizeImage($width, $height, $flag=1) {
		$widthRatio = $width/$this->imageWidth;
		$heightRatio = $height/$this->imageHeight;
		switch ($flag) {
			case 1:
				if ($this->imageHeight < $height && $this->imageWidth < $width) {
					$endWidth = $this->imageWidth;
					$endHeight = $this->imageHeight;
					//return;
				} elseif (($this->imageHeight * $widthRatio)>$height) {
					$endWidth = ceil($this->imageWidth * $heightRatio);
					$endHeight = $height;
				} else {
					$endWidth = $width;
					$endHeight = ceil($this->imageHeight * $widthRatio);
				}
				break;
			case 2:
				$endWidth = $width;
				$endHeight = ceil($this->imageHeight * $widthRatio);
				break;
			case 3:
				$endWidth = ceil($this->imageWidth * $heightRatio);
				$endHeight = $height;
				break;
			case 4:
				$endWidth2 = $width;
				$endHeight2 = $height;
				if ($this->imageHeight < $height && $this->imageWidth < $width) {
					$endWidth = $this->imageWidth;
					$endHeight = $this->imageHeight;
					//return;
				} elseif (($this->imageHeight * $widthRatio)<$height) {
					$endWidth = ceil($this->imageWidth * $heightRatio);
					$endHeight = $height;
				} else {
					$endWidth = $width;
					$endHeight = ceil($this->imageHeight * $widthRatio);
				}
				break;
			default:
				$endWidth = $width;
				$endHeight = $height;
				break;
		}
		if ($this->imageResource==NULL) {
			$this->createSrcImage();
		}
		if ($flag==4) {
			$this->newResource = imagecreatetruecolor($endWidth2,$endHeight2);
		} else {
			$this->newResource = imagecreatetruecolor($endWidth,$endHeight);
		}
		$this->newResType = $this->imageType;
		imagecopyresampled($this->newResource, $this->imageResource, 0, 0, 0, 0, $endWidth, $endHeight,$this->imageWidth,$this->imageHeight);
		
	}
	
	/**
	 * 给图像加水印
	 * @param string $waterContent 水印内容可以是图像文件名，也可以是文字
	 * @param int $pos 位置0-9可以是数组
	 * @param int $textFont 字体大字，当水印内容是文字时有效
	 * @param string $textColor 文字颜色，当水印内容是文字时有效
	 * @return string
	 */
	public function waterMark($waterContent, $pos = 0, $textFont=5, $textColor="#ffffff") {
		$isWaterImage = file_exists($waterContent);
		if ($isWaterImage) {
			$waterImgRes = $this->createImageFromFile($waterContent);
			$waterImgInfo = $this->getImageInfo($waterContent);
			$waterWidth = $waterImgInfo[0];
			$waterHeight = $waterImgInfo[1];
		} else {
			$waterText = $waterContent;
			//$temp = @imagettfbbox(ceil($textFont*2.5),0,"./cour.ttf",$waterContent);
			if ($temp) {
				$waterWidth = $temp[2]-$temp[6];
				$waterHeight = $temp[3]-$temp[7];
			} else {
				$waterWidth = 100;
				$waterHeight = 12;
			}
		}
		if ($this->imageResource==NULL) {
			$this->createSrcImage();
		}
		switch($pos)  { 
			case 1://1为顶端居左 
				$posX = 0; 
				$posY = 0; 
				break; 
			case 2://2为顶端居中 
				$posX = ($this->imageWidth - $waterWidth) / 2; 
				$posY = 0; 
				break; 
			case 3://3为顶端居右 
				$posX = $this->imageWidth - $waterWidth; 
				$posY = 0; 
				break; 
			case 4://4为中部居左 
				$posX = 0; 
				$posY = ($this->imageHeight - $waterHeight) / 2; 
				break; 
			case 5://5为中部居中 
				$posX = ($this->imageWidth - $waterWidth) / 2; 
				$posY = ($this->imageHeight - $waterHeight) / 2; 
				break; 
			case 6://6为中部居右 
				$posX = $this->imageWidth - $waterWidth; 
				$posY = ($this->imageHeight - $waterHeight) / 2; 
				break; 
			case 7://7为底端居左 
				$posX = 0; 
				$posY = $this->imageHeight - $waterHeight; 
				break; 
			case 8://8为底端居中 
				$posX = ($this->imageWidth - $waterWidth) / 2; 
				$posY = $this->imageHeight - $waterHeight; 
				break; 
			case 9://9为底端居右 
				$posX = $this->imageWidth - $waterWidth-20; 
				$posY = $this->imageHeight - $waterHeight-10; 
				break; 
			default://随机 
				$posX = rand(0,($this->imageWidth - $waterWidth)); 
				$posY = rand(0,($this->imageHeight - $waterHeight)); 
				break;     
		}
		imagealphablending($this->imageResource, true);  
		if($isWaterImage) {
			imagecopy($this->imageResource, $waterImgRes, $posX, $posY, 0, 0, $waterWidth,$waterHeight);    
		} else { 
			$R = hexdec(substr($textColor,1,2)); 
			$G = hexdec(substr($textColor,3,2)); 
			$B = hexdec(substr($textColor,5)); 
			
			$textColor = imagecolorallocate($this->imageResource, $R, $G, $B);
			//imagestring ($this->imageResource, $textFont, $posX, $posY, $waterText, $textColor);     
			imagefttext ($this->imageResource,$textFont,0,$posX, $posY,$textColor,'simhei.ttf',$waterText);    
		}
		$this->newResource =  $this->imageResource;
		$this->newResType = $this->imageType;
	}
	
	/**
	 * 生成验证码图片
	 * @param int $width 宽
	 * @param string $height 高
	 * @param int $length 长度
	 * @param int $validType 0=数字,1=字母,2=数字加字母
	 * @param string $textColor 文字颜色
	 * @param string $backgroundColor 背景颜色
	 * @return void
	 */
	public function imageValidate($width, $height, $length = 4, $validType = 1, $textColor = '#000000', $backgroundColor = '#ffffff') {
		if ($validType==1) {
			$validString = 'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ';
			$validLength = 52;
		} elseif ($validType==2) {
			$validString = '0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ';
			$validLength = 62;
		} elseif ($validType==3) {
			$validString = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ';
			$validLength = 26;
		} else {
			$validString = '0123456789';
			$validLength = 10;
		}
		
		srand((int)time());
		$valid = '';
		for ($i=0; $i<$length; $i++) {
			$valid .= $validString{rand(0, $validLength-1)};
		}
		$this->newResource = imagecreate($width,$height);
		$bgR = hexdec(substr($backgroundColor,1,2));
		$bgG = hexdec(substr($backgroundColor,3,2));
		$bgB = hexdec(substr($backgroundColor,5,2));
		$backgroundColor = imagecolorallocate($this->newResource, $bgR, $bgG, $bgB);
		$tR = hexdec(substr($textColor,1,2));
		$tG = hexdec(substr($textColor,3,2));
		$tB = hexdec(substr($textColor,5,2));
		$textColor = imagecolorallocate($this->newResource, $tR, $tG, $tB);
		for ($i=0;$i<strlen($valid);$i++){ 
			imagestring($this->newResource,5,$i*$width/$length+3,2, $valid[$i],$textColor); 
		}
		$this->newResType = IMAGETYPE_JPEG;
		return $valid;

	}
	
	/**
	 * 显示输出图像
	 * @return void
	 */
	public function display($fileName='', $quality=100) {
	
		$imgType = $this->newResType;
		$imageSrc = $this->newResource;
        switch ($imgType) {
		case IMAGETYPE_GIF:
			if ($fileName=='') {
				header('Content-type: image/gif');
			}
			imagegif($imageSrc, $fileName, $quality);
			break;
		case IMAGETYPE_JPEG:
			if ($fileName=='') {
				header('Content-type: image/jpeg');
			}
			imagejpeg($imageSrc, $fileName, $quality);
			break;
		case IMAGETYPE_PNG:
			if ($fileName=='') {
				header('Content-type: image/png');
				imagepng($imageSrc);
			} else {
				imagepng($imageSrc, $fileName);
			}
			break;
		case IMAGETYPE_WBMP:
			if ($fileName=='') {
				header('Content-type: image/wbmp');
			}
			imagewbmp($imageSrc, $fileName, $quality);
			break;
		case IMAGETYPE_XBM:
			if ($fileName=='') {
				header('Content-type: image/xbm');
			}
			imagexbm($imageSrc, $fileName, $quality);
			break;
		default:
			throw new Exception('Unsupport image type');
        }
		imagedestroy($imageSrc);
	}
	
	/**
	 * 保存图像
	 * @param int $fileNameType 文件名类型 0使用原文件名，1使用指定的文件名，2在原文件名加上后缀，3产生随机文件名
	 * @param string $folder 文件夹路径 为空为与原文件相同
	 * @param string $param 参数$fileNameType为1时为文件名2时为后缀
	 * @return void
	 */
	public function save($fileNameType = 0, $folder = NULL, $param = '_miniature') {
	    import('util.FileSystem');
	    
		if ($folder==NULL) {
			$folder = dirname($this->fileName).DIRECTORY_SEPARATOR;
		}
		$fileExtName = FileSystem::fileExt($this->fileName, true);
		$fileBesicName = FileSystem::getBasicName($this->fileName, false);
		
		switch ($fileNameType) {
		case 1:
			$newFileName = $param;
			break;
		case 2:
			$newFileName = $fileBesicName.$param.$fileExtName;
			break;
		case 3:
			$tmp = date('YmdHis');
			$fileBesicName = $tmp;
			$i = 0;
			while (file_exists($folder.$fileBesicName.$fileExtName)) {
				$fileBesicName = $tmp.$i;
				$i++;
			}
			$newFileName = $fileBesicName.$fileExtName;
			break;
		default:
			$newFileName = $this->fileName;
			break;
		}
		
		$this->display($folder.$newFileName);
		return $newFileName;
	}
}
?>