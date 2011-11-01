package com.framework.utils
{
	
	import flash.accessibility.AccessibilityProperties;
	import flash.display.*;
	import flash.events.*;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.text.*;
	import flash.utils.Dictionary;
	
	/**
	 * tootip显示类
	 * @author chengang
	 * 
	 */	
	public class ToolTip extends Sprite	
	{
		/**
		 * 单例 
		 */		
		private static var instance:ToolTip = null;
		
		/**
		 * 样式 
		 * 默认样式为：default
		 */		
		private var styles:Object={};
		
		/**
		 * 绑定tip key => vo
		 */		
		private var tipBinds:Dictionary;
	
		private var currentTipSp:Sprite;
		private var currentTxt:TextField;
		private var currentTipVo:ToolTipVo;
		
		/**
		 * 获取实例 
		 * @return 
		 * 
		 */		
		private static function getInsance():ToolTip
		{
			if (instance == null){
				instance = new ToolTip();
				
				// 设置默认样式
				setStyle("default", 0xFFFFFF,null, 200,6,0x0,0.9,0x0,0.6);
			}
			
			return instance;
		}
		
		/**
		 * 设置tooltip样式
		 * 默认样式名为default 
		 * 
		 * @param style			样式名称
		 * @param bgClass		背景资源
		 * @param scale9Grid	缩放网络
		 * @param defaultTxtColor	默认字体颜色
		 * @param format		字体样式
		 * @param defaultWidth		默认宽度
		 * 
		 */		
		public static function setStyle(style:String, defaultTxtColor:uint, format:TextFormat, defaultWidth:Number,bgBoder:int, bgBoderColor:uint,bgBorderAlpha:Number,bgColor:uint,bgAlpha:Number):void
		{
			getInsance()._setStyle(style, defaultTxtColor,format, defaultWidth,bgBoder, bgBoderColor,bgBorderAlpha,bgColor,bgAlpha);
		}
		
		/**
		 * 增加tooltip
		 * 如果已经有，则修改 
		 * 一个对象，只能加一种tooltip
		 * 
		 * @param area		需要提示的对象
		 * @param message	提示信息
		 * @param tipWidth	宽度，如果为0，则自动扩展
		 * @param style		显示样式
		 * @param txtColor	字体颜色,如果为默认值，则取样式的默认值
		 * 
		 */		
		public static function show(area:DisplayObject, htmlMessage:String, tipWidth:Number = -1, style:String = null, txtColor:uint = 0x0):void 
		{
			getInsance()._show(area, htmlMessage, tipWidth, style,txtColor);
		}
	
		/**
		 * 移除tip
		 * 
		 * @param area
		 * 
		 */		
		public static function removeTip(area:DisplayObject):void 
		{
			getInsance()._removeTip(area);
		}
		
		// 具体显示方法
		private function _show(area:DisplayObject, htmlMessage:String, tipWidth:Number, style:String, txtColor:uint):void 
		{
			if (tipBinds == null)
				tipBinds = new Dictionary(true);
			
			var tipVo:ToolTipVo;
			for(var key:Object in tipBinds)
			{
				tipVo = tipBinds[key];
				if (tipVo.srcDisplayObject == area)
				{
					break;
				}
			}
			if (tipVo == null || tipVo.srcDisplayObject != area)
			{
				tipVo = new ToolTipVo();
				tipVo.area = area;
				tipBinds[area] = tipVo;
				tipVo.srcDisplayObject = area;
			}
			
			if (style == null)
				style = 'default';
			
			tipVo.style = style;
			tipVo.htmlMessage = htmlMessage;
			tipVo.tipWidth = tipWidth;
			tipVo.txtColor = txtColor;
			
			if (area.stage)
				initTip(tipVo.area);
			else{
				area.removeEventListener(Event.ADDED_TO_STAGE, addToStageHandler);
				area.addEventListener(Event.ADDED_TO_STAGE, addToStageHandler);
			}
		}
		
		//移除
		private function _removeTip(area:DisplayObject):void 
		{
			var tipVo:ToolTipVo;
			for(var key:Object in tipBinds)
			{
				tipVo = tipBinds[key];
				if (tipVo.srcDisplayObject == area)
				{
					break;
				}
			}
			
			// 删除事件
			if (tipVo != null && tipVo.srcDisplayObject == area)
			{
				if (tipVo.area != area)
					tipVo.area.parent.removeChild(tipVo.area);
				
				if (currentTipVo!= null && currentTipVo.area == tipVo.area)
					outHandler();
				
				tipVo.srcDisplayObject.removeEventListener(Event.ADDED_TO_STAGE, addToStageHandler);
				tipVo.area.removeEventListener(MouseEvent.MOUSE_MOVE, moveHandler);
				tipVo.area.removeEventListener(MouseEvent.ROLL_OUT, outHandler);	
				delete tipBinds[tipVo.area];
			}
		}
		
		// 添加到舞台
		private function addToStageHandler(e:Event):void
		{
			var mouseArea:DisplayObject = e.target as DisplayObject;
			mouseArea.removeEventListener(Event.ADDED_TO_STAGE, addToStageHandler);
			
			initTip(mouseArea);
		}
		
		/**
		 * 初始化tooltip 
		 * @param mouseArea
		 * 
		 */		
		private function initTip(area:DisplayObject):void
		{
			var vo:ToolTipVo = tipBinds[area];
			
			var mouseArea:InteractiveObject = area as InteractiveObject;
			
			// 如果正在显示，则直接修改
			if (currentTipVo != null && currentTipVo.area == area)
			{
				var style:ToolTipStyleVo = styles[currentTipVo.style];
				if (style == null)
					style = styles['default'];
				
				var txtWidth:Number = 0;
				if (currentTipVo.tipWidth == -1){
					txtWidth = style.defaultWidth;
				}else
					txtWidth = currentTipVo.tipWidth;
				
				currentTxt.htmlText = currentTipVo.htmlMessage;
				
				// 字体颜色处理
				if (currentTipVo.txtColor == 0x0)
					style.defaultTxtFormat.color = style.defaultTxtColor;
				else
					style.defaultTxtFormat.color = currentTipVo.txtColor;
				
				currentTxt.defaultTextFormat = style.defaultTxtFormat;
				currentTxt.setTextFormat(style.defaultTxtFormat);
				// 嵌入字体判断
				currentTxt.embedFonts = CommonUtils.fontCanDisplay(currentTipVo.htmlMessage, style.defaultTxtFormat.font);
				
				var width:Number = currentTxt.textWidth + 2 * style.bgBoder;
				var height:Number = currentTxt.textHeight + 2 * style.bgBoder;
				
				if (currentTxt.textWidth < txtWidth)
					txtWidth = currentTxt.textWidth;
				
				if (txtWidth>0)
					width = txtWidth + 2 * style.bgBoder;
				
				// 背景大小处理
				currentTipSp.graphics.clear();
				currentTipSp.graphics.beginFill(style.bgColor, style.bgAlpha);
				currentTipSp.graphics.drawRoundRect(-style.bgBoder, -style.bgBoder, width, height, style.bgBoder, style.bgBoder);
				currentTipSp.graphics.endFill();
				
				currentTipSp.graphics.lineStyle(1, style.bgBoderColor, style.bgBorderAlpha);
				currentTipSp.graphics.drawRoundRect( -style.bgBoder, -style.bgBoder, width, height, style.bgBoder, style.bgBoder);
				
				return;
			}
			
			// 如果被禁用，则创建透明层，接收鼠标事件
			if (mouseArea == null || mouseArea.mouseEnabled == false)
			{
				var rect:Rectangle = area.getBounds(area.parent);
				var sprite:Sprite = new Sprite();
				
				sprite.graphics.beginFill(0x0, 0);
				sprite.graphics.drawRect(0, 0, rect.width, rect.height);
				sprite.graphics.endFill();
				
				sprite.x = rect.x;
				sprite.y = rect.y;
				
				area.parent.addChild(sprite);
				mouseArea = sprite;
				
				vo.area = mouseArea;
				
				delete tipBinds[area];
				tipBinds[sprite] = vo;
			}
			
			mouseArea.removeEventListener(MouseEvent.MOUSE_MOVE, moveHandler);
			mouseArea.removeEventListener(MouseEvent.ROLL_OUT, outHandler);		
			
			mouseArea.addEventListener(MouseEvent.MOUSE_MOVE, moveHandler,false,0,true);
			mouseArea.addEventListener(MouseEvent.ROLL_OUT, outHandler,false,0,true);	
		}
		
		// 鼠标移入、移动
		private function moveHandler(e:MouseEvent):void
		{
			var area:InteractiveObject = e.currentTarget as InteractiveObject;
			
			currentTipVo = tipBinds[area];
			
			var style:ToolTipStyleVo = styles[currentTipVo.style];
			if (style == null)
				style = styles['default'];
			
			var txtWidth:Number = 0;

			if (currentTipSp == null)
			{
				currentTipSp = new Sprite();
				currentTipSp.mouseChildren = false;
				currentTipSp.mouseEnabled = false;
				area.stage.addChild(currentTipSp);
								
				currentTxt = new TextField();
				//currentTxt.border = true;
				//currentTxt.borderColor = 0xFF00;
				
				// 字体颜色处理
				if (currentTipVo.txtColor == 0x0)
					style.defaultTxtFormat.color = style.defaultTxtColor;
				else
					style.defaultTxtFormat.color = currentTipVo.txtColor;
				
				currentTxt.defaultTextFormat = style.defaultTxtFormat;
				currentTxt.setTextFormat(style.defaultTxtFormat);
				// 嵌入字体判断
				currentTxt.embedFonts = CommonUtils.fontCanDisplay(currentTipVo.htmlMessage, style.defaultTxtFormat.font);
				
				if (currentTipVo.tipWidth == -1){
					txtWidth = style.defaultWidth;
				}else
					txtWidth = currentTipVo.tipWidth;
				
				if (txtWidth > 0){
					currentTxt.width = txtWidth;
					currentTxt.wordWrap = true;
				}
				
				currentTxt.autoSize = TextFieldAutoSize.LEFT;
				
				currentTipSp.addChild(currentTxt);
				currentTxt.htmlText = currentTipVo.htmlMessage;
				
				var width:Number = currentTxt.textWidth + 2 * style.bgBoder;
				var height:Number = currentTxt.textHeight + 2 * style.bgBoder;
				
				if (currentTxt.textWidth < txtWidth)
					txtWidth = currentTxt.textWidth;
				
				if (txtWidth>0)
					width = txtWidth + 2 * style.bgBoder;
				
				// 背景大小处理
				currentTipSp.graphics.clear();
				currentTipSp.graphics.beginFill(style.bgColor, style.bgAlpha);
				currentTipSp.graphics.drawRoundRect(-style.bgBoder, -style.bgBoder, width, height, style.bgBoder, style.bgBoder);
				currentTipSp.graphics.endFill();
				
				currentTipSp.graphics.lineStyle(1, style.bgBoderColor, style.bgBorderAlpha);
				currentTipSp.graphics.drawRoundRect( -style.bgBoder, -style.bgBoder, width, height, style.bgBoder, style.bgBoder);
			}
			
			// 位置处理
			currentTipSp.x = e.stageX;
			currentTipSp.y = e.stageY + 25;
			
			// 超出修正处理
			if (currentTipSp.y + currentTipSp.height > currentTipSp.stage.stageHeight){
				currentTipSp.y = e.stageY - currentTipSp.height;
			}
			if (currentTipSp.y < 0)
				currentTipSp.y = 0;
			
			txtWidth = currentTxt.textWidth + 2 * style.bgBoder;

			if (currentTipSp.x + txtWidth > currentTipSp.stage.stageWidth)
				currentTipSp.x = currentTipSp.stage.stageWidth - txtWidth;
		}
		
		// 鼠标移出
		private function outHandler(e:MouseEvent=null):void
		{
			if (currentTipVo != null)
			{
				currentTipSp.parent.removeChild(currentTipSp);
				currentTipSp = null;
				currentTipVo = null;
				currentTxt = null;
			}
		}
		
		// 具体方法
		private function _setStyle(style:String, defaultTxtColor:uint, format:TextFormat, defaultWidth:Number, bgBoder:int, bgBoderColor:uint,bgBorderAlpha:Number,bgColor:uint,bgAlpha:Number):void
		{			
			if (format == null)
			{
				format = new TextFormat();
				format.font = "_sans";
				format.size = 12;
			}
			
			var vo:ToolTipStyleVo = new ToolTipStyleVo();
			vo.bgAlpha = bgAlpha;
			vo.bgColor = bgColor;
			
			vo.bgBoder = bgBoder;
			vo.bgBoderColor = bgBoderColor;
			vo.bgBorderAlpha = bgBorderAlpha;
			
			vo.style = style;
			vo.defaultTxtFormat = format;
			vo.defaultTxtColor = defaultTxtColor;
			vo.defaultWidth = defaultWidth;
			
			styles[style] = vo;
		}
		
	}
}

import flash.display.DisplayObject;
import flash.display.Sprite;
import flash.geom.Rectangle;
import flash.text.TextFormat;

/**
 * 样式vo 
 * @author rendong
 * 
 */
class ToolTipStyleVo{
	public var style:String;
	public var defaultTxtColor:uint;
	public var defaultWidth:Number;
	public var defaultTxtFormat:TextFormat;
	
	public var bgBoder:int;
	public var bgBoderColor:uint;
	public var bgBorderAlpha:Number;
	
	public var bgColor:uint;
	public var bgAlpha:Number;
}

class ToolTipVo{
	public var style:String;
	public var area:DisplayObject;
	public var htmlMessage:String;
	public var tipWidth:Number;
	public var txtColor:uint;
	/**
	 * 辅助层，如果本身被禁用 
	 */	
	public var srcDisplayObject:DisplayObject;
}