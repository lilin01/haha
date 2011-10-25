<?php

/**
 * 返回 XML 的Page类
 *
 * @package lib
 * @subpackage core.page
 * @author 张立冰 <roast@php.net>
 */
class PageXml extends APageFactory {
	/**
	 * 值
	 * @var array $value
	 * @access private
	 */
	var $value = array();
	
	/**
	 * 构造函数(兼容PHP4)
	 * @param Application $app
	 */
	function PageExtjsResponse(& $app) {
		$this->__construct(& $app);
	}
	
	/**
	 * 构造函数
	 * @param Application $app
	 */
	function __construct(& $app) {
		parent::__construct(& $app);
		
	}
	
	/**
	 * 给变量赋值
	 * @param string $name 变量名,当$value有值是该参数无效,一般都设置"reponse"以便于阅读
	 * @param mixed $value 变量值,如果该参数未指定,则返回变量值,否则设置变量值
	 * @return APage 如果参数为NULL则返回Page对象本身,否则返回变量值
	 */
	function value($name, $value = NULL) {
		if ($value === NULL && !is_array($name)) { //取值
			return $this->value;
		} else { //赋值
			$this->value = $value;
			return $this;
		}
	}
	
	/**
	 * 页面内容输出
	 * @param boolean $fetch 是否提取输出结果
	 */
	function output($fetch=false) {
		header("Content-Type: text/xml;charset=" . $this->app->cfg['page']['charset']);
		ob_start();
		echo $this->serializeXml($this->value);
		$content = ob_get_contents();
		if ($fetch) {
			ob_end_clean();
		} else {
			ob_end_flush();
		}
		return $content;
	}
	
	/**
	 * 序列化输出XML字符串
	 * @param array $data 输出数据
	 * @param int $level 级数
	 * @param string $priorKey 前一级的键名
	 * @return string
	 */
	function & serializeXml(&$data, $level = 0, $priorKey = NULL) {
		$serializedXmlString = '';
		foreach ($data as $key => $value) {
			$inline = false;
			$numericArray = false;
			$attributes = '';
			if (!strstr($key, ' attr') && $value!==NULL) { // 如果不是一个属性
				if (array_key_exists("{$key} attr", $data)) {
					foreach ($data["{$key} attr"] as $attrName => $attrValue) {
						$attrValue = &htmlspecialchars($attrValue, ENT_QUOTES);
						$attributes .= " {$attrName}=\"{$attrValue}\"";
					}
				}
	
				if (is_numeric($key)) {
					$key = $priorKey;
				} else {
					if (is_array($value) and array_key_exists(0, $value)) {
						$numericArray = true;
						$serializedXmlString .= $this->serializeXml($value, $level, $key);
					}
				}
	
				if (!$numericArray) {
					$serializedXmlString .= str_repeat("\t", $level) . "<{$key}{$attributes}>";
					if (is_array($value)) {
						$inner = $this->serializeXml($value, $level+1);
						($inner) && $serializedXmlString .= "\r\n" . $inner;
					} else {
						$inline = true;
						$serializedXmlString .= htmlspecialchars($value, ENT_QUOTES);
					}
					$serializedXmlString .= ((!$inline) ? str_repeat("\t", $level) 
														: '') . "</{$key}>\r\n";
				}
			}
		}
		if ($level == 0) {
			$serializedXmlString = '<?xml version="1.0" encoding="' 
					. $this->app->cfg['page']['charset'] .'"?>' . "\r\n"
					. $serializedXmlString;
		}
		return $serializedXmlString;
	}
}
?>