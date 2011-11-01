package com.app.view.map 
{
    import fl.motion.*;
    import flash.display.*;
	import res.map.*;
    public class WordPlosion extends MovieClip
    {
        private var life:int = 30;
        private var maxLife:int;
        public var dead:Boolean = false;
        private var speed:Number = 0;
        private var xSpeed:Number = 0;
        private var ySpeed:Number = 0;
        private var direction:Number = 0;
        private var weapon:int = 0;
        private var gravity:Number = 0;
        private var bmp:Object;
        private var main:Object;

        public function WordPlosion(param1, param2:Number, param3:Number, param4:int)
        {
            this.maxLife = this.life;
            mouseEnabled = false;
            mouseChildren = false;
            x = param2;
            y = param3;
            this.main = param1;
            var _loc_5:* = new Color();
            new Color().setTint(16777215, 1);
            transform.colorTransform = _loc_5;
            switch(param4)
            {
                case 0:
                {
                    this.addChild(new WordDojoMC());
                    _loc_5.setTint(10079045, 1);
                    transform.colorTransform = _loc_5;
                    break;
                }
                case 1:
                {
                    this.addChild(new WordRecruitMC());
                    _loc_5.setTint(10079045, 1);
                    transform.colorTransform = _loc_5;
                    break;
                }
                case 2:
                {
                    this.addChild(new WordRelicMC());
                    break;
                }
                case 3:
                {
                    this.addChild(new WordHospitalMC());
                    break;
                }
                case 4:
                {
                    this.addChild(new WordWeaponMC());
                    break;
                }
                case 5:
                {
                    this.addChild(new WordFightMC());
                    y = y - 20;
                    break;
                }
                case 6:
                {
                    this.addChild(new WordDaimyoMC());
                    break;
                }
                case 7:
                {
                    this.addChild(new WordInviteMC());
                    break;
                }
                case 8:
                {
                    this.addChild(new WordAlliesMC());
                }
                case 9:
                {
                    this.addChild(new WordMagicMC());
                }
                case 10:
                {
                    this.addChild(new WordInviteMC());
                    break;
                }
                default:
                {
                    break;
                }
            }
            return;
        }// end function

        public function update()
        {
            alpha = this.life / this.maxLife;
            scaleX = scaleX + 0.02;
            scaleY = scaleY + 0.02;
            if (this.life <= 0)
            {
                this.dead = true;
            }
           
            this.life--;
            return;
        }// end function

        public function disable()
        {
            return;
        }// end function

        public function destroy()
        {
            parent.removeChild(this);
            return;
        }// end function

    }
}
