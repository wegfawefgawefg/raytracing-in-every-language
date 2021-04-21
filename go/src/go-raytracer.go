package main

import (
	"image"
	"image/color"
	"image/png"
	"log"
	"math"
	"os"
)

const width = 1920
const height = 1080

const maxSteps = 100.0
const minSurfaceDist = 0.005
const maxDist = 100.0

func getDist(p Vec3) (dist float64) {
	//	sphere
	s := Vec3{0.0, 1.0, 6.0}
	r := 1.0
	sd := p.VecSub(s).Mag() - r

	//dist = sd

	//	the ground
	pd := p.y

	//	keep whichever is closer
	dist = math.Min(sd, pd)
	return
}

func getNormal(p Vec3) (n Vec3) {
	delta := 0.01
	xDelta := Vec3{delta, 0.0, 0.0}
	yDelta := Vec3{0.0, delta, 0.0}
	zDelta := Vec3{0.0, 0.0, delta}

	d := getDist(p)

	dx := d - getDist(p.VecSub(xDelta))
	dy := d - getDist(p.VecSub(yDelta))
	dz := d - getDist(p.VecSub(zDelta))

	n = Vec3{dx, dy, dz}.Norm()
	return n
}

func march(ro Vec3, rd Vec3) (totalDist float64) {
	totalDist = 0.0
	for i := 0; i < maxSteps; i++ {
		p := ro.VecAdd(rd.ScalarMul(totalDist))
		dist := getDist(p)

		totalDist += dist
		if dist < minSurfaceDist || totalDist > maxDist {
			break
		}
	}
	return totalDist
}

func rayMarchCoord(xCoord int, yCoord int) (col Vec3) {
	fragCoord := Vec2{float64(xCoord), float64(yCoord)}
	uv := fragCoord.VecSub(
		Vec2{width, height}.ScalarMul(0.5)).ScalarDiv(height)

	//	scene
	light := Vec3{-3.0, 5.0, -1.0}

	//	fire ray for each pixel
	ro := Vec3{0.0, 1.0, 0.0}
	rd := Vec3{uv.x, uv.y, 1.0}.Norm()

	//	march the ray
	totalDist := march(ro, rd)
	hitPos := ro.VecAdd(rd.ScalarMul(totalDist))

	//	lighting
	//toCam := ro.VecSub(hitPos).Norm()
	toLight := light.VecSub(hitPos).Norm()
	normal := getNormal(hitPos)

	b := math.Max(normal.Dot(toLight), 0.0)

	col = Vec3{1.0, 1.0, 1.0}.ScalarMul(b)
	col = col.Clamp(0.0, 1.0).ScalarMul(255.0)

	return col
}

func main() {
	img := image.NewRGBA(image.Rect(0, 0, width, height))
	for y := 0; y <= height; y++ {
		for x := 0; x <= width; x++ {
			col := rayMarchCoord(x, y)
			col = col.Clamp(0, 255)
			img.Set(x, height-y, color.NRGBA{
				R: uint8(col.x),
				G: uint8(col.y),
				B: uint8(col.z),
				A: 255,
			})
		}
	}

	f, err := os.Create("render.png")
	if err != nil {
		log.Fatal(err)
	}

	if err := png.Encode(f, img); err != nil {
		f.Close()
		log.Fatal(err)
	}

	if err := f.Close(); err != nil {
		log.Fatal(err)
	}

}
