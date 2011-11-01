package com.framework.test
{
	import caurina.transitions.Tweener;
	
	import com.framework.controller.BaseController;
	import com.framework.test.button.TestButton;
	import com.framework.test.controller.TestController;
	import com.framework.utils.Singleton;
	import com.framework.utils.ToolTip;
	import com.framework.utils.controls.FLViewStack;
	import com.framework.utils.controls.SpButton;
	import com.framework.utils.debug.Debug;
	import com.framework.utils.debug.FPSStats;
	import com.framework.utils.filters.HttpJsonSFilter;
	import com.framework.utils.loader.DisplayLoader;
	import com.framework.utils.loader.HttpLoader;
	import com.framework.utils.loader.MutiFileLoader;
	import com.framework.utils.loader.events.MutiFileLoaderEvent;
	import com.framework.utils.managers.AlertManager;
	import com.framework.utils.managers.WindowManager;
	import com.framework.utils.ui.VectorBitmapClip;
	import com.framework.view.ViewComponent;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.Loader;
	import flash.display.LoaderInfo;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.geom.Rectangle;
	import flash.net.URLRequestMethod;
	import flash.net.URLVariables;
	import flash.system.ApplicationDomain;
	import flash.text.TextField;
	import flash.utils.Timer;
	import flash.utils.setTimeout;
	
	import test.AlertBg;
	
	
	/**
	 * framework
	 * @author 任冬 rendong@corp.the9.com
	 * $Id: framework.as 607 2010-12-30 04:00:26Z rendong $
	 * @version 1.0
	 */
	public class framework extends Sprite
	{
		private var i:int = 0;
		private var flag:Boolean;
		private var dialog:Sprite;
		
		private var vm:FLViewStack;
		private var tab1:Sprite;
		private var tab2:Sprite;
		
		public function framework()
		{
			stage.align = flash.display.StageAlign.TOP_LEFT;
			stage.scaleMode = flash.display.StageScaleMode.NO_SCALE;
		
			//stage.addChild(new FPSStats());
			
			//TestController.instance.init();
			
			//httpTest();
			//displayLoaderTest();
			// mutiFileLoaderTest();
			// tabTest();
			
			//tooltipTest();
			buttonTest();
			
			// cacheLoaderTest();
			//vectorBitmapTest();
			//stage.addEventListener(MouseEvent.CLICK, clickHandler);
		}
		
		public function vectorBitmapTest():void
		{
			var bm:VectorBitmapClip;
			DisplayLoader.getLoaderInfo("../res/frame.swf", function (loaderInfo:LoaderInfo):void{
				//addChild(loaderInfo.content);
				
				bm = new VectorBitmapClip(loaderInfo.content as MovieClip, 5);
				bm.x = 100;
				bm.y = 300;
				addChild(bm);
				bm.setEnterFrameHandler( function ():void{
					trace(bm.currentFrame, bm.totalFrames);
				});
				
			});
			
			
			setTimeout(function ():void{
				removeChild(bm);
			}, 2000);
			
			
		}
		
		
		/**
		 * viewManager 测试 
		 * 
		 */		
		private function tabTest():void
		{
			vm = new FLViewStack(300,200, true);
			
			tab1 = new Sprite();
			tab1.graphics.beginFill(0x00FFFF, 1);
			tab1.graphics.drawRect(0,0, 300,200);
			tab1.graphics.endFill();
			
			tab2 = new Sprite();
			tab2.graphics.beginFill(0xFF00FF, 1);
			tab2.graphics.drawRect(0,0, 300,200);
			tab2.graphics.endFill();
			
			vm.addChild(tab1);
			vm.addChild(tab2);
			
			vm.selectedItem = tab1;
			
			vm.setAnimateHandler(ainimate);
			vm.x = 300;
			addChild(vm);
		}
		
		// tab 的动画效果处理函数
		private function ainimate(old:DisplayObject, current:DisplayObject, width:Number, height:Number):void
		{
			current.y = -height;
			
			Tweener.addTween(current, {y:0,time:0.9,transition:"easeInSine"});
		}
		
		private function clickHandler(e:MouseEvent):void
		{
			if (flag)
			{
				WindowManager.closeWindow(dialog);
			}else{
				if (dialog == null)
				{
					dialog = new Sprite();
					dialog.graphics.beginFill(0x00FF, 1);
					dialog.graphics.drawRect(0,0, 100, 200);
					dialog.graphics.endFill();
					var txt:TextField = new TextField();
					txt.text = "dfkajsdkfjaksdfjaksdjfk";
					dialog.addChild(txt);
				}
				WindowManager.popWindow(dialog, this);
				
			}
			
			// WindowManager.disableDisplayObject(this, flag);
			flag = !flag;
			
		}
		
		/**
		 * http数据加载测试， 可以用来加载json，xml，text
		 */		
		public function httpTest():void
		{
			// json 加载测试
			var url:String = 'http://w0.im.baidu.com/welcome?force=false&session=&t=gd83h5m8&source=2&seq=0';
			HttpLoader.addSendFilter( function (url:String, method:String, vars:URLVariables):void{
				trace("addSendFilter", url, method, vars);
				vars.ff = 'xx';
			});
			
			HttpLoader.addRecvFilter(function (data:Object):void{
				trace("FILTER_RECV_BEFORE", data);
			}, HttpLoader.FILTER_RECV_BEFORE);
			
			HttpLoader.addRecvFilter(function (data:Object):void{
				trace("FILTER_RECV_AFTER", data);
			}, HttpLoader.FILTER_RECV_AFTER);
			
			
			HttpLoader.getInstance().httpJson(url, callback);
		}
		
		/**
		 * 缓存加载测试
		 */		
		public function cacheLoaderTest():void
		{
			var url:String = "http://img.baidu.com/img/logo-img.gif";
			
			DisplayLoader.getCachedBitmapData(url, function (bmd:BitmapData):void{
				var bm:Bitmap = new Bitmap(bmd);
				bm.x =0;
				bm.y = 0;
				addChild(bm);
			});
			
			url = "http://img.baidu.com/img/logo-img.gif";
			
			DisplayLoader.getCachedLoaderInfo(url, function (loader:LoaderInfo):void{
				addChild(loader.content);
			});
			
			url = "http://img.baidu.com/img/logo-img.gif";
			
			DisplayLoader.getCachedBitmapData(url, function (bmd:BitmapData):void{
				var bm:Bitmap = new Bitmap(bmd);
				bm.x = 100;
				bm.y = 110;
				addChild(bm);
			});
		}
		

		
		// 回调
		private function callback(data:Object):void
		{
			Debug.dump(data);
		}
		
		/**
		 * 可视化加载测试，可以用来加载swf，图片，etc
		 */
		private function displayLoaderTest():void
		{
			var url:String = 'http://www.baidu.com/img/baidu_logo.gif';
			DisplayLoader.getLoaderInfo(url, callback2, callback2);
			
			url = 'http://img1.kaixin001.com.cn/i2/kaixinlogo.gif';
			DisplayLoader.getLoaderInfo(url, callback2, callback2);
		}
		// 回调 参数如果为null，表示加载失败
		private function callback2(result:LoaderInfo):void
		{
			if (result.content != null)
			{
				var bm:Bitmap = result.content as Bitmap;
				bm.x =i;
				i+= 100;
				addChild(bm);
			}else
				trace("loader fail");
		}
		
		/**
		 * 多文件加载测试
		 */		
		private function mutiFileLoaderTest():void
		{
			trace("mutiFileLoaderTest", "start");
			var loader:MutiFileLoader = new MutiFileLoader();
			loader.addEventListener(MutiFileLoaderEvent.PROGRESS, progressHandler);
			loader.addEventListener(MutiFileLoaderEvent.COMPLETE, completeHandler);			
			
			// 语言包加载
			var xmlParam:Object = {};
			xmlParam.domin = new ApplicationDomain();
			xmlParam.version = Math.random();
			xmlParam.ratio = 0.4;
			loader.addFile("http://news.ifeng.com/pubres/rss/opinion/feed.xml", "xml", xmlParam);
			
			// 资源文件
			var resParam:Object = {};
			resParam.domin = new ApplicationDomain();
			resParam.version = Math.random();
			resParam.ratio = 0.6;			
			loader.addFile("http://hiphotos.baidu.com/20meitu/pic/item/78358c8b25e0763d9e2fb4ca.jpg", "res", resParam);

			loader.load();
		}
		
		// 加载进度显示
		private function progressHandler(e:MutiFileLoaderEvent):void
		{
			var rate:int = e.totalProgress * 10000;
			
			trace("progress:", e.url, rate/100);
		}
		
		// 加载完成处理
		private function completeHandler(e:MutiFileLoaderEvent):void
		{
			trace("mutiFileLoaderTest", "finish");
			var loader:MutiFileLoader = e.target as MutiFileLoader;
			// 加载
			var xml:XML = new XML(loader.getContent(("xml")));
			var res:LoaderInfo = loader.getContent("res") as LoaderInfo;
			
			var bm:Bitmap = res.content as Bitmap;
			addChild(bm);
		}
		
		private function tooltipTest():void
		{
			/*this.mouseChildren = false;*/
			
			var bm:Bitmap = new Bitmap();
			var bmd:BitmapData = new BitmapData(200,200,false,0xFF);
			bm.bitmapData = bmd;
			addChild(bm);
			bm.x = 10;
			bm.y = 10;
			
			ToolTip.show(bm, "提示提示提");
			
			var t:Timer = new Timer(5000);
			t.addEventListener(TimerEvent.TIMER, function (e:TimerEvent):void{
				//ToolTip.show(bm, "提示提示提示" + Math.random());
				//ToolTip.removeTip(bm);
			});
			
			t.start();
			
		}
		
		/**
		 * 按钮测试 
		 * 
		 */		
		private function buttonTest():void
		{
			var button:SpButton = new TestButton();
			button.label = "我草草草草草草草草草";
			button.addEventListener(MouseEvent.CLICK, function(e:MouseEvent):void{
				trace("button click");
				alertTest();
			});
			button.x = 150;
			button.y = 150;
			addChild(button);
		}
		
		/**
		 * 弹出框测试
		 */		
		private function alertTest():void
		{
			WindowManager.defaultParent = this.stage;
			WindowManager.defaultWindowHeight = 600;
			WindowManager.defaultWindowWidth = 800;
			// 初始化样式 只做一次
			
			AlertManager.addStyle(AlertManager.STYLE_DEFAULT, test.AlertBg, TestButton, TestButton,"确定", "取消",
				new Rectangle(48, 17, 229.95, 85), new Rectangle(48,114.65,231.95,26.35));
			
			//AlertManager.showInfoDialog("info");
			//**
			 AlertManager.show("弹出\n框弹出\n框弹出框弹出框弹\n出框弹\n出框弹\n出框弹出框弹出框弹出框弹出框弹出框弹出框", AlertManager.STYLE_DEFAULT, "default", "default", function():void{
			 trace("click ok");
			 }, function ():void{
			 trace('click cancel');
			 });
			 //**/
		}
	}
}