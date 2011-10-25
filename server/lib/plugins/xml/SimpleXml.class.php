<?php 

/**
 * XML解析类
 *
 * @package lib
 * @subpackage plugins.xml
 * @author 张立冰 <roast@php.net>
 */
class SimpleXml {
	/**
	 * @var string $charset 字符集
	 */
	public $charset = 'utf-8';

	/**
	 * 从文件中读取XML信息
	 * @param string $filename
	 * @return SimpleXml
	 */
	public function loadFromFile($filename) {
		return simplexml_load_file($filename);
	}
	
	/**
	 * 从字符串中解析XML信息
	 * @param string $filename
	 * @return array
	 */
	public function loadFromString($string) {
		return simplexml_load_string($string);
	}
}
?>