function init() {
    window.gameArea = document.getElementById("gameArea");
    if (checkflashVer() == false) return;

    var urlParams = getURLParams();

    //url参数覆盖页面参数中的对应值
    for (var key in urlParams) {
        flashVars[key] = urlParams[key];
    }

    createSwf(mainSwf);

}

function getFlashVars() {
    return flashVars;
}

function getURLParams() {
    var urlParam = {};
    //暂时不转换成小写，会造成一些问题
    //var urlParamString = window.location.search.toLowerCase();
    var urlParamString = window.location.search;

    if (urlParamString.length != 0) {
        urlParamString = urlParamString.substr(1);
        var paramArr = urlParamString.split("&");

        for (var i = 0; i < paramArr.length; i++) {
            var itemArr = paramArr[i].split("=");
            urlParam[itemArr[0]] = itemArr[1];
        }
    }

    return urlParam;

}

function checkflashVer() {
    var ver = 0;
    try {
        if (document.all) {
            var swf = new ActiveXObject('ShockwaveFlash.ShockwaveFlash');
            var a = swf.GetVariable("$version").replace(" ", ",").split(",");
            ver = parseFloat(a[1] + "." + a[2]);
        }
        else {
            var swf = navigator.plugins["Shockwave Flash"];
            a = swf.description.split(" ");
            ver = parseFloat(a[2]);
        }
    }
    catch (e) {
    }
    if (ver < 10) {
        s = "<table width='100%' height='100%'><tr><td align='center'>";
        s += "<a target='_blank' href='fp/" + "installFlash" + (window.ActiveXObject ? "IE" : "FF") + ".exe' style='color:#ffffff;font-size:12px'>";
        s += "本游戏需要flash player10支持，请点击安装后再刷新页面继续。";
        s += "</a>";
        s += "</td></tr></table>";
        gameArea.innerHTML = s;
        return false;
    }
}
function createSwf(url) {
    var urlTail = "?v=" + getBuildVersion();
    if (document.all) {
        gameArea.innerHTML = "";
        try {
            var fla = document.createElement("<object id='flaGame' name='flaGame' width='" + swfWidth + "' height='" + swfHeight + "' classid='clsid:d27cdb6e-ae6d-11cf-96b8-444553540000' />");
            fla.appendChild(document.createElement("<param name='movie' value='" + url + urlTail + "' />"));
            fla.appendChild(document.createElement("<param name='base' value='.' />"));
            fla.appendChild(document.createElement("<param name='allowScriptAccess' value='always' />"));
            fla.appendChild(document.createElement("<param name='allowNetworking' value='all' />"));
            fla.appendChild(document.createElement("<param name='allowFullScreen' value='true' />"));
            fla.appendChild(document.createElement("<param name='wmode' value='window' />"));
            gameArea.appendChild(fla);
        }
        catch (e) {
            gameArea.innerHTML = "<object id='flaGame' name='flaGame' width='" + swfWidth + "' height='" + swfHeight + "' classid='clsid:d27cdb6e-ae6d-11cf-96b8-444553540000' />" +
												"<param name='movie' value='" + url + urlTail + "' />" +
												"<param name='base' value='.' />" +
												"<param name='allowScriptAccess' value='always' />" +
												"<param name='allowNetworking' value='all' />" +
												"<param name='allowFullScreen' value='true' />" +
                                                "<param name='wmode' value='window' />" +
												"</object>";
        }
    }
    else {
        var sl = "<embed id='flaGame' name='flaGame' base='.'  src='" + url + urlTail + "' width='" + swfWidth + "' height='" + swfHeight + "' allowScriptAccess='always' allowNetworking='all' allowFullScreen='true' type='application/x-shockwave-flash' wmode='window' />";
        gameArea.innerHTML = sl;
    }

    window.flaGame = document.getElementById("flaGame");
}

function refreshPage() {
    location = location;
}