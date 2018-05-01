package org.superkaka.KLib.display.ui.components 
{
	import flash.display.MovieClip;
	import flash.utils.getTimer;
	import org.superkaka.KLib.display.ui.controls.RadioButtonGroupControl;
	import org.superkaka.KLib.display.ui.events.UIComponentEvent;
	/**
	 * 单选按钮组
	 * 使用 RadioButtonGroup 组件可以强制用户只能从一组选项中选择一项
	 * @author ｋａｋａ
	 */
	public class RadioButtonGroup extends MovieClipComponent
	{
		
		static private var instanceCount:uint = 0;
		
		private var _groupName:String;
		
		private var list_radioButton:Array = [];
		
		public function RadioButtonGroup():void
		{
			
			
		}
		
		/**
		 * 开始初始化操作
		 */
		override protected function bindComplete():void
		{
			
			super.bindComplete();
			
			var i:int = 0;
			var c:int = movieClip.numChildren;
			
			while (i < c) 
			{
				
				var child:MovieClip = movieClip.getChildAt(i) as MovieClip;
				if (child != null)
				{
					
					var radioButton:RadioButton = new RadioButton();
					
					radioButton.bind(child);
					movieClip.addChildAt(radioButton, i);
					
					list_radioButton.push(radioButton);
					
				}
				
				i++;
				
			}
			
			this.groupName = "RadioButtonGroup_" + (instanceCount++) + "_" + getTimer();
			
			//selection = list_radioButton[0];
			selection = null;
			
		}
		
		/**
		 * 获取指定名称的子选项按钮
		 * @param	name
		 * @return
		 */
		public function getRadioButtonByName(name:String):RadioButton
		{
			
			for each(var radioButton:RadioButton in list_radioButton)
			{
				if (radioButton.name == name)
				{
					return radioButton;
				}
			}
			
			return null;
			
		}
		
		/**
		 * 获取或设置当前单选按钮组选中的单选按钮
		 */
		public function get selection():RadioButton 
		{
			return RadioButtonGroupControl.getGroup(_groupName).selection;
		}
		
		public function set selection(value:RadioButton):void
		{
			
			RadioButtonGroupControl.getGroup(_groupName).selection = value;
			
		}
		
		public function set selectedName(value:String):void
		{
			
			for each(var btn:RadioButton in list_radioButton)
			{
				if (btn.name == value)
				{
					selection = btn;
					return;
				}
			}
			selection = null;
		}
		
		/**
		 * 获取或设置当前单选按钮组选中的单选按钮的名称
		 */
		public function get selectedName():String
		{
			
			var selection:RadioButton = this.selection;
			if (null == selection)
			{
				return null;
			}
			
			return selection.name;
			
		}
		
		public function get groupName():String 
		{
			return _groupName;
		}
		
		public function set groupName(value:String):void 
		{
			
			RadioButtonGroupControl.getGroup(_groupName).removeEventListener(UIComponentEvent.CHANGE, selectChangeHandler);
			
			if (value == _groupName) return;
			
			_groupName = value;
			
			for each(var radioButton:RadioButton in list_radioButton)
			{
				
				radioButton.groupName = _groupName;
				
			}
			
			RadioButtonGroupControl.getGroup(_groupName).addEventListener(UIComponentEvent.CHANGE, selectChangeHandler);
			
		}
		
		private function selectChangeHandler(evt:UIComponentEvent):void
		{
			
			dispatchEvent(evt);
			
		}
		
	}

}