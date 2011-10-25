<?php
/**
 *  ORM 数据库MySQL操作类
 *
 * @package lib
 * @subpackage plugins.orm
 * @author 张立冰 <roast@php.net>
 */


/**#@+
 * select操作符
 */
define('_ORM_OP_AS',  		'AS'); 	
define('_ORM_OP_MAX',  		'MAX'); 	
define('_ORM_OP_MIN',      	'MIN');
define('_ORM_OP_SUM',      	'SUM');
define('_ORM_OP_AVG',     	'AVG');
define('_ORM_OP_COUNT',   	'COUNT');
/**#@-*/

/**#@+
 * where操作符
 */
define('_ORM_OP_EQ',  		'=');
define('_ORM_OP_NEQ',  		'!=');
define('_ORM_OP_GT',      	'>');
define('_ORM_OP_LT',      	'<');
define('_ORM_OP_GE',     		'>=');
define('_ORM_OP_LE',    		'<=');
define('_ORM_OP_BETWEEN',    	'BETWEEN');
define('_ORM_OP_LIKE',     	'LIKE');
define('_ORM_OP_ISNULL',     	'IS NULL');
define('_ORM_OP_ISNOTNULL',  	'IS NOT NULL');
define('_ORM_OP_IN',     		'IN');
define('_ORM_OP_OR',     		'OR');
define('_ORM_OP_AND',     	'AND');
define('_ORM_OP_NOT',     	'NOT');
define('_ORM_OP_SQL',     	'sqlLeash');
/**#@-*/

/**#@+
 * orm 字段获取方式
 */
define('_ORM_FETCH_ASSOC', 	1);
define('_ORM_FETCH_NUM', 		2);
define('_ORM_FETCH_BOTH', 	3);
define('_ORM_FETCH_OBJ', 		4);
/**#@-*/

/**#@+
 * order操作符
 */
define('_ORM_OP_ASC',  		'ASC'); 
define('_ORM_OP_DESC',  		'DESC'); 		
/**#@-*/

/**#@+
 * Mapping 文件中的字段数据类型
 */
define('_ORM_DT_SQL',     		'sql');
define('_ORM_DT_AUTO',     		'auto');

define('_ORM_DT_BOOLEAN',  		'boolean');
define('_ORM_DT_BIT',      		'bit');
define('_ORM_DT_INT',      		'int');
define('_ORM_DT_DECIMAL',  		'decimal');
define('_ORM_DT_FLOAT',    		'float');
define('_ORM_DT_CHAR',     		'char');
define('_ORM_DT_VARCHAR',     	'varchar');
define('_ORM_DT_CLOB',     		'clob');
define('_ORM_DT_TEXT',     		'text');
define('_ORM_DT_BLOB',     		'blob');
define('_ORM_DT_DATE',     		'date');
define('_ORM_DT_TIME',     		'time');
define('_ORM_DT_DATETIME', 		'datetime');
/**#@-*/

/**
 *  ORM sql解析器
 *
 * @package lib
 * @subpackage plugins.orm.parser
 * @author 张立冰 <roast@php.net>
 */
class MysqlOrmParser {
    /**
     * 查询计数器
     */
    static public $query_cnt = 0;
    
    /**
     * 数据查询的统计
     *
     * @var Array
     */
    static public $querys = array();
    
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
	 * 数据库连接实例
	 * @var Object
	 * @access private
	 */
	var $connect;
	
	/**
	 * 最后一条更新或删除SQL执行影响到的记录数
	 * @var int
	 */
	var $lastAffectedRows = 0;
	
	/**
	 * 多DB操作时需要进行的数据库Key的标记字段
	 *
	 * @var Array
	 */
	public static $activeParams = null;
	
	/**
	 * 构造函数(兼容PHP4)
	 *
	 * @param 	Array 	$params		数据库连接参数
	 * @param 	Array	$options	数据库连接选项
	 * @return OrmQuery
	 */
	function OrmParser($params, $options) {
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
	}
	
	/**
	 * Enter description here...
	 *
	 */
	function connect() {
		if ($this->options['persistent']) 
		{
			$this->connect = mysql_pconnect($this->params['host'],
											$this->params['user'],
											$this->params['password']);
		} else {
			$this->connect =  mysql_connect($this->params['host'],
											$this->params['user'],
											$this->params['password']);
		}
		
		if (isset($this->options['charset'])) {
			$this->execute("set names  ".$this->options['charset']);
		}
	}

	/**
	 * 解析生成SQL语句
	 * @param array $a OrmQuery生成的SQL元素数组
	 * @return string
	 */
	function parseSql($a) {
		switch ($a['mode']) {
			case 'select':
				$sql = 'SELECT ' . $this->parseSqlFieldList($a['field'], true)
						. ' FROM ' . $this->parseSqlTable($a['table']);
				(!empty($a['where'])) && $sql .= ' WHERE ' . $this->parseSqlWhere($a['where']);
				(!empty($a['group'])) && $sql .= ' GROUP BY ' . $this->parseSqlGroup($a['group']);
				(!empty($a['order'])) && $sql .= ' ORDER BY ' . $this->parseSqlOrder($a['order']);
				break;
			case 'update':
				$sql = 'UPDATE ' . $this->parseSqlTable($a['table'], false)
						. ' SET ' . $this->parseSqlValue($a['value'], 'update');
				(!empty($a['where'])) && $sql .= ' WHERE ' . $this->parseSqlWhere($a['where']);
				break;
			case 'insert':
				$sql = 'INSERT ' . $this->parseSqlTable($a['table'], false)
						. ' ' . $this->parseSqlValue($a['value'], 'insert');
				break;
			case 'delete':
				$sql = 'DELETE FROM ' . $this->parseSqlTable($a['table'], false);
				(!empty($a['where'])) && $sql .= ' WHERE ' . $this->parseSqlWhere($a['where']);
				break;
		}
		return $sql;
	}
	
	/**
	 * 字段名编码
	 * @param string $name 字段名
	 * @return string
	 * @access private
	 */
	function encodeFieldName($name) {
		if (preg_match('/^\w+$/', $name)) {
			$result = '`' . $name . '`';
		} elseif (preg_match('/^\w+\.\w+$/', $name)) {
			$result = preg_replace('/^(\w+)\.(\w+)$/', '`\\1`.`\\2`', $name);
		} elseif (preg_match('/^\w+\(\s*\w+\.\w+/', $name)) {
			$result = preg_replace('/^(\w+\(\s*)(\w+)\.(\w+)(.+)/', '\\1`\\2`.`\\3`\\4', $name);
		} elseif (preg_match('/^\w+\(\s*\w+/', $name)) {
			$result = preg_replace('/^(\s*\w+\()(\w+)(.+)/', '\\1`\\2`\\3', $name);
		} else {
			$result = $name;
		}
		return $result;
	}
	
	/**
	 * 字段值编码
	 * @param string $value 字段值
	 * @param string $type 字段类型
	 * @return string
	 * @access private
	 */
	function encodeFieldValue($value, $type) {
		if (is_array($value)) {
			foreach ($value as $k => $v) {
				$value[$k] = $this->encodeFieldValue($v, $type);
			}
			return $value;
		} else {
			if ($type == _ORM_DT_AUTO) { //自动识别数据类型
				switch (gettype($value)) {
					case 'boolean': $type = _ORM_DT_BOOLEAN; break;
					case 'integer': $type = _ORM_DT_INT; break;
					case 'double': $type = _ORM_DT_FLOAT; break;
					default: $type = _ORM_DT_VARCHAR; break;
				}
			}
			switch ($type) {
				case _ORM_DT_INT: $result = intval($value); break;
				case _ORM_DT_DECIMAL:
				case _ORM_DT_FLOAT: $result = floatval($value); break;
				case _ORM_DT_BOOLEAN:
				case _ORM_DT_BIT: $result = $this->quote($value ? 1 : 0); break;
				case _ORM_DT_DATETIME: $result = $this->quote(
						strftime('%Y-%m-%d %H:%M:%S', is_numeric($value) ? $value : strtotime($value))); break;
				case _ORM_DT_DATE: $result = $this->quote(
						strftime('%Y-%m-%d', is_numeric($value) ? $value : strtotime($value))); break;
				case _ORM_DT_TIME: $result = $this->quote(
						strftime('%H:%M:%S', is_numeric($value) ? $value : strtotime($value))); break;
				case _ORM_DT_SQL: $result = $this->encodeFieldName($value); break;
				default: $result = $this->quote($value); break;
			}
			return $result;
		}
	}
	
	/**
	 * 给字符型字段值加引号
	 * @param string $s
	 * @return string
	 */
	function quote($s) {
		return '\'' . strtr($s, array('\\' => '\\\\', '\'' => '\\\'')) . '\'';
	}

	/**
	 * 解析生成SQL语句中的字段列表(select)
	 * @param array $fields OrmQuery生成的SQL元素数组中的字段列表部分
	 * @return string
	 * @access private
	 */
	function parseSqlFieldList($fields) {
		$sql = array();
		foreach ($fields as $field) {
			$s = $this->encodeFieldName($field['name']);
			$s = (empty($field['opt'])) ? $s : ($field['opt'] . '(' . $s . ')');
			($field['name'] != $field['alias']) && $s .= ' ' . _ORM_OP_AS . ' '
								. $this->encodeFieldName($field['alias']);
			$sql[] = $s;
		}
		return empty($sql) ? '*' : implode(',', $sql);
	}
	
	/**
	 * 解析生成SQL语句中的字段列表(update&insert)
	 * @param array $values OrmQuery生成的SQL元素数组中的字段列表部分
	 * @param string $type 类型,update|insert
	 * @return string
	 * @access private
	 */
	function parseSqlValue($values, $type) {
		if ($type == 'update') { //更新记录的Value部分
			$sql = array();
			foreach ($values as $value) {
				$sql[] = $this->encodeFieldName($value['name']) . '='
						. $this->encodeFieldValue($value['value'], $value['type']);
			}
			$sql = implode(',', $sql);
		} else { //插入记录的Value部分
			$fields = array();
			$fieldValues = array();
			foreach ($values as $value) {
				$fields[] = $this->encodeFieldName($value['name']);
				$fieldValues[] = $this->encodeFieldValue($value['value'], $value['type']);
			}
			$sql = '(' . implode(',', $fields) . ')VALUES('
					. implode(',', $fieldValues) . ')';
		}
		return $sql;
	}
	
	/**
	 * 解析生成SQL语句中的表列表
	 * @param array $tables OrmQuery生成的SQL元素数组中的表列表部分
	 * @param boolean $withAlias 是否带别名
	 * @return string
	 * @access private
	 */
	function parseSqlTable($tables, $withAlias=true) {
		if (empty($tables)) {
			throwException('你没有指定表名', 4041);
		}
		$sql = array();
		foreach ($tables as $table) {
			$sql[] = '`' . $this->options['tablePrefix'] . $table['name']
					. (($withAlias) ? ('` `' . $table['alias'] . '`') : '`');
		}
		return implode(',', $sql);
	}
	
	/**
	 * 解析生成SQL语句中的条件列表
	 * @param array $wheres OrmQuery生成的SQL元素数组中的条件列表部分
	 * @return string
	 * @access private
	 */
	function parseSqlWhere($wheres) {
		$sql = '';
		$addLogical = false;
		foreach ($wheres as $where) {
			if ($addLogical && $where['name'] != ')' || $where['logical'] == _ORM_OP_NOT) {
				$sql .= ' ' . $where['logical'] . ' ';
			}
			if ($where['name'] == '(' || $where['name'] == ')') {
				$sql .= $where['name'];
				$addLogical = ($where['name'] != '(');
			} else {
				$name = $this->encodeFieldName($where['name']);
				$value = $this->encodeFieldValue($where['value'], $where['type']);
				switch ($where['opt']) {
					case _ORM_OP_SQL:
						$sql .= ' ' . $name;
						break;
					case _ORM_OP_BETWEEN:
						if (is_array($value) && count($value) == 2) {
							$sql .= ' ' . $name . ' ' . _ORM_OP_BETWEEN . ' '
										. $value[0] . ' and ' . $value[1] . ' ';
						} else {
							throwException('字段值不合法:必须为数组且数组长度为2', 4053);
						}
						break;
					case _ORM_OP_IN:
						if (is_array($value)) {
							$sql .= ' ' . $name . ' ' . _ORM_OP_IN 
										. ' (' . implode(',', $value) . ')';
						} else {
							throwException('字段值不合法:必须为数组', 4053);
						}
						break;
					default :
						$sql .= $name . ' ' . $where['opt'] . ' ' . $value;
						break;
				}
				$addLogical = true;
			}
		}
		return $sql;
	}
	
	/**
	 * 解析生成SQL语句中的分组列表
	 * @param array $groups OrmQuery生成的SQL元素数组中的分组列表部分
	 * @return string
	 * @access private
	 */
	function parseSqlGroup($groups) {
		$sql = array();
		foreach ($groups as $group) {
			$sql[] = $this->encodeFieldName($group);
		}
		return implode(',', $sql);
	}
	
	/**
	 * 解析生成SQL语句中的排序列表
	 * @param array $orders OrmQuery生成的SQL元素数组中的排序列表部分
	 * @return string
	 * @access private
	 */
	function parseSqlOrder($orders) {
		$sql = array();
		foreach ($orders as $order) {
			$sql[] = $this->encodeFieldName($order['name']) . ' ' . $order['order'];
		}
		return implode(',', $sql);
	}
	
	/**
	 * 从结果集中提取记录
	 * @param object $dataset
	 * @param int $fetchMode 记录提取模式 默认字段名(_ORM_FETCH_ASSOC)
	 * @return mixed
	 */
	function fetch($dataset, $fetchMode = _ORM_FETCH_ASSOC) {
		switch ($fetchMode) {
			case _ORM_FETCH_ASSOC: 
				$result = mysql_fetch_assoc($dataset); break;
			case _ORM_FETCH_NUM: 
				$result = mysql_fetch_row($dataset); break;
			case _ORM_FETCH_BOTH: 
				$result = mysql_fetch_array($dataset); break;
			case _ORM_FETCH_OBJ: 
				$result = mysql_fetch_object($dataset); break;
		}
		return $result;
	}
	
	/**
	 * 获取一条记录
	 * @param string $sql SQL语句
	 * @param int $fetchMode 记录提取模式 默认字段名(_ORM_FETCH_ASSOC)
	 * @return array
	 */
	function getFirst($sql, $fetchMode = _ORM_FETCH_ASSOC) {
		$sql .= ' LIMIT 1';
		$dataset = $this->execute($sql);
		return $this->fetch($dataset, $fetchMode);
	}
	
	/**
	 * 返回所有记录
	 * @param string $sql SQL语句
	 * @param int $offset 偏移量,即记录起始游标,从0开始
	 * @param int $count 返回的最大记录数
	 * @param int $fetchMode 记录提取模式 默认字段名(_ORM_FETCH_ASSOC)
	 * @return unknown
	 */
	function getAll($sql, $offset=0, $count=-1, $fetchMode = _ORM_FETCH_ASSOC) {
		$result = array();
		($count > 0) && $sql .= ' LIMIT ' . $offset . ',' . $count;
		$dataset = $this->execute($sql);
		while ($row = mysql_fetch_array($dataset, $fetchMode)) {
			$result[] = $row;
		}
		return $result;
	}
	
	/**
	 * 执行SQL(update/delete)并返回受影响的记录数
	 * @param string $sql SQL语句
	 * @return int
	 */
	function execute($sql) {
	    if (MysqlOrmParser::$activeParams !== $this->params)
	    {
	        MysqlOrmParser::$activeParams = $this->params;
	        mysql_select_db($this->params['name'], $this->connect);
	    }
	    
	    if (DEBUG)
	    {
	       self::$query_cnt++;
	       self::$querys[] = $sql;	        
	    }
	      
		$result = mysql_query($sql, $this->connect);
		($result === false) && $this->error($sql);
		return $result;
	}
	
	function call($procedureName) {
		// TODO 执行存储过程
		return false;
	}
	
	/**
	 * 取序列号
	 * @param string $seqName 序列名
	 * @param string $type    类型 cur/next
	 * @return integer $seqId 序列ID 
	 * @access public
	 */
	function getSeq($seqName, $type = 'next'){ 	
		switch ($type) {
			case 'cur':	
			case 'current':	
				$seqInfo = $this->getFirst('SELECT `id` FROM ' . $seqName);
				break;
			default:
				$this->execute('UPDATE ' . $seqName . ' SET `id`=`id` + 1');
				$seqInfo = $this->getFirst('SELECT `id` FROM ' . $seqName);
				break;			
		}
		return $seqInfo['id'];
	}
	
	/**
	 * 返回数据类型
	 * @param string $s
	 * @return string
	 */
	function getType($s) {
		switch ($s) {
			case 'bool':
			case 'boolean': $result = _ORM_DT_BOOLEAN; break;
			case 'bit': $result = _ORM_DT_BIT; break;
			case 'integer':
			case 'int': $result = _ORM_DT_INT; break;
			case 'decimal': $result = _ORM_DT_DECIMAL; break;
			case 'real':
			case 'double':
			case 'float': $result = _ORM_DT_FLOAT; break;
			case 'char': $result = _ORM_DT_CHAR; break;
			case 'string':
			case 'varchar': $result = _ORM_DT_VARCHAR; break;
			case 'clob': $result = _ORM_DT_CLOB; break;
			case 'text': $result = _ORM_DT_TEXT; break;
			case 'blob': $result = _ORM_DT_BLOB; break;
			case 'date': $result = _ORM_DT_DATE; break;
			case 'time': $result = _ORM_DT_TIME; break;
			case 'datetime': $result = _ORM_DT_DATETIME; break;
		}
		return $result;
	}
	
	/**
	 * 查询操作影响到的行数量
	 *
	 * @return Integer
	 */	
	function getAffectRows() {
		return mysql_affected_rows($this->connect);
	}	
	
	/**
	 * 数据库操作执行错误
	 * @param string $sql 错误的SQL语句
	 * @access private
	 */
	function error($sql) {
		throwException('SQL执行错误: <b>' . $sql 
				. '</b><br /> 错误代码: <b>' . mysql_errno($this->connect)
				. '</b><br /> 错误信息: <b>' . mysql_error($this->connect)
				. '</b>', 4001);
	}

}
?>