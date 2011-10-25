<?php
/**
 * 框架使用样例－文本过滤
 * 
 * @author 苏宁 <suning@corp.the9.com>
 * 
 * $Id$
 */

error_reporting(E_ALL ^ (E_NOTICE | E_WARNING));
require_once('../../../common.inc.php');

class index extends Action   
{	
	function doDefault() 
	{	
		/* {{{ 导入过滤模块,并初始化 */
		importModule("Filter.Filter");
		$fl = new Filter();
		/* }}} */
				
		/* {{{ 过滤测试测试文本 */
		$content = "大家好.有人认识李洪志吗? 学过法轮功的吗?";
		echo "<b>原语句:</b> ", $content , "<br />";		
		/* }}} */
		
		/* {{{ 检测是否含有非法关键字 */
		$show = $fl->isForbidden($content);
		if ($show)
		{
			echo "<br />含有非法关键字!<br /><br />";
		}
		else 
		{
			echo "<br />没有有非法关键字!<br /><br />";
		}
		/* }}} */
		
		/* {{{ 过滤文本 */
		$start = xdebug_time_index();
		$show = $fl->clean($content);
		echo "<b>过滤后的:</b>", $show , "<br />";
		echo "用时: ", xdebug_time_index() - $start, "<br />";
		/* }}} */
		
		/* {{{ 过滤文本, 指定替换的格式 */
		$start = xdebug_time_index();
		$show = $fl->clean($content, "×");
		echo "<br /><b>指定替换内容过滤:</b> ", $show , "<br />";
		echo "用时: ", xdebug_time_index() - $start, "<br />";
		/* }}} */
		
		/* {{{ 并手工指定关键字再过滤文本 */
		$start = xdebug_time_index();
		$fl->setKey(array('大家好'));
		$show = $fl->clean($content);
		echo "<br /><b>手工指定关键字过滤:</b> ", $show , "<br />";	
		echo "用时: ", xdebug_time_index() - $start, "<br />";
		/* }}} */
		
		/* {{{ 模糊过滤文本 */
		$start = xdebug_time_index();
		$ff = new Filter();
		$content = "start:李      洪     志-测-试- f-!u-c=k, fuck:end";
		echo "<br /><b>原语句:</b> ", $content , "<br />";

		$show = $ff->fuzzyClean($content, "*", 2); //其中2为深度,默认值,值越大清理越干净,误杀越多,消耗资源越多.

		echo "<b>模糊过滤后:</b> ", $show , "<br />";
		echo "用时: ", xdebug_time_index() - $start, "<br />";
		/* }}} */	
	}
}

$app->run();
?>