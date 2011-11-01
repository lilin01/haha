package com.vo
{
	public class MagicItemVo
	{
		private var _name:String="";
		private var _description:String="";
		private var _min_level:int;
		private var _damage:int;
		private var _duration:String="";
		private var _gift_currency_value:int;
		private var _karma_value:int;
		private var _new_item:int;
		private var _sprite:int;
		private var _sid:int;
		private var _effect:String="";
		public function MagicItemVo(data:Object)
		{
			_name=data.name;
			_description=data.description;
			_min_level=data.min_level;
			_damage=data.damage;
			_duration=data.duration;
			_gift_currency_value=data.gift_currency_value;
			_karma_value=data.karma_value;
			_new_item=data.new_item;
			_sprite=data.sprite;
			_sid=data.sid;
			_effect=data.effect;
		}

		public function get name():String
		{
			return _name;
		}

		public function set name(value:String):void
		{
			_name = value;
		}

		public function get description():String
		{
			return _description;
		}

		public function set description(value:String):void
		{
			_description = value;
		}

		public function get min_level():int
		{
			return _min_level;
		}

		public function set min_level(value:int):void
		{
			_min_level = value;
		}

		public function get damage():int
		{
			return _damage;
		}

		public function set damage(value:int):void
		{
			_damage = value;
		}

		public function get duration():String
		{
			return _duration;
		}

		public function set duration(value:String):void
		{
			_duration = value;
		}

		public function get gift_currency_value():int
		{
			return _gift_currency_value;
		}

		public function set gift_currency_value(value:int):void
		{
			_gift_currency_value = value;
		}

		public function get karma_value():int
		{
			return _karma_value;
		}

		public function set karma_value(value:int):void
		{
			_karma_value = value;
		}

		public function get new_item():int
		{
			return _new_item;
		}

		public function set new_item(value:int):void
		{
			_new_item = value;
		}

		public function get sprite():int
		{
			return _sprite;
		}

		public function set sprite(value:int):void
		{
			_sprite = value;
		}

		public function get sid():int
		{
			return _sid;
		}

		public function set sid(value:int):void
		{
			_sid = value;
		}

		public function get effect():String
		{
			return _effect;
		}

		public function set effect(value:String):void
		{
			_effect = value;
		}


	}
}