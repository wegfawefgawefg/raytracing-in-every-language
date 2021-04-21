package main

import "math"

type Vec3 struct {
	x float64
	y float64
	z float64
}

func (self Vec3) Clamp(min float64, max float64) (out Vec3) {
	out.x = math.Max(math.Min(self.x, max), min)
	out.y = math.Max(math.Min(self.y, max), min)
	out.z = math.Max(math.Min(self.z, max), min)
	return
}

func (self Vec3) ScalarSub(s float64) (out Vec3) {
	out.x = self.x - s
	out.y = self.y - s
	out.z = self.z - s
	return
}

func (self Vec3) VecSub(v Vec3) (out Vec3) {
	out.x = self.x - v.x
	out.y = self.y - v.y
	out.z = self.z - v.z
	return
}

func (self Vec3) ScalarAdd(s float64) (out Vec3) {
	out.x = self.x + s
	out.y = self.y + s
	out.z = self.z + s
	return
}

func (self Vec3) VecAdd(v Vec3) (out Vec3) {
	out.x = self.x + v.x
	out.y = self.y + v.y
	out.z = self.z + v.z
	return
}

func (self Vec3) ScalarDiv(s float64) (out Vec3) {
	out.x = self.x / s
	out.y = self.y / s
	out.z = self.z / s
	return
}

func (self Vec3) VecDiv(v Vec3) (out Vec3) {
	out.x = self.x / v.x
	out.y = self.y / v.y
	out.z = self.z / v.z
	return
}

func (a Vec3) ScalarMul(s float64) (out Vec3) {
	out.x = a.x * s
	out.y = a.y * s
	out.z = a.z * s
	return
}

func (self Vec3) VecMul(v Vec3) (out Vec3) {
	out.x = self.x * v.x
	out.y = self.y * v.y
	out.z = self.z * v.z
	return
}

func (self Vec3) Mag() (mag float64) {
	mag = math.Sqrt(
		math.Pow(self.x, 2) +
			math.Pow(self.y, 2) +
			math.Pow(self.z, 2))
	return
}

func (self Vec3) Norm() (normalized Vec3) {
	normalized = self.ScalarDiv(self.Mag())
	return
}

func (self Vec3) Dot(v Vec3) (dp float64) {
	dp = self.x*v.x +
		self.y*v.y +
		self.z*v.z
	return dp
}
