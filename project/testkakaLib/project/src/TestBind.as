package  
{
	import flash.display.Loader;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.system.ApplicationDomain;
	import flash.text.TextField;
	import flash.utils.ByteArray;
	import flash.utils.getDefinitionByName;
	import org.superkaka.kakalib.data.KTable;
	import org.superkaka.kakalib.manager.ClassManager;
	import org.superkaka.kakalib.struct.BitmapFrameInfo;
	
	import org.superkaka.kakalib.core.Engine;
	import org.superkaka.kakalib.data.KDataFormat;
	import org.superkaka.kakalib.data.KDataPackager;
	import org.superkaka.kakalib.data.KTypeArray;
	import org.superkaka.kakalib.data.KTypeData;
	import org.superkaka.kakalib.data.KTypeObject;
	import org.superkaka.kakalib.events.KTaskEvent;
	import org.superkaka.kakalib.i18n.I18NTextManager;
	import org.superkaka.kakalib.i18n.interfaces.I18NLanguagePack;
	import org.superkaka.kakalib.i18n.lang.KDataLanguagePack;
	import org.superkaka.kakalib.i18n.lang.XMLLanguagePack;
	import org.superkaka.kakalib.manager.ClassManager;
	import org.superkaka.kakalib.manager.SystemManager;
	import org.superkaka.kakalib.utils.KCloner;
	import org.superkaka.kakalib.utils.ObjectUtil;
	
	import ui.TestScrollBar;
	import ui.TestUI;

	/**
	 * ...
	 * @author ｋａｋａ
	 */
	[SWF(width="800", height="600")] 
	 
	public class TestBind extends Engine
	{
		
		private var testUI:TestUI = new TestUI();
		private var testScrollBar:TestScrollBar = new TestScrollBar();
		
		public function TestBind() 
		{
			
			//addEventListener(Event.ADDED, addHandler);
			
		}
		
		private function addHandler(evt:Event):void
		{
			trace("addHandleraddHandleraddHandler",evt.target);
		}
		
		/**
		 * 执行主程序的初始化
		 */
		override protected function init():void
		{
			///被子类覆写
			startTest();
		}
		
		private function startTest():void
		{
			
			trace("startTest");
			
			var kd:KDataPackager = new KDataPackager();
			
			kd.writeValue(new KTypeData(KDataFormat.TYPEOBJECT, new KTypeObject(KDataFormat.INT, { a:1, b: -45, ghf:90})));
			kd.position = 0;
			var o:KTypeObject = kd.readValue();
			
			kd.reset();
			kd.writeValue({ a:1, b: -45, ghf:90});
			kd.resetPosition();
			var obj:Object=kd.readValue();
			
			kd.reset();
			kd.writeValue(new KTypeData(KDataFormat.TYPEARRAY,new KTypeArray(KDataFormat.STRING, ["a", "fgdfg34","22",23,445,66,77])));
			kd.position = 0;
			var arr:KTypeArray = kd.readValue();
			
			kd.reset();
			kd.writeValue(["a", "fgdfg34","22",23,445,66,77]);
			kd.resetPosition();
			var array:Array = kd.readValue();
			
			var langPack:I18NLanguagePack;
			langPack = new XMLLanguagePack();
			langPack.langId = "zh_cn";
			langPack.fill(getAsset("zh_cn"));
			I18NTextManager.registerLanguagePack(langPack);
			//
			langPack = new XMLLanguagePack();
			langPack.langId = "zh_cn2";
			langPack.fill(getAsset("zh_cn2"));
			I18NTextManager.registerLanguagePack(langPack);
			
			langPack = new KDataLanguagePack();
			langPack.langId = "中文";
			langPack.fill(getAsset("中文"));
//			langPack.fill((new KDataPackager(getLoadedDataById("中文"))).readTable());
			I18NTextManager.registerLanguagePack(langPack);
			
			I18NTextManager.changeCurrentLanguageId("zh_cn");
			
			//ClassManager.currentDomainId = "q";
			//trace(ClassManager.createInstanceClass("TestUI"));
			
			//trace(ApplicationlicationDomain.currentDomain.getDefinition("TestUI"));
			
			testUI.bind(ClassManager.createInstance("TestUI"));
			testScrollBar.bind(ClassManager.createInstance("TestScrollBar"));
			
			
			addChild(testScrollBar);
			addChild(testUI);
			//SystemManager.autoDisableIME = true;
			
		}
		
	}

}