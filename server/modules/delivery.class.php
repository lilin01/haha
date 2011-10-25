<?php
/**
 * 获得和广告点击转向相关的处理
 * <strong>jacklee.tj@gmail.com</strong>
 * @author Jack Lee<jacklee.tj@gmail.com>
 * $Id: delivery.class.php 96 2011/11/ 16.14:10Z jacklee $
 */



/**
 * 查询用户是否存在
 * @package modules
  * $id$
 */
class delivery {


	private $_obj_db_r;
	

	function __construct()
	{
		//global $app;
		//$this->_obj_db_r = $app->orm()->query();
	}
	
	
	/*
	 * 根据给定的appid返回banner代码
	 * @param int $app_id 要获得应用的id
	 * @return Array 针对于该应用的banner数组  
	 */
	function getBannerByAppid($apid=0){
		global $app;
		$db_r = $app->orm($app->cfg['db_r']['params'])->query();	
			
		$ads_arr = $db_r->addTable('advertisement')
						  ->addField('adid')
						  ->addField('apid')
						  ->addField('popupdesc')
						  ->addField('img')
						  ->addField('imghover')
						  ->addWhere('apid',$apid,_ORM_OP_NEQ)
						  ->addWhere('enabled',"1",_ORM_OP_EQ)
						  ->addWhere('islive',"1",_ORM_OP_EQ)
						  ->getArray(null,0,1);
		$this->updImpressions($ads_arr);						  
		return $ads_arr;				  
	}//getBannerByAppid
	
	
	/*
	 * 
	 * 
	 */
	function getGameUrlByApid($apid){
		
	}//getGameUrlByApid
	
	/*
	 * 对apid进行签名
	 * return string iid 签名后的apid
	 */
	function encodeApid(){
		
	}//encodeApid

	
	
	/*
	 * 更新所呈现广告的计数器Impressions
	 * @parm Array $ads_arr
	 */
	function updImpressions($ads_arr){
		
		if(!is_array($ads_arr) || count($ads_arr) <= 0){
			return;
		}//if
		
		$adids_arr = Array();
		foreach($ads_arr  as $ads_row){
			isset($ads_row["adid"]) && array_push($adids_arr,$ads_row["adid"]);
		}//foreach
		
		/*更新数据库*/
		global $app;
		$db_w = $app->orm($app->cfg['db_w']['params'])->query();
		$db_w->clear();
		$db_w->addTable('advertisement');
		$db_w->addValue('impressions', "`impressions`+1", 'sql');
		$db_w->addWhere('adid',$adids_arr,_ORM_OP_IN);
		$rs = $db_w->update();
		
	}//getBannerByAppid
	
	
	
	/*
	 * 更新相应广告的点击次数
	 */
	function updClick($appid=0,$adid=0){
		global $app;
		$db_w = $app->orm($app->cfg['db_w']['params'])->query();
		$db_w->clear();
		$db_w->addTable('advertisement');
		$db_w->addValue('clicks', "`clicks`+1", 'sql');
		$db_w->addWhere('adid', $adid);
		$rs = $db_w->update();
			
	}//updClick
}