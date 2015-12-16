import "deps/phoenix_html/web/static/js/phoenix_html";
import { Ripple } from "./ripple";

const FIXED_NAVBAR = 'navbar-fixed-top';

function fix_navbar () {
	if (window.innerWidth < 768) {
		$('nav').removeClass(FIXED_NAVBAR);
	} else {
		$('nav').addClass(FIXED_NAVBAR);				
	}
};

$(window).resize(fix_navbar);
fix_navbar();

$('#application-form').click(function () {
	var other = document.querySelector('#application_priority_other');
	if (other && other.checked) {
		document.querySelector('#application_priority').disabled = false;
	} else {
		document.querySelector('#application_priority').disabled = true;
	}
});
