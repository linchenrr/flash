/**
import com.peter.Csv;
import com.peter.CsvEvent;
import flash.events.Event;
var csv:Csv=new Csv();
csv.loadURL("online3.csv");
csv.addEventListener(Event.COMPLETE,onLoadCompleteHandler);
csv.addEventListener(IOErrorEvent.IO_ERROR,onLoadIOError);
csv.addEventListener(CsvEvent.EOF_ERROR,onReadFileError);
function onLoadCompleteHandler(event:Event):void {
	var arr:Array=csv.getRandomRecords(10);
	for (var i:uint=0; i<arr.length; i++) {
		trace("q:"+arr[i]["question"]+"__A:"+arr[i]["a"]);//question,a為csv第一行相應列對應記錄字段
	}
}
function onLoadIOError(event:IOErrorEvent):void{
	trace('url error');
}
function onReadFileError(event:CsvEvent):void{
	trace('read csv file error');
}
*******************************************************/
package com.peter{
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.net.URLRequest;
	import flash.net.URLLoader;
	import flash.events.EventDispatcher;
	import flash.utils.ByteArray;
	import flash.errors.EOFError;
	public class Csv extends EventDispatcher {
		private var _records:Array=new Array  ;
		private const DQUOTES:String="#100";
		private const SEMICOLON:String="#101";
		private var _currentIndex:uint=0;
		private var _encoding:String="utf8";
		public function Csv() {
		}
		public function loadURL(url:String):void {
			_records=new Array  ;
			var loader:URLLoader=new URLLoader  ;
			var link:URLRequest=new URLRequest(url);
			loader.addEventListener(Event.COMPLETE,onLoadCompleteHandler);
			loader.addEventListener(IOErrorEvent.IO_ERROR,onLoadErrorHandler);
			loader.dataFormat="binary";
			loader.load(link);
		}
		private function onLoadCompleteHandler(event:Event):void {
			var byteArray:ByteArray=ByteArray(event.target.data);
			var resultStr:String="";
			try {
				resultStr=byteArray.readMultiByte(byteArray.length,_encoding);
			} catch (e:EOFError) {
				dispatchEvent(new CsvEvent(CsvEvent.EOF_ERROR));
			}
			var tempArr:Array=resultStr.split(String.fromCharCode(13));
			tempArr.pop();
			var keyName:Array=new Array  ;
			if (tempArr.length>0) {
				tempArr[0]=tempArr[0].toLowerCase();
				keyName=tempArr[0].split(",");
				for (var i:uint=1; i<tempArr.length; i++) {
					tempArr[i]=parse(tempArr[i]);
					var tempArr2:Array=tempArr[i].split(",");
					var arr:Array=new Array  ;
					for (var j:uint=0; j<keyName.length; j++) {
						var s:String=keyName[j];
						if (tempArr2.length<=j) {
							arr[s]="";
						} else {
							tempArr2[j]=parseBack(tempArr2[j]);
							arr[s]=tempArr2[j];
						}
					}
					_records.push(arr);
				}
			}
			dispatchEvent(new Event(Event.COMPLETE));
		}
		private function parseBack(str:String):String {
			str=str.replace(DQUOTES,"\"");
			str=str.replace(SEMICOLON,",");
			return str;
		}
		private function parse(str:String):String {
			str=str.replace("\"\"",DQUOTES);
			str=parseSemicolon(str);
			return str;
		}
		private function parseSemicolon(str:String):String {
			var s:int=str.search("\"");
			while (s!=-1) {
				str=str.substr(s+1,str.length);
				var e:int=str.search("\"");
				var targetIndex:int=str.search(",");
				if (targetIndex!=-1&&e!=-1&&targetIndex<e) {
					str=str.substring(0,e)+str.substr(e+1,str.length);
					targetIndex=str.search(",");
					str=str.substring(0,targetIndex)+SEMICOLON+str.substr(targetIndex+1,str.length);
				}
				s=str.search("\"");
			}
			return str;
		}
		public function getRandomRecords(nums:uint):Array {
			var tempArr:Array=new Array();
			for (var i:uint=0; i<_records.length; i++) {
				tempArr.push(i);
			}
			tempArr=randArray(tempArr);
			var targetArr:Array=new Array();
			for (i=0; i<nums; i++) {
				var id:uint=tempArr[i];
				if (i>=tempArr.length) {
					break;
				}
				targetArr.push(_records[id]);
			}
			return targetArr;
		}
		private function randArray(arr:Array):Array {
			var temp:Array=new Array  ;
			var rand:Number=0;
			while (arr.length>0) {
				rand=Math.floor(Math.random()*arr.length);
				temp.push(arr[rand]);
				arr.splice(rand,1);
			}
			return temp;
		}
		public function setEnCoding(code:String):void {
			_encoding=code;
		}
		private function onLoadErrorHandler(event:IOErrorEvent):void {
			dispatchEvent(new IOErrorEvent(IOErrorEvent.IO_ERROR));
		}
	}
}