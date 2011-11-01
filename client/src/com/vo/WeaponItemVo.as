package com.vo
{
	public class WeaponItemVo
	{
		private var _iid:String="";
		private var _sort_order:String="";
		private var _name:String="";
		private var _is_plural:String="";
		private var _description:String="";
		private var _unique:String="";
		private var _value:String="";
		private var _karma_value:String="";
		private var _type:String="";
		private var _sprite:String="";
		private var _runanimation:String="";
		private var _standanimation:String="";
		private var _rarity:String="";
		private var _attributes:Object={};
		private var _sortLevel:int=1;//装备此武器最低等级
		private var _dps:Number;
		public function WeaponItemVo(dt:Object)
		{
				/*for(var key:String in dt)
				{
					this["_" + key] = dt[key];
				}
				*/
				_iid=dt.iid;
				_sort_order=dt.sort_order;
				_name=dt.name;
				_is_plural=dt.is_plural;
				_description=dt.description;
				_unique=dt.unique;
				_value=dt.value;
				_karma_value=dt.karma_value;
				_type=dt.type;
				_sprite=dt.sprite;
				_runanimation=dt.runanimation;
				_standanimation=dt.standanimation;
				_rarity=dt.rarity;
				_attributes=dt.attributes;
				if(this._attributes.min_level!=undefined)
					_sortLevel=parseInt(this._attributes.min_level);
				_dps=Math.round(100 / parseInt(_attributes.speed) * parseFloat(_attributes.damage) * 100) / 100;
		}
		
		
		
		
		public function getSpeed():String
		{
			var _loc_1:Array = new Array(33, 50, 66, 85, 150, 299, 399, 499, 1000);
			var _loc_2:Array = new Array("Ultra Fast", "Fastest", "Faster", "Fast", "Normal", "Slow", "Slower", "Slowest", "Slow Loris");
			var _loc_3:int = 0;
			while (_loc_3 < _loc_1.length)
			{
				
				if (_attributes.speed < _loc_1[_loc_3])
				{
					return _loc_2[_loc_3];
				}
				_loc_3++;
			}
			return "";
		}

		public function get iid():String
		{
			return _iid;
		}

		public function set iid(value:String):void
		{
			_iid = value;
		}

		public function get sort_order():String
		{
			return _sort_order;
		}

		public function set sort_order(value:String):void
		{
			_sort_order = value;
		}

		public function get name():String
		{
			return _name;
		}

		public function set name(value:String):void
		{
			_name = value;
		}

		public function get is_plural():String
		{
			return _is_plural;
		}

		public function set is_plural(value:String):void
		{
			_is_plural = value;
		}

		public function get description():String
		{
			return _description;
		}

		public function set description(value:String):void
		{
			_description = value;
		}

		public function get unique():String
		{
			return _unique;
		}

		public function set unique(value:String):void
		{
			_unique = value;
		}

		public function get value():String
		{
			return _value;
		}

		public function set value(value:String):void
		{
			_value = value;
		}

		public function get karma_value():String
		{
			return _karma_value;
		}

		public function set karma_value(value:String):void
		{
			_karma_value = value;
		}

		public function get type():String
		{
			return _type;
		}

		public function set type(value:String):void
		{
			_type = value;
		}

		public function get sprite():String
		{
			return _sprite;
		}

		public function set sprite(value:String):void
		{
			_sprite = value;
		}

		public function get runanimation():String
		{
			return _runanimation;
		}

		public function set runanimation(value:String):void
		{
			_runanimation = value;
		}

		public function get standanimation():String
		{
			return _standanimation;
		}

		public function set standanimation(value:String):void
		{
			_standanimation = value;
		}

		public function get rarity():String
		{
			return _rarity;
		}

		public function set rarity(value:String):void
		{
			_rarity = value;
		}

		public function get attributes():Object
		{
			return _attributes;
		}

		public function set attributes(value:Object):void
		{
			_attributes = value;
		}

		public function get sortLevel():int
		{
			return _sortLevel;
		}

		public function set sortLevel(value:int):void
		{
			_sortLevel = value;
		}

		public function get dps():Number
		{
			return _dps;
		}

		public function set dps(value:Number):void
		{
			_dps = value;
		}



	}
}