package com.framework.utils.controls
{
	import flash.display.DisplayObject;
	import flash.display.Shape;
	import flash.display.Sprite;
	import com.framework.utils.managers.WindowManager;
	
	/**
	 * ViewManager
	 * @author 任冬 rendong@corp.the9.com
	 * $Id: FLViewStack.as 253 2010-08-25 09:11:34Z rendong $
	 * @version 1.0
	 */
	public class FLViewStack extends Sprite
	{
		private var _selectedItem:DisplayObject;
		
		private var _animateHandler:Function;
		private var _width:Number;
		private var _height:Number;
		
		/**
		 * 创建视图管理器
		 * 在做tab时用到 
		 * @param width
		 * @param height
		 * 
		 */		
		public function FLViewStack(width:Number, height:Number, mask:Boolean = false)
		{
			_width = width;
			_height = height;
			
			if (mask)
			{
				var shape:Shape = new Shape();
				shape.graphics.beginFill(0x0, 0);
				shape.graphics.drawRect(0,0, width, height);
				shape.graphics.endFill();
				addChild(shape);
				this.mask = shape;
			}
		}
		
		/**
		 * 设置动画效果回调
		 * 回调动画时，已经把显示关系处理好了
		 *  
		 * @param func	动画处理函数，参数：oldDisplayObject currentDisplayObject width height
		 * 
		 */		
		public function setAnimateHandler(func:Function):void
		{
			_animateHandler = func;
		}
		
		/**
		 * 返回当前显示的菜单 
		 * @return 
		 * 
		 */		
		public function get selectedItem():DisplayObject {
			return _selectedItem;
		}
		
		/**
		 * 设置当前显示什么菜单 
		 * @param value
		 * 
		 */		
		public function set selectedItem(value:DisplayObject):void 
		{
			if (value == _selectedItem)
				return;
			var old:DisplayObject = _selectedItem;
			
			_selectedItem = value;
			
			var tmp:DisplayObject;
			
			for(var i:int=0; i<this.numChildren; i++)
			{
				tmp = getChildAt(i);
				
				if (tmp != value)
					tmp.visible = false;
				else
					tmp.visible = true;
			}
			
			WindowManager.setFront(value, this);
			
			// 动画处理
			if (_animateHandler != null)
				_animateHandler(old, _selectedItem, _width, _height);			
		}
	}
}