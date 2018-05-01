package org.superkaka.KLib.display.ui.components 
{
	import flash.display.FrameLabel;
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	import flash.media.Sound;
	/**
	 * 按钮组件
	 * 为了更加灵活，能够应付各种情况，改回了自己控制按钮跳帧逻辑
	 * @author ｋａｋａ
	 */
	public class Button extends MovieClipComponent
	{
		
		static protected var hash_sound:Object = { };
		
		protected var customSound:Object = { };
		
		static private const State_Up:int = 1;
		static private const State_Over:int = 2;
		static private const State_Down:int = 3;
		static private const State_Disable:int = 4;
		
		private var list_btn:Array;
		
		private var isDown:Boolean;
		private var isRollIn:Boolean;
		private var _enabled:Boolean;
		
		public function Button():void
		{
			
			
		}
		
		/**
		 * 开始初始化操作
		 */
		override protected function bindComplete():void
		{
			
			super.bindComplete();
			
			list_btn = [movieClip];
			
			var i:int = 0;
			var c:int = numChildren;
			while (i < c) 
			{
				
				var mc_btn:MovieClip = movieClip.getChildAt(i) as MovieClip;
				if (mc_btn != null && mc_btn.name.indexOf("btn") == 0)
				list_btn.push(mc_btn);
				
				i++;
			}
			
			this.mouseChildren = false;
			this.buttonMode = true;
			
			this.enabled = true;
			
			this._contentWidth = this.width;
			this._contentHeight = this.height;
			
			this.addEventListener(MouseEvent.ROLL_OVER, playRollOverSound);
			this.addEventListener(MouseEvent.CLICK, playClickSound);
			
			configListeners();
			
		}
		
		private function configListeners():void
		{
			this.addEventListener(MouseEvent.ROLL_OVER, rollOverHandler);
			this.addEventListener(MouseEvent.ROLL_OUT, rollOutHandler);
			this.addEventListener(MouseEvent.MOUSE_DOWN, mouseDownHandler);
		}
		
		private function removeListeners():void
		{
			this.removeEventListener(MouseEvent.ROLL_OVER, rollOverHandler);
			this.removeEventListener(MouseEvent.ROLL_OUT, rollOutHandler);
			this.removeEventListener(MouseEvent.MOUSE_DOWN, mouseDownHandler);
			UIStage.removeEventListener(MouseEvent.MOUSE_UP, mouseUpHandler);
		}
		
		/**
		 * 是否启用
		 */
		public function set enabled(value:Boolean):void
		{
			_enabled = value;
			updateState();
		}
		
		/**
		 * 是否启用
		 */
		public function get enabled():Boolean
		{
			return _enabled;
		}
		
		static public function registerSoundEffect(type:String, sound:Sound):void
		{
			
			hash_sound[type] = sound;
			
		}
		
		public function registerSoundEffect(type:String, sound:Sound):void
		{
			
			customSound[type] = sound;
			
		}
		
		private function playRollOverSound(evt:MouseEvent):void
		{
			
			var sd:Sound = customSound["over"] || hash_sound["over"];
			if (null != sd)
			sd.play();
			
		}
		
		private function playClickSound(evt:MouseEvent):void
		{
			
			var sd:Sound = customSound["click"] || hash_sound["click"];
			if (null != sd)
			sd.play();
			
		}
		
		/**
		 * 获取或设置界面用于排布的参考宽度
		 */
		override public function get contentWidth():Number
		{
			
			///如果没有设置过contentWidth则返回主容器宽度
			if (isNaN(_contentWidth)) return this.width;
			
			return _contentWidth;
			
		}
		
		/**
		 * 获取或设置界面用于排布的参考高度
		 */
		override public function get contentHeight():Number
		{
			
			///如果没有设置过contentHeight则返回主容器宽度
			if (isNaN(_contentHeight)) return this.height;
			
			return _contentHeight;
			
		}
		
		override public function set contentWidth(value:Number):void 
		{
			//super.contentWidth = value;
			//this.width = value;
			//this.scaleX = value / _contentWidth;
			
			super.contentWidth = value;
			
			if (_binded) movieClip.width = value;
			
		}
		
		override public function set contentHeight(value:Number):void 
		{
			//super.contentHeight = value;
			//this.height = value;
			//this.scaleY = value / _contentHeight;
			
			super.contentHeight = value;
			
			if (_binded) movieClip.height = value;
		}
		
		/**
		 * 更新状态
		 */
		private function updateState():void
		{
			
			if (_enabled == false)
			{
				moveMC("disable");
				this.mouseEnabled = false;
				return;
			}
			
			this.mouseEnabled = true;
			
			if (isRollIn)
			{
				if (isDown)
				moveMC("down");
				else
				moveMC("over");
			}
			else
			{
				if (isDown)
				moveMC("over");
				else
				moveMC("up");
			}
			
		}
		
		private function moveMC(label:String):void
		{
			
			for each(var mc_btn:MovieClip in list_btn)
			{
				try
				{
					mc_btn.gotoAndStop(label);
				}
				catch (err:Error)
				{
					
				}
			}
			
		}
		
		private function rollOverHandler(evt:MouseEvent):void
		{
			isRollIn = true;
			updateState();
		}
		
		private function rollOutHandler(evt:MouseEvent):void
		{
			isRollIn = false;
			updateState();
		}
		
		private function mouseDownHandler(evt:MouseEvent):void
		{
			UIStage.addEventListener(MouseEvent.MOUSE_UP, mouseUpHandler);
			isDown = true;
			updateState();
		}
		
		private function mouseUpHandler(evt:MouseEvent):void
		{
			UIStage.removeEventListener(MouseEvent.MOUSE_UP, mouseUpHandler);
			isDown = false;
			updateState();
		}
		
		public function dispose():void
		{
			
			removeListeners();
			
		}
		
	}

}