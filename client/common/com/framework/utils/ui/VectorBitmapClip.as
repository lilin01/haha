package com.framework.utils.ui
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.TimerEvent;
	import flash.geom.Matrix;
	import flash.geom.Rectangle;
	import flash.utils.Timer;
	import flash.utils.getTimer;
	
	
	/**
	 * 矢量动画转换为位图动画播放
	 * 
	 * @author 任冬 rendong@corp.the9.com
	 * $Id: VectorBitmapClip.as 506 2010-11-24 07:22:50Z rendong $
	 * @version 1.0
	 */
	public class VectorBitmapClip extends Sprite
	{
		/**
		 * 全局缩放参数 
		 */		
		private static var _scaleX:Number=1;
		/**
		 * 全局缩放参数 
		 */		
		private static var _scaleY:Number=1;

		/**
		 * 矢量动画 
		 */		
		private var _mc:MovieClip;
		
		/**
		 * 动画显示区域 
		 */		
		private var _rect:Rectangle;
		/**
		 * copy 矩阵 
		 */		
		private var _matrix:Matrix;
		
		/**
		 * 显示的位图 
		 */		
		private var bm:Bitmap;
		
		/**
		 * 缓存的位图数组 
		 */
		private var cachedBmd:Vector.<BitmapData>;
		
		/**
		 * 公用定时器 
		 */		
		private static var cachedTimer:Object = {};
		
		private var frameRate:int;
		
		/**
		 * 是否播放动画 
		 */		
		private var _play:Boolean;
		
		/**
		 * 实例中帧的总数 
		 */
		public var totalFrames:int;
		
		/**
		 * 帧事件处理函数 
		 */		
		private var enterFrameCallback:Function=null;
		
		/**
		 * 指定播放头在 MovieClip 实例的时间轴中所处的帧的编号 
		 */		
		public var currentFrame:int=0;
		
		private var __scaleX:Number;
		private var __scaleY:Number;
		
		private var __width:Number;
		private var __height:Number;
		
		/**
		 * 设置缩放参数 
		 * @param scaleX
		 * @param scaleY
		 * 
		 */		
		public static function setScale(scaleX:Number, scaleY:Number):void
		{
			_scaleX = scaleX;
			_scaleY = scaleY;
		}

		/**
		 * 初始化矢量动画 
		 * @param mc
		 * @param frameRate	帧率
		 * 
		 */		
		public function VectorBitmapClip(mc:MovieClip, frameRate:int = 0)
		{
			this.frameRate = frameRate;
			__width = mc.width;
			__height = mc.height;
			
			_mc = mc;
			
			if (stage)
				init();
			else
				addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		/**
		 * 获取初始宽度 
		 * @return 
		 * 
		 */		
		public function getInitWidth():Number
		{
			return __width;
		}
		
		/**
		 * 获取初始高度 
		 * @return 
		 * 
		 */		
		public function getInitHeight():Number
		{
			return __height;
		}
		
		public override function get width():Number
		{
			return __width * __scaleX;
		}
		
		public override function get height():Number
		{
			return __height * __scaleY;
		}
		
		/**
		 * 初始化 
		 * @param e
		 * 
		 */		
		private function init(e:Event=null):void
		{
			// 初始化数组
			cachedBmd = new Vector.<BitmapData>(_mc.totalFrames+1);
			
			// 初始化位图
			bm = new Bitmap();			
			addChild(bm);
			
			createRectAndMatrix();
			
			if (this.frameRate == 0)
				this.frameRate = stage.frameRate;
			
			var fps:int = 1000/this.frameRate;
			// 初始化timer
			if (cachedTimer[fps] == null)
			{
				cachedTimer[fps] = new Timer(fps, 0);
				cachedTimer[fps].start();
			}
			
			cachedTimer[fps].addEventListener(TimerEvent.TIMER, timerHandler);
			addEventListener(Event.REMOVED_FROM_STAGE, removeHandler);
			
			// 播放处理
			if (currentFrame > 0)
				_play = false;
			else{
				_play = true;
				currentFrame = 1;
			}
			
			totalFrames = _mc.totalFrames;
		}
		
		// 移除出舞台，释放内存
		private function removeHandler(e:Event):void
		{
			removeEventListener(Event.REMOVED_FROM_STAGE, removeHandler);
			
			var fps:int = 1000/this.frameRate;
			// 初始化timer
			if (cachedTimer[fps] != null)
			{
				_play = false;
				cachedTimer[fps].removeEventListener(TimerEvent.TIMER, timerHandler);
			}
			
			for(var i:int = 0; i< cachedBmd.length; i++){
				if (cachedBmd[i] != null)
					(cachedBmd[i] as BitmapData).dispose();
				cachedBmd[i] = null;
			}
			
			currentFrame = 0;
		}
		
		/**
		 * 获得通道属性 
		 * @param localX
		 * @param localY
		 * 
		 */		
		public function getPixel32(localX:Number,localY:Number):uint
		{
			if(bm == null)
				return 0;
			return bm.bitmapData.getPixel32(localX-bm.x,localY-bm.y);
		}
		
		/**
		 * 创建copy区域和矩阵
		 */		
		private function createRectAndMatrix():void
		{
			_rect = _mc.getBounds(_mc);
			
			_matrix = new Matrix();
			_matrix.createBox(_scaleX, _scaleY, 0, -_rect.left * _scaleX, -_rect.top * _scaleY);
			
			bm.x = _rect.x * _scaleX;
			bm.y = _rect.y * _scaleY;
			
			for(var i:int = 0; i< cachedBmd.length; i++){
				if (cachedBmd[i] != null)
					(cachedBmd[i] as BitmapData).dispose();
				cachedBmd[i] = null;
			}
		}
		
		/**
		 * 帧事件 
		 * @param e
		 * 
		 */		
		private function timerHandler(e:TimerEvent=null):void
		{
			if (__scaleX != _scaleX || __scaleY != _scaleY){
				createRectAndMatrix();
				__scaleX = _scaleX;
				__scaleY = _scaleY;
				this.scaleX = 1/ _scaleX;
				this.scaleY = 1/ _scaleY;
				if(this.parent!=null)
					if(this.parent is (VectorBitmapClip))
					{
						this.scaleX /= this.parent.scaleX; 
						this.scaleY /= this.parent.scaleY;
					}
			}
			
			if ((visible))
			{
				if (currentFrame > totalFrames)
					currentFrame = 1;
				
				if (cachedBmd[currentFrame] == null)
				{
					_mc.gotoAndStop(currentFrame);
					
					cachedBmd[currentFrame] = new BitmapData(_rect.width * _scaleX, _rect.height * _scaleY, true, 0x0);
					cachedBmd[currentFrame].draw(_mc,_matrix);
				
					// 释放mc
					if (currentFrame == totalFrames)
					{
						_mc.stop();
					}
				}
				
				if (enterFrameCallback != null)
				{
					enterFrameCallback(this);
				}
				
				bm.bitmapData = cachedBmd[currentFrame];
				
				if (_play)
					currentFrame++;
			}
		}
		
		/**
		 * 设置帧事件处理函数 
		 * @param callback	无参数
		 * 
		 */		
		public function setEnterFrameHandler(callback:Function):void
		{
			this.enterFrameCallback = callback;
		}
		
		/**
		 * 从指定帧开始播放 SWF 文件 
		 * @param frame
		 * 
		 */		
		public function gotoAndPlay(frame:int):void
		{
			if (frame > 0 && frame <= totalFrames)
				currentFrame = frame;
			
			play();
		}
		
		/**
		 * 播放指定帧 
		 * @param frame
		 * 
		 */		
		public function gotoAndStop(frame:int):void
		{
			currentFrame = frame;
			
			if (stage)
			{
				timerHandler();
				stop();
			}
		}
		
		/**
		 * 动画播放 
		 * 
		 */		
		public function play():void
		{
			_play = true;
		}
		
		/**
		 * 停止播放 
		 * 
		 */		
		public function stop():void
		{
			_play = false;
		}
	}
}