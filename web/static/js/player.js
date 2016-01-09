var Analyzer = function () {};

if (!window.AudioContext && window.webkitAudioContext) {
    var globalAudioContext = new window.webkitAudioContext();
    class WebkitAnalyzer {
        constructor(url, done, ended) {
            let sampleRate = globalAudioContext.sampleRate;
            this._context = globalAudioContext;

            var source = this._context.createBufferSource();
            var analyzer = this._context.createAnalyser();
            analyzer.fftSize = 2048;

            source.buffer = this._context.createBuffer(2, sampleRate, sampleRate * 2.0);
            source.connect(analyzer);
            analyzer.connect(this._context.destination);
            source.start(0);

            this._done = done;
            this._startTime = 0;
            this._ended = ended;

            let request = new XMLHttpRequest();
            request.open('GET', url, true);
            request.responseType = 'arraybuffer';
            request.onload = this._responseLoaded.bind(this, request);
            request.send();
        }

        getByteFrequencyData() {
            if (!this._data) {
                return [];
            }
            this._analyzer.getByteFrequencyData(this._data);
            return this._data;
        }

        play() {
            if (!this._loaded) {
                return setTimeout(this.play.bind(this), 250);
            }
            this._source = this._context.createBufferSource();
            this._analyzer = this._context.createAnalyser();
            this._analyzer.fftSize = 2048;
            this._data = new Uint8Array(this._analyzer.frequencyBinCount);

            this._source.buffer = this._buffer;
            this._source.connect(this._analyzer);
            this._source.addEventListener('ended', this._ended);
            this._analyzer.connect(this._context.destination);
            this._source.start(0, this._startTime);

            return null;
        }

        pause() {
            if (this._context) {
                this._startTime = this._context.currentTime;
            }
            if (this._source) {
                this._source.removeEventListener('ended', this._ended);
                this._source.disconnect();
                this._source = null;
            }
            if (this._analyzer) {
                this._analyzer.disconnect();
                this._analyzer = null;
            }
            if (this._data) {
                this._data = null;
            }
        }

        _responseLoaded(request) {
            var audioData = request.response;
            this._context.decodeAudioData(audioData, buffer => {
                this._buffer = buffer;
                this._loaded = true;
                this._done();
            });
        }
    }

    Analyzer = WebkitAnalyzer;
} else if (window.AudioContext) {
    class NormalAnalyzer {
        constructor(url, done, ended) {
            this._audio = document.createElement('audio');
            this._audio.src = url;
            this._audio.addEventListener('ended', ended);
            document.body.appendChild(this._audio);

            this._context = new window.AudioContext();
            this._source = this._context.createMediaElementSource(this._audio);
            this._analyzer = this._context.createAnalyser();
            this._analyzer.fftSize = 2048;

            this._data = new Uint8Array(this._analyzer.frequencyBinCount);

            this._source.connect(this._analyzer);
            this._analyzer.connect(this._context.destination);

            done();
        }

        play() {
            this._audio.play();
        }

        pause() {
            this._audio.pause();
        }

        getByteFrequencyData() {
            this._analyzer.getByteFrequencyData(this._data);
            return this._data;
        }
    }

    Analyzer = NormalAnalyzer;
} else {
    class DumbAnalyzer {
        constructor (url, done, ended) {
            this._audio = document.createElement('audio');
            this._audio.src = url;
            this._data = 0;
            this._audio.addEventListener('ended', ended);
            document.body.appendChild(this._audio);

            done();
        }

        play() {
            this._playing = true;
            this._audio.play();
        }

        pause() {
            this._playing = false;
            this._audio.pause();
        }

        getByteFrequencyData() {
            if (!this._playing) {
                return [0];
            }
            var data = 35 - Math.abs(17 - this._data);
            this._data += 0.75;
            this._data = this._data % 35;
            return [data];
        }
    }

    Analyzer = DumbAnalyzer;
}

export class MarketingPlayer {
    constructor() {
        this._eventListeners = [];
        this._previousVolume = -1;
        this._volume = 0;
    }

    init() {
        let ready = this._fire.bind(this, 'ready');
        let ended = this._fire.bind(this, 'ended');
        this._analyzer = new Analyzer('./audio/intro.mp3', ready, ended);
    }

    play() {
        this._analyzer.play();
        window.requestAnimationFrame(this._monitorVolume.bind(this));
    }

    pause() {
        this._analyzer.pause();
    }

    addEventListener(name, fn) {
        this._eventListeners[name] = this._eventListeners[name] || [];
        this._eventListeners[name].push(fn);

        if (this['_' + name]) {
            this._fire(name);
        }
    }

    _monitorVolume() {
        if (this._stopMonitoring) {
            return;
        }
        let ppv = this._previousVolume;
        let pv = this._volume;
        let volume = 0;
        let data = this._analyzer.getByteFrequencyData();
        for (var i = 0; i < data.length; i += 1) {
            if (!isNaN(data[i])) {
                volume += data[i];
            }
        }
        volume = volume / data.length;
        if (pv > volume && pv > ppv) {
            this._fire('dipped');
        }

        this._previousVolume = this._volume;
        this._volume = volume;

        window.requestAnimationFrame(this._monitorVolume.bind(this));
    }

    _fire(name, e) {
        if (name === 'ended') {
            this._stopMonitoring = true;
        }
        if (name === 'ready') {
            this._ready = true;
        }
        var listeners = this._eventListeners[name] || [];
        for (var listener of listeners) {
            listener(e);
        }
    }
}
