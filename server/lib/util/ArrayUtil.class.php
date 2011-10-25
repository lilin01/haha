<?php

/**
 *  数组工具类
 *
 * @package lib
 * @subpackage util
 * @author 张立冰 <roast@php.net>
 */
class ArrayUtil {
	
	public static $keys;
	public static $order;
	
	/**
	 * 搜索数组中符合条件的值
	 * 如果$keys=NULL且$onlyFirst=true的情况建议使用内建函数array_search()代替该方法
	 *
	 * @param array $array 被搜索的数组
	 * @param mixed $value 要查询的值 
	 * @param mixed $keys 深入搜索的键列表,不深入搜索则赋值为NULL,值可以是字符串或字符串数组类型
	 * @param boolean $onlyFirst 是否只搜索第一个
	 * @return mixed 搜索到一个则返回该数组元素,搜索到两个以上则返回结果数组,否则返回-1
	 */
	public static function search(& $array, $value, $keys = NULL, $onlyFirst = false) {
		$result = array();
		foreach ($array as $v) {
			switch (gettype($keys)) {
				case 'string': $arrayValue = $v[$keys]; break;
				case 'array':
					$arrayValue = $v;
					foreach ($keys as $key) {
						$arrayValue = $arrayValue[$key];
					}
					break;
				default: $arrayValue = $v; break;
			}
			if ($arrayValue == $value) {
				$result[] = $key;
				if ($onlyFirst) {
					break;
				}
			}
		}
		$count = count($result);
		return ($count < 1) ? -1 : (($count == 1) ? $result[0] : $result);
	}
	
	/**
	 * 插入指定的$key值前插入数据$value
	 * @param array $array 操作的数组
	 * @param string $key 键值,设置为NULL可以让数据添加到数组尾部
	 * @param mixed $value 值
	 * @param boolean $before 是否插入在指定$key之前
	 * @return boolean 如果找到$key并插入成功则返回true,否则返回false,并把数据添加到数组尾部
	 */
	public static function insert(& $array, $key, $newValue, $before = true) {
		$inserted = false;
		$size = sizeof($array);
		for ($i=0; $i<$size; $i++) {
			$value = array_shift($array);
			if ($i == $key) {
				if ($before) {
					array_push($array, $newValue);
					array_push($array, $value);
				} else {
					array_push($array, $value);
					array_push($array, $newValue);
				}
				$inserted = true;
			} else {
				array_push($array, $value);
			}
		}
		(!$inserted) && array_push($array, $newValue);
		return $result;
	}
	
	/**
	 * 删除key为指定的key里的值
	 * @param array $array 操作的数组
	 * @param string $keys 键值可以是数组
	 * @return void
	 */
	public static function delete(& $array, $keys) {
		(!is_array($keys)) && $keys = array($keys);
		foreach ($keys as $key) {
			unset($array[$key]);
		}
		//$array = array_values($array);
	}
	
	/**
	 * 对数组排序,如果做简单排序建议使用PHP内建函数
	 * 
	 * @param array $array 操作的数组
	 * @param string $byKey true按键排序,false按值排序,为字符串或数组则作为键名做深入比较按值排序
	 * @param string $orderBy 排序方式asc顺序desc逆序
	 * @return void
	 */
	public static function sort(& $array, $byKey = false, $orderBy = 'asc') {
		if (is_bool($byKey)) {
			if ($byKey) {
				($orderBy == 'asc') ? ksort($array) : krsort($array);
			} else {
				($orderBy == 'asc') ? asort($array) : arsort($array);
			}
		} else {
			foreach ($array as $k => $v) {
				$temp[$k] = $v[$byKey];
			}
			($orderBy == 'asc') ? asort($temp) : arsort($temp);
			$newarray = array();
			foreach ($temp as $k => $v) {
				$newarray[$k] = $array[$k];
			}
			$array = $newarray;
		}
	}
}
?>