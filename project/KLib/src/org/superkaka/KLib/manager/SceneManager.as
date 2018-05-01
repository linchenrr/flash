package org.superkaka.KLib.manager 
{
	import flash.display.Sprite;
	import org.superkaka.KLib.events.AppEvent;
	import org.superkaka.KLib.events.GlobalEventDispatcher;
	import org.superkaka.KLib.struct.ResourceRequest;
	import org.superkaka.KLib.struct.UIResourceInfo;
	import org.superkaka.KLib.utils.ObjectUtil;
	import org.superkaka.KLib.display.ui.BaseScene;
	
	/**
	 * 游戏场景管理类
	 * @author ｋａｋａ
	 */
	public class SceneManager
	{
		
		/**
		 * 存储已注册场景
		 */
		static private const map_scene:Object = { };
		
		static private const dic_resInfo:Object = { };
		
		/**
		 * 当前场景id
		 */
		static private var _currentSceneId:String;
		
		/**
		 * 内部容器
		 */
		static private var _insideContainer:Sprite = new Sprite();
		
		/**
		 * 场景容器
		 */
		static private var _container:Sprite;
		
		static public var defaultTransition:Function;
		
		/**
		 * 注册容器
		 * @param	container		容器
		 */
		static public function registerSceneContainer(container:Sprite):void
		{
			_container = container;
			_container.addChild(_insideContainer);
		}
		
		/**
		 * 注册场景
		 * @param	scene		新加入的场景
		 * @param	sceneId		场景标示
		 */
		static public function registerScene(scene:BaseScene, sceneId:String):void
		{
			map_scene[sceneId] = scene;
		}
		
		/**
		 * 获取场景
		 * @param	sceneId
		 * @return
		 */
		static public function getScene(sceneId:String):BaseScene
		{
			return map_scene[sceneId];
		}
		
		/**
		 * 转换场景
		 * @param	sceneId		场景标示
		 */
		static public function gotoScene(sceneId:String):void
		{
			
			var targetScene:BaseScene = map_scene[sceneId];
			
			if (targetScene == null)
			{
				
				var resInfo:UIResourceInfo = dic_resInfo[sceneId];
				
				if (null == resInfo) throw new Error("不存在的场景定义" + sceneId);
				
				
				var request:ResourceRequest = new ResourceRequest(resInfo.id, resInfo.resourceList);
				request.completeHandler = resourceReadyHandler;
				GlobalEventDispatcher.dispatchEvent(new AppEvent(AppEvent.RESOURCE_REQUEST, request));
				
			}
			else
			{
				
				doGotoScene(sceneId);
				
			}
			
			GlobalEventDispatcher.dispatchEvent(new AppEvent(AppEvent.ON_SCENE_CHANGE, sceneId));
			
		}
		
		static private function doGotoScene(sceneId:String):void
		{
			
			var targetScene:BaseScene = map_scene[sceneId];
			
			var transition:Function = targetScene.transition || defaultTransition;
			
			if (transition == null)
			doChangeScene(sceneId);
			else
			transition.call(null, targetScene, _container, doChangeScene, sceneId);
			
		}
		
		static private function doChangeScene(sceneId:String):void
		{
			
			var scene:BaseScene = map_scene[_currentSceneId];
			
			if (scene != null)
			{
				_insideContainer.removeChild(scene);
			}
			
			_currentSceneId = sceneId;
			scene = map_scene[_currentSceneId];
			
			_insideContainer.addChild(scene);
			
			GlobalEventDispatcher.dispatchEvent(new AppEvent(AppEvent.SCENE_CHANGED, _currentSceneId));
			
		}
		
		static private function resourceReadyHandler(request:ResourceRequest):void
		{
			
			var resInfo:UIResourceInfo = dic_resInfo[request.id];
			
			var scene:BaseScene = ClassManager.createInstance(resInfo.className) as BaseScene;
			scene.bind(ClassManager.createInstance(resInfo.link));
			
			registerScene(scene, resInfo.id);
			
			doGotoScene(resInfo.id);
			
		}
		
		static public function registerResourceInfo(dic_info:Object):void
		{
			
			ObjectUtil.copyTo(dic_info, dic_resInfo);
			
		}
		
		
		/**
		 * 获取当前场景id
		 */
		static public function get currentSceneId():String 
		{
			return _currentSceneId;
		}
		
	}

}