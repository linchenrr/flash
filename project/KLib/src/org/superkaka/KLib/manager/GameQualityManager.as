package org.superkaka.KLib.manager 
{
	import flash.display.Stage;
	import flash.display.StageQuality;
	/**
	 * ...
	 * @author ｋａｋａ
	 * 游戏画质管理类
	 */
	public class GameQualityManager
	{
		
		static private var stage:Stage;
		
		static public function init(stg:Stage):void
		{
			stage = stg;
		}
		
		
		/**
		 * 设置最佳品质
		 */
		static public function setBestQuality():void
		{
			setGameQuality(StageQuality.BEST);
		}
		
		/**
		 * 设置高品质
		 */
		static public function setHighQuality():void
		{
			setGameQuality(StageQuality.HIGH);
		}
		
		/**
		 * 设置中等品质
		 */
		static public function setMediumQuality():void
		{
			setGameQuality(StageQuality.MEDIUM);
		}
		
		/**
		 * 设置低品质
		 */
		static public function setLowQuality():void
		{
			setGameQuality(StageQuality.LOW);
		}
		
		/**
		 * 设置游戏品质
		 * @param	quality		品质，StageQuality的某个值
		 */
		static public function setGameQuality(quality:String):void
		{
			stage.quality = quality;
		}
		
		/**
		 * 获取游戏品质
		 * @return
		 */
		static public function getGameQuality():String
		{
			return stage.quality;
		}
		
	}

}