<?php

/**
 * RSA使用样例－页面输出处理示例
 * 
 * @author 陈敬钻
 * 
 * $Id: index.php 1 2008-08-27 10:05:35Z  $
 */

require_once('../../../common.inc.php');
importModule("RSA.RSA");
/* Default Module */
class rsademo extends Action   
{
	/**
	 * 显示登录页(默认Action)
	 */
	function doDefault()
	{
		$base = dirname(__FILE__);
		// 初始化smarty
		import('smarty.Smarty');
		$smarty = new Smarty;
		$smarty->template_dir = $this->app->cfg['smarty']['template_dir'];
		$smarty->compile_dir = $this->app->cfg['smarty']['compile_dir'];
		$smarty->config_dir = $this->app->cfg['smarty']['config_dir'];
		$smarty->cache_dir = $this->app->cfg['smarty']['cache_dir'];
		$smarty->debugging = $this->app->cfg['smarty']['debugging'];
		$smarty->caching = $this->app->cfg['smarty']['caching'];
		$smarty->cache_lifetime = $this->app->cfg['smarty']['cache_lifetime'];
		$smarty->left_delimiter = '{<';
		$smarty->right_delimiter = '>}';
		
		$result = null;
		//$_POST['en']是客户端用RSA加密后的字符串
		if ($_POST['en'])
		{
			$result = RSA::Decrypt($_POST['en']);
			$result = "The plain text is:".$result;
		}
		$smarty->assign("result", $result);
		$smarty->display($base . "\\rsademo.tpl");
	}
}

$app->run();
?>