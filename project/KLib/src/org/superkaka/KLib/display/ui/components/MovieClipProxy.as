package org.superkaka.KLib.display.ui.components 
{
	import flash.display.Scene;
	/**
	 * MovieClip代理组件
	 * @author ｋａｋａ
	 */
	public class MovieClipProxy extends MovieClipComponent
	{
		
		public function MovieClipProxy():void
		{
			
		}
		
		//=============MovieClip================
		
		public function get currentFrame () : int
		{
			
			return movieClip.currentFrame;
			
		}
		
		public function get currentFrameLabel () : String
		{
			
			return movieClip.currentFrameLabel;
			
		}


		public function get currentLabel () : String
		{
			
			return movieClip.currentLabel;
			
		}


		public function get currentLabels () : Array
		{
			
			return movieClip.currentLabels;
			
		}


		public function get currentScene () : Scene
		{
			
			return movieClip.currentScene;
			
		}


		public function get enabled () : Boolean
		{
			
			return movieClip.enabled;
			
		}

		public function set enabled (value:Boolean) : void
		{
			
			movieClip.enabled=value;
			
		}


		public function get framesLoaded () : int
		{
			
			return movieClip.framesLoaded;
			
		}

		public function get scenes () : Array
		{
			
			return movieClip.scenes;
			
		}

		public function get totalFrames () : int
		{
			
			return movieClip.totalFrames;
			
		}

		public function get trackAsMenu () : Boolean
		{
			
			return movieClip.trackAsMenu;
			
		}
		
		public function set trackAsMenu (value:Boolean) : void
		{
			
			movieClip.trackAsMenu=value;
			
		}

		public function addFrameScript (...rest) : void
		{
			
			movieClip.addFrameScript.apply(null, rest);
			
		}

		public function gotoAndPlay (frame:Object, scene:String = null) : void
		{
			
			return movieClip.gotoAndPlay(frame,scene);
			
		}

		public function gotoAndStop (frame:Object, scene:String = null) : void
		{
			
			return movieClip.gotoAndStop(frame,scene);
			
		}


		public function nextFrame () : void
		{
			
			return movieClip.nextFrame();
			
		}

		public function nextScene () : void
		{
			
			return movieClip.nextScene();
			
		}

		public function play () : void
		{
			
			return movieClip.play();
			
		}

		public function prevFrame () : void
		{
			
			return movieClip.prevFrame();
			
		}

		public function prevScene () : void
		{
			
			return movieClip.prevScene();
			
		}

		public function stop () : void
		{
			
			return movieClip.stop();
			
		}
		
		//=============MovieClip================end
		
	}

}