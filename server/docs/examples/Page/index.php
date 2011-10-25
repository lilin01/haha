<?php

/**
 * 框架使用样例－页面输出处理示例
 * 
 * @author 张立冰 <roast@php.net>
 * 
 * $Id: index.php 1 2008-08-14 10:05:35Z libing $
 */

require_once('../../../common.inc.php');

/* Default Module */
class index extends Action   
{
	/**
	 * 显示登录页(默认Action)
	 */
	function doDefault() 
	{
        echo '<a href="?type=xml">xml</a>&nbsp;<a href="?type=json">json</a>&nbsp;<a href="?type=smarty">smarty</a>&nbsp;<a href="?type=excel">excel</a>&nbsp;<br />';
	    
	    $str_page_type = trim($_GET['type']);
	    
	    $data = array(array('name'=>'roast', 'sex'=>'male'), array('name'=>'len', 'sex'=>'female'));
	    
	    if (!in_array($str_page_type, array('smarty', 'json', 'xml', 'excel')))
	        $page = $this->app->page();
	    else 
	        $page = $this->app->page($str_page_type);
	       
	     $page->value('data', $data);
	     $page->output();
	}
}

$app->run();
?>