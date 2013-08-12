var minimumheight=200;
var flashResizeMode=0;

function fncFlashHeight() {
	var headerheight=130;
	var footerheight=80;
	var myHeight=0;
	if (typeof(window.innerWidth)=='number') {
		myHeight=window.innerHeight;
	}
	else if(document.documentElement && (document.documentElement.clientHeight)) {
		myHeight=document.documentElement.clientHeight;
	}
	else if(document.body && (document.body.clientHeight)) {
		myHeight=document.body.clientHeight;
	}
	
	var divheight=myHeight-headerheight-footerheight;
	if (divheight<minimumheight) divheight=minimumheight;
	if(document.getElementById('fnc_flash')) {
		document.getElementById('fnc_flash').style.height=divheight+'px';
	}
}

function toTop() {
	window.scrollTo(0,0);
}

function resetFocus() {
	window.focus();
}

function resizeFlash(value) {
	if (flashResizeMode==1) {
		minimumheight=value;
		fncFlashHeight();
	}
	else {
		var flashDivContainer=document.getElementById('fnc_container');
		if(flashDivContainer===null) {
			return false;
		}
		flashDivContainer.style.height=value+'px';
		var flashDiv=document.getElementById('fnc_flash');
		if(flashDiv===null) {
			return false;
		}
		flashDiv.height=value;
	}
}
