package org.superkaka.KLib.manager 
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.MovieClip;
	import flash.media.Sound;
	import flash.system.ApplicationDomain;
	import flash.utils.getDefinitionByName;
	/**
	 * 类管理
	 * @author ｋａｋａ
	 */
	public class ClassManager
	{
		/**
		 * 储存各个类容器
		 */
		static private const dic_domain:Object = new Object();
		
		/**
		 * 当前类容器id
		 */
		static public var currentDomainId:String;
		
		
		/**
		 * 加入类容器
		 * @param	classDomain				类容器
		 * @param	domainId					类容器id
		 */
		//static public function storeClassDomain(classDomain:ApplicationDomain, domainId:String):void
		//{
			//
			//if (dic_domain[domainId] != null) throw new Error("已经存在的类容器:", domainId);
			//dic_domain[domainId] = classDomain;
			//
		//}
		
		/**
		 * 获取指定的类容器，如果不存在，则会创建一个并返回
		 * @param	domainId					类容器id
		 * @return
		 */
		static public function getClassDomain(domainId:String):ApplicationDomain
		{
			
			return dic_domain[domainId] || (dic_domain[domainId] = new ApplicationDomain(ApplicationDomain.currentDomain));
			
		}
		
		/**
		 * 移除指定的类容器
		 * @param	domainId					类容器id
		 */
		//static public function removeClassDomain(domainId:String):void
		//{
			//
			//dic_domain[domainId] = null;
			//delete dic_domain[domainId];
			//
		//}
		
		/**
		 * 创建类实例，此方法通过getClass方法获取到类定义并实例化后返回
		 * @param	className		类名
		 * @param	domainId		类容器id，如果省略此参数，则使用当前容器id
		 * @return
		 */
		static public function createInstance(className:String, domainId:String = null):*
		{
			
			var cls:Class = getClass(className, domainId);
			
			return new cls();
			
		}
		
		/**
		 * 创建位图实例，此方法通过getClass方法获取到类定义并实例化后返回
		 * @param	className		类名
		 * @param	domainId		类容器id，如果省略此参数，则使用当前容器id
		 * @return
		 */
		static public function createBitmap(className:String, domainId:String = null):Bitmap
		{
			
			var bitData:BitmapData = createInstance(className, domainId);
			
			var bitmap:Bitmap = new Bitmap(bitData);
			bitmap.smoothing = true;
			
			return bitmap;
			
		}
		
		/**
		 * 创建MovieClip实例，此方法通过getClass方法获取到类定义并实例化后返回
		 * @param	className		类名
		 * @param	domainId		类容器id，如果省略此参数，则使用当前容器id
		 * @return
		 */
		static public function createMovieClip(className:String, domainId:String = null):MovieClip
		{
			
			var mc:MovieClip = createInstance(className, domainId);
			return mc;
			
		}
		
		/**
		 * 创建Sound实例，此方法通过getClass方法获取到类定义并实例化后返回
		 * @param	className		类名
		 * @param	domainId		类容器id，如果省略此参数，则使用当前容器id
		 * @return
		 */
		static public function createSound(className:String, domainId:String = null):Sound
		{
			
			var sound:Sound = createInstance(className, domainId);
			return sound;
			
		}
		
		/**
		 * 根据类名获取类，此方法会依次从domainId指定的容器、系统基础容器中查找类定义，如果都没有找到，则会引发异常
		 * @param	className					类名
		 * @param	domainId					类容器id，如果省略此参数，则使用当前容器id
		 * @param	checkSystemDomain		在domainId或当前类容器中都未找到类定义的情况下是否尝试从系统域查找
		 * @return
		 */
		static public function getClass(className:String, domainId:String = null, checkSystemDomain:Boolean = true):Class
		{
			
			var classDomain:ApplicationDomain;
			
			if (domainId == null)
			{
				domainId = currentDomainId;
			}
			
			if (domainId != null)
			{
				
				classDomain = getClassDomain(domainId);
				
				if (classDomain.hasDefinition(className))
				{
					return classDomain.getDefinition(className) as Class;
				}
				
			}
			
			if (checkSystemDomain)
			{
				classDomain = ApplicationDomain.currentDomain;
				
				if (classDomain.hasDefinition(className))
				{
					return classDomain.getDefinition(className) as Class;
				}
			}
			
			throw new Error("不存在的类:" + className + "\r\ndomainId:" + domainId + "\r\ncheckSystemDomain:" + checkSystemDomain);
			
			return null;
			
		}
		
		static public function getClassFromCurDomain(className:String):Class
		{
			
			var classDomain:ApplicationDomain = getClassDomain(currentDomainId);
			
			if (classDomain.hasDefinition(className))
			{
				return classDomain.getDefinition(className) as Class;
			}
			
			return null;
			
		}
		
	}

}