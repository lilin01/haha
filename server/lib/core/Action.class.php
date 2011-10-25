<?php

/**
 * Action类
 *
 * @package lib
 * @subpackage core
 * @author 张立冰 <roast@php.net>
 */
class Action {
	
	/**
	 * 应用程序类
	 * @var Application
	 * @access protected
	 */
	var $app;

	/**
	 * 构造函数(兼容PHP4)
	 * @param Application &$app 应用程序类
	 */
	function Action(& $app) {
		$this->__construct($app);
	}
	
	/**
	 * 构造函数
	 *
	 * @param Application &$app 应用程序类
	 */
	function __construct(& $app) {
		$this->app = $app;
		
		if ((LOGIN_CHECK === true) && empty($_SESSION['uid']))
		{
            //login check
		}
	}
	
	/**
	 * 默认Action
	 */
	function doDefault() { /* nothing */ }
	
	
	/**
	 * 通过FriePHP进行调试，将调试信息输出到头消息中
	 *
	 * 相关链接：http://www.firephp.org/
	 * 
	 * @return void
	 */
	function debug()
	{
		if (DEBUG)
		{
			$instance = FirePHP::getInstance(true);
			  
			 $args = func_get_args();
			 return call_user_func_array(array($instance,'fb'),$args);
			      
			 return true;				
		}
	}
	
	
	/**
	 * 输出验证输出处理 
	 */
	function doCode() 
	{
		import('util.ValidateCode');
		$img = new ValidateCode();
		
		/** 设置字体文件与临时目录 **/
		$img->font_dir = $this->app->cfg['path']['fonts'];
		$img->temp_dir = $this->app->cfg['path']['temp'];
		
		$img->session_name='VALIDATE_CODE';
		$img->background_color(array('#FEFDCF','#DFFEFF','#FFEEE1','#E1F4FF'));
		$img->grid_color(array('#FAD1AD','#FFD9FB','#D1D1E0'));
		$img->text_color(array('#801D00','#5C0497','#0289B0'));
		$img->overlap_text(false);
		$img->random_y_factor(4);
		$img->string_length(4);
		$img->frame_number(3);
		$img->frame_delay(80);
		$img->generate();
	}
	
	
	/**
	 * 验证验证码是否正确
	 *
	 * @param string $code
	 * @return boolean
	 */
	function _checkCode($code)
	{
		return ($code == $_SESSION['VALIDATE_CODE']);
	}
	
	
	/**
	 * 执行SOAP请求，返回请求得到的数据段切分为数组,简单方法
	 *
	 * @param String $interface WS接口地址
	 * @param String $uri SOAP调用的地址
	 * @param String $op SOAP调用的方法
	 * @param Array $args 传递的参数数据
	 * 
	 * @return Array|false	false表示调用失败，否则返回查询到的数据数组 
	 */
    function _soap($interface, $uri, $op, $args)
    {
        $fp = fsockopen($interface, 80, $errno, $errstr, 30);
        if (!$fp)
            return false;
        else
        {
            $content .= '<?xml version="1.0" encoding="utf-8"?>';
            $content .= '<soap:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/">';
            $content .= '<soap:Body>';
            $content .= '<' . $op . ' xmlns="http://tempuri.org/">';
            if ( is_array($args))
            {
                foreach ( $args as $key=>$value)
                    $content .= '<' . $key . '>' . $value . '</' . $key . '>';
            }
            $content .= '</' . $op . '>';
            $content .= '</soap:Body>';
            $content .= '</soap:Envelope>';
            
            $out = "POST /" . $uri . " HTTP/1.1\r\n";
            $out .= "Host: " . $this->interface . "\r\n";
            $out .= "Content-Type: text/xml; charset=utf-8\r\n";
            $out .= "Content-Length: " . strlen($content) . "\r\n";
            $out .= "SOAPAction: \"http://tempuri.org/" . $op . "\"\r\n\r\n";

            fwrite($fp, $out . $content);
            sleep(1);
            
            $ret = fread($fp, 10240);
            fclose($fp);
                       
            if ( preg_match('/<soap:Body>(.+)<\/soap:Body>/', $ret, $mc) )
                preg_match_all('/<([^>\/]+)>([^>\/]+)<\/([^>\/]+)>/', $mc[1], $tmp);
            
            if ( count($tmp) != 4 )
                return false;
            else
                return array_combine($tmp[1], $tmp[2]);
        }
    }


	/**
	 * 讲数组中的值进行json编码然后输出到浏览器，主要用户和前端flash通信使用
	 *
	 * @param Array $array 要答应的数组
	 */
	function output($array){
			echo json_encode($array);
	}
}
?>