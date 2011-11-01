package com.vo
{

	
	public class UserInfoVo
	{
		
		public function UserInfoVo(dt:Object){
			for(var key:String in dt['data'])
			{
				this["_" + key] = dt.data[key];
			}
			
			var i:int = 0;
			i = 0;
			/*while (i < this.relics.length)
			{
				trace("relics.length"+relics.length);
				this.activeRelics.push(relics[i]);
				this.activeRelics[i].index = i;
				i++;
			}*/
			activeRelics=relics;
			i = 0;
			while (i < inventory.length)
			{
				
				switch(parseInt(inventory[i].type))
				{
					case 1:
					{
						this.weaponInventory.push(inventory[i]);
						//this.weaponInventory[(this.weaponInventory.length - 1)].index = this.weaponInventory.length - 1;
						this.sortWeaponInventory();
						break;
					}
					case 2:
					{
						this.relicInventory.push(inventory[i]);
						this.relicInventory[(this.relicInventory.length - 1)].index = this.relicInventory.length - 1;
						break;
					}
					default:
					{
						break;
					}
				}
				i++;
			}
			this.allies.unshift({cid:0});
			while(this.allies.length<7)
				this.allies.unshift({cid:0});
			//trace("00000000000000000000    "+weaponInventory.length);
			this.token=parseInt(this.gift_currency);
		}
		
		//用户编号
		private var _cid:String;
		private var _facebook_id:String;
		private var _npc:String;
		private var _name:String;
		private var _avatar:String;
		private var _formed:String;
		private var _faction:String;
		private var _gold:int;
		private var _karma:int;
		private var _gift_currency:String;
		private var _relic_slots:String;
		private var _level:String;
		private var _exp:String;
		private var _last_auto_heal:String;
		private var _last_bonus:String;
		private var _leveled_at:String;
		private var _exp_modifier:String;
		private var _gold_modifier:String;
		private var _tutorial:String;
		private var _currency_provider:String;
		private var _source:String;
		private var _purchased_karma:String;
		private var _purchased_gold:String;
		private var _magic:Object;
		private var _magic_equipped_at:String;
		private var _relics:Array=[];
		private var _bonus_gold_per_hour:int;
		private var _bonus_karma_per_hour:int;
		private var _ninjas:Array=[];
		private var _exp_to_level:int;
		private var _total_exp_to_level:int;
		private var _seconds_of_bonus_exp:int;
		private var _seconds_of_magic:int;
		private var _achievements:Array=[];
		private var _gained_exp:int;
		private var _gained_karma:int;
		private var _gained_gold:int;
		private var _gained_level:int;
		private var _gained_gift_currency:int;
		private var _inventory:Array=[];
		private var _flags:String;
		private var _defeated_girl:Boolean;
		private var _defeated_genbu:Boolean;
		private var _defeated_small_girl:Boolean;
		private var _defeated_mechagenbu:Boolean;
		private var _allies:Array=[];
		private var _ally_count:int;
		private var _ally_requests:Array=[];
		private var _daimyo_gift:int;
		private var _cloud:int;
		private var _tournament_in:int;
		private var _horde_in:int;
		private var _errors:Array=[];
		private var _token:int=0;

		public function get token():int
		{
			return _token;
		}

		public function set token(value:int):void
		{
			_gift_currency=value.toString();
			_token = value;
		}

		private var _activeRelics:Array=[];
		
		private var _weaponInventory:Array=[];
		
		private var _relicInventory:Array=[];
		
		
		private function sortWeaponInventory():void
		{
			var _loc_1:int = 0;
			while (_loc_1 < this.weaponInventory.length)
			{
				
				this.weaponInventory[_loc_1].dps = Math.round(100 / parseInt(this.weaponInventory[_loc_1].attributes.speed) * parseFloat(this.weaponInventory[_loc_1].attributes.damage) * 100) / 100;
				_loc_1++;
			}
			this.weaponInventory = this.weaponInventory.sortOn("dps", Array.NUMERIC);
			return;
		}
		
		
		public function addWeapon(param1:Object):void
		{
			if (parseInt(param1.iid) == 0)
			{
				trace("can\'t add fists");
				return;
			}
			//param1.index = this.weaponInventory.length;
			this.weaponInventory.push(param1);
			this.sortWeaponInventory();
			return;
		}
		
		public function removeSelectedWeapon(param1:Object) : Object
		{
			var _loc_3:* = undefined;
			var _loc_2:int = 0;
			while (_loc_2 < this.weaponInventory.length)
			{
				
				if (this.weaponInventory[_loc_2] != null && this.weaponInventory[_loc_2].iid == param1.iid)
				{
					_loc_3 = this.weaponInventory[_loc_2];
					this.weaponInventory.splice(_loc_2, 1);
					return _loc_3;
				}
				_loc_2++;
			}
			return null;
		}
		public function addRelic(param1:Object):void
		{
			//param1.index = this.relicInventory.length;
			this.relicInventory.push(param1);
			return;
		}
		public function removeSelectedRelic(param1:Object) : Object
		{
			var _loc_3:Object;
			var _loc_2:int = 0;
			while (_loc_2 < this.relicInventory.length)
			{
				
				if (this.relicInventory[_loc_2] != null && this.relicInventory[_loc_2].iid == param1.iid)
				{
					_loc_3 = this.relicInventory[_loc_2];
					this.relicInventory[_loc_2] = null;
					this.relicInventory.splice(_loc_2, 1);
					return _loc_3;
				}
				_loc_2++;
			}
			return null;
		}
		
		public function addNinja(param1)
		{
			/*param1.index = this.ninjas.length;
			param1.recoverHealth = parseInt(param1.health);*/
			this.ninjas.push(param1);
			return;
		}
		
		public function removeNinja(param1:Object):void
		{
			for(var i:int=0;i<this.ninjas.length;i++){
				if(param1.nid==this.ninjas[i].nid)
					break;
			}
			//var _loc_2:* = this.ninjas[param1];
			this.ninjas.splice(i, 1);
		}
		
		public function get cid():String
		{
			return _cid;
		}

		public function set cid(value:String):void
		{
			_cid = value;
		}

		public function get facebook_id():String
		{
			return _facebook_id;
		}

		public function set facebook_id(value:String):void
		{
			_facebook_id = value;
		}

		public function get npc():String
		{
			return _npc;
		}

		public function set npc(value:String):void
		{
			_npc = value;
		}

		public function get name():String
		{
			return _name;
		}

		public function set name(value:String):void
		{
			_name = value;
		}

		public function get avatar():String
		{
			return _avatar;
		}

		public function set avatar(value:String):void
		{
			_avatar = value;
		}

		public function get formed():String
		{
			return _formed;
		}

		public function set formed(value:String):void
		{
			_formed = value;
		}

		public function get faction():String
		{
			return _faction;
		}

		public function set faction(value:String):void
		{
			_faction = value;
		}

		public function get gold():int
		{
			return _gold;
		}

		public function set gold(value:int):void
		{
			_gold = value;
		}

		public function get karma():int
		{
			return _karma;
		}

		public function set karma(value:int):void
		{
			_karma = value;
		}

		public function get gift_currency():String
		{
			return _gift_currency;
		}

		public function set gift_currency(value:String):void
		{
			this._token=parseInt(value);
			_gift_currency = value;
		}

		public function get relic_slots():String
		{
			return _relic_slots;
		}

		public function set relic_slots(value:String):void
		{
			_relic_slots = value;
		}

		public function get level():String
		{
			return _level;
		}

		public function set level(value:String):void
		{
			_level = value;
		}

		public function get exp():String
		{
			return _exp;
		}

		public function set exp(value:String):void
		{
			_exp = value;
		}

		public function get last_auto_heal():String
		{
			return _last_auto_heal;
		}

		public function set last_auto_heal(value:String):void
		{
			_last_auto_heal = value;
		}

		public function get last_bonus():String
		{
			return _last_bonus;
		}

		public function set last_bonus(value:String):void
		{
			_last_bonus = value;
		}

		public function get leveled_at():String
		{
			return _leveled_at;
		}

		public function set leveled_at(value:String):void
		{
			_leveled_at = value;
		}

		public function get exp_modifier():String
		{
			return _exp_modifier;
		}

		public function set exp_modifier(value:String):void
		{
			_exp_modifier = value;
		}

		public function get gold_modifier():String
		{
			return _gold_modifier;
		}

		public function set gold_modifier(value:String):void
		{
			_gold_modifier = value;
		}

		public function get tutorial():String
		{
			return _tutorial;
		}

		public function set tutorial(value:String):void
		{
			_tutorial = value;
		}

		public function get currency_provider():String
		{
			return _currency_provider;
		}

		public function set currency_provider(value:String):void
		{
			_currency_provider = value;
		}

		public function get source():String
		{
			return _source;
		}

		public function set source(value:String):void
		{
			_source = value;
		}

		public function get purchased_karma():String
		{
			return _purchased_karma;
		}

		public function set purchased_karma(value:String):void
		{
			_purchased_karma = value;
		}

		public function get purchased_gold():String
		{
			return _purchased_gold;
		}

		public function set purchased_gold(value:String):void
		{
			_purchased_gold = value;
		}

		public function get magic():Object
		{
			return _magic;
		}

		public function set magic(value:Object):void
		{
			_magic = value;
		}

		public function get magic_equipped_at():String
		{
			return _magic_equipped_at;
		}

		public function set magic_equipped_at(value:String):void
		{
			_magic_equipped_at = value;
		}

		public function get relics():Array
		{
			return _relics;
		}

		public function set relics(value:Array):void
		{
			_relics = value;
		}

		public function get bonus_gold_per_hour():int
		{
			return _bonus_gold_per_hour;
		}

		public function set bonus_gold_per_hour(value:int):void
		{
			_bonus_gold_per_hour = value;
		}

		public function get bonus_karma_per_hour():int
		{
			return _bonus_karma_per_hour;
		}

		public function set bonus_karma_per_hour(value:int):void
		{
			_bonus_karma_per_hour = value;
		}

		public function get ninjas():Array
		{
			return _ninjas;
		}

		public function set ninjas(value:Array):void
		{
			_ninjas = value;
		}

		public function get exp_to_level():int
		{
			return _exp_to_level;
		}

		public function set exp_to_level(value:int):void
		{
			_exp_to_level = value;
		}

		public function get total_exp_to_level():int
		{
			return _total_exp_to_level;
		}

		public function set total_exp_to_level(value:int):void
		{
			_total_exp_to_level = value;
		}

		public function get seconds_of_bonus_exp():int
		{
			return _seconds_of_bonus_exp;
		}

		public function set seconds_of_bonus_exp(value:int):void
		{
			_seconds_of_bonus_exp = value;
		}

		public function get seconds_of_magic():int
		{
			return _seconds_of_magic;
		}

		public function set seconds_of_magic(value:int):void
		{
			_seconds_of_magic = value;
		}

		public function get achievements():Array
		{
			return _achievements;
		}

		public function set achievements(value:Array):void
		{
			_achievements = value;
		}

		public function get gained_exp():int
		{
			return _gained_exp;
		}

		public function set gained_exp(value:int):void
		{
			_gained_exp = value;
		}

		public function get gained_karma():int
		{
			return _gained_karma;
		}

		public function set gained_karma(value:int):void
		{
			_gained_karma = value;
		}

		public function get gained_gold():int
		{
			return _gained_gold;
		}

		public function set gained_gold(value:int):void
		{
			_gained_gold = value;
		}

		public function get gained_level():int
		{
			return _gained_level;
		}

		public function set gained_level(value:int):void
		{
			_gained_level = value;
		}

		public function get gained_gift_currency():int
		{
			return _gained_gift_currency;
		}

		public function set gained_gift_currency(value:int):void
		{
			_gained_gift_currency = value;
		}

		public function get inventory():Array
		{
			return _inventory;
		}

		public function set inventory(value:Array):void
		{
			_inventory = value;
		}

		public function get flags():String
		{
			return _flags;
		}

		public function set flags(value:String):void
		{
			_flags = value;
		}

		public function get defeated_girl():Boolean
		{
			return _defeated_girl;
		}

		public function set defeated_girl(value:Boolean):void
		{
			_defeated_girl = value;
		}

		public function get defeated_genbu():Boolean
		{
			return _defeated_genbu;
		}

		public function set defeated_genbu(value:Boolean):void
		{
			_defeated_genbu = value;
		}

		public function get defeated_small_girl():Boolean
		{
			return _defeated_small_girl;
		}

		public function set defeated_small_girl(value:Boolean):void
		{
			_defeated_small_girl = value;
		}

		public function get defeated_mechagenbu():Boolean
		{
			return _defeated_mechagenbu;
		}

		public function set defeated_mechagenbu(value:Boolean):void
		{
			_defeated_mechagenbu = value;
		}

		public function get allies():Array
		{
			return _allies;
		}

		public function set allies(value:Array):void
		{
			_allies = value;
		}

		public function get ally_count():int
		{
			return _ally_count;
		}

		public function set ally_count(value:int):void
		{
			_ally_count = value;
		}

		public function get ally_requests():Array
		{
			return _ally_requests;
		}

		public function set ally_requests(value:Array):void
		{
			_ally_requests = value;
		}

		public function get daimyo_gift():int
		{
			return _daimyo_gift;
		}

		public function set daimyo_gift(value:int):void
		{
			_daimyo_gift = value;
		}

		public function get cloud():int
		{
			return _cloud;
		}

		public function set cloud(value:int):void
		{
			_cloud = value;
		}

		public function get tournament_in():int
		{
			return _tournament_in;
		}

		public function set tournament_in(value:int):void
		{
			_tournament_in = value;
		}

		public function get horde_in():int
		{
			return _horde_in;
		}

		public function set horde_in(value:int):void
		{
			_horde_in = value;
		}

		public function get errors():Array
		{
			return _errors;
		}

		public function set errors(value:Array):void
		{
			_errors = value;
		}

		public function get activeRelics():Array
		{
			return _activeRelics;
		}

		public function set activeRelics(value:Array):void
		{
			_activeRelics = value;
			//trace("userinfovo+++++++++++++++"+activeRelics.length);
		}

		public function get weaponInventory():Array
		{
			return _weaponInventory;
		}

		public function set weaponInventory(value:Array):void
		{
			_weaponInventory = value;
		}

		public function get relicInventory():Array
		{
			return _relicInventory;
		}

		public function set relicInventory(value:Array):void
		{
			_relicInventory = value;
		}


	}
}

