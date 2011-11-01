package com.framework.utils.managers
{
	import com.framework.utils.controls.SpButton;
	
	import flash.display.DisplayObject;
	import flash.display.SimpleButton;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	import flash.utils.Dictionary;
	
	/**
	 * 弹出框管理类
	 * 提供稍微通用的alert、confirm对话框
	 * 如果不满足需要，请使用原始的show方法
	 * 
	 * @author 任冬 rendong@corp.the9.com
	 * $Id: AlertManager.as 282 2010-09-06 02:19:10Z rendong $
	 * @version 1.0
	 */
	public class AlertManager extends Sprite
	{
		/**
		 * 默认样式 
		 */		
		public static const STYLE_DEFAULT:String = "default";
		/**
		 * 警告样式 
		 */		
		public static const STYLE_WARN:String = "warn";
		
		/**
		 * 保存所有样式 
		 */		
		private static var styles:Object;
		
		// 回调函数1
		private var callback_1:Function;
		private var callback_2:Function;
		// 按钮
		private var btn1:SpButton;
		private var btn2:SpButton;
		
		public function AlertManager()
		{
		}
		
		
		/**
		 * 添加样式 
		 * @param style			风格名称
		 * @param bgResource	背景资源
		 * @param btn_ok
		 * @param btn_cancel
		 * @param txtRect		文本框的区域 
		 * @param btnRect		按钮区域
		 * 
		 */		
		public static function addStyle(style:String, bgResource:Class,btn_ok:Class, btn_cancel:Class, ok:String, cancel:String, txtRect:Rectangle, btnRect:Rectangle, txtFormat:TextFormat=null):void
		{
			if (AlertManager.styles == null)
				AlertManager.styles = {};
			
			var param:Object = {};
			param['bg'] = bgResource;
			param['txtRect'] = txtRect;
			param['btnRect'] = btnRect;
			param['btn_ok'] = btn_ok;
			param['btn_cancel'] = btn_cancel;
			param['format'] = txtFormat;
			param['ok'] = ok;
			param['cancel'] = cancel;
			AlertManager.styles[style] = param;
		}
		
		/**
		 * 弹出提示信息框 
		 * @param message	提示信息 支持html标签
		 * @param callback	点击按钮后的回调
		 * 
		 */
		public static function showInfoDialog(message:String, callback:Function = null):void
		{
			show(message, AlertManager.STYLE_DEFAULT, "default", null, callback,null);
		}
		
		/**
		 * 弹出警告信息框 
		 * @param message	提示信息 支持html标签
		 * @param callback	点击按钮后的回调
		 * 
		 */
		public static function showWarnDilaog(message:String, callback:Function = null):void
		{
			show(message, AlertManager.STYLE_WARN, "default", null, callback,null);
		}
		
		/**
		 * 弹出confirm确认信息框 
		 * @param message	提示信息 支持html标签
		 * @param callback	点击第一个按钮后的回调
		 * 
		 */
		public static function showConfirmDialog(message:String, callback:Function = null):void
		{
			show(message, AlertManager.STYLE_WARN, "default", "default", callback,null);
		}
		
		
		/**
		 * 显示弹出框 
		 * @param message			提示信息 支持html标签
		 * @param style				提示框样式
		 * @param txt_btn_1_message 按钮1文字 如果为：default 则为显示默认
		 * @param txt_btn_2_message 按钮2文字 如果为：default 则为显示默认
		 * @param callback_1		按钮1的回调
		 * @param callback_2		按钮2的回调
		 * 
		 */		
		public  static function show(message:String, style:String,
							  txt_btn_1_message:String = "default", txt_btn_2_message:String = null,
							  callback_1:Function = null, callback_2:Function = null):void
		{
			var alert:AlertManager = new AlertManager();
			if (AlertManager.styles == null || AlertManager.styles[style]==null)
				throw new ArgumentError("还未初始该样式:" + style);
			
			var param:Object = AlertManager.styles[style];
			
			var cl:Class;
			var rect:Rectangle;
			
			cl = param['bg'];
			var bg:DisplayObject = new cl() as DisplayObject;
			
			alert.addChild(bg);
			
			// 文本处理
			var format:TextFormat = param['format'];
			rect = param['txtRect'];
			var txt:TextField = new TextField();
			// txt.border = true;
			txt.x = rect.x;
			txt.y = rect.y;
			txt.width = rect.width;
			txt.height = rect.height;
			
			txt.wordWrap = true;
			txt.tabEnabled = false;
			
			alert.addChild(txt);

			txt.htmlText = message||"";
			if (format != null)
			{
				txt.defaultTextFormat = format;
				txt.setTextFormat(format);
			}
			
			// 文本垂直居中处理
			trace(txt.height, txt.textHeight);
			txt.y += (txt.height - txt.textHeight) /2;
			txt.autoSize = TextFieldAutoSize.LEFT;
			
			// 添加按钮
			cl = param['btn_ok'];
			
			var btn1:SpButton = new cl() as SpButton;
			alert.btn1 = btn1;
			if (btn1 == null)
				throw new ArgumentError("按钮类型错误，应该为:SpButton的继承类");
			var btn2:SpButton = null;
			if (txt_btn_2_message != null){
				cl = param['btn_cancel'];
				btn2 = new cl() as SpButton;
			}
			alert.btn2 = btn2;
			
			// 按钮文本处理
			if (txt_btn_1_message == null || txt_btn_1_message == 'default')
				txt_btn_1_message = param['ok'];
			
			btn1.label = txt_btn_1_message;
			
			if (txt_btn_2_message == 'default')
			{
				btn2.label = param['cancel'];
			}else if (txt_btn_2_message != null)
				btn2.label = txt_btn_2_message;
			
			rect = param['btnRect'];
			// 加入按钮
			if (btn2 == null)
			{
				alert.addChild(btn1);
				btn1.x = rect.x + rect.width /2 - btn1.width / 2;
				btn1.y = rect.y;
			}else{
				alert.addChild(btn1);
				alert.addChild(btn2);
				
				btn1.x = rect.x;
				btn1.y = rect.y;
				btn2.x = rect.x + rect.width - btn2.width;
				btn2.y = rect.y;
			}
			
			alert.callback_1 = callback_1;
			alert.callback_2 = callback_2;
			
			// 事件处理
			btn1.addEventListener(MouseEvent.CLICK, alert.click1Handler);
			if (btn2 != null)
				btn2.addEventListener(MouseEvent.CLICK, alert.click2Handler);
			
			// 显示
			WindowManager.popWindowToStage(alert, true, true);
		}
		
		/**
		 * 按钮1事件
		 * @param	e
		 */
		private function click1Handler(e:MouseEvent):void
		{
			close();
			
			if (callback_1 != null)
				callback_1();
		}
		
		/**
		 * 按钮2事件
		 * @param	e
		 */
		private function click2Handler(e:MouseEvent):void
		{
			close();
			
			if (callback_2 != null)
				callback_2();
		}
		
		/**
		 * 关闭
		 */
		private function close():void
		{
			if (btn1)
				btn1.removeEventListener(MouseEvent.CLICK, click1Handler);
			if (btn2)
				btn2.removeEventListener(MouseEvent.CLICK, click2Handler);
			
			WindowManager.closeWindow(this, false);
			this.stage.removeChild(this);
		}
	}
}