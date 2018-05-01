package
{
	import org.superkaka.kakalib.control.KeyCode;
	import org.superkaka.kakalib.control.KeyControl;
	import org.superkaka.kakalib.core.Engine;
	import org.superkaka.kakalib.i18n.lang.*;
	import org.superkaka.kakalib.manager.AssetManager;
	import org.superkaka.kakalib.manager.SoundManager;
	import org.superkaka.kakalib.media.KSound;
	

	[SWF(width=800, height=600, frameRate=30)]
	public class testSD extends Engine
	{
		private var sound:KSound;
		
		public function testSD():void
		{
			
		}
		
		override protected function init():void
		{
			
			KeyControl.registerKeyPressFunction(keyDownFun, KeyCode.SHIFT, KeyCode.G);
			KeyControl.registerKeyReleaseFunction(keyUpFun, KeyCode.SHIFT, KeyCode.G);
			
			sound = new KSound(AssetManager.getAsset("my soul"));
			
			
			
			//SoundManager.registerSound(sound, "忧伤还是快乐");
			//SoundManager.registerSound(AssetManager.getAsset("msg"), "msg");
			//SoundManager.playSound("my soul",226000,2);
			SoundManager.playSound("my soul",226000,2);
			
		}
		
		private function keyDownFun():void
		{
			
			trace("keyDownFun");
			SoundManager.volume = .5;
			SoundManager.pauseAllSound();
		}
		
		private function keyUpFun():void
		{
			
			trace("keyUpFun");
			SoundManager.volume = 1;
			SoundManager.resumeAllSound();
		}
		
		
	}
}