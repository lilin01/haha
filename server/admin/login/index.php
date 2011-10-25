<?php
/**
 * user login page
 * <strong>jacklee.tj@gmail.com</strong>
 * @author Jack Lee<jacklee.tj@gmail.com>
 * $Id: index.php 96 2010/10/26 16.14:10Z jacklee $
 */

require_once('../../common.inc.php');
/*　
*  文件起始页面
*　 @package	admin	
*/
class index extends Action {

	public function __construct()
	{
		global $app;
		$this->app = $app;			
		$this->log = $this->app->log();
	}
		
	public function doDefault(){
		$smarty = $this->app->page();
		$smarty->output();
	}
	
	public function doLogin(){
		//print_r($_POST);
		$this->doDefault();
	}
	
}

$app->run();