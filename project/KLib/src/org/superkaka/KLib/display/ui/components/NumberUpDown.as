package org.superkaka.KLib.display.ui.components 
{
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.text.TextFieldType;
	
	import org.superkaka.KLib.display.ui.events.UIComponentEvent;
	/**
	 * 控制数字增减的组件
	 * @author ｋａｋａ
	 */
	public class NumberUpDown extends MovieClipComponent
	{
		
		protected var _max:Number;
		protected var _min:Number = 0;
		
		protected var _step:Number = 1;
		
		protected var _number:Number = 0;
		
		public var btn_up:Button;
		public var btn_down:Button;
		public var txt_number:TextField;
		
		public function NumberUpDown():void
		{
			
		}
		
		override protected function bindComplete():void
		{
			
			super.bindComplete();
			
			txt_number.restrict = "0-9.";
			txt_number.addEventListener(Event.CHANGE, txt_numberChangeHandler);
			
			changeNum(Number(txt_number.text));
			
		}
		
		override protected function onButtonClick(button:Button):void
		{
			
			switch(button)
			{
				case btn_up:
					changeNum(_number + _step);
					break;
					
				case btn_down:
					changeNum(_number - _step);
					break;
			}
			
		}
		
		protected function changeNum(num:Number):void
		{
			
			btn_up.enabled = true;
			btn_down.enabled = true;
			
			if (!isNaN(_max) && num >= _max)
			{
				num = _max;
				btn_up.enabled = false;
			}
			
			if (!isNaN(_min) && num <= _min)
			{
				num = _min;
				btn_down.enabled = false;
			}
			
			_number = num;
			
			renderNumber();
			
			dispatchEvent(new UIComponentEvent(UIComponentEvent.CHANGE, _number));
			
		}
		
		protected function renderNumber():void
		{
			
			txt_number.text = String(_number);
			
		}
		
		public function set editable(value:Boolean):void
		{
			
			if (value)
			{
				txt_number.type = TextFieldType.INPUT;
				txt_number.selectable = true;
			}
			else
			{
				txt_number.type = TextFieldType.DYNAMIC;
				txt_number.selectable = false;
			}
			//txt_number.type = value ? TextFieldType.INPUT : TextFieldType.DYNAMIC;
			
		}
		
		/**
		 * 获取或设置此组件是否允许用户手动编辑数字
		 */
		public function get editable():Boolean
		{
			
			return txt_number.type == TextFieldType.INPUT;
			
		}
		
		public function get max():Number 
		{
			return _max;
		}
		
		public function set max(value:Number):void 
		{
			_max = value;
			//if (_max < _min)_max = _min;
			if (_max < _min)_min = _max;
			changeNum(_number);
		}
		
		public function get min():Number 
		{
			return _min;
		}
		
		public function set min(value:Number):void 
		{
			_min = value;
			//if (_min > _max)_min = _max;
			if (_min > _max)_max = _min;
			changeNum(_number);
		}
		
		public function get number():Number 
		{
			return _number;
		}
		
		public function set number(value:Number):void 
		{
			changeNum(value);
		}
		
		/**
		 * 获取或设置数字增减的步进
		 * 默认值为1
		 */
		public function get step():Number 
		{
			return _step;
		}
		
		public function set step(value:Number):void 
		{
			_step = value;
		}
		
		private function txt_numberChangeHandler(evt:Event):void
		{
			
			changeNum(Number(txt_number.text));
			
		}
		
	}

}