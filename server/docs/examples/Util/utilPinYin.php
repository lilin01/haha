<?php

/**
 * 框架使用样例－PinYin操作
 * 
 * @author suning <suning@corp.the9.com>
 * 
 * $Id: utilPinYin.php 47 2008-08-28 07:08:03Z suning $
 */

require_once('../../../common.inc.php');

import('util.PinYin.PinYin');

/* Default Module */
class utilPinYin extends Action   
{
	/**
	 * 显示登录页(默认Action)
	 */
	function doDefault() 
	{
		/* {{{ 获取拼音, 待转换汉字编码为UTF8 */
		$pinyin = new PinYin();
		echo $pinyin->getPinYin("阿斯蒂芬玩儿玩儿234wer1判断是23123地方", "-");
		echo "<br />";
		/* }}} */
		
		/* {{{ 获取拼音, 待转换汉字编码为GB2312 */
		$pinyin = new PinYin('gb2312');
		$list = iconv("UTF-8", "GB2312", "阿斯蒂芬玩儿玩儿234wer1判断是23123地方");
		echo $pinyin->getPinYin($list, ",");
		/* }}} */
	}
}

$app->run();
?>