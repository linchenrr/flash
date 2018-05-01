package lyrics
{	
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	/**
	* ...
	* @author kaka
	* @version 0.2
	* @date 08/9/15
	*/
	public class SplitLyrics
	{
		static public function split(lyrics:String):Array
		{
			var l:String = lyrics;
			
			//获取歌曲信息
			//歌曲名
			var reg_soundname:RegExp =/\[ti:(.+?)\]/i;
			//歌手
			var reg_singer:RegExp =/\[ar:(.+?)\]/i;
			//专辑
			var reg_CD:RegExp =/\[al:(.+?)\]/i;
			//歌词作者
			var reg_maker:RegExp =/\[(by:.+?)\]/i;
			
			var arr_soundname:Array = l.match(reg_soundname);
			var arr_singer:Array = l.match(reg_singer);
			var arr_CD:Array = l.match(reg_CD);
			var arr_maker:Array = l.match(reg_maker);
			
			var info:String = "";
			if (arr_soundname != null)
			{
				info += "歌曲:" + arr_soundname[1] + "  ";
			}
			if (arr_singer != null)
			{
				info += "歌手:" + arr_singer[1] + "  ";
			}
			if (arr_CD != null)
			{
				info += "专辑:" + arr_CD[1] + "  ";
			}
			if (arr_maker != null)
			{
				info += arr_maker[1] + "  ";
			}			
			
			
			var reg_take:RegExp =/\[\d\d:\d\d\.\d\d\].*/g;
			
			//获取歌词，去除歌曲信息
			var arr_lyrics:Array = l.match(reg_take);			
			//过滤时间信息的正则
			var reg_replacetime:RegExp =/(\[\d\d:\d\d\.\d\d\])+/g;
			//获取时间信息的正则
			var reg_gettimes:RegExp =/\[\d\d:\d\d\.\d\d\]/g;
			var reg_readtime:RegExp =/\[(\d\d):(\d\d\.\d\d)\]/;
			//均衡歌词间距的正则
			var reg_dis:RegExp =/( )*$/;
			
			
			var arr_splitedLyrics:Array = new Array();
			
			//将歌曲信息放在头一个
			var arr_info:Array = [0, info];
			arr_splitedLyrics.push(arr_info);
			
			for each(var ly:String in arr_lyrics)
			{
				//获取所有的时间信息
				var arr_tmptime:Array = ly.match(reg_gettimes);
				//去除时间信息，只保留歌词以便后面形成数组
				ly = ly.replace(reg_replacetime, "");
				for (var i:int = 0; i < arr_tmptime.length; i++)
				{
					//每一个包括时间和歌词信息的数组
					var arr_single:Array = new Array();
					//解析时间为Number
					var t:String = arr_tmptime[i];
					var min:String = t.replace(reg_readtime, "$1");
					var sec:String = t.replace(reg_readtime, "$2");
					var time:Number = Number(min) * 60 + Number(sec);
					//数组第一个元素为时间
					arr_single[0] = time;
					//第二个元素为歌词
					//将这个歌词结尾的0~多个空格替换为单个空格，均衡歌词间距
					ly = ly.replace(reg_dis, " ");	
					
					arr_single[1] = ly;
					//将每一行添加进总的歌词数组
					arr_splitedLyrics.push(arr_single);
				}
			}
			//歌词排序
			arr_splitedLyrics.sortOn("0", Array.NUMERIC);
			return arr_splitedLyrics;			
		}
	}	
}