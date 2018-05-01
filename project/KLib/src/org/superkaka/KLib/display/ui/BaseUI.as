package org.superkaka.KLib.display.ui 
{
	import flash.display.DisplayObject;
	import flash.display.InteractiveObject;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.events.IEventDispatcher;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.utils.describeType;
	import flash.utils.Timer;
	import org.superkaka.KLib.manager.ClassManager;
	import org.superkaka.KLib.struct.EventListenerInfo;
	import org.superkaka.KLib.display.ui.components.Button;
	
	/**
	 * ...
	 * @author ｋａｋａ
	 * 用户界面基类
	 */
	public class BaseUI extends BaseUIForExtend implements IUI
	{
		
		/**
		 * 绑定的资源
		 */
		protected var _content:DisplayObject;
		
		/**
		 * 是否已经绑定过资源
		 */
		protected var _binded:Boolean = false;
		
		protected var _isSleep:Boolean;
		
		protected var _contentWidth:Number;
		protected var _contentHeight:Number;
		
		/**
		 * 用户自定义的数据
		 */
		public var customData:Object = { };
		
		/**
		 * 与此UI关联的数据
		 */
		protected var _data:Object;
		
		/**
		 * 通过describeType生成的描述此类信息的xml
		 */
		public var describeXML:XML;
		
		static private var _stage:Stage;
		
		private var _activeListenerList:Array = [];
		
		public function BaseUI():void
		{
			
			describeXML = describeType(this);
			
		}
		
		static public function registerStage(stg:Stage):void
		{
			
			_stage = stg;
			
		}
		
		protected function get UIStage():Stage
		{
			return _stage;
		}
		
		//public function addChildEventListener(type:String, listener:Function, useCapture:Boolean = false, priority:int = 0, useWeakReference:Boolean = false):void
		//{
			//
			//return _content.addEventListener(type, listener, useCapture, priority, useWeakReference);
			//
		//}
		//
		//public function removeChildEventListener(type:String, listener:Function, useCapture:Boolean = false):void
		//{
			//
			//return _content.removeEventListener(type, listener, useCapture);
			//
		//}
		
		
		/**
		 * 进入激活状态
		 */
		protected function active():void
		{
			///被子类覆写
		}
		
		/**
		 * 进入后台运行状态
		 */
		protected function backStage():void
		{
			///被子类覆写
		}
		
		/**
		 * 销毁，释放资源
		 */
		public function destory():void
		{
			///被子类覆写
		}
		
		private var superCalled:Boolean;
		
		/**
		 * 执行资源绑定
		 * @param	resource		绑定到的资源，如果传入的是一个字符串，则会以此为链接名获取资源执行绑定
		 */
		public function bind(resource:*):void
		{
			
			if (binded)
			throw new Error("已经绑定过资源");
			
			_content = null;
			
			if (resource is String)
			{
				_content = ClassManager.createInstance(String(resource));
			}
			else
			{
				_content = resource;
			}
			
			UITool.bind(this, _content);
			_binded = true;
			_isSleep = true;
			
			superCalled = false;
			bindComplete();
			if (false == superCalled) throw new Error(describeXML.@name + " 必须调用父类的 bindComplete");
			
			
			///如果onButtonClick被覆写，则为每个按钮添加侦听器
			if (super.onButtonClick != this.onButtonClick)
			{
				
				var list_btn:Array = UITool.filterProperty(this, Button);
				
				for each(var btnName:String in list_btn)
				{
					
					var btn:Button = this[btnName];
					
					btn.addEventListener(MouseEvent.CLICK, btnClickHandler);
					
				}
				
			}
			
			//var list_event:Array = [];
			//if (super.onClick != this.onClick) list_event.push([MouseEvent.CLICK, onClick]);
			//if (super.onRollOver != this.onRollOver) list_event.push([MouseEvent.ROLL_OVER, onRollOver]);
			//if (super.onRollOut != this.onRollOut) list_event.push([MouseEvent.ROLL_OUT, onRollOut]);
			//if (super.onMouseDown != this.onMouseDown) list_event.push([MouseEvent.MOUSE_DOWN, onMouseDown]);
			//if (super.onMouseUp != this.onMouseUp) list_event.push([MouseEvent.MOUSE_UP, onMouseUp]);
			//
			//var list_target:Array = UITool.filterProperty(this, InteractiveObject);
			//
			//for each(var targetName:String in list_btn)
			//{
				//
				//var target:InteractiveObject = this[btnName];
				//
				//for each(var evtItem:Array in list_event)
				//{
					//target.addEventListener(evtItem[0], evtItem[1]);
				//}
				//
			//}
			
			addEventListener(Event.ADDED_TO_STAGE, showHandler);
			
			addEventListener(Event.REMOVED_FROM_STAGE, hideHandler);
			
		}
		
		private function btnClickHandler(evt:MouseEvent):void
		{
			
			this.onButtonClick(evt.currentTarget as Button);
			
		}
		
		/**
		 * 解除绑定
		 */
		//public function unbind():void
		//{
			//
			//beforeUnbind();
			//
			//ResourceBinder.unbindResource(this);
			//this._content = null;
			//
		//}
		//
		/**
		 * 执行重绑定资源
		 */
		//public function replaceBindedResource():void
		//{
			//ResourceBinder.replaceBindResource(this);
		//}
		
		/**
		 * 绑定完成，资源已经可以访问
		 */
		protected function bindComplete():void
		{
			
			superCalled = true;
			///被子类覆写
			
		}
		
		/**
		 * 即将解除绑定
		 */
		protected function beforeUnbind():void
		{
			
			removeEventListener(Event.ADDED_TO_STAGE, showHandler);
			
			removeEventListener(Event.REMOVED_FROM_STAGE, hideHandler);
			
			destory();
			
		}
		
		/**
		 * 绑定的资源
		 */
		public function get content():DisplayObject
		{
			return _content;
		}
		
		public function get data():Object
		{
			return _data;
		}
		
		public function set data(value:Object):void
		{
			_data = value;
			render();
		}
		
		/**
		 * 获取或设置界面用于排布的参考宽度
		 */
		public function get contentWidth():Number
		{
			
			///如果没有设置过contentWidth则返回主容器宽度
			if (isNaN(_contentWidth)) return this.width;
			
			return _contentWidth * this.scaleX;
			
		}
		
		/**
		 * 获取或设置界面用于排布的参考高度
		 */
		public function get contentHeight():Number
		{
			
			///如果没有设置过contentHeight则返回主容器宽度
			if (isNaN(_contentHeight)) return this.height;
			
			return _contentHeight * this.scaleY;
			
		}
		
		public function set contentWidth(value:Number):void 
		{
			_contentWidth = value;
		}
		
		public function set contentHeight(value:Number):void 
		{
			_contentHeight = value;
		}
		
		/**
		 * 渲染此UI
		 */
		protected function render():void
		{
			
			///被子类覆写
			
		}
		
		/**
		 * 添加到显示列表
		 * @param	evt
		 */
		private function showHandler(evt:Event):void
		{
			
			removeEventListener(Event.EXIT_FRAME, doSleep);
			
			if (!_isSleep) return;
			
			var i:int = 0;
			var c:int = _activeListenerList.length;
			while (i < c) 
			{
				
				var elInfo:EventListenerInfo = _activeListenerList[i];
				
				doAddActiveEventListener(elInfo);
				
				i++;
			}
			
			_isSleep = false;
			
			active();
			
		}
		
		/**
		 * 从显示列表移除
		 * @param	evt
		 */
		private function hideHandler(evt:Event):void
		{
			
			addEventListener(Event.EXIT_FRAME, doSleep);
			
		}
		
		private function doSleep(evt:Event):void
		{
			
			removeEventListener(Event.EXIT_FRAME, doSleep);
			
			if (_isSleep) return;
			
			_isSleep = true;
			
			if (stage != null) throw new Error();//本行在测试一段时间没问题之后删除
			
			var i:int = 0;
			var c:int = _activeListenerList.length;
			while (i < c) 
			{
				
				var elInfo:EventListenerInfo = _activeListenerList[i];
				
				doRemoveActiveEventListener(elInfo);
				
				i++;
			}
			
			backStage();
			
		}
		
		/**
		 * 获取此对象是否处于显示列表中并显示
		 */
		public function get isDisplay():Boolean
		{
			
			return (null != stage) && this.visible;
			
		}
		
		public function get binded():Boolean 
		{
			return _binded;
		}
		
		/**
		 * 获取此UI实例当前是否处于休眠状态
		 */
		public function get isSleep():Boolean 
		{
			return _isSleep;
		}
		
		
		/**
		 * 解除绑定，销毁并释放资源
		 */
		//public function dispose():void
		//{
			//
			//
			//
		//}
		
		/**
		 * 注册激活状态事件侦听，通过此方法注册的侦听器只会在此UI对象处于激活状态的情况下触发
		 * @param	target							侦听的目标
		 * @param	type								事件的类型
		 * @param	listener							处理事件的侦听器函数。此函数必须接受事件对象作为其唯一的参数，并且不能返回任何结果，如下面的示例所示：
		 * function(evt:Event):void
		 * @param	useCapture					确定侦听器是运行于捕获阶段还是运行于目标和冒泡阶段
		 * @param	priority							事件侦听器的优先级
		 * @param	useWeakReference			确定对侦听器的引用是强引用，还是弱引用
		 */
		public function addActiveEventListener(target:IEventDispatcher, type:String, listener:Function, useCapture:Boolean = false, priority:int = 0, useWeakReference:Boolean = false):void
		{
			
			var elInfo:EventListenerInfo = new EventListenerInfo(target, type, listener, useCapture, priority, useWeakReference);
			
			_activeListenerList.push(elInfo);
			
			if (null != stage)
			{
				doAddActiveEventListener(elInfo);
			}
			
		}
		
		/**
		 * 移除激活状态事件侦听
		 * @param	target							侦听的目标
		 * @param	type								事件的类型
		 * @param	listener							处理事件的侦听器函数。此函数必须接受事件对象作为其唯一的参数，并且不能返回任何结果，如下面的示例所示：
		 * function(evt:Event):void
		 * @param	useCapture					确定侦听器是运行于捕获阶段还是运行于目标和冒泡阶段
		 */
		public function removeActiveEventListener(target:IEventDispatcher, type:String, listener:Function, useCapture:Boolean = false):void
		{
			
			var i:int = 0;
			var c:int = _activeListenerList.length;
			while (i < c) 
			{
				
				var elInfo:EventListenerInfo = _activeListenerList[i];
				
				if (elInfo.target == target && elInfo.type == type && elInfo.useCapture == useCapture)
				{
					doRemoveActiveEventListener(elInfo);
					_activeListenerList.splice(i, 1);
					break;
				}
				
				i++;
			}
			
			
		}
		
		private function doAddActiveEventListener(elInfo:EventListenerInfo):void
		{
			
			elInfo.target.addEventListener(elInfo.type, elInfo.listener, elInfo.useCapture, elInfo.priority, elInfo.useWeakReference);
			
		}
		
		private function doRemoveActiveEventListener(elInfo:EventListenerInfo):void
		{
			
			elInfo.target.removeEventListener(elInfo.type, elInfo.listener, elInfo.useCapture);
			
		}
		
		/**
		 * 显示到当前容器的最前端
		 */
		public function bringToFront():void
		{
			
			if (parent != null)
			parent.addChild(this);
			
		}
		
	}

}