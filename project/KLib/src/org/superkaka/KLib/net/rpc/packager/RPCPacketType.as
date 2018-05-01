package org.superkaka.KLib.net.rpc.packager 
{
	/**
	 * rpc数据包类型
	 * @author		ｋａｋａ
	 * @Email		superkaka.org@gmail.com
	 * @date		2012-11-26-星期一 17:39
	 */
	public class RPCPacketType 
	{
		
		///请求包
		static public const REQUEST:uint = 1;
		///返回包
		static public const RESPONSE:uint = 2;
		///异常包，表示处理请求时出现异常
		static public const ERROR:uint = 10;
		
	}

}