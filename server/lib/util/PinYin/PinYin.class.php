<?php
/**
 * PinYin 转换类(全)
 * 类中支持GB2312编码的所有汉字与拼音对应,共计6763个 
 * 如果超出此集合,暂无法支持
 *
 * @package lib
 * @subpackage util.PinYin
 * @author 苏宁 <suning@corp.the9.com>
 *
 * $Id: PinYin.class.php 96 2009-03-12 06:36:10Z libing $
 */


class PinYin
{
	/**
	 * 是否支持eAccelerator
	 *
	 * @var boolean
	 */
	private $eAcache = false;
	
	/**
	 * 存放汉字拼音对应表
	 *
	 * @var boolean
	 */
	private $pinyin = array();
	
	/**
	 * 汉字字节长度,默认为2
	 *
	 * @var Number
	 */
	private $length = 2;
	
	/**
	 * 构造函数, 初始化汉字拼音对照表
	 *
	 * @param string $encode 设定待转换汉字的编码类型, 默认UTF8
	 */	
	public function __construct($encode = "utf8")
	{
		global $cfg;
		$dbPath = $cfg['path']['lib'] . "util/PinYin/PinYin_" . strtoupper($encode) . ".db";
		if (!file_exists($dbPath))
		{
			$encode = "utf8";
			$dbPath = $cfg['path']['lib'] . "util/PinYin/PinYin_UTF8.db";
		}
		$this->length = $encode == "utf8" ? 3 : 2;
		
		// 使用eAccelerator缓存
		if (function_exists("eaccelerator_put"))
		{
			$this->eAcache = true;
			import("plugins.cache.eAcache");
			$key = "{$encode}__pinyin";
			$data = eAcache::get($key);
			if (!is_array($data) || empty($data[0]))
			{
				$data = unserialize(file_get_contents($dbPath));
				eAcache::set($key, $data);
			}
			$this->pinyin = & $data;
		}
		else
		{
			$data = unserialize(file_get_contents($dbPath));
			$this->pinyin = & $data;
		}
	}
	
	/**
	 * 获得汉字对应的拼音,非汉字自动跳过
	 *
	 * @param string $str 汉字
	 * @param string $delimiter 分割符号
	 * @param boolean $ucfirst 拼音首字母大写
	 * @return string 返回对于的拼音,如果不存在,则返回空.
	 */
	public function getPinYin($str, $delimiter = " ", $ucfirst = false)
	{
		$len = strlen($str);
		if ($len < $this->length) return $str;
		$pinyin = array();
		for ($i = 0; $i < $len; $i++)
		{
			$asi = ord($str[$i]);
			if ($asi > 0 && $asi < 160)
			{
				$pinyin[] = $str[$i];
			}
			else
			{
				$find = "";
				for ($j = 0; $j < $this->length; $j++)
				{
					$find .= $str[$i];
					++$i;
				}
				--$i;				
				if (isset($this->pinyin[$find]))
				{
					if ($ucfirst == true)
					{
						$pinyin[] = ucfirst($this->pinyin[$find]);
					}
					else 
					{
						$pinyin[] = $this->pinyin[$find];
					}
				}
			}
		}
		return  implode($delimiter, $pinyin);		
	}
}

?>