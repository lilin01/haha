<?php

/**
 * 返回 Excel 的Page类
 *
 * @package lib
 * @subpackage core.page
 * @author 张立冰 <roast@php.net>
 */
class PageExcel extends APageFactory {
	/**
	 * 值
	 * @var array $value
	 * @access private
	 */
	var $value = array();
	
	/**
	 * 标题文字
	 * @var array $title
	 * @access private
	 */
	var $header = array();
	
	/**
	 * 构造函数(兼容PHP4)
	 *
	 * @param Application $app
	 */
	function PageExcel(& $app) {
		$this->__construct(& $app);
	}
	
	/**
	 * 构造函数
	 *
	 * @param Application $app
	 */
	function __construct(& $app) {
		parent::__construct(& $app);
	}
	
	/**
	 * 给变量赋值
	 *
	 * @param string $name 变量名,如果参数类型为数组,则为变量赋值,此时$value参数无效
	 * @param mixed $value 变量值,如果该参数未指定,则返回变量值,否则设置变量值
	 * @return APage 如果参数为NULL则返回Page对象本身,否则返回变量值
	 */
	function value($name, $value=NULL) {
		if ($value === NULL && !is_array($name)) { //取值
			return $this->value[$name];
		} else { //赋值
			if (is_array($name)) { //如果是数组则批量变量赋值
				foreach ($name as $k => $v) {
					$this->value[$k] = $v;
				}
			} else {
				$this->value[$name] = & $value;
			}
			return $this;
		}
	}
	
	/**
	 * 定义标题文字
	 *
	 * @param Array $header 标题数组
	 * @return APage
	 */
	function setHeader($headers) {
		foreach ($headers as $field => $header) {
			if (is_array($header)) {
				$this->header[$field] = $header;
				$this->header[$name]['type'] = 'string';
			} else {
				list($name, $type) = explode('#', $field);
				$this->header[$name]['title'] = $header;
				$this->header[$name]['type'] = $type;
			}
		}
		return $this;
	}
	
	/**
	 * 页面内容输出
	 * @param boolean $filename Excel文件名
	 */
	function output($filename='noname.xls') {
		header('Content-type:application/vnd.ms-excel');
		header('Content-Disposition: attachment;filename=' . urlencode($filename));
		header('Pragma: no-cache');
		header('Expires: Mon, 26 Jul 1997 05:00:00 GMT');
		echo '<html><head><meta http-equiv="Content-Type" content="application/vnd.ms-excel; charset='
				. $this->app->cfg['page']['charset'] . '" /></head><body><table>';
		if (!empty($this->value)) {
			$index = 0;
			foreach ($this->value as $row) {
				if ($index === 0 && !empty($this->header)) {
					echo '<tr>';
					foreach ($this->header as $value) {
						echo '<th>' . $value['title'] . '</th>';
					}
					echo '</tr>';
				}
				$index++;
				echo '<tr>';
				$skipCol = 0;
				foreach ($this->header as $field => $value) {
					if ($skipCol > 0) {
						$skipCol--;
						continue;
					}
					switch ($value['type']) {
						case 'index':
							$content = $index;
							break;
						case 'datetime':
							$content = isset($row[$field]) ? date('Y-m-d H:i:s', intval($row[$field])) : '';
							break;
						case 'hash':
							$content = $value['hash'][$row[$field]];
							break;
						default:
							$content = $row[$field];
							break;
					}
					if ($value['type'] == 'int' || $value['type'] == 'float') {
						echo '<td';
					} else {
						echo '<td style="vnd.ms-excel.numberformat:@"';
					}
					if ($attrs = $row[$field . ' attr']) {
						if (gettype($attrs) == 'string') {
							echo ' ' . $attrs;
						} else {
							foreach ($attrs as $attrName => $attrValue) {
								echo ' ' . $attrName . '="' 
										. str_replace('"', '\"', $attrValue) . '"';
								if ($attrName == 'colspan') {
									$skipCol = intval($attrValue);
								}
							}
						}
					}
					echo '>' . $content . '</td>';
				}
				echo '</tr>';
			}
		}
		echo '</table></body></html>';
		return $this;
	}
}
?>