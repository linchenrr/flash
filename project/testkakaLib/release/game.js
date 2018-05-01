function init() {
    window.gameArea = document.getElementById("gameArea");
    if (checkflashVer() == false) return;

    createSwf(mainSwf);

}

function getFlashVars() {
    return flashVars;
}

function checkflashVer() {
    var ver = 0;
    var swf;
    try {
        if (window.ActiveXObject) {
            swf = new ActiveXObject('ShockwaveFlash.ShockwaveFlash');
            var s = swf.GetVariable("$version");
            ver = parseInt(s.split(" ")[1].split(",")[0]);
        }
        else {
            swf = navigator.plugins["Shockwave Flash"];
            var words = swf.description.split(" ");
            for (var i = 0; i < words.length; ++i) {
                if (isNaN(parseInt(words[i]))) continue;
                ver = parseInt(words[i]);
            }
        }
    }
    catch (e) {
    }
    if (ver < 10) {
        s = "<table width='100%' height='100%'><tr><td align='center'>";
        s += "<a target='_blank' href='" + staticPath + "installFlash" + (window.ActiveXObject ? "IE" : "FF") + ".exe' style='color:#ffffff;font-size:12px'>";
        s += "本游戏需要flash player10支持，请点击安装后再刷新页面继续。";
        s += "</a>";
        s += "</td></tr></table>";
        gameArea.innerHTML = s;
        return false;
    }
}
function createSwf(url) {

    if (window.ActiveXObject) {
        gameArea.innerHTML = "";
        var fla = document.createElement("<object id='flaGame' name='flaGame' width='" + swfWidth + "' height='" + swfHeight + "' classid='clsid:d27cdb6e-ae6d-11cf-96b8-444553540000' />");
        //var fla = document.createElement("<object id='flaGame' name='flaGame' width='760' height='600'  classid='clsid:d27cdb6e-ae6d-11cf-96b8-444553540000' />");
        fla.appendChild(document.createElement("<param name='movie' value='" + url + "' />"));
        fla.appendChild(document.createElement("<param name='base' value='.' />"));
        fla.appendChild(document.createElement("<param name='allowScriptAccess' value='always' />"));
        fla.appendChild(document.createElement("<param name='allowNetworking' value='all' />"));
        fla.appendChild(document.createElement("<param name='allowFullScreen' value='true' />"));
        fla.appendChild(document.createElement("<param name='wmode' value='window' />"));
        gameArea.appendChild(fla);
    }
    else {
        var sl = "<embed id='flaGame' name='flaGame' base='.'  src='" + url + "' width='" + swfWidth + "' height='" + swfHeight + "' allowScriptAccess='always' allowNetworking='all' allowFullScreen='true' type='application/x-shockwave-flash' wmode='window' />";
        gameArea.innerHTML = sl;
    }

    window.flaGame = document.getElementById("flaGame");
}