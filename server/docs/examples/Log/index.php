<?php

/**
 * 框架使用样例－日志操作
 * 
 * @author 苏宁 <suning@corp.the9.com>
 * 
 * $Id: index.php 51 2008-08-29 07:19:39Z suning $
 */

error_reporting(E_ALL ^ (E_NOTICE | E_WARNING));
require_once('../../../common.inc.php');

/* Default Module */
class index extends Action   
{
	/**
	 * 显示登录页(默认Action)
	 */
	function doDefault() 
	{	
		/* {{{ 导入LOG模块 */
		import("plugins.Log");
		/* }}} */
				
		/* {{{ 创建普通日志文件 ROOT/logs/login/login_年月日.log */
		$data = array("UID", "KID", "www.koyoz.com"); //日志记录的数据
		$log = new Log('login', $data);
		$log->write();
		/* }}} */
		
		/* {{{ 创建带目录日志文件 ROOT/logs/memcache/error_年月日.log */
		$data = array("UID", "KID", "www.koyoz.com"); //日志记录的数据
		$log = new Log('memcache/error', $data);
		$log->write();
		/* }}} */
		
		/* {{{ 创建自定义日志文件 ROOT/logs/fulltest/test.txt */
		$data = array("zz", "12345" , "67890");
		$log = new Log();
		$log->setPath("fulltest"); //设置路径,必选
		$log->setData($data); //设置数据, 必选
		$log->setNoTime(); //设置不添加年月日时间, 可选, 默认添加
		$log->setSep(","); //设置日志数据分割符号, 可选, 默认为\t
		$log->setTitle("test.txt"); //设置自定义的日志文件名, 可选, 默认为设置的路径的最后一部分
		$log->write();
		/* }}} */
		
		/* {{{ 重用日志对象 */
		$data = array("zz", "12345" , "67890");		
		$log = new Log();
		
		// 设置参数, 支持方法链简写, 允许叠加设置数据; ROOT/logs/fulltest/link.txt
		$log->setPath("fulltest")
			->setData($data)
			->setData("more")
			->setData(array('link', 'test'))
			->setTitle("link.txt")
			->write();
		
		// 复位参数,记录另一种类日志; ROOT/logs/fulltest/again.txt
		$log->reset()
			->setPath("fulltest")
			->setData($data)
			->setTitle("again.txt")
			->write();		
		/* }}} */
		

		echo "日志创建完毕";		
				
	}
}

$app->run();
?>