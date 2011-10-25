<?php

/**
 * 框架使用样例－主应用
 * 
 * @author 张立冰 <roast@php.net>
 * 
 * $Id: index.php 1 2008-08-14 10:05:35Z libing $
 */

require_once('../../common.inc.php');

/* Default Module */
class index extends Action   
{
	/**
	 * 显示登录页(默认Action)
	 */
	function doDefault() 
	{	
		/* {{{ 调试用例开始 */
		$data = array('a'=>'a', 'b'=>3);
		$this->debug('数据库连接失败');
		$this->debug($data);
		$this->debug('提示信息');
		$this->debug('警告信息');
		$this->debug('错误信息');		
		echo '调试方法使用，通过firephp和friebug查看相关调试信息<br />';	
		/* }}} */	
		
		$page = $this->app->page();
		
		/* {{{ 分页字符串生成 */
		$page_cur = $_GET['page'] ? intval($_GET['page']) : 0;
		$data = $page->getNav(40, 7, $page_cur, '<a href="?page=%d">%d</a>&nbsp;&nbsp;', '<b>%d</b>');		
		echo '分页处理:' . $data . '<br />';
		/* }}} */
		
		
		/* {{{ 输出验证码链接 */
		echo '<img src="?do=code" ><br />';
		/* }}} */
		
		
		/* {{{ 验证验证码 */
		if ($_GET['code'])
			echo '验证码检测结果:' . var_export($this->_checkCode(trim($_GET['code'])), true) . '<br />';
		/* }}} */

		
		/* {{{ 导出基础类 */
		import('util.Ip');	//include('util/Ip.class.php');
		echo Ip::get().'<br />';	//调用IP类中获取IP的方法
		/* }}} */
		
		
		/* {{{ 导出应用定义模块文件 */
		importModule('HelloWorld');	//include('modules/HelloWorld.class.php');
		echo HelloWorld::Test('HelloWorld::Test').'<br />';	//调用IP类中获取IP的方法
		/* }}} */
			
		
		/* {{{ 获取IP地址 */
		echo 'Application 获得的IP地址' . $this->app->ip().'<br />';
		/* }}} */
			
		
		/* {{{页面跳转 */
		if ($_GET['go'] == 'redirect')
			$this->app->redirect('http://www.baidu.com/');
		/* }}} */
		
		
		/* {{{ 测试smarty页面输出 */
		$page->value('title', '这是页面变量！');
		$page->output();
		/* }}} */
		
		
		/** {{{ 通过SOCKET执行SOAP请求 **/
		/*  SOCKET INPUT DATA
		POST /HRWeb/Asmx/Reming.asmx HTTP/1.1
		Host: 192.168.2.36
		Content-Type: text/xml; charset=utf-8
		Content-Length: length
		SOAPAction: "http://tempuri.org/PersonnelInfo"
		
		<?xml version="1.0" encoding="utf-8"?>
		<soap:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/">
		  <soap:Body>
		    <PersonnelInfo xmlns="http://tempuri.org/">
		      <p_lUserId>int</p_lUserId>
		    </PersonnelInfo>
		  </soap:Body>
		</soap:Envelope>		
		*/
		
		/*  SOCKET OUTPUT DATA
		HTTP/1.1 200 OK
		Content-Type: text/xml; charset=utf-8
		Content-Length: length
		
		<?xml version="1.0" encoding="utf-8"?>
		<soap:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/">
		  <soap:Body>
		    <PersonnelInfoResponse xmlns="http://tempuri.org/">
		      <PersonnelInfoResult>
		        <UserId>int</UserId>
		        <UserName>string</UserName>
		        <UserPhotolink>string</UserPhotolink>
		        <UserAge>int</UserAge>
		        <UserSex>string</UserSex>
		        <UserNative>string</UserNative>
		        <UserParty>string</UserParty>
		        <UserNation>string</UserNation>
		        <UserBirthday>dateTime</UserBirthday>
		        <UserHeight>string</UserHeight>
		        <UserBlood>string</UserBlood>
		        <UserCardCode>string</UserCardCode>
		        <UserMarriage>string</UserMarriage>
		        <UserMobile>string</UserMobile>
		        <UserPhone>string</UserPhone>
		        <UserEmail>string</UserEmail>
		        <UserHJAdd>string</UserHJAdd>
		        <UserXZAdd>string</UserXZAdd>
		        <UserHKArea>string</UserHKArea>
		        <UserDAArea>string</UserDAArea>
		        <UserBYSchool>string</UserBYSchool>
		        <DepCode>string</DepCode>
		        <DepName>string</DepName>
		        <GWName>string</GWName>
		        <ZWName>string</ZWName>
		        <ZCName>string</ZCName>
		        <UserType>string</UserType>
		        <WorkAge>int</WorkAge>
		        <GraNum>string</GraNum>
		        <JoinDate>dateTime</JoinDate>
		        <SYDate>dateTime</SYDate>
		      </PersonnelInfoResult>
		    </PersonnelInfoResponse>
		  </soap:Body>
		</soap:Envelope>		
		*/
		$args =  array('p_lUserId'=> '100418');
		echo '<p>_soap action:<br />';
		//var_dump($this->_soap('192.168.2.36', 'HRWeb/Asmx/Reming.asmx', 'PersonnelInfo', $args));
		echo '</p>';
		/* }}} */
	}
}

$app->run();
?>