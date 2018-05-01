package ui 
{
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.TextEvent;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFieldType;
	import flash.text.TextFormat;
	
	import org.superkaka.kakalib.i18n.I18NText;
	import org.superkaka.kakalib.i18n.I18NTextManager;
	import org.superkaka.kakalib.struct.ParamText;
	import org.superkaka.kakalib.view.ui.BasePanel;
	import org.superkaka.kakalib.view.ui.components.Button;
	import org.superkaka.kakalib.view.ui.components.MovieClipComponent;
	import org.superkaka.kakalib.view.ui.components.RadioButton;
	import org.superkaka.kakalib.view.ui.components.RadioButtonGroup;
	import org.superkaka.kakalib.view.ui.components.TextBox;
	import org.superkaka.kakalib.view.ui.components.TextFieldComponent;
	import org.superkaka.kakalib.view.ui.components.ToggleButton;
	import org.superkaka.kakalib.view.ui.controls.RadioButtonGroupControl;
	import org.superkaka.kakalib.view.ui.events.UIComponentEvent;

	/**
	 * ...
	 * @author ｋａｋａ
	 */
	public class TestUI extends BasePanel
	{
		
		private var _mc:MovieClipComponent = new MovieClipComponent();
		
		private var _realMC:MovieClip;
		
		public var testUI2:TestUI2;
		
		public var txt_title:TextBox;
		
		public var realTextField:TextField;
		
		public var btn:Button;
		
		public var toggleBtn:ToggleButton;
		public var radioBtn1:RadioButton;
		public var radioBtn2:RadioButton;
		public var radioBtn3:RadioButton;
		public var radioBtn4:RadioButton;
		
		public var rdBtnGroup:RadioButtonGroup;
		
		public function TestUI():void
		{
			
		}
		
		/**
		 * 绑定完成，资源已经可以访问
		 */
		override protected function bindComplete():void
		{
			
			super.bindComplete();
			
			toggleBtn.selected = true;
			//_panelMC.removeChild(toggleBtn);
			toggleBtn.addEventListener(MouseEvent.CLICK, toggleBtnClickHandler);
			btn.addEventListener(MouseEvent.CLICK, btnClickHandler);
			
			radioBtn1.addEventListener(UIComponentEvent.CHANGE, radioBtn1ChangeHandler);
			radioBtn2.addEventListener(UIComponentEvent.CHANGE, radioBtn1ChangeHandler);
			radioBtn3.addEventListener(UIComponentEvent.CHANGE, radioBtn1ChangeHandler);
			radioBtn4.addEventListener(UIComponentEvent.CHANGE, radioBtn1ChangeHandler);
			
			RadioButtonGroupControl.getGroup(RadioButtonGroupControl.defaultGroupName).addEventListener(UIComponentEvent.CHANGE, RadioButtonGroupControlChangeHandler);
			
			radioBtn4.groupName=""
			radioBtn4.selected = true;
			radioBtn4.customData = "hahaha";
			radioBtn4.groupName = RadioButtonGroupControl.defaultGroupName
			
			radioBtn2.selected = false;
			//radioBtn4.selected = false;
			
			//radioBtn1.groupName = "";
			//radioBtn3.groupName = "";
			//radioBtn1.selected = true;
			//radioBtn1.enabled = false;
			//radioBtn4.group.removeAllRadioButton();
			
			rdBtnGroup.addEventListener(UIComponentEvent.CHANGE, rdBtnGroupChangeHandler);
			
			txt_title.defaultTextFormat = new TextFormat("Tahoma", 12, 0x6699ff, false);
			
			txt_title.text = "yy萨达sdfasfsdfsd324523GSAD撒打算";
			trace(txt_title.defaultTextFormat.color);
			txt_title.textColor = 0xff0000;
			trace(txt_title.defaultTextFormat.color);
			txt_title.border = true;
			txt_title.borderColor = 0x6699ff;
			txt_title.background = true;
			txt_title.backgroundColor=0x000000
			
			//txt_title.textId = "UI_loginDays";
			//txt_title.setTextIdParam("txt_days", "IT_F1_100010022");
			//txt_title.setParam("txt_days", "15");
			txt_title.addEventListener(MouseEvent.CLICK, txt_titleHandler);
			txt_title.addEventListener(Event.CHANGE, txt_titleHandler);
			txt_title.addEventListener(Event.SCROLL, txt_titleHandler);
			txt_title.addEventListener(TextEvent.TEXT_INPUT, txt_titleHandler);
			txt_title.addEventListener(TextEvent.LINK, txt_titleHandler);
			
			txt_title.type = TextFieldType.INPUT;
			txt_title.multiline = true;
			
			var text:I18NText = new I18NText();
			text.textId = "UI_Gift_send";
			
			var paramText:ParamText = new ParamText("abc<%value%>def", { value:"345" } );
			
			text.param = { 
				itemName:new I18NText
				("IT_F1_100010002", 
					{ 
						pp:"p~p参数" 
					},
					"zh_cn2" ),
				
				testParam2:paramText };
			
			//text.customLangId = "zh_cn2";
			
			//txt_title.i18nText = text;
			txt_title.autoSize = TextFieldAutoSize.LEFT;
			
			I18NTextManager.changeCurrentLanguageId("zh_cn2");
			
			//txt_title.i18nText = text;
			
		}
		
		private function txt_titleHandler(evt:Event):void
		{
			
			trace("txt_titleHandler",evt.type);
			
		}
		
		private function radioBtn1ChangeHandler(evt:UIComponentEvent):void
		{
			
			//trace("radioBtn1ChangeHandler",evt.currentTarget, evt.data);
			
		}
		
		private function RadioButtonGroupControlChangeHandler(evt:UIComponentEvent):void
		{
			
			var group:RadioButtonGroupControl = evt.currentTarget as RadioButtonGroupControl;
			
			trace("RadioButtonGroupControlChangeHandler", group.selection, group.selection.name,group.selectedData);
			
		}
		
		private function rdBtnGroupChangeHandler(evt:UIComponentEvent):void
		{
			
			trace("rdBtnGroupChangeHandler", rdBtnGroup.groupName,evt.target, evt.data);
			
			rdBtnGroup.groupName = String(Math.random());
			
		}
		
		private function toggleBtnClickHandler(evt:Event):void
		{
			
			btn.enabled = toggleBtn.selected;
			
		}
		
		private function btnClickHandler(evt:Event):void
		{
			
			trace("btnClickHandler" + Math.random());
			
		}
		
		public function get realMC():MovieClip 
		{
			return _realMC;
		}
		
		public function set realMC(value:MovieClip):void 
		{
			_realMC = value;
		}
		
		public function get mc():MovieClipComponent 
		{
			return _mc;
		}
		
		public function set mc(value:MovieClipComponent):void 
		{
			_mc = value;
		}
		
	}

}