<?php

/**
 * 框架使用样例－日期相关操作
 * 
 * @author 张立冰 <roast@php.net>
 * 
 * $Id: utildate.php 1 2008-08-14 10:05:35Z libing $
 */

require_once('../../../common.inc.php');

import('util.DateTime');

/* Default Module */
class utildate extends Action   
{
	/**
	 * 显示登录页(默认Action)
	 */
	function doDefault() 
	{	

	}
}

$app->run();
?>