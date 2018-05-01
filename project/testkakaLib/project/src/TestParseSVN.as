package  
{
	import org.superkaka.kakalib.core.Engine;
	/**
	 * ...
	 * @author ｋａｋａ
	 */
	public class TestParseSVN extends Engine
	{
		
		public function TestParseSVN():void
		{
			
		}
		
		override protected function init():void
		{
			
			var entries:String = getAsset("entries");
			
			//var list_dir:Array = parseDir(entries);
			
			var list_file:Array = parseFileVersion(entries);
			
			var mainVersion:uint = parseMainVersion(entries);
			
		}
		
		private function parseMainVersion(svnStr:String):uint
		{
			
			var reg_mainVer:RegExp =/\s+dir\s+(\d+)/;
			
			var result:Array = svnStr.match(reg_mainVer);
			
			
			return result[1];
			
		}
		
		private function parseFileVersion(svnStr:String):Array
		{
			
			var reg_file:RegExp = /\S+\s+file\s+[\s\S]+?\s+\d+\s+\S+/g;
			
			
			var list_file:Array = svnStr.match(reg_file);
			var list_verson:Array=[];
			
			var i:int = 0;
			var c:int = list_file.length;
			
			var reg_replace:RegExp =/\s+(\d+)\s+\S+$/;
			
			while (i < c) 
			{
				
				var str:String = list_file[i];
				
				str = str.match(reg_replace)[1];
				
				list_verson[i] = str;
				
				i++;
				
			}
			
			
			return list_verson;
			
		}
		
		private function parseDir(svnStr:String):Array
		{
			
			var reg_dir:RegExp = /\s+[\S ]+\s+dir\s+(dir){0}/g;
			
			var list_dir:Array = svnStr.match(reg_dir);
			
			var i:int = 0;
			var c:int = list_dir.length;
			
			var reg_replaceDir:RegExp = /([\S ]+)\s+dir/;
			
			while (i < c) 
			{
				
				var str:String = list_dir[i];
				
				str = str.match(reg_replaceDir)[1];
				
				list_dir[i] = str;
				
				i++;
				
			}
			
			return list_dir;
			
		}
		
	}

}