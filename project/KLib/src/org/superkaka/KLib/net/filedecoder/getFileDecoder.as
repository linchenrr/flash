package org.superkaka.KLib.net.filedecoder 
{
	import org.superkaka.KLib.net.FileType;
	/**
	 * ...
	 * @author		ｋａｋａ
	 * @Email		superkaka.org@gmail.com
	 * @date		2012-11-29-星期四 17:33
	 */
	
	 /**
	  * 根据文件类型获取相应的解析器
	  * @param	fileType
	  * @return
	  */
	public function getFileDecoder(fileType:String):FileDecoder
	{
		
		fileType = FileType.getType(fileType);
		
		switch(fileType)
		{
			
			case FileType.TEXT:
				return new TextDecoder();
				
			case FileType.XML:
				return new XMLDecoder();
				
			case FileType.SWF:
			case FileType.IMAGE:
				return new MediaDecoder();
				
			case FileType.XML:
				return new XMLDecoder();
				
			case FileType.SOUND:
				return new SoundDecoder();
				
			case FileType.TABLE:
				return new TableDecoder();
				
			case FileType.LANG:
				return new LangDecoder();
				
			default:
				return null;
			
		}
		
	}

}