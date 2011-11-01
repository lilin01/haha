package 
{ 
	import caurina.transitions.Tweener;
	
	import com.app.controller.Application;
	import com.framework.utils.debug.FPSStats;
	import com.framework.utils.loader.DisplayLoader;
	import com.framework.utils.loader.HttpLoader;
	import com.framework.utils.loader.MutiFileLoader;
	import com.framework.utils.loader.events.MutiFileLoaderEvent;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.Loader;
	import flash.display.LoaderInfo;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.geom.Rectangle;
	import flash.net.URLRequestMethod;
	import flash.net.URLVariables;
	import flash.system.ApplicationDomain;
	import flash.system.Security;
	import flash.text.TextField;
	import flash.utils.Timer;
	import flash.utils.setTimeout;
	
	import test.AlertBg;
	/**
	 * framework
	 * @author 
	 * $Id: 
	 * @version 1.0
	 */
	[SWF(width="760",height="720",frameRate="30",backgroundColor="0xFFFFFF")]	
	public class App extends Sprite
	{
		

		public function App()
		{
			if (stage){
				init();
			}
			else {
				addEventListener(Event.ADDED_TO_STAGE, init);
			}
		}
		
		private function init(...args):void{
			this.stage.addChild(new FPSStats());
			removeEventListener(Event.ADDED_TO_STAGE, init);
			Security.allowDomain("*");
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.align = StageAlign.TOP_LEFT;
			var self:App = this;
			
		
		//	if (this.parent && !(this.parent is Stage))
		//	{
				
				Application.instance.init(self);
				Application.instance.initView();
		//	}
				//Application.instance.ok();
						
		}
		
		
	
		
		


	}
}