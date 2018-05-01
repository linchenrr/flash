

  
  
  
  










  








//#define StatusManager_USE_MULTI_ST_MACHINE
//#StatusManager_INLINE_STATUS










//#define MASK_STAGE_AREAR
//#define HIDE_BUILT_IN_ITEM






  






//@MACRO Base64_USE_FAST_TABLEG ENG: when defiend :decode 25% faster and encode 10% faster but cost more byteCode and more runtime memery and 64 more String in String pool






































  
  
  
  
  
  

  
  




















	
	

																			   //10.0.2.54
	
	
	
	











































//@ setting start
//@ USE_ARRAY_STAUTS
//@ INLINE_STATUS
//@ setting end

//@ config start

//@ config end


























































//#define StatusManager_USE_MULTI_ST_MACHINE
//#StatusManager_INLINE_STATUS










//#define MASK_STAGE_AREAR
//#define HIDE_BUILT_IN_ITEM











//@ setting start
//@ ENABLE_CHECK_SOUND_PAYING
//@ SUPPORT_LOAD_SOUND_OUT
//@ setting end








//@ setting start
//@MACRO StatusManager_USE_MULTI_ST_MACHINE 使用多层状态机 ,打开后状态机变成2维数组,第一维是状态机的编号
//@MACRO StatusManager_INLINE_STATUS 将STATUS STATUS_MC 等等内联,可以提高一点速度,打开多层状态机后,可能会增加文件容量
//@MACRO StatusManager_MACHINE_USE_SUB_STATUS	给每个状态机增加一个子状态,不使用时关闭以节约内存
//@ setting end







	
	






  




















	
	



  








	
	

																			   //10.0.2.54
	
	
	
	



  
  
    
    
	
		
	
	
	
  //DUMP_CONST

	
		
		
	
	

	
		
	

	
	
	
	
	





package   BSS.Util.BA_Util   { 
	
	import flash.utils.*;
	public class  Base64 {
    
    
    
      

	private static  var BASE64_CHARS_ARRAY : Vector.< String >  =    
                Vector.< String > (['A','B','C','D','E','F','G','H',   
                'I','J','K','L','M','N','O','P',   
                'Q','R','S','T','U','V','W','X',   
                'Y','Z','a','b','c','d','e','f',   
                'g','h','i','j','k','l','m','n',   
                'o','p','q','r','s','t','u','v',   
                'w','x','y','z','0','1','2','3',   
                '4','5','6','7','8','9','+','/']);

		

	private static  var BASE64_DECODE_CHARS_ARRAY : Vector.< int >   = 
		Vector.< int > 
	(       [64, 64, 64, 64, 64, 64, 64, 64,   
                64, 64, 64, 64, 64, 64, 64, 64,   
                64, 64, 64, 64, 64, 64, 64, 64,   
                64, 64, 64, 64, 64, 64, 64, 64,   
                64, 64, 64, 64, 64, 64, 64, 64,   
                64, 64, 64, 62, 64, 64, 64, 63,   
                52, 53, 54, 55, 56, 57, 58, 59,   
                60, 61, 64, 64, 64, 64, 64, 64,   
                64,  0,  1,  2,  3,  4,  5,  6,   
                 7,  8,  9, 10, 11, 12, 13, 14,   
                15, 16, 17, 18, 19, 20, 21, 22,   
                23, 24, 25, 64, 64, 64, 64, 64,   
                64, 26, 27, 28, 29, 30, 31, 32,   
                33, 34, 35, 36, 37, 38, 39, 40,   
                41, 42, 43, 44, 45, 46, 47, 48,   
                49, 50, 51, 64, 64, 64, 64, 64]);
	

        	public static function Base64_encodeByteArray 	(data:ByteArray)
		:String {
			// Initialise output
			var output:String = "";
			
			// Rewind ByteArray
			data.position = 0;
			var data_bytesAvailable : int = data.bytesAvailable ;
			// while there are still bytes to be processed
			var cycle : int = data_bytesAvailable / 3;
			
			var dataPos : int ;
			while (cycle)
			{
				cycle--;

				var c : int  = data[dataPos++] << 16 | data[dataPos++] << 8 | data[dataPos++];
				output += BASE64_CHARS_ARRAY[ c >> 18 & 0x3f ] 
					+ BASE64_CHARS_ARRAY[ c >> 12 & 0x3f ] 
					+ BASE64_CHARS_ARRAY[ c >> 6 & 0x3f ] 
					+ BASE64_CHARS_ARRAY[ c & 0x3f ] 
						
			//output += BASE64_CHARS.charAt((data[dataPos] & 0xfc) >> 2)
			//		+ BASE64_CHARS.charAt(((data[dataPos++] & 0x03) << 4) | ((data[dataPos]) >> 4))
			//		+ BASE64_CHARS.charAt(((data[dataPos++] & 0x0f) << 2) | ((data[dataPos]) >> 6))
			//		+ BASE64_CHARS.charAt(data[dataPos++] & 0x3f)
			//;
				
			//	output += BASE64_CHARS.charAt((data[dataPos] & 0xfc) >> 2)
			//			+ BASE64_CHARS.charAt(((data[dataPos] & 0x03) << 4) | ((data[dataPos+1]) >> 4))
			//			+ BASE64_CHARS.charAt(((data[dataPos+1] & 0x0f) << 2) | ((data[dataPos+2]) >> 6))
			//			+ BASE64_CHARS.charAt(data[dataPos+2] & 0x3f)
			//	;
			//	dataPos += 3;

			
			}
			if (data_bytesAvailable % 3 == 1)
			{
				output += BASE64_CHARS_ARRAY[ (data[dataPos] & 0xfc) >> 2 ] 
						+ BASE64_CHARS_ARRAY[ ((data[dataPos] & 0x03) << 4) ] 
						+ "==";
				;
				
			}
			else if (data_bytesAvailable % 3 == 2)
			{
				output += BASE64_CHARS_ARRAY[ (data[dataPos] & 0xfc) >> 2 ] 
						+ BASE64_CHARS_ARRAY[ ((data[dataPos++] & 0x03) << 4) | ((data[dataPos]) >> 4) ] 
						+ BASE64_CHARS_ARRAY[ ((data[dataPos] & 0x0f) << 2) ] 
						+ "=";
			
			//	output += BASE64_CHARS.charAt((data[dataPos] & 0xfc) >> 2)
			//			+ BASE64_CHARS.charAt(((data[dataPos] & 0x03) << 4) | ((data[dataPos+1]) >> 4))
			//			+ BASE64_CHARS.charAt(((data[dataPos+1] & 0x0f) << 2))
			//			+ "=";
				
			}
			
			
			// Return encoded data
			return output;
		}





		public static function	Base64_decodeToByteArray(data : String)
		: ByteArray {
			// Initialise output ByteArray for decoded data
			var output:ByteArray = new ByteArray();
			
			// Create data and output buffers
			//var dataBuffer_0 : int;
			var dataBuffer_1 : int;
			var dataBuffer_2 : int;
			var dataBuffer_3 : int;
			
			// While there are data bytes left to be processed
			var stringLength : int = data.length;
			
			output.length = (stringLength * 3 ) >> 2;
			var outputPt : int ;
			for (var i:int = 0; i < stringLength; i += 4) {
				
				
				//dataBuffer_0 = BASE64_CHARS.indexOf(data.charAt(i ));
				dataBuffer_1 = BASE64_DECODE_CHARS_ARRAY[( data .charCodeAt( (i + 1)  ))] ;
				dataBuffer_2 = BASE64_DECODE_CHARS_ARRAY[( data .charCodeAt( (i + 2)  ))] ;
				dataBuffer_3 = BASE64_DECODE_CHARS_ARRAY[( data .charCodeAt( (i + 3)  ))] ;
				
				
				output[outputPt++] = ((BASE64_DECODE_CHARS_ARRAY[( data .charCodeAt( (i )  ))]  << 2) + ((dataBuffer_1 & 0x30) >> 4));
				output[outputPt++] = (((dataBuffer_1 & 0x0f) << 4) + ((dataBuffer_2 & 0x3c) >> 2));
				output[outputPt++] = (((dataBuffer_2 & 0x03) << 6) + dataBuffer_3);
			}
			
			
			if (dataBuffer_2 == 64)
				output.length -= 2;
			else if (dataBuffer_3 == 64)
			{	
				//trace ("here");
				output.length --;	
			
			}

			output.position = 0;	
			// Return decoded data
			return output;
		}








            public static function Base64_init() : void {};



	
		public static function Base64_dispose() : void {	Base64.BASE64_DECODE_CHARS_ARRAY = null; Base64.BASE64_CHARS_ARRAY = null;}
	



    
  }
}
