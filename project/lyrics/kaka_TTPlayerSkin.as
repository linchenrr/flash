package lyrics
{
	import fl.transitions.Tween;
	import fl.transitions.easing.*;
	import fl.transitions.TweenEvent;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.filters.BlurFilter;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	
	/**
	* ...
	* @author DefaultUser (Tools -> Custom Arguments...)
	*/
	public class kaka_TTPlayerSkin extends MovieClip
	{
		var btn_play:Sprite;
		var btn_pause:Sprite;
		var btn_stop:Sprite;
		var btn_next:Sprite;
		var btn_prev:Sprite;
		var btn_list:Sprite;
		var _mask:Sprite;
		var txt:TextField;
		var bit_txt:Bitmap;
		var tw:Tween;
		static public const PLAY:String = "play";
		static public const PAUSE:String = "pause";
		static public const STOP:String = "stop";
		static public const NEXT:String = "next";
		static public const PREV:String = "prev";
		static public const LIST:String = "list";
		public function kaka_TTPlayerSkin():void
		{
			btn_play = getChildByName("_play") as Sprite;
			btn_pause = getChildByName("_pause") as Sprite;
			btn_stop = getChildByName("_stop") as Sprite;
			btn_next = getChildByName("_next") as Sprite;
			btn_prev = getChildByName("_prev") as Sprite;
			btn_list = getChildByName("_list") as Sprite;
			_mask = getChildByName("sp_mask") as Sprite;
			
			btn_play.buttonMode = btn_pause.buttonMode = btn_stop.buttonMode = btn_next.buttonMode = btn_prev.buttonMode = btn_list.buttonMode = true;
			btn_play.addEventListener(MouseEvent.MOUSE_DOWN, Play);
			btn_pause.addEventListener(MouseEvent.MOUSE_DOWN, Pause);
			btn_stop.addEventListener(MouseEvent.MOUSE_DOWN, Stop);
			btn_next.addEventListener(MouseEvent.MOUSE_DOWN, Next);
			btn_prev.addEventListener(MouseEvent.MOUSE_DOWN, Prev);
			btn_list.addEventListener(MouseEvent.MOUSE_DOWN, List);
			
			//addChild(_mask);
			
			bit_txt = new Bitmap();
			bit_txt.cacheAsBitmap = true;
			bit_txt.y = _mask.y;
			addChild(bit_txt);
			bit_txt.mask = _mask;
			
			txt = new TextField();
			txt.autoSize = TextFieldAutoSize.LEFT;
			txt.defaultTextFormat = new TextFormat('黑体', 12, 0xffffff);
			txt.mouseEnabled = false;
			
			tw = new Tween(bit_txt, "x", None.easeNone, 0, 0, 0, true);
			tw.stop();
			tw.addEventListener(TweenEvent.MOTION_FINISH, tweenFinished);
			
			isPlay = false;
		}
		
		public function set musicName(name:String):void
		{
			tw.stop();
			txt.text = name;		
			bit_txt.bitmapData = draw(txt);
			tw.begin = _mask.x + _mask.width + bit_txt.width * .5;
			tw.finish = _mask.x - bit_txt.width * 1.5;
			tw.duration = 10;
			tw.time = 0;			
			tw.start();
		}
		
		function draw(sp:DisplayObject):BitmapData
		{
			var bitmapdata:BitmapData = new BitmapData(sp.width, sp.height, true, 0x00ffffff);
			bitmapdata.draw(sp);
			return bitmapdata;
		}
		
		function tweenFinished(evt:TweenEvent):void
		{
			tw.start();
		}
		
		public function set isPlay(b:Boolean):void
		{
			btn_pause.visible = b;
			btn_play.visible = !b;
		}
		
		function Play(evt:MouseEvent):void
		{
			//isPlay = true;
			dispatchEvent(new Event(PLAY));
		}
		
		function Pause(evt:MouseEvent):void
		{
			isPlay = false;
			dispatchEvent(new Event(PAUSE));
		}
		
		function Stop(evt:MouseEvent):void
		{
			isPlay = false;
			dispatchEvent(new Event(STOP));
		}
		
		function Next(evt:MouseEvent):void
		{
			dispatchEvent(new Event(NEXT));
		}
		
		function Prev(evt:MouseEvent):void
		{
			dispatchEvent(new Event(PREV));
		}
		
		function List(evt:MouseEvent):void
		{
			dispatchEvent(new Event(LIST));
		}
	}
	
}