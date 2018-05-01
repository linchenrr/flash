package org.superkaka.KLib.display.ui 
{
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.MovieClip;
	import flash.system.System;
	import flash.text.TextField;
	import flash.text.TextFieldType;
	import flash.text.TextFormat;
	import flash.utils.Dictionary;
	import flash.utils.getDefinitionByName;
	import flash.utils.getQualifiedClassName;
	import flash.utils.getTimer;
	import org.superkaka.KLib.i18n.I18NTextManager;
	import org.superkaka.KLib.manager.ClassManager;
	import org.superkaka.KLib.utils.searchChild;
	
	import org.superkaka.KLib.display.ui.BaseUI;
	import org.superkaka.KLib.display.ui.BasePanel;
	import org.superkaka.KLib.display.ui.components.BaseUIComponent;

	/**
	 * ...
	 * @author ｋａｋａ
	 */
	internal class UITool
	{
		
		/**
		 * 绑定资源
		 * @param	bindTarget		绑定对象
		 * @param	source			绑定源
		 */
		static public function bind(bindTarget:BaseUI, source:DisplayObject):void
		{
			//var t:Number = getTimer();
			//if (bindTarget is BasePanel) bindUIPanel(bindTarget as BasePanel, source as MovieClip);
			//else if(bindTarget is BaseUIComponent)bindUIComponent(bindTarget as BaseUIComponent, source as DisplayObject);
			bindUI(bindTarget, source);
			setAllTextField(bindTarget);
			//trace("bind " + bindTarget, bindTarget.name, "  time:" + (getTimer() - t) + "ms");
		}
		
		static private var dic_txt:Dictionary = new Dictionary(true);
		static private function setAllTextField(bindTarget:DisplayObjectContainer):void
		{
			var list_txt:Array = searchChild(bindTarget, TextField);
			var i:int = 0;
			var c:int = list_txt.length;
			while (i < c) 
			{
				
				///如果是文本框，则为其设置默认TextFormat为舞台上编辑好的TextFormat
				var txt:TextField = list_txt[i];
				if (dic_txt[txt] == null)
				{
					setTextField(txt);
					dic_txt[txt] = true;
				}
				
				i++;
			}
		}
		
		static private function setTextField(txt:TextField):void
		{
			//if (txt.text.length != 0)
			//{
				//var format:TextFormat = txt.getTextFormat(0);
				//txt.defaultTextFormat = format;
				//txt.setTextFormat(format);
			//}
			//trace(txt.name,I18NTextManager.hasText(txt.name))
			//方便不需要程序动态控制内容的文本框自动获取语言包内容
			//if (I18NTextManager.hasText(txt.name))
			//{
				//txt.text = I18NTextManager.getRawText(txt.name);
			//}
			
			//使用飞线方式调用项目的接口处理
			//TextfieldUtil.reset(txt);
			
			var langPrefix:String = "lang_";
			var index:int = txt.name.indexOf(langPrefix);
			if (index == 0)
			{
				//txt.text = lang(txt.name.substr(langPrefix.length));
			}
			
			var htmlPrefix:String = "htmlLang_";
			index = txt.name.indexOf(htmlPrefix);
			if (index == 0)
			{
				//txt.htmlText = htmlLang(txt.name.substr(htmlPrefix.length));
			}
			
			if (txt.type != TextFieldType.INPUT)
			{
				txt.mouseEnabled = false;
				txt.selectable = false;
				txt.mouseWheelEnabled = false;
				
				if (txt.text.length != 0 && txt.name.lastIndexOf("_fix") == -1)
				txt.autoSize = txt.getTextFormat(0).align;
			}
			else
			{
				//解决字体变化高度不够显示问题
				txt.height += 5;
			}
			
		}
		
		static public function bindUI(bindTarget:BaseUI, res:DisplayObject):void
		{
			
			if (res == null) throw new Error(bindTarget + "绑定资源为空！");
			
			bindTarget.name = res.name;
			bindTarget.x = res.x;
			bindTarget.y = res.y;
			res.x = 0;
			res.y = 0;
			bindTarget.addChild(res);
			
			var resource:MovieClip = res as MovieClip;
			
			if (null == resource) return;
			
			var list_property:Array = getPropertyList(bindTarget);
			
			var src:DisplayObject;
			
			//国际化同名资源替换和国际化文本自动赋值
			var i:int = 0;
			var c:int = resource.numChildren;
			while (i < c) 
			{
				
				src = resource.getChildAt(i) as DisplayObject;
				
				///获取资源类名，如果是自定义类名则查找当前类容器中是否有同名资源，有则替代
				var className:String = getQualifiedClassName(src);
				if (className != "flash.display::MovieClip" && className != "flash.text::TextField")
				{
					var rpCls:Class = ClassManager.getClassFromCurDomain(className);
					if (null != rpCls)
					{
						
						var newSrc:DisplayObject = new rpCls;
						newSrc.transform = src.transform;
						
						resource.removeChild(src);
						resource.addChildAt(newSrc, i);
						
						resource[src.name] = newSrc;
						
					}
				}
				
				i++;
			}
			
			
			//递归绑定
			for each(var property:Property in list_property)
			{
				
				src = resource[property.name] as DisplayObject;
				
				if (src == null) continue;
				
				var srcIndex:int = resource.getChildIndex(src);
				
				
				//如果目标对象的相应属性为空，则检查该属性是否为需要绑定的类型，如果是，为该属性进行初始化。
				if (bindTarget[property.name] == null)
				{
					var targetProperty:*;
					//try
					{
						targetProperty= new property.type();
					}
					//catch (e:Error)
					//{
						
					//}
					
					if (targetProperty is BaseUI) bindTarget[property.name] = targetProperty;
					
				}
				
				
				var bindObj:BaseUI = bindTarget[property.name] as BaseUI;
				if (bindObj != null)
				{
					
					bindObj.bind(src);
					
				}
				else
				{
					
					if (src != null) 
					bindTarget[property.name] = src;
					
				}
				
				if (bindTarget[property.name] != null)
				{
					
					resource.addChildAt(bindTarget[property.name], srcIndex);
					
				}
				
				
				//if (resource[proName] == null)
				//{
					//throw new Error("绑定资源未找到元件！  " + bindTarget + "," + getQualifiedClassName(src) +"," + proName);
				//}
			}
			
		}
		
		
		//static public function bindUIComponent(bindTarget:BaseUIComponent, resource:DisplayObject):void
		//{
			//
			//if (resource == null) throw new Error("绑定资源为空！");
			//bindTarget.name = resource.name;
			//bindTarget.x = resource.x;
			//bindTarget.y = resource.y;
			//resource.x = 0;
			//resource.y = 0;
			//bindTarget.addChild(resource);
			//
		//}
		
		/**
		 * 在指定mc的所有帧上查找指定名称的子对象并返回
		 * @param	mc
		 * @param	childName
		 * @return
		 */
		static private function getMovieClipChild(mc:MovieClip, childName:String):DisplayObject
		{
			
			var curFrame:int = mc.currentFrame;
			
			var i:int = 1;
			var c:int = mc.totalFrames;
			
			while (i <= c)
			{
				
				mc.gotoAndStop(i);
				
				var res:DisplayObject = mc.getChildByName(childName);
				if (null != res) break;
				
				i++;
				
			}
			
			//mc.gotoAndStop(curFrame);
			
			return res;
			
		}
		
		/**
		 * 获取对象的属性列表
		 * @param	target
		 * @return
		 */
		static private function getPropertyList(target:BaseUI):Array
		{
			var list_property:Array = [];
			
			var property:Property;
			
			var xml_target:XML = target.describeXML;
			
			//System.setClipboard(xml_target);
			
			var xmlList_variable:XMLList = xml_target.variable;
			for each(var xml_variable:XML in xmlList_variable)
			{
				
				property = new Property();
				property.name = String(xml_variable.@name);
				property.type = getDefinitionByName(String(xml_variable.@type)) as Class;
				
				list_property.push(property);
				
			}
			
			///存取器属性忽略
			
			//var xmlList_accessor:XMLList = xml_target.accessor;
			//for each(var xml_accessor:XML in xmlList_accessor)
			//{
				//
				//if (String(xml_accessor.@access) == "readwrite")
				//{
					//
					//property = new Property();
					//property.name = String(xml_accessor.@name);
					//property.type = getDefinitionByName(String(xml_accessor.@type)) as Class;
					//list_property.push(property);
					//
				//}
				//
				//
			//}
			
			return list_property;
		}
		
		/**
		 * 过滤目标的属性
		 * @param	target		过滤的对象
		 * @param	type			属性类别
		 * @return
		 */
		static public function filterProperty(target:BaseUI, type:Class):Array
		{
			
			var list_property:Array = getPropertyList(target);
			
			var list:Array = [];
			
			var i:int = 0;
			var c:int = list_property.length;
			
			while (i < c) 
			{
				
				var property:Property = list_property[i];
				
				if (target[property.name] is type)
				{
					list.push(property.name);
				}
				
				i++;
				
			}
			
			return list;
			
		}
		
	}

}
class Property
{
	
	public var name:String;
	public var type:Class;
	
	
}