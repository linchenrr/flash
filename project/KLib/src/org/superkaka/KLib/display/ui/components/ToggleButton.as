package org.superkaka.KLib.display.ui.components 
{
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	import org.superkaka.KLib.display.ui.events.UIComponentEvent;
	/**
	 * 带开和关状态的按钮
	 * @author ｋａｋａ
	 */
	public class ToggleButton extends MovieClipComponent
	{
		
		public var btn_on:Button = new Button();
		public var btn_off:Button = new Button();
		
		/**
		 * 指示按钮是否处于选中状态
		 */
		protected var _selected:Boolean;
		
		/**
		 * 指示按钮是否处启用
		 */
		protected var _enabled:Boolean;
		
		public function ToggleButton():void
		{
			
			
		}
		
		/**
		 * 开始初始化操作
		 */
		override protected function bindComplete():void
		{
			
			super.bindComplete();
			
			//this.buttonMode = true;
			
			var buttonAsset:MovieClip;
			
			movieClip.gotoAndStop("on");
			buttonAsset = movieClip.getChildByName("button") as MovieClip;
			if (null == buttonAsset) buttonAsset = movieClip.getChildAt(0) as MovieClip;
			btn_on.bind(buttonAsset);
			
			movieClip.gotoAndStop("off");
			buttonAsset = movieClip.getChildByName("button") as MovieClip;
			if (null == buttonAsset) buttonAsset = movieClip.getChildAt(0) as MovieClip;
			btn_off.bind(buttonAsset);
			
			this.mouseEnabled = false;
			
			//addChild(btn_on);
			addChild(btn_off);
			
			//this.selected = false;
			
		}
		
		/**
		 * 配置侦听器
		 */
		override protected function active():void
		{
			
			this.addEventListener(MouseEvent.CLICK, clickHandler);
			
		}
		
		/**
		 * 移除侦听器
		 */
		override protected function backStage():void
		{
			
			this.removeEventListener(MouseEvent.CLICK, clickHandler);
			
		}
		
		/**
		 * 设置按钮的选中状态
		 * @param	selected			选中与否
		 * @param	forceUpdate		是否强制更新状态(即使将要设置的状态与当前一致)，如果设置为true，则一定会派发UIComponentEvent.CHANGE事件，否则只会在状态真正改变时派发
		 */
		public function setSelected(selected:Boolean, forceUpdate:Boolean = false):void
		{
			
			if (_selected != selected || forceUpdate)
			{
				_selected = selected;
				
				if (_selected)
				{
					addChild(btn_on);
					if (contains(btn_off))
					removeChild(btn_off);
				}
				else
				{
					addChild(btn_off);
					if (contains(btn_on))
					removeChild(btn_on);
				}
				
				dispatchEvent(new UIComponentEvent(UIComponentEvent.CHANGE, _selected));
				
			}
			
		}
		
		/**
		 * 获取或设置按钮是否处于选中状态
		 * 只有在状态真正改变时才会派发UIComponentEvent.CHANGE事件
		 */
		public function get selected():Boolean 
		{
			return _selected;
		}
		
		public function set selected(value:Boolean):void 
		{
			
			if (value == _selected) return;
			
			setSelected(value);
			
		}
		
		/**
		 * 指示按钮是否处启用
		 */
		public function get enabled():Boolean
		{
			return _enabled;
		}
		
		/**
		 * 指示按钮是否处启用
		 */
		public function set enabled(value:Boolean):void 
		{
			_enabled = value;
			btn_on.enabled = _enabled;
			btn_off.enabled = _enabled;
		}
		
		/**
		 * 组件被点击时触发
		 * @param	evt
		 */
		protected function clickHandler(evt:MouseEvent):void
		{
			
			this.selected = !_selected;
			
		}
		
	}

}