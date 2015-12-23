import "deps/phoenix_html/web/static/js/phoenix_html";

function showRatio() {
    var footer = document.getElementsByTagName('footer')[0];
    footer.innerHTML = window.innerWidth + '/' + window.innerHeight + '=' + (window.innerWidth / window.innerHeight);
}

showRatio();

window.addEventListener('resize', showRatio);

