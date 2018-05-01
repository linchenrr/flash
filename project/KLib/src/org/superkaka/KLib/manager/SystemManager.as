package org.superkaka.KLib.manager 
{
	import flash.display.DisplayObject;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.events.FocusEvent;
	import flash.events.MouseEvent;
	import flash.system.IME;
	import flash.system.System;
	import flash.text.TextField;
	import flash.text.TextFieldType;
	import org.superkaka.KLib.events.GlobalEventDispatcher;
	/**
	 * 程序系统控制操作封装管理
	 * @author ｋａｋａ
	 */
	public class SystemManager
	{
		
		static private var _autoDisableIME:Boolean;
		
		static private var stage:Stage;
		
		/**
		 * 初始化
		 */
		static public function init(stg:Stage):void
		{
			stage = stg;
			autoDisableIME = true;
			
			stage.addEventListener(FocusEvent.FOCUS_IN, stageFocusInHandler);
			System.ime.addEventListener(Event.DEACTIVATE, deActiveHandler);
			System.ime.addEventListener(Event.ACTIVATE, activeHandler);
			
		}
		
		/**
		 * 获取或设置是否根据当前焦点是否为可输入文字对象自动启用或禁用输入法
		 */
		static public function get autoDisableIME():Boolean 
		{
			return _autoDisableIME;
		}
		
		/**
		 * 获取或设置是否根据当前焦点是否为可输入文字对象自动启用或禁用输入法
		 */
		static public function set autoDisableIME(value:Boolean):void 
		{
			
			_autoDisableIME = value;
			
			if (_autoDisableIME)
			{
				stage.addEventListener(FocusEvent.FOCUS_IN, checkIME);
				stage.addEventListener(MouseEvent.MOUSE_DOWN, checkIME);
			}
			else
			{
				stage.removeEventListener(FocusEvent.FOCUS_IN, checkIME);
				stage.removeEventListener(MouseEvent.MOUSE_DOWN, checkIME);
			}
			
		}
		
		static private function checkIME(evt:Event):void
		{
			
			var tf:TextField = evt.target as TextField;
			IME.enabled = (null != tf && tf.type == TextFieldType.INPUT);
			
		}
		
		static private var focusTarget:DisplayObject;
		static private function stageFocusInHandler(evt:FocusEvent):void
		{
			
			if (null != focusTarget)
			focusTarget.removeEventListener(Event.REMOVED_FROM_STAGE, focusTargetRemovedHandler);
			
			focusTarget = evt.target as DisplayObject;
			focusTarget.addEventListener(Event.REMOVED_FROM_STAGE, focusTargetRemovedHandler);
			
		}
		
		static private function focusTargetRemovedHandler(evt:Event):void
		{
			
			focusTarget.removeEventListener(Event.REMOVED_FROM_STAGE, focusTargetRemovedHandler);
			stage.addEventListener(Event.EXIT_FRAME, checkFocus);
			
		}
		
		static private function checkFocus(evt:Event):void
		{
			
			stage.removeEventListener(Event.EXIT_FRAME, checkFocus);
			
			if (focusTarget.stage == null)
			{
				focusTarget = null;
				stage.focus = stage;
			}
			
		}
		
		//===========flash整体失去焦点相关==============
		static private function activeHandler(evt:Event):void
		{
			
			GlobalEventDispatcher.dispatchEvent(new Event(Event.ACTIVATE));
			
		}
		
		static private function deActiveHandler(evt:Event):void
		{
			
			GlobalEventDispatcher.dispatchEvent(new Event(Event.DEACTIVATE));
			
		}
		
	}

}