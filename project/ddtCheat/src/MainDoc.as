
	//import fl.controls.Button;
	//import fl.controls.RadioButton
	//import fl.controls.RadioButtonGroup;
	import flash.display.DisplayObject;
	import flash.display.Graphics;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.filters.GlowFilter;
	import flash.net.LocalConnection;
	import flash.net.SharedObject;
	import flash.system.Capabilities;
	
	import mx.containers.Canvas;
	import mx.controls.Label;
	import mx.controls.RadioButton;
	import mx.core.BitmapAsset;
	
	/**
	 * ...
	 * @author ｋａｋａ
	 */

		///距离测试面板
		var disPanel:DistancePanel;
		
		///横向距离
		private var dis:Distance=new Distance(0,0);
		
		///临时应急用测量小地图距离面板
		private var tmpRect:TempRectangel;
		
		///风速
		private var wind:Number = 0;
		///风速整数
		private var wind_num:int;
		///风速小数
		private var wind_point:int;
		
		///风向 右为true,左为false
		private var windDirection:Boolean = true;
		///左打右还是右打左
		private var targetDirection:Boolean = true;
		///地图选择面板
		private var mapChosePanel:MapChoosePanel;
		///xml加载类
		private var xmlLoader:XmlLoader;
		///xml地址
		private var url_xml:String="mapInfo.xml";
		///系统托盘的图标
		[Embed(source="stuff/status16.png")]
		private var cls_icon16:Class; 
		
		///通信对象
		private var loc:LocalConnection=new LocalConnection();
		
		//[Embed(source="stuff/icon128.png")]
		//private var cls_icon128:Class; 
		
		/*
		private var lb_zp_angle:TextField;
		private var lb_zp_power:TextField;
		private var lb_bp_angle:TextField;
		private var lb_bp_power:TextField;
		private var lb_70_angle:TextField;
		private var lb_70_power:TextField;
		private var lb_70_angle_back:TextField;
		private var lb_70_power_back:TextField;
		private var lb_60_angle:TextField;
		private var lb_60_power:TextField;
		private var lb_60_angle_back:TextField;
		private var lb_60_power_back:TextField;
		private var lb_30_angle:TextField;
		private var lb_30_power:TextField;
		*/
		
		
		public function start():void 
		{
			/*
			if(!checkTime())
			{
				return;
			}
			*/
			
			//this.nativeWindow.width=Capabilities.screenResolutionX;
			//this.nativeWindow.height=Capabilities.screenResolutionY;
			this.width=Capabilities.screenResolutionX;
			this.height=Capabilities.screenResolutionY;
			this.nativeWindow.x=0;
			this.nativeWindow.y=0;
			trace("!!--  ",this.nativeApplication.applicationID)
			
			this.nativeApplication.icon.bitmaps =[(new cls_icon16() as BitmapAsset).bitmapData];
			
			stage.scaleMode = StageScaleMode.NO_SCALE;
			init();
			//loc.allowDomain("*");
			//loc.connect("_kaka");
			//loc.client=this;
			trace(loc.client)
		}
		
		public function updateWind(num:int,point:int):void
		{
			trace("updateWind!",num,"---",point);
		}
		
		//使用次数
		private const useCount:int = 10 ;
		
		function checkTime():Boolean
		{
			var so:SharedObject = SharedObject.getLocal("ddtCheat");
			
			if(so.data["ddt"]==null)
			{
				so.data["ddt"]= 1;
				so.flush();
			}
			
			var ddtCount:int = int(so.data["ddt"]);
			
			if (ddtCount > useCount)
			{
				txt_count.text = "已经超过" + useCount + "次使用次数";
				return false;
			}
			else
			{
				txt_count.text = "剩余使用次数:" + (useCount - ddtCount);
				so.data["ddt"]=ddtCount + 1;
				so.flush();
				return true;
			}
		}
		
		
		//===============================================
		///初始化
		//===============================================
		public function init():void
		{			
			initView();
			initControl();
			
			//ddl_map.dispatchEvent(new ListEvent(ListEvent.CHANGE));
		}
		
		private function initView():void
		{
			
			disPanel = new DistancePanel(400, 180);
			disPanel.x=0;
			disPanel.y=40;
			sp_distence.addChild(disPanel);
			
			btn_disContriler.label = "测屏距";
			
			btn_hideDispanel.label="隐藏";
			
			
			//ddl_map.dataProvider=MapInfo.ARR_MAP_RECT_INFO;
			
			initRadioButtons();
			
			mapChosePanel=new MapChoosePanel(sp_mapChoose,disPanel,lb_map);
			
			drawBG(sp_wind);
			//drawBG(sp_angle);
			drawBG(sp_distence,0.1);
			drawBG(sp_mapChoose);
			
			xmlLoader=new XmlLoader(mapChosePanel);
			xmlLoader.load(url_xml);
			
//			this.tmpRect=new TempRectangel(disPanel,lb_map);
//			tmpRect.visible=false;
//			tmpRect.x=sp_distence.x;
//			tmpRect.y=sp_distence.y+80;
//			
//			this.addChildAt(tmpRect,0);
			drawShadow();
		}
		
		private function drawShadow():void
		{
			var c:int=sp_angle.numChildren;
			for(var i:int=0;i<c;i++)
			{
				var lb:DisplayObject=sp_angle.getChildAt(i) as DisplayObject;
				
				lb.filters=[new GlowFilter(0xffffff,0.9,3,3,4,3)];
			}
		}
		
		private function drawBG(sp:Canvas,alpha:Number=0.8):void
		{			
			var gr:Graphics=sp.graphics;
			gr.clear();
			gr.lineStyle(4,0x58baf9,0.6);
			gr.beginFill(0xffffff,alpha);
			gr.drawRoundRect(0,0,sp.width,sp.height,25,25);
			gr.endFill();
		}
		
		
		private function initControl():void
		{
			btn_disContriler.addEventListener(MouseEvent.CLICK, btn_disContrilerClickHandler);
			btn_disContriler.addEventListener(MouseEvent.MOUSE_DOWN, btn_disContrilerMouseDownHandler);
			btn_hide.addEventListener(MouseEvent.CLICK, btn_hideClickHandler);
			btn_hide.addEventListener(MouseEvent.MOUSE_DOWN, btn_disContrilerMouseDownHandler);
			disPanel.addEventListener(DistanceEvent.DIS_UPDATE, disUpdateHandler);
			disPanel.addEventListener(MapInfoEvent.Info_Change,mapInfoChangeHandler);
			mapChosePanel.addEventListener(MapInfoEvent.Info_Change,mapInfoChangeHandler);
			
			
			btn_hideDispanel.addEventListener(MouseEvent.CLICK, btn_hideDispanelClickHandler);
			
			btn_rect_reduce.addEventListener(MouseEvent.CLICK, btn_rect_reduceClickHandler);
			btn_rect_add.addEventListener(MouseEvent.CLICK, btn_rect_addClickHandler);
			
//			sp_distence.addEventListener(MouseEvent.ROLL_OVER,sp_distenceROLL_OVERHandler);
//			sp_distence.addEventListener(MouseEvent.ROLL_OUT,sp_distenceROLL_OUTHandler);
			
			stage.addEventListener(MouseEvent.MOUSE_UP, endDrag);
			
			//ddl_map.addEventListener(ListEvent.CHANGE,ddl_mapChangeHandler);			
		}
		
		///初始化单选按钮
		private function initRadioButtons():void
		{
			var rd_left:RadioButton = new RadioButton();
			rd_left.value = false;
			rd_left.label = "左";
			rd_left.x = 122;
			rd_left.y = 3;
			sp_wind.addChild(rd_left);
			
			var rd_right:RadioButton = new RadioButton();
			rd_right.value = true;
			rd_right.label = "右";
			rd_right.x = 196;
			rd_right.y = 3;
			sp_wind.addChild(rd_right);
			
			rd_left.groupName = "风向组";
			rd_right.groupName = "风向组";
			
			rd_left.addEventListener(MouseEvent.CLICK, windDirectionChangeHandler);
			rd_right.addEventListener(MouseEvent.CLICK, windDirectionChangeHandler);
			
			rd_right.selected = true;
			
			var stx:int = 100;
			for (var i:int = 0; i < 6; i++)
			{
				var rd_wind_num:RadioButton = new RadioButton();
				rd_wind_num.groupName = "风向整数";
				rd_wind_num.label = i.toString();
				rd_wind_num.value = i;
				rd_wind_num.x = stx;
				rd_wind_num.y = 25;
				sp_wind.addChild(rd_wind_num);
				
				rd_wind_num.addEventListener(MouseEvent.CLICK, rd_wind_numClickHandler);
				
				stx += 32;
			}
			
			stx = 100;
			for (var j:int = 0; j < 10; j++)
			{
				var rd_wind_point:RadioButton = new RadioButton();
				rd_wind_point.groupName = "风向小数";
				rd_wind_point.label = j.toString();
				rd_wind_point.value = j;
				rd_wind_point.x = stx;
				rd_wind_point.y = 48;
				sp_wind.addChild(rd_wind_point);
				
				rd_wind_point.addEventListener(MouseEvent.CLICK, rd_wind_pointClickHandler);
				
				stx += 32;
			}
			
		}
		
		///置顶
		public function setTop(sp:Canvas):void
		{
			//this.addChild(sp);
			this.setChildIndex(sp,this.numChildren-1);
		}
		
		///重新计算
		private function updateCount():void
		{
			var wind:Number = wind_num + wind_point / 10;
			
			if (windDirection != targetDirection)
			{
				wind = -wind;
			}
			
			AngleCounter.fixOffset(wind);
			
            var ap_zp:AngleAndPower = AngleCounter.getZPAngleAndPower(dis, wind);
            var ap_bp:AngleAndPower = AngleCounter.getBPAngleAndPower(dis, wind);
            //半抛
            var ap_Hzp:AngleAndPower = AngleCounter.getHalfZPAngleAndPower(dis, wind);
            var ap_Hbp:AngleAndPower = AngleCounter.getHalfBPAngleAndPower(dis, wind);
            var ap_70:AngleAndPower = AngleCounter.getAngleAndPowerBy70(dis, wind);
            var ap_70_back:AngleAndPower = AngleCounter.getAngleAndPowerBy70_back(dis, wind);
            var ap_65:AngleAndPower = AngleCounter.getAngleAndPowerBy65(dis, wind);
            var ap_65_back:AngleAndPower = AngleCounter.getAngleAndPowerBy65_back(dis, wind);
            var ap_60:AngleAndPower = AngleCounter.getAngleAndPowerBy60(dis, wind);
            var ap_60_back:AngleAndPower = AngleCounter.getAngleAndPowerBy60_back(dis, wind);
            var ap_30:AngleAndPower = AngleCounter.getAngleAndPowerBy30(dis, wind);
			
	     	lb_zp_angle.text = getStr(ap_zp.angle);
            lb_zp_power.text = getStr(ap_zp.power);
            
            lb_Hzp_angle.text = getStr(ap_Hzp.angle);
            lb_Hzp_power.text = getStr(ap_Hzp.power);

            lb_bp_angle.text = getStr(ap_bp.angle);
            lb_bp_power.text = getStr(ap_bp.power);
            
            lb_Hbp_angle.text = getStr(ap_Hbp.angle);
            lb_Hbp_power.text = getStr(ap_Hbp.power);

            lb_70_angle.text = getStr(ap_70.angle);
            lb_70_power.text = getStr(ap_70.power);

            lb_70_angle_back.text = getStr(ap_70_back.angle);
            lb_70_power_back.text = getStr(ap_70_back.power);
            
            lb_65_angle.text = getStr(ap_65.angle);
            lb_65_power.text = getStr(ap_65.power);

            lb_65_angle_back.text = getStr(ap_65_back.angle);
            lb_65_power_back.text = getStr(ap_65_back.power);

            lb_60_angle.text = getStr(ap_60.angle);
            lb_60_power.text = getStr(ap_60.power);

            lb_60_angle_back.text = getStr(ap_60_back.angle);
            lb_60_power_back.text = getStr(ap_60_back.power);

            lb_30_angle.text = getStr(ap_30.angle);
            lb_30_power.text = getStr(ap_30.power);
		}
		
		private function getStr(s:int):String
		{
			return s.toString();
		}
		
		private var disMode:Boolean;
		///更改距离面板显示
		private function changeDIsPanelView():void
		{
			disMode=!disMode;
			if (disMode)
			{
				//disPanel.visible = false;
				btn_disContriler.label = "量边框";
				//sp_distence.height=60;
				//drawBG(sp_distence);
				
				//changeTmpRectView();
			}
			else
			{
				//disPanel.visible = true;
				btn_disContriler.label = "测屏距";
				//sp_distence.height=220;
				//drawBG(sp_distence,0.1);
				
				//changeTmpRectView();
			}
			
			disPanel.changeMode(disMode);
		}
		
		private var isShowDispanel:Boolean=true;
		private function btn_hideDispanelClickHandler(evt:MouseEvent):void
		{
			
			if (isShowDispanel)
			{
				disPanel.visible = false;
				btn_hideDispanel.label="显示";
				sp_distence.height=60;
				drawBG(sp_distence);
				
				//changeTmpRectView();
			}
			else
			{
				disPanel.visible = true;
				btn_hideDispanel.label = "隐藏";
				sp_distence.height=220;
				drawBG(sp_distence,0.01);
				
				//changeTmpRectView();
			}
			isShowDispanel=!isShowDispanel;
		}

//		private function sp_distenceROLL_OVERHandler(evt:MouseEvent):void
//		{
//			disPanel.visible = true;
//			
//			sp_distence.height=220;
//			drawBG(sp_distence,0.1)
//		}
//
//		private function sp_distenceROLL_OUTHandler(evt:MouseEvent):void
//		{
//			disPanel.visible = false;
//			
//			sp_distence.height=60;
//			drawBG(sp_distence);
//		}
		
		private function changeTmpRectView():void
		{
//			this.tmpRect.visible=!this.disPanel.visible;
		}
		
		//===============================================
		///事件
		//===============================================
		///距离控制按钮点击
		private function btn_disContrilerClickHandler(evt:MouseEvent):void
		{
			changeDIsPanelView();
		}
		
		private function btn_hideClickHandler(evt:MouseEvent):void
		{
			if(btn_hide.label=="全部隐藏")
			{
				btn_hide.label="显示";
				sp_wind.visible=false;
				sp_angle.visible=false;
				sp_distence.visible=false;
				sp_mapChoose.visible=false;
//				tmpRect.visible=false;
			}
			else
			{
				btn_hide.label="全部隐藏";
				sp_wind.visible=true;
				sp_angle.visible=true;
				sp_distence.visible=true;
				sp_mapChoose.visible=true;
//				changeTmpRectView();
			}
			
		}
		
		private function btn_rect_reduceClickHandler(evt:MouseEvent):void
		{
			disPanel.spaceX-=1;
			lb_rect.text=disPanel.spaceX.toString();
		}	

		private function btn_rect_addClickHandler(evt:MouseEvent):void
		{
			disPanel.spaceX+=1;
			lb_rect.text=disPanel.spaceX.toString();
		}
		
		private function btn_disContrilerMouseDownHandler(evt:MouseEvent):void
		{
			evt.stopPropagation();
		}		
		
		///地图信息更新
		private function mapInfoChangeHandler(evt:MapInfoEvent):void
		{
			lb_rect.text=evt.width.toString();
			
			disPanel.spaceX=evt.width;
			
			lb_map.text="自定义";
		}
		
		///距离更新
		private function disUpdateHandler(evt:DistanceEvent):void
		{
			this.targetDirection = evt.direction;
			this.dis=evt.distance;
			lb_distance.text=(dis.disX+dis.offsetX).toFixed(1).toString();
			updateCount();
		}
		
		///风向改变
		private function windDirectionChangeHandler(evt:Event):void
		{
			var rd:RadioButton = evt.target as RadioButton;
			windDirection = rd.value;
			updateCount();
		}
		
		///风速整数改变
		private function rd_wind_numClickHandler(evt:MouseEvent):void
		{
			var rd:RadioButton = evt.target as RadioButton;
			wind_num = int(rd.value);
			updateCount();
		}
		
		///风速小数改变
		private function rd_wind_pointClickHandler(evt:MouseEvent):void
		{
			var rd:RadioButton = evt.target as RadioButton;
			wind_point = int(rd.value);
			updateCount();
		}
		
		///停止拖动
		private function endDrag(evt:MouseEvent):void
		{
			sp_wind.stopDrag();
			sp_angle.stopDrag();
			sp_distence.stopDrag();
			sp_mapChoose.stopDrag();
		}
		/*
		///ddl_map改变
		private function ddl_mapChangeHandler(evt:ListEvent):void
		{
			disPanel.spaceX=ddl_map.selectedItem.data;
			updateCount();
		}
*/