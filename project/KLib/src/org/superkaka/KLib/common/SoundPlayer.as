package org.superkaka.KLib.common 
{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.media.Sound;
	import flash.media.SoundChannel;
	import flash.media.SoundTransform;
	/**
	 * 声音
	 * @author ｋａｋａ
	 */
	
	[Event(name="soundComplete", type="flash.events.Event")] 
	
	public class SoundPlayer extends EventDispatcher
	{
		
		protected var loop:int;
		
		protected var curLoop:int;
		
		protected var _sound:Sound;
		
		protected var _channel:SoundChannel = new SoundChannel();
		
		protected var _position:Number = 0;
		
		protected var _volume:Number = 1;
		
		protected var _isPlaying:Boolean;
		
		public function SoundPlayer(sound:Sound = null):void
		{
			
			this._sound = sound;
			
		}
		
		/**
		 * 播放声音
		 * @param	startTime		开始播放的初始位置（以毫秒为单位）
		 * @param	loop				循环播放的次数（包括第一次），如果小于1则无限循环
		 */
		public function play(startTime:Number = 0, loop:int = 1):void
		{
			
			this.loop = loop;
			
			curLoop = 1;
			
			doPlay(startTime);
			
		}
		
		private function doPlay(startTime:Number = 0):void
		{
			
			stop();
			
			if (null == _sound) throw new Error("未填充Sound对象，无法播放");
			
			if (loop > 0 && curLoop > loop) 
			{
				_isPlaying = false;
				dispatchEvent(new Event(Event.SOUND_COMPLETE));
				return;
			}
			
			if (startTime >= _sound.length) startTime = _sound.length - 1;
			
			_channel.removeEventListener(Event.SOUND_COMPLETE, soundCompleteHandler);
			
			_channel = _sound.play(startTime);
			
			_isPlaying = true;
			
			setChannelValume();
			
			_channel.addEventListener(Event.SOUND_COMPLETE, soundCompleteHandler);
			
		}
		
		/**
		 * 从上一次暂停的位置开始继续播放声音
		 */
		public function resume():void
		{
			
			if (_isPlaying) return;
			doPlay(_position);
			
		}
		
		/**
		 * 暂停正在播放的声音
		 */
		public function pause():void
		{
			
			_position = _channel.position;
			_channel.stop();
			_isPlaying = false;
			
		}
		
		/**
		 * 停止正在播放的声音
		 */
		public function stop():void
		{
			
			_position = 0;
			_channel.stop();
			_isPlaying = false;
			
		}
		
		/**
		 * 获取或设置要播放的声音对象
		 */
		public function get sound():Sound 
		{
			return _sound;
		}
		
		public function set sound(value:Sound):void 
		{
			_sound = value;
		}
		
		/**
		 * 获取或设置播放时的音量
		 * 音量范围从 0（静音）至 1（最大音量）
		 */
		public function get volume():Number 
		{
			return _volume;
		}
		
		public function set volume(value:Number):void 
		{
			
			if (value > 1 || value < 0 || isNaN(value)) throw new Error("非法的音量值:" + value);
			
			_volume = value;
			
			setChannelValume();
			
		}
		
		private function setChannelValume():void
		{
			
			var transform:SoundTransform = _channel.soundTransform;
			transform.volume = _volume;
			_channel.soundTransform = transform;
			
		}
		
		/**
		 * 获取声音文件中当前播放的位置（以毫秒为单位）
		 */
		public function get position():Number 
		{
			return _channel.position;
		}
		
		/**
		 * 获取此声音当前是否处于播放状态
		 */
		public function get isPlaying():Boolean 
		{
			return _isPlaying;
		}
		
		private function soundCompleteHandler(evt:Event):void
		{
			
			curLoop++;
			doPlay();
			
		}
		
	}

}