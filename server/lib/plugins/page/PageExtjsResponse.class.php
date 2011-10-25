<?php

require_once('PageXml.class.php');
/**
 * Extjs 回复的Page类
 *
 * @package lib
 * @subpackage core.page
 * @author 张立冰 <roast@php.net>
 */
class PageExtjsResponse extends PageXml {
	/**
	 * 值
	 * @var array $value
	 * @access private
	 */
	var $value = array();
	
	/**
	 * 构造函数(兼容PHP4)
	 *
	 * @param Application $app
	 */
	function PageExtjsResponse(& $app) {
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
	 * 返回调用成功结果
	 * @param array $data 返回数据
	 */
	function success($data = array()) {
		$this->value = array('response' => array('data' => $data), 
					  		 'response attr' => array('success' => 'true'));
		$this->output();
	}
	
	/**
	 * 返回调用失败结果
	 * 可带多个参数,每个参数分别代表一个错误,格式为array('id'=>xxx, 'msg'=>xxx)
	 */
	function failure() {
		$fields = array();
		$args = func_get_args();
		if (!empty($args)) {
			for ($i=0; $i<count($args); $i++) {
				if (isset($args[$i][0])) {
					$fields = array_merge($fields, $args[$i]);
				} else {
					$fields[] = $args[$i];
				}
			}
		}
		$this->value = array('response' => array('errors' => 
											array('field' => $fields)), 
					  		 'response attr' => array('success' => 'false'));
		$this->output();
	}
}
?>