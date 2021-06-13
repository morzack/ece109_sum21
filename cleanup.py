# cleanup.py - removes all .sym & .obj files
import os

root = os.path.dirname(os.path.realpath(__file__))
for path, subdirs, files in os.walk(root):
    for file in files:
        if file.endswith(('.sym', '.obj')) and 'lc3os' not in file:
            os.remove(os.path.join(path, file))
