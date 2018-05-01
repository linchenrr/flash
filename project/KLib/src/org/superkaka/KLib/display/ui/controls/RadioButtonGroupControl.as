package org.superkaka.KLib.display.ui.controls 
{	
	import flash.events.EventDispatcher;
	import org.superkaka.KLib.display.ui.components.RadioButton;
	import org.superkaka.KLib.display.ui.events.UIComponentEvent;
	/**
	 * RadioButtonGroupControl 类将一组 RadioButton 组件定义为单个组件。 选中一个单选按钮后，不能再选中同一组中的其它单选按钮。 
	 * @author ｋａｋａ
	 */
	public class RadioButtonGroupControl extends EventDispatcher 
	{
		
		/**
		 * 默认组名
		 */
		static public var defaultGroupName:String = "defaultRadioButtonGroup";
		
		static private const groups:Object = { };
		
		static private var groupCount:uint = 0;
		
		protected var _name:String;
		
		protected var radioButtons:Array = [];
		
		protected var _selection:RadioButton;
		
		/**
		 * 创建一个新的 RadioButtonGroupControl 实例。 在实例化单选按钮时，会自动执行此操作，无法手动创建实例
		 * @param	hiddenCls
		 * @param	name
		 */
		public function RadioButtonGroupControl(name:String, hiddenCls:HiddenCls):void
		{
			
			_name = name;
			
		}
		
		/**
		 * 检索对指定单选按钮组的引用
		 * @param	name			要检索对其引用的组的名称
		 * @return
		 */
		static public function getGroup(name:String):RadioButtonGroupControl 
		{
			
			var group:RadioButtonGroupControl = groups[name] as RadioButtonGroupControl;
			
			if (group == null) 
			{
				
				group = new RadioButtonGroupControl(name, new HiddenCls());
				groups[name] = group;
				
			}
			
			return group;
			
		}
		
		/**
		 * 获取单选按钮组的实例名称
		 */
		public function get name():String 
		{
			
			return _name;
			
		}
		
		/**
		 * 向内部单选按钮数组添加一个单选按钮，以用于单选按钮组索引，这样可允许在单选按钮组中单独选择一个单选按钮
		 * 此方法由单选按钮自动应用，但是也可以手动使用此方法将单选按钮显式添加到组中
		 * @param	radioButton			要添加到当前单选按钮组的 RadioButton 实例
		 */
		public function addRadioButton(radioButton:RadioButton):void 
		{
			if (radioButton.groupName != name) 
			{
				
				radioButton.groupName = name;
				
				return;
				
			}
			
			radioButtons.push(radioButton);
			
			if (radioButton.selected) 
			{ 
				
				selection = radioButton; 
				
			}
			
		}
		
		/**
		 * 从内部单选按钮列表中清除 RadioButton 实例
		 * @param	radioButton			要删除的 RadioButton 实例
		 */
		public function removeRadioButton(radioButton:RadioButton):void 
		{
			var i:int = getRadioButtonIndex(radioButton);
			
			if (i != -1)
			{
				radioButtons.splice(i, 1);
			}
			
			if (_selection == radioButton)
			{ 
				_selection = null;
			}
			
			if (radioButtons.length == 0)
			{
				
				groups[_name] = null;
				delete groups[_name];
				
			}
			
		}
		
		/**
		 * 从内部单选按钮列表中清除所有 RadioButton 实例
		 */
		public function removeAllRadioButton():void
		{
			
			for each(var radioButton:RadioButton in radioButtons)
			{
				
				radioButton.group = null;
				
			}
			
			radioButtons.splice(0);
			
		}
		
		/**
		 * 获取或设置对当前从单选按钮组中选择的单选按钮的引用
		 */
		public function get selection():RadioButton 
		{
			return _selection;
		}
		
		public function set selection(value:RadioButton):void
		{
			
			if (value == null)
			{
				
				changeSelection(null);
				return;
				
			}
			else
			if (_selection == value || getRadioButtonIndex(value) == -1) return;
			
			changeSelection(value);
			
		}
		
		private function changeSelection(value:RadioButton):void
		{
			
			_selection = value;
			
			dispatchEvent(new UIComponentEvent(UIComponentEvent.CHANGE, _selection));
			
		}
		
		/**
		 * 获取所选单选按钮的自定义数据。如果当前未选中任何单选按钮，则此属性为 null
		 */
		public function get selectedData():Object 
		{
			
			var s:RadioButton = _selection;
			
			return (s == null) ? null : s.customData;
			
		}
		
		/**
		 * 返回指定 RadioButton 实例的索引
		 * @param	radioButton			要在当前 RadioButtonGroupControl 中查找的 RadioButton 实例
		 * @return
		 */
		public function getRadioButtonIndex(radioButton:RadioButton):int 
		{
			
			for (var i:int = 0; i < radioButtons.length; i++) 
			{
				
				var rb:RadioButton = radioButtons[i] as RadioButton;
				
				if (rb == radioButton) return i;
				
			}
			
			return -1;
			
		}
		
		/**
		 * 检索指定索引位置的 RadioButton 组件
		 * @param	index			RadioButtonGroupControl 组件中的 RadioButton 组件的索引，其中第一个组件的索引为 0
		 * @return
		 */
		public function getRadioButtonAt(index:int):RadioButton 
		{
			
			return RadioButton(radioButtons[index]);
			
		}
		
		/**
		 * 获取此单选按钮组中的单选按钮数
		 */
		public function get numRadioButtons():int 
		{
			
			return radioButtons.length;
			
		}
		
	}
}
class HiddenCls { };