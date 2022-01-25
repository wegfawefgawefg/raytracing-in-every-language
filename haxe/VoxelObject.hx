import Vec3;

class VoxelObject {
    public var pos:Vec3;

    public var depth:Int;
    public var voxels:Array<Array<Array<Bool>>>;

    public function new(p:Vec3, d:Int) {
        this.pos = p.clone();
        this.depth = d;
        this.voxels = [
            for (x in 0...this.depth) [
                for (y in 0...this.depth) [
                    for (z in 0...this.depth) false]]];
        

        var r:Float = this.depth/2;
        var center:Vec3 = new Vec3(r, r, r);
        
        var total:Int = 0;
        for (z in 0...this.depth) {
            for (y in 0...this.depth) {
                for (x in 0...this.depth) {
                    var p:Vec3 = new Vec3(x, y, z);
                    var d:Float = center.vecSub(p).mag();
                    if (d < r) {
                        this.voxels[z][y][x] = true;
                        total++;
                    }
                }
            }
        }
        trace("total voxels: " + total);
    }


    public function isHit(p:Vec3):Bool {
        // first check if its in the bounding box
        if (p.x < this.pos.x || p.x > (this.pos.x+this.depth) ||
            p.y < this.pos.y || p.y > (this.pos.y+this.depth) ||
            p.z < this.pos.z || p.z > (this.pos.z+this.depth)) {
            return false;
        }
        else {
            return true;
            // return voxels[Std.int(z)][Std.int(y)][Std.int(x)];
        }
    }
}