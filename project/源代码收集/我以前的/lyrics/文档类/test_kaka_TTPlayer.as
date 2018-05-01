package 
{
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import lyrics.kaka_TTPlayer;
	import lyrics.kaka_TTPlayerListSkin;
	import lyrics.kaka_TTPlayerSkin;
	
	/**
	* ...
	* @author kaka
	* @version 0.2
	* @date 08/9/15
	*/
	public class test_kaka_TTPlayer extends Sprite 
	{
		var ttplayer:kaka_TTPlayer;
		public function test_kaka_TTPlayer():void
		{
			addEventListener(Event.ADDED_TO_STAGE, add_to_stage);			
		}
		function add_to_stage(evt:Event):void
		{
			init();
		}
		function init():void
		{
			stage.align = StageAlign.TOP_LEFT;
			stage.scaleMode = StageScaleMode.NO_SCALE;
			//ttplayer = new kaka_TTPlayer(new QZONE_PlayerSkin(),new QZONE_ListSkin());
			ttplayer = new kaka_TTPlayer(new kaka_TTPlayerSkin(),new kaka_TTPlayerListSkin());
			ttplayer.play(Math.random() * 8 ^ 0);
			//ttplayer.play();
			ttplayer.autoPlay = true;
			ttplayer.listURL = "http://www.superkaka.org/kaka_LyricShow/list.xml";
			//ttplayer.listURL = "list.xml";
			addChild(ttplayer);
		}
	}
	
}