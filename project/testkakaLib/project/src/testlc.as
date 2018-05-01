package
{
	import flash.display.Sprite;
	import flash.external.ExternalInterface;
	import flash.net.SharedObject;
	import org.superkaka.kakalib.core.Engine;
	import org.superkaka.kakalib.i18n.I18NTextManager;
	import org.superkaka.kakalib.i18n.interfaces.I18NLanguagePack;
	import org.superkaka.kakalib.i18n.lang.*;
	import org.superkaka.kakalib.manager.AssetManager;
	import org.superkaka.kakalib.manager.ContainerManager;
	import org.superkaka.kakalib.manager.SceneManager;
	import org.superkaka.kakalib.manager.SoundManager;
	import org.superkaka.kakalib.media.KSound;
	import org.superkaka.kakalib.utils.gc;
	import ui.scene.DefaultScene;
	import ui.scene.GameScene;
	
	import org.superkaka.kakalib.control.KeyControl;
	import org.superkaka.kakalib.control.KeyCode;

	[SWF(width=800, height=600, frameRate=30)]
	public class testlc extends Engine
	{
		DefaultScene
		GameScene
		private var sound:KSound;
		
		public function testlc():void
		{
			
		}
		
		override protected function init():void
		{
			
			KeyControl.registerKeyPressFunction(keyDownFun, KeyCode.SHIFT, KeyCode.G);
			KeyControl.registerKeyReleaseFunction(keyUpFun, KeyCode.SHIFT, KeyCode.G);
			
			sound = new KSound(AssetManager.getAsset("my soul"));
			
			
			var so:SharedObject = SharedObject.getLocal("test");
			so.data.str="kaka";
			so.data.ba = getAsset("zh_cn2");
			//delete so.data.a;
			//delete so.data.sp;
			//so.data.sd = sound.sound;
			
			so.flush(10000);
			
			//SoundManager.registerSound(sound, "忧伤还是快乐");
			//SoundManager.registerSound(AssetManager.getAsset("msg"), "msg");
			//SoundManager.playSound("my soul",226000,2);
			gc();
			
			
			
			
			
			
			
			
			
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
			
			addChild(ContainerManager.createContainer("sceneContainer"));
			SceneManager.registerSceneContainer(ContainerManager.getContainer("sceneContainer"));
			SceneManager.gotoScene("game");
			
			
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