package org.superkaka.KLib.utils{
	import flash.utils.ByteArray;
	/**
	 * 为启用 JSON 的应用程序提供序列化和反序列化功能。
	 * @author 赵进
	 */
	public class Json {
		
		private static var mem:ByteArray=new ByteArray();
		private static var str:ByteArray=new ByteArray();
		private static var esc:Vector.<int>;
		private static var err:int;
		private static var chr:int;
		private static var pos:int;
		
		public static function decode(string:String):* {
			var v:Object;
			mem.position=err=0;
			mem.writeUTFBytes(string);
			mem.writeByte(0);
			chr=mem[0];pos=1;
			decodeIgnored();
			v=decodeValue();
			if (err > 0)
			{
				throw new Error("解析出错，请检查传入的JSON格式是否正确");
			}
			decodeIgnored();
			if (chr > 0)
			{
				throw new Error("解析出错，请检查传入的JSON格式是否正确");
			}
			return v;
		}
		
		private static function decodeValue():* {
			var i:int,j:int,n:int,u:int,c:int,f:int;
			var b:Boolean,a:Array,o:Object,k:*,v:*;
			if(chr>0x2f&&chr<0x3a||chr==0x2e){
				i=pos;
				if(chr==0x30){
					c=mem[pos];
					if(c==0x78||c==0x58){
						pos+=1;
						for(;;){
							chr=mem[pos];pos+=1;
							if(!(chr>0x2f&&chr<0x3a||chr>0x40&&chr<0x47||chr>0x60&&chr<0x67))break;
						}
						if(pos-i==2)return err=1;
					}
				}
				if(pos==i){
					if(chr!=0x2e){
						for(;;){
							chr=mem[pos];pos+=1;
							if(!(chr>0x2f&&chr<0x3a))break;
						}
					}
					if(chr==0x2e){
						for(;;){
							chr=mem[pos];pos+=1;
							if(!(chr>0x2f&&chr<0x3a))break;
						}
						if(pos-i==1)return err=1;
					}
					if(chr==0x65||chr==0x45){
						chr=mem[pos];
						if(chr==0x2b||chr==0x2d)pos+=1;
						j=pos;
						for(;;){
							chr=mem[pos];pos+=1;
							if(!(chr>0x2f&&chr<0x3a))break;
						}
						if(pos-j==1)return err=1;
					}
				}
				str.length=0;
				str.writeBytes(mem,i-1,pos-i);
				return Number(str.toString());
			}
			if(chr==0x22||chr==0x27){
				str.length=0;
				f=chr;
				i=pos;
				for(;;){
					chr=mem[pos];
					if(chr==0x00||chr==0x0a||chr==0x0d)return err=1;
					if(chr==f){
						if(pos>i)str.writeBytes(mem,i,pos-i);
						chr=mem[pos+1];pos+=2;
						return str.toString();
					}
					if(chr==0x5c){
						if(pos>i)str.writeBytes(mem,i,pos-i);
						chr=mem[pos+1];pos+=2;
						if(chr==0x78||chr==0x75){
							for(j=u=0,n=chr==0x78?2:4;j<n;j++){
								c=mem[pos+j];
								if(c>0x2f&&c<0x3a)u=u*16+c-0x30;
								else if(c>0x40&&c<0x47)u=u*16+c-0x37;
								else if(c>0x60&&c<0x67)u=u*16+c-0x57;
								else break;
							}
							if(j==n){
								pos+=n;
								if(u<0x80){
									str.writeByte(u);
								}
								else if(u<0x800){
									str.writeShort(0xc080|((u<<2)&0x1f00)|(u&0x3f));
								}
								else {
									str.writeByte(0xe0|((u>>12)&0xf));
									str.writeShort(0x8080|((u<<2)&0x3f00)|(u&0x3f));
								}
							}
							else str.writeByte(chr);
						}
						else if(chr==0x62)str.writeByte(0x08);
						else if(chr==0x66)str.writeByte(0x0c);
						else if(chr==0x6e)str.writeByte(0x0a);
						else if(chr==0x72)str.writeByte(0x0d);
						else if(chr==0x74)str.writeByte(0x09);
						else if(chr==0x00)return err=1;
						else str.writeByte(chr);
						i=pos;
					}
					else pos+=1;
				}
			}
			if(chr==0x7b){
				chr=mem[pos];pos+=1;
				decodeIgnored();
				if(chr==0x7d){
					chr=mem[pos];pos+=1;
					return {};
				}
				o={};
				for(;;){
					if(chr==0x22||chr==0x27||chr==0x2e||chr>0x2f&&chr<0x3a){
						k=decodeValue();
						if(err>0)return err;
					}
					else{
						i=pos;
						for(;;){
							if(chr>0x60&&chr<0x7b||chr>0x40&&chr<0x5b||chr>0x2f&&chr<0x3a||chr==0x5f||chr==0x24){
								chr=mem[pos];pos+=1;
							}
							else if(chr<0x80){
								if(pos==i)return err=1;
								str.length=0;
								str.writeBytes(mem,i-1,pos-i);
								k=str.toString();
								break;
							}
							else if(chr>>>5==0x06){
								c=mem[pos];pos+=1;
								if(c<0x80||c>0xbf)return err=1;
								u=c&0x3f|(chr&0x1f)<<6;
								if(u<0xc0||u==0xd7||u==0xf7)return err=1;
								chr=mem[pos];pos+=1;
							}
							else if(chr>>>4==0x0E){
								c=mem[pos];pos+=1;
								if(c<0x80||c>0xbf)return err=1;
								j=mem[pos];pos+=1;
								if(j<0x80||j>0xbf)return err=1;
								u=j&0x3f|(c&0x3f)<<6|(chr&0x1f)<<12;
								if(u>0x1fff&&u<0x3040)return err=1;
								if(u>0x318f&&u<0x3300)return err=1;
								if(u>0x337f&&u<0x3400)return err=1;
								if(u>0x3d2d&&u<0x4e00)return err=1;
								if(u>0x9fff&&u<0xf900)return err=1;
								chr=mem[pos];pos+=1;
							}
							else return err=1;
						}
					}
					decodeIgnored();
					if(chr!=0x3a)return err=1;
					chr=mem[pos];pos+=1;
					decodeIgnored();
					v=decodeValue();
					if(err>0)return err;
					o[k]=v;
					decodeIgnored();
					if(chr==0x7d){
						chr=mem[pos];pos+=1;
						return o;
					}
					if(chr==0x2c){
						chr=mem[pos];pos+=1;
						decodeIgnored();
					}
					else return err=1;
				}
			}
			if(chr==0x5b){
				chr=mem[pos];pos+=1;
				decodeIgnored();
				if(chr==0x5d){
					chr=mem[pos];pos+=1;
					return [];
				}
				a=[];i=0;b=false;
				for(;;){
					decodeIgnored();
					if(chr==0x5d){
						chr=mem[pos];pos+=1;
						return a;
					}
					if(chr==0x2c){
						a.length=++i;b=false;
						chr=mem[pos];pos+=1;
					}
					else if(b)return err=1;
					else {
						decodeIgnored();
						v=decodeValue();
						if(err>0)return err;
						a[i]=v;b=true;
					}
				}
			}
			if(chr==0x2d){
				chr=mem[pos];pos+=1;
				decodeIgnored();
				v=decodeValue();
				if(err>0)return err;
				return -v;
			}
			if(chr==0x66){
				chr=mem[pos];pos+=1;
				if(chr!=0x61)return err=1;
				chr=mem[pos];pos+=1;
				if(chr!=0x6c)return err=1;
				chr=mem[pos];pos+=1;
				if(chr!=0x73)return err=1;
				chr=mem[pos];pos+=1;
				if(chr!=0x65)return err=1;
				chr=mem[pos];pos+=1;
				return false;
			}
			if(chr==0x74){
				chr=mem[pos];pos+=1;
				if(chr!=0x72)return err=1;
				chr=mem[pos];pos+=1;
				if(chr!=0x75)return err=1;
				chr=mem[pos];pos+=1;
				if(chr!=0x65)return err=1;
				chr=mem[pos];pos+=1;
				return true;
			}
			if(chr==0x6e){
				chr=mem[pos];pos+=1;
				if(chr!=0x75)return err=1;
				chr=mem[pos];pos+=1;
				if(chr!=0x6c)return err=1;
				chr=mem[pos];pos+=1;
				if(chr!=0x6c)return err=1;
				chr=mem[pos];pos+=1;
				return null;
			}
			if(chr==0x75){
				chr=mem[pos];pos+=1;
				if(chr!=0x6e)return err=1;
				chr=mem[pos];pos+=1;
				if(chr!=0x64)return err=1;
				chr=mem[pos];pos+=1;
				if(chr!=0x65)return err=1;
				chr=mem[pos];pos+=1;
				if(chr!=0x66)return err=1;
				chr=mem[pos];pos+=1;
				if(chr!=0x69)return err=1;
				chr=mem[pos];pos+=1;
				if(chr!=0x6e)return err=1;
				chr=mem[pos];pos+=1;
				if(chr!=0x65)return err=1;
				chr=mem[pos];pos+=1;
				if(chr!=0x64)return err=1;
				chr=mem[pos];pos+=1;
				return undefined;
			}
			if(chr==0x49){
				chr=mem[pos];pos+=1;
				if(chr!=0x6e)return err=1;
				chr=mem[pos];pos+=1;
				if(chr!=0x66)return err=1;
				chr=mem[pos];pos+=1;
				if(chr!=0x69)return err=1;
				chr=mem[pos];pos+=1;
				if(chr!=0x6e)return err=1;
				chr=mem[pos];pos+=1;
				if(chr!=0x69)return err=1;
				chr=mem[pos];pos+=1;
				if(chr!=0x74)return err=1;
				chr=mem[pos];pos+=1;
				if(chr!=0x79)return err=1;
				chr=mem[pos];pos+=1;
				return Infinity;
			}
			if(chr==0x4e){
				chr=mem[pos];pos+=1;
				if(chr!=0x61)return err=1;
				chr=mem[pos];pos+=1;
				if(chr!=0x4e)return err=1;
				chr=mem[pos];pos+=1;
				return NaN;
			}
			return err=1;
		}
		
		private static function decodeIgnored():void {
			for(;;){
				if(chr<0x21){
					if(chr==0x00)return;
					chr=mem[pos];pos+=1;
				}
				else if(chr==0x2f){
					chr=mem[pos];pos+=1;
					if(chr==0x2f){
						for(;;){
							chr=mem[pos];pos+=1;
							if(chr==0x00)return;
							if(chr==0x0a||chr==0x0d){
								chr=mem[pos];pos+=1;
								break;
							}
						}
					}
					else if(chr==0x2a){
						chr=mem[pos];pos+=1;
						for(;;){
							if(chr==0x00)return;
							if(chr==0x2a){
								chr=mem[pos];pos+=1;
								if(chr==0x2f){
									chr=mem[pos];pos+=1;
									break;
								}
							}
							else{
								chr=mem[pos];pos+=1;
							}
						}
					}
					else return;
				}
				else return;
			}
		}
		
		public static function encode(object:Object):String {
			if(esc==null){
				esc=new Vector.<int>(0x100,true);
				esc[0x08]=0x5c62;
				esc[0x09]=0x5c74;
				esc[0x0a]=0x5c6e;
				esc[0x0c]=0x5c66;
				esc[0x0d]=0x5c72;
				esc[0x22]=0x5c22;
				esc[0x5c]=0x5c5c;
			}
			if(object==null)return "null";
			if(object===true)return "true";
			if(object===false)return "false";
			if(object is Number)return String(object);
			mem.position=0;
			encodeValue(object);
			mem.length=mem.position;
			return mem.toString();
		}
		
		private static function encodeValue(object:Object):void {
			var i:int,n:int,a:Array,k:String,b:Boolean;
			if(object==null){
				mem.writeUnsignedInt(0x6e756c6c);
			}
			else if(object===true){
				mem.writeUnsignedInt(0x74727565);
			}
			else if(object===false){
				mem.writeByte(0x66);
				mem.writeUnsignedInt(0x616c7365);
			}
			else if(object is Number){
				mem.writeUTFBytes(String(object));
			}
			else if(object is String){
				mem.writeByte(0x22);
				str.position=pos=0;
				str.writeUTFBytes(object as String);
				for(i=0,n=str.position;i<n;i++){
					chr=esc[str[i]];
					if(chr){
						if(i>pos)mem.writeBytes(str,pos,i-pos);
						mem.writeShort(chr);
						pos=i+1;
					}
				}
				if(n>pos)mem.writeBytes(str,pos,n-pos);
				mem.writeByte(0x22);
			}    
			else if(object is Array){
				a=object as Array;
				mem.writeByte(0x5b);
				for(i=0,n=a.length;i<n;i+=1){
					b?mem.writeByte(0x2c):(b=true);
					encodeValue(a[i]);
				}
				mem.writeByte(0x5d);
			}
			else{
				a=[];i=0;
				for(k in object){
					a[i]=k;i+=1;
				}
				a.sort();
				mem.writeByte(0x7b);
				for(i=0,n=a.length;i<n;i+=1){
					b?mem.writeByte(0x2c):(b=true);
					encodeValue(k=a[i]);
					mem.writeByte(0x3a);
					encodeValue(object[k]);
				}
				mem.writeByte(0x7d);
			}
		}
	}
}
