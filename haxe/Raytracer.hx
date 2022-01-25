import Vec3;
import VoxelObject;

class Raytracer {
    static public var WIDTH:Int = 128;//3840;
    static public var HEIGHT:Int = 128;//2160;

    static public var MAX_STEPS:Int = 100;
    static public var MIN_SURFACE_DIST:Float = 0.005;
    static public var MAX_DIST:Float = 100;

    public var vod:Float = 10;
    public var voxelObject = new VoxelObject(
        new Vec3(
            0.0-vod/2, 
            1.0-vod/2, 
            vod), 
        vod);

    public function new() {}

    static public function makePPM(width:Int, height:Int, pixels:Array<Array<Vec3>>) {
        var im = sys.io.File.write("./image.ppm");
        im.writeString('P3\n${width} ${height}\n255\n');
        for (y in 0...height) {
            for (x in 0...width) {
                var pixel:Vec3 = pixels[y][x];
                im.writeString('${pixel.x} ${pixel.y} ${pixel.z}\t');
            }
            im.writeString('\n');
        }
    }

    public function getDist(p:Vec3):Float {
        //	sphere
        var s:Vec3 = new Vec3(0.0, 1.0, 6.0);
        // var r:Float = 1.0;
        var r:Float = 1.0 + Math.floor(Math.sin(p.y*20.0)*0.1 + Math.sin(p.x*20.0)*0.1);
        var sd:Float = p.vecSub(s).mag() - r;
        
        // voxel object
        var vd:Float = 10000.0;
        if (this.voxelObject.isHit(p)) {
            vd = 0.00001;
        }
        
        //	the ground
        var pd:Float = p.y;
    
        //	keep whichever is closer
        var dist:Float = 1000.0;
        // dist = Math.min(dist, sd);
        dist = Math.min(dist, vd);
        dist = Math.min(dist, pd);

        return dist;
    }

    public function getNormal(p:Vec3):Vec3 {
        var delta:Float = 0.01;
        var xDelta:Vec3 = new Vec3(delta, 0.0, 0.0);
        var yDelta:Vec3 = new Vec3(0.0, delta, 0.0);
        var zDelta:Vec3 = new Vec3(0.0, 0.0, delta);
    
        var d:Float = getDist(p);
    
        var dx:Float = d - getDist(p.vecSub(xDelta));
        var dy:Float = d - getDist(p.vecSub(yDelta));
        var dz:Float = d - getDist(p.vecSub(zDelta));
    
        var n:Vec3 = new Vec3(dx, dy, dz).norm();
        
        return n;
    }

    public function march(ro:Vec3, rd:Vec3):Float {
        var totalDist:Float = 0.0;
        for (i in 0...Raytracer.MAX_STEPS) {
            var p:Vec3 = ro.vecAdd(rd.scalarMul(totalDist));
            var dist:Float = getDist(p);
    
            totalDist += dist;
            if ((dist < Raytracer.MIN_SURFACE_DIST) || (totalDist > Raytracer.MAX_DIST)){
                break;
            }
        }
        return totalDist;
    }

    public function rayMarchCoord(xCoord:Int, yCoord:Int):Vec3 {
        // TODO: shift by half screen later
        var fragCoord = new Vec2(xCoord, yCoord);
        var uv:Vec2 = fragCoord.vecSub(
            new Vec2(Raytracer.WIDTH, Raytracer.HEIGHT).scalarMul(0.5)).scalarDiv(Raytracer.HEIGHT);
        
        //  scene
        var light:Vec3 = new Vec3(-3.0, 5.0, -1.0);

        //  fire ray for each pixel
        var ro:Vec3 = new Vec3(0.0, 1.0, 0.0);
        var rd:Vec3 = new Vec3(uv.x, uv.y, 1.0).norm();

        //  march the ray
        var totalDist:Float = march(ro, rd);
        var hitPos:Vec3 = ro.vecAdd(rd.scalarMul(totalDist));

        //  lighting
        var toLight:Vec3 = light.vecSub(hitPos).norm();
        var normal:Vec3 = getNormal(hitPos);

        // var b:Float = Math.max(normal.dot(toLight), 0.0);
        var b:Float = (1.0 - (totalDist / Raytracer.MAX_DIST)) * 0.2;

        var col:Vec3 = new Vec3(1.0, 1.0, 1.0).scalarMul(b);
        col = col.clamp(0.0, 1.0).scalarMul(255.0);

        return col;
    }

    public function raytrace() {
        var pixels:Array<Array<Vec3>> = new Array();
        
        for (y in 0...Raytracer.HEIGHT) {
            if ((y%(Raytracer.HEIGHT / 10)) == 0) trace('${y / Raytracer.HEIGHT * 100.0}%');
            var row:Array<Vec3> = new Array();
            for (x in 0...Raytracer.WIDTH) {
                var col:Vec3 = rayMarchCoord(x, Raytracer.HEIGHT - y);
                col = col.clamp(0, 255);
                row.push(col);
            }
            pixels.push(row);
        }
        makePPM(Raytracer.WIDTH, Raytracer.HEIGHT, pixels);
    }
}