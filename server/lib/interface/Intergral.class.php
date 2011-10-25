<?php

/**
 * 积分处理相关的接口类
 * 
 * @package lib
 * @subpackage interface
 * @author 张立冰 <roast@php.net>
 * 
 * $Id: Intergral.class.php 1 2008-08-14 10:05:35Z libing $
 */

/**
 * 积分处理相关的接口类,全静态方式调用
 *
 * @package interface
 * @author 张立冰 <roast@php.net>
 */
Class Intergral 
{        
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
    protected function _soap($interface, $uri, $op, $args)
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
            $out .= "Host: " . $interface . "\r\n";
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
}
?>