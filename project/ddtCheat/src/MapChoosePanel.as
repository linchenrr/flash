package 
{
	import flash.events.MouseEvent;
	import flash.events.TextEvent;
	import flash.text.TextFieldType;
	
	import mx.containers.Canvas;
	import mx.controls.Button;
	import mx.controls.Label;
	import mx.core.UITextField;
	import mx.flash.UIMovieClip;
	
	/**
	 * ...
	 * @author ｋａｋａ
	 */
	public class MapChoosePanel extends UIMovieClip
	{
		//最大宽度
		private var max_w:int;
		//地图xml信息
		private var xml_map:XML;
		//显示当前地图名称
		private var lb_map:Label;
		private var arr_btn:Array;
		
		//dispanel实例
		private var dispanel:DistancePanel;
		
		///用于搜索的文本框
		private var txt_search:UITextField;
		
		private var cav:Canvas;
		///按钮的起始坐标
		private const stx:int=10;
		private const sty:int=60;
		///按钮的坐标增加值
		private const addx:int=95;
		private const addy:int=30;
		
		public function MapChoosePanel(cav:Canvas,dispanel:DistancePanel,lb_map:Label):void
		{
			this.cav=cav;
			this.dispanel=dispanel;
			this.lb_map=lb_map;		
			
			max_w=cav.width - 10;
			
			arr_btn=[];	
		}
		
		///更新地图xml信息
		public function set mapInfo(value:XML):void
		{
			this.xml_map=value;
			initMapBtns();
		}
		
		private function initMapBtns():void
		{
			var c:int=xml_map.map.length();
			var cx:int=stx;
			var cy:int=sty;
			
			var map:XML;
			
			for(var i:int=0;i<c;i++)
			{
				map=xml_map.map[i];
				map["btnIndex"]=i;
				var btn:Button=new Button();
				btn.label=map.label;
				
				if(cx+btn.width>max_w)
				{
					cx=stx;
					cy+=30;
				}
				
				btn.x=cx;
				btn.y=cy;
				
				btn.data={x:cx,y:cy,width:map.width,height:map.height,p:map.p};
				btn.addEventListener(MouseEvent.CLICK,btnClickHandler);
				
				cx+=addx;
				
				
				cav.addChildAt(btn,0);
				
				arr_btn[i]=btn;
			}
			
			map=xml_map.map[0];
			
			//dispanel.spaceX=Number(map.width);
			dispatchEvent(new MapInfoEvent(MapInfoEvent.Info_Change,Number(map.width)));
			
			lb_map.text=map.label;
			
			txt_search=new UITextField();
			txt_search.width=60;
			txt_search.height=20
			txt_search.x=100;
			txt_search.y=20;
			txt_search.selectable=true;
			txt_search.type=TextFieldType.INPUT;
			txt_search.border=true;
			txt_search.addEventListener(TextEvent.TEXT_INPUT,txt_searchChangeHandler);
			txt_search.addEventListener(MouseEvent.MOUSE_DOWN,txt_searchMdHandler);
			cav.addChild(txt_search);
		}
		
		private function btnClickHandler(evt:MouseEvent):void
		{
			var btn:Button=evt.target as Button;
			//dispanel.spaceX=Number(btn.data.width);
			
			dispatchEvent(new MapInfoEvent(MapInfoEvent.Info_Change,Number(btn.data.width)));
			
			lb_map.text=btn.label;
		}
		
		private function txt_searchChangeHandler(evt:TextEvent):void
		{
			txt_search.text="";
			while(cav.numChildren>1)
			{
				cav.removeChildAt(0);
			}
			var str:String=evt.text;
			
			if(str==" ")
			{
				for each(var btn:Button in arr_btn)
				{
					btn.x=btn.data.x;
					btn.y=btn.data.y;
					cav.addChildAt(btn,0);
				}
			}
			else
			{
				var arr:XMLList=xml_map.map.(p==str);
				var c:int=arr.length();
				var cx:int=10;
				var cy:int=60;
				for each(var map:XML in arr)
				{
					var btn:Button=arr_btn[map.btnIndex];
					btn.x=cx;
					btn.y=cy;
					
					cx+=addx;
					if(cx>max_w)
					{
						cx=stx;
						cy+=30;
					}
				
					cav.addChildAt(btn,0);
				}
			}
		}
		
		private function txt_searchMdHandler(evt:MouseEvent):void
		{
			evt.stopPropagation();
		}
		
	}
}