<?php

/**
 * 游戏数据捕捉程序
 *
 * @author 庾洋 <yuyangvi@gmail.com>
 *
 * $Id$
 */

error_reporting(E_ALL ^ (E_NOTICE | E_WARNING));
set_time_limit(0);
date_default_timezone_set('Asia/Shanghai');

/* {{{ 数据库配置 */	
$db_cfg = array(
				'host' => 'localhost',
				'username' => 'root',
				'password' => 'root',
				'dbname' => 'au2'
				);
/* }}} */

/* {{{ 连接数据库 */
mysql_connect( $db_cfg['host'], $db_cfg['username'], $db_cfg['password'] );
mysql_select_db($db_cfg['dbname']);
/* }}} */

/* {{{ 记录数据库当前GameId,AreaId最大值 */
$query = mysql_query('select max(`GameId`) as `cur_game_id`, max(`AreaId`) as `cur_area_id` from `Game`');
extract( mysql_fetch_assoc($query) );
isset( $cur_game_id ) || ( $cur_game_id = 0 );
isset( $cur_area_id ) || ( $cur_area_id = 0 );
/* }}} */

/* {{{ 记录开始时间 */
logfile( 'begin' );
echo "Begin!\n";
/* }}} */

updateGame();

/* {{{ 记录结束时间 */
logfile( 'end' );
echo "Complete!\n";
mysql_close();
/* }}} */

/**
 * 更新游戏
 */
function updateGame()
{
	global $cur_game_id;

	/* {{{ 获取数据 */
	$text = curl_content( "http://5173.com/" );
	if( !$text )
	{
		return;
	}
	preg_match_all( "/<select name=\"SearchBarTop[\$]CommSearchBarV2[\$]ddlGames\".*?<\/select>/is" , $text , $dc );
	$text = iconv( "GB2312//IGNORE", "UTF-8//IGNORE", $dc[0][0] );
	preg_match_all( "/<option value=\"([\d\w]+)\">(.*?)<\/option>/" , $text , $sc );
	if ( !$sc[0] )
	{
		return;
	}
	$list = array($sc[1],$sc[2]);
	/* }}} */

	/* {{{ 遍历游戏区 */
	$i = 0;
	while ( isset( $list[0][$i] ) )
	{
		$list[0][$i]= mysql_escape_string($list[0][$i]);
		$list[1][$i]= mysql_escape_string($list[1][$i]);
		$sql = 'select `GameId` from `Game` where `GameName` = \''.$list[1][$i].'\'' ;
		$query = mysql_query($sql);
		$result = mysql_fetch_row( $query );
		$game_id = $result[0];
		$game_id || ( $game_id = ++ $cur_game_id );
		echo $game_id, iconv( "UTF-8//IGNORE", "GB2312//IGNORE", $list[1][$i] );
		updateArea( $game_id, $list[1][$i], $list[0][$i] );
		sleep(1);
		++$i;
	}
	/* }}} */
}

/**
 * 更新游戏区
 */
function updateArea($game_id, $game_name, $game_key)
{
	global $cur_area_id;

	$text = curl_content("http://www.5173.com/ajax.axd?methodName=games&gameType=GameAreas&id=".$game_key."&tradingType=other" );
	if (!$text)
	{
		return;
	}
	else
	{
		$text = iconv( "GB2312//IGNORE", "UTF-8//IGNORE", $text );
		$text = mysql_escape_string($text);
		$areas = explode('$', $text);

		/* {{{ 向下查找服务器 */
		$i = 0;
		while ( $areas[$i*2] )
		{
			print_r( 'select `AreaId` from `Game` where `GameId` = \''.$game_id.'\' and `Area` = \''.$areas[$i*2+1].'\'' );
			$query = mysql_query( 'select `AreaId` from `Game` where `GameId` = \''.$game_id.'\' and `Area` = \''.$areas[$i*2+1].'\'' );
			$result = mysql_fetch_row($query);
			var_dump($result);
			$area_id = $result[0];
			$area_id || ( $area_id = ++ $cur_area_id );
			echo $area_id, iconv( "UTF-8//IGNORE", "GB2312//IGNORE", $areas[$i*2+1] ), "\n";
			updateServer( $game_id, $game_name, $area_id, $areas[$i*2+1], $areas[$i*2] );
			sleep(1);
			++$i;
		}
		/* }}} */
	}
}


/**
 * 更新游戏服务器
 */
function updateServer( $game_id, $game_name, $area_id, $area_name, $area_key )
{
	//echo $game_name, '/', $area_name, "\n";

	/* {{{ 读数据 */
	$text = curl_content( "http://www.5173.com/ajax.axd?methodName=games&gameType=GameServers&id=".$area_key."&tradingType=other" );
	/* }}} */

	if ( !$text )
	{
		return;
	}
	else
	{
		/* {{{ 解析数据 */
		$text = iconv( "GB2312//IGNORE", "UTF-8//IGNORE", $text );
		$text = mysql_escape_string($text);
		$tmp = explode('$',$text);
		/* }}} */

		$i = 0;
		$servers = array();
		while ( $tmp[$i*2] )
		{
			$servers[]=$tmp[$i*2+1];
			$i++;
		}

		/* {{{ 过滤掉和数据库相同的内容 */
		$query = mysql_query('select `Server` from `Game` where `GameId`=\''.$game_id.'\' and `AreaId`=\''.$area_id.'\'');
		$servers_indb = array();
		while ( $result = mysql_fetch_assoc($query) )
		{
			$servers_indb[] = $result['Server'];
		}
		$servers = array_diff( $servers, $servers_indb );
		/* }}} */

		/* {{{ 插入数据库 */
		$i = 0;
		$values = array();
		while ($servers[$i])
		{
			if ($servers[$i] != null)
			{
				$values[] = '(\''.$game_id.'\',\''.$game_name.'\',\''.$area_id.'\',\''.$area_name.'\',\''.$servers[$i].'\',now())';
			}
			++ $i;
		}
		$result = implode(',',$values);
		$sql = "insert into `Game` (`GameId`,`GameName`,`AreaId`,`Area`,`Server`,`UpdateTime`) values ".$result;
		mysql_query($sql);
		/* }}} */
	}
}

 /**
  * 记录日志
  */
function logfile($str)
{
	$handle = fopen(date('Ymd').'.txt','a');
	fwrite( $handle,date('Y-m-d H:i:s ').$str."\n" );
	fclose($handle);
}

/**
 * 过滤空数组元素用
 */
 function escape_blank($val)
 {
	 if ($val == null)
		 return false;
	 else
		 return true;
 }

/**
 * 获取url内容
 */
function curl_content($url)
{
	$ch2 = curl_init();
	curl_setopt( $ch2, CURLOPT_URL, $url );
	curl_setopt( $ch2, CURLOPT_HEADER, false);
	curl_setopt( $ch2, CURLOPT_RETURNTRANSFER, 1);
	curl_setopt( $ch2, CURLOPT_TIMEOUT, 15);
	$orders = curl_exec( $ch2 );

	/* {{{ 如果不成功会再试一遍，还不行就写入日志 */
	if (!$orders)
	{
		sleep(1);
		$orders = curl_exec( $ch2 );
		( $orders === false ) || logfile($url);
	}
	/* }}} */

	curl_close( $ch2 );
	return $orders;
}