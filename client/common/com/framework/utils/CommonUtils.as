package com.framework.utils
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.InteractiveObject;
	import flash.display.Loader;
	import flash.display.LoaderInfo;
	import flash.display.PixelSnapping;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.TimerEvent;
	import flash.filters.ColorMatrixFilter;
	import flash.net.URLRequest;
	import flash.system.LoaderContext;
	import flash.text.Font;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.utils.Timer;
	/**
	 * 常用的方法
	 * @author 任冬 rendong@corp.the9.com
	 * $Id: CommonUtils.as 610 2010-12-30 09:42:45Z rendong $
	 * @version 1.0
	 */
	public class CommonUtils
	{
		/**
		 * 调试模式 
		 */		
		public static var DEBUG:Boolean = true;
		
		/**
		 * 静态图像缓存数据
		 */
		private static var _cacheImage:Object = { };
		
		/**
		 * 缓存所有的字体对应关系 
		 */		
		private static var fonts:Object;
		
		/**
		 * 判断嵌入的字体是否可以显示文本
		 *  
		 * @param str	测试的字符串
		 * @param fontName	字体名称
		 * 
		 * @return true 可以显示， false 不能显示
		 */		
		public static function fontCanDisplay(str:String, fontName:String):Boolean
		{
			if (fonts == null)
			{
				fonts ={};
				var embeddedFonts:Array = Font.enumerateFonts(false);
				for(var i:int = 0; i< embeddedFonts.length;i++)
				{
					var font:Font = embeddedFonts[i];
					
					fonts[font.fontName] = font;
				}
			}
			if (fonts[fontName] && fonts[fontName].hasGlyphs(str))
				return true;
			else{
				if (DEBUG)
					trace("FONT=>", fontName, str);
				return false;
			}
		}
		
		/**
		 * 获取静态图片
		 * 内部处理缓存
		 * @param	url	图片地址
		 * @param	callback	回调函数，参数为mc:Sprite
		 */
		public static function getImageByUrl(url:String, callback:Function):void
		{
			if (url == null || url == "")
			{
				trace("Warnning getImageByUrl:url is Empty");
				return;
			}
			
			var mc:Sprite;
			var bmd:BitmapData
			
			mc = new Sprite();
			/*
			if (_cacheImage[url])
			{
				bmd = _cacheImage[url] as BitmapData;
				bmd = bmd.clone();
				
				mc.addChild(new Bitmap(bmd, PixelSnapping.AUTO, true));
				
				callback(mc,url);
			}else{*/
				var image:Loader = new Loader();
				var lc:LoaderContext = new LoaderContext(true);
				image.contentLoaderInfo.addEventListener(Event.COMPLETE, function (e:Event) {
					var image:LoaderInfo = LoaderInfo(e.target);
					var dobj:DisplayObject = DisplayObject(image.content);					
					
					mc.addChild(dobj);
					bmd = new BitmapData(image.width, image.height, true, 0x00000000);
					bmd.draw(dobj);
					
					_cacheImage[url] = bmd;
					
					callback(mc,url);
				} );
				
				image.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, function(e:IOErrorEvent) {
					trace("图片加载失败 URL", url);
				});
				image.load(new URLRequest(url),lc);
			/*}*/
		}
		
		
		/**
		 * 设置嵌入字体显示 
		 * @param txt
		 * @param str 显示文本
		 * @param fontName
		 * 
		 */		
		public static function setEmbeddedFons(txt:TextField, str:String, fontName:String):void
		{
			if (fontCanDisplay(str, fontName))
			{
				var format:TextFormat = txt.defaultTextFormat;
				if (format == null)
					format = new TextFormat();
				
				format.font = fontName;
				
				txt.setTextFormat(format);
				txt.embedFonts = true;
			}else{
				txt.embedFonts = false;
			}
		}
		/**
		 *秒转换为string 
		 * @param param1 秒数
		 * @param param2
		 * @param param3
		 * @param param4
		 * @param param5
		 * @param param6
		 * @return 
		 * 
		 */		
		public function secondsToString(param1:int, param2:Array = null, param3:Array = null, param4:Boolean = false, param5:String = "", param6:Boolean = false):String
		{
			var _loc_10:uint = 0;
			var _loc_7:Array = [];
			var _loc_8:* = param1 < 0 ? ("-") : ("");
			if (!param2)
			{
				param2 = [1, 60, 3600, 86400];
			}
			if (!param3)
			{
				param3 = ["s", "m", "h", "d"];
			}
			param1 = Math.abs(param1);
			var _loc_9:* = param2.length - 1;
			while (_loc_9--)
			{
				
				_loc_10 = Math.floor(param1 / param2[_loc_9]);
				_loc_7.push((_loc_10 < 10 ? ("0") : ("")) + _loc_10 + (_loc_9 > 0 ? (":") : ("")));
				param1 = param1 % param2[_loc_9];
			}
			return (param6 ? (_loc_8) : ("")) + _loc_7.join("");
		}
		/**
		 *传入int返回格式化的string 10000=>10,000 
		 * @param param1
		 * @return 
		 * 
		 */		
		public static function getFormattedNumber(param1:int):String
		{
			var _loc_2:* = "" + param1;
			var _loc_3:* = new Array();
			var _loc_4:int = 0;
			var _loc_5:* = _loc_2.length;
			while (_loc_5 > 0)
			{
				
				_loc_4 = Math.max(_loc_5 - 3, 0);
				_loc_3.unshift(_loc_2.slice(_loc_4, _loc_5));
				_loc_5 = _loc_4;
			}
			return _loc_3.join(",");
		}// end function
	}
}