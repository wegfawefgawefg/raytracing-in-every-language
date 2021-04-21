
			
import math
import random
from PIL import Image 

from tqdm import tqdm

SPECULAR_K = 30
MIN_OFFSET = 0.001

def write_as_png(pixels, file_name, show_when_done=True):
    height = len(pixels)
    width = len(pixels[0])

    file_image = Image.new('RGB', (width, height), color = 'black')
    image_pixels = file_image.load()
    
    for y in range(height):
        for x in range(width):
            pixel = pixels[y][x]
            pixel = pixel.clamp(0.0, 1.0) * 255.0
            image_pixels[x, height - 1 - y] = (
                int(pixel.x),
                int(pixel.y),
                int(pixel.z)
            )

    file_image.save(file_name + ".png")
    if show_when_done:
        file_image.show()

class Vec3:
    def __init__(self, x=0.0, y=0.0, z=0.0):
        self.x, self.y, self.z = x, y, z

    def mag(self):
        return math.sqrt(self.x**2 + self.y**2 + self.z**2)

    def norm(self):
        mag = self.mag()
        if mag > 0:
            self.x, self.y, self.z = self.x / mag, self.y / mag, \
                self.z / mag
        return self

    def __add__(self, other):
        return Vec3(self.x + other.x, self.y + other.y, self.z + other.z)

    def __sub__(self, other):
        return Vec3(self.x - other.x, self.y - other.y, self.z - other.z)

    def __mul__(self, other):
        return Vec3(self.x * other, self.y * other, self.z * other)

    def __rmul__(self, other):
        return self.__mul__(other)

    def __truediv__(self, other):
        return Vec3(self.x / other, self.y / other, self.x / other)

    def dot(self, vec2):
        return self.x * vec2.x + self.y * vec2.y + self.z * vec2.z

    def __repr__(self):
        return (self.x, self.y, self.z).__repr__()

    def clone(self):
        return Vec3(self.x, self.y, self.z)

    def clamp(self, low, high):
        return Vec3(
            min(max(self.x, low), high),
            min(max(self.y, low), high),
            min(max(self.z, low), high),
        )

    @classmethod
    def random(self):
        return Vec3(
            random.random(), 
            random.random(), 
            random.random()
        )

    @classmethod
    def white(self):
        return Vec3(1.0, 1.0, 1.0)

class Ray:
    def __init__(self, origin, dir):
        self.origin = origin
        self.dir = dir.norm()

class Light:
    def __init__(self, pos, color):
        self.pos = pos
        self.color = color

class Material:
    def __init__(self, color, 
            ambient=0.05, 
            diffuse=0.25, 
            specular=0.1, 
            reflection=1.0):
        self.color = color
        self.ambient = ambient
        self.diffuse = diffuse
        self.specular = specular
        self.reflection = reflection

class Sphere:
    def __init__(self, center, radius, material):
        self.center = center
        self.radius = radius
        self.material = material

    def intersects(self, ray):
        to_sphere = self.center - ray.origin
        t = to_sphere.dot(ray.dir)
        if t < 0:
            return None
        perp_center = ray.origin + ray.dir * t
        y = (perp_center - self.center).mag()
        if y > self.radius: #   miss
            return None
        elif y <= self.radius:  #   hit
            x = math.sqrt(self.radius**2 - y**2)
            t1 = t - x
            return t1

    def normal(self, hit_point):
        return (hit_point - self.center).norm()

class Scene:
    def __init__(self, width, height):
        self.width = width
        self.height = height
        self.cam = Vec3(x=width / 2, y=height / 2, z=-width / 2)
        self.NUM_SPHERES = 30
        self.NUM_LIGHTS = 20
        self.objects = []
        self.lights = []

        # sphere_one = Sphere(
        #     center=Vec3(
        #         x=width / 4, 
        #         y=height / 4, 
        #         z=width / 2),
        #     radius=width / 2,
        #     material=Material(
        #         color=Vec3.random()
        #     )
        # )
        # self.objects.append(sphere_one)
        '''
        for _ in range(self.NUM_SPHERES):
            procedural_sphere = Sphere(
                center=Vec3(
                    x=random.random() * width, 
                    y=random.random() * height, 
                    z=width / 2 + random.random() * width),
                radius=random.random() * width / 5,
                material=Material(
                    color=Vec3.random()
                )
            )
            self.objects.append(procedural_sphere)

        new_light = Light(
            pos=Vec3(
                x=0, 
                y=height*5, 
                z=0),
            color=Vec3(1.0, 1.0, 1.0))
        self.lights.append(new_light)
		'''
		
        for _ in range(self.NUM_SPHERES):
            procedural_sphere = Sphere(
                center=Vec3(
                    x=random.random() * width, 
                    y=random.random() * height, 
                    z=width / 2 + random.random() * width),
                radius=random.random() * width / 7,
                material=Material(
                color=Vec3.random()
                )
            )
            self.objects.append(procedural_sphere)

        for _ in range(self.NUM_LIGHTS):
            new_light = Light(
                pos=Vec3(
                    x=(random.random() - 0.5) * width * 2, 
                    y=(random.random() - 0.5) * height * 2, 
                    z=width / 2 + random.random() * width),
                color=Vec3.random())
            self.lights.append(new_light)
		

def render_scene(scene, max_bounces=3):
    width = scene.width
    height = scene.height
    cam = scene.cam
    
    pixels = []
    for y in range(height):
        row = []
        for x in range(width):
            row.append(Vec3())
        pixels.append(row)

    for y in tqdm(range(height)):
        for x in range(width):
            plane_target = Vec3(x, y, 0)
            ray = Ray(
                origin=cam, 
                dir=plane_target-cam)
            pixels[y][x] = raytrace(ray, scene, max_bounces)
    return pixels

def raytrace(ray, scene, max_depth, depth=0):
    if depth == 0:
        color = Vec3()
    elif depth == max_depth:
        return Vec3()

    #   find closest hit; if any
    min_dist = 0.0
    obj_hit = None
    for obj in scene.objects:
        dist = obj.intersects(ray)
        if dist is not None:
            if obj_hit is None or dist < min_dist:
                min_dist = dist
                obj_hit = obj
    if obj_hit is None:
        return Vec3()
    dist = min_dist

    hit_pos = ray.origin + ray.dir * dist
    hit_normal = obj_hit.normal(hit_pos)
    color = color_at(obj_hit, hit_pos, hit_normal, scene)

    new_ray = Ray(
        origin=hit_pos + hit_normal * MIN_OFFSET,
        dir=ray.dir - (2 * ray.dir.dot(hit_normal)) * hit_normal)

    color += raytrace(new_ray, scene, max_depth, depth + 1) * obj_hit.material.reflection
    return color

def color_at(obj_hit, hit_pos, hit_normal, scene):
    to_cam = scene.cam - hit_pos
    
    color = obj_hit.material.color * obj_hit.material.ambient
    #color = Vec3.white() * obj_hit.material.ambient
    for light in scene.lights:
        to_light = Ray(hit_pos, light.pos - hit_pos)

        ''' diffuse shading     '''
        color += (
            obj_hit.material.color
            * obj_hit.material.diffuse
            * max(hit_normal.dot(to_light.dir), 0))

        ''' specular shading    '''
        half_vector = (to_light.dir + to_cam.norm()).norm()
        color += (
            light.color
            * obj_hit.material.specular
            * max(hit_normal.dot(half_vector), 0) ** SPECULAR_K)

    return color

def main():
    resolutions = [(20, 20), (200, 200), (500, 500), 
        (1920, 1080), (4096, 2160), (7680, 4320)]
    WIDTH, HEIGHT = resolutions[3]

    scene = Scene(width=WIDTH, height=HEIGHT)
    pixels = render_scene(scene, max_bounces=5)
    write_as_png(pixels, "render")

if __name__ == "__main__":
    main()