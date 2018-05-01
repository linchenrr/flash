package
{
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.filters.BlurFilter;
	import flash.media.SoundTransform;
	import flash.utils.ByteArray;
	
	import org.superkaka.kakalib.core.Engine;
	import org.superkaka.kakalib.events.GlobalEventDispatcher;
	import org.superkaka.kakalib.data.KDataPackager;
	import org.superkaka.kakalib.data.KTable;
	import org.superkaka.kakalib.debug.Fps;
	import org.superkaka.kakalib.i18n.interfaces.I18NLanguagePack;
	import org.superkaka.kakalib.i18n.lang.XMLLanguagePack;
	import org.superkaka.kakalib.manager.DragManager;
	import org.superkaka.kakalib.manager.EnterFrameManager;
	import org.superkaka.kakalib.manager.GameLockManager;
	import org.superkaka.kakalib.manager.PopUpManager;
	import org.superkaka.kakalib.manager.SceneManager;
	import org.superkaka.kakalib.struct.ResourceInfo;
	import org.superkaka.kakalib.utils.KCloner;
	import org.superkaka.kakalib.utils.DisplayObjectTool;
	
	public class testkakaLib extends Engine
	{
		public function testkakaLib()
		{
			
			var date:Date = new Date();
			trace(date,Number.MAX_VALUE);
			
			var packager:KDataPackager = new KDataPackager();
			packager.writeValue(date);
			
			packager.resetPosition();
			var date2:Date = packager.readValue();
			
		}
		
		override protected function init():void
		{
			
			Fps.setup(this);
			
			PopUpManager
			//GameLockManager.lockMouse();
			EnterFrameManager
			SceneManager
			//DragManager.startDrag(this)
			GlobalEventDispatcher.addEventListener("ssqq", ssqq);
			GlobalEventDispatcher.dispatchEvent(new Event("ssqq"))
			
			
			var lp:I18NLanguagePack = new XMLLanguagePack();
			lp.fill(XML(getAsset("zh_cn")),getAsset("zh_cn2"));
			
			trace(lp.getText("qqsd"));
			
			var kd:KDataPackager = new KDataPackager(getAsset("SkillEffect"));
			var table:KTable = kd.readTable();
			
			var kd2:KDataPackager = new KDataPackager(getAsset("SkillDict"));
			var table2:KTable = kd2.readTable();
			
			trace(table.getValue("1"));
			
			
			var resInfo:ResourceInfo = new ResourceInfo("resInfo", "ss.kk", "bin", "haha");
			
			var resInfo2:ResourceInfo = KCloner.deepClone(resInfo);
			
			resInfo2.id = "resInfo2";
			resInfo2.customData = "qq";
			
			var resInfo3:ResourceInfo = KCloner.deepClone(resInfo2);
			resInfo3.id = "resInfo3";
			
			var sp:Sprite = new Sprite();
			sp.addChild(getAsset("pic"));
			addChild(sp);
			
			sp.addEventListener(MouseEvent.MOUSE_DOWN, sd);
			
		}
		
		private function sd(evt:MouseEvent):void
		{
			
			DragManager.startDrag(evt.target as Sprite,false,true);
			
		}
		
		override protected function registerResLoadCallBack():void
		{
			
			addResourceLoadCallBack("testTXT", testTXTHandler);
			
		}
		
		private function testTXTHandler(data:String):void
		{
			
			trace(data);
			
		}
		
		private function ssqq(evt:Event):void
		{
			
			trace("ssssssaaaa");
			
		}
		
	}
}