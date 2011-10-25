<?php
/**
 * 转换数组中所有元素的字符集
 * @package lib
 * @author 张立冰(roast) <roast@php.net>
 * 
 * $Id: base.inc.php 98 2009-05-06 01:53:29Z libing $
 */

/**
 * 导入文件
 * @param string $classString 导入文件路径字符串,可以用"."代替"/"
 * @param string $fileType 导入文件类型的扩展名(带"."号),也可以是class/inc(简写方式)
 * 
 * @example 
 * 		import('interface.Account') => include_once('interface/Account.class.php');
 */
function import($classString, $fileType = 'class') 
{
	global $cfg;
	$filename = $cfg['path']['lib'] . strtr($classString, '.', '/');
	switch ($fileType) {
		//导入类文件 
		case 'class': $filename .= '.class.php'; break;
		//导入包含文件
		case 'inc': $filename .= '.inc.php'; break;
		//自定义导入文件的扩展名
		default: $filename .= $fileType; break;
	}
	if (is_file($filename)) {
		include_once($filename);
	} else {
		exit('file "' . $filename . '" is not found.');
	}
}

//导入Application应用程序处理类
import('core.Action');
import('core.Application');

if (get_magic_quotes_gpc()) {
	stripslashesForArray($_COOKIE);
	stripslashesForArray($_POST);
	stripslashesForArray($_GET);
	stripslashesForArray($_REQUEST);
	stripslashesForArray($HTTP_GET_VARS);
	stripslashesForArray($HTTP_POST_VARS);
	stripslashesForArray($HTTP_COOKIE_VARS);
}


/**
 * 为数组中的每个元素取消魔术引用
 * @param mixed $var 要取消魔术引用的变量,可以是数组或字符串
 */
function stripslashesForArray(& $var) 
{
    //$var = is_array($var) ? array_map('stripslashesForArray', $var) : stripslashes($var); --php bug??

    // return $value;
    
	if (is_array($var)) {
		foreach ($var as $key => $val) {
		    if (is_array($val))
                stripslashesForArray($val);
		    else 
                $var[$key] = stripslashes($val);
		}
	} else {
		$var = stripslashes($var);
	}
}


/**
 * 导入模块文件
 * @param string $classString 导入文件路径字符串,可以用"."代替"/"
 * @param string $fileType 导入文件类型的扩展名(带"."号),也可以是class/inc(简写方式)
 * @return Exception 如果导入成功则返回true，否则返回异常对象
 * 
 * @example 
 * 		importModule('gapi.Account') => include_once('modules/Account.class.php');
 */
function importModule($classString, $fileType = 'class') 
{
	global $cfg;
	$filename = $cfg['path']['module'] . strtr($classString, '.', '/');
	switch ($fileType) {
		//导入类文件 
		case 'class': $filename .= '.class.php'; break;
		//导入包含文件
		case 'inc': $filename .= '.inc.php'; break;
		//自定义导入文件的扩展名
		default: $filename .= $fileType; break;
	}
	if (is_file($filename)) {
		include_once($filename);
	} else {
		exit('file "' . $filename . '" is not found.');
	}	
}


/**
 * Debug 函数,可以包含多个参数,逐个输出变量的值
 * 注: 输出中debug_0代表第一个参数,debug_1代表第二个参数,以此类推.
 */
function debug() 
{
	extract(func_get_args(), EXTR_PREFIX_ALL, 'debug');
	trigger_error('Debug');
}


/**
 * 抛出异常处理
 *
 * @param string $msg
 * @param string $code
 */
function throwException($msg, $code) {
	trigger_error($msg . '(' . $code . ')');
}


/**
 * 转换数组中所有元素的字符集
 * @param array $array 源数组
 * @param string $to 目标字符集
 * @param string $from 源字符集
 */
function arrayCharsetConvert(& $array, $to, $from = 'GBK') {
	if (is_array($array)) {
		foreach ($array as $key => $item) {
			if (is_array($item)) {
				arrayCharsetConvert($array[$key], $to, $from);
			} else {
				$array[$key] = iconv($from, $to, $item);
			}
		}
	}
}


/**
 * 提供给游戏API返回的XML格式数据转换为数组格式
 *
 * @param array $list
 * @param int $count
 * @return array
 */
function apiXmlToArray($list, $count=0) {
	$result = array();
	if (isset($list['Context'])) {
		$result = apiXmlToArray($list['Context']);
	} elseif (isset($list['Resource'])) {
		$count = intval($list['Resource attr']['length']);
		$result = apiXmlToArray($list['Resource'], $count);
	} elseif (isset($list['Parameters'])) {
		for ($i=0; $i<$count; $i++) {
			$name = $list['Parameters'][$i . ' attr']['name'];
			$n = intval($list['Parameters'][$i . ' attr']['length']);
			($n==0) && $n = 1;
			if (empty($name)) {
				if ($count == 1) {
					$result = apiXmlToArray($list['Parameters'], $n);
				} elseif (empty($result)) {
					$result = apiXmlToArray($list['Parameters'][$i], $n);
				} else {
					$result = array_merge($result,
							apiXmlToArray($list['Parameters'][$i], $n));
				}
			} else {
				if ($count == 1) {
					$result[$name] = apiXmlToArray($list['Parameters'], $n);
				} else {
					$result[$name] = apiXmlToArray($list['Parameters'][$i], $n);
				}
			}
		}
	} elseif (isset($list['Data'])) {
		for ($i=0; $i<$count; $i++) {
			$name = $list['Data'][$i . ' attr']['name'];
			$n = intval($list['Data'][$i . ' attr']['length']);
			$data = ($count == 1) ? $list['Data'] : $list['Data'][$i];
			if ($n==0) {
				$n = (isset($data['Parameters'][1])) ? count($data['Parameters']) : 1;
			}
			if (empty($name)) {
				if ($count == 1) {
					$result = apiXmlToArray($data, $n);
				} else {
					$result[] = apiXmlToArray($data, $n);
				}
			} else {
				$result[$name] = apiXmlToArray($data, $n);
			}
		}
	} elseif (isset($list['parameter'])) {
		$result[$list['parameter']] = trim($list['result']);
	}
	return $result;
}

/**
 * 根据用户的UserId来散列获取分表名称
 * 
 * @param integer $user_id 用户表中的UserId
 * @return boolean
 */
function table($user_id)
{
    return sprintf('%02x', intval($user_id) % 256);
}

/**
 * 对Smarty中的html标记添加引号的过滤
 *
 * @param String $str
 * @return String
 */
function _htmlspecialchars($str)
{
    return htmlspecialchars($str, ENT_QUOTES);
}


/**
 * 根据用户的UserId来散列获取头像的绝对路径
 *
 * @author 陈敬钻 <chenjingzuan@corp.the9.com>
 * 
 * @param string $userid_s  userid后跟s， 其中s 表示图片的规格， 0表示60×60，1表示80×80，2表示100×100,3表示180×180,4表示15×15
 * @return string 头像的绝对路径
 */
function head($userid_s)
{
	global $cfg;
	
	list($user_id, $s) = explode('_', $userid_s);
 
	$s = $s=='' ? -1 : intval($s);
	$s = ($s < 0 || $s > 4 ) ? 1 : $s;
	
	// 一级目录
	$t1 = sprintf("%02x", intval($user_id) % 256);
	
	// 二级目录
	$t2 = sprintf("%02x", (intval($user_id) / 256) % 256);
	
	// 表示存放在哪台机子
	$t3 = intval($user_id) % 2;
	
	return $cfg['url']['avatar'][$t3] . "$t1/$t2/$user_id" . "_" . "$s.jpg";
}

/**
 * 该函数仅用于返回裁剪头像时的保存目录
 *
 * @param int $userid
 * @return string 头像在本地存放路径
 */
function headCut($user_id)
{
	// 一级目录
	$t1 = sprintf("%02x", intval($user_id) % 256);
	
	// 二级目录
	$t2 = sprintf("%02x", (intval($user_id) / 256) % 256);

	// 表示存放在哪台机子
	$t3 = intval($user_id) % 2;
	
	return "/avatar$t3/$t1/$t2";
}

/**
 * 取图片的绝对路径
 *
 * @param integer $pid		图片的ID
 * @param integer $type		图片类型,0缩略图,1大图
 * @param integer $server	防止block服务器数,默认两台.
 * @return string			图片绝对路径
 */
function photo($pid, $type = 0, $server = 2)
{		
	$server_id = $pid % $server + 1;
	$small = $type == 0 ? 's' : null;
	$hash1 = sprintf("%02x", $pid % 256);
	$hash2 = sprintf("%02x", $pid / 256 % 256);
	return "http://p{$server_id}.play9.the9.com/{$hash1}/{$hash2}/{$pid}{$small}.jpg";
}
?>