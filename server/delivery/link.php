<?php
/**
 * transport link to the specific game home page
 * <strong>jacklee.tj@gmail.com</strong>
 * @author Jack Lee<jacklee.tj@gmail.com>
 * $Id: link.php 96 2010/10/26 16.14:10Z jacklee $
 */


//apid=153&adid=1162&iid=4ccf7af2315d208b75680000


//http://localhost/delivery/link.php?apid=153&adid=1162&iid=4cd66a24a62b8f824a621000

require_once('../common.inc.php');

importModule('delivery');

/*　
*  用户点击后的处理页面，并转向到相应的游戏
*　 @package	link	
*/
class link extends Action {

	public function __construct()
	{
		global $app;
		$this->app = $app;			
		$this->log = $this->app->log();
	}
		
	public function doDefault(){
		global $app;
		//应用id
		$apid = 0;
		//相应的广告adid
		$adid  = 0;
		if (isset($_GET["apid"])&& isset($_GET["adid"])){
		  $apid = $_GET["apid"];
		  $adid  = $_GET["adid"];				
		}//if
		else{
			throwException("invaid url parms",4053);
		}//else
		
		$this->doDelivery($apid,$adid);

	}//doDefault
	
	
	/*
	 * 更新点击并转向到相应的游戏界面
	 * @parm Int $apid 应用id
	 * @parm Int $adid 广告id
	 */
	public function doDelivery($apid,$adid){
		$obj_delivery = new delivery();
		$obj_delivery->updClick($apid,$adid);
		$app->redirect();
	}//doDelivery
	
}//link

$app->run();