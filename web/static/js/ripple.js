const SVG_NS = 'http://www.w3.org/2000/svg';
const GROW_DELTA = 2.5;

export class RippleSurface {
    constructor(container, height, width, center) {
        var s = this._surface = document.createElementNS(SVG_NS, 'svg');
        s.setAttribute('width', width);
        s.setAttribute('height', container.offsetHeight);
        s.setAttribute('style', 'position: absolute; bottom: 0; left: 0;');
        container.insertBefore(s, center);

        this._centered = {
            x: center.offsetLeft + center.clientWidth / 2,
            y: center.offsetTop + center.clientHeight / 2,
            width: center.clientWidth,
            height: center.clientHeight
        };

        window.addEventListener('resize', () => {
            s.setAttribute('height', container.offsetHeight);
            this._centered.x = center.offsetLeft + center.clientWidth / 2;
            this._centered.y = center.offsetTop + center.clientHeight / 2;
        });
    }

    ripple() {
        var r = new Ripple(this._centered, this._surface);
    }
}

class Ripple {
    constructor({x, y, width, height}, surface) {
        this._opacity = 1;
        this._x = x;
        this._y = y;
        this._width = width;
        this._height = height;
        this._strokeWidth = 1;
        this._cornerRadius = 0;

        var n = this._node = surface.ownerDocument.createElementNS(SVG_NS, 'rect');
        n.setAttribute('stroke', 'white');
        n.setAttribute('fill', 'none');
        surface.appendChild(n);

        window.requestAnimationFrame(this._update.bind(this));
    }

    _update() {
        this._width += GROW_DELTA;
        this._height += GROW_DELTA;
        this._opacity -= 0.01;
        this._strokeWidth += 0.03;
        this._cornerRadius += GROW_DELTA / 5;

        if (this._opacity < 0) {
            if (this._node != null) {
                this._node.parentNode.removeChild(this._node);
            }
            this._node = null;
            return;
        }

        let n = this._node;
        let {_strokeWidth: sw, _cornerRadius: r, _opacity: opac, _x: x, _y: y, _width: w, _height: h} = this;
        n.setAttribute('stroke-width', sw);
        n.setAttribute('opacity', opac);
        n.setAttribute('x', x - w / 2 + 1);
        n.setAttribute('y', y - h / 2 + 1);
        n.setAttribute('width', w - 1);
        n.setAttribute('height', h - 1);
        n.setAttribute('rx', r);
        n.setAttribute('ry', r);

        window.requestAnimationFrame(this._update.bind(this));
    }
}
