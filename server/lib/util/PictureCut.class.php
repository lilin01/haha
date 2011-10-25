<?php

/**
 * 社区平台-头像上传和裁剪
 * 
 * @author 朱信 <zhuxin@corp.the9.com>
 * Adaptated by 陈敬钻 <chenjingzuan@corp.the9.com>
 *
 * $Id: PictureCut.class.php 1610 2008-12-04 02:01:24Z jingzuan $ 
 */

importModule("Photo.PhotoImage");
 
class PictureCut
{
	// 头像上传后保存的目录
	const UPLOAD_DIR = "../uploads/temp";

	// 裁剪后的头像暂存的目录
	const TEMP_CUT_DIR = "../uploads/temp";

	// 用户确定保存后将头像移动到该目录
	const CUT_DIR = "../uploads";

	// 配置信息 dst为最终截取图片保存的大小
	static private $pic_cfg = array(
		"select_size" => array(
			"width" => 100,
			"height" => 100
		),
		"out_frame" => array(
			"width" => 347,
			"height" => 347
		),
		"dst" => array(
			array(
			"width" => 60,
			"height" => 60		
			),
			array(
			"width" => 80,
			"height" => 80		
			),
			array(
			"width" => 100,
			"height" => 100
			),			
		    array(
			"width" => 180,
			"height" => 180
			),		
			array(
			"width" => 15,
			"height" => 15
			),	
		),
		"big_base" =>  1.5
	);	
	
	// 可以接受的图片类型
	static private $accept_type = array(IMAGETYPE_GIF => '.gif', IMAGETYPE_JPEG => '.jpg', IMAGETYPE_PNG => '.png', IMAGETYPE_BMP => '.bmp');
	
	/**
	 * 对上传的照片判断是否符合要求，并保存在指定目录
	 * 
	 * @param int $user_id 用户ID
	 * @access public
	 */
	static public function upLoad($user_id)
	{ 
		import("util.FileSystem");
		switch($_FILES['cut_imag']['error']) 
		{
			case 0:
				break;
		    case 1:       
		        return '<script type="text/javascript">alert("文件大小超出了服务器的限制大小");top.uploadAbort(); </script>';
		        break;    
		    case 2:
		        return '<script type="text/javascript">alert("要上传的文件大小超出浏览器限制 ");top.uploadAbort(); </script>';   
		        break;    
		   default:
		   	 	return '<script type="text/javascript">alert("对不起，图片上传失败，请重新再试");top.uploadAbort(); </script>';
		   	 	break;  
		}
		
		// 验证文件数据		
		if ($_FILES['cut_imag']['error'] == 0 && $_FILES['cut_imag']['size'] > 1024 * 1024 * 5)
		{
			return '<script type="text/javascript">alert("文件太大，请选择5M以下的文件"); top.uploadAbort();</script>';
		}
		
		$img_path = $_FILES['cut_imag']['tmp_name'];
		$filetype = false;
		if (file_exists($img_path))
		{
			$filetype = exif_imagetype($img_path);  
		}
		if ($filetype && self::$accept_type[$filetype])
		{
			$file_name = $user_id ^ 37529113 << 8 | $user_id; //根据$user_id得出唯一的文件名
			if (!is_dir(self::UPLOAD_DIR))
				FileSystem::makeDir(self::UPLOAD_DIR);
			$uploadfile = self::UPLOAD_DIR . '/' . $file_name  . self::$accept_type[$filetype];
		}
		else 
		{
			return '<script type="text/javascript">alert("不支持的图片类型，请重新选择"); top.uploadAbort();</script>';
		}

		// 移到到指定目录
		$result = move_uploaded_file($img_path, $uploadfile);

		if (!$result)
		{
			return '<script type="text/javascript">alert("上传失败，请重新选择图片"); top.uploadAbort();</script>';
		}		

		// 如果是gif图片，那么取其第一帧
		if ($filetype == IMAGETYPE_GIF)	
		{
			list($src_width, $src_height) = getimagesize($uploadfile);
			$oldImg = imagecreatefromgif($uploadfile);
			$newImg = imagecreatetruecolor($src_width, $src_height);
			$trans_colour = imagecolorallocate($newImg, 255, 255, 255);
			imagefill($newImg, 0, 0, $trans_colour);
			$result = imagecopyresampled($newImg, $oldImg, 0, 0, 0, 0, $src_width, $src_height, $src_width, $src_height);
			if ($result)
			{
				$uploadfile = substr($uploadfile, 0, strlen($uploadfile)-3) . 'jpg';
				imagejpeg($newImg, $uploadfile, 100);
			}				
			else 
			{
				return '<script type="text/javascript">alert("对不起，处理gif图片时出错，请重新选择图片"); top.uploadAbort();</script>';
			}
			imagedestroy($newImg);
			imagedestroy($oldImg);
		}		
		
		// 若是ie6则保存完后直接返回,不需要下面的过程
		if ($_POST["browsetype"] == 'ie6')
		{
			$str = <<<EOT
<script type="text/javascript">
top.sendCutRequest();
top.uploadAbort();
</script>
EOT;
			return $str;
		}
		
		// 回传图片上传结果和上传成功后图片的路径给主页的IFRAME
 
		$offset = array(
		"width" => 0,
		"height" => 0,
		"top" => 0,
		"left" => 0
		);
		
		// 设置返回的图片地址
		$url = $uploadfile . '?' . time();

		$arr_offset = getimagesize($uploadfile);
		if ($arr_offset[0] > $arr_offset[1])
		{
			$offset["width"] = self::$pic_cfg["out_frame"]["width"];
			$offset["height"] = intval(self::$pic_cfg["out_frame"]["width"] / $arr_offset[0] * $arr_offset[1] );
			$offset["top"] = (self::$pic_cfg["out_frame"]["height"] - $offset["height"]) / 2;
		}
		else
		{
			$offset["height"] = self::$pic_cfg["out_frame"]["height"];
			$offset["width"] = intval(self::$pic_cfg["out_frame"]["height"] / $arr_offset[1] * $arr_offset[0]);
			$offset["left"] = (self::$pic_cfg["out_frame"]["width"] - $offset["width"]) / 2;
		}
	    
		$offset["top"] = 0;
		$offset["left"] = 0;
		
		$width = self::$pic_cfg['select_size']['width'];
		$height = self::$pic_cfg['select_size']['height'];
		$big_base = self::$pic_cfg["big_base"];
		$str = <<<EOT
<script type="text/javascript">
top.show_hide();
top.init("{$url}", {$width}, {$height}, {$offset["width"]}, {$offset["height"]}, {$offset["top"]}, {$offset["left"]}, {$big_base});
top.uploadAbort();
</script>
EOT;
		return $str;
	}

	/**
	 * 把照片裁剪成四种规格
	 *
	 * @param int $UserId 用户ID
	 * @return unknown
	 */
	static public function cut($UserId)
	{
		// 取得原始图片的路径
		$src_path = $_GET['path'] ? $_GET['path'] : null;
		if (!$src_path)
			return(json_encode(array('result'=>false,"message"=>"对不起, 请刷新页面后重新上传图片")));
			
		preg_match("/(\.)([a-zA-Z]{3})(\?)*/i", $src_path, $matches);
		$suffix = strtolower($matches[2]);
		if (mb_strlen($suffix) > 3 || !in_array('.' . $suffix, self::$accept_type))
			return(json_encode(array('result'=>false,"message"=>"对不起, 请刷新页面后重新上传图片")));	
		$file_name = $UserId ^ 37529113 << 8 | $UserId; //根据$UserId得出唯一的文件名
		$src_path = self::TEMP_CUT_DIR . '/' . $file_name . '.' . $suffix;	
		
		$top = $_GET['top'] ? $_GET['top'] : null;
		$left = $_GET['left'] ? $_GET['left'] : null;
		$width = $_GET['width'] ? $_GET['width'] : null;
		$height = $_GET['height'] ? $_GET['height'] : null;
		$big_base = $_GET['big_base'] ? $_GET['big_base'] : null;

		if ( $src_path == null && $top == null && $left == null && $width == null && $height == null && $big_base == null )
		{
			return(json_encode(array('result'=>false,"message"=>"对不起, 请刷新页面后重新上传图片")));
		}

		if (!is_file($src_path))
			return(json_encode(array('result'=>false,"message"=>"对不起, 请刷新页面后重新上传图片")));
					
		$src_width = 0; //原始图片的宽度
		$src_height = 0;
		list($src_width, $src_height) = getimagesize($src_path);
	
		$src_left = $left * $src_width / $width;
		$src_top = $top * $src_height / $height;
		$src_width = self::$pic_cfg['big_base'] * self::$pic_cfg['select_size']['width'] * $src_width / $width;
		$src_height = self::$pic_cfg['big_base'] * self::$pic_cfg['select_size']['height'] * $src_height / $height;

		// 裁剪原始图片并保存
		for($i = 0; $i < 5; ++$i)
		{
			// head返回的是包含域名的绝对路径，用substr获得相对路径
			$newPath = self::TEMP_CUT_DIR . '/' . "$UserId".'_' . $i . ".jpg";

			switch ($suffix)
			{
				case 'jpg':
					$oldImg = imagecreatefromjpeg($src_path);
					break;
				case 'bmp':
					$oldImg =  PhotoImage::imagecreatefrombmp($src_path);
					break;		
				case 'png':
					$oldImg = imagecreatefrompng($src_path);
					break;
				case 'gif':
					$oldImg = imagecreatefromgif($src_path);
					break;														
			}
			if ($oldImg == false)
			{
				return(json_encode(array('result'=>false,"message"=>"对不起, 裁剪图片出错,请重试")));
			}
			
			// 获得一张透明图
			$newImg = imagecreatetruecolor(self::$pic_cfg['dst'][$i]['width'], self::$pic_cfg['dst'][$i]['height']);
			$trans_colour = imagecolorallocate($newImg, 255, 255, 255);
			imagefill($newImg, 0, 0, $trans_colour);
			$complete = imagecopyresampled($newImg, $oldImg, 0, 0, $src_left, $src_top, self::$pic_cfg['dst'][$i]['width'], self::$pic_cfg['dst'][$i]['height'], $src_width, $src_height);
			if ($complete)
			{
				imagejpeg($newImg, $newPath, 100);
				imagedestroy($newImg);
				imagedestroy($oldImg);				
			}
			else 
			{
				imagedestroy($newImg);
				imagedestroy($oldImg);				
				return(json_encode(array('result'=>false,"message"=>"对不起, 裁剪图片出错,请重试")));
			}
		}
		
		if (self::saveHead($UserId))
		{
			self::clearHead($UserId);
			return(json_encode(array('result'=>true,"message"=>"恭喜，保存成功")));
		}
		else 
		{
			self::clearHead($UserId);
			return(json_encode(array('result'=>false,"message"=>"对不起, 裁剪图片出错,请稍后再试")));
		}
	}
	
	/**
	 * 将裁剪好的头像从临时目录转移到正式目录
	 *
	 * @param int $userid 用户ID
	 * @param boolean $flag false时表示保存图片并删除临时目录中图片，true时表示删除临时目录中的图片并不保存
	 * @return string 操作正常返回succ,否则error
	 */
	static public function saveHead($user_id)
	{				
		import("util.FileSystem");
		
		// 移动图片
		for ($i = 0; $i < 5; $i++)
		{
			$src_file = self::TEMP_CUT_DIR . '/' . "$user_id" . '_' . $i . ".jpg";
			if(!file_exists($src_file))
				return false;
			$dest_dir = self::CUT_DIR . headCut($user_id);
			if (!is_dir($dest_dir))
				FileSystem::makeDir($dest_dir);
			$dest_file = $dest_dir . '/' . "$user_id" . '_' . $i . ".jpg";
			if (!copy($src_file, $dest_file))
				return false;
		}
		return true;
	}
	
	/**
	 * 删除用户上传的图片和裁剪留下的临时文件
	 *
	 * @param int $userid 用户ID
	 * @return boolean 操作正常返回true,否则false
	 */
	static public function clearHead($user_id)
	{
		// 移动裁剪留下的临时文件
		for ($i = 0; $i < 5; $i++)
		{
			$src_file = self::TEMP_CUT_DIR . '/' . "$user_id" . '_' . $i . ".jpg";
			if (file_exists($src_file))
				unlink($src_file);
		}		
		
		// 删除临时目录中的原始图片
		$file_name = $user_id ^ 37529113 << 8 | $user_id; //根据$user_id得出唯一的文件名
		// 若临时目录中还有别的格式图片也一起删除
		foreach (self::$accept_type as $v)
		{
			if (file_exists(self::UPLOAD_DIR . '/' . $file_name  . $v))
				unlink(self::UPLOAD_DIR . '/' . $file_name  . $v);			
		}
		return true;		
	}
}