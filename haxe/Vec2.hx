class Vec2 {
    public var x:Float;
    public var y:Float;
    public function new(x:Float, y:Float) {
        this.x=x; 
        this.y=y;
    }

    public function toString() {
        return "Vec2(" + this.x + ", " + this.y + ")";
    }

    public function clamp(min:Float, max:Float) {
        return new Vec2(
            Math.max(Math.min(this.x, max), min),
            Math.max(Math.min(this.y, max), min)
        );
    }

    public function scalarSub(s:Float) {
        return new Vec2(
            this.x - s,
            this.y - s
        );
    }

    public function vecSub(v:Vec2) {
        return new Vec2(
            this.x - v.x,
            this.y - v.y
        );
    }

    public function scalarAdd(s:Float) {
        return new Vec2(
            this.x + s,
            this.y + s
        );
    }

    public function vecAdd(v:Vec2):Vec2 {
        return new Vec2(
            this.x + v.x,
            this.y + v.y
        );
    }

    public function scalarDiv(s:Float) {
        return new Vec2(
            this.x / s,
            this.y / s
        );
    }

    public function vecDiv(v:Vec2) {
        return new Vec2(
            this.x / v.x,
            this.y / v.y
        );
    }

    public function scalarMul(s:Float) {
        return new Vec2(
            this.x * s,
            this.y * s
        );
    }

    public function vecMul(v:Vec2) {
        return new Vec2(
            this.x * v.x,
            this.y * v.y
        );
    }

    public function mag() {
        return Math.sqrt(
            Math.pow(this.x, 2) +
            Math.pow(this.y, 2)
        );
    }

    public function norm() {
        return this.scalarDiv(this.mag());
    }

    public function dot(v:Vec2) {
        return this.x*v.x + this.y*v.y; 
    }
}