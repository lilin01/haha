<?php
/**
 * user login page
 * <strong>jacklee.tj@gmail.com</strong>
 * @author Jack Lee<jacklee.tj@gmail.com>
 * $Id: index.php 96 2010/10/26 16.14:10Z jacklee $
 */

require_once('./common.inc.php');

importModule('applist');




/*　
*  文件起始页面
*　 @package	admin	
*/
class User extends Action {

	public function construct()
	{
		global $app;
		$this->app = $app;			
		$this->log = $this->app->log();
	}
		
	public function doDefault(){
	}
	
	public function doUserInfo(){
		$apid = 0;
		$obj = Array('status'=>"1"
									,'data'=>array(
													'UserId'=>'100'
													,'NickName'=>'100'
													,'Gold'=>'100'
													,'Rmb'=>'100'
													,'Token'=>'100'
													,'Health'=>'100'
													,'Level'=>'100'
													,'CurrExp'=>'100'
													,'TotalExp'=>'100'
													,'ShowSpreadTip'=>'0'
													,'magicid'=>'100'
													,'districtid'=>'100'
													,'rollid'=>'100'
													,'districtid'=>'100'
													,'iFreshMan'=>'100'
													,'districtid'=>'100'
												)
								 );

		$this->output($obj);
	}
}

$app->run();