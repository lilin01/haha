<?php

/**
 *  页面接口类
 * 
 * @package lib
 * @subpackage core.page
 * @author 张立冰 <roast@php.net>
 */
class APageFactory {
	/**
	 * 页面参数,如title等
	 *
	 * @var array
	 */
	var $params = array();
	
	/**
	 * 应用程序类
	 * @var Aplication
	 * @var protected
	 */
	var $app;
	
	/**
	 * 构造函数(兼容PHP4)
	 * @param Appcation $app
	 */
	function APageFactory(& $app) {
		$this->__construct($app);
	}
	
	/**
	 * 构造函数
	 * @param Appcation $app
	 */
	function __construct(& $app) {
		global $cfg;
		$this->params = & $cfg['page'];
		$this->app = & $app;
	}
	
	/**
	 * 创建一个页面类
	 *
	 * @param Application $app 应用程序类
	 * @param string $engine 页面引擎
	 * @return APage
	 */
	function create(& $app, $engine=NULL) {
		$className = 'Page' . ucfirst($engine);
		import('plugins.page.' . $className);
		return new $className($app);
	}
	
	/**
	 * 页面变量取值/赋值
	 *
	 * @param string $name 变量名
	 * @param mixed $value 变量值,如果该参数未指定,则返回变量值,否则设置变量值
	 * @return APage 如果参数为NULL则返回Page对象本身,否则返回变量值
	 */
	function value($name, $value=NULL) { /*nothing*/ }
	
	/**
	 * 页面内容输出
	 *
	 * @param boolean $return
	 */
	function output($return=false) { /*nothing*/ }
	
	
	/**
	 * 生成分页中除上一页、下一页、首页、最后页的连续部分
	 *
	 * @param integer $page_total
	 * @param integer $page_size
	 * @param integer $page_cur
	 * @param string $style
	 * @return string 
	 * @example 
	 * 		$style = 'index.php?page=%d&type=fuck'; //%d替换成页码
	 * 		$nav = getNav(11,3,4,$style);
	 */
	function getNav($page_total, $page_size = PAGR_NAV_SIZE, $page_cur, $style, $cur_style = null)
	{
		$nav = '';
		
		if (isset($page_total)&& $page_total > 1)
		{
			if ($page_cur <= (ceil(($page_size / 2))+1))	//当页码小于分页规格时，起始页码为第一页
			    $nav_start_page = 0;
			elseif (($page_total - $page_cur) + 1 < $page_size  && $page_total > $page_size) //当前页面到最后一页的长度小于分页规格时，设置开始分页为总页面长度减少页面规格   
			    $nav_start_page = $page_total - $page_size;
			elseif ($page_cur > (ceil(($page_size / 2))+1))
				$nav_start_page = $page_cur - (ceil(($page_size / 2))+1);
			else
			    $nav_start_page = $page_cur;
			    
			for($i = $nav_start_page, $m = 0; $i < $page_total && $m < $page_size; $i++, $m++)
			{
				if (!empty($cur_style) && ($i + 1) == $page_cur)
					$nav .= str_replace('%d', ($i+1), $cur_style);
				else 
					$nav .= str_replace('%d', ($i+1), $style);
			}
				
		}	
			
		return $nav;
	}
}
?>