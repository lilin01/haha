package com.app{ 
	
	import flash.display.DisplayObject; 
	
	import flash.display.BitmapData; 
	
	import flash.geom.Point; 
	
	import flash.display.BlendMode; 
	
	
	public class PngResource { 
		
		/** 
		 
		 *  
		 
		 * @param image 
		 
		 * @return 获得一个不透明的bitmap 
		 
		 *  
		 
		 */ 
		
		public static function createBitmapData(image:DisplayObject):BitmapData { 
			
			var bitmap:BitmapData = new BitmapData(image.width, image.height); 
			
			bitmap.draw(image); 
			
			return bitmap; 
			
		} 
		
		/** 
		 
		 *  
		 
		 * @param image 
		 
		 * @return 获得图像的透明部份 bitmap 
		 
		 *  
		 
		 */ 
		
		public static function createAlphaBitmapData 
			
			(image:DisplayObject):BitmapData { 
			
			var bitmap:BitmapData = new BitmapData(image.width, image.height); 
			
			bitmap.draw(image, null, null, BlendMode.ALPHA); 
			
			return bitmap; 
			
		} 
		
		// 
		
		/** 
		 
		 *  
		 
		 * @param image 
		 
		 * @return 获得一个透明的bitmap 
		 
		 *  
		 
		 */ 
		
		public static function getAlphaImg(image:DisplayObject):BitmapData { 
			
			var bitmap:BitmapData = PngResource.createBitmapData(image); 
			
			var bitmapAlpha:BitmapData = PngResource.createAlphaBitmapData 
				
				(image); 
			
			var db:BitmapData=new BitmapData 
				
				(bitmap.rect.width,bitmap.rect.height,true,0x000000); 
			
			// 
			
			db.copyPixels(bitmap, bitmap.rect, new Point(0,0), bitmapAlpha, new  
				
				Point(0, 0), true); 
			
			return db; 
			
		} 
		
	} 
	
}
}