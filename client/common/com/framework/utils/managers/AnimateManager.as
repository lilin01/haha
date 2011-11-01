package com.framework.utils.managers
{
	import caurina.transitions.Tweener;
	
	import flash.display.DisplayObject;
	
	/**
	 * 动画效果管理类
	 * 显示类动画以show开头
	 * 隐藏类动画以hide开头
	 * 
	 * @author 任冬 rendong@corp.the9.com
	 * $Id: AnimateManager.as 247 2010-08-24 07:19:16Z rendong $
	 * @version 1.0
	 */
	public class AnimateManager
	{
		/**
		 * window7 菜单打开效果 
		 * @param mc
		 * 
		 */		
		public static function showWin7Window(window:DisplayObject, windowWidth:Number=0, windowHeight:Number = 0):void
		{
			var _x:Number = window.x;
			var _y:Number = window.y;
			
			windowWidth = windowWidth || window.width;
			windowHeight = windowHeight || window.height;
			
			window.x = window.x + windowWidth * 0.1;
			window.y = window.y + windowHeight * 0.1;
			
			window.scaleX = 0.8;
			window.scaleY =  0.8;
			
			window.alpha = 0.3;
			
			Tweener.addTween(window, { x:_x, y:_y, scaleX:1, scaleY:1, time:0.1,transition:"easeInSine"});
			Tweener.addTween(window, { alpha:1, transition:"linear", time:0.3 } );
		}
		
		/**
		 * window7 菜单关闭效果 
		 * @param window
		 * 
		 */		
		public static function hideWin7Window(window:DisplayObject, windowWidth:Number=0, windowHeight:Number = 0):void
		{
			var _x:Number = window.x;
			var _y:Number = window.y;
			
			windowWidth = windowWidth || window.width;
			windowHeight = windowHeight || window.height;
			
			var __x:Number = _x + windowWidth * 0.1;
			var __y:Number = _y + windowHeight * 0.1;
			
			Tweener.addTween(window, { x:__x, y:__y, scaleX:0.8, scaleY:0.8, time:0.1, transition:"easeInSine", onComplete:function():void {
				window.visible = false;
				window.x = _x;
				window.y = _y;
				window.scaleX = 1;
				window.scaleY = 1;
			}});
			Tweener.addTween(window, { alpha:0.3, transition:"linear", time:0.1, onComplete:function():void {
				window.alpha = 1;
			} } );
		}
	}
}