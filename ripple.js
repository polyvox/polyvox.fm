function Ripple (radius, ripples, offsetX, offsetY) {
    this._radius = radius;
    this._opacity = 1;
    this.node = ripples.ownerDocument.createElementNS('http://www.w3.org/2000/svg', 'circle');
    this.node.setAttribute('stroke', '#F9A825');
    this.node.setAttribute('stroke-width', '4');
    this.node.setAttribute('fill', 'none');
    this.node.setAttribute('cx', offsetX);
    this.node.setAttribute('cy', offsetY);
    ripples.appendChild(this.node);

    this._update();
    
    window.requestAnimationFrame(this.start.bind(this));
    
    return this;
}

Ripple.prototype._update = function () {
    this.node.setAttribute('opacity', this._opacity);
    this.node.setAttribute('r', this._radius);
};			

Ripple.prototype.start = function () {
    this._radius += 2;
    this._opacity -= 0.01;

    if (this._opacity < 0) {
	if (this.node != null) {
	    this.node.parentNode.removeChild(this.node);
	}
	this.node = null;
	return;
    }

    this._update();

    window.requestAnimationFrame(this.start.bind(this));
};

