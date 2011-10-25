<?php
/**
 * user login page
 * <strong>jacklee.tj@gmail.com</strong>
 * @author Jack Lee<jacklee.tj@gmail.com>
 * $Id: index.php 96 2010/10/26 16.14:10Z jacklee $
 */

require_once('../common.inc.php');
importModule("delivery");
import("util.Json");
/*　
*  文件起始页面
*　 @package	admin	
*/
class jsonbar extends Action {

	public function __construct()
	{
		global $app;
		$this->app = $app;			
		$this->log = $this->app->log();
	}
		
	public function doDefault(){
		
		
		echo (isset($_GET["callback"])) ? $_GET["callback"] : exit("json parm error") ;
		
		$this->getjsonbar($_GET["apid"]);
		//$smarty = $this->app->page();
		//$smarty->output();
	}
	
	
	/*
	 * 返回广告条json数据
	 * @parm $apid 应用id
	 */
	public function getjsonbar($apid){
		$delivery_o = new delivery();
		$ads_arr = $delivery_o->getBannerByAppid($apid);
		
		$jsonarray = array();
	
		empty($ads_arr) && exit("");
		
		$jsonarray["g"] = array(array("i"=>"http://localhost/ads/" . $ads_arr[0]["img"]
									,"h"=>"http://localhost/ads/" . $ads_arr[0]["imghover"]
									,"l"=>"http://localhost/delivery/link.php?apid=" . $ads_arr[0]["apid"] . "&amp;adid=" . $ads_arr[0]["adid"] . "&amp;iid=4cd66a24a62b8f824a621000"
									,"d"=>"Make Cupcakes & Sweet Treats with Friends!"
									,"u"=>1
									,"m"=>array()
									)
								);
		
		$jsonarray["f"] = array();
		$jsonarray["t"] =  array( "b" =>"#26addc"
									   ,"h" =>"#2ec2f6"
									   ,"nh"=>"#fa913b"
									   ,"s" =>"http://cdn.applifier.com/images/a-blue.png"
										);
		$jsonarray["l"] = array("p"=>"Try new games and apps with The911"
								   ,"f"=>"Favorites"
								   ,"i"=>"http://cdn.applifier.com/images/identity-mask.png"
									);;
		$jsonarray["os"] = false;

		$json = new Json();
		
		$output = $json->encode($jsonarray);
		
		echo "($output)";
		
	}//getjsonbar
	

}//jsonbar

$app->run();