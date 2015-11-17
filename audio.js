var Polyvox = {
    Audio: {
	Analyzer: undefined
    }
};

if (!window.AudioContext && window.webkitAudioContext) {
    Polyvox.Audio.Analyzer = function (url) {
    	this._context = new window.webkitAudioContext();
	this._source = this._context.createBufferSource();
	this._analyzer = this._context.createAnalyser();
	this._analyzer.fftSize = 2048;
	this._data = new Uint8Array(this._analyzer.frequencyBinCount);

	var request = new XMLHttpRequest();
	request.open('GET', url, true);
	request.responseType = 'arraybuffer';

	request.onload = (function () {
	    var audioData = request.response;

	    this._context.decodeAudioData(audioData, (function (buffer) {
		this._source.buffer = buffer;
		this._source.connect(this._analyzer);
		this._analyzer.connect(this._context.destination);
		this._loaded = true;
	    }).bind(this));
	}).bind(this);

	request.send();
    };

    Polyvox.Audio.Analyzer.prototype = {
	play: function () {
	    if (!this._loaded) {
		return setTimeout(this.play.bind(this), 250);
	    }
	    this._source.start();
	},

	pause: function () {
	    this._source.stop();
	},

	getByteFrequencyData: function () {
	    this._analyzer.getByteFrequencyData(this._data);
	    return this._data;
	},

	addEventListener: function (name, callback) {
	}
    };
} else if (window.AudioContext) {
    Polyvox.Audio.Analyzer = function (url) {
	this._audio = document.createElement('audio');
	this._audio.src = url;
	this._audio.autoplay = true;
	document.body.appendChild(this._audio);

    	this._context = new window.AudioContext();
	this._source = this._context.createMediaElementSource(this._audio);
	this._analyzer = this._context.createAnalyser();
	this._analyzer.fftSize = 2048;

	this._data = new Uint8Array(this._analyzer.frequencyBinCount);

	this._source.connect(this._analyzer);
	this._analyzer.connect(this._context.destination);
    };

    Polyvox.Audio.Analyzer.prototype = {
	play: function () {
	    this._audio.play();
	},

	pause: function () {
	    this._audio.pause();
	},

	getByteFrequencyData: function () {
	    this._analyzer.getByteFrequencyData(this._data);
	    return this._data;
	},

	addEventListener: function (name, callback) {
	    if (name === 'ended') {
		this._audio.addEventListener('ended', callback);
	    }
	}
    };
}
