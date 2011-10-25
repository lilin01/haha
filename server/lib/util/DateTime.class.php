<?php

/**
 *  DateTime 类 
 *
 * @package lib
 * @subpackage util
 * @author 张立冰 <roast@php.net>
 */
class DateTime {  

	/**
	 * @var int $firstDayOfWeek 一周第一天是星期几0表示星期天
	 * @access private
	 */
	private $firstDayOfWeek = 1;

	/**
	 * @var string $datetime 日期时间字符串
	 * @access private
	 */
	private $datetime;

	/**
	 * @var string $date 日期字符串
	 * @access private
	 */
	private $date;

	/**
	 * @var int $timestamp 时间戳
	 * @access private
	 */
	private $timestamp;

	/**
	 * 构造函数
	 * @param string $date 日期时间字符串格式为0000-00-00 00:00:00可以没有时间
	 */
	public function __construct ($date = NULL) {
		$this->setDateTime($date);
	}

	/**
	 * 设置当前时区
	 * @param string $timezone 时区
	 * @return void
	 */
	public function setDefaultTimezone($timezone) {
		date_default_timezone_set($timezone);
		return;
	}

	/**
	 * 设置日期时间
	 * @param string $date
	 * @return void
	 */
	public function setDateTime($date=NULL) {
		if ($date) {
			if (!is_numeric($date)) {
				$this->timestamp = $this->toTimeStamp($date);
			} else {
				$this->timestamp = (int)$date;
			}
		} else {
			$this->timestamp = time();
		}
		$this->datetime = $this->format();
		$this->date      = $this->format('date');
	}

	/**
	 * 时间相加运算
	 * @param int $increment 增量
	 * @param string $unit 单位
	 * @param string $returnFormat 返回的时间格式
	 * @return void
	 */
	public function add($increment, $unit='s', $returnFormat = NULL) {
		$increment = intval($increment);
		$source = $this->timestamp;
		switch ($unit)
		{
			case 'yy' : $result = $source + $increment * 31536000;	break;	//年
			case 'mm' : $result = $source + $increment * 2592000;	break;	//月
			case 'dd' : $result = $source + $increment * 86400;		break;	//日
			case 'h'  : $result = $source + $increment * 3600;		break;	//时
			case 'm'  : $result = $source + $increment * 60;		break;	//分
			default	  : $result = $source + $increment;				break;	//秒
		}
		if ($returnFormat) {
			$result = $this->format($returnFormat, $result);
		}
		return $result;
	}
	
	public static function transform($formatTo = 'date',$source) {
		if(!$source) {
			return 0;
		}
		if (!is_numeric($source)) {
			$source = DateTime::toTimeStamp($source); 
		}
		if ($formatTo!='timestamp') {
			switch (strtolower($formatTo))
			{
				case 'chinese' : //中文格式串“YYYY年MM月DD日 HH:MM:SS”
					$result = date('Y年m月d日 H:i:s', $source); break ;
				case 'cdate':
					$result = date('Y年m月d日', $source); break ;
				case 'date':
					$result = date('Y-m-d', $source); break ;
				case 'time':
					$result = date('H:i:s', $source); break ;
				case 'standard' : //标准格式串“YYYY-MM-DD HH:MM:SS”
					$result = date('Y-m-d H:i:s', $source); break;
				default : 
					$result = date($formatTo, $source);
			}
		} else {
			$result = $source;
		}
		return $result;
	}

	/**
	 * 时间相减运算
	 * @param string $source 原时间
	 * @param string $dest 目标时间
	 * @param string $unit 单位
	 * @param bool $roundIt 是否将结果四舍五入
	 * @return int
	 */
	public static function compare($source, $dest, $unit, $roundIt = false) {
		if ($source&&$dest)
		{
			if (is_object($source) && get_class($source)=='DateTime') {
				$source = $source->getTimeStamp();
			}
			if (is_object($dest) && get_class($dest)=='DateTime') {
				$dest = $dest->getTimeStamp();
			}
			if (!is_numeric($source)) {
				$source = DateTime::toTimeStamp($source); 
			}
			if (!is_numeric($dest)) {
				$dest = DateTime::toTimeStamp($dest);
			}
			$result = $source - $dest ;
			if ($result!=0)	{
				switch ($unit) {
					case 'yy' : $result = $result/31536000;	break;	//年
					case 'mm' : $result = $result/2592000;	break;	//月
					case 'dd' : $result = $result/86400;	break;	//日
					case 'h'  : $result = $result/3600;		break;	//时
					case 'm'  : $result = $result/60;		break;	//分
					default	  : break;								//秒
				}
			}
			if ($roundIt) {
				$result = intval(round($result));
			}
		} else {
			$result = false ;
		}
		return $result;
	}

	/**
	 * 日期所在月的天数
	 * @return int
	 */
	public function daysOfMonth ($year=NULL,$month=NULL) {
		if ($year===NULL) {
			$year = $this->getPart('yy');
		}
		if ($month===NULL) {
			$month = $this->getPart('mm');
		}
		if ($month==2)
		{
			if (($year % 4 == 0 && $year % 100 != 0) || $year % 400 == 0)
				$result = 29;
			else
				$result = 28;
		}
		elseif ($month == 4 || $month == 6 || $month == 9 || $month == 11)
			$result = 30;
		else
			$result = 31;
		return $result;
	}

	/**
	 * 日期所在月的第一天日期
	 * @return int
	 */
	public function getFirstDayOfMonth ($format = 'timestamp') {
		$day = $this->getPart('yy') . '-' . $this->getPart('mm') . '-' . '01';
		if ($format=='timestamp') {
			$day = (int)$this->toTimeStamp($day);
		}
		return $day;
	}
	/**
	 * 日期所在月的最后一天日期
	 * @return int
	 */
	public function getLastDayOfMonth ($format = 'timestamp') {
		$day = $this->getPart('yy') . '-' . $this->getPart('mm') . '-' . $this->daysOfMonth();
		if ($format=='timestamp') {
			$day = (int)$this->toTimeStamp($day);
		}
		return $day;
	}

	/**
	 * 格式化输出日期
	 * @param string $formatTo 日期格式
	 * @return int
	 */
	public function format ($formatTo='standard',$timestamp = NULL) {
		if ($timestamp!==NULL) {
			$source = $timestamp;
			if (!$source) {
				return '';
			}
		} else {
			$source = $this->timestamp;
		}
		
		switch (strtolower($formatTo))
		{
			case 'chinese' : //中文格式串“YYYY年MM月DD日 HH:MM:SS”
				$result = date("Y年m月d日 H:i:s", $source); break ;
			case 'cdate':
				$result = date("Y年m月d日", $source); break ;
			case 'date':
				$result = date("Y-m-d", $source); break ;
			case 'time':
				$result = date("H:i:s", $source); break ;
			case 'month':
				$result = date("m月", $source); break ;				
			case 'standard' : //标准格式串“YYYY-MM-DD HH:MM:SS”
				$result = date("Y-m-d H:i:s", $source); break;
			default : 
				$result = date($formatTo, $source);
		}
		return $result;
	}	

	public function getQuarter() {
		$month = $this->getPart('mm');
		if ($month<=3) {
			return 1;
		} else if ($month>=4 && $month<=6) {
			return 2;
		} else if ($month>=7 && $month<=9) {
			return 3;
		} else {
			return 4;
		}
	}
	
	public function getFirstDayOfQuarter($format='timestamp') {
		$quarter = $this->getQuarter();
		$year = $this->getPart('yy');
		switch ($quarter) {
		case 1:
			$month = 1;
			break;	
		case 2:
			$month = 4;
			break;	
		case 3:
			$month = 7;
			break;	
		default :
			$month = 10;
			break;	
		}
		$day = $year . '-' . $month . '-' . '01';
		
		if ($format=='timestamp') {
			$day = (int)$this->toTimeStamp($day);
		}
		return $day;
	}
	
	public function getLastDayOfQuarter($format='timestamp') {
		$quarter = $this->getQuarter();
		$year = $this->getPart('yy');
		switch ($quarter) {
		case 1:
			$month = 4;
			break;	
		case 2:
			$month = 6;
			break;	
		case 3:
			$month = 9;
			break;	
		default :
			$month = 12;
			break;	
		}
		$dd = $this->daysOfMonth($year,$month);
		$day = $year . '-' . $month . '-' . $dd;
		
		if ($format=='timestamp') {
			$day = (int)$this->toTimeStamp($day);
		}
		return $day;
	}
	
	public function getPeriod() {
		$day = $this->getPart('dd');
		if ($day<11) {
			return 1;
		} else if ($day>=11 && $day<=20) {
			return 2;
		} else {
			return 3;
		}
	}
	
	/**
	 * 取日期的一个部份
	 * @param string $part 部分的格式
	 * @return string
	 */
	public function getPart ($part) {
		$source = $this->timestamp;
		switch($part)
		{
			case 'yy' : $result = intval(date("Y", $source)); break; //年
			case 'mm' : $result = intval(date("m", $source)); break; //月
			case 'dd' : $result = intval(date("d", $source)); break; //日
			case 'w'  : $result = intval(date("N", $source)); break; //星期 [1-7] "1"表示星期一
			case 'cw' : $index = date("N", $source); //中文星期
						$week_array = array('1'=>'一', '2'=>'二', '3'=>'三', '4'=>'四', '5'=>'五', '6'=>'六', '7'=>'日');
						$result = '星期' . $week_array[$index];
						break;
			case 'h'  : $result = intval(date("H", $source)); break; //时
			case 'm'  : $result = intval(date("i", $source)); break; //分
			case 's'  : $result = intval(date("s", $source)); break; //秒
			case 'yw' : $result = intval(date("W", $source)); break; //一年中第几周
			case 'yd' : $result = intval(date("z", $source)); break; //一年中第几天
			default   :  //全部
				$week_array = array('1'=>'一', '2'=>'二', '3'=>'三', '4'=>'四', '5'=>'五', '6'=>'六', '7'=>'日');
				$result = array(
						'yy' => intval(date("Y", $source)), //年
						'mm' => intval(date("m", $source)), //月
						'dd' => intval(date("d", $source)), //日
						'w'  => intval(date("N", $source)), //星期 [1-7] "1"表示星期一
						'cw' => '星期' . $week_array[date("N", $source)], //中文星期
						'h'  => intval(date("H", $source)), //时
						'm'  => intval(date("i", $source)), //分
						's'  => intval(date("s", $source)), //秒
						);
				break;
		}
		return $result;
	}

	/**
	 * 把日期转换成时间戳
	 * @param string $dateTimeString 日期时间
	 * @return int
	 */
	public function toTimeStamp ($dateTimeString = NULL) {
		if (!$dateTimeString) {
			$dateTimeString = $this->datetime;
		}
		$numeric = '';
		$add_space = false;
		for($i=0;$i<strlen($dateTimeString);$i++) {
			if(strpos('0123456789',$dateTimeString[$i])===false) {
				if($add_space) {
					$numeric .= ' ';
					$add_space = false;
				}
			} else {
				$numeric .= $dateTimeString[$i];
				$add_space = true;
			}
		}
		
		$numeric_array = explode(' ',$numeric,6);
		if(sizeof($numeric_array)<3 || ($numeric_array[0]==0 && $numeric_array[1]==0 && $numeric_array[2]==0)) {
			throw new Exception($dateTimeString . ' is an invalid parameter', 5);
		} else {
			$result = mktime(intval($numeric_array[3]),	intval($numeric_array[4]), intval($numeric_array[5]),
								intval($numeric_array[1]), intval($numeric_array[2]), intval($numeric_array[0])) ;
		}
		
		return $result;
	
	}

	/**
	 * 取本周第一天的日期
	 * @return string
	 */
	public function getFirstDayOfWeek ($format='') {
		$todayOfWeek = $this->getPart('w');
		
		/* 此处还有问题 */
		$firstDay = $this->add($this->firstDayOfWeek-$todayOfWeek,'dd',$format);
		return $firstDay;
	}
	
	/**
	 * 取当天凌晨0点时间戳
	 * @return interger
	 */
	 public static function getTodayTimestamp(){
	 	return mktime(0, 0, 0, (int)date('m'), (int)date('d'), (int)date('Y'));
	 }

	/**
	 * 取时间戳
	 * @return int
	 */
	public function getTimeStamp() {
		return $this->timestamp;
	}

	/**
	 * 取时间日期串
	 * @return string
	 */
	public function getDateTime() {
		return $this->datetime;
	}

	/**
	 * 取日期串
	 * @return string
	 */
	public function getDate() {
		return $this->date;
	}

	/**
	 * 设置每周第一天是星期几
	 * @param string $week 星期0-6
	 * @return void
	 */
	public function setFirstDayOfWeek($week = 1) {
		$this->firstDayOfWeek = $week;
	}
	
	/**
	 * 时间转换成秒数，类似时间戳
	 * @param string $time
	 * @return int
	 */
	public static function timeToSec($time) {
		if (!$time) return 0;
		$p = explode(':',$time);
		$c = count($p);
		if ($c>1) {
			$hour    = intval($p[0]);
			$minute  = intval($p[1]);
			$sec     = intval($p[2]);
		} else {
			throw new Exception('error time format');
		}
		$secs = $hour*3600 + $minute*60 + $sec;
		return $secs;
	}
	
}
?>