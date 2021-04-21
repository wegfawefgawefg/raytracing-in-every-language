use std::fmt;

#[derive(Copy, Clone)]
pub struct Vec2 {
    pub x: f64,
    pub y: f64
}

impl fmt::Display for Vec2 {
    fn fmt(&self, f: &mut fmt::Formatter) -> fmt::Result {
        write!(f, "Vec3{{{:4.2}, {:4.2}}}", self.x, self.y)
    }
}

//  ADD
pub fn vec_add(a: Vec2, b: Vec2) -> Vec2 {
    Vec2{
        x: a.x + b.x,
        y: a.y + b.y}
}

pub fn scalar_add(a: Vec2, b: f64) -> Vec2 {
    Vec2{
        x: a.x + b,
        y: a.y + b}
}

//  SUB
pub fn vec_sub(a: Vec2, b: Vec2) -> Vec2 {
    Vec2{
        x: a.x - b.x,
        y: a.y - b.y}
}

pub fn scalar_sub(a: Vec2, b: f64) -> Vec2 {
    Vec2{
        x: a.x - b,
        y: a.y - b}
}

//  DIV
pub fn vec_div(a: Vec2, b: Vec2) -> Vec2 {
    Vec2{
        x: a.x / b.x,
        y: a.y / b.y}
}

pub fn scalar_div(a: Vec2, b: f64) -> Vec2 {
    Vec2{
        x: a.x / b,
        y: a.y / b}
}

//  MUL
pub fn vec_mul(a: Vec2, b: Vec2) -> Vec2 {
    Vec2{
        x: a.x * b.x,
        y: a.y * b.y}
}

pub fn scalar_mul(a: Vec2, b: f64) -> Vec2 {
    Vec2{
        x: a.x * b,
        y: a.y * b}
}

pub fn clamp(a: Vec2, min: f64, max: f64) -> Vec2 {
    Vec2{
        x: a.x.max(min).min(max),
        y: a.y.max(min).min(max)}
}

pub fn mag(a: Vec2) -> f64 {
    (a.x.powi(2) + a.y.powi(2)).sqrt()
}

pub fn norm(a: Vec2) -> Vec2 {
    let mag: f64 = mag(a);
    scalar_div(a, mag)
}

pub fn dot(a: Vec2, b: Vec2) -> f64 {
    a.x*b.x + a.y*b.y
}