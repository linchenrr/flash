package org.superkaka.KLib.net.rpc.sim 
{
	/**
	 * 模拟数据集合表
	 * @author ｋａｋａ
	 */
	public class SimDataTable
	{
		
		private const dic_simData:Object = { };
		
		public function SimDataTable():void
		{
			
		}
		
		public function getSimData(procedureId:uint):SimData
		{
			
			return dic_simData[procedureId];
			
		}
		
		public function addSimData(simData:SimData):void
		{
			
			dic_simData[simData.procedureId] = simData;
			
		}
		
		public function removeSimData(procedureId:uint):void
		{
			
			dic_simData[procedureId] = null;
			delete dic_simData[procedureId];
			
		}
		
	}

}