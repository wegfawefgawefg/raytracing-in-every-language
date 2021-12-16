class Vec3 {
    public var x:Float;
    public var y:Float;
    public var z:Float;
    public function new(x:Float, y:Float, z:Float) {
        this.x=x; 
        this.y=y;
        this.z=z;
    }

    @:op(A * B)
    public function vecSub(v Vec3) {
        return new Vec3(
            this.x - v.x,
            this.y - v.y,
            this.z - v.z,
        )
    }
}