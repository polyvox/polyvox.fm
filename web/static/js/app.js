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

