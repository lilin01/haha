<?php 

/**
 *  memcached 类
 *
 * @package lib
 * @subpackage plugins.cache
 * @author 张立冰 <roast@php.net>
 * 
 * $Id: Memcached.class.php 98 2009-05-06 01:53:29Z libing $
 */
class Memcached
{
	/**
	 * @var Memcache $memcache Memcached 缓存连接对象
	 * @access public
	 */
	var $memcache = NULL;
	
	/**
	 * @var string $prefix 变量前缀
	 */
	var $prefix = '';
	
	
    /**
     * 数据查询的统计
     *
     * @var Array
     */
    static public $querys = array();
    
    
    /**
     * 数据缓存沲
     *
     * @var Array
     */
    static public $data = array();
    
    
	/**
	 * 构造函数(兼容PHP4)
	 * @param string $host Memcached 服务器的主机名或IP地址
	 * @param int $port 端口号
	 * @param int $timeout 超时时间
	 */
	function Memcached($host = 'localhost', $port = 11211, $timeout = 60) 
	{
		if (strpos($host, '$') !== false)
			list($host, $this->prefix) = explode('$', $host, 2);
		
		($this->prefix) && $this->prefix .= '_';
    	$this->__construct($host, $port, $timeout);
    }
	
    
	/**
	 * 构造函数
	 * @param string $host Memcached 服务器的主机名或IP地址或者为服务器组相关信息
	 * @param int $port 端口号
	 * @param int $timeout 超时时间
	 */
	function __construct($host = 'localhost', $port = 11211, $timeout = 60) 
	{
    	$this->memcache = new Memcache();
    	
    	$host = is_array($host) ? $host : array(array('host' => $host, 'port' => $port));
    	
    	//如果是服务器分组则添加所有的服务器分组
    	foreach ($host as $m)
    	{
    	    $this->memcache->addServer($m['host'], $m['port']);
    	}
    }
	
    
	/**
	 * 析构函数
	 */
	function __destruct() 
	{
    	$this->memcache->close();
    }
	
    
	/**
	 * 在cache中设置键为$key的项的值，如果该项不存在，则新建一个项
	 * @param string $key 键值
	 * @param mix $var 值
	 * @param int $expire 到期秒数
	 * @param int $flag 标志位
	 * @return bool 如果成功则返回 TRUE，失败则返回 FALSE。
	 * @access public
	 */
    function set($key, $var, $expire = 0, $flag = 0) 
    {
		global $global;
		$key = $this->prefix . $key;
		
	    if (DEBUG)
	       self::$querys[] = "set " . $key . ' ' . $var;	  

	    if (isset(self::$data[$key]))
			self::$data[$key] = '';
	    		
		return $this->memcache->set($key, $var, $flag, $expire);
	}
	
	
	/**
	 * 在cache中获取键为$key的项的值
	 * @param string $key 键值
	 * @return string 如果该项不存在，则返回false
	 * @access public
	 */
    function get($key) 
    {
		global $global;
		$key = (empty($this->prefix)) ? $key : $this->prefix . $key;
		
		$s_key = is_array($key) ? serialize($key) : $key;

		if (empty(self::$data[$s_key]))
		{
		    if (DEBUG)
		       self::$querys[] = "get " . (is_array($key) ? implode(',', $key) : $key);
		       		
			self::$data[$s_key] = $this->memcache->get($key);			
		}
			
		return self::$data[$s_key];
	}
	
	
	/**
	 * 在MC中获取为$key的自增ID
	 *
	 * @param string $key	 自增$key键值
	 * @param integer $count 自增量,默认为1
	 * @return 				 成功返回自增后的数值,失败返回false
	 */
	function increment($key, $count = 1) 
	{
		return $this->memcache->increment($key, $count);
	}
	
	
	/**
	 * 清空cache中所有项
	 * @return 如果成功则返回 TRUE，失败则返回 FALSE。
	 * @access public
	 */
    function flush() 
    {
		return $this->memcache->flush();
	}
	
	
	/**
	 * 删除在cache中键为$key的项的值
	 * @param string $key 键值
	 * @return 如果成功则返回 TRUE，失败则返回 FALSE。
	 * @access public
	 */
    function delete($key) 
    {
 	    if (isset(self::$data[$key]))
			self::$data[$key] = '';
			   	
		return $this->memcache->delete($this->prefix . $key);
	}
}
?>