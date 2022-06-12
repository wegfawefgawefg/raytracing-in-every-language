import std/math

type
    Vec2* = array[2, float]

func zerovec2*(): Vec2 = 
    [0.0, 0.0]
func `+` *(a: Vec2, b: Vec2): Vec2 =
    [a[0] + b[0], a[1] + b[1]]
func `-` *(a: Vec2, b: Vec2): Vec2 =
    [a[0] - b[0], a[1] - b[1]]
func `*` *(a: Vec2, b: Vec2): Vec2 =
    [a[0] * b[0], a[1] * b[1]]
func `/` *(a: Vec2, b: Vec2): Vec2 =
    [a[0] / b[0], a[1] / b[1]]
func `+` *(a: Vec2, b: float): Vec2 =
    [a[0] + b, a[1] + b]
func `-` *(a: Vec2, b: float): Vec2 =
    [a[0] - b, a[1] - b]
func `*` *(a: Vec2, b: float): Vec2 =
    [a[0] * b, a[1] * b]
func `/` *(a: Vec2, b: float): Vec2 =
    [a[0] / b, a[1] / b]
func mag *(a: Vec2): float =
    sqrt(a[0] * a[0] + a[1] * a[1])
func norm *(a: Vec2): Vec2 =
    a / mag(a)
func `@` *(a: Vec2, b: Vec2): float = 
    a[0] * b[0] + a[1] * b[1]
func crush8 *(a: Vec2): array[2, uint8] = 
    [a[0].uint8, a[1].uint8]
func clamp *(a: Vec2, minimum: float, maximum: float): Vec2 = 
    [max(min(a[0], maximum), minimum), max(min(a[1], maximum), minimum)]

when isMainModule:
    let a: Vec2 = [1.0, 2.0]
    let b: Vec2 = [4.0, 5.0]
    assert(zeroVec2()+2.0 == [2.0, 2.0])