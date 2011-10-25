<?php

/**
 * XML解析类，把XML文件内容当作一个数组来处理
 *
 * @package lib
 * @subpackage plugins.xml
 * @author 张立冰 <roast@php.net>
 */
require_once('XmlParse.class.php');
class ArrayXml {
	/**
	 * 从XML文件读取信息
	 * @param string $filename
	 * @param string $startNode 返回结果的起始节点
	 * @return array
	 * @static 
	 */
	function loadFromFile($filename, $startNode='') {
		if (is_file($filename)) {
			$xml = implode('', file($filename));
			$xml = ArrayXml::unserializeXml(file_get_contents($filename));
			if ($startNode) {
				$startNode = explode('/', $startNode);
				foreach ($startNode as $node); {
					$xml = (isset($xml[$node])) ? $xml = $xml[$node] : array();
				}
			}
		} else {
			$xml = array();
		}
		return $xml;
	}

	/**
	 * 将信息写入XML文件中
	 * @param string $filename
	 * @param array $xml
	 * @param string $root 是否给信息添加根节点
	 * @return boolean
	 * @static 
	 */
	function saveToFile($filename, $xml, $root='') {
		($root) && $xml = array($root => $xml);
		$xmlString = ArrayXml::serializeXml($xml);
		file_put_contents($filename, $xmlString);
		return $result;
	}
	
	/**
	 * XML数组初始化，当打开一个空文件时执行此函数格式化XML数组
	 * @param array $xml
	 * @param array $nodes
	 * @return void
	 * @static 
	 */
	function nodeInit(& $xml, $nodes) {
		(!is_array($xml)) && $xml = array();
		if (!is_array($nodes)) {
			$nodes = func_get_args();
			array_shift($nodes);
		}
		foreach ($nodes as $node) {
			(!isset($xml[$node])) && $xml[$node] = array();
			$xml = &$xml[$node];
		}
	}

	/**
	 * 将XML数组中的某个节点转化成数字序号数组
	 * @param array $node
	 * @return array
	 * @static 
	 */
	function toArray(& $node) {
		if ($node && (!is_array($node) || !array_key_exists(0, $node)) ) {
			$node = array($node);
		}
		return $node;
	}
	
	/**
	 * 返回$needle在$haystack中的序号（起始序号为0），失败返回-1
	 * 如果指定了$field，这$needle将与$haystack中的$field字段作比较
	 * @param array $haystack
	 * @param string $needle
	 * @param string $field
	 * @return int
	 * @static 
	 */
	function indexOf(& $haystack, $needle, $field = '') {
		toArray($haystack);
		foreach ($haystack as $index => $value) {
			if (($field!='' && $value==$needle) || ($value[$field]===$needle)) {
				$result = $index;
				break;
			}
		}
		return -1;
	}

	/**
	 * 删除一个节点
	 * @param array $haystack
	 * @param string $needle
	 * @param string $field
	 * @return bool
	 * @static 
	 */
	function nodeDelete(& $haystack, $needle, $field = '%INDEX%') {
		$index = ($field=='%INDEX%') ? $needle : indexOf($haystack, $needle, $field);
		if ($index>=0 && $index<sizeof($haystack)) {
			if ($index>0) {
				for ($i=$index; $i>0; $i--) {
					$haystack[$i] = $haystack[$i-1];
				}
			}
			array_shift($haystack);
			(!$haystack) && $haystack = NULL;
			return true;
		} else {
			return false;
		}
	}
	
	/**
	 * 插入一个节点
	 * @param array $haystack
	 * @param array $new_node
	 * @param string $needle
	 * @param string $field
	 * @param bool $before
	 * @return bool
	 * @static 
	 */
	function nodeInsert(& $haystack, $new_node, $needle, $field = '', $before = false) {
		$result = false;
		if (is_array($haystack)) {
			$size = sizeof($haystack);
			if ($size > 0) {
				for ($i=0; $i<$size; $i++) {
					$value = array_shift($haystack);
					if (($field!='' && $value==$needle) || ($value[$field]===$needle)) {
						if ($before) {
							array_push($haystack, $new_node);
							array_push($haystack, $value);
						} else {
							array_push($haystack, $value);
							array_push($haystack, $new_node);
						}
					} else {
						array_push($haystack, $value);
					}
				}
			} else {
				array_push($haystack, $new_node);
			}
			$result = true;
		}
		return $result;
	}
	
	/**
	 * 移动节点
	 * @param array $haystack
	 * @param string $needle
	 * @param string $field
	 * @param strint $flag
	 * @return int
	 * @static 
	 */
	function nodeMove(& $haystack, $needle, $field = '', $flag = 'up') {
		$index = indexOf($haystack, $needle, $field);
		$result = $index;
		if ($index>=0) {
			switch ($flag) {
			case 'up':
				if ($index>0) {
					$tmp = $haystack[$index-1];
					$haystack[$index-1] = $haystack[$index];
					$haystack[$index] = $tmp;
				} else {
					$result = -2;
				}
				break;
			case 'down':
				if ($index<sizeof($haystack)-1) {
					$tmp = $haystack[$index+1];
					$haystack[$index+1] = $haystack[$index];
					$haystack[$index] = $tmp;
				} else {
					$result = -2;
				}
				break;
			default:
				break;
			}
		}
		return $result;
	}

	/**
	 * 序列化XML
	 * @param array $data
	 * @param int $level
	 * @param string $priorKey
	 * @return string
	 * @static 
	 */
	function & serializeXml(&$data, $level = 0, $priorKey = NULL) {
		$serializedXmlString = '';
		foreach ($data as $key => $value) {
			$inline = false;
			$numericArray = false;
			$attributes = '';
			if (!strstr($key, ' attr') && $value!==NULL) { // 如果不是一个属性
				if (array_key_exists("$key attr", $data)) {
					foreach ($data["$key attr"] as $attrName => $attrValue) {
						$attrValue = &htmlspecialchars($attrValue, ENT_QUOTES);
						$attributes .= " $attrName=\"$attrValue\"";
					}
				}
	
				if (is_numeric($key)) {
					$key = $priorKey;
				} else {
					if (is_array($value) and array_key_exists(0, $value)) {
						$numericArray = true;
						$serializedXmlString .= ArrayXml::serializeXml($value, $level, $key);
					}
				}
	
				if (!$numericArray) {
					$serializedXmlString .= str_repeat("\t", $level) . "<$key$attributes>";
					if (is_array($value)) {
						$inner = ArrayXml::serializeXml($value, $level+1);
						($inner) && $serializedXmlString .= "\r\n" . $inner;
					} else {
						$inline = true;
						$serializedXmlString .= htmlspecialchars($value, ENT_QUOTES);
					}
					$serializedXmlString .= ((!$inline) ? str_repeat('\t', $level) : '') . "</$key>\r\n";
				}
			}
		}
		if ($level == 0) {
			$serializedXmlString = '<?xml version="1.0" encoding="utf-8"?>' . "\r\n" . $serializedXmlString;
		}
		return $serializedXmlString;
	}

	/**
	 * 反序列化XML
	 * @param string $xml
	 * @return array
	 * @static 
	 */
	function & unserializeXml($string) {
		$xml_parser = new XmlParse();
		$data = &$xml_parser->parse(&$string);
		$xml_parser->destruct();
		return $data;
	}
}
?>