import Vec3;

class Raytracer {
    static public function makePPM(width:Int, height:Int, pixels:Array<Array<Vec3>>) {
        var im = sys.io.File.write("./image.ppm");
        im.writeString('P3\n$width $height\n255\n');
        for (y in 0...height) {
            for (x in 0...width) {
                var pixel:Vec3 = pixels[y][x];
                im.writeString('${pixel.x} ${pixel.y} ${pixel.z}\t');
            }
            im.writeString('\n');
        }
    }

    static public function main() {
        trace("Hello World");
        var width:Int = 256;
        var height:Int = 256;
        var pixels:Array<Array<Vec3>> = new Array();
        for (y in 0...height) {
            var row:Array<Vec3> = new Array();
            for (x in 0...width) {
                var r:Float = Math.random()*255.0;
                var g:Float = Math.random()*255.0;
                var b:Float = Math.random()*255.0;
                row.push(new Vec3(r, g, b));
            }
            pixels.push(row);
        }
        makePPM(width, height, pixels);
    }
}