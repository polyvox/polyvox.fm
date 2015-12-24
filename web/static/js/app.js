import "deps/phoenix_html/web/static/js/phoenix_html";

function firstPage() {
    var signUp = document.getElementById('sign-up'),
        story = document.getElementById('story'),
        logoHolder = document.getElementById('logo-holder'),
        combinedHeight = signUp.clientHeight + story.clientHeight,
        windowHeight = window.innerHeight,
        windowWidth = window.innerWidth;

    if (windowWidth < 768 && windowHeight - combinedHeight < 220) {
        logoHolder.style.height = windowHeight + 'px';
    } else if (windowHeight - combinedHeight < 300) {
        logoHolder.style.height = windowHeight + 'px';
    } else {
        logoHolder.style.height = (windowHeight - combinedHeight) + 'px';
    }
};

window.addEventListener('resize', firstPage);

setTimeout(firstPage, 100);
