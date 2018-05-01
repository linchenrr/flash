package
{
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import luaAlchemy.LuaAlchemy;
	import org.superkaka.kakalib.core.Engine;
	public class TestLua extends Engine
	{
		
		private var luaAc:LuaAlchemy = new LuaAlchemy();
		public var txt:TextField = new TextField();
		
		public function TestLua():void
		{
			
			
		}
		
		override protected function init():void
		{
			
			var luaScript:String = getAsset("lua");
			
			txt.multiline = true;
			txt.autoSize = TextFieldAutoSize.LEFT;
			txt.width = 300;
			txt.border = true;
			addChild(txt);
			
			luaAc.setGlobalLuaValue("this", this);
			luaAc.setGlobalLuaValue("x", txt.x);
			luaAc.doString(luaScript);
			
		}
		
		public function log(str:String):void
		{
			trace(str);
		}
		
	}
}