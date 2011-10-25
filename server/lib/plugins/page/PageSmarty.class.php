<?php

import('smarty.Smarty');

/**
 * 应用Smarty的Page类
 *
 * @package lib
 * @subpackage core.page
 * @author 张立冰 <roast@php.net>
 */
class PageSmarty extends APageFactory {
	/**
	 * Smarty 对象
	 *
	 * @var object Smarty
	 * @access private
	 */
	var $smarty;
	
	/**
	 * 构造函数(兼容PHP4)
	 *
	 * @param Application $app
	 */
	function PageSmarty(& $app) {
		$this->__construct(& $app);
	}
	
	/**
	 * 构造函数
	 *
	 * @param Application $app
	 */
	function __construct(& $app) {
		parent::__construct(& $app);
		$this->smarty = new Smarty;
		(isset($app->cfg['smarty']['template_dir'])) && $this->smarty->template_dir = $app->cfg['smarty']['template_dir'];
		(isset($app->cfg['smarty']['compile_dir'])) && $this->smarty->compile_dir = $app->cfg['smarty']['compile_dir'];
		(isset($app->cfg['smarty']['config_dir'])) && $this->smarty->config_dir = $app->cfg['smarty']['config_dir'];
		(isset($app->cfg['smarty']['cache_dir'])) && $this->smarty->cache_dir = $app->cfg['smarty']['cache_dir'];
		(isset($app->cfg['smarty']['debugging'])) && $this->smarty->debugging = $app->cfg['smarty']['debugging'];
		(isset($app->cfg['smarty']['caching'])) && $this->smarty->caching = $app->cfg['smarty']['caching'];
		(isset($app->cfg['smarty']['cache_lifetime'])) && $this->smarty->cache_lifetime = $app->cfg['smarty']['cache_lifetime'];
		(isset($app->cfg['smarty']['left_delimiter'])) && $this->smarty->left_delimiter = $app->cfg['smarty']['left_delimiter'];
		(isset($app->cfg['smarty']['right_delimiter'])) && $this->smarty->right_delimiter = $app->cfg['smarty']['right_delimiter'];
		$this->smarty->plugins_dir = SMARTY_DIR . 'plugins/';
		
		$this->smarty->assign_by_ref('cfg', $app->cfg);
		$this->smarty->register_modifier('head', 'head'); 
		$this->smarty->register_modifier('html', '_htmlspecialchars'); 
		
		//设置默认的图片、样式、JS的模版路径
		$this->value('url_js', $app->cfg['url']['js']);
		$this->value('url_images', $app->cfg['url']['images']);
		$this->value('url_css', $app->cfg['url']['css']);
		$this->value('site_title', $app->cfg['site']['title']);
		$this->value('site_name', $app->cfg['site']['name']);
		$this->value('url_theme', $app->cfg['url']['theme']);
		
		if (is_array($this->app->pool['message_cnt_info']))
		{
			$message_cnt = $this->app->pool['message_cnt_info'];
			$this->value('all_message_cnt', array_sum(array_values($message_cnt)));
			$this->value('message_cnt_info', '[' . $message_cnt['system'] . ',' . $message_cnt['message'] . ',' . $message_cnt['guestbook'] . ',' . $message_cnt['comment'] . ']');
		}
			
	}
	
	/**
	 * 给页面变量赋值
	 *
	 * @param string $name 变量名,如果参数类型为数组,则为变量赋值,此时$value参数无效
	 * @param mixed $value 变量值,如果该参数未指定,则返回变量值,否则设置变量值
	 * @return APage 如果参数为NULL则返回Page对象本身,否则返回变量值
	 */
	function value($name, $value = NULL) {
		if ($value === NULL && !is_array($name)) { //取值
			return $this->smarty->get_template_vars($name);
		} else { //赋值
			if (is_array($name)) { //如果是数组则批量变量赋值
				foreach ($name as $k => $v) {
					$this->smarty->assign($k, $v);
				}
			} else {
				$this->smarty->assign($name, $value);
			}
			return $this;
		}
	}
	
	/**
	 * 页面内容输出
	 * @param boolean $fetch 是否提取输出结果
	 * @param string 如果$fetch值为true,则返回页面HTML文本内容,否则直接输出
	 */
	function output($fetch=false) {
		if (!isset($this->params['template'])) {
			$offsetPath = substr($this->app->cfg['path']['current'],
								 strlen($this->app->cfg['path']['root']));
			$this->params['template'] = $offsetPath . $this->app->name 
					. $this->app->module . '.tpl';
		}
		if ($fetch) {
			return $this->smarty->fetch($this->params['template']);
		} else {
			$this->smarty->display($this->params['template']);
		}
	}
}
?>