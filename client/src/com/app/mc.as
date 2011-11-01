package com.app

{ 
	
	import flash.display.Loader; 
	
	import flash.display.Sprite; 
	
	import flash.events.*; 
	
	import flash.net.URLRequest; 
	
	import flash.display.SimpleButton; 
	
	import com.mygamemylove.*; 
	
	//源码下载地址http://www.mygamemylove.com/bbs/viewthread.php?tid=35 
	
	[SWF(backgroundColor="0x006699")] 
	
	public class loadPng extends Sprite 
		
	{ 
		
		//加载图片 
		
		public var load:Loader  
		
		//分解图片后不动动作的BitmapData 
		
		public var player:PngMovie; 
		
		//显示人物 
		
		
		
		public var sp_player:Sprite; 
		
		//是否加载成功 
		
		public var isLoad:Boolean=false 
		
		//动画播放的速度 
		
		public var fps:uint=0 
		
		public var fpsI:uint=0 
		
		public function loadPng() 
			
		{ 
			
			fps=2 
			
			//加载png图片 
			
			load=new Loader (); 
			
			load.contentLoaderInfo.addEventListener 
				
				(Event.COMPLETE,fun_complete); 
			
			load.load(new URLRequest("npc_pet17.png")); 
			
			//显示动画容器 
			
			sp_player=new Sprite(); 
			
			sp_player.x=50 
			
			this.addChild(sp_player); 
			
			// 
			
			this.addEventListener(Event.ENTER_FRAME,fun_onEnterFrame) 
			
			// 
			
			btn1.addEventListener(MouseEvent.CLICK,btn_click); 
			
			btn2.addEventListener(MouseEvent.CLICK,btn_click); 
			
			btn3.addEventListener(MouseEvent.CLICK,btn_click); 
			
			btn4.addEventListener(MouseEvent.CLICK,btn_click); 
			
			btn5.addEventListener(MouseEvent.CLICK,btn_click); 
			
			btn6.addEventListener(MouseEvent.CLICK,btn_click); 
			
			btn7.addEventListener(MouseEvent.CLICK,btn_click); 
			
			btn8.addEventListener(MouseEvent.CLICK,btn_click); 
			
		} 
		
		//加载完成 
		
		public function fun_complete(e:Event):void{ 
			
			//此参数：[1,3,1,3,1,3,1,3]  将加的图片分8组动画。依次为：1行1列，1 
			
			行2列到1行4列 
			
			player=new PngMovie(PngResource.getAlphaImg(load),4,4, 
				
				[1,3,1,3,1,3,1,3]); 
			
			//显示第二组动画 
			
			player.setCurrentMovie(1); 
			
			isLoad=true 
			
		} 
		
		//循环动画 
		
		public function fun_onEnterFrame(e:Event):void{ 
			
			//动画播放的速度 
			
			if(fpsI++>fps){ 
				
				fpsI=0 
				
				//如果加载成功，显示动画 
				
				if(isLoad){ 
					
					sp_player.graphics.clear(); 
					
					sp_player.graphics.beginBitmapFill 
						
						(player.nextFrame(),null,false,true); 
					
					sp_player.graphics.drawRect(0,0,player.w,player.h); 
					
					sp_player.graphics.endFill(); 
					
				} 
				
			} 
			
			// 
			
		} 
		
		// 
		
		public function btn_click(e:MouseEvent):void{ 
			
			switch(e.target){ 
				
				case btn1: 
					
					player.setCurrentMovie(0); 
					
					break; 
				
				case btn2: 
					
					player.setCurrentMovie(1); 
					
					break; 
				
				case btn3: 
					
					player.setCurrentMovie(2); 
					
					break; 
				
				case btn4: 
					
					player.setCurrentMovie(3); 
					
					break; 
				
				case btn5: 
					
					player.setCurrentMovie(4); 
					
					break; 
				
				case btn6: 
					
					player.setCurrentMovie(5); 
					
					break; 
				
				case btn7: 
					
					player.setCurrentMovie(6); 
					
					break; 
				
				case btn8: 
					
					player.setCurrentMovie(7); 
					
					break; 
				
			} 
			
		} 
		
	} 
	
}