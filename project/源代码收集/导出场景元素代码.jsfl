var document = fl.getDocumentDOM();
document.selectAll()
var items=document.selection

var code="package com.renren.home.ui.poppanel{\n"

  code+="import flash.display.MovieClip;\n"

  code+="import flash.events.Event;\n"

  code+="import flash.events.MouseEvent;\n"
  
  code+="import flash.text.TextField;\n\n"
  
  code+="public class ### extends BasePopPanel{\n\n"

 createVars()
 
 code+="public function ###():void{}\n\n"

code+="override protected function init():void{}\n\n"
		
code+="public override function updateData(data:Object):void{}\n\n"
		
code+="override protected function configListeners():void{\n"

createAddEvent()

code+="}\n\n"
		
code+="override protected function removeListeners():void{\n"

createRemoveEvent()

code+="}\n\n"

createFunEvent()

code+="}}"

fl.trace(code)


function createVars(){

for(var i=0;i<items.length;i++){

    if(items[i].elementType=="text"){
    
     code+="public var "+items[i].name+":TextField\n"
    
    }else if(items[i].symbolType=="movie clip"&&items[i].name!=""){
    
     code+="public var "+items[i].name+":MovieClip\n"
    
    }else if(items[i].symbolType=="button"){
    
    }

}

}

function createAddEvent(){

for(var i=0;i<items.length;i++){

    if(items[i].symbolType=="movie clip"&&items[i].name.indexOf("btn_")!=-1){
    
     code+=items[i].name+".addEventListener(MouseEvent.CLICK, "+items[i].name+"ClickHandler);\n"
    
    }
}

}

function createRemoveEvent(){

for(var i=0;i<items.length;i++){

    if(items[i].symbolType=="movie clip"&&items[i].name.indexOf("btn_")!=-1){
    
     code+=items[i].name+".removeEventListener(MouseEvent.CLICK, "+items[i].name+"ClickHandler);\n"
    
    }
}

}

function createFunEvent(){

for(var i=0;i<items.length;i++){

    if(items[i].symbolType=="movie clip"&&items[i].name.indexOf("btn_")!=-1){
    
       code+="private function "+items[i].name+"(e:MouseEvent):void{\n\n                     }\n"
    
    }
}

}

