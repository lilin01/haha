package com.app.view.tournyChoose 
{
    import com.app.config.UrlConfig;
    import com.app.controller.FramebarController;
    import com.framework.utils.loader.HttpLoader;
    
    import flash.display.*;
    import flash.events.*;
    import flash.net.*;
    
    import res.tournyChoose.TournyChooseMainMC;
    public class TournyChooseMain extends TournyChooseMainMC  
    { 
       
      
        private var rewards:Array;
        private var tournyType:String;
        private var tournySize:int;
        private var rewardCounter:int = 0;
        private var prizes:Array;

        public function TournyChooseMain()
        {
            rewards = [];
            prizes = [];
            this.addEventListener(Event.ENTER_FRAME, createScreen);
            return;
        }// end function

        public function createScreen(event:Event) : void
        {
			
			
            this.removeEventListener(Event.ENTER_FRAME, createScreen);
			
            init();
            createRewards();
            return;
        }// end function

        public function init() : void
        {
            enableButtons();
            return;
        }// end function

        private function createRewards() : void
        {
            
			HttpLoader.getInstance().httpJson(UrlConfig.HTTPROOT+UrlConfig.GETTOURNAMENTPRIZES,loadInfoHandler1);
            return;
        }// end function

        public function loadInfoHandler1(data:Object) : void
        {
            
            if (data.result != "error")
            {
                rewards = data as Array;
            }
           
            displayRewards();
            return;
        }// end function

        public function ioErrorHandler(param1)
        {
            return;
        }// end function

        private function displayRewards() : void
        {
            var _loc_1:int = 0;
            while (_loc_1 < 6)
            {
                
                prizes.push(addChild(new TourneyReward(rewards[_loc_1])));
                prizes[_loc_1].x = 611;
                prizes[_loc_1].y = 78 * _loc_1 + 134;
                _loc_1++;
            }
            return;
        }// end function

        private function disableButtons()
        {
            backButt.buttonMode = false;
            backButt.hitZone.removeEventListener(MouseEvent.CLICK, gotoMap);
            backButt.hitZone.removeEventListener(MouseEvent.ROLL_OVER, startFloat);
            backButt.hitZone.removeEventListener(MouseEvent.ROLL_OUT, stopFloat);
            sameLevel4.buttonMode = false;
            sameLevel4.hitZone.removeEventListener(MouseEvent.CLICK, setVars);
            sameLevel4.hitZone.removeEventListener(MouseEvent.ROLL_OVER, startFloat);
            sameLevel4.hitZone.removeEventListener(MouseEvent.ROLL_OUT, stopFloat);
            openLevel4.buttonMode = false;
            openLevel4.hitZone.removeEventListener(MouseEvent.CLICK, setVars);
            openLevel4.hitZone.removeEventListener(MouseEvent.ROLL_OVER, startFloat);
            openLevel4.hitZone.removeEventListener(MouseEvent.ROLL_OUT, stopFloat);
            sameLevel5.buttonMode = false;
            sameLevel5.hitZone.removeEventListener(MouseEvent.CLICK, setVars);
            sameLevel5.hitZone.removeEventListener(MouseEvent.ROLL_OVER, startFloat);
            sameLevel5.hitZone.removeEventListener(MouseEvent.ROLL_OUT, stopFloat);
            openLevel5.buttonMode = false;
            openLevel5.hitZone.removeEventListener(MouseEvent.CLICK, setVars);
            openLevel5.hitZone.removeEventListener(MouseEvent.ROLL_OVER, startFloat);
            openLevel5.hitZone.removeEventListener(MouseEvent.ROLL_OUT, stopFloat);
            sameLevel6.buttonMode = false;
            sameLevel6.hitZone.removeEventListener(MouseEvent.CLICK, setVars);
            sameLevel6.hitZone.removeEventListener(MouseEvent.ROLL_OVER, startFloat);
            sameLevel6.hitZone.removeEventListener(MouseEvent.ROLL_OUT, stopFloat);
            openLevel6.buttonMode = false;
            openLevel6.hitZone.removeEventListener(MouseEvent.CLICK, setVars);
            openLevel6.hitZone.removeEventListener(MouseEvent.ROLL_OVER, startFloat);
            openLevel6.hitZone.removeEventListener(MouseEvent.ROLL_OUT, stopFloat);
            return;
        }// end function

        private function enableButtons()
        {
            backButt.buttonMode = true;
            backButt.hitZone.addEventListener(MouseEvent.CLICK, gotoMap);
            backButt.hitZone.addEventListener(MouseEvent.ROLL_OVER, startFloat);
            backButt.hitZone.addEventListener(MouseEvent.ROLL_OUT, stopFloat);
            sameLevel4.buttonMode = true;
            sameLevel4.hitZone.addEventListener(MouseEvent.CLICK, setVars);
            sameLevel4.hitZone.addEventListener(MouseEvent.ROLL_OVER, startFloat);
            sameLevel4.hitZone.addEventListener(MouseEvent.ROLL_OUT, stopFloat);
            openLevel4.buttonMode = true;
            openLevel4.hitZone.addEventListener(MouseEvent.CLICK, setVars);
            openLevel4.hitZone.addEventListener(MouseEvent.ROLL_OVER, startFloat);
            openLevel4.hitZone.addEventListener(MouseEvent.ROLL_OUT, stopFloat);
            sameLevel5.buttonMode = true;
            sameLevel5.hitZone.addEventListener(MouseEvent.CLICK, setVars);
            sameLevel5.hitZone.addEventListener(MouseEvent.ROLL_OVER, startFloat);
            sameLevel5.hitZone.addEventListener(MouseEvent.ROLL_OUT, stopFloat);
            openLevel5.buttonMode = true;
            openLevel5.hitZone.addEventListener(MouseEvent.CLICK, setVars);
            openLevel5.hitZone.addEventListener(MouseEvent.ROLL_OVER, startFloat);
            openLevel5.hitZone.addEventListener(MouseEvent.ROLL_OUT, stopFloat);
            sameLevel6.buttonMode = true;
            sameLevel6.hitZone.addEventListener(MouseEvent.CLICK, setVars);
            sameLevel6.hitZone.addEventListener(MouseEvent.ROLL_OVER, startFloat);
            sameLevel6.hitZone.addEventListener(MouseEvent.ROLL_OUT, stopFloat);
            openLevel6.buttonMode = true;
            openLevel6.hitZone.addEventListener(MouseEvent.CLICK, setVars);
            openLevel6.hitZone.addEventListener(MouseEvent.ROLL_OVER, startFloat);
            openLevel6.hitZone.addEventListener(MouseEvent.ROLL_OUT, stopFloat);
            return;
        }// end function

        private function setVars(event:MouseEvent) : void
        {
            switch(event.currentTarget.parent)
            {
                case sameLevel4:
                {
                    tournyType = "same_level";
                    tournySize = 4;
                    //tourneyReward = 0;
                    break;
                }
                case openLevel4:
                {
                    tournyType = "open";
                    tournySize = 4;
                    //tourneyReward = 0;
                    break;
                }
                case sameLevel5:
                {
                    tournyType = "same_level";
                    tournySize = 5;
                    //tourneyReward = 0;
                    break;
                }
                case openLevel5:
                {
                    tournyType = "open";
                    tournySize = 5;
                    //tourneyReward = 0;
                    break;
                }
                case sameLevel6:
                {
                    tournyType = "same_level";
                    tournySize = 6;
                   // tourneyReward = 0;
                    break;
                }
                case openLevel6:
                {
                    tournyType = "open";
                    tournySize = 6;
                    //tourneyReward = 0;
                    break;
                }
                default:
                {
                    break;
                }
            }
			FramebarController.instance.framebarview.tourneySize = tournySize;
			FramebarController.instance.framebarview.tourneyType = tournyType;
            disableButtons();
           // main.buttonSound();
			FramebarController.instance.framebarview.loadTournamentFile("tournyLoad");
			this.parent.removeChild(this);
            return;
        }// end function

        private function gotoMap(... args)
        {
			this.parent.removeChild(this);
			FramebarController.instance.framebarview.checkForTrain();
			FramebarController.instance.framebarview.showAllies();
            /*main.buttonSound();
            parent.parent.loadFile("map");*/
            return;
        }// end function

        private function startFloat(event:MouseEvent)
        {
            event.currentTarget.parent.graphic.removeEventListener(Event.ENTER_FRAME, floatDown);
            event.currentTarget.parent.graphic.addEventListener(Event.ENTER_FRAME, floatUp);
            return;
        }// end function

        private function stopFloat(event:MouseEvent)
        {
            event.currentTarget.parent.graphic.addEventListener(Event.ENTER_FRAME, floatDown);
            event.currentTarget.parent.graphic.removeEventListener(Event.ENTER_FRAME, floatUp);
            return;
        }// end function

        private function floatUp(event:Event)
        {
            if (event.currentTarget.y < -6)
            {
                event.currentTarget.removeEventListener(Event.ENTER_FRAME, floatUp);
            }
            else
            {
                event.currentTarget.y = event.currentTarget.y - 2;
            }
            return;
        }// end function

        private function floatDown(event:Event)
        {
            if (event.currentTarget.y >= 0)
            {
                event.currentTarget.removeEventListener(Event.ENTER_FRAME, floatDown);
            }
            else
            {
                event.currentTarget.y = event.currentTarget.y + 2;
            }
            return;
        }// end function

    }
}
