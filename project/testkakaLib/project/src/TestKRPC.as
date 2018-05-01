package  
{
	import flash.utils.ByteArray;
	import org.superkaka.kakalib.data.KDataPackager;
	import org.superkaka.kakalib.data.KTable;
	import org.superkaka.kakalib.net.connection.KSimConnection;
	import org.superkaka.kakalib.net.connection.KSocketConnection;
	import org.superkaka.kakalib.net.rpc.KRPCError;
	import org.superkaka.kakalib.net.rpc.KRPCResult;
	import org.superkaka.kakalib.net.sim.KSimServer;
	import org.superkaka.kakalib.net.sim.SimProcedureTableTransform;
	import org.superkaka.kakalib.utils.StringTool;
	
	import org.superkaka.kakalib.core.Engine;
	import org.superkaka.kakalib.net.connection.KConnection;
	import org.superkaka.kakalib.net.connection.KHttpConnection;
	import org.superkaka.kakalib.net.rpc.KRPCClient;
	import org.superkaka.kakalib.net.rpc.KRPCPackager;
	/**
	 * ...
	 * @author ｋａｋａ
	 */
	public class TestKRPC extends Engine
	{
		
		private var rpcClient:KRPCClient;
		
		public function TestKRPC():void
		{
			
			
		}
		
		override protected function init():void
		{
			
			var kd:KDataPackager = new KDataPackager(getAsset("SkillEffect"));
			var table:KTable = kd.readTable();
			
			var kd2:KDataPackager = new KDataPackager(getAsset("SkillDict"));
			var table2:KTable = kd2.readTable();
			
			
			
			var httpConnection:KHttpConnection = new KHttpConnection();
			httpConnection.URI = "http://localhost:4054/Default.aspx";
			
			var simConnection:KSimConnection = new KSimConnection();
			var simServer:KSimServer = new KSimServer(new KRPCPackager());
			simServer.procedureTable = SimProcedureTableTransform.transformFromJson(getAsset("dataInterface"));
			simConnection.simServer = simServer;
			
			var socketConnection:KSocketConnection = new KSocketConnection("10.4.104.48", 1569);
			
			var connection:KConnection;
			//connection = socketConnection;
			//connection = httpConnection;
			connection = simConnection;
			
			rpcClient = new KRPCClient(connection, new KRPCPackager());
			rpcClient.connect("testRemote");
			
			rpcClient.defaultRequestCompleteHandler = defaultCallBack;
			rpcClient.defaultRequestErrorHandler = defaultErrorHandler;
			rpcClient.defaultCompleteHandler = defaultDoBatchCallCompleteHandler;
			rpcClient.defaultErrorHandler = defaultDoBatchCallErrorHandler;
			
			rpcClient.registerRequestHandler(1001, hand_1001);
			rpcClient.registerRequestHandler(1002, hand_1002);
			
			var param:Object = { date:new Date(),table:table,table2:table2, playerList:[1, 2, 3], name:"action script", age:23, win:true, lose:false };
			
			rpcClient.readyBatchCall();
			//rpcClient.ApplicationendBatchCall(1001, param, [callBack1], [errorHandler]);
			rpcClient.appendBatchCall(1001, param, callBack1, [errorHandler]);
			rpcClient.appendBatchCall(1002, "test String", [callBack2], []);
			rpcClient.doBatchCall([doBatchCallCompleteHandler], [doBatchCallErrorHandler]);
			
			//rpcClient.call(1001, param, [callBack1], [errorHandler]);
			
			
			
		}
		
		private function hand_1001(vars:*):void
		{
			
			trace("hand_1001");
			
		}
		
		private function hand_1002(vars:*):void
		{
			
			trace("hand_1002");
			
		}
		
		private function callBack1(result:KRPCResult):void
		{
			
			trace("callBack1");
			
		}
		
		private function callBack2(result:KRPCResult):void
		{
			
			trace("callBack2");
			
		}
		
		private function defaultCallBack(result:KRPCResult):void
		{
			
			trace("defaultCallBack");
			
		}
		
		private function errorHandler(error:KRPCError):void
		{
			
			trace("errorHandler");
			
		}
		
		private function defaultErrorHandler(error:KRPCError):void
		{
			
			trace("defaultErrorHandler");
			
		}
		
		private function doBatchCallCompleteHandler():void
		{
			
			trace("doBatchCallCompleteHandler");
			
		}
		
		private function defaultDoBatchCallCompleteHandler():void
		{
			
			trace("defaultDoBatchCallCompleteHandler");
			
		}
		
		private function doBatchCallErrorHandler(error:KRPCError):void
		{
			
			trace("doBatchCallErrorHandler");
			
		}
		
		private function defaultDoBatchCallErrorHandler(error:KRPCError):void
		{
			
			trace("defaultDoBatchCallErrorHandler");
			
		}
		
	}

}