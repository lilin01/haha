<?php

/**
 *  ORM 数据库连接类
 *
 * @package lib
 * @subpackage plugins.orm
 * @author 张立冰 <roast@php.net>
 */
class OrmQuery {

	/**
	 * 数据库连接参数
	 *
	 * @var Array
	 */
	var $params;
	
	/**
	 * 数据库连接选项
	 *
	 * @var Array
	 */
	var $options;
	
	/**
	 * SQL分析句柄
	 *
	 * @var OrmParser
	 */
	var $parser = null;
	
	/**
	 * 用于生成SQL语句的条件数组
	 * @var array
	 * @access private
	 */
	var $sql;
	
	/**
	 * 构造函数(兼容PHP4)
	 *
	 * @param 	Array 	$params		数据库连接参数
	 * @param 	Array	$options	数据库连接选项
	 * @return OrmQuery
	 */
	function OrmQuery($params, $options) {
		$this->__construct($params, $options);
	}
	
	/**
	 * 构造函数
	 *
	 * @param 	Array 	$params		数据库连接参数
	 * @param 	Array	$options	数据库连接选项
	 * @return OrmQuery
	 */
	function __construct($params, $options) {
		$this->params = $params;
		$this->options = $options;
		$this->clear();
	}
	
	/**
	 * 生成并执行SQL,然后返回结果数据集中的第一行记录的第一格数据
	 * @param string $sql 直接执行原生SQL
	 * @return string
	 */
	function getValue($sql=NULL) {
		($sql===NULL) && $sql = $this->asSql('select');
		$data = $this->parser->getFirst($sql, _ORM_FETCH_NUM);
		return $data[0];
	}
	
	/**
	 * 生成并执行SQL,然后返回一个数组对象表示结果数据集中的第一行记录
	 * @param string $sql 直接执行原生SQL
	 * @return array()
	 */
	function getRow($sql=NULL) {
		($sql===NULL) && $sql = $this->asSql('select');
		return $this->parser->getFirst($sql);
	}
	
	/**
	 * 生成并执行SQL,然后返回一个数组表示结果数据集中的第一列数据
	 * @param string $sql 直接执行原生SQL
	 * @return Array
	 */
	function getColumn($sql=NULL) {
		$result = array();
		$list = $this->getArray($sql, 0, -1, _ORM_FETCH_NUM);
		foreach ($list as $item) {
			$result[] = $item[0];
		}
		return $result;
	}
	
	/**
	 * 生成并执行SQL,然后返回一个数组表示一个数据集
	 * @param string $sql 直接执行原生SQL
	 * @param int $offset 偏移量
	 * @param int $count 返回结果集记录条数
	 * @param int $fetchMode 记录提取模式 默认字段名(_ORM_FETCH_ASSOC)
	 * @return array
	 */
	function getArray($sql=NULL, $offset=0, $count=-1, $fetchMode=_ORM_FETCH_ASSOC) {
		($sql===NULL) && $sql = $this->asSql('select');
		return $this->parser->getAll($sql, $offset, $count, $fetchMode);
	}
		
	/**
	 * 更新数据库记录,返回受影响的记录数
	 * @param array $fields 内容为 字段名=>字段值 或者 array('name'=>字段名,'value'=>字段值,'type'=>字段类型)
	 * @return int
	 */
	function update($fields=array()) {
		if (!empty($fields)) {
			foreach ($fields as $name => $value) {
				if (is_numeric($name)) {
					$this->addValue($value['name'], $value['value'], $value['type']);
				} else {
					$this->addValue($name, $value);
				}
			}
		}
		return $this->parser->execute($this->asSql('update'));
	}
	
	/**
	 * 插入数据库新记录,返回受影响的记录数
	 * @param array $fields 内容为 字段名=>字段值 或者 array('name'=>字段名,'value'=>字段值,'type'=>字段类型)
	 * @return int
	 */
	function insert($fields=array()) {
		if (!empty($fields)) {
			foreach ($fields as $name => $value) {
				if (is_numeric($name)) {
					$this->addValue($value['name'], $value['value'], $value['type']);
				} else {
					$this->addValue($name, $value);
				}
			}
		}
		return $this->parser->execute($this->asSql('insert'));
	}
	
	/**
	 * 更新数据库记录,返回受影响的记录数,如果执行失败返回false
	 * @return int
	 */
	function delete() {
		return $this->parser->execute($this->asSql('delete'));
	}
	
	/**
	 * 执行存储过程
	 * @param string $procedureName
	 */
	function call($procedureName) {
		return $this->parser->call($procedureName);
	}
	
	/**
	 * 返回生成的SQL脚本
	 * @return string
	 */
	function asSql($type='select') {
		$this->sql['mode'] = $type;
		return $this->parser->parseSql($this->sql);
	}
	
	/**
	 * 清空表,字段,约束
	 * @param string $part 要清空的部分,默认清空全部,值可为:'table', 'field', 'value', 'where', 'group', 'order'
	 * @return OrmQuery
	 */
	function clear($part='') {
		if (in_array($part, array('table', 'field', 'value', 'where', 'group', 'order'))) {
			$this->sql[$part] = array();
		} else {
			$this->sql = array (
					'mode'		=> 'select',
					'table'		=> array(),
					'field'		=> array(),
					'value'		=> array(),
					'where'		=> array(),
					'group'		=> array(),
					'order'		=> array(),
					);
		}
		return $this;
	}
	
	/**
	 * 加入表
	 * @param string $tableName 表名
	 * @param string $alias 别名
	 * @return OrmQuery
	 */
	function addTable($tableName, $alias = '') {
		$tableName = trim($tableName);
		if (empty($tableName)) {
			throwException('表名不能为空', 4051);
		}
		$this->sql['table'][] = array(
				'name'	=> $tableName,
				'alias'	=> empty($alias) ? $tableName : $alias,
				);	
		return $this;
	}
	
	/**
	 * 加入字段
	 * @param string $fieldName 字段名
	 * @param string $alia 别名
	 * @param string $opt 操作/函数类型
	 * @param string $fieldType 字段类型
	 * @return OrmQuery
	 */
	function addField($fieldName, $alias = '', $opt = '', $fieldType = _ORM_DT_AUTO) {
		$fieldName = trim($fieldName);
		if (empty($fieldName)) {
			throwException('字段名不能为空', 4052);
		}
		$this->sql['field'][] = array(
				'name'	=> $fieldName,
				'alias'	=> empty($alias) ? $fieldName : $alias,
				'opt'		=> $opt,
				'type'	=> $fieldType,
				);
		return $this;
	}
	
	/**
	 * 加入值
	 * @param string $fieldName 字段名
	 * @param string $fieldValue 字段值
	 * @param string $fieldType 字段类型
	 * @return OrmQuery
	 */
	function addValue($fieldName, $fieldValue, $fieldType = _ORM_DT_AUTO) {
		$fieldName = trim($fieldName);
		if (empty($fieldName)) {
			throwException('字段名不能为空', 4052);
		}
		$this->sql['value'][] = array(
				'name'	=> $fieldName,
				'value'	=> $fieldValue,
				'type'	=> $fieldType,
				);
		return $this;
	}
	
	/**
	 * 加入约束条件
	 * @param string $fieldName 字段名
	 * @param mixed $value 字段值
	 * @param string $opt 操作符
	 * @param string $fieldType 字段类型
	 * @param string $logical 逻辑关系操作符
	 * @return OrmQuery
	 */
	function addWhere($fieldName, $value = '', $opt = _ORM_OP_EQ, 
			$fieldType = _ORM_DT_AUTO, $logical = _ORM_OP_AND) {
		$fieldName = trim($fieldName);
		if (empty($fieldName)) {
			throwException('字段名不能为空', 4052);
		}
		$this->sql['where'][] = array(
				'name'		=> $fieldName,
				'value'		=> $value,
				'opt'			=> $opt,
				'type'		=> $fieldType,
				'logical'		=> $logical,
				);
		return $this;
	}
	
	/**
	 * 加入分组
	 * @param string $fieldName
	 * @return string
	 * @return OrmQuery
	 */
	function addGroupBy($fieldName) {
		$fieldName = trim($fieldName);
		if (empty($fieldName)) {
			throwException('分组字段名不能为空', 4052);
		}
		$this->sql['group'][] = $fieldName;
		return $this;
	}
	
	/**
	 * 加入排序
	 * @param string $fieldName 字段名
	 * @param string $orderBy 排序方式
	 * @return OrmQuery
	 */
	function addOrderBy($fieldName, $orderBy = _ORM_OP_ASC) {
		$fieldName = trim($fieldName);
		if (empty($fieldName)) {
			throwException('排序字段名不能为空', 4052);
		}
		$this->sql['order'][] = array(
				'name'	=> $fieldName,
				'order'	=> $orderBy,
				);
		return $this;
	}
	
	/**
	 * 添加直接执行SQL的接口
	 * @return int
	 */
	function exec($sql) {
		return $this->parser->execute($sql);
	}	
	
	
	/**
	 * 获取查询对象同时对查询进行重置
	 *
	 */
	function query() {
		if ($this->parser == null)
		{
			import('plugins.orm.parser.Orm' . ucfirst($this->params['driver']) . 'Parser');
			$parser = ucfirst($this->params['driver']) . 'OrmParser';
			$this->parser = new $parser($this->params, $this->options);
			$this->parser->connect();
		}
		else 
			$this->clear();
			
		return $this;
	}
	
	
	/**
	 * 获取插入表后的得到的返回的主键编号,仅MySQL具有该功能
	 *
	 * @return Integer
	 */
	function getLastId() {
		return mysql_insert_id($this->parser->connect);
	}
	
	
	/**
	 * 查询操作影响到的行数量
	 *
	 * @return Integer
	 */
	function getAffectRows() {
		return $this->parser->getAffectRows();
	}
}
?>