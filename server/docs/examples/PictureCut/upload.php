<?php
header("Content-Type: text/html; charset=utf-8");
$uploaddir = "./test/"; //上传成功之后图片保存的位置
$uploadfile = $uploaddir.basename($_FILES['cut_imag']['name']);

//上传图片的限制条件（暂无）

if (move_uploaded_file($_FILES['cut_imag']['tmp_name'], $uploadfile))
{
   $result = true;
} 
else {
   $result = false;
}

//回传图片上传结果和上传成功后图片的路径给主页的IFRAME
$ch = curl_init();
curl_setopt($ch, CURLOPT_URL, "http://localhost/au2/trunk/docs/examples/picture_cut/up_result.php");
$fields = "result=$result&pic_src=$uploadfile";
curl_setopt($ch, CURLOPT_POST, 1); 
curl_setopt($ch, CURLOPT_POSTFIELDS, $fields);
curl_setopt($ch, CURLOPT_TIMEOUT, 15);
curl_exec($ch);
curl_close($ch);
?>