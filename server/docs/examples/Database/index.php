<?php

/**
 * 框架使用样例－数据库操作举例
 * 
 * @author 张立冰 <roast@php.net>
 * 
 * $Id: index.php 1 2008-08-14 10:05:35Z libing $
 */

require_once('../../../common.inc.php');

/* Default Module */
class index extends Action   
{
	/**
	 * 显示登录页(默认Action)
	 */
	function doDefault() 
	{	
		/* {{{ 初始化DB操作类,默认使用配置文件中配置引擎 */
		$query = $this->app->orm()->query();
		/* }}} */
		
		
		/* {{{ 通过SQL查询返回记录的数组 */
		echo '<p>$query->getArray(\'show tables\'):<br />';
		print_r($query->getArray('show tables'));
		echo '</p>';
		/* }}} */
		
		
		/* {{{ 通过SQL查询单条记录 */
		echo '<p>$query->getRow(\' select * from user\'):<br />';
		print_r($query->getRow(' select * from user'));
		echo '</p>';
		/* }}}*/
		
		
		/* {{{ 通过SQL查询单条记录的某个值 */
		echo '<p>$query->getValue(\' select * from user\'):<br />';
		print_r($query->getValue(' select * from user'));
		echo '</p>';
		/* }}}*/		

		
		/* {{{ OO方式操作数据库 */
		echo '<p>$query->addTable(\'user\')->addWhere(\'User\',\'root\')->getRow()<br />';
		print_r($query->addTable('user')->addWhere('User','root')->getRow());
		echo '</p>';
		/* }}} */
		
		
		/* {{{ 将数据库操作的历史记录删除，参数可以为table/value等，具体可以*/
		$query->clear();
		/* }}} */

			
		/* {{{ OO方式操作数据库（添加条件） */
		echo '<p>SQL：select host from user where User=\'root\' group by host order by User<br />';
		$query->addTable('user');
		$query->addField('host');
		$query->addWhere('User', 'root');	//宏定义参见：OrmMysqlParser.class.php
		$query->addGroupBy('host');
		$query->addOrderBy('User');
		print_r($query->getArray(null, 0, 10));
		echo '</p>';
		/* }}} */	
		
		
		/* {{{ 获取单列的数据 */
		echo '<p> select host from user <br />';
		$query->clear();
		print_r($query->getColumn('select host from user'));
		echo '</p>';
		/* }}} */
		
	   //更换数据库—配置一般于配置文件
	   $db['params'] = array
		                (
							'driver'		=> 'mysql',
							'host'			=> 'localhost',
							'name'			=> 'test',
							'user'			=> 'root',
							'password'		=> '',
						);
						
		$db['options'] = array
		                (
							'persistent'				=> false,
							'tablePrefix'				=> '',
							'charset'					=> 'utf8',
						);

		$query = $this->app->orm($db['params'], $db['options'])->query();
		
		/* {{{ 插入数据 */
		echo '<p>test.test count:' . $query->getValue('select count(*) from test') . '<br />';
		$query->clear();
		$query->addTable('test');
		$query->addValue('id', 1);
		$query->addValue('name', 'roast');
		$query->insert();
		echo 'test.test count:' . $query->getValue('select count(*) from test') . '</p>';
		/* }}} */

		
		/* {{{ 插入数据（另外一种方式) */
		echo '<p>test.test count:' . $query->getValue('select count(*) from test') . '<br />';
		$query->clear('value');
		$query->insert(array('id'=>'1', 'name'=>'roast'));
		echo 'test.test count:' . $query->getValue('select count(*) from test') . '</p>';
		/* }}} */

		
		/* {{{ 修改数据 */
		echo '<p>id:' . $query->getValue('select name from test where id="1"') . '<br />';
		$query->clear();
		$query->addTable('test');
		$query->addValue('name', 'libing');
		$query->addWhere('id', '1');
		$query->update();
		echo 'id:' . $query->getValue('select name from test where id="1"') . '</p>';
		/* }}} */
		
		
		/* {{{ 修改数据（另外一种方式) */
		echo '<p>id:' . $query->getValue('select name from test where id="1"') . '<br />';
		$query->clear('value');
		$query->update(array('name'=>'roast'));
		echo 'id:' . $query->getValue('select name from test where id="1"') . '</p>';
		/* }}} */	
			
		
		/* {{{ 删除记录 */
		echo '<p>test.test count:' . $query->getValue('select count(*) from test') . '<br />';
		$query->clear();
		$query->addTable('test');
		$query->addWhere('id', 1);
		$query->delete();
		echo 'test.test count:' . $query->getValue('select count(*) from test') . '</p>';
		/* }}} */
		
		/* {{{ 获取当前的SQL语句 */
		$query->clear();
		$query->addTable('test');
		$query->addValue('id', '1');
		$query->addValue('name', 'libing');
		$query->addWhere('name', 'roastxshare');
		echo '<p>SQL(select):' . $query->asSql() . '<br />';
		echo 'SQL(update):' . $query->asSql('update') . '<br />';
		echo 'SQL(insert):' . $query->asSql('insert') . '<br />';
		echo 'SQL(delete):' . $query->asSql('delete') . '<br />';
		echo '</p>';
		/* }}} */
		
		/* {{{ 执行SQL语句 */
		$query->exec('SET NAMES utf8');
		/* }}} */	
	}
}

$app->run();
?>