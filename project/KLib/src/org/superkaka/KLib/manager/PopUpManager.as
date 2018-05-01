package org.superkaka.KLib.manager 
{
	import flash.display.DisplayObject;
	import flash.display.Graphics;
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.geom.Rectangle;
	import flash.utils.Dictionary;
	import org.superkaka.KLib.events.AppEvent;
	import org.superkaka.KLib.events.GlobalEventDispatcher;
	import org.superkaka.KLib.struct.ResourceRequest;
	import org.superkaka.KLib.struct.UIResourceInfo;
	import org.superkaka.KLib.utils.DisplayObjectTool;
	import org.superkaka.KLib.utils.ObjectUtil;
	import org.superkaka.KLib.display.ui.BasePopPanel;
	/**
	 * 弹窗管理类
	 * @author ｋａｋａ
	 */
	public class PopUpManager
	{
		
		
		/**
		 * 注册的弹窗集合
		 */
		static private const dic_panel:Object = { };
		
		static private const dic_resInfo:Object = { };
		
		/**
		 * 当前弹出的面板列表
		 */
		static private const list_panel:Array = [];
		
		/**
		 * 当前弹出的面板附加信息集
		 */
		static private const dic_panelInfo:Dictionary = new Dictionary();
		
		/**
		 * 灰色背景层
		 */
		static private const layer_background:Sprite = new Sprite();
		
		/**
		 * 内部容器
		 */
		static private const _insideContainer:Sprite = new Sprite();
		
		/**
		 * 弹窗容器
		 */
		static private var _container:Sprite;
		
		static private var stage:Stage;
		
		static public var defaultEaseIn:Function;
		static public var defaultEaseOut:Function;
		
		/**
		 * 初始化
		 */
		static public function init(stg:Stage):void
		{
			
			stage = stg;
			
			DisplayObjectTool.drawRect(layer_background.graphics, 0, 0.3, stage.stageWidth, stage.stageHeight);
			
		}
		
		/**
		 * 注册容器
		 * @param	container		容器
		 */
		static public function registerContainer(container:Sprite):void
		{
			
			_container = container;
			_container.addChild(_insideContainer);
			
		}
		
		/**
		 * 注册弹窗
		 * @param	panel
		 */
		static public function registerPopPanel(panel:BasePopPanel, panelId:String):void
		{
			
			dic_panel[panelId] = panel;
			
		}
		
		
		/**
		 * 根据类型弹出面板
		 * @param	type				弹窗类型
		 * @param	overlay			是否需要灰色背景覆盖
		 */
		static public function popUpPanelById(panelId:String, data:Object = null, closeCurPanels:Boolean = false, overlay:Boolean = true, offsetX:int = 0, offsetY:int = 0):void
		{
			
			var panel:BasePopPanel = dic_panel[panelId];
			
			if (panel == null)
			{
				
				var resInfo:UIResourceInfo = dic_resInfo[panelId];
				
				if (null == resInfo) throw new Error("不存在的弹窗定义" + panelId);
				
				var panelInfo:PanelInfo = new PanelInfo();
				
				panelInfo.id = panelId;
				panelInfo.data = data;
				panelInfo.closeCurPanels = closeCurPanels;
				panelInfo.overlay = overlay;
				panelInfo.offsetX = offsetX;
				panelInfo.offsetY = offsetY;
				
				var request:ResourceRequest = new ResourceRequest(resInfo.id, resInfo.resourceList);
				request.customData = panelInfo;
				request.completeHandler = resourceReadyHandler;
				GlobalEventDispatcher.dispatchEvent(new AppEvent(AppEvent.RESOURCE_REQUEST, request));
				
				return;
				
			}
			
			popUpPanel(panel, data, closeCurPanels, overlay, offsetX, offsetY);
			
		}
		
		static private function resourceReadyHandler(request:ResourceRequest):void
		{
			
			var panelInfo:PanelInfo = request.customData as PanelInfo;
			
			var resInfo:UIResourceInfo = dic_resInfo[panelInfo.id];
			
			var panel:BasePopPanel = ClassManager.createInstance(resInfo.className) as BasePopPanel;
			panel.bind(ClassManager.createInstance(resInfo.link));
			
			registerPopPanel(panel, resInfo.id);
			
			popUpPanelById(panelInfo.id, panelInfo.data, panelInfo.closeCurPanels, panelInfo.overlay, panelInfo.offsetX, panelInfo.offsetY);
			
		}
		
		static public function registerResourceInfo(dic_info:Object):void
		{
			
			ObjectUtil.copyTo(dic_info, dic_resInfo);
			
		}
		
		/**
		 * 弹出面板
		 * @param	panel				需要弹出的面板显示对象
		 * @param	overlay			是否需要灰色背景覆盖
		 */
		static public function popUpPanel(panel:BasePopPanel, data:Object = null, closeCurPanels:Boolean = true, overlay:Boolean = true, offsetX:int = 0, offsetY:int = 0):void
		{
			
			var panelInfo:PanelInfo = dic_panelInfo[panel];
			if (null != panelInfo)
			{
				closePanel(panel);
			}
			
			
			if (closeCurPanels)
			{
				closeAllPanel();
			}
			
			panelInfo = new PanelInfo();
			
			panelInfo.overlay = overlay;
			panelInfo.offsetX = offsetX;
			panelInfo.offsetY = offsetY;
			
			//list_panel.push(panel);
			list_panel.unshift(panel);
			
			dic_panelInfo[panel] = panelInfo;
			
			if (panel.parent != null)
			panel.parent.removeChild(panel);
			
			panel.data = data;
			
			var panelContainer:Sprite = panelInfo.container;
			panelContainer.x = stage.stageWidth / 2;
			panelContainer.y = stage.stageHeight / 2;
			
			panelContainer.addChild(panel);
			
			
			var rect:Rectangle = DisplayObjectTool.getVisibleBounds(panel);
			
			panel.x = - rect.width / 2 - rect.x + panelInfo.offsetX;
			
			panel.y = - rect.height / 2 - rect.y + panelInfo.offsetY;
			
			_insideContainer.addChild(panelContainer);
			
			//updateView();
			renderState();
			
			if (null != defaultEaseIn)
			defaultEaseIn.call(null, panelContainer);
			
		}
		
		/**
		 * 关闭当前面板
		 */
		static public function closeCurrentPanel():void
		{
			
			var panel:BasePopPanel = list_panel[0];
			
			closePanel(panel);
			
		}
		
		/**
		 * 关闭面板
		 * @param	panel		要被关闭的面板
		 */
		static public function closePanel(panel:BasePopPanel):void
		{
			
			var index:int = list_panel.lastIndexOf(panel);
			
			if (index == -1)
			{
				
				//throw new Error("此面板不存在！");
				
				return;
				
			}
			
			list_panel.splice(index, 1);
			
			var panelInfo:PanelInfo = dic_panelInfo[panel];
			panelInfo.container.mouseChildren = false;
			
			if (defaultEaseOut == null)
			doRemovePanel(panelInfo.container);
			else
			defaultEaseOut.call(null, panelInfo.container, doRemovePanel);
			
			dic_panelInfo[panel] = null;
			delete dic_panelInfo[panel];
			
			//updateView();
			renderState();
			
		}
		
		static private function doRemovePanel(panelContainer:Sprite):void
		{
			
			panelContainer.mouseChildren = true;
			
			if (panelContainer.stage != null)
			_insideContainer.removeChild(panelContainer);
			
		}
		
		/**
		 * 根据类型关闭面板
		 * @param	type		要关闭的面板类型
		 */
		static public function closePanelById(panelId:String):void
		{
			
			var panel:BasePopPanel = dic_panel[panelId];
			
			closePanel(panel);
			
		}
		
		/**
		 * 关闭所有弹窗
		 */
		static public function closeAllPanel():void
		{
			
			while (list_panel.length > 0)
			{
				
				closePanel(list_panel[0]);
				
			}
			
		}
		
		/**
		 * 获取当前弹出的面板数组
		 * @return
		 */
		static public function getOpenedPanels():Array
		{
			
			return list_panel.concat();
			
		}
		
		/**
		 * 根据当前状态进行相关显示渲染
		 */
		static private function renderState():void
		{
			
			if (layer_background.stage != null)
			_insideContainer.removeChild(layer_background);
			
			var i:int = 0;
			var c:int = list_panel.length;
			while (i < c) 
			{
				
				var panelInfo:PanelInfo = dic_panelInfo[list_panel[i]];
				
				if (panelInfo.overlay)
				{
					_insideContainer.addChildAt(layer_background, _insideContainer.getChildIndex(panelInfo.container));
					break;
				}
				
				i++;
			}
			
			
			
		}
		
	}

}
import flash.display.Sprite;

/**
 * 面板信息
 */
class PanelInfo
{
	
	public var id:String;
	
	/**
	 * 是否需要灰色背景覆盖
	 */
	public var overlay:Boolean;
	
	/**
	 * 水平偏移
	 */
	public var offsetX:int;
	
	/**
	 * 垂直偏移
	 */
	public var offsetY:int;
	
	public var data:Object;
	public var closeCurPanels:Boolean;
	
	public var container:Sprite = new Sprite();
	
}