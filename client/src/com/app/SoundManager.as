package com.app {
	import flash.events.*;
	import flash.net.*;
	import flash.media.*;
	import flash.system.*;
	
	public class SoundManager { 
		
		private var channelList:Array;
		private var musicChannels:Array;
		private var currentChannel:int = 0;
		private var directory:String = "";
		private var prefix:String = "";
		public var muted:Boolean = false;
		public var soundObject:Object;
		private var soundDisabled:Boolean = false;
		private var _playCount:int = 0;
		private var sfxVolume:Number = 0.5;
		private var currentMusic:String = "";
		
		public function SoundManager(_arg1:String, _arg2:int=6, _arg3:Number=1){
			this.channelList = new Array(0);
			this.musicChannels = new Array(0);
			this.soundObject = {};
			super();
			this.directory = _arg1;
			var _local4:int;
			while (_local4 < _arg2) {
				this.channelList.push(new SoundChannel());
				this.channelList[_local4].soundTransform = new SoundTransform(this.sfxVolume);
				_local4++;
			};
			this.musicChannels.push(new SoundChannel());
			if (this.channelList[0] == null){
				this.soundDisabled = true;
			};
		}
		public function setPrefix(_arg1:String):void{
			this.prefix = _arg1;
		}
		public function loadSoundEffect(_arg1:String, _arg2:int=0):void{
			var sound:* = _arg1;
			var loops:int = _arg2;
			if (((!(this.muted)) && (!(this.soundDisabled)))){
				if (this.soundObject[sound] == undefined){
					this.soundObject[sound] = {
						sound:new Sound(new URLRequest((((this.prefix + this.directory) + sound) + ".mp3"))),
						channel:0
					};
					this.soundObject[sound].sound.addEventListener(IOErrorEvent.IO_ERROR, this.soundFail);
				};
				if (this.channelList[this.currentChannel] != null){
					this.channelList[this.currentChannel].stop();
					try {
						this.soundObject[sound].channel = this.currentChannel;
						this.channelList[this.currentChannel] = this.soundObject[sound].sound.play(0, loops, this.channelList[this.currentChannel].soundTransform);
						this.currentChannel = ((this.currentChannel)==(this.channelList.length - 1)) ? 0 : (this.currentChannel + 1);
					} catch(e) {
					};
				};
			};
		}
		public function stopSoundEffect(_arg1:String):void{
			if (this.soundObject[_arg1] != null){
				this.channelList[this.soundObject[_arg1].channel].stop();
			};
		}
		public function loadMusic(_arg1:String):void{
			var music:* = _arg1;
			if (((!(this.muted)) && (!(this.soundDisabled)))){
				if (this.soundObject[music] == undefined){
					this.soundObject[music] = new Sound(new URLRequest((((this.prefix + this.directory) + music) + ".mp3")));
					this.soundObject[music].addEventListener(IOErrorEvent.IO_ERROR, this.soundFail);
				};
				if (this.musicChannels[0] != null){
					this.musicChannels[0].stop();
					try {
						this.currentMusic = music;
						this.musicChannels[0] = this.soundObject[music].play(0, 9999, this.musicChannels[0].soundTransform);
					} catch(e) {
					};
				};
			};
		}
		public function mute():void{
			if (!this.muted){
				this.stopAll();
				this.musicChannels[0].stop();
				this.muted = true;
			} else {
				this.musicChannels[0] = this.soundObject[this.currentMusic].play(0, 9999, this.musicChannels[0].soundTransform);
				this.muted = false;
			};
		}
		public function get playCount():int{
			return (this._playCount);
		}
		private function soundFail(_arg1:IOErrorEvent):void{
			trace(_arg1);
		}
		public function stopAll():void{
			var _local1:int;
			if (!this.soundDisabled){
				_local1 = 0;
				while (_local1 < this.channelList.length) {
					if (this.channelList[_local1] != null){
						this.channelList[_local1].stop();
					};
					_local1++;
				};
			};
		}
		
	}
}//package 