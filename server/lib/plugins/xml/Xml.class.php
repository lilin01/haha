<?php

/**
 *  xml 类
 *
 * @package lib
 * @subpackage plugins.xml
 * @author 张立冰
 */
 class Xml extends DOMDocument {
	/**
	 * @var string $fileName xml文件名
	 * @access private
	 */
	private $fileName = '';
	/**
	 * @var bool　$isSax 是否存储成SimpleXMLElement对象
	 * @access private
	 */
	private $isSax = false;
	/**
	 * @var SimpleXMLElement　$saxData　SimpleXMLElement对象
	 * @access private
	 */
	public $saxData = NULL;
	/**
	 * @var DOMXPath　$XPath　DOMXPath对象
	 * @access private
	 */
	private $XPath = NULL;
	
	public $i = 0;
	/**
	 * 构造函数
	 * @param string $fileName xml文件名
	 * @param bool $isSax 是否存储成SimpleXMLElement对象
	 */
	public function __construct ($fileName = '', $isSax = true, $version = '1.0' ,$encoding = 'utf-8') {
		parent::__construct($version, $encoding);
		$this->fileName = $fileName;
		$this->isSax = $isSax;
		($this->fileName) && $this->loadFromFile();
	}
	
	/**
	 * 加载xml文件
	 * @access public
	 */
	public function loadFromFile() {
		if (is_file($this->fileName)) {
			$this->preserveWhiteSpace = false;
			$this->load($this->fileName);
		}
		($this->isSax) && $this->domToSax();
	}
	
	/**
	 * 加载xml字符串
	 * @access public
	 */
	public function loadFromString($string) {
		$this->preserveWhiteSpace = false;
		$this->loadXML($string);
		if ($this->isSax) {
			$this->domToSax();
		}
	}
	/**
	 * 将dom对象转换成SimpleXMLElement对象
	 * @access public
	 */
	public function domToSax() {
		$this->saxData = simplexml_import_dom($this);
	}
	
	/**
	 * 把SimpleXMLElement对象转换成DOMElement对象
	 * @access public
	 */
	public function saxToDom () {
		($this->saxData) && $this->dom = dom_import_simplexml($this->saxData);
	}
	
	/**
	 * 插入节点
	 * @param DOMNode $node XML节点
	 * @param DOMNode $newNode 新建XML节点
	 * @param DOMNode $oldNode XML节点 如果指定此参数新节点插入在此节点之前
	 * @return void
	 */
	public function insertNode(&$node, $newNode,$srcNode = NULL) {
		if ($srcNode==NULL) {
			$node->appendChild($newNode);
		} else {
			$node->insertBefore($newNode,$srcNode);
		}
	}
	/**
	 * 向上移动节点
	 * @param DOMNode $moveNode 要移动的XML节点
	 * @return void
	 */
	public function moveUp(&$moveNode) {
		return $this->moveNodeUpOrDown($moveNode, 'up');
	}
	
	/**
	 * 向下移动节点
	 * @param DOMNode $moveNode 要移动的XML节点
	 * @return void
	 */
	public function moveDown(&$moveNode) {
		return $this->moveNodeUpOrDown($moveNode, 'down');
	}
	
	/**
	 * 上下移动节点
	 * @param DOMNode $moveNode 要移动的XML节点
	 * @param string $direction 移动的方向
	 * @return void
	 */
	private function moveNodeUpOrDown(&$moveNode, $direction = 'down') {
		$index = -1;
		$node = & $moveNode->parentNode;
		for ($i=0; $i<$node->childNodes->length; $i++) {
			$child = $node->childNodes->item($i);
			if ($child->isSameNode($moveNode)) {
				$index= $i;
				break;
			}
		}
		if ($index==-1) {
			return 0;
		}
		if ($direction=='down') {
			if ($index==$node->childNodes->length-1) {
				return 0;
			}
			$node->removeChild($moveNode);
			if ($index==($node->childNodes->length-1)){
				$node->appendChild($moveNode);
			} else {
				$node->insertBefore($moveNode,$node->childNodes->item($index+1));
			}
		} else {
			if ($index==0) {
				return 0;
			}
		
			$node->removeChild($moveNode);
			$node->insertBefore($moveNode,$node->childNodes->item($index-1));
		}
		return 1;
	}
	
	/**
	 * 移动节点
	 * @param DOMNode $srcNode 要移动的XML节点
	 * @param DOMNode $destNode 移动到的目标节点
	 * @param string $position 位置参数 before after NULL
	 * @return bool
	 */
	public function moveNode(&$srcNode, &$destNode, $position = NULL) {
		$node = &$srcNode->parentNode;
		$node->removeChild($srcNode);
		if ($position) {
			if ($position=='before') {
				$destNode->parentNode->insertBefore($srcNode, $destNode);
			} else {
				$index = -1;
				$parentNode = &$destNode->parentNode;
				for ($i=0; $i<$parentNode->childNodes->length; $i++) {
					$child = $parentNode->childNodes->item($i);
					if ($child->isSameNode($destNode)) {
						$index= $i;
						break;
					}
				}
				$parentNode->insertBefore($srcNode, $parentNode->childNodes->item($index+1));
			}
		} else {
			$destNode->appendChild($srcNode);
		}
	}
	/**
	 * 删除节点
	 * @param DOMNode $node XML节点
	 * @param DOMNode $oldNode 要删除的XML节点
	 * @return void
	 */
	public function removeNode(&$oldNode) {
		$node = &$oldNode->parentNode;
		$node->removeChild($oldNode);
	}
	/**
	 * xPath方法
	 * @param string 查询表达式
	 * @return DOMNodeList
	 */
	public function XPath($query) {
		(!is_object($this->XPath)) && $this->XPath = new domXPath($this);
		return $this->XPath->query($query);
	}
	/**
	 * 创建新的节点
	 * @param string $tagName 标签名
	 * @param mixed $value 值
	 * @param array $attr 要删除的XML节点
	 * @return DOMNode
	 */
	public function newNode($tagName,$value,$attr=NULL) {
		if (is_array($value)) {
			$node = $this->createElement($tagName);
			foreach ($value as $key => $value) {
				$node->appendChild($this->createElement($key,$value));
			}
		} else {
			$node = $this->createElement($tagName,$value);
		}
		if ($attr && is_array($attr)) {
			foreach ($attr as $key => $value) {
				$node->setAttribute($key,$value);
			}
		}
		return $node;
	}
	
	/**
	 * 将一个数组创建为DOMNode对象
	 * @param array $array 标签名
	 * @return DOMNode
	 */
	public function newNodeFormArray($array) {
		if (is_array($array)) {
			foreach ($array as $key => $value) {
				if (substr($key,-5)==' attr') {
					continue;
				}
				if (!is_array($value)) {
					$node = $this->createElement($key,$value);
				} else {
					$node = $this->createElement($key);
					foreach ($value as $key_1 => $value_1) {
						if(is_array($value_1) && array_key_exists(0,$value_1)) {
							foreach ($value_1 as $key_2 => $value_2) {
								if (substr($key_2,-5)!=' attr') {
									$newNode = $this->newNodeFormArray(array($key_1 => $value_2,$key_1 .' attr' => $value_1[$key_2 .' attr']));
									$node->appendChild($newNode);
				
								}
								
							}
						} else {
							$node->appendChild($this->newNodeFormArray(array($key_1 => $value_1,$key_1 .' attr' => $value[$key_1 .' attr'])));
						}
					}
				}
				if (is_array($array[$key .' attr'])) {
					foreach ($array[$key .' attr'] as $attrKey => $attrValue) {
						$node->setAttribute($attrKey,$attrValue);
					}
				}
				break;
			}
		}
		return $node;
		
	}
	
	/**
	 * 将xml转换成数组
	 * @param DOMNode $node 标签名
	 * @return array
	 */
	public function toArray($node = NULL) {
		if ($node===NULL) {
			$node = $this->saxData;
		}
		$array = $this->simplexml2array($node);
		//print_r($array);
		return array($this->firstChild->tagName => $array);
	}
	
	/**
	 * 将simplexml转换成数组
	 * @param SimpleXMLElement $xml SimpleXMLElement对象
	 * @return array
	 */
	private function simplexml2array($xml) {
		if (get_class($xml)=='SimpleXMLElement') {
			$attributes = $xml->attributes();
			foreach($attributes as $k=>$v) {
				if ($v) {
			   		$a[$k] = (string) $v;
				}
			}
			$x = $xml;
			$xml = get_object_vars($xml);
	   }
	   if (is_array($xml)) {
			if (count($xml) == 0) {
		   		return (string) $x;
			}
			foreach($xml as $key=>$value) {
				if ($key!=='@attributes') {
					$r[$key] = $this->simplexml2array($value);
					if ( !is_array( $r[$key] ) ) {
						$r[$key] = $r[$key];
					}
				}
		   }
		   if (isset($a)) {
				$r['@attr'] = $a;
			}
			return $r;
	   }
	   return (string) $xml;
	}
	
	/**
	 * 把DOM对象保存成文件
	 * @access public
	 */
	public function saveToFile($fileName = NULL) {
		$this->formatOutput = true;
		if ($fileName!==NULL) {
			$this->fileName = $fileName;
		}
		$f = fopen($this->fileName,'w');
		fwrite($f,$this->saveXML());
		fclose($f);
	}
	/**
	 * 把SimpleXMLElement对象保存成文件
	 * @access public
	 */
	public function saxToFile ($fileName = NULL) {
		if ($fileName!==NULL) {
			$this->fileName = $fileName;
		}
		$f = fopen($this->fileName,'w');
		fwrite($f,$this->saxData->asXML());
		fclose($f);
	}
}
?>