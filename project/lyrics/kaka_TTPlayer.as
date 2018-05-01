package lyrics
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.MouseEvent;
	import flash.events.SecurityErrorEvent;
	import flash.events.TimerEvent;
	import flash.net.URLLoader;
	import flash.net.URLLoaderDataFormat;
	import flash.net.URLRequest;
	import flash.net.URLRequestMethod;
	import flash.utils.Timer;
	import myevents.MyEvent;
	
	/**
	* ...
	* @author kaka
	* @version 0.2
	* @date 08/9/15
	*/
	public class kaka_TTPlayer extends Sprite 
	{
		var _list:XML;
		var shower:LyricsShower;
		var xmlLoader:URLLoader;
		var xmlRequest:URLRequest;
		var _index:int;
		var _rand:Boolean;
		var _reTryTime:int;
		var _autoPlay:Boolean;
		var _skin:kaka_TTPlayerSkin;
		var _listSkin:kaka_TTPlayerListSkin;
		public function kaka_TTPlayer(skin:kaka_TTPlayerSkin, listSkin:kaka_TTPlayerListSkin = null):void
		{
			init(skin, listSkin);
		}
		function init(skin:kaka_TTPlayerSkin, listSkin:kaka_TTPlayerListSkin):void
		{
			shower = new LyricsShower();
			shower.showWidth = 500;
			addChild(shower);
			shower.addEventListener(Event.SOUND_COMPLETE, soundComplete);
			
			xmlLoader = new URLLoader();
			xmlLoader.dataFormat = URLLoaderDataFormat.TEXT;
			xmlRequest = new URLRequest();
			xmlRequest.method = URLRequestMethod.POST;
			
			_skin = skin;
			_skin.addEventListener(kaka_TTPlayerSkin.PLAY, skinPlay);
			_skin.addEventListener(kaka_TTPlayerSkin.PAUSE, skinPause);
			_skin.addEventListener(kaka_TTPlayerSkin.STOP, skinStop);
			_skin.addEventListener(kaka_TTPlayerSkin.NEXT, skinNext);
			_skin.addEventListener(kaka_TTPlayerSkin.PREV, skinPrev);
			_skin.x = shower.x + (shower.showWidth - _skin.width) / 2;
			_skin.y = shower.y + shower.height;
			addChild(_skin);
			
			if (listSkin)
			{
				_listSkin = listSkin;
				_listSkin.x = _skin.x + (_skin.width - _listSkin.width) / 2;
				_listSkin.y = _skin.y + _skin.height;
				addChild(_listSkin);
				_skin.addEventListener(kaka_TTPlayerSkin.LIST, showList);
				
				_listSkin.addEventListener(kaka_TTPlayerListSkin.PLAYSONG, listPlaySong);
			}
		}
		
		function showList(evt:Event):void
		{
			_listSkin.showList();
		}
		
		function listPlaySong(evt:MyEvent):void
		{
			stop();
			play(evt.args.index);
		}
		
		//是否自动开始播放
		public function set autoPlay(b:Boolean):void
		{
			this._autoPlay = _skin.isPlay = b;
		}
		public function get autoPlay():Boolean
		{
			return this._autoPlay;
		}
		//是否随机播放
		public function set randomPlay(b:Boolean):void
		{
			this._rand = b;
		}
		public function get randomPlay():Boolean
		{
			return this._rand;
		}
		//设置现成的歌曲信息XML
		public function set list(listXML:XML):void
		{
			this._list = listXML.copy();
		}
		//获取歌曲信息的XML
		public function get list():XML
		{
			return this._list.copy();
		}
		//设置歌曲信息XML的地址，让他自己加载
		public function set listURL(url:String):void
		{
			_list = null;
			
			try
			{
				xmlLoader.close();
			}
			catch(e)
			{
				
			}			
			
			xmlRequest.url = url;
			
			addxmlLoaderEventListeners();
			
			xmlLoader.load(xmlRequest);
		}
		//获取歌曲信息XML的地址
		public function get listURL():String
		{
			return xmlRequest.url;
		}
		//公开方法，播放第index首歌曲，随后是否随机播放
		public function play(index:int = 0):void
		{
			this._index = index;
			autoPlay = true;
			if (_list)
			{
				if (index >= 0 && index < _list.song.length())
				{
					playSound(index);
				}
				else
				{
					_skin.isPlay = false;
				}
			}
		}
		//获取当前歌曲索引
		public function get songIndex():int
		{
			return _index;
		}
		//播放第index首歌曲
		public function playSound(index:int):void
		{
			_skin.musicName = _list.song[index];
			//必须先设置歌曲地址，否则歌词在设置歌曲地址之后会被清空
			//shower.musicURL = _list.song[index].@mp3Path;
			//shower.lyricURL = _list.song[index].@lyricPath;
			shower.musicName = _list.song[index];
			shower.musicURL = "http://www.superkaka.org/Music/" + _list.song[index].@mp3Path;
			shower.lyricURL = "http://www.superkaka.org/kaka_LyricShow/" + _list.song[index].@lyricPath;	
			//shower.play(20*1000); 
			shower.play();
			_skin.isPlay = true;
			/*
			ii = index;
			var timer:Timer = new Timer(5000, 1);
			timer.addEventListener(TimerEvent.TIMER, ss);
			timer.start();
			*/
		}
		/*
		var ii:int;
		function ss(evt:TimerEvent):void
		{
			//shower.lyricURL = "http://www.angels-love.cn/kaka_LyricShow/" + _list.song[ii].@lyricPath;	
			shower.lyricURL = _list.song[ii].@lyricPath;
		}
		*/
		//播放或者继续播放
		public function replay():void
		{
			if (shower.isplay)
			{
				_skin.isPlay = true;
				shower.play();
			}
			else
			{				
				play(_index);
			}
		}
		//下一曲
		public function nextSound():void
		{
			++_index < _list.song.length() ? _index : _index = 0;
			playSound(_index);
		}
		//上一曲
		public function prevSound():void
		{
			--_index < 0 ? _index = _list.song.length() - 1 : _index;
			playSound(_index);
		}
		//暂停
		public function pause():void
		{
			shower.pause();
		}
		//停止
		public function stop():void
		{
			shower.stop();
		}		
		//声音播放完成
		function soundComplete(evt:Event):void
		{
			if (_rand)
			{
				_index = Math.random() * _list.song.length() ^ 0;
				playSound(_index);
			}
			else
			{
				nextSound();
			}
		}
		
		
		////////////歌曲信息xml加载
		function addxmlLoaderEventListeners():void
		{
			xmlLoader.addEventListener(Event.COMPLETE, xmlLoadComplete);            
            xmlLoader.addEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler);
			xmlLoader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, securityErrorHandler);
		}
		function removexmlLoaderEventListeners():void
		{			
			xmlLoader.removeEventListener(Event.COMPLETE, xmlLoadComplete);            
            xmlLoader.removeEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler);
			xmlLoader.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, securityErrorHandler);
			_reTryTime = 0;			
		}
		function xmlLoadComplete(evt:Event):void
		{
			removexmlLoaderEventListeners();
			_list = XML(xmlLoader.data);
			
			_listSkin.list = _list.song;
			
			_autoPlay && play(_index);
			/*
			if (!_autoPlay)
			{
				shower.stop();
			}
			*/
		}
		function ioErrorHandler(evt:IOErrorEvent):void
		{
			if (_reTryTime++ < 3)			
			{
				xmlLoader.load(xmlRequest);
			}
			else
			{
				trace("ioError!!");
				removexmlLoaderEventListeners();
			}
		}
		function securityErrorHandler(evt:SecurityErrorEvent):void
		{
			trace("securityError!!");
			removexmlLoaderEventListeners();
		}
		
		///////skin的侦听器
		function skinPlay(evt:Event):void
		{
			replay();
		}
		function skinPause(evt:Event):void
		{
			pause();
		}
		function skinStop(evt:Event):void
		{
			stop();
		}
		function skinNext(evt:Event):void
		{
			nextSound();
		}
		function skinPrev(evt:Event):void
		{
			prevSound();
		}
	}
	
}