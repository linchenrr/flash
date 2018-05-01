package org.superkaka.KLib.display.ui.components 
{
	import org.superkaka.KLib.i18n.I18NText;
	import org.superkaka.KLib.i18n.I18NTextFieldDriver;
	import flash.text.StyleSheet;
	import flash.text.TextField;
	import flash.text.TextFormat;
	
	/**
	 * 文本框组件
	 * @author ｋａｋａ
	 */
	public class TextBox extends TextFieldComponent
	{
		
		/**
		 * 默认是否开启国际化行为
		 */
		static public var defaultI18nMode:Boolean = false;
		
		protected var textDriver:I18NTextFieldDriver;
		
		public function TextBox() 
		{
			
		}
		
		/**
		 * 开始初始化操作
		 */
		override protected function bindComplete():void
		{
			
			super.bindComplete();
			
			textDriver = new I18NTextFieldDriver();
			this.i18nMode = defaultI18nMode;
			textDriver.textField = _textField;
			
		}
		
		//=============I18NTextDriver================
		
		public function set i18nMode(value:Boolean):void
		{
			
			textDriver.enabled = value;
			
		}
		
		/**
		 * 获取或设置此文本组件是否开启国际化行为
		 * 默认值为false
		 */
		public function get i18nMode():Boolean
		{
			
			return textDriver.enabled;
			
		}
		
		/**
		 * 获取或设置国际化文字对象
		 */
		public function get i18nText():I18NText 
		{
			return textDriver.i18nText;
		}
		
		public function set i18nText(value:I18NText):void 
		{
			textDriver.i18nText = value;
		}
		
		//=============I18NTextDriver===============end
		
		//=============TextField================
		
		public function get text():String 
		{
			return textField.text;
		}
		
		public function set text(value:String):void 
		{
			textField.text = value;
		}
		
		public function get alwaysShowSelection () : Boolean
		{
			return _textField.alwaysShowSelection;
		}
		
		public function set alwaysShowSelection (value:Boolean) : void
		{
			_textField.alwaysShowSelection=value;
		}
		
		public function get autoSize () : String
		{
			return _textField.autoSize;
		}
		
		public function set autoSize (value:String) : void
		{
			_textField.autoSize=value;
		}
		
		public function get background () : Boolean
		{
			return _textField.background;
		}
		
		public function set background (value:Boolean) : void
		{
			_textField.background=value;
		}
		
		public function get backgroundColor () : uint
		{
			return _textField.backgroundColor;
		}
		
		public function set backgroundColor (value:uint) : void
		{
			_textField.backgroundColor=value;
		}
		
		public function get border () : Boolean
		{
			return _textField.border;
		}
		
		public function set border (value:Boolean) : void
		{
			_textField.border=value;
		}
		
		public function get borderColor () : uint
		{
			return _textField.borderColor;
		}
		
		public function set borderColor (value:uint) : void
		{
			_textField.borderColor=value;
		}
		
		public function get caretIndex () : int
		{
			return _textField.caretIndex;
		}
		
		
		public function get defaultTextFormat () : TextFormat
		{
			return _textField.defaultTextFormat;
		}
		
		public function set defaultTextFormat (format:TextFormat) : void
		{
			_textField.defaultTextFormat=format;
		}
		
		public function get displayAsPassword () : Boolean
		{
			return _textField.displayAsPassword;
		}
		
		public function set displayAsPassword (value:Boolean) : void
		{
			_textField.displayAsPassword=value;
		}
	 
		public function get htmlText () : String
		{
			return _textField.htmlText;
		}
		
		public function set htmlText (value:String) : void
		{
			_textField.htmlText=value;
		}
		
		public function get length () : int
		{
			return _textField.length;
		}
		
		public function get maxChars () : int
		{
			return _textField.maxChars;
		}
		
		public function set maxChars (value:int) : void
		{
			_textField.maxChars = value;
		}
		
		public function get maxScrollH () : int
		{
			return _textField.maxScrollH;
		}
		
		public function get maxScrollV () : int
		{
			return _textField.maxScrollV;
		}
		
		public function get mouseWheelEnabled () : Boolean
		{
			return _textField.mouseWheelEnabled;
		}
		
		public function set mouseWheelEnabled (value:Boolean) : void
		{
			_textField.mouseWheelEnabled=value;
		}
		
		public function get multiline () : Boolean
		{
			return _textField.multiline;
		}
		
		public function set multiline (value:Boolean) : void
		{
			_textField.multiline=value;
		}
		
		
		public function get numLines () : int
		{
			return _textField.numLines;
		}
		
		
		public function get restrict () : String
		{
			return _textField.restrict;
		}
		
		public function set restrict (value:String) : void
		{
			_textField.restrict=value;
		}
		
		
		public function get scrollH () : int
		{
			return _textField.scrollH;
		}
		
		public function set scrollH (value:int) : void
		{
			_textField.scrollH=value;
		}
		
		
		public function get scrollV () : int
		{
			return _textField.scrollV;
		}
		
		public function set scrollV (value:int) : void
		{
			_textField.scrollV=value;
		}
		
		
		public function get selectable () : Boolean
		{
			return _textField.selectable;
		}
		
		public function set selectable (value:Boolean) : void
		{
			_textField.selectable = value;
		}
		
		public function get selectedText () : String
		{
			return _textField.selectedText;
		}
		
		
		public function get selectionBeginIndex () : int
		{
			return _textField.selectionBeginIndex;
		}
		
		
		public function get selectionEndIndex () : int
		{
			return _textField.selectionEndIndex;
		}
		
		public function get styleSheet () : StyleSheet
		{
			return _textField.styleSheet;
		}
		
		public function set styleSheet (value:StyleSheet) : void
		{
			_textField.styleSheet=value;
		}
		
		public function get textColor () : uint
		{
			return _textField.textColor;
		}
		
		public function set textColor (value:uint) : void
		{
			_textField.textColor=value;
		}
		
		public function get textHeight () : Number
		{
			return _textField.textHeight;
		}
		
		public function get textWidth () : Number
		{
			return _textField.textWidth;
		}
		
		public function get type () : String
		{
			return _textField.type;
		}
		
		public function set type (value:String) : void
		{
			_textField.type=value;
		}
		
		public function get useRichTextClipboard () : Boolean
		{
			return _textField.useRichTextClipboard;
		}
		
		
		public function set useRichTextClipboard (value:Boolean) : void
		{
			_textField.useRichTextClipboard=value;
		}
		
		
		public function get wordWrap () : Boolean
		{
			return _textField.wordWrap;
		}
		
		public function set wordWrap (value:Boolean) : void
		{
			_textField.wordWrap=value;
		}
		
		public function appendText (newText:String) : void
		{
			return _textField.appendText(newText);
		}
		
		public function getTextFormat (beginIndex:int = -1, endIndex:int = -1) : TextFormat
		{
			return _textField.getTextFormat(beginIndex,endIndex);
		}
		
		public function replaceSelectedText (value:String) : void
		{
			return _textField.replaceSelectedText(value);
		}
		
		public function replaceText (beginIndex:int, endIndex:int, newText:String) : void
		{
			return _textField.replaceText(beginIndex,endIndex,newText);
		}
		
		public function setSelection (beginIndex:int, endIndex:int) : void
		{
			return _textField.setSelection(beginIndex,endIndex);
		}
		
		public function setTextFormat (format:TextFormat, beginIndex:int = -1, endIndex:int = -1) : void
		{
			return _textField.setTextFormat(format,beginIndex,endIndex);
		}
		
		//=============TextField================end
		
	}

}