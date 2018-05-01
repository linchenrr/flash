package org.superkaka.KLib.common.keyboard 
{
	import flash.display.Stage;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import org.superkaka.KLib.events.GlobalEventDispatcher;
	import org.superkaka.KLib.utils.ObjectUtil;
	/**
	 * 通过使用KeyControl类对键盘组合按键事件进行侦听，执行指定的回调函数
	 * 同时还提供as2时代的keyIsDown方法，可以随时获取指定按键的当前状态。
	 * KeyControl类增强了flash自身的键盘事件的功能，同时避免了不同的操作系统在键盘按下时可能会间隔重复触发键盘事件导致的问题
	 * @author ｋａｋａ
	 */
	public class KeyControl
	{
		
		static private var stage:Stage;
		
		static private const dic_key:Object = { };
		
		static private const dic_keyStateInfo:Object = { };
		
		static private const dic_downStateInfo:Object = { };
		
		static public function init(_stg:Stage):void
		{
			
			stage = _stg;
			
			stage.addEventListener(KeyboardEvent.KEY_DOWN, keyDownHandler);
			stage.addEventListener(KeyboardEvent.KEY_UP, keyUpHandler);
			
			GlobalEventDispatcher.addEventListener(Event.DEACTIVATE, deActiveHandler);
			
		}
		
		/**
		 * 获取指定的按键集当前是否处于按下状态
		 * @param	...keys			指定的一个或多个按键
		 * @return
		 */
		static public function keyIsDown(...keys):Boolean
		{
			
			for each(var key:uint in keys)
			{
				if (dic_key[key] == null || dic_key[key] == false) return false;
			}
			
			return true;
			
		}
		
		/**
		 * 注册指定的按键集按下时的回调函数，只有指定的按键集全部按下时才会触发回调函数
		 * 可以通过对此方法进行多次调用，传递相同的按键集参数和不同的回调函数从而对相同的按键集注册不同的回调函数，回调函数会按注册的顺序依次调用。
		 * 完全相同的按键集和回调只会注册一次
		 * @param	fun				指定按下时的回调函数
		 * @param	...keys			指定的一个或多个按键
		 */
		static public function registerKeyPressFunction(fun:Function, ...keys):void
		{
			
			keys.sort();
			
			var list_pressFun:Array = getKeyStateInfo(keys, true).list_pressFun;
			
			if (list_pressFun.indexOf(fun) == -1)
			{
				list_pressFun.push(fun);
			}
			
		}
		
		/**
		 * 移除对指定的按键集注册的按下时的回调函数
		 * @param	fun				要移除的回调函数
		 * @param	...keys			指定的一个或多个按键
		 */
		static public function removeKeyPressFunction(fun:Function, ...keys):void
		{
			
			removeKeyFunction(fun, true, keys);
			
		}
		
		/**
		 * 注册指定的按键集松开时的回调函数，只要指定的按键集处于按下状态时其中的任何一个松开，便会触发回调函数。回调函数不会在松开时重复触发除非该按键集再次处于按下状态
		 * 可以通过对此方法进行多次调用，传递相同的按键集参数和不同的回调函数从而对相同的按键集注册不同的回调函数，回调函数会按注册的顺序依次调用。
		 * 完全相同的按键集和回调只会注册一次
		 * @param	fun				指定松开时的回调函数
		 * @param	...keys			指定的一个或多个按键
		 */
		static public function registerKeyReleaseFunction(fun:Function, ...keys):void
		{
			
			keys.sort();
			
			var list_releaseFun:Array = getKeyStateInfo(keys, true).list_releaseFun;
			
			if (list_releaseFun.indexOf(fun) == -1)
			{
				list_releaseFun.push(fun);
			}
			
		}
		
		/**
		 * 移除对指定的按键集注册的松开时的回调函数
		 * @param	fun				要移除的回调函数
		 * @param	...keys			指定的一个或多个按键
		 */
		static public function removeKeyReleaseFunction(fun:Function, ...keys):void
		{
			
			removeKeyFunction(fun, false, keys);
			
		}
		
		
		static private function removeKeyFunction(fun:Function, pressFun:Boolean, keys:Array):void
		{
			
			keys.sort();
			
			var ks:KeyStateInfo = getKeyStateInfo(keys);
			
			if (null == ks) return;
			
			var list_fun:Array = pressFun ? ks.list_pressFun : ks.list_releaseFun;
			
			var index:int = list_fun.indexOf(fun);
			if (index != -1)
			{
				
				list_fun.splice(index, 1);
				
				if (ks.list_pressFun.length == 0 && ks.list_releaseFun.length == 0)
				{
					delete dic_keyStateInfo[ks.keyName];
					delete dic_downStateInfo[ks.keyName];
				}
				
			}
			
		}
		
		
		static private function keyDownHandler(evt:KeyboardEvent):void
		{
			
			dic_key[evt.keyCode] = true;
			
			var dic2:Object = ObjectUtil.copyObject(dic_keyStateInfo);
			
			for each(var ks:KeyStateInfo in dic2)
			{
				
				if (keyIsDown.apply(null, ks.list_keyCode))
				{
					
					//ks.isDown = true;
					
					dic_downStateInfo[ks.keyName] = ks;
					
					delete dic_keyStateInfo[ks.keyName];
					
					var list_pressFun:Array = ks.list_pressFun;
					
					var i:int = 0;
					var c:int = list_pressFun.length;
					
					while (i < c) 
					{
						
						list_pressFun[i].apply();
						
						i++;
						
					}
					
				}
				
			}
			
		}
		
		
		static private function keyUpHandler(evt:KeyboardEvent):void
		{
			
			dic_key[evt.keyCode] = false;
			
			var dic2:Object = ObjectUtil.copyObject(dic_downStateInfo);
			
			var keyCode:uint = evt.keyCode;
			
			for each(var ks:KeyStateInfo in dic2)
			{
				
				if (ks.list_keyCode.indexOf(keyCode) != -1)
				{
					
					//ks.isDown = false;
					
					dic_keyStateInfo[ks.keyName] = ks;
					
					delete dic_downStateInfo[ks.keyName];
					
					var list_releaseFun:Array = ks.list_releaseFun;
					
					var i:int = 0;
					var c:int = list_releaseFun.length;
					
					while (i < c) 
					{
						
						list_releaseFun[i].apply();
						
						i++;
						
					}
					
				}
				
			}
			
		}
		
		static private function getKeyStateInfo(list_key:Array, autoCreate:Boolean = false):KeyStateInfo
		{
			
			var keyName:String = list_key.join("_");
			
			var ks:KeyStateInfo;
			
			if (null == dic_keyStateInfo[keyName])
			{
				if (null == dic_downStateInfo[keyName])
				{
					if (autoCreate)
					{
						ks = new KeyStateInfo(list_key, keyName);
						if (keyIsDown(list_key))
						{
							dic_downStateInfo[keyName] = ks;
						}
						else
						{
							dic_keyStateInfo[keyName] = ks;
						}
					}
				}
				else
				{
					ks = dic_downStateInfo[keyName];
				}
			}
			else
			{
				ks = dic_keyStateInfo[keyName];
			}
			
			return ks;
			
		}
		
		static private function getCurPressKeys():Array
		{
			
			var list_key:Array = [];
			for (var key:String in dic_key)
			{
				
				list_key.push(uint(key));
				
			}
			
			return list_key;
			
		}
		
		static private function deActiveHandler(evt:Event):void
		{
			
			for (var key:String in dic_key)
			{
				
				stage.dispatchEvent(new KeyboardEvent(KeyboardEvent.KEY_UP, true, false, 0, uint(key)));
				
			}
			
		}
		
	}

}
class KeyStateInfo
{
	
	public function KeyStateInfo(list_keyCode:Array,keyName:String):void
	{
		this.list_keyCode = list_keyCode;
		this.keyName = keyName;
	}
	
	//public var isDown:Boolean;
	public var keyName:String;
	public var list_keyCode:Array;
	public var list_pressFun:Array = [];
	public var list_releaseFun:Array = [];
	
}