<?php
header("Content-Type: text/html; charset=utf-8");
require_once("pic_cfg.php");

$result = $_POST["result"] ? $_POST["result"] : null;
if ($result != null)
{
	if ($result)
	{
		$offset = array(
			"width" => 0,
			"height" => 0,
			"top" => 0,
			"left" => 0
		);
		$url = $_POST["pic_src"];
		$arr_offset = getimagesize($url);
		if ($arr_offset[0] > $arr_offset[1] )
		{
			$offset["width"] = $pic_cfg["out_frame"]["width"];
			$offset["height"] = intval($pic_cfg["out_frame"]["width"] / $arr_offset[0] * $arr_offset[1] );
			$offset["top"] = ($pic_cfg["out_frame"]["height"] - $offset["height"]) / 2;  
		}
		else 
		{
			$offset["height"] = $pic_cfg["out_frame"]["height"];
			$offset["width"] = intval($pic_cfg["out_frame"]["height"] / $arr_offset[1] * $arr_offset[0]);
			$offset["left"] = ($pic_cfg["out_frame"]["width"] - $offset["width"]) / 2;  
		}
		
$str = <<<EOT
<script type="text/javascript">
top.init("{$url}", {$pic_cfg['select_size']['width']}, {$pic_cfg['select_size']['height']}, {$offset["width"]}, {$offset["height"]}, {$offset["top"]}, {$offset["left"]}, {$pic_cfg["big_base"]});
</script>
EOT;
		echo $str;
	}
	else
	{
		echo "error";
	}
}

?>