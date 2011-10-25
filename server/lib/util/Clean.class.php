<?php
/**
 *  输入输出数据过滤检测类
 *
 * @package lib
 * @subpackage util
 * @author 张立冰 <roast@php.net>
 * $Id: Clean.class.php 3286 2009-02-19 03:38:16Z zhuxin $
 */

class Clean 
{
    /**
     * 清除所有的HTML标记，只返回文本    --此函数有待加强
     *
     * @param String $string
     * @return String
     */
    static public function text($string)
    {
        return strip_tags($string);
    }
    
    
    /**
     * 过滤HTML文本中的非法标记等可能存在安全问题的字符
     *
     * @param String    $html
     * @return String
     */
    static public function htmlSafe($html)
    {
        //转换&、<、>
        $html = str_replace(array('&amp;', '&lt;', '&gt;'), array('&amp;amp;', '&amp;lt;', '&amp;gt;'), $html);
        
        //将换行标记进行连接(\n)
        $html = preg_replace('#(&\#*\w+)[\x00-\x20]+;#u', "$1;", $html);
        $html = preg_replace('#(&\#x*)([0-9A-F]+);*#iu', "$1$2;", $html);   
        
        //进行编码转换
        $html = html_entity_decode($html, ENT_COMPAT, 'UTF-8');  
         
        //去除所有标签中on开头或者xmlns的属性
        $html = preg_replace('#(<[^>]+[\x00-\x20\"\'\/])(on|xmlns)[^>]*>#iUu', "$1>", $html); 
        
        //去除javascript和vbscript
        $html = preg_replace('#([a-z]\*)[\x00-\x20]\*=[\x00-\x20]\*([\`\'\"]\*)[\\x00-\x20]\*j[\x00-\x20]\*a[\x00-\x20]\*v[\x00-\x20]\*a[\x00-\x20]\*s[\x00-\x20]\*c[\x00-\x20]\*r[\x00-\x20]\*i[\x00-\x20]\*p[\x00-\x20]\*t[\x00-\x20]\*:#iU','',$html);
        $html = preg_replace('#([a-z]*)[\x00-\x20\/]*=[\x00-\x20\/]*([\`\'\"]*)[\x00-\x20\/]*j[\x00-\x20]*a[\x00-\x20]*v[\x00-\x20]*a[\x00-\x20]*s[\x00-\x20]*c[\x00-\x20]*r[\x00-\x20]*i[\x00-\x20]*p[\x00-\x20]*t[\x00-\x20]*:#iUu', '', $html);
        
        $html = preg_replace('#([a-z]\*)[\x00-\x20]\*=([\'\"]\*)[\x00-\x20]\*v[\x00-\x20]\*b[\x00-\x20]\*s[\x00-\x20]\*c[\x00-\x20]\*r[\x00-\x20]\*i[\x00-\x20]\*p[\x00-\x20]\*t[\x00-\x20]\*:#iU','',$html);
        $html = preg_replace('#([a-z]*)[\x00-\x20\/]*=[\x00-\x20\/]*([\`\'\"]*)[\x00-\x20\/]*v[\x00-\x20]*b[\x00-\x20]*s[\x00-\x20]*c[\x00-\x20]*r[\x00-\x20]*i[\x00-\x20]*p[\x00-\x20]*t[\x00-\x20]*:#iUu', '', $html);
        
        $html = preg_replace('#([a-z]*)[\x00-\x20\/]*=[\x00-\x20\/]*([\`\'\"]*)[\x00-\x20\/]*-moz-binding[\x00-\x20]*:#Uu', '', $html);
        $html = preg_replace('#([a-z]*)[\x00-\x20\/]*=[\x00-\x20\/]*([\`\'\"]*)[\x00-\x20\/]*data[\x00-\x20]*:#Uu', '', $html);
        
        //将带有注释的Style全部删除
        $html = preg_replace('#style([a-z]*)[\x00-\x20\/]*=[\'"]*[^\*\/>]*[\*\/]+[^\*\/>]*>#iU','>',$html);
        
        //将带有url和expression的样式全部删除
        $html = preg_replace('#style([a-z]*)[\x00-\x20\/]*=[\'"]*(url|expression)[\'"]*#iU','',$html);
        
        //移除所有名字空间元素
        $html = preg_replace('#<\?import[^>]+>#iU','',$html);
        $html = preg_replace('#<\?xml:namespace[^>]+>#iU','',$html);
        
        //删除不需要的标记
        do {
            $o_html = $html;
            $html = preg_replace('#</*(applet|meta|xml|blink|link|style|script|iframe|frame|frameset|ilayer|layer|bgsound|title|base|input)[^>]*>#i', "", $html);
        } while ($o_html != $html); 
               
        return $html;
    }
}
?>