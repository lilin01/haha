package com.app 
	
{ 
	
	
	
	import flash.display.BitmapData; 
	
	import flash.geom.Point; 
	
	import flash.geom.Rectangle; 
	
	/** 
	 
	 * flash原创代码尽在 www.mygamemylove.com  
	 
	 * @author smallerbird  09-8-19 14:23 
	 
	 * 
	 
	 */ 
	
	public class PngMovie 
		
	{ 
		
		private var currentFrame:uint=0 
		
		private var arrBmap:Array=new Array(); 
		
		private var arrBmapAll:Array=new Array(); 
		
		public var w:Number,h:Number 
		
		/** 
		 
		 *  
		 
		 * @param bd_img 生成动画的BitmapData对象 
		 
		 * @param row 该图象显示动画是几行 uint 
		 
		 * @param tier 该图象显示动画是几列 uint 
		 
		 * @param arr 将该图象中的动画划分几个部份.Array 如:如果该图像是一个２*３的 
		 
		 动画。 
		 
		 *该参数设置为［２,３］意思为：分为两组动画：第1行第１列到第２列　以及 第1行第3列到第2行第3列 
		 

		 
		 *  
		 
		 */ 
		
		public function PngMovie(bd_img:BitmapData, row:uint, tier:uint, arr:Array) 
			
		{ 
			
			currentFrame=0 
			
			w=bd_img.width / tier 
			
			h=bd_img.height / row 
			
			// 
			
			var arrTemBmap:Array=new Array(); 
			
			var arrI:uint=0 
			
			var ij:uint=1 
			
			for (var i:uint=0; i < row; i++) 
				
			{ 
				
				for (var j:uint=0; j < tier; j++) 
					
				{ 
					
					var bd:BitmapData=new BitmapData(w, h) 
					
					var rect:Rectangle=new Rectangle(j * w, i * h, w,  
						
						h); 
					
					bd.copyPixels(bd_img, rect, new Point(0, 0)); 
					
					arrTemBmap.push(bd) 
					
					if (++ij > arr[arrI]) 
						
					{ 
						
						ij=1 
						
						arrI++ 
							
							arrBmapAll.push(arrTemBmap); 
						
						arrTemBmap=new Array(); 
						
					} 
					
				} 
				
			} 
			
			// 
			
			setCurrentMovie() 
			
		} 
		
		// 
		
		/** 
		 
		 *  
		 
		 * @param arrI 当前显示的动画是第几组动画。注意：第一组动画是用0表示的。 
		 
		 *  
		 
		 *  
		 
		 */ 
		
		public function setCurrentMovie(arrI:uint=0):void{ 
			
			arrBmap=arrBmapAll[arrI] 
			
			currentFrame=0 
			
		} 
		
		// 
		
		/** 
		 
		 *  
		 
		 *  
		 
		 * @return 当前播放的动画的当前帧的BitmapData 
		 
		 *  
		 
		 */ 
		
		public function nextFrame():BitmapData 
			
		{ 
			
			var bd:BitmapData=arrBmap[currentFrame]; 
			
			if (currentFrame + 1 < arrBmap.length) 
				
			{ 
				
				currentFrame++ 
				
			} 
				
			else 
				
			{ 
				
				currentFrame=0 
				
			} 
			
			return bd; 
			
		} 
		
	} 
	
}