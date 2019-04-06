import sys
import os
import math
import pystache


def parse_file(filename):
    vertices = []
    faces = []

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

    return {
        'vertices': vertices,
        'faces': faces
    }


def format(data):
    vertices = []
    faces = []

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

    return {
        'vertices': vertices,
        'faces': faces
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
