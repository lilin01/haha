<?php
/**
 * 框架使用样例－列表获取应用
 * 
 * @author 苏宁 <suning@corp.the9.com>
 * 
 * $Id: index.php 87 2008-09-17 06:54:55Z suning $
 */

error_reporting(E_ALL ^ (E_NOTICE | E_WARNING));
require_once('../../../common.inc.php');
importModule("Mail.MailList");

class index extends Action 
{
	/**
	 * 使用例子,不直接调用!
	 *
	 */
	public function example()
	{		
		/* {{{ 初始化邮件列表 */
		$list = new MailList();
		/* }}} */	
		
		/* {{{ 加载126邮箱实现模块,设置用户名和密码,取列表 */
		$MailList = $list->init('126');
		$MailList->mail->set('用户名', '密码');
		print_r($MailList -> getList());
		/* }}} */	
		
		
		/* {{{ 加载163邮箱实现模块,设置用户名和密码,取列表 */
		$MailList = $list->init('163');		
		$MailList->mail->set('用户名', '密码');
		print_r($MailList -> getList());
		/* }}} */
		
		/* {{{ 加载yeah.net邮箱实现模块,设置用户名和密码,取列表 */
		$MailList = $list->init('yeah');		
		$MailList->mail->set('用户名', '密码');
		print_r($MailList -> getList());
		/* }}} */

		/* {{{ 加载sohu邮箱实现模块,设置用户名和密码,取列表 */
		$MailList = $list->init('sohu');		
		$MailList->mail->set('用户名', '密码');
		print_r($MailList -> getList());
		/* }}} */
		
		/* {{{ 加载gmail邮箱实现模块,设置用户名和密码,取列表 */
		$MailList = $list->init('gmail');		
		$MailList->mail->set('用户名', '密码');
		print_r($MailList -> getList());
		/* }}} */
		
		/* {{{ 加载sina邮箱实现模块,设置用户名和密码,取列表 */
		$MailList = $list->init('sina');		
		$MailList->mail->set('用户名', '密码'); 
		print_r($MailList -> getList());
		/* }}} */
		
		/* {{{ 加载MSN实现模块,设置用户名和密码,取列表 */
		$MailList = $list->init('msn');		
		$MailList->mail->set('用户名', '密码'); 
		print_r($MailList -> getList());
		/* }}} */
		
		/* {{{ 加载QQ实现模块,设置用户名,密码和验证码,取列表 */			
		//取QQ验证码,方法一
		header("Content-Type: image/jpeg");
		importModule("Mail._qq");
		_qq::getImage();

		//取QQ验证码,方法二
		header("Content-Type: image/jpeg");
		$MailList = $list->init('qq');	
		$MailList->getImage();	
		
		//取QQ好友列表		
		$MailList = $list->init('qq');
		$MailList->mail->set('qq号', '密码', '验证码'); //除QQ号密码外, 必须输入验证码
		print_r($MailList -> getList());
		/* }}} */		
	}
	
	/**
	 * DEMO
	 *
	 */
	public function doDefault()
	{
		$base = dirname(__FILE__);
		
		// QQ验证码
		if (isset($_GET['image']))
		{
			header("Content-Type: image/jpeg");
			importModule("Mail._qq");
			_qq::getImage();
			exit;
		}

		// QQ邮件验证码
		if (isset($_GET['image_mail']))
		{
			header("Content-Type: image/jpeg");
			importModule("Mail._qqmail");
			_qqmail::getImage();
			exit;
		}
		
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
		
		
		// 逻辑处理
		$result = null;
		if (isset($_POST['type']))
		{			
			$type = $_POST['type'];
			$login = $_POST['login'];
			$pass = $_POST['passwd'];
			if ($login == "" || $pass == "")
			{
				$result = "用户名密码空!";				
			}
			else 
			{
				if ($type == 'mail')
				{
					$type = $_POST['mail'];
					if (strpos($type, '@') !== false)
					{
						list($type, $name) = explode("@", $type);
						$login .= '@' . $name;
					}
				}
				$list = new MailList();
				$MailList = $list->init($type);
				$MailList->mail->set($login, $pass, trim($_POST['code']));
				$result = print_r($MailList -> getList(), true);
				if ($result == false)
				{
					$result = "用户名或密码不正确";
				}
			}
		}
		
		$QQimage = "?image=qq";
		$smarty->assign("QQ", $QQimage);	
		$smarty->assign("result", $result);
		$smarty->display($base . "\\demo.tpl");
	}
}
$app->run();
?>