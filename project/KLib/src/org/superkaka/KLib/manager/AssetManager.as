package org.superkaka.KLib.manager 
{
	/**
	 * 资源管理
	 * @author ｋａｋａ
	 */
	public class AssetManager
	{
		
		static private const dic_asset:Object = { };
		
		static public function addAsset(asset:*, id:String):void
		{
			
			dic_asset[id] = asset;
			
		}
		
		static public function getAsset(id:String):*
		{
			
			if (!hasAsset(id)) throw new Error("不存在的资源  id:" + id);
			return dic_asset[id];
			
		}
		
		static public function hasAsset(id:String):Boolean
		{
			
			return null != dic_asset[id];
			
		}
		
	}

}