-- phpMyAdmin SQL Dump
-- version 3.1.3
-- http://www.phpmyadmin.net
--
-- 主机: localhost
-- 生成日期: 2010 年 12 月 29 日 04:25
-- 服务器版本: 5.1.32
-- PHP 版本: 5.2.9-1

SET SQL_MODE="NO_AUTO_VALUE_ON_ZERO";

--
-- 数据库: `gameleap`
--

-- --------------------------------------------------------

--
-- 表的结构 `advertisement`
--

DROP TABLE IF EXISTS `advertisement`;
CREATE TABLE IF NOT EXISTS `advertisement` (
  `adid` int(11) NOT NULL AUTO_INCREMENT,
  `apid` int(11) NOT NULL,
  `bannerurl` varchar(200) COLLATE utf8_bin NOT NULL,
  `islive` int(11) NOT NULL DEFAULT '1',
  `enabled` int(11) NOT NULL DEFAULT '1',
  `ratio` decimal(2,0) NOT NULL DEFAULT '1',
  `clicks` int(11) NOT NULL DEFAULT '0',
  `impressions` int(11) NOT NULL DEFAULT '0',
  `type` int(11) NOT NULL DEFAULT '0' COMMENT 'house promot\ncross promot',
  `efficiency` int(11) NOT NULL DEFAULT '0',
  `banner_tag` varchar(100) COLLATE utf8_bin DEFAULT NULL,
  `popupdesc` varchar(150) COLLATE utf8_bin DEFAULT NULL,
  `preference` int(11) NOT NULL DEFAULT '0' COMMENT '0,1',
  `img` varchar(45) COLLATE utf8_bin DEFAULT NULL,
  `imghover` varchar(45) COLLATE utf8_bin DEFAULT NULL,
  PRIMARY KEY (`adid`)
) ENGINE=MyISAM  DEFAULT CHARSET=utf8 COLLATE=utf8_bin COMMENT='广告列表' AUTO_INCREMENT=3 ;

--
-- 导出表中的数据 `advertisement`
--

INSERT INTO `advertisement` (`adid`, `apid`, `bannerurl`, `islive`, `enabled`, `ratio`, `clicks`, `impressions`, `type`, `efficiency`, `banner_tag`, `popupdesc`, `preference`, `img`, `imghover`) VALUES
(1, 1, 'http://widgets.friendster.com/Winninggoal', 1, 1, '1', 13902, 6, 0, 1, NULL, NULL, 0, 'fab99b6ad8331246dcfc9ce27b1fa90f860e5093.png', 'b17695fd99c5b8296fdcb24d886a2fc109e9d6e8.png'),
(2, 2, 'http://widgets.friendster.com/texasholdempoker', 1, 1, '1', 0, 0, 0, 1, NULL, '德州扑克 popupdesc', 0, '0fd526bf44906e9b965f7f277bfb8b0c2b62cc18.jpg', 'f9e52f2d491912fafaed8027fbb972d6fc142fe0---.j');

-- --------------------------------------------------------

--
-- 表的结构 `app_list`
--

DROP TABLE IF EXISTS `app_list`;
CREATE TABLE IF NOT EXISTS `app_list` (
  `appid` int(11) NOT NULL AUTO_INCREMENT,
  `platform_id` int(11) NOT NULL,
  `appname` varchar(45) CHARACTER SET latin1 NOT NULL COMMENT 'Name of your application',
  `url` varchar(200) CHARACTER SET latin1 NOT NULL COMMENT 'URL to your application (not including any tracking URLs)',
  `category_id` varchar(30) CHARACTER SET latin1 NOT NULL,
  `uid` int(11) NOT NULL,
  `status` int(1) NOT NULL,
  PRIMARY KEY (`appid`),
  KEY `uid` (`uid`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 COLLATE=utf8_bin COMMENT='应用列表' AUTO_INCREMENT=5 ;

--
-- 导出表中的数据 `app_list`
--

INSERT INTO `app_list` (`appid`, `platform_id`, `appname`, `url`, `category_id`, `uid`, `status`) VALUES
(1, 1, 'Winning Goal', 'http://widgets.friendster.com/Winninggoal', '', 1, 0),
(2, 1, 'texasholdempoker', 'http://widgets.friendster.com/texasholdempoker', '', 1, 0),
(3, 1, 'SpiritValley', 'http://widgets.friendster.com/SpiritValley', '', 1, 0),
(4, 1, 'SpiritValley', 'http://widgets.friendster.com/SpiritValley', '', 0, 0);

-- --------------------------------------------------------

--
-- 表的结构 `statistics`
--

DROP TABLE IF EXISTS `statistics`;
CREATE TABLE IF NOT EXISTS `statistics` (
  `statistics_id` int(11) NOT NULL,
  PRIMARY KEY (`statistics_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin;

--
-- 导出表中的数据 `statistics`
--


-- --------------------------------------------------------

--
-- 表的结构 `user`
--

DROP TABLE IF EXISTS `user`;
CREATE TABLE IF NOT EXISTS `user` (
  `uid` int(11) NOT NULL,
  `email` varchar(45) CHARACTER SET latin1 DEFAULT NULL,
  `company` varchar(45) CHARACTER SET latin1 DEFAULT NULL,
  `phone` varchar(45) CHARACTER SET latin1 DEFAULT NULL,
  `firstname` varchar(45) CHARACTER SET latin1 DEFAULT NULL,
  `lastname` varchar(45) CHARACTER SET latin1 DEFAULT NULL,
  `password` varchar(45) CHARACTER SET latin1 DEFAULT NULL,
  `status` varchar(45) CHARACTER SET latin1 DEFAULT NULL,
  PRIMARY KEY (`uid`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE=utf8_bin COMMENT='用户表 存放用户数据';

--
-- 导出表中的数据 `user`
--

INSERT INTO `user` (`uid`, `email`, `company`, `phone`, `firstname`, `lastname`, `password`, `status`) VALUES
(1, '1', '1', '1', '1', '1', NULL, '1');
