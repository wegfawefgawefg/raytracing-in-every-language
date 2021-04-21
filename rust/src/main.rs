//pub struct vec3::Vec3<N> {
//    pub x: N,
//    pub y: N,
//    pub z: N,
//}
use png;

#[allow(dead_code)]
mod vec3;

#[allow(dead_code)]
mod vec2;

const WIDTH: i32 = 256;
const HEIGHT: i32 = 256;
const MAX_STEPS: i64 = 50;
const MINN_SURFACE_DIST: f64 = 0.005;
const MAX_DIST: f64 = 100.0;

pub fn get_dist(p: vec3::Vec3) -> f64 {
    //  sphere
    let s: vec3::Vec3 = vec3::Vec3{x: 0.0, y:  1.0, z: 6.0};
    let r: f64 = 1.0;
    let sd: f64 = vec3::mag(vec3::vec_sub(p, s)) - r;

    //dist = sd

    //  the ground
    let pd: f64 = p.y;

    pd.min(sd)
}

pub fn get_normal(p: vec3::Vec3) -> vec3::Vec3 {
    let delta: f64 = 0.01;
	let x_delta: vec3::Vec3 = vec3::Vec3{x: delta, y: 0.0, z: 0.0};
	let y_delta: vec3::Vec3 = vec3::Vec3{x: 0.0, y: delta, z: 0.0};
	let z_delta: vec3::Vec3 = vec3::Vec3{x: 0.0, y: 0.0, z: delta};

    let d: f64 = get_dist(p);

    let dx: f64 = d - get_dist(vec3::vec_sub(p, x_delta));
    let dy: f64 = d - get_dist(vec3::vec_sub(p, y_delta));
    let dz: f64 = d - get_dist(vec3::vec_sub(p, z_delta));

    vec3::norm(vec3::Vec3{x: dx, y: dy, z: dz})
}

pub fn march(ro: vec3::Vec3, rd: vec3::Vec3) -> f64 {
    let mut total_dist: f64 = 0.0;
    let mut i: i64 = 0;
    while i < MAX_STEPS {
        let p: vec3::Vec3 = vec3::vec_add(ro, vec3::scalar_mul(rd, total_dist));
        let dist: f64 = get_dist(p);

        total_dist += dist;
        if (dist < MINN_SURFACE_DIST) || (total_dist > MAX_DIST) {
            break
        }

        i = i + 1;
    }

    return total_dist;
}

pub fn ray_march_coord(x_coord: i32, y_coord: i32) -> vec3::Vec3 {
    let frag_coord: vec2::Vec2 = vec2::Vec2{x: x_coord as f64, y: y_coord as f64};
    let dims: vec2::Vec2 = vec2::Vec2{x: WIDTH as f64, y: HEIGHT as f64};
    let uv: vec2::Vec2 = vec2::scalar_div(
        vec2::vec_sub(
            frag_coord, vec2::scalar_mul(dims, 0.5)),
        HEIGHT as f64);
    
    //  scene
    let light: vec3::Vec3 = vec3::Vec3{x: -3.0, y: 5.0, z: -1.0};

    //  fire ray for each pixel
    let ro: vec3::Vec3 = vec3::Vec3{x: 0.0, y: 1.0, z: 0.0};
	let rd: vec3::Vec3 = vec3::norm(vec3::Vec3{x: uv.x, y: uv.y, z: 1.0});

    //  march the ray
    let total_dist: f64 = march(ro, rd);
    let hit_pos: vec3::Vec3 = vec3::vec_add(ro,
        vec3::scalar_mul(rd, total_dist));

    //  lighting
    let to_light: vec3::Vec3 = vec3::norm(vec3::vec_sub(light, hit_pos));
    let normal: vec3::Vec3 = get_normal(hit_pos);

    let b: f64 = vec3::dot(normal, to_light).max(0.0);

    let mut col: vec3::Vec3 = vec3::scalar_mul(
        vec3::Vec3{x: 1.0, y: 1.0, z: 1.0}, b);
    col = vec3::clamp(col, 0.0, 1.0);
    col = vec3::scalar_mul(col, 255.0);

    return col;
}

fn main() {
    //println!("{}", r);

    // For reading and opening files
    use std::path::Path;
    use std::fs::File;
    use std::io::BufWriter;

    let path = Path::new(r"./render.png");
    let file = File::create(path).unwrap();
    let ref mut w = BufWriter::new(file);

    let mut encoder = png::Encoder::new(w, WIDTH as u32, HEIGHT as u32); // Width is 2 pixels and height is 1.
    encoder.set_color(png::ColorType::RGBA);
    encoder.set_depth(png::BitDepth::Eight);
    let mut writer = encoder.write_header().unwrap();

    const NUM_DATA: usize = (WIDTH as usize) * (HEIGHT as usize) * 4;
    //let mut data: [u8; NUM_DATA] = [0; NUM_DATA];
    let mut data = vec![0_u8; NUM_DATA];
    let mut y: i32 = 0;
    let mut x: i32;
    let mut col: vec3::Vec3;
    while y < HEIGHT {  //  never terminating.... stack overflow
        x = 0;
        while x < HEIGHT {
            col = ray_march_coord(x, y);
            col = vec3::clamp(col, 0.0, 255.0);
            let i: i32 = ((HEIGHT - y - 1) * WIDTH + x) * 4;
            data[(i+0) as usize] = col.x as u8;
            data[(i+1) as usize] = col.y as u8;
            data[(i+2) as usize] = col.z as u8;
            data[(i+3) as usize] = 255;

            x += 1;
        }
        y += 1;
    }

    writer.write_image_data(&data).unwrap(); // Save
}
