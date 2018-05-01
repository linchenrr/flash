package org.superkaka.KLib.net.rpc.sim 
{
	import org.superkaka.KLib.utils.Json;
	/**
	 * 模拟数据转换器
	 * @author ｋａｋａ
	 */
	public class SimDataTableDecoder
	{
		
		
		static public function decode(obj_or_JOSN:*):SimDataTable
		{
			
			var tableObj:Object;
			
			if (obj_or_JOSN is String)
			tableObj = Json.decode(obj_or_JOSN);
			else
			tableObj = obj_or_JOSN;
			
			var table:SimDataTable = new SimDataTable();
			
			for(var procedureId:String in tableObj)
			{
				
				var dataObj:Object = tableObj[procedureId];
				
				var simData:SimData = new SimData();
				
				simData.procedureId = uint(procedureId);
				
				simData.description = dataObj["description"];
				simData.simParam = dataObj["param"];
				simData.simReturn = dataObj["return"];
				
				transformObject(simData.simParam);
				transformObject(simData.simReturn);
				
				table.addSimData(simData);
				
			}
			
			return table;
			
		}
		
		static public function transformObject(obj:Object):Object
		{
			
			for (var key:* in obj)
			{
				
				if (obj[key] is String)
				{
					obj[key] = transformString(obj[key]);
				}
				else
				{
					transformObject(obj[key]);
				}
				
			}
			
			return obj;
			
		}
		
		static private const reg:RegExp =/^\[(.+?)\((.*?)\)\]$/;
		
		static public function transformString(str:String):*
		{
			
			var m:Array = str.match(reg);
			if (null != m && m.length == 3)
			{
				
				var type:String = m[1];
				var value:String = m[2];
				
				switch(type)
				{
					
					case "Date":
						return parseDate(value);
						
				}
				
			}
			
			return str;
			
		}
		
		static private function parseDate(value:String):Date
		{
			
			var date:Date = new Date();
			
			if (value == "") return date;
			var arr:Array = value.split(",");
			
			if (arr[0] != null && arr[0] != "")
			{
				var arr_date:Array = arr[0].split("-");
				date.fullYear=(arr_date[0]);
				date.month=(arr_date[1] - 1);
				date.date=(arr_date[2]);
			}
			
			
			if (arr[1] != null && arr[1] != "")
			{
				var arr_time:Array = arr[1].split(":");
				date.hours = arr_time[0];
				date.minutes = arr_time[1];
				date.seconds = arr_time[2];
			}
			
			return date;
			
		}
		
	}

}