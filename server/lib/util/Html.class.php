<?php

/**
 *  Html 类
 *
 * @package lib
 * @subpackage util
 * @author 张立冰 <roast@php.net>
 */
class Html {
	/**
	 * @var string $output html内容
	 * @access private
	 */
	private $output = '';
	/**
	 * @var bool $inJsArea 是否在js代码区域内
	 * @access private
	 */
	private $inJsArea = false;

	/**
	 * 添加html标签
	 * @param string $tag 标签名
	 * @param mixed $attribute 属性
	 * @param string $content 内容
	 * @return string 返回生成的HTML标签
	 */
	public function addTag($tag, $attribute = NULL, $content = NULL) {
		$this->js();
		$html = '';
		$tag = strtolower($tag);
		$html .= '<' . $tag;
		if ($attribute != NULL) {
			if (is_array($attribute)) {
				foreach ($attribute as $key=>$value) {
					$html .= ' ' . strtolower($key) . '="' . htmlentities($value) . '"';
				}
			} else {
				$html .= ' ' . $attribute;
			}
		}
		$html .= ($content) ? ('>' . $content . '</' . $tag . '>') : ' />';
		$this->output .= $html;
		return $html;
	}
	
	/**
	 * 添加html文本
	 * @param string $content 内容
	 * @return string
	 */
	public function addText($content) {
		$this->js();
		$content = htmlentities($content);
		$this->output .= $content;
		return $content;
	}
	
	/**
	 * 添加js代码
	 * @param string $jscode js代码
	 * @param bool $end 是否关闭js 代码块
	 * @return void
	 */
	public function js($jscode = NULL, $end = false) {
		if (!$this->inJsArea && $jscode) {
			$this->output .= '<script language="JavaScript" type="text/javascript">' . chr(13)
							 . '//<![CDATA[' . chr(13);
			$this->inJsArea = true;
		}
		($jscode) && $this->output .= $jscode . chr(13);
		if (($jscode == NULL || $end) && $this->inJsArea) {
			$this->output .= chr(13) . '//]]>' . chr(13) . '</script>';
			$this->inJsArea = false;
		}
	}
	
	/**
	 * 添加js提示代码
	 * @param string $message 提示内容
	 * @param bool $end 是否关闭js 代码块
	 * @return void
	 */
	public function jsAlert($message, $end = false) {
		$this->js('alert("' . strtr($message, '"', '\\"') . '");', $end);
	}
	
	/**
	 * 添加js文件包含
	 * @param string $fileName 文件名
	 * @param bool $defer 是否添加defer标记
	 * @return string 返回生成的HTML标签
	 */
	public function jsInclude($fileName, $defer = false) {
		$this->js();
		$html = '<script language="JavaScript" type="text/javascript" src="' 
				. $fileName . '"' . ( ($defer) ? ' defer="1"' : '' ) . '></script>';
		$this->output .= $html;
		return $html;
	}
	
	/**
	 * 添加css文件包含
	 * @param string $fileName 文件名
	 * @return string 返回生成的HTML标签
	 */
	public function cssInclude($fileName) {
		$this->js();
		$html = '<LINK href="' . $fileName . '" rel="stylesheet" />';
		$this->output .= $html;
		return $html;
	}
	
	/**
	 * 输出html内容
	 * @param bool $print 是否直接输出，可选，默认返回
	 * @return string 返回输出的HTML内容
	 */
	public function output($print = false) {
		$this->js();
		$output = $this->output;
		if ($print) {
			echo $output;
		}
		$this->output = '';
		return $output;
	}
}
?>