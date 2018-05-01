package lyrics
{
	import fl.transitions.easing.*;
	import fl.transitions.Tween;
	import fl.transitions.TweenEvent;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Graphics;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.MouseEvent;
	import flash.events.ProgressEvent;
	import flash.events.SecurityErrorEvent;
	import flash.media.Sound;
	import flash.media.SoundChannel;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;	
	import flash.display.GradientType;
	import flash.geom.Matrix;
	import flash.display.SpreadMethod;
	
	/**
	* ...
	* @author kaka
	* @version 0.4
	* @date 08/9/19
	*/
	public class LyricsShower extends Sprite
	{
		var lyricLoader:URLLoader;
		var lyricRequest:URLRequest;
		var _reTryTime:int;
		
		var sprite_lyricsContainer:Sprite;
		var sprite_lyrics:Sprite;
		var arr_splitedLyrics:Array;
		var sound:Sound;
		var soundchannel:SoundChannel;
		var soundRequest:URLRequest;
		//当前播放的歌曲名
		var _musicName:String = "";
		//显示的宽度
		var _showWidth:Number = 600;
		//指示歌曲是否已经播放
		var _isplay:Boolean = false;
		//指示歌曲是否正在暂停
		var _ispause:Boolean = true;
		//横向滚动歌词的TWEEN
		var tween_sd:Tween;
		//歌词到第几句了
		var _lrcIndex:int;
		//遮罩
		var _mask:Shape;
		//前方阴影
		var _shadow:Sprite
		//当前为绿色的歌词文本框
		var txt_green:TextField;
		//歌词大小
		var _fontSize:int = 13;
		//正在显示的歌词样式
		var textFormat_show:TextFormat = new TextFormat('黑体', _fontSize, 0x66CC00);
		//默认歌词样式
		var textFormat_default:TextFormat = new TextFormat('黑体', _fontSize, 0x6699FF);
		
		public function LyricsShower():void
		{
			init();
		}
		function init():void
		{
			//容纳所有歌词的容器
			sprite_lyricsContainer = new Sprite();
			sprite_lyrics = new Sprite();
			sprite_lyricsContainer.mouseChildren = sprite_lyrics.mouseChildren = false;
			sprite_lyricsContainer.mouseEnabled = sprite_lyrics.mouseEnabled = false;
			
			sprite_lyricsContainer.addChild(sprite_lyrics);
			addChild(sprite_lyricsContainer);
			
			_mask = new Shape();
			_shadow = new Sprite();

			sprite_lyrics.mask = _mask;
			
			lyricLoader = new URLLoader();
			lyricRequest = new URLRequest();
			
			soundRequest = new URLRequest();
			
			showWidth = _showWidth;
			
			tween_sd = new Tween(sprite_lyrics, "x", None.easeNone, 0, 0, 0, true);
			tween_sd.stop();
			tween_sd.addEventListener(TweenEvent.MOTION_FINISH, tweenFinished);
		}
		
		function drawMask(w:Number = 500, h:Number = 0):void
		{
			if (h == 0)
			{
				var txt:TextField = new TextField();
				txt.text = "测试Height";
				txt.autoSize = TextFieldAutoSize.LEFT;
				txt.setTextFormat(textFormat_default);
				h = txt.height;
				txt = null;
			}
			var gr:Graphics = _mask.graphics;
			gr.clear();
			gr.lineStyle();
			gr.beginFill(0);
			gr.drawRect(0, 0, w, h + 7);
			gr.endFill();
			
			addChild(_mask);
			
			gr = _shadow.graphics;			
			gr.clear();
			var colors:Array = new Array(0x000000, 0x000000, 0x000000, 0x000000);
			var alphas:Array = new Array(1, 0, 0, 1);
			var ratios:Array = new Array(0, 50, 205, 255);
			var matr:Matrix = new Matrix();
			matr.createGradientBox(w, h, 0, 0, 0);
			var spreadMethod:String = SpreadMethod.PAD;
			gr.beginGradientFill(GradientType.LINEAR, colors, alphas, ratios, matr, spreadMethod);
			gr.drawRect(0, 0, w, h + 7);
			gr.endFill();
			
			addChild(_shadow);
			
			gr = this.graphics;
			gr.clear();
			gr.lineStyle();
			gr.beginFill(0xCCCCCC);
			gr.drawRect(0, 0, w, 3.5);
			gr.drawRect(0, h + 3.5, w, 3.5);
			gr.beginFill(0x000000);
			gr.drawRect(0, 3.5, w, h);
			gr.endFill();			
		}
		public function set showWidth(value:Number):void
		{
			_showWidth = value;
			sprite_lyricsContainer.x = value / 2;
			sprite_lyricsContainer.y = 3;
			drawMask(value);
		}
		public function get showWidth():Number
		{
			return _showWidth;
		}		
		
		//释放资源，重置状态
		function reset():void
		{
			if (tween_sd)
			{
				pauseLrc();
			}
			
			if (soundchannel)
			{
				soundchannel.removeEventListener(Event.SOUND_COMPLETE, soundComplete);
				soundchannel.stop();
			}
			
			if (sound)
			{
				sound.removeEventListener(IOErrorEvent.IO_ERROR, soundLoadFailed);
				try
				{
					sound.close();
				}
				catch (e)
				{
					
				}
			}			

			soundchannel = null;
			sound = null;
			
			//_lrcIndex = 0;			
			_ispause = true;
			_isplay = false;			
			
			resetLrc();
			
			//sprite_lyrics.x = 0;
			//arr_splitedLyrics = null;
			lrcDragEnabled = false;
			removelyricLoaderEventListeners();
		}
		
		function play(position:Number = -1):void
		{
			jumpLrcByTime(position, false);	
			
			if (arr_splitedLyrics && position < 0)
			{
				position = jumpLrcByX(sprite_lyrics.x);
			}
			
			playSound(position);
			
			resumeLrc();
			
			lrcDragEnabled = true;			
		}
		
		//暂停
		public function pause():void
		{			
			pauseSound();
			pauseLrc();
		}
		
		//停止
		public function stop():void
		{			
			reset();		
		}
		
		//从指定位置播放歌曲，默认从当前位置播放
		function playSound(position:Number = -1):void
		{
			if (soundRequest.url == null)
			{
				return;
			}
			sound || (sound = new Sound(soundRequest), sound.addEventListener(IOErrorEvent.IO_ERROR, soundLoadFailed));
			if (position < 0)
			{
				if (soundchannel)
				{
					if (_ispause)
					{
						soundchannel = sound.play(soundchannel.position);
					}
				}
				else
				{
					soundchannel = sound.play();
				}
			}
			else
			{
				pauseSound();
				soundchannel = sound.play(position);
			}
			soundchannel.addEventListener(Event.SOUND_COMPLETE, soundComplete);
			_isplay = true;
			_ispause = false;			
		}
		
		//停止声音并且停止声音的加载
		function stopSound():void
		{
			pauseSound();
			try
			{
				sound.close();
			}
			catch (e)
			{
				
			}
			soundchannel = null;
			sound = null;
		}
		
		//暂停声音
		function pauseSound():void
		{
			if (soundchannel)
			{
				soundchannel.position;
				soundchannel.stop();
				soundchannel.removeEventListener(Event.SOUND_COMPLETE, soundComplete);
			}
			_ispause = true;
		}
		
		//设置歌词滚动
		function setLrc(start:Number = Infinity, end:Number = Infinity, duration:Number = Infinity):void
		{
			tween_sd.stop();
			start    == Infinity || (tween_sd.begin    = start   );
			end      == Infinity || (tween_sd.finish   = end     );
			duration == Infinity || (tween_sd.duration = duration);
			tween_sd.duration == Infinity && (tween_sd.duration = 0.1);
			tween_sd.time = 0;
			//tween_sd.start();
			//tween_sd.stop();
			//tween_sd.obj[tween_sd.prop] = tween_sd.begin;
		}
		
		//暂停歌词滚动
		function pauseLrc():void
		{
			tween_sd.stop();
		}
		
		//停止并且重置歌词
		function resetLrc():void
		{
			pauseLrc();
			_lrcIndex = 0;
			if (arr_splitedLyrics)
			{
				setLrc(0, -arr_splitedLyrics[0][2].width, arr_splitedLyrics[1][0]);
				updateActiveText();
			}			
		}
		
		//清空歌词
		function clearLrc():void
		{
			//清空sprite_lyrics中的歌词文本
			while (sprite_lyrics.numChildren > 0)
			{
				sprite_lyrics.removeChildAt(0);
			}
		}
		
		//恢复歌词滚动
		function resumeLrc():void
		{
			arr_splitedLyrics && (tween_sd.isPlaying || tween_sd.resume());
		}
		
		//将歌词滚动跳转到横向坐标X
		function jumpLrcByX(jumpX:Number, goBack:Boolean = true):Number
		{			
			if (!arr_splitedLyrics)
			{
				return Infinity;
			}
			
			var jumpIndex:int = -1;
			for (var i:int = arr_splitedLyrics.length - 1; i >= 0; i--)			
			{
				if (arr_splitedLyrics[i][2].x <= -jumpX)
				{
					jumpIndex = i;					
					break;
				}
			}			
			
			pauseLrc();
			
			//跳转到的那句歌词已经经过了多少的百分比
			var pec:Number = -(arr_splitedLyrics[jumpIndex][2].x + jumpX) / arr_splitedLyrics[jumpIndex][2].width;

			//跳转到的那句歌词滚动所需要的持续时间
			var tmptime:Number;
			
			if (jumpIndex != arr_splitedLyrics.length - 1)
			{
				tmptime = arr_splitedLyrics[jumpIndex + 1][0] - arr_splitedLyrics[jumpIndex][0];
			}
			else
			{
				tmptime = sound.length / 1000 - arr_splitedLyrics[jumpIndex][0];
			}			
			
			//歌曲所要跳转到的时间
			var replaytime:Number = (arr_splitedLyrics[jumpIndex][0] + tmptime * pec) * 1000;	
			
			//如果歌曲所要跳转到的时间还未加载到就返回当前歌曲所处的位置
			if (sound && replaytime > sound.length)			
			{
				//重新设置歌词位置为当前歌曲播放位置
				goBack && jumpLrcByTime(soundchannel.position);
				//后面的代码随之跳过
				return -1;
			}
			
			//更新当前所到的歌词数
			_lrcIndex = jumpIndex;
			
			setLrc(jumpX, jumpX - arr_splitedLyrics[_lrcIndex][2].width * (1 - pec), tmptime * (1 - pec));
			
			updateActiveText();
			
			return replaytime;
		}
		
		//将歌词滚动跳转到时间
		function jumpLrcByTime(time:Number, checkTime:Boolean = true):void
		{
			if (!arr_splitedLyrics)
			{
				return;
			}			
			if (checkTime)
			{
				if (time >= sound.length)
				{
					return;
				}
			}
			
			if (time < 0)
			{
				return;				
			}
				pauseLrc();
				time /= 1000;
				
				var c:int = arr_splitedLyrics.length;
				for (var i:int = 1; i < c; i++)
				{
					if (time >= arr_splitedLyrics[i - 1][0] && time <= arr_splitedLyrics[i][0])
					{
						_lrcIndex = i - 1;
						updateActiveText();
						
						var pec:Number = (time - arr_splitedLyrics[i - 1][0]) / (arr_splitedLyrics[i][0] - arr_splitedLyrics[i - 1][0]);
						
						setLrc( -(arr_splitedLyrics[_lrcIndex][2].x + arr_splitedLyrics[_lrcIndex][2].width * pec), -arr_splitedLyrics[i][2].x, arr_splitedLyrics[i][0] - time);
						
						return;
					}
				}
				//如果跳转到的是最后一句的处理
				_lrcIndex = i - 1;				
				updateActiveText();
				
				
				var pec:Number = (time - arr_splitedLyrics[_lrcIndex][0]) / (sound.length - arr_splitedLyrics[_lrcIndex][0]);
				
				setLrc( -(arr_splitedLyrics[_lrcIndex][2].x + arr_splitedLyrics[_lrcIndex][2].width * pec), -sprite_lyrics.width, sound.length / 1000 - time);		
		}
		
		public function updateLrc(arr_splitedLyrics:Array):void
		{
			if (!arr_splitedLyrics)
			{
				return;
			}
			this.arr_splitedLyrics = arr_splitedLyrics;
			
			//清空sprite_lyrics中的歌词文本
			clearLrc();
			
			//歌词解析完成，下面开始创建歌词显示文本			
			//加入歌词
			for (var i:int = 0; i < arr_splitedLyrics.length; i++)
			{
				var txt:TextField = new TextField();
				
				//txt.border = true;
				//txt.borderColor = 0xffffff;
				
				txt.selectable = false;
				txt.text = arr_splitedLyrics[i][1];
				txt.setTextFormat(textFormat_default);
				txt.autoSize = TextFieldAutoSize.LEFT;
				txt.x = sprite_lyrics.width;
				sprite_lyrics.addChild(txt);
				arr_splitedLyrics[i][2] = txt;
			}
			_lrcIndex = 0;
			updateActiveText();
			
			setLrc(0, -arr_splitedLyrics[0][2].width, arr_splitedLyrics[1][0]);
			
			lrcDragEnabled = true;
		}
		
		//更新当前高亮显示的文本
		function updateActiveText():void
		{
			txt_green && txt_green.setTextFormat(textFormat_default);
			if (arr_splitedLyrics)
			{
				txt_green = arr_splitedLyrics[_lrcIndex][2];
				txt_green.setTextFormat(textFormat_show);
			}			
		}
		
		////////////////////////////////////////////////////
		////////////////////////////////////////////////////
		
		public function get isplay():Boolean
		{
			return _isplay;
		}
		
		public function set musicURL(url:String):void
		{
			reset();
			soundRequest.url = url;
			//sound = new Sound(soundRequest);
		}
		public function get musicURL():String
		{
			return sound.url;
		}
		public function set lyricURL(url:String):void
		{
			try
			{
				lyricLoader.close();
			}
			catch (e)
			{
				
			}
			
			if (arr_splitedLyrics == null || lyricRequest.url != url)
			{
				pauseLrc();
				arr_splitedLyrics = null;
				lrcDragEnabled = false;
				addlyricLoaderEventListeners();
				lyricRequest.url = url;
				lyricLoader.load(lyricRequest);
			}
		}
		public function get lyricURL():String
		{
			return lyricRequest.url;
		}
		
		//设置/获取当前播放的歌曲名称
		public function set musicName(name:String):void
		{
			_musicName = name;
		}
		
		public function get musicName():String
		{
			return _musicName;
		}
		
		//当没有歌词的时候显示歌曲名
		function showMusicName():void
		{
			clearLrc();
			var txt:TextField = new TextField();
			txt.text = _musicName;
			txt.autoSize = TextFieldAutoSize.LEFT;
			txt.setTextFormat(textFormat_default);
			txt.x = -txt.width / 2;
			sprite_lyrics.addChild(txt);
			sprite_lyrics.x = 0;
		}
		
		////////////歌词加载
		function addlyricLoaderEventListeners():void
		{
			lyricLoader.addEventListener(Event.COMPLETE, lyricLoadComplete);            
            lyricLoader.addEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler);
			lyricLoader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, securityErrorHandler);
		}
		function removelyricLoaderEventListeners():void
		{			
			lyricLoader.removeEventListener(Event.COMPLETE, lyricLoadComplete);            
            lyricLoader.removeEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler);
			lyricLoader.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, securityErrorHandler);
			_reTryTime = 0;
		}
		function lyricLoadComplete(evt:Event):void
		{
			removelyricLoaderEventListeners();
			
			updateLrc(SplitLyrics.split(lyricLoader.data));
			isplay && (jumpLrcByTime(soundchannel.position, false), lrcDragEnabled = true);
			_ispause || resumeLrc();
		}
		
		//开启/关闭歌词拖动
		public function set lrcDragEnabled(enabled:Boolean):void
		{
			if (enabled)
			{
				if (arr_splitedLyrics && isplay)
				{
					_shadow.buttonMode = true;
					_shadow.addEventListener(MouseEvent.MOUSE_DOWN, startDragLyrics);
				}				
			}
			else
			{
				_shadow.buttonMode = false;
				_shadow.removeEventListener(MouseEvent.MOUSE_DOWN, startDragLyrics);
			}
		}
		
		function ioErrorHandler(evt:IOErrorEvent):void
		{
			if (_reTryTime++ < 3)			
			{
				lyricLoader.load(lyricRequest);
			}
			else
			{
				trace("ioError!!");
				removelyricLoaderEventListeners();
				showMusicName();
			}
		}
		function securityErrorHandler(evt:SecurityErrorEvent):void
		{
			trace("securityError!!");
			removelyricLoaderEventListeners();
			showMusicName();
		}		
		
		//播放完成时的处理
		function soundComplete(evt:Event):void
		{
			reset();
			
			dispatchEvent(new Event(Event.SOUND_COMPLETE));
		}
		
		//歌曲文件不存在或加载失败
		function soundLoadFailed(evt:IOErrorEvent):void
		{
			trace("歌曲加载失败！");
			reset();
			//clearLrc();
		}
		
		//正常进入下一句歌词 
		function tweenFinished(evt:TweenEvent):void
		{
			_lrcIndex++;
			checkLength();
		}
		//检测是否已加载到相应的歌词
		function checkLength():void
		{
			if (_lrcIndex < arr_splitedLyrics.length)
			{
				if (sound.length > arr_splitedLyrics[_lrcIndex][0] * 1000)				
				{
					changeCurrentLrc(_lrcIndex);
				}
				else
				{
					sound.addEventListener(ProgressEvent.PROGRESS, soundData);
				}
			}
		}
		//更新歌词 
		function changeCurrentLrc(index:int):void
		{
			sound.removeEventListener(ProgressEvent.PROGRESS, soundData);
			
			if (index < 0 || index >= arr_splitedLyrics.length)			
			{
				return;
			}
			
			_lrcIndex = index;
			updateActiveText();
			
			var begin:Number = -arr_splitedLyrics[_lrcIndex][2].x;
			var finish:Number = -(arr_splitedLyrics[_lrcIndex][2].x + arr_splitedLyrics[_lrcIndex][2].width);
			var duration:Number;
			
			if (_lrcIndex != arr_splitedLyrics.length - 1)
			{
				duration = arr_splitedLyrics[_lrcIndex + 1][0] - soundchannel.position / 1000;
			}
			else
			{
				duration = (sound.length - soundchannel.position) / 1000;
			}
			setLrc(begin, finish, duration);
			_ispause || resumeLrc();
		}
		function soundData(evt:ProgressEvent):void
		{			
			checkLength();
		}		
		
		//开始拖动歌词
		function startDragLyrics(evt:MouseEvent):void
		{
			stage.addEventListener(MouseEvent.MOUSE_UP, stopDragLyrics);
			tween_sd.stop();
			tmpx = mouseX;
			stage.addEventListener(MouseEvent.MOUSE_MOVE, moveLyrics);
		}
		//拖动中..
		var tmpx:Number;
		function moveLyrics(evt:MouseEvent):void
		{
			sprite_lyrics.x += mouseX - tmpx;
			tmpx = mouseX;
			if (sprite_lyrics.x > 0)
			{
				sprite_lyrics.x = 0;
			}
			else if (sprite_lyrics.x < -sprite_lyrics.width)
			{
				sprite_lyrics.x = -sprite_lyrics.width;
			}
			jumpLrcByX(sprite_lyrics.x, false);
		}
		//结束拖动
		function stopDragLyrics(evt:MouseEvent):void
		{
			stage.removeEventListener(MouseEvent.MOUSE_UP, stopDragLyrics);
			stage.removeEventListener(MouseEvent.MOUSE_MOVE, moveLyrics);

			var position:Number = jumpLrcByX(sprite_lyrics.x);
			
			/*
			else
			{
				playSound(jumpLrcByX(sprite_lyrics.x));
				resumeLrc();
			}
			*/
			if (!_ispause)
			{
				playSound(position);
				resumeLrc();
			}
		}		
	}	
}