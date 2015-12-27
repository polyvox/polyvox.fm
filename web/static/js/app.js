import 'babel-polyfill';
import 'deps/phoenix_html/web/static/js/phoenix_html';
import { RippleSurface } from './ripple';
import { MarketingPlayer as Player } from './player';

var listen = document.getElementById('listen');
var play = document.getElementById('play');
listen.addEventListener('click', function _listenClick() {
    listen.removeEventListener('click', _listenClick);
    moveListenButton()
        .then(movePlayButton)
        .then(spinUntilInitialized)
        .then(setUpPlayerControls)
        .catch(e => console.log(e));
});

function once(el, name, fn) {
    el.addEventListener(name, function _bindy() {
        el.removeEventListener(name, _bindy);
        fn();
    });
}

function moveListenButton() {
    return new Promise(good => {
        once(listen, 'transitionend', good);
        listen.classList.add('disappear');
    });
}

function movePlayButton() {
    return new Promise(good => {
        listen.style.position = 'absolute';
        play.style.position = 'relative';
        once(play, 'transitionend', good);
        setTimeout(function () { play.classList.add('appear'); }, 0);
    });
}

function spinUntilInitialized() {
    return new Promise(good => {
        var story = document.getElementById('story');
        var player = new Player();
        var surface = new RippleSurface(story, 500, '100%', play);
        var ready = false;

        player.addEventListener('ready', e => {
            ready = true;
        });
        player.init();

        play.classList.add('spin');
        play.addEventListener('animationiteration', function _iterationend() {
            if (ready) {
                play.removeEventListener('animationiteration', _iterationend);
                play.classList.remove('spin');
                good([player, surface]);
            }
        });
    });
}

function setUpPlayerControls([player, surface]) {
    let ended = false;
    let icon = play.querySelector('i');

    player.addEventListener('dipped', surface.ripple.bind(surface));

    player.addEventListener('ended', () => {
        icon.innerHTML = 'p';
        icon.style.fontFamily = 'Righteous';
        ended = true;
    });

    return new Promise(good => {
        function start() {
            if (ended) {
                return;
            }
            icon.innerHTML = 'pause';
            player.play();
            once(play, 'click', pause);
        }

        function pause() {
            if (ended) {
                return;
            }
            icon.innerHTML = 'play_arrow';
            player.pause();
            once(play, 'click', start);
        }

        start();
    });
}
