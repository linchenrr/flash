package org.superkaka.KLib.utils 
{
	import flash.events.Event;
	import flash.events.IEventDispatcher;
	import flash.utils.Dictionary;
	/**
	 * 事件桥接，将输入对象、事件类型和输出对象、事件类型关联，输入对象触发该事件时输出对象自动触发相应的事件
	 * @author ｋａｋａ
	 */
	public class EventBridge 
	{
		
		static private var dic_info:Dictionary = new Dictionary();
		
		static public function registerEvent(input:IEventDispatcher, inputType:String, outPut:IEventDispatcher, outputType:String = null):void
		{
			
			if (null == outputType)
			outputType = inputType;
			
			var info:EventBridgeInfo = new EventBridgeInfo();
			info.input = input;
			info.inputType = inputType;
			info.outPut = outPut;
			info.outputType = outputType;
			
			dic_info[input] = info;
			
			input.addEventListener(inputType, eventInputHandler);
			
		}
		
		static private function eventInputHandler(evt:Event):void
		{
			
			var info:EventBridgeInfo = dic_info[evt.currentTarget];
			
			info.outPut.dispatchEvent(new Event(info.outputType));
			
		}
		
	}

}
import flash.events.IEventDispatcher;
class EventBridgeInfo
{
	
	public var input:IEventDispatcher;
	public var outPut:IEventDispatcher;
	public var inputType:String;
	public var outputType:String;
	
}