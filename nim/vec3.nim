import std/math

type
    Vec3* = array[3, float]

func zerovec3*(): Vec3 = 
    [0.0, 0.0, 0.0]
func `+` *(a: Vec3, b: Vec3): Vec3 =
    [a[0] + b[0], a[1] + b[1], a[2] + b[2]]
func `-` *(a: Vec3, b: Vec3): Vec3 =
    [a[0] - b[0], a[1] - b[1], a[2] - b[2]]
func `*` *(a: Vec3, b: Vec3): Vec3 =
    [a[0] * b[0], a[1] * b[1], a[2] * b[2]]
func `/` *(a: Vec3, b: Vec3): Vec3 =
    [a[0] / b[0], a[1] / b[1], a[2] / b[2]]
func `+` *(a: Vec3, b: float): Vec3 =
    [a[0] + b, a[1] + b, a[2] + b]
func `-` *(a: Vec3, b: float): Vec3 =
    [a[0] - b, a[1] - b, a[2] - b]
func `*` *(a: Vec3, b: float): Vec3 =
    [a[0] * b, a[1] * b, a[2] * b]
func `/` *(a: Vec3, b: float): Vec3 =
    [a[0] / b, a[1] / b, a[2] / b]
func mag *(a: Vec3): float =
    sqrt(a[0] * a[0] + a[1] * a[1] + a[2] * a[2])
func norm *(a: Vec3): Vec3 =
    a / mag(a)
func `@` *(a: Vec3, b: Vec3): float = 
    a[0] * b[0] + a[1] * b[1] + a[2] * b[2]
func crush8 *(a: Vec3): array[3, uint8] = 
    [a[0].uint8, a[1].uint8, a[2].uint8]
func clamp *(a: Vec3, minimum: float, maximum: float): Vec3 = 
    [max(min(a[0], maximum), minimum), max(min(a[1], maximum), minimum), max(min(a[2], maximum), minimum)]

when isMainModule:
    let a: Vec3 = [1.0, 2.0, 3.0]
    let b: Vec3 = [4.0, 5.0, 6.0]
    assert(zerovec3()+2.0 == [2.0, 2.0, 2.0])