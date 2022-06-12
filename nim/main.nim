import simplepng

import Vec2
import Vec3

var MAX_STEPS: int = 100
var MIN_SURFACE_DIST: float = 0.005
var MAX_DIST: float = 100.0

func get_dist(p: Vec3): float = 
    #   sphere
    let s: Vec3 = [0.0, 1.0, 6.0]
    let r: float = 1.0
    let sd: float = mag(p-s) - r

    #   ground
    let pd: float = p[1]

    #   keep the closer one
    let dist = min(sd, pd)
    result = dist

func get_normal(p: Vec3): Vec3 = 
    let delta: float = 0.01
    let x_delta: Vec3 = [delta, 0.0, 0.0]
    let y_delta: Vec3 = [0.0, delta, 0.0]
    let z_delta: Vec3 = [0.0, 0.0, delta]

    let d: float = get_dist(p)

    let dx: float = d - get_dist(p - x_delta)
    let dy: float = d - get_dist(p - y_delta)
    let dz: float = d - get_dist(p - z_delta)

    let d3: Vec3 = [dx, dy, dz]
    let n: Vec3 = norm(d3)

    result = n

proc march(ro: Vec3, rd: Vec3): float =
    var total_dist = 0.0
    for i in 0..<MAX_STEPS:
        let p: Vec3 = ro + (rd * total_dist)
        let dist: float = get_dist(p)

        total_dist += dist
        if dist < MIN_SURFACE_DIST or total_dist > MAX_DIST:
            break

    return total_dist

proc ray_march_coord(width: int, height: int, xCoord: int, yCoord: int): Vec3 =
    let fragCoord: Vec2 = [xCoord.float, yCoord.float]
    let uv: Vec2 = (fragCoord - ([width.float, height.float] * 0.5)) / height.float

    # scene
    let light: Vec3 = [-3.0, 5.0, -1.0]

    # fire a ray for each pixel
    let ro: Vec3 = [0.0, 1.0, 0.0]
    let rd: Vec3 = norm([uv[0], uv[1], 1.0])

    # march the ray
    let total_dist: float = march(ro, rd)
    let hit_pos = ro + (rd * total_dist)

    # lighting
    let to_light: Vec3 = norm(light - hit_pos)
    let normal: Vec3 = get_normal(hit_pos)

    let b: float = max(normal @ to_light, 0.0)

    var col: Vec3 = [1.0, 1.0, 1.0] * b
    col = clamp(col, 0.0, 1.0) * 255.0

    result = col

proc main(): void = 
    let resolution = [(200, 200),(600, 600),(1920, 1080), (10_000, 10_000)][3]
    let width: int = resolution[0]
    let height: int = resolution[1]
    var im = initPixels(width, height)

    for y in 0..<resolution[1]:
        echo(y / height * 100.0, "%\r")
        for x in 0..<resolution[0]:
          let light: Vec3 = ray_march_coord(width, height, x, y)
          let col = crush8(clamp(light, 0.0, 255))
          var p = im.getPixel(x, height - y - 1)
          p.setColor(col[0], col[1], col[2], 255)

    simplePNG("./output.png", im)

main()