<?php

/**
 * 框架使用样例－缓存操作
 * 
 * @author 张立冰 <roast@php.net>
 * 
 * $Id: index.php 11 2008-08-27 04:00:47Z suning $
 */

require_once('../../../common.inc.php');

/* Default Module */
class index extends Action   
{
	/**
	 * 显示登录页(默认Action)
	 */
	function doDefault() 
	{	
		/* {{{ 初始化Cache,默认使用配置文件中配置引擎 */
		$cache = $this->app->cache();
		/* }}} */
		
		/* {{{ 缓存数据 == resource/cache/Test/FileKey.cache.php写入数据 */
		$cache->set('Test/FileKey2', 'FileValue', 0);
		/* }}} */
		
		/* {{{ 读取缓存数据 == resource/cache/Test/FileKey.cache.php的数据 */
		echo $cache->get('Test/FileKey') . '<br />';
		/* }}} */	
		
		/* {{{ 删除缓存数据文件 rm -f resource/cache/Test/FileKey.cache.php */
		echo $cache->delete('Test/FileKey') . '<br />';
		/* }}} */
				
		/* {{{ 使用Memcached做数据缓存 */
		$cache = $this->app->cache('memcached', '172.18.61.201', 11211, 60);
		/* }}} */
		
		/* {{{ 缓存数据 ==memcache_set($mc, 'Test_FileKey', 'FileValue', 0)*/
		$cache->set('Test_FileKey', 'FileValue', 0);
		/* }}} */
		
		/* {{{ 读取缓存数据 == memcache_get($mc, 'Test_FileKey') */
		echo $cache->get('Test_FileKey') . '<br />';
		/* }}} */
		
		/* {{{ 使用eAcache做数据缓存 */
		$cache = $this->app->cache('eacache');
		/* }}} */
		
		/* {{{ 缓存数据 */
		$cache->set('key', 'eAcacheValue', 0);
		/* }}} */
		
		/* {{{ 读取缓存数据*/
		echo $cache->get('key') . '<br />';
		/* }}} */
		
		/* {{{ 删除缓存数据  */
		$cache->delete('key') . '<br />';
		/* }}} */
	}
}

$app->run();
?>