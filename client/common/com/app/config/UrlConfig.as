package com.app.config
{
	

	public final class UrlConfig
	{
		
		/**
		 * 接口请求基地址 
		 */		
		public static var HTTPROOT:String = "http://127.0.0.1/";
		
		public static var MAINAPP:String=UrlConfig.HTTPROOT+"swf/App.swf";
		/**
		 * 资源根路径 
		 */		
		public static var SWFROOT:String = "./";
		
		/**
		 * 获得用户个人信息
		 * 接口编号：1.1
		 */		
		public static const GETUSERINFO:String = "ajax/GetUserInfo.json";
		public static const GETMAGICLIST:String = "ajax/GetMagicList.json";
		
		/**
		 * 获得系统Relic列表
		 */
		public static const GETRELICLIST:String = "ajax/GetRelicList.json";
		
		
		/**
		 * unequip relic
		 */
		public static const UNEQUIPRELIC:String = "ajax/unequip_relic.json";
		
		/**
		 * 购置slot
		 */
		public static const PURCHASERELICSLOT:String = "ajax/purchase_relic_slot.json";
		
		/**
		 * 应用relic
		 */
		public static const EQUIPRELIC:String = "ajax/equip_relic.json";
		/**
		 *dojo 应用武器 
		 */		
		public static const EQUIPWEAPON:String="ajax/equip_weapon.json";
		
		/**
		 *dojo 卸载武器 
		 */		
		public static const UNEQUIPWEAPON:String="ajax/unequip_weapon.json";
		/**
		 *train ninja 
		 */		
		public static const TRAINNINJA:String="ajax/train_ninja.json";
		/**
		 *解雇ninja 
		 */		
		public static const DISMISSNINJA:String="ajax/dismiss_ninja.json";
		/**
		 *重命名ninja 
		 */		
		public static const RENAMENINJA:String="ajax/rename_ninja.json";
		
		
		/**
		 *获取对战列表
		 */		
		public static const STAGE:String="ajax/stage.json";
		/**
		 *模拟获取strong列表  
		 */		
		public static const GETOPPONENTS:String="ajax/get_opponents_1_0_50.json"
		
		/////////////////////////////////////////////////////////////////////////////////////////////////
		/**
		 * 雇佣忍者
		 */		
		public static const RECRUITNINJA:String="ajax/recruit_ninja.json";
		
		/**
		 *获取可招募忍者名单 
		 */		
		public static const RECRUITABLENINJAS:String="ajax/recruitable_ninjas.json"
		
		///////////////////////////////////////////////////////////////////////////////////////////////////
		
		
		/**
		 *fight 数据 
		 */			
		public static const FIGHT:String="ajax/fight.json";	
			
		public static const HORDE:String="ajax/horde.json";
		/**
		 *第一个boss数据 
		 */		
		public static const FIGHTSMALLGIRL:String=UrlConfig.HTTPROOT+"ajax/epicbattle/small_girl.json";
		/**
		 * 第二个boss fight 数据
		 */		
		public static const FIGHTGENBU:String=UrlConfig.HTTPROOT+"ajax/epicbattle/genbu.json";
		/**
		 *第三个boss数据 
		 */		
		public static const FIGHTGIRL:String=UrlConfig.HTTPROOT+"ajax/epicbattle/girl.json";
		/**
		 *第四个boss数据 
		 */		
		public static const FIGHTMECHAGENBU:String=UrlConfig.HTTPROOT+"ajax/epicbattle/mechagenbu.json";
		/**
		 * 获得系统Weapon列表
		 * 接口编号：1.3
		 */
		public static const GETWEAPONLIST:String = "ajax/GetWeaponList.json";
		/**
		 *购买weapon 
		 */		
		public static const PURCHASEWEAPON:String=UrlConfig.HTTPROOT+"ajax/purchase/weapon.json";
		/**
		 *购买relic 
		 */		
		public static const PURCHASERELIC:String=UrlConfig.HTTPROOT+"ajax/purchase/relic.json";
		
		/**
		 *购买magic
		 */		
		public static const PURCHASEMAGIC:String=UrlConfig.HTTPROOT+"ajax/purchase/magic.json";
		/**
		 *卖武器或relics 
		 */			
		public static const SELLITEM:String=UrlConfig.HTTPROOT+"ajax/sell_item.json";
		
		//public static const prefix:String="http://ninjacdn.brokenbulbstudios.com/swf/";
		public static const prefix:String=UrlConfig.HTTPROOT+"swf/";
		public static const PREFIX:String=UrlConfig.HTTPROOT+"swf/";
		
		public static const debugPrefix:String="http://ninjawarz.brokenbulbstudios.com";
		
		/**
		 *武器图片存放url
		 * http://ninjacdn.brokenbulbstudios.com/swf/weaponshopgfx/cleaver.png 
		 */		
		public static const WEAPONIMGURL:String=UrlConfig.HTTPROOT+"swf/weaponshopgfx/";
		
		public static const RELICIMGURL:String=UrlConfig.HTTPROOT+"swf/relicshopgfx/";
		
		public static const RELICSTINY:String=UrlConfig.HTTPROOT+"swf/relicstiny/"
//////////////////////////////////////////////////Map相关		
		public static const MAGICIMGURL:String=UrlConfig.HTTPROOT+"swf/magicshopgfx/";
		
		public static const LEVELIMGURL:String=UrlConfig.HTTPROOT+"images/levels/"
		/**
		 *获取todo 
		 */		
		public static const GETACHIEVEMENTPROGRESS:String="map/get_achievement_progress.json";
		
		/**
		 *karma to gold 
		 */
		public static const KARMATOGOLD:String="map/karma_to_gold.json";
		/**
		 *golden_cloud 
		 */		
		public static const GOLDENCLOUD:String="map/golden_cloud.json";
		
		public static const DAIMYOGIFT:String="map/daimyo_gift.json";
		/**
		 *第一个boss 
		 */		
		public static const GIRL1:String="map/bosses/mapgirl1.swf";
		/**
		 *第三个boss 
		 */		
		public static const GIRL:String="map/bosses/mapgirl.swf";
		/**
		 *第二个boss 
		 */		
		public static const GENBU:String="map/bosses/mapgenbu.swf";

		/**
		 *第四个boss 
		 */		
		public static const MECHGENBU:String="map/bosses/mapmechagenbu.swf";
		/**
		 *比赛奖励 
		 */		
		public static const GETTOURNAMENTPRIZES:String="ajax/get_tournament_prizes.json";
		/**
		 * 比赛人员列表
		 */		
		public static const CREATTOURNAMENT:String="ajax/create_tournament.json";
		public function UrlConfig()
		{

			
						
		}
	}
}