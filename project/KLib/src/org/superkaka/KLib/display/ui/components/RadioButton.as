package org.superkaka.KLib.display.ui.components 
{
	import flash.events.MouseEvent;
	import org.superkaka.KLib.display.ui.controls.RadioButtonGroupControl;
	import org.superkaka.KLib.display.ui.events.UIComponentEvent;
	/**
	 * 单选按钮
	 * 使用 RadioButton 组件可以强制用户只能从一组选项中选择一项
	 * @author ｋａｋａ
	 */
	public class RadioButton extends ToggleButton
	{
		
		protected var _group:RadioButtonGroupControl;
		
		protected var _groupName:String;
		
		public function RadioButton():void
		{
			
			groupName = RadioButtonGroupControl.defaultGroupName;
			
		}
		
		/**
		 * 组件被点击时触发
		 * @param	evt
		 */
		override protected function clickHandler(evt:MouseEvent):void
		{
			
			this.selected = true;
			
		}
		
		/**
		 * 指示按钮是否处于选中状态
		 */
		override public function set selected(value:Boolean):void 
		{
			
			super.selected = value;
			
			if (_group == null) return;
			
			if (_selected)
			{
				
				_group.selection = this;
				
			}
			else
			if(_group.selection==this)
			{
				
				_group.selection = null;
				
			}
			
		}
		
		/**
		 * 单选按钮实例或组的组名。 您可以使用此属性来获取或设置单选按钮实例或单选按钮组的组名
		 * 默认值为 "defaultRadioButtonGroup"
		 */
		public function get groupName():String 
		{
			return (_group == null) ? null : _group.name;
		}
		
		/**
		 * 单选按钮实例或组的组名。 您可以使用此属性来获取或设置单选按钮实例或单选按钮组的组名
		 * 默认值为 "defaultRadioButtonGroup"
		 */
		public function set groupName(name:String):void 
		{
			
			group = RadioButtonGroupControl.getGroup(name);
			
		}
		
		/**
		 * 此 RadioButton 所属的 RadioButtonGroupControl 对象
		 */
		public function get group():RadioButtonGroupControl 
		{
			return _group;
		}
		
		/**
		 * 此 RadioButton 所属的 RadioButtonGroupControl 对象
		 */
		public function set group(value:RadioButtonGroupControl):void 
		{
			
			if (_group == value) return;
			
			if (_group != null) 
			{
				
				_group.removeRadioButton(this);
				_group.removeEventListener(UIComponentEvent.CHANGE, changeHandler);
				
			}
			
			_group = value;
			
			if (_group != null) 
			{
				
				_group.addRadioButton(this);
				_group.addEventListener(UIComponentEvent.CHANGE, changeHandler);
				
			}
			
		}
		
		protected function changeHandler(evt:UIComponentEvent):void 
		{
			
			super.selected = (_group.selection == this);
			
		}
		
	}

}