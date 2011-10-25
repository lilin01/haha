<?php
/**
 * app object data file provide data
 * <strong>jacklee.tj@gmail.com</strong>
 * @author Jack Lee<jacklee.tj@gmail.com>
 * $Id: applist.class.php 96 2011/11/ 16.14:10Z jacklee $
 */



/**
 * 查询用户是否存在
 * @package modules
  * $id$
 */
class applist {


	private $_obj_db_r;

	function __construct()
	{
		global $app;
		//$this->_obj_db_r = $app->orm()->query();
	}
	
	
	/*
	 * 根据给定的appid返回banner代码
	 * @param int $app_id 要获得应用的id
	 * @return string 针对于该应用的banner代码  
	 */
	function getBannerByAppid($app_id){
		
		echo "ok";
		/*
		$user_info = $this->_obj_db_r->query()
								->addTable('advertisement')
								->getArray();
		*/
		//$user_info = $this->_obj_db_r->query()->exec("select * from advertisement"); 
		
	//	print_r($user_info);
		
		
	}
}