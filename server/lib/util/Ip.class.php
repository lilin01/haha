<?php

/**
 *  IP 类
 *
 * @package lib
 * @subpackage util
 * @author 张立冰 <roast@php.net>
 */
class Ip {
	
	/**
	 * 获取客户端IP
	 * @return string
	 * @static 
	 */
	function get() {
		if ($_SERVER['HTTP_CLIENT_IP'] && $_SERVER['HTTP_CLIENT_IP']!='unknown') {
			$ip = $_SERVER['HTTP_CLIENT_IP'];
		} elseif ($_SERVER['HTTP_X_FORWARDED_FOR'] && $_SERVER['HTTP_X_FORWARDED_FOR']!='unknown') {
			$ip = $_SERVER['HTTP_X_FORWARDED_FOR'];
		} else {
			$ip = $_SERVER['REMOTE_ADDR'];
		}
		return $ip;
	}
	
	/**
	 * 判断$ip是否在指定IP范围内
	 * @param string $ip
	 * @param string $startIp
	 * @param string $endIp
	 * @return boolean
	 * @static 
	 */
	function isIn($ip, $startIp, $endIp) {
		$ip = ip2long($ip);
		return ($ip>=ip2long($startIp) && $ip<=ip2long($endIp));
	}
}
?>