package  
{
	
	/**
	 * ...
	 * @author ｋａｋａ
	 */
	public class AngleCounter 
	{
		
		static private const arr_70:Array =
		[
			0,
            19,
            26,
            33,
            38,
            43,
            47,
            51,
            55,
            59,
            63,
            66,
            70,
            73,
            77,
            80,
            83,
            86,
            89,
            92,
            95,
            98
		];
		
		static private const arr_65:Array =
		[
			0,
			18,
			24,
			29,
			32,
			37,
			40,
			44,
			48,
			51,
			55,
			59,
			62,
			66,
			69,
			72,
			75,
			78,
			81,
			84,
			87,
			90
		];
		
		
		static private const arr_60:Array =
		[
			0,
            16,
            22,
            27,
            32,
            36,
            40,
            43,
            46,
            50,
            53,
            56,
            58,
            61,
            64,
            67,
            69,
            72,
            75,
            77,
            80,
            83
		];
		
		static private const arr_30:Array =
		[
			0,
            14,
            20,
            25,
            29,
            32,
            36,
            39,
            42,
            45,
            48,
            50,
            53,
            55,
            58,
            60,
            63,
            65,
            68,
            70,
            72,
            74
		];
		
		//修正力偏移
		static private var POWER_OFFSET:int=0;
		static public function fixOffset(wind:Number):void
		{
			POWER_OFFSET=-2;
			/*
			if(wind>=3)
			{
				POWER_OFFSET=-3;
			}
			else
			if(wind>=-1)
			{
				POWER_OFFSET=-2;
			}
			else
			if(wind>=-3)
			{
				POWER_OFFSET=-2;
			}
			else
			{
				POWER_OFFSET=-1;
			}*/
		}
		
	 //获取70度角度和力量
        static public function getAngleAndPowerBy70(distance:Distance ,wind:Number):AngleAndPower
        {
        	var dx:int=distance.disX;
        	
			var angle:int = 70 + (wind + wind);
			var power:int = arr_70[dx];
			if(arr_70[dx+1]!=undefined)
			{
				power+=(arr_70[dx+1]-arr_70[dx])*distance.offsetX;
			}
			else
			{
				return new AngleAndPower(angle, -1);
			}
			
			power+=POWER_OFFSET;
			
			return new AngleAndPower(angle, power);
        }

        //获取70度背抛角度和力量
        static public function getAngleAndPowerBy70_back(distance:Distance, wind:Number):AngleAndPower
        {            
            var dx:int=distance.disX;
        	
			var angle:int = 110 - (wind + wind);
			var power:int = arr_70[dx];
			if(arr_70[dx+1]!=undefined)
			{
				power+=(arr_70[dx+1]-arr_70[dx])*(distance.offsetX+0.5);
			}
			else
			{
				return new AngleAndPower(angle, -1);
			}
			
			power+=POWER_OFFSET;
			
			return new AngleAndPower(angle, power);
        }
        
        //获取65度角度和力量
        static public function getAngleAndPowerBy65(distance:Distance, wind:Number):AngleAndPower
        {
        	var defaultAngle:int=65;
        	var reducePower:int=0;
        	
        	var dx:int=distance.disX;
        	
        	if(dx>=13)
        	{
        		defaultAngle=64;
        		reducePower= -(dx - 13)/7 * 3 -1;
        	}
        	
			var angle:int = defaultAngle + (wind + wind);
			var power:int = arr_65[dx] + reducePower;
			if(arr_65[dx+1]!=undefined)
			{
				power+=(arr_65[dx+1]-arr_65[dx])*distance.offsetX;
			}
			else
			{
				return new AngleAndPower(angle, -1);
			}
			
			//power+=POWER_OFFSET;
			
			return new AngleAndPower(angle, power);
		
        }

        //获取65度背抛角度和力量
        static public function getAngleAndPowerBy65_back(distance:Distance, wind:Number):AngleAndPower
        {            
        	var defaultAngle:int=115;
        	var reducePower:int=0;
        	
            var dx:int=distance.disX;
        	
        	if(dx>=13)
        	{
        		defaultAngle=116;
        		reducePower= -(1 - (dx - 13)/7) * 3;
        	}
        	
			var angle:int = defaultAngle - (wind + wind);
			var power:int = arr_65[dx] + reducePower;
			if(arr_65[dx+1]!=undefined)
			{
				power+=(arr_65[dx+1]-arr_65[dx])*(distance.offsetX+0.5);
			}
			else
			{
				return new AngleAndPower(angle, -1);
			}
			
			//power+=POWER_OFFSET;
			
			return new AngleAndPower(angle, power);
        }


        //获取60度角度和力量
        static public function getAngleAndPowerBy60(distance:Distance, wind:Number):AngleAndPower
        {
        	var dx:int=distance.disX;
        	
			var angle:int = 60 + (wind + wind);
			var power:int = arr_60[dx];
			if(arr_60[dx+1]!=undefined)
			{
				power+=(arr_60[dx+1]-arr_60[dx])*distance.offsetX;
			}
			else
			{
				return new AngleAndPower(angle, -1);
			}
			
			power+=POWER_OFFSET;
			
			return new AngleAndPower(angle, power);
		
        }

        //获取60度背抛角度和力量
        static public function getAngleAndPowerBy60_back(distance:Distance, wind:Number):AngleAndPower
        {            
            var dx:int=distance.disX;
        	
			var angle:int = 120 - (wind + wind);
			var power:int = arr_60[dx];
			if(arr_60[dx+1]!=undefined)
			{
				power+=(arr_60[dx+1]-arr_60[dx])*(distance.offsetX+0.5);
			}
			else
			{
				return new AngleAndPower(angle, -1);
			}
			
			power+=POWER_OFFSET;
			
			return new AngleAndPower(angle, power);
        }

        //获取30度角度和力量
        static public function getAngleAndPowerBy30(distance:Distance, wind:Number):AngleAndPower
        {            
            var dx:int=distance.disX;
        	
			var angle:int = 30;
			var power:int = arr_30[dx];
			if(arr_30[dx+1]!=undefined)
			{
				power+=(arr_30[dx+1]-arr_30[dx])*distance.offsetX;
			}
			else
			{
				return new AngleAndPower(angle, -1);
			}
			
			power-= int(wind/2);
			
			return new AngleAndPower(angle, power);
        }

        //获取正抛的角度和力量
        static public function getZPAngleAndPower(distance:Distance, wind:Number):AngleAndPower
        {            
            //风*2
            wind = wind + wind;
            //取整数风
            var wind_num:int = Math.round(wind);
            //取小数风
            var wind_point:Number = wind - wind_num;

            //正抛角度
            var angle_zp:int = 90 - distance.disX + wind_num;
            //正抛力量
            var power_zp:int = 95 - wind_point * 5 + Math.round(distance.disX/10);
            
            power_zp += Math.round(distance.offsetX*5);
            
            if(power_zp > 100)
            {
            	angle_zp--;
            	power_zp -= 5;
            }
            

            return new AngleAndPower(angle_zp, power_zp);
        }

        //获取背抛的角度和力量
        static public function getBPAngleAndPower(distance:Distance, wind:Number):AngleAndPower
        {
            //风*2
            wind = wind + wind;
           var wind_num:int = Math.round(wind);
            //取小数风
            var wind_point:Number = wind - wind_num;

            //背抛角度
            var angle_bp:int = 90 + distance.disX - wind_num;

            //背抛力量+2
            var power_bp:int = 95 - wind_point * 5 + Math.round(distance.disX/10) + 2;
            
            power_bp += Math.round(distance.offsetX*5);
            
            if(power_bp > 100)
            {
            	angle_bp++;
            	power_bp -= 5;
            }
			
            return new AngleAndPower(angle_bp, power_bp);
        }
        
        
        //获取正抛的角度和力量(半抛)
        static public function getHalfZPAngleAndPower(distance:Distance, wind:Number):AngleAndPower
        {            
            //风*2
            wind = wind + wind;
            //取整数风
            var wind_num:int = Math.round(wind);
            //取小数风
            var wind_point:Number = wind - wind_num;

            //正抛角度
            var angle_zp:int = 90 - distance.disX*2 + wind_num;
            //正抛力量
            var power_zp:int = 61 - wind_point * 2.5 + Math.round(distance.disX/5);
            
            power_zp += Math.round(distance.offsetX*2.5);
            
            return new AngleAndPower(angle_zp, power_zp);
        }

        //获取背抛的角度和力量(半抛)
        static public function getHalfBPAngleAndPower(distance:Distance, wind:Number):AngleAndPower
        {
            //风*2
            wind = wind + wind;
           var wind_num:int = Math.round(wind);
            //取小数风
            var wind_point:Number = wind - wind_num;

            //背抛角度
            var angle_bp:int = 90 + distance.disX*2 - wind_num;

            //背抛力量+3
            var power_bp:int = 61 - wind_point * 2.5 + Math.round(distance.disX/5) + 3;
            
            power_bp += Math.round(distance.offsetX*2.5);
            
			
            return new AngleAndPower(angle_bp, power_bp);
        }
	}
	
}