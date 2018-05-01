package org.superkaka.KLib.manager 
{
	import flash.events.Event;
	import flash.media.Sound;
	import flash.media.SoundMixer;
	import flash.media.SoundTransform;
	import flash.utils.Dictionary;
	import org.superkaka.KLib.common.SoundPlayer;
	/**
	 * 声音管理
	 * @author ｋａｋａ
	 */
	public class SoundManager
	{
		
		static private const dic_sound:Object = { };
		
		static private const dic_playing:Dictionary = new Dictionary();
		
		static public function playSound(soundId:String, startTime:Number = 0, loop:int = 1, volume:Number = NaN):SoundPlayer
		{
			
			var sound:SoundPlayer = getSound(soundId);
			
			if (null == sound) throw new Error("未注册的声音id:" + soundId);
			
			getPlayList(soundId, true).push(sound);
			
			sound.addEventListener(Event.SOUND_COMPLETE, soundCompleteHandler);
			
			if (!isNaN(volume)) sound.volume = volume;
			sound.play(startTime, loop);
			
			return sound;
			
		}
		
		static public function registerSound(sound:*, soundId:String):void
		{
			
			if (null != dic_sound[soundId]) throw new Error("已经注册的SoundId:" + soundId);
			
			var kSound:SoundPlayer;
			
			if (sound is Sound) dic_sound[soundId] = sound;
			else if (sound is SoundPlayer) dic_sound[soundId] = (sound as SoundPlayer).sound;
			else throw new Error("无效的声音对象");
			
		}
		
		static public function getSound(soundId:String):SoundPlayer
		{
			
			var sound:Sound = dic_sound[soundId];
			if (null == sound) return null;
			return new SoundPlayer(sound);
			
		}
		
		static public function removeSound(soundId:String):void
		{
			
			delete dic_sound[soundId];
			
		}
		
		static public function get volume():Number
		{
			
			return SoundMixer.soundTransform.volume;
			
		}
		
		static public function set volume(value:Number):void
		{
			
			if (value > 1 || value < 0 || isNaN(value)) throw new Error("非法的音量值:" + value);
			
			var transform:SoundTransform = SoundMixer.soundTransform;
			transform.volume = value;
			SoundMixer.soundTransform = transform;
			
		}
		
		static public function get soundTransform():SoundTransform 
		{
			return SoundMixer.soundTransform;
		}
		
		static public function set soundTransform(value:SoundTransform):void 
		{
			SoundMixer.soundTransform = value;
		}
		
		static public function pauseSound(soundId:String):void
		{
			
			var playList:Array = getPlayList(soundId);
			
			if (null == playList) return;
			
			for each(var sound:SoundPlayer in playList)
			{
				
				sound.pause();
				
			}
			
		}
		
		static public function resumeSound(soundId:String):void
		{
			
			var playList:Array = getPlayList(soundId);
			
			if (null == playList) return;
			
			for each(var sound:SoundPlayer in playList)
			{
				
				sound.resume();
				
			}
			
		}
		
		static public function stopSound(soundId:String):void
		{
			
			var playList:Array = getPlayList(soundId);
			
			if (null == playList) return;
			
			for each(var sound:SoundPlayer in playList)
			{
				
				sound.stop();
				
			}
			
			noSoundPlay(sound);
			
		}
		
		static public function pauseAllSound():void
		{
			
			for (var soundId:String in dic_sound)
			{
				
				pauseSound(soundId);
				
			}
			
		}
		
		static public function resumeAllSound():void
		{
			
			for (var soundId:String in dic_sound)
			{
				
				resumeSound(soundId);
				
			}
			
		}
		
		static public function stopAllSound():void
		{
			
			for (var soundId:String in dic_sound)
			{
				
				stopSound(soundId);
				
			}
			
		}
		
		static private function noSoundPlay(sound:SoundPlayer):void
		{
			
			delete dic_playing[sound.sound];
			
		}
		
		static private function soundCompleteHandler(evt:Event):void
		{
			
			var sound:SoundPlayer = evt.target as SoundPlayer;
			
			var playList:Array = getPlayList(sound.sound);
			
			if (null == playList) return;
			
			playList.splice(playList.indexOf(sound), 1);
			
			if (playList.length == 0)
			{
				noSoundPlay(sound);
			}
			
		}
		
		static private function getPlayList(soundInfo:*, autoCreate:Boolean = false):Array
		{
			
			var sound:Sound;
			if (soundInfo is String) sound = dic_sound[soundInfo];
			else sound = soundInfo;
			
			var list_play:Array = dic_playing[sound];
			
			if (null == list_play && autoCreate)
			{
				list_play = dic_playing[sound] = [];
			}
			
			return list_play;
			
		}
		
	}

}