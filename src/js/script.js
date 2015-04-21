$(document).ready(function () {
	var subnav, vbtn;
	subnav = $("#subnav").on("mouseleave", function(){
		subnav.removeClass("is-shown");
	});
	vbtn = $("#select_veh_btn a").on("mouseenter", function () {
		subnav.addClass("is-shown");
	});
});