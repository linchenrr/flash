package org.superkaka.KLib.common 
{
	import flash.utils.Dictionary;
	import org.superkaka.KLib.interfaces.IRecycle;

	/**
	 * 对象池简单实现
	 * @author ｋａｋａ
	 */
	public class ObjectPool
	{
		
		/**
		 * 缓存对象类型
		 */
		private var typeClass:Class;
		
		/**
		 * 已缓存对象列表
		 */
		private var list_obj:Array;
		
		/**
		 * 缓存实例数量
		 */
		private var _cacheSize:uint;
		
		/**
		 * @param	typeClass			对象池存放的对象类型
		 * @param	cacheSize			对象池缓存实例数量，0为不限制
		 * @param	initializeNow			是否立即初始化cacheSize所指定数量的实例
		 */
		public function ObjectPool(typeClass:Class, cacheSize:uint = 0, initializeNow:Boolean = false):void
		{
			
			this.typeClass = typeClass;
			
			_cacheSize = cacheSize;
			
			list_obj = [];
			
			if (initializeNow)
			{
				var i:uint = 0;
				while (i < cacheSize) 
				{
					
					list_obj[i] = new typeClass;
					
					i++;
				}
			}
			
		}
		
		/**
		 * 获取对象实例
		 * @return
		 */
		public function getObj():*
		{
			
			//trace("获取", list_obj.length);
			
			if (list_obj.length > 0)
			{
				
				return list_obj.pop();
				
			}
			else
			{
				
				return new typeClass;
				
			}
			
		}
		
		/**
		 * 存放对象实例
		 * @param	obj
		 */
		public function putObj(obj:IRecycle):void
		{
			
			obj.recycle();
			
			if (_cacheSize == 0 || list_obj.length < _cacheSize)
			{
				//if (list_obj.indexOf(obj) != -1) trace("sameObj",list_obj.indexOf(obj))
				//if (list_obj.indexOf(obj) != -1) throw new Error();
				list_obj.push(obj);
				
			}
			
			//trace("存放", list_obj.length);
			
		}
		
		/**
		 * 缓存实例数量，0为不限制
		 */
		public function get cacheSize():uint 
		{
			
			return _cacheSize;
			
		}
		
		/**
		 * 缓存实例数量，0为不限制
		 */
		public function set cacheSize(value:uint):void 
		{
			
			_cacheSize = value;
			
			if (_cacheSize == 0) return;
			
			if (list_obj.length > _cacheSize)
			{
				
				list_obj.length = _cacheSize;
				
			}
		}
		
		//=================静态管理===============
		
		
		static private var dic_pool:Dictionary = new Dictionary();
		
		/**
		 * 创建对象池
		 * @param	typeClass			创建的对象池存放的对象类型
		 * @param	cacheSize			对象池缓存实例数量，0为不限制
		 * @param	initializeNow			是否立即初始化cacheSize所指定数量的实例
		 */
		static public function createObjectPool(typeClass:Class, cacheSize:uint = 0, initializeNow:Boolean = false):ObjectPool
		{
			
			if (dic_pool[typeClass] == null)
			{
				var pool:ObjectPool = new ObjectPool(typeClass, cacheSize);
				dic_pool[typeClass] = pool;
				return pool;
			}
			else
			{
				
				throw new Error("尝试创建已存在的对象池" + typeClass);
				
			}
			
			return null;
			
		}
		
		/**
		 * 获取对象池
		 * @param	typeClass			所要获取的对象池存放的对象类型
		 * @return
		 */
		static public function getObjectPool(typeClass:Class):ObjectPool
		{
			
			return dic_pool[typeClass];
			
		}
		
		/**
		 * 获取对象实例
		 * @return
		 */
		static public function getObj(typeClass:Class):*
		{
			
			var pool:ObjectPool = dic_pool[typeClass];
			
			if (pool == null) throw new Error("对象池" + typeClass + "不存在");
			
			return pool.getObj();
			
		}
		
		/**
		 * 存放对象实例
		 * @param	obj					要存放的对象
		 */
		static public function putObj(typeClass:Class,obj:IRecycle):void
		{
			
			var pool:ObjectPool = dic_pool[typeClass];
			
			if (pool == null) throw new Error("对象池" + typeClass + "不存在");
			
			pool.putObj(obj);
			
		}
		
	}

}