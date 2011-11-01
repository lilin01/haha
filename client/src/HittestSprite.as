package
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.Rectangle;
	
	public class HittestSprite extends Sprite 
	{
		private var circle:Sprite;
		
		private var rec:Sprite;
		public function HittestSprite()
		{
			circle = new Sprite();
			circle.graphics.beginFill(0x669900);
			circle.graphics.drawCircle(10,10,10);
			circle.graphics.endFill();
			trace("sdf");
			addChild(circle);
			circle.startDrag(true);
			
			rec = new Sprite();
			rec.graphics.beginFill(0xFF00FF);
			rec.graphics.drawRect(220,220,120,120);
			rec.graphics.endFill();
			addChild(rec);
			rec.addEventListener(Event.ENTER_FRAME,this.isHist);
			
		}
		
		private function isHist(evt:Event):void{
			if(this.circle.hitTestObject(evt.target as Sprite)){
				//trace("AAA");
			}
			
			if(this.circle.hitTestPoint(220,220,true)){
				trace("point");
			}
		}
	}
}