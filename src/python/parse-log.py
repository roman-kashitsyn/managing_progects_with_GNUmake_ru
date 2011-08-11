#!/usr/bin/python
import sys
import os
from subprocess import Popen, PIPE, STDOUT
import logging
from termcolor import colored
import texlog

def underscored(text):
    UNDERSCORE = '=============================='
    sep = os.linesep
    return sep + text + sep + UNDERSCORE

def smartColored(text, color, attrs):
    if os.isatty(1):
        return colored(text, color, attrs=attrs)
    else:
        return text

def warning(text):
    return smartColored(underscored(text), 'red', ['bold'])

def printOverfulls(overfulls):
    prev_file = ''
    for overfull in overfulls:
        current_file = overfull['file']
        if current_file != prev_file:
            print '\n{0}:'.format(current_file)
            prev_file = current_file
        print '{0:>5}: {1}'.format(overfull['linum'], overfull['line'])

def usage(my_name):
    print >> sys.stderr, "{0} log_file".format(my_name)
    sys.exit(1)

if __name__ == "__main__":
    if len(sys.argv) < 2:
        sys.exit(1);

    log_file = open(sys.argv[-1])

    logdata = texlog.parse(log_file.read())
    
    log_file.close()

    if len(logdata.overfulls) > 0:
        print warning('Overfulls:')
        printOverfulls(logdata.overfulls)

    if len(logdata.underfulls) > 0:
        print warning('Underfulls: ')
        printOverfulls(logdata.underfulls)

