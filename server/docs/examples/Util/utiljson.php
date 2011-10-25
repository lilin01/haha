<?php

/**
 * 框架使用样例－JSON操作
 * 
 * @author 张立冰 <roast@php.net>
 * 
 * $Id: utiljson.php 1 2008-08-14 10:05:35Z libing $
 */

require_once('../../../common.inc.php');

import('util.Json');

/* Default Module */
class utiljson extends Action   
{
	/**
	 * 显示登录页(默认Action)
	 */
	function doDefault() 
	{	
	    $data = array('a', 'b'=>'roast');
        $json = new Json();
        
        $str_encoded = $json->encode($data);
        
        var_dump($str_encoded);
        
        var_dump($json->decode($str_encoded));
	}
}

$app->run();
?>