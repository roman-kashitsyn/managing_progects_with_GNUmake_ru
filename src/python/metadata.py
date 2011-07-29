#!/usr/bin/python
import os
import sys
import hashlib
import logging

def fileSHA1(filename):
    f = open(filename, "r")
    m = hashlib.sha1()
    m.update(f.read())
    f.close()
    return m.hexdigest()

def collectMetadata(dir):
    metadata = []
    for root, dirs, files in os.walk(dir):
        for name in files:
            filename = os.path.join(root, name)
            sha1sum = fileSHA1(filename)
            entry = {'file': filename, 'sha1sum': sha1sum}
            metadata.append(entry)
        for name in dirs:
            if name == '.git':
                continue
            dirname = os.path.join(root, name)
            entry = {'dir': dirname}
            metadata.append(entry)
        if '.git' in dirs:
            dirs.remove('.git')
    return metadata

if __name__ == "__main__":
    metadata = collectMetadata('.')
    for entry in metadata:
        if entry.has_key('file'):
            print entry['sha1sum'], entry['file']
        elif entry.has_key('dir'):
            print '{0:40} {1}'.format('', entry['dir'])
