import math
import random

from PIL import Image 
from tqdm import tqdm
import numpy as np
import torch
import torch.nn.functional as F

MAX_STEPS = 100
MIN_SURFACE_DIST = 0.005
DEVICE = torch.device('cuda' if torch.cuda.is_available() else 'cpu')
#DEVICE = torch.device("cpu")

#MAX_DIST = 100.0

def dot(a, b):
    return (a*b).sum(1)

def mag(tensor, dim=0):
    return tensor.norm(dim=dim)

def norm(tensor):
    return F.normalize(tensor)

def get_dist(p):
    t = 11.0
    s = torch.tensor([0.0, 1.0, 6.0]).to(DEVICE)
    r = 1.0
    sd = mag(p - s, 1) - r

    pd = p[:, 1]   # y component
    dist, _ = torch.stack([pd, sd], 1).min(dim=1)
    dist = dist.view(-1, 1)

    return dist

def get_normal(p):
    delta = 0.01
    x_delta = torch.tensor([delta, 0.0, 0.0]).to(DEVICE)
    y_delta = torch.tensor([0.0, delta, 0.0]).to(DEVICE)
    z_delta = torch.tensor([0.0, 0.0, delta]).to(DEVICE)
    
    d = get_dist(p)

    dx = (d - get_dist(p - x_delta)).flatten()
    dy = (d - get_dist(p - y_delta)).flatten()
    dz = (d - get_dist(p - z_delta)).flatten()

    n = torch.stack([dx, dy, dz], 0).T
    n = norm(n)

    return n

def march(ro, rd):
    already_hit = torch.zeros((rd.shape[0], 1), dtype=torch.bool).to(DEVICE)
    total_dist = torch.zeros(rd.shape[0], 1).to(DEVICE)
    for _ in tqdm(range(MAX_STEPS)):
        p = ro + rd * total_dist.view(-1, 1)
        dist = get_dist(p)

        #   we cant break because the ops are all paralel so we use masks
        hit = dist < MIN_SURFACE_DIST
        total_dist[~already_hit] += dist[~already_hit]
        already_hit[~already_hit] = hit[~already_hit]

    return total_dist

def main():
    resolutions = torch.tensor([
        (3, 2), (20, 20), (200, 200), (500, 500), (1080, 1080), (4000, 4000),
        (1920, 1080), (4096, 2160), (7680, 4320)
    ])
    resolution = resolutions[4].to(DEVICE)
    width, height = resolution

    #   build frag coords and make pixel buffer
    x = torch.arange(width, dtype=torch.float32).repeat(1, height).view(-1, width).flatten().to(DEVICE)
    y = torch.arange(height, dtype=torch.float32).repeat(1, width).view(-1, height).T.flatten().to(DEVICE)
    frag_coord = torch.stack([y, x], 1)

    uv = (frag_coord - 0.5*resolution) / height

    #   light
    light = torch.tensor([-3.0, 5.0, -1.0]).to(DEVICE)

    #   fire a ray for each pixel
    ro = torch.tensor([0.0, 1.0, 0.0]).to(DEVICE)
    rd = norm( F.pad(uv, pad=(0, 1), mode='constant', value=1.0) ).to(DEVICE)

    #   march the ray
    total_dist = march(ro, rd)
    hit_pos = ro + rd * total_dist

    #   lighting
    to_cam = norm(ro - hit_pos)
    to_light = norm(light - hit_pos)
    normal = get_normal(hit_pos)

    b = dot(normal, to_light).clamp(0.0)

    pixels = torch.ones(height * width, 3).to(DEVICE)
    pixels *= b.view(-1, 1)
    pixels = pixels.view(width, height, 3)
    pixels = pixels.permute(1, 0, 2).flip(0, 1)

    pixels = pixels.clamp(0.0, 1.0) * 255.0
    pixels = pixels.to(torch.uint8).cpu().numpy()
    img = Image.fromarray(pixels)
    img.save("render.png")
    #img.show()

if __name__ == "__main__":
    main()