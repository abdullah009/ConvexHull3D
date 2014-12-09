
function start(id) {
	var val = document.getElementById("txt_vertex").value;
	if (!isNumber(val))
		val = 10;
	if (val < 4) 
		val = 4;
	val	= Math.floor(val);
	document.getElementById("txt_vertex").value = val;
	/*document.getElementById("lb_unexpl").innerHTML = "Unexplored:";
	document.getElementById("lb_expl").innerHTML = "Exploring:";
	document.getElementById("lb_onhull").innerHTML = "OnHull:";
	document.getElementById("lb_inhull").innerHTML = "InsideHull:";*/
	var verList = Processing.getInstanceById(id).startAppl(val);
	var secListArr = verList.split(";");
				document.getElementById("lb_unexpl").innerHTML = secListArr[0];
				document.getElementById("lb_expl").innerHTML = secListArr[1];
				document.getElementById("lb_onhull").innerHTML = secListArr[2];
				document.getElementById("lb_inhull").innerHTML = secListArr[3];
				Processing.getInstanceById(id).focus();
}

function isNumber(n) {
  return !isNaN(parseFloat(n)) && isFinite(n);
}


