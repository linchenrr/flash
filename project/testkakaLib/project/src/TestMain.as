package  
{
	import com.demonsters.debugger.MonsterDebugger;
	import flash.events.Event;
	import org.superkaka.kakalib.core.Application;
	import org.superkaka.kakalib.core.Engine;
	import org.superkaka.kakalib.manager.ClassManager;
	import org.superkaka.kakalib.manager.DragManager;
	import org.superkaka.kakalib.manager.SoundManager;
	import ui.TestUI2;
	/**
	 * ...
	 * @author ｋａｋａ
	 */
	public class TestMain extends Engine
	{
		
		public var testUI:TestUI2 = new TestUI2();
		
		public function TestMain():void
		{
			MonsterDebugger.initialize(this);
			MonsterDebugger.logger = trace;
			//MonsterDebugger.clear();
            MonsterDebugger.trace(this, "MonsterDebugger Hello World!", "kaka");
			
		}
		
		override protected function updateLoadingProgress(bytesLoaded:uint, bytesTotal:uint, customData:Object = null):void
		{
			
			var list_loading:Array = multiLoader.processId;
			
			var msg:String = "正在下载:\r";
			
			var i:int = 0;
			var c:int = list_loading.length;
			
			while (i < c) 
			{
				
				msg += list_loading[i];
				msg += "\r";
				
				i++;
				
			}
			
			super.updateLoadingProgress(bytesLoaded, bytesTotal, msg);
			
		}
		
		override protected function init():void
		{
			
			SoundManager.playSound("my soul");
			
			testUI.bind(ClassManager.createInstance("TestUI2"));
			addChild(testUI);
			
			testUI.txt_name.text = String("ver:" + buildVersion) + "  gameName:" + String(Application.parameters["gameName"]);
			//throw new Error("ver:" + buildVersion);
			//MonsterDebugger.breakpoint(this, "kaka");
			//MonsterDebugger.log("aa","bb",435,new Event(Event.COMPLETE),testUI);
			//MonsterDebugger.snapshot(testUI, testUI, "kaka", "ll");
			
			DragManager.startDrag(testUI,true);
			
		}
		
	}

}