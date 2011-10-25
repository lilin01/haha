<?php 
/**
 *  eAccelerator 缓存类
 *
 * @package lib
 * @subpackage plugins.cache
 * @author 苏宁 <suning@corp.the9.com>
 * 
 * $Id: eAcache.class.php 96 2009-03-12 06:36:10Z libing $
 */
class eAcache{	
	
	/**
	 * 构造函数
	 * 
	 */
	public function __construct() 	{ }
	
	/**
	 * 在缓存中设置键为$key的项的值，如果该项不存在，则新建一个项
	 * @param string $key 键值
	 * @param mix $var 值
	 * @param int $expire 缓存时间,单位为秒
	 * @return boolean 如果成功则返回 true，失败则返回 false。返回false很有可能是缓存已满!
	 * @access public
	 */
    public static function set($key, $var, $expire = 0) 
    {
		return eaccelerator_put($key, $var, $expire);
	}
	
	/**
	 * 在cache中获取键为$key的项的值
	 * @param string $key 键值
	 * @return mixed 如果该项不存在，则返回 NULL
	 * @access public
	 */
    public static function get($key) 
    {
		return eaccelerator_get($key);
	}
	
	/**
	 * 清空cache中所有项, 全部清除需要遍历cache,一个一个删除!
	 * @return void
	 * @access public
	 */
    public static function flush() 
    {
    	// 清除过期的key
    	eaccelerator_gc();
    	
    	// 遍历key,一个一个删除
		$list = eaccelerator_list_keys();
		foreach ($list as $k => $v)
		{
			self::delete($v['name']);
		}
	}
	
	/**
	 * 删除在cache中键为$key的项的值
	 * @param string $key 键值
	 * @return 如果成功则返回 true，失败则返回 false。
	 * @access public
	 */
    public static function delete($key) 
    {
		return eaccelerator_rm($key);
	}
}
?>