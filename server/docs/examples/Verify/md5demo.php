<?php

/**
 * MD5使用样例－主应用
 * 
 * @author 陈敬钻 
 * 
 * $Id: index.php 1 2008-08-27 10:05:35Z  $
 */

require_once('../../../common.inc.php');

/* Default Module */
class md5demo extends Action
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
		if(isset($_POST['u']) && isset($_POST['p']))
		{
			//$password 是从数据库中读取的用户密码,现在暂定hello
			$password ="hello";
			//计算密码和验证码的md5值
			if(md5($password.$_SESSION['VALIDATE_CODE'])== $_POST['p'])
			{
				$result= "The result is: right";
			}
			else
			{
				$result="The result is: false";
			}
		}
		$smarty->assign("result", $result);
		$smarty->display($base . "\\md5demo.tpl");
	}
}

$app->run();
?>
 


