var Polyvox = {
    Audio: {
	Analyzer: undefined
    }
};

if (!window.AudioContext && window.webkitAudioContext) {
    Polyvox.Audio.Analyzer = function (url) {
    	this._context = new window.webkitAudioContext();
	this._startTime = 0;
	this._onend = (function () {
	    for(var i = 0; i < this._ended.length; i += 1) {
		this._ended[i]();
	    }
	}).bind(this);

	var request = new XMLHttpRequest();
	request.open('GET', url, true);
	request.responseType = 'arraybuffer';

	request.onload = (function () {
	    var audioData = request.response;

	    this._context.decodeAudioData(audioData, (function (buffer) {
		this._buffer = buffer;
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
	    this._source = this._context.createBufferSource();
	    this._analyzer = this._context.createAnalyser();
	    this._analyzer.fftSize = 2048;
	    this._data = new Uint8Array(this._analyzer.frequencyBinCount);

	    this._source.buffer = this._buffer;
	    this._source.connect(this._analyzer);
	    this._source.addEventListener('ended', this._onend);
	    this._analyzer.connect(this._context.destination);
	    this._source.start(0, this._startTime);
	},

	pause: function () {
	    if (this._context) {
		this._startTime = this._context.currentTime;
	    }
	    if (this._source) {
		this._source.removeEventListener('ended', this._onend);
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
	},

	getByteFrequencyData: function () {
	    if (!this._data) {
		return [];
	    }
	    this._analyzer.getByteFrequencyData(this._data);
	    return this._data;
	},

	addEventListener: function (name, callback) {
	    if (name === 'ended') {
		this._ended = this._ended || [];
		this._ended.push(callback);
	    }
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
} else  {
    Polyvox.Audio.Analyzer = function (url) {
	this._audio = document.createElement('audio');
	this._audio.src = url;
	this._audio.autoplay = true;
	this._data = 0;
	document.body.appendChild(this._audio);
    };

    Polyvox.Audio.Analyzer.prototype = {
	play: function () {
	    this._playing = true;
	    this._audio.play();
	},

	pause: function () {
	    this._playing = false;
	    this._audio.pause();
	},

	getByteFrequencyData: function () {
	    if (!this._playing) {
		return [0];
	    }
	    var data = 35 - Math.abs(17 - this._data);
	    console.log(this._data, data);
	    this._data += 0.75;
	    this._data = this._data % 35;
	    return [ data ];
	},

	addEventListener: function (name, callback) {
	    if (name === 'ended') {
		this._audio.addEventListener('ended', callback);
	    }
	}
    };
}
