package com.vo
{
	public class AllieVo
	{
		public function AllieVo(dt:Object)
		{
			for(var key:String in dt)
			{
				this["_" + key] = dt[key];
			}
		}
		private var _cid:String;
		private var _name:String;
		private var _level:String;
		private var _faction:String;
		private var _avatar:String;
		private var _needs_assistance:int;
		public function get cid():String
		{
			return _cid;
		}
		
		public function set cid(value:String):void
		{
			_cid = value;
		}

		public function get name():String
		{
			return _name;
		}

		public function set name(value:String):void
		{
			_name = value;
		}

		public function get level():String
		{
			return _level;
		}

		public function set level(value:String):void
		{
			_level = value;
		}

		public function get faction():String
		{
			return _faction;
		}

		public function set faction(value:String):void
		{
			_faction = value;
		}

		public function get avatar():String
		{
			return _avatar;
		}

		public function set avatar(value:String):void
		{
			_avatar = value;
		}

		public function get needs_assistance():int
		{
			return _needs_assistance;
		}

		public function set needs_assistance(value:int):void
		{
			_needs_assistance = value;
		}


	}
}