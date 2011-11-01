package com.framework.utils.controls
{
	import flash.display.SimpleButton;
	import flash.display.Sprite;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	import flash.utils.Dictionary;
	
	/**
	 * 带label文本的按钮
	 * 
	 * @author 任冬 rendong@corp.the9.com
	 * $Id: SpButton.as 280 2010-09-05 16:18:24Z rendong $
	 * @version 1.0
	 */
	public class SpButton extends Sprite
	{
		private var _txt:String;
		private var _button:SimpleButton;
		private var _oldTxtLength:Number;
		
		protected var txtField:TextField;
		
		public function SpButton()
		{
			
		}
		
		/**
		 * 渲染按钮 
		 * @param txt
		 * @param x
		 * @param y
		 * @param width
		 * @param txtFormat
		 * 
		 */		
		protected function render(txt:String = null, x:Number=0, y:Number=0, width:Number=0, txtFormat:TextFormat = null):void
		{
			if (txt != null)
				_txt = txt;
			
			// 创建文本框
			if (txtField == null){
				txtField = new TextField();				
				addChild(txtField);
				
				if (txtFormat == null)
				{
					txtFormat = new TextFormat();
					txtFormat.align = TextFormatAlign.CENTER;
					txtFormat.color = 0xFFFFFF;
					txtFormat.size = 12;
					txtFormat.font = 'Verdana';
				}else{
					if (txtFormat.align == null || txtFormat.align == '')
						txtFormat.align = TextFormatAlign.CENTER;
				}
				// txtField.border= true;
			}
			txtField.height = this._button.height - y;
			
			if (txtFormat != null)
			{
				txtField.defaultTextFormat = txtFormat;
				txtField.setTextFormat(txtFormat);
			}
			
			txtField.x = x;
			txtField.y = y;
			if (width > 0)
				txtField.width = width;
			
			txtField.mouseEnabled = false;
			txtField.mouseWheelEnabled = false;
			
			if (_txt != null)
				txtField.htmlText = _txt;			
			
			if (_button != null)
				this.addChildAt(_button, 0);
			
			if (txtField.textWidth > 0)
				callAfterRender(txtField.textWidth);
		}
		
		/**
		 * 设置文本长度 
		 * @param width
		 * 
		 */		
		protected function setTextLength(width:Number):void
		{
			if (txtField!= null)
			{
				txtField.width = width;
			}
		}
		
		/**
		 * 文本长度发生变化调用 
		 * @param txtWidth
		 * 
		 */		
		private function callAfterRender(txtWidth:Number):void
		{
			if (_oldTxtLength != txtWidth){
				_oldTxtLength = txtWidth;
				afterRender(txtWidth);
			}
		}
		
		/**
		 * 渲染后调用
		 * 处理文本过长的情况 
		 * @param txtWidth
		 * 
		 */		
		protected function afterRender(txtWidth:Number):void
		{
			// emppty
			/**
			if (txtWidth > 100)
				txtField.width = 100;
			//**/
		}
		
		/**
		 * 设置文本 
		 * @param value
		 * 
		 */		
		public function set label(value:String):void
		{
			_txt = value;
			
			if (txtField != null && _txt != null){
				txtField.htmlText = _txt;
				callAfterRender(txtField.textWidth);
			}
		}
		
		/**
		 * 设置按钮 
		 * @param value
		 * 
		 */		
		public function set button(value:SimpleButton):void
		{
			if (_button != null && contains(_button))
				removeChild(_button);
			
			_button = value;
		}
		
	}
}