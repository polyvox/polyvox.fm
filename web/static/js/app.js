import 'babel-polyfill';
import { RippleSurface } from './ripple';
import { MarketingPlayer as Player } from './player';

var blank = document.getElementById('blank');
var listen = document.getElementById('listen');
var play = document.getElementById('play');
var radios = Array.from(document.querySelectorAll('input[type=radio]'));
var other_cb = document.getElementById('application_priority_other');
var other_tb = document.getElementById('application_priority');
if (play) {
  listen.addEventListener('mousedown', function _listenClick() {
    var player = new Player();
    player.init();
    blank.play();
    moveListenButton()
      .then(movePlayButton)
      .then(() => spinUntilInitialized(player))
      .then(setUpPlayerControls)
      .catch(e => console.log(e));
  });
}

if (other_cb) {
  for (var radio of radios) {
    radio.addEventListener('click', function _listenClick2() {
      setTimeout(() => {
        other_tb.disabled = !other_cb.checked;
        if (other_tb.disabled) {
          other_tb.value = '';
        } else {
          other_tb.focus();
        }
      }, 0);
    });
  }
}

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

function spinUntilInitialized(player) {
    return new Promise(good => {
        var story = document.getElementById('story');
        var surface = new RippleSurface(story, 500, '100%', play);
        var ready = false;
        player.addEventListener('ready', e => {
            ready = true;
        });

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

var linkForms = Array.from(document.querySelectorAll('[data-submit=parent]'));
for (var linkForm of linkForms) {
  linkForm.addEventListener('click', function (e) {
    e.preventDefault();
    if (!this.getAttribute('data-confirm') || confirm(this.getAttribute('data-confirm'))) {
      if (this.parentNode && this.parentNode.submit) {
        this.parentNode.submit();
      }
    }
  });
}
