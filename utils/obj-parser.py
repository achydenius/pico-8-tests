import sys
import os
import math
import pystache


def fixed_point(value):
    return int((float(value) * 255))


def vector_subtract(a, b):
    return [a[0] - b[0], a[1] - b[1], a[2] - b[2]]


def vector_length(p):
    return math.sqrt((p[0] * p[0]) + (p[1] * p[1]) + (p[2] * p[2]))


def vector_cross(p1, p2, p3):
    u = vector_subtract(p2, p1)
    v = vector_subtract(p3, p1)

    return [
        (u[1] * v[2]) - (u[2] * v[1]),
        (u[2] * v[0]) - (u[0] * v[2]),
        (u[0] * v[1]) - (u[1] * v[0])
    ]


def calculate_normal(p1, p2, p3):
    normal = vector_cross(p1, p2, p3)
    length = vector_length(normal)
    return [
        normal[0] / length,
        normal[1] / length,
        normal[2] / length
    ]


def parse_file(filename):
    vertices = []
    faces = []
    face_normals = []

    for line in open(filename, 'r'):
        # Parse vertex
        if line.startswith('v '):
            vertices.append(
                [float(value) for value in line.split(' ')[1:]]
            )

        # Parse face
        elif line.startswith('f '):
            values = line.split(' ')[1:]
            faces.append([int(value.split('/')[0]) - 1 for value in values])

    # Calculate face normals
    for face in faces:
        face_normals.append(calculate_normal(
            vertices[face[0]], vertices[face[1]], vertices[face[2]]
        ))

    return {
        'vertices': vertices,
        'faces': faces,
        'face_normals': face_normals
    }


def format(data):
    vertices = []
    faces = []
    face_normals = []

    # Vertices
    for vertex in data['vertices']:
        vertices.append({
            'x': vertex[0],
            'y': vertex[1],
            'z': vertex[2]
        })
    vertices[-1]['last_vertex'] = True

    # Faces
    index = 0
    for face in data['faces']:
        indices = [{'index': i + 1} for i in face]
        indices[-1]['last_index'] = True

        faces.append({
            'index': index,
            'indices': indices
        })
        index += 1
    faces[-1]['last_face'] = True

    # Face normals
    for face in data['face_normals']:
        face_normals.append({
            'x': face[0],
            'y': face[1],
            'z': face[2]
        })
    face_normals[-1]['last_face_normal'] = True

    return {
        'vertices': vertices,
        'faces': faces,
        'face_normals': face_normals
    }


def render(data):
    path = os.path.dirname(os.path.realpath(__file__))
    template = open(path + '/obj-parser.mustache', 'r').read()
    renderer = pystache.Renderer()
    return renderer.render(template, data)


if len(sys.argv) < 2:
    print('obj-parser.py <obj_file>')
else:
    filename = sys.argv[1]
    data = parse_file(filename)
    formatted = format(data)
    sys.stdout.write(render(formatted))
