
var exec = require('cordova/exec');

var WavToAacConverter = function() {
    if (!(this instanceof WavToAacConverter)) {
        return new WavToAacConverter();
    }
};

WavToAacConverter.prototype.convert = function(source, destination, progressCallback, errorCallback) {
    exec(progressCallback, errorCallback, 'WavToAacConverter', 'convert', [source, destination]);
};

WavToAacConverter.prototype.release = function() {
    exec(null, null, 'WavToAacConverter', 'release');
};

module.exports = WavToAacConverter;
