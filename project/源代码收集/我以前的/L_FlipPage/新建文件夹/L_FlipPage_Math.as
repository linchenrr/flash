package L_FlipPage
{
	/**
	* ...
	* @author DefaultUser (Tools -> Custom Arguments...)
	*/
	public class L_FlipPage_Math
	{
		static var values:L_FlipPage_GlobalVariables = L_FlipPage_GlobalVariables.values;
		
		public function L_FlipPage_Math():void
		{
		}
		private static function which_larger(x1:Number, x2:Number, b:Boolean):Number
		{
			if (b)
			{
				if (x1 >= x2)
				{
					return x1;
				}
				else
				{
					return x2;
				}
			}
			else
			{
				if (x1 <= x2)
				{
					return x1;
				}
				else
				{
					return x2;
				}
			}
		}
		public static function get_points(cx:Number,cy:Number,p_type:uint):Array
		{
			var w:uint = values.page_width;
			var h:uint = values.page_height;

			var v:Number = w / 2;
			/////////////所有的局部变量在此声明

			var ox:Number, oy:Number, ix:Number, iy:Number, hx:Number, hy:Number, gx:Number, gy:Number, qx:Number, qy:Number;
			var is_up:Boolean, is_left:Boolean;
			ix = ox = v;

			switch (p_type)
			{
				case 1 :
					is_up = true;
					is_left = true;
					hy = oy = 0;
					gy = iy = h;
					qx = gx = hx = 0;
					break;

				case 2 :
					is_up = true;
					is_left = false;
					hy = oy = 0;
					gy = iy = h;
					qx = gx = hx = w;
					break;

				case 3 :
					is_up = false;
					is_left = true;
					hy = oy = h;
					gy = iy = 0;
					qx = gx = hx = 0;
					break;

				case 4 :
					is_up = false;
					is_left = false;
					hy = oy = h;
					gy = iy = 0;
					qx = gx = hx = w;
					break;

				default :
					break;
			}
			/////////////
			//半径
			var r:Number;

			//鼠标与圆心的距离
			var odis:Number;

			var x1:Number;
			var x2:Number;

			var tx:Number;
			var ty:Number;

			var a:Number;
			var b:Number;
			var c:Number;
			var b_4ac:Number;

			var topdis:Number;

			var is_tuoyuanside:Boolean, is_in:Boolean;
			if (is_left)
			{
				is_tuoyuanside = cx > ox;
			}
			else
			{
				is_tuoyuanside = cx < ox;
			}
			if (is_up)
			{
				is_in = cy >= hy;
			}
			else
			{
				is_in = cy <= hy;
			}
			//如果鼠标超出了扇形区域就需要重置拖拽点
			if (is_in)
			{
				r = v;
				odis = Math.sqrt((cx - ox) * (cx - ox) + (cy - oy) * (cy - oy));
				if (odis > r)
				{

					if (cx == ox)
					{
						if (is_up)
						{
							cy = r;
						}
						else
						{
							cy = oy - r;
						}
					}
					else
					{
						//圆心与鼠标所成直线的斜率
						var ok:Number = (oy - cy) / (ox - cx);
						//根据 y = kx + b 算出b
						var ob:Number = oy - ok * ox;


						a = ok * ok + 1;
						b = 2 * ok * (ob - oy) - 2 * ox;
						c = ox * ox + (ob - oy) * (ob - oy) - r * r;
						b_4ac = Math.sqrt(b * b - 4 * a * c);

						//与圆心交点的两个横坐标
						x1 = ( -b + b_4ac) / (2 * a);
						x2 = ( -b - b_4ac) / (2 * a);

						cx = x1 = which_larger(x1, x2, cx > ox);
						cy = ok * x1 + ob;
					}
				}
			}
			else
			{
				r = Math.sqrt(v * v + h * h);

				//鼠标与圆心的距离
				odis = Math.sqrt((cx - ox) * (cx - ox) + (cy - oy) * (cy - oy));

				var qk:Number = (oy - cy) / (ox - cx);
				var qb:Number = cy - qk * cx;

				if (is_tuoyuanside)
				{
					a = qk * qk + 1;
					b = 2 * qk * (qb - iy) - 2 * ix;
					c = ix * ix + (qb - iy) * (qb - iy) - r * r;
					b_4ac = Math.sqrt(b * b - 4 * a * c);

					//与圆心交点的两个横坐标
					x1 = ( -b + b_4ac) / (2 * a);
					x2 = ( -b - b_4ac) / (2 * a);

					tx = which_larger(x1, x2, is_left);
					ty = qk * tx + qb;

					//交点线段的距离
					topdis = Math.sqrt((ox - tx) * (ox - tx) + (oy - ty) * (oy - ty));

					if (odis > topdis)
					{
						cx = tx;
						cy = ty;
					}
				}
				else
				{
					//椭圆圆心y坐标
					if (is_up)
					{
						qy = h - r;
					}
					else
					{
						qy = r;
					}
					if (cx == ox)
					{
						if (is_up)
						{
							if (cy < qy)
							{
								cy = qy;
							}
						}
						else
						{
							if (cy > qy)
							{
								cy = qy;
							}
						}
					}
					else
					{
						//椭圆长轴、短轴的长度
						var la:Number = v;
						var lb:Number = r - h;

						a = lb * lb + (la * qk) * (la * qk);
						b = 2 * la * la * qk * (qb - qy) - 2 * lb * lb * qx;
						c = (lb * qx) * (lb * qx) + la * la * (qb - qy) * (qb - qy) - la * la * lb * lb;
						b_4ac = Math.sqrt(b * b - 4 * a * c);

						x1 = ( -b + b_4ac) / (2 * a);
						x2 = ( -b - b_4ac) / (2 * a);

						tx = which_larger(x1, x2, is_left);
						ty = qk * tx + qb;

						//交点线段的距离
						topdis = Math.sqrt((ox - tx) * (ox - tx) + (oy - ty) * (oy - ty));

						if (odis > topdis)
						{
							cx = tx;
							cy = ty;
						}
					}
				}
			}
			var arr:Array = new Array();
			var ax:Number, ay:Number, bx:Number, by:Number, sx:Number, sy:Number, dx:Number, dy:Number, vx:Number, vy:Number, jx:Number, jy:Number;
			var re:Boolean;
			var ck:Number = (hy - cy) / (hx - cx);
			var sk:Number;
			//卷起页的角度
			var vk:Number;
			if (cy == hy)
			{
				//当BD斜率不存在时
				//vk = 0;

				dx = bx = sx = (cx + hx) / 2;
				dy = sy = hy;

				ay = by = gy;
				ax = cx;

			}
			else
			{
				//算出垂直平分线的斜率
				sk = -1 / ck;
				//垂直平分线的偏移量
				var sb:Number = (hy * hy - cy * cy + hx * hx - cx * cx) / (2 * (hy - cy));
				//c、h中间点的坐标
				sx = (cx + hx) / 2;
				sy = (cy + hy) / 2;

				//直线BD与FG、EH的交点b点和d点坐标
				var test_y:Number = sk * gx + sb;
				//是否为三个点
				var three_point:Boolean;
				if (is_up)
				{
					three_point = test_y < gy && is_in;
				}
				else
				{
					three_point = test_y > gy && is_in;
				}

				if (three_point)
				{
					ax = bx = gx;
					ay = by = test_y;
					jy = gy;
					jx = (jy - sb) / sk;
				}
				else
				{
					var ab:Number = gy - ck * gx;

					//A、G中间点的坐标
					var mdx:Number = (ab - sb) / (sk - ck);
					var mdy:Number = ck * mdx + ab;
					//g点关于中垂线的对称点a的坐标
					ax = 2 * mdx - gx;
					ay = 2 * mdy - gy;

					jy = by = gy;
					jx = bx = (by - sb) / sk;
				}
				dy = hy;
				dx = (dy - sb) / sk;


			}
			//算出卷起页的坐标和角度
			var stx:Number, sty:Number;
			var tk:Number, tb:Number;
			vk = Math.atan((dy - cy)/(dx-cx))/Math.PI * 180;
			//vk = Math.atan((dy - cy)/(dx-cx))/Math.PI * 180 - 180;
			//trace(vk)
			if (is_left)
			{
				tk = (dy - cy) / (dx - cx);

				if (is_up)
				{
					if (is_in && tk < 0)
					{
						vk -= 180;
					}
					stx = cx;
					sty = cy;



					if (tk == Infinity || tk == -Infinity)
					{
						vx = cx;
						vy = cy - v;
					}
					else
					{

						tb = sty - tk * stx;

						a = tk * tk + 1;
						b = 2 * tk * (tb - sty) - 2 * stx;
						c = stx * stx + (sty - tb) * (sty - tb) - v * v;
						b_4ac = Math.sqrt(b * b - 4 * a * c);

						x1 = ( -b + b_4ac) / (2 * a);
						x2 = ( -b - b_4ac) / (2 * a);


						if (is_in)
						{
							re = tk < 0;
						}
						else
						{
							re = false;
						}
						vx = which_larger(x1, x2, re);
						vy = tk * vx + tb;
					}
				}
				else
				{
					if (is_in && tk > 0)
					{
						vk -= 180;
					}
					stx = cx;
					sty = cy;

					if (tk == 0)
					{
						vx = cx - v;
						vy = cy - h;
					}
					else
					{
						tk = -1 / tk;
						tb = sty - tk * stx;

						a = tk * tk + 1;
						b = 2 * tk * (tb - sty) - 2 * stx;
						c = stx * stx + (sty - tb) * (sty - tb) - h * h;
						b_4ac = Math.sqrt(b * b - 4 * a * c);

						x1 = ( -b + b_4ac) / (2 * a);
						x2 = ( -b - b_4ac) / (2 * a);



						if (is_in)
						{
							re = false;
						}
						else
						{
							re = true;
						}
						stx = which_larger(x1, x2, re);
						sty = tk * stx + tb;

						tk = (dy - cy) / (dx - cx);

						if (tk == Infinity || tk == -Infinity)
						{
							vx = cx - h;
							vy = cy + v;
						}
						else
						{


							tb = sty - tk * stx;



							a = tk * tk + 1;
							b = 2 * tk * (tb - sty) - 2 * stx;
							c = stx * stx + (sty - tb) * (sty - tb) - v * v;
							b_4ac = Math.sqrt(b * b - 4 * a * c);

							x1 = ( -b + b_4ac) / (2 * a);
							x2 = ( -b - b_4ac) / (2 * a);

							if (is_in)
							{
								re = tk > 0;
							}
							else
							{
								re = false;
							}
							vx = which_larger(x1, x2, re);
							vy = tk * vx + tb;
						}
					}
				}
			}
			else
			{
				tk = (dy - cy) / (dx - cx);

				if (is_up)
				{
					vx = cx;
					vy = cy;

					if (is_in && tk > 0)
					{
						vk -= 180;
					}
				}
				else
				{
					stx = cx;
					sty = cy;



					if (is_in && tk < 0)
					{
						vk -= 180;
					}
					if (tk == 0)
					{
						vx = cx;
						vy = cy - h;
					}
					else
					{
						tk = -1 / tk;
						tb = cy - tk * cx;

						a = tk * tk + 1;
						b = 2 * tk * (tb - sty) - 2 * stx;
						c = stx * stx + (sty - tb) * (sty - tb) - h * h;
						b_4ac = Math.sqrt(b * b - 4 * a * c);

						x1 = ( -b + b_4ac) / (2 * a);
						x2 = ( -b - b_4ac) / (2 * a);


						var tmp_vx:Number = which_larger(x1, x2, is_in);
						vx = tmp_vx;
						vy = tk * tmp_vx + tb;
					}
				}
			}
			var obj_a:Object = new Object();
			var obj_b:Object = new Object();
			var obj_c:Object = new Object();
			var obj_d:Object = new Object();
			var obj_v:Object = new Object();
			var obj_g:Object = new Object();
			var obj_h:Object = new Object();

			obj_a.x = ax;
			obj_a.y = ay;
			//obj_a.name = "A";

			obj_b.x = bx;
			obj_b.y = by;
			//obj_b.name = "B";

			obj_c.x = cx;
			obj_c.y = cy;
			//obj_c.name = "C";

			obj_d.x = dx;
			obj_d.y = dy;
			//obj_d.name = "D";

			obj_v.x = vx;
			obj_v.y = vy;
			obj_v.vk = vk;
			//obj_v.name = "V";

			obj_g.x = gx;
			obj_g.y = gy;
			//obj_g.name = "G";

			obj_h.x = hx;
			obj_h.y = hy;
			//obj_h.name = "H";

			arr.push(obj_a);
			arr.push(obj_b);
			arr.push(obj_c);
			arr.push(obj_d);
			arr.push(obj_v);
			arr.push(obj_g);
			arr.push(obj_h);

			return arr;
		}
		//////////////////////////////////////////////////////////////


		//////////////////////////////////////////////////////////////
		public static function get_finish_point(cx:int,p_type:uint):Object
		{
			var w:uint = values.page_width;
			var h:uint = values.page_height;
			var v:Number = w / 2;
			var hx:uint, hy:uint;

			var flip_over:Boolean = true;

			switch (p_type)
			{
				case 1 :
					if (cx > v + w / 10)
					{
						hx = w;
					}
					else
					{
						hx = 0;
						flip_over = false;
					}
					hy = 0;
					break;
				case 2 :
					if (cx < v - w / 10)
					{
						hx = 0;
					}
					else
					{
						hx = w;
						flip_over = false;
					}
					hy = 0;
					break;

				case 3 :
					if (cx > v + w / 10)
					{
						hx = w;
					}
					else
					{
						hx = 0;
						flip_over = false;
					}
					hy = h;
					break;
				case 4 :
					if (cx < v - w / 10)
					{
						hx = 0;
					}
					else
					{
						hx = w;
						flip_over = false;
					}
					hy = h;
					break;

				default :
					break;
			}
			var tmp_obj:Object = new Object();
			tmp_obj.x = hx;
			tmp_obj.y = hy;
			tmp_obj.flip_over = flip_over;
			return tmp_obj;
		}
	}
}