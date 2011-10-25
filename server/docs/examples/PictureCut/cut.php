<?php
require_once("pic_cfg.php");

$src_path = $_GET['path'] ? $_GET['path'] : null;
$top = $_GET['top'] ? $_GET['top'] : null;
$left = $_GET['left'] ? $_GET['left'] : null;
$width = $_GET['width'] ? $_GET['width'] : null;
$height = $_GET['height'] ? $_GET['height'] : null;
$big_base = $_GET['big_base'] ? $_GET['big_base'] : null;
if ( $src_path == null && $top == null && $left == null && $width == null && $height == null && $big_base == null )
{
	$response['result'] = "error";
}

$response = array(); //记录结果
$src_width = 0; //原始图片的宽度
$src_height = 0;
if (is_file($src_path))
{
	$arr_offset = getimagesize( $src_path );
	$src_width = $arr_offset[0];
	$src_height = $arr_offset[1];
}
else
{
	$response['result'] = "error";
}
$src_left = $left * $src_width / $width;
$src_top = $top * $src_height / $height;
$src_width = $pic_cfg['big_base'] * $pic_cfg['select_size']['width'] * $src_width / $width;
$src_height = $pic_cfg['big_base'] * $pic_cfg['select_size']['height'] * $src_height / $height;

//裁剪原始图片并保存
$rnds = mt_rand(1000, 9999);
$newPath='./test/T_' . $rnds . '.jpg';
$newImg = imagecreatetruecolor($pic_cfg['dst']['width'], $pic_cfg['dst']['height']);
$data = file_get_contents($src_path);
$oldImg = imagecreatefromstring($data);
$complete = imagecopyresampled($newImg, $oldImg, 0, 0, $src_left, $src_top, $pic_cfg['dst']['width'], $pic_cfg['dst']['height'], $src_width, $src_height);
if ($complete){
     imagejpeg($newImg, $newPath, 100); 
     $response['result'] = "success";
     $response['path'] = $newPath;
}

imagedestroy($newImg);
imagedestroy($oldImg);

echo  'response = {result : "' . $response["result"] .'", path : "' . $response['path'] . '"}';
?>