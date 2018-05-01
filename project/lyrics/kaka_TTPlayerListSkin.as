package lyrics
{
	import fl.transitions.easing.*;
	import fl.transitions.Tween;
	import fl.transitions.TweenEvent;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.filters.BlurFilter;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	import myevents.MyEvent;
	
	/**
	* ...
	* @author DefaultUser (Tools -> Custom Arguments...)
	*/
	public class kaka_TTPlayerListSkin extends MovieClip
	{
		var title:Sprite;
		var btn_close:Sprite;
		var bg:Sprite;
		var tween_show:Tween;
		var _visible:Boolean;
		static public const PLAYSONG:String = "playsong"; 
		var textFormat_list:TextFormat = new TextFormat('黑体', 14, 0xffffff);
		public function kaka_TTPlayerListSkin():void
		{
			this.visible = false;
			
			btn_close = getChildByName("closeBtn") as Sprite;
			title = getChildByName("sp_title") as Sprite;
			bg = getChildByName("BG") as Sprite;
			btn_close.buttonMode = true;
			btn_close.addEventListener(MouseEvent.CLICK, closeList);
			
			tween_show = new Tween(this, "alpha", Strong.easeOut, 0, 0, .75, true);
			tween_show.stop();
			tween_show.addEventListener(TweenEvent.MOTION_FINISH, showFinished);			
		}
		
		public function showList():void
		{
			this.visible = _visible = true;
			tween_show.stop();
			tween_show.begin = this.alpha;
			tween_show.finish = 1;
			tween_show.time = tween_show.duration - tween_show.time;
			tween_show.start();
		}
		
		function closeList(evt:MouseEvent):void
		{
			_visible = false;
			tween_show.stop();
			tween_show.begin = this.alpha;
			tween_show.finish = 0;
			tween_show.time = tween_show.duration - tween_show.time;
			tween_show.start();
		}
		
		function showFinished(evt:TweenEvent):void
		{
			_visible || (this.visible = false);
		}
		
		public function set list(listInfo:*):void
		{
			if (listInfo is XMLList)
			{
				var songList:XMLList = listInfo as XMLList;
				var yy:Number = title.height + 5;
				var c:int = songList.length();
				for (var i:int = 0; i < c; i++)
				{
					var sp:Sprite = new Sprite();	
					sp.name = i + "";				
					var txt:TextField = new TextField();
					txt.text = (i + 1) + ". " + songList[i];
					txt.selectable = false;
					txt.setTextFormat(textFormat_list);
					txt.autoSize = TextFieldAutoSize.LEFT;
					txt.filters = [new BlurFilter(0, 0)];
					sp.addChild(txt);
					sp.x = 10;
					sp.y = yy;
					
					i != c - 1 && (yy += sp.height + 2);
					
					
					addChild(sp);
					
					sp.mouseChildren = false;
					sp.buttonMode = true;
					sp.doubleClickEnabled = true;
					sp.addEventListener(MouseEvent.DOUBLE_CLICK, playSong);	
				}
				bg.height = yy;
			}			
		}
		function playSong(evt:MouseEvent):void
		{
			var event:MyEvent = new MyEvent(PLAYSONG);
			event.args.index = int(evt.target.name);
			dispatchEvent(event);
		}
	}	
}