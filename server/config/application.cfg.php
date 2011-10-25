<?php
/**
 * 配置文件－－主配置文件
 * @package main
 * @subpackage configure
 * @author 张立冰 <roast@php.net>
 * @version 0.1 20071031
 * 
 * $Id: application.cfg.php 98 2009-05-06 01:53:29Z libing $
 */

//调试开关
define('DEBUG', true);

//是否需要进行SESSION处理
define('SESSION', true);

//设置时区
date_default_timezone_set('Asia/Shanghai');

//在线活动时间长度,单位：秒
define('ONLINE_TIME_GAP', 600);

//统一分页长度
define('PAGE_NAV_SIZE', 8);

//初始化配置变量
$cfg = array();

$cfg['path']['conf'] = dirname(__FILE__) . '/';
$cfg['path']['root'] = dirname($cfg['path']['conf']) . '/';

//社区首页
$cfg['url']['root'] = 'http://play9.the9.com/';

//avatar的URL数组
/*
$cfg['url']['avatar'] = array('http://a0.play9.the9.com/avatar0/', 'http://a1.play9.the9.com/avatar1/');

$cfg['site']['title'] = '星期舞社区';

$cfg['site']['name'] = '星期舞社区';

//用于BBS贴子相关加密的密钥
$cfg['bbs']['sec_key'] = 'hj2jkllk&*((*4&*4kd*(/*';

//聊天服务器分组相关配置信息
$cfg['webim'] = array(
    array('host' => '172.18.61.209','port' => 2112)    
);

*/

//主数据库，默认连接该数据库
$cfg['db_r'] = array(
	'params'   => array('driver'=> 'mysql', 'host'=> 'localhost', 'name'=> 'gameleap', 'user'=> 'root', 'password'=> '',),
	'options'  => array('persistent'=> false, 'tablePrefix' => ''),
	);	

//主数据库，默认连接该数据库
$cfg['db_w'] = array(
	'params'   => array('driver'=> 'mysql', 'host'=> 'localhost', 'name'=> 'gameleap', 'user'=> 'root', 'password'=> '',),
	'options'  => array('persistent'=> false, 'tablePrefix' => ''),
	);
	
//页面信息
$cfg['page'] = array(
	'charset'			=> 'UTF-8',
	'contentType'		=> 'text/html',
	'title'			=> '',
	'cached'			=> true,
	'engine'			=> 'smarty',
	'css'				=> array(),
	'js'				=> array(),
	);
    
	
//风格
$cfg['theme'] = array(
	'root'			=> '',
	'current'			=> '',
	);
    
	
//其他路径
$cfg['path'] = array_merge($cfg['path'], array(
	'lib'				=> $cfg['path']['root'] . 'lib/',
	'class'			=> $cfg['path']['root'] . 'lib/',
	'common'			=> $cfg['path']['root'] . 'lib/',
	'cache'			=> $cfg['path']['root'] . 'cache/',
	'upload'			=> $cfg['path']['root'] . 'public/upload/',
	'fonts'			=> $cfg['path']['root'] . 'public/fonts/',
	'temp'			=> $cfg['path']['root'] . 'public/temp/',
	'module'		=> $cfg['path']['root'] . 'modules/',
	));
    
	
//URL设置
$cfg['url'] = array_merge($cfg['url'], array(
	'js'				=> $cfg['url']['root'] . 'public/js/',
	'css'				=> $cfg['url']['root'] . 'public/css/',
	'images'			=> $cfg['url']['root'] . 'public/images/',
	'theme'			    => $cfg['url']['root'] . 'public/theme/',
	));

    
//Smarty
$cfg['smarty'] = array(
	'template_dir'	=> $cfg['path']['root'] . $cfg['theme']['current'] . 'templates/',
	'compile_dir'		=> $cfg['path']['cache'] . 'smarty/',
	'left_delimiter'	=> '{',
	'right_delimiter'	=> '}',
	);
    
	
//cache
$cfg['cache'] = array(
	'root'			=> $cfg['path']['cache'],  // engine=memcached 时为服务器地址 
	'engine'			=> 'file', //file|memcached
	'port'			=> 11211, //engine=memcached 时才有意义 
	'timeout'			=> 60, //engine=memcached 时才有意义 
	);
	
	


// Rsa的公私钥
$cfg['rsa']['pubkey'] = 
'-----BEGIN PUBLIC KEY-----
MIGfMA0GCSqGSIb3DQEBAQUAA4GNADCBiQKBgQDHbnmlsI7lgWOBhONJeBATmyV2
+oXG7VIKMsDWEN13VkWYHqrZnzqWePnTtakv0ckmYTM51Fb+K0W+uZsxBKwynIBj
vhZVCIP9/8LOIAIdmiGQFtIRd8SLR/jS5AOx0H2iqFhOSYIP596BmxNYR43BJ/Jg
PMuXaxPEHYheuzxKuQIDAQAB
-----END PUBLIC KEY-----
';
$cfg['rsa']['prikey'] = 
'-----BEGIN RSA PRIVATE KEY-----
MIICXQIBAAKBgQDHbnmlsI7lgWOBhONJeBATmyV2+oXG7VIKMsDWEN13VkWYHqrZ
nzqWePnTtakv0ckmYTM51Fb+K0W+uZsxBKwynIBjvhZVCIP9/8LOIAIdmiGQFtIR
d8SLR/jS5AOx0H2iqFhOSYIP596BmxNYR43BJ/JgPMuXaxPEHYheuzxKuQIDAQAB
AoGBALSy18wWFtPCkduIAbzO6ZoqKB8OzWm6HGybIfiUHWaEp9g2aU13pckzYgG+
hsaKSbzZs2WBjTUNFkvCtugKOM6idFCQe2zUBlahWxAIZD+cUEcyzh82pshwJgxf
8mI3nAQoCsb09Mhq86G6wo8zf0d7RsdsiOPcFXSc1g8DGswFAkEA/qaRL2IGNDL3
v1SS/M97C1+KeNiowUhyu+YgXOgNyMeACkHTrmw7nmE9NMn/vwbT85Ws7xdBQykE
xXp4XFm8RwJBAMh9AOT80wdUXNwMBGWeTS1mWzBI0fmEy56R7yfH8G6m5Xa1yeJy
4R0mJQjH52eDulFWEAJONUrNKDT68cb4QP8CQQCior8XBAPyUproF5vI2ro7CUnm
5Hji+OJOHyuMKqijEsczxdbsDzQEcxYkIN61oia761wHV1LXEdt6RD2avbUBAkBo
yRTHmfB92zTxeYJuzi8ONHoioVzFage2aBW0GAbs/mPeCKNsrJhF0OL4VOr4Klwe
GLojSlcGMnX6QtJNKQFnAkBh8buEQtaizkoyE7zsoyirxBWuoI/D25mcwrAVz/yd
Na7A+5tb5SnmQtNyNFn9ebU5L/4/d7NTz6XHmcJTbnSX
-----END RSA PRIVATE KEY-----
';
?>