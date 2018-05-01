package org.superkaka.KLib.utils 
{
	import flash.events.TimerEvent;
	import flash.utils.Dictionary;
	import flash.utils.getTimer;
	import flash.utils.Timer;
	/**
	 * 基于轮询机制的数据绑定，Model-View事件机制的替代品
	 * 由于轮询机制会消耗额外的性能，因此建议只在需要快速开发的小项目中使用
	 * @author ｋａｋａ
	 */
	public class PollDataBind
	{
		
		static private var timer:Timer;
		
		
		///轮询间隔  以秒为单位
		static private var _pollInterval:Number = 1;
		
		static private var dic_bindRecord:Dictionary;
		
		init();
		static private function init():void
		{
			
			dic_bindRecord = new Dictionary();
			
			timer = new Timer(1000 * _pollInterval);
			timer.addEventListener(TimerEvent.TIMER, doPoll);
			timer.start();
			
		}
		
		/**
		 * 将目标属性的值绑定到指定数据源对象的属性
		 * @param	target								绑定的目标
		 * @param	targetPropertyName				绑定目标的属性
		 * @param	source								绑定到的数据源对象
		 * @param	sourcePropertyName				数据源对象的属性
		 */
		static public function bind(target:*, targetPropertyName:String, source:*, sourcePropertyName:String):void
		{
			
			var recordObj:Object = getRecordObj(target);
			
			recordObj[targetPropertyName] = new BindRecord(target, targetPropertyName, source, sourcePropertyName);
			
		}
		
		/**
		 * 移除对目标对象相关属性的绑定
		 * @param	target								绑定的目标
		 * @param	targetPropertyName				绑定目标的属性，如果省略此参数，则解除目标所添加的所有绑定
		 */
		static public function unBind(target:*, targetPropertyName:String = null):void
		{
			
			var recordObj:Object = getRecordObj(target);
			
			if (targetPropertyName != null)
			{
				
				recordObj[targetPropertyName] = null;
				delete recordObj[targetPropertyName];
				
				for each(var recordItem:BindRecord in recordObj)
				{
					
					return;
					
				}
				
			}
			
			dic_bindRecord[target] = null;
			delete dic_bindRecord[target];
			
		}
		
		/**
		 * 轮询检查  如果目标属性的值与数据源属性的值不同，则对目标属性重新赋值。
		 * @param	evt
		 */
		static private function doPoll(evt:TimerEvent):void
		{
			
			for each(var recordObj:Object in dic_bindRecord)
			{
				
				for each(var recordItem:BindRecord in recordObj)
				{
					
					if (recordItem.target[recordItem.targetPropertyName] != recordItem.source[recordItem.sourcePropertyName])
					{
						
						recordItem.target[recordItem.targetPropertyName] = recordItem.source[recordItem.sourcePropertyName];
						
					}
					
				}
				
			}
			
		}
		
		static private function getRecordObj(target:*):Object
		{
			
			return dic_bindRecord[target] || (dic_bindRecord[target] = new Object());
			
		}
		
		/**
		 * 轮询间隔  以秒为单位。默认值是0.5秒
		 */
		static public function get pollInterval():Number 
		{
			return _pollInterval;
		}
		
		/**
		 * 轮询间隔  以秒为单位。默认值是0.5秒
		 */
		static public function set pollInterval(value:Number):void 
		{
			
			_pollInterval = value;
			
			timer.delay = _pollInterval * 1000;
			
		}
		
	}

}
/**
 * 绑定记录
 */
class BindRecord
{
	
	/**
	 * 绑定目标
	 */
	public var target:*;
	/**
	 * 目标属性名
	 */
	public var targetPropertyName:String;
	/**
	 * 绑定的数据源
	 */
	public var source:*;
	/**
	 * 数据源属性名
	 */
	public var sourcePropertyName:String;
	
	public function BindRecord(target:*, targetPropertyName:String, source:*, sourcePropertyName:String):void
	{
		
		this.target = target;
		this.targetPropertyName = targetPropertyName;
		this.source = source;
		this.sourcePropertyName = sourcePropertyName;
		
	}
	
}