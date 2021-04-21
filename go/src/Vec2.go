package main

import "math"

type Vec2 struct {
	x float64
	y float64
}

func (self Vec2) Clamp(min float64, max float64) (out Vec2) {
	out.x = math.Max(math.Min(self.x, max), min)
	out.y = math.Max(math.Min(self.y, max), min)
	return
}

func (self Vec2) ScalarSub(s float64) (out Vec2) {
	out.x = self.x - s
	out.y = self.y - s
	return
}

func (self Vec2) VecSub(v Vec2) (out Vec2) {
	out.x = self.x - v.x
	out.y = self.y - v.y
	return
}

func (self Vec2) ScalarAdd(s float64) (out Vec2) {
	out.x = self.x + s
	out.y = self.y + s
	return
}

func (self Vec2) VecAdd(v Vec2) (out Vec2) {
	out.x = self.x + v.x
	out.y = self.y + v.y
	return
}

func (self Vec2) ScalarDiv(s float64) (out Vec2) {
	out.x = self.x / s
	out.y = self.y / s
	return
}

func (self Vec2) VecDiv(v Vec2) (out Vec2) {
	out.x = self.x / v.x
	out.y = self.y / v.y
	return
}

func (self Vec2) ScalarMul(s float64) (out Vec2) {
	out.x = self.x * s
	out.y = self.y * s
	return
}

func (self Vec2) VecMul(v Vec2) (out Vec2) {
	out.x = self.x * v.x
	out.y = self.y * v.y
	return
}

func (self Vec2) Mag() (mag float64) {
	mag = math.Sqrt(
		math.Pow(self.x, 2) + math.Pow(self.y, 2))
	return
}

func (self Vec2) Norm() (normalized Vec2) {
	normalized = self.ScalarDiv(self.Mag())
	return
}

func (self Vec2) Dot(v Vec2) (dp float64) {
	dp = self.x*v.x + self.y*v.y
	return dp
}
