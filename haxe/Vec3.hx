class Vec3 {
    public var x:Float;
    public var y:Float;
    public var z:Float;
    public function new(x:Float, y:Float, z:Float) {
        this.x=x; 
        this.y=y;
        this.z=z;
    }

    public function toString() {
        return "Vec3(" + this.x + ", " + this.y + ", " + this.z +")";
      }

    public function clamp(min:Float, max:Float) {
        return new Vec3(
            Math.max(Math.min(this.x, max), min),
            Math.max(Math.min(this.y, max), min),
            Math.max(Math.min(this.z, max), min)
        );
    }

    public function scalarSub(s:Float) {
        return new Vec3(
            this.x - s,
            this.y - s,
            this.z - s
        );
    }

    public function vecSub(v:Vec3) {
        return new Vec3(
            this.x - v.x,
            this.y - v.y,
            this.z - v.z
        );
    }

    public function scalarAdd(s:Float) {
        return new Vec3(
            this.x + s,
            this.y + s,
            this.z + s
        );
    }

    public function vecAdd(v:Vec3):Vec3 {
        return new Vec3(
            this.x + v.x,
            this.y + v.y,
            this.z + v.z
        );
    }

    public function scalarDiv(s:Float) {
        return new Vec3(
            this.x / s,
            this.y / s,
            this.z / s
        );
    }

    public function vecDiv(v:Vec3) {
        return new Vec3(
            this.x / v.x,
            this.y / v.y,
            this.z / v.z
        );
    }

    public function scalarMul(s:Float) {
        return new Vec3(
            this.x * s,
            this.y * s,
            this.z * s
        );
    }

    public function vecMul(v:Vec3) {
        return new Vec3(
            this.x * v.x,
            this.y * v.y,
            this.z * v.z
        );
    }

    public function mag() {
        return Math.sqrt(
            Math.pow(this.x, 2) +
            Math.pow(this.y, 2) +
            Math.pow(this.z, 2)
        );
    }

    public function norm() {
        return this.scalarDiv(this.mag());
    }

    public function dot(v:Vec3) {
        return this.x*v.x + this.y*v.y + this.z*v.z; 
    }
}