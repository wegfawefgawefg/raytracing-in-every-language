use std::fmt;

#[derive(Copy, Clone)]
pub struct Vec3 {
    pub x: f64,
    pub y: f64,
    pub z: f64
}

impl fmt::Display for Vec3 {
    fn fmt(&self, f: &mut fmt::Formatter) -> fmt::Result {
        write!(f, "Vec3{{{:4.2}, {:4.2}, {:4.2}}}", self.x, self.y, self.z)
    }
}

//  ADD
pub fn vec_add(a: Vec3, b: Vec3) -> Vec3 {
    Vec3{
        x: a.x + b.x,
        y: a.y + b.y,
        z: a.z + b.z}
}

pub fn scalar_add(a: Vec3, b: f64) -> Vec3 {
    Vec3{
        x: a.x + b,
        y: a.y + b,
        z: a.z + b}
}

//  SUB
pub fn vec_sub(a: Vec3, b: Vec3) -> Vec3 {
    Vec3{
        x: a.x - b.x,
        y: a.y - b.y,
        z: a.z - b.z}
}

pub fn scalar_sub(a: Vec3, b: f64) -> Vec3 {
    Vec3{
        x: a.x - b,
        y: a.y - b,
        z: a.z - b}
}

//  DIV
pub fn vec_div(a: Vec3, b: Vec3) -> Vec3 {
    Vec3{
        x: a.x / b.x,
        y: a.y / b.y,
        z: a.z / b.z}
}

pub fn scalar_div(a: Vec3, b: f64) -> Vec3 {
    Vec3{
        x: a.x / b,
        y: a.y / b,
        z: a.z / b}
}

//  MUL
pub fn vec_mul(a: Vec3, b: Vec3) -> Vec3 {
    Vec3{
        x: a.x * b.x,
        y: a.y * b.y,
        z: a.z * b.z}
}

pub fn scalar_mul(a: Vec3, b: f64) -> Vec3 {
    Vec3{
        x: a.x * b,
        y: a.y * b,
        z: a.z * b}
}

pub fn clamp(a: Vec3, min: f64, max: f64) -> Vec3 {
    Vec3{
        x: a.x.max(min).min(max),
        y: a.y.max(min).min(max),
        z: a.z.max(min).min(max)}
}

pub fn mag(a: Vec3) -> f64 {
    (a.x.powi(2) + a.y.powi(2) + a.z.powi(2)).sqrt()
}

pub fn norm(a: Vec3) -> Vec3 {
    let mag: f64 = mag(a);
    scalar_div(a, mag)
}

pub fn dot(a: Vec3, b: Vec3) -> f64 {
    a.x*b.x + a.y*b.y + a.z*b.z
}