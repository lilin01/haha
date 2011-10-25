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
class Relic extends Action {

	public function construct()
	{
		global $app;
		$this->app = $app;			
		$this->log = $this->app->log();
	}
		
	public function doDefault(){
	}
	
	public function doRelicList(){
		$apid = 0;
		$obj = Array('status'=>"1"
									,"data"=>array(
													'1'=>array(
														'relicid' = '1'
														,'img' = 'relic1.png'
														,'name'=>'100'
														,'desc'=>'100'
														,'buyprice'=>'100'
														,'sellprice'=>'100'
														,'requirelevel'=>'100'
														,'isnew'=>'1'
										)
								 );

		$this->output($obj);
	}
}

$app->run();