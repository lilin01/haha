<?php

/**
 * 驼峰字符串编码/解码类
 *
 * @package lib
 * @subpackage util
 * @author 张立冰 <roast@php.net>
 */
class CamelString {
	/**
	 * 驼峰字符串编码
	 * @param string $s 源字符串
	 * @param string $first 第一个字符是否大写
	 * @return string
	 */
	function encode($s, $first=false) {
		$len = strlen($s);
		$result = '';
		for ($i=0; $i<$len-1; $i++) {
			$result .= ($s[$i]=='_') ? strtoupper($s[++$i]) : $s[$i];
		}
		$result .= $s[$len-1];
		return $first ? ucfirst($result) : $result;
	}

	/**
	 * 驼峰字符串解码
	 * @param string $s 源字符串
	 * @param string $first 是否处理第一个字符
	 * @return string
	 */
	function decode($s, $first=false) {
		$len = strlen($s);
		$result = '';
		for ($i=0; $i<$len; $i++) {
			$code = ord($s[$i]);
			$result .= ($code>=65 && $code<=90) ? (($i==0 && !$first) ? '' : '_') . chr($code+32) : $s[$i];
		}
		return $result;
	}
}
?>