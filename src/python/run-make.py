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

if __name__ == "__main__":
    make_with_args = ['make']

    if len(sys.argv) > 1:
        make_with_args.extend(sys.argv[1:])
        logging.info("Running make with arguments: {0}", sys.argv[1:])
    else:
        logging.info("Running make without parameters")

    p = Popen(make_with_args, shell=True, stdin=PIPE, stdout=PIPE, stderr=STDOUT)

    stdoutdata, stderrdata = p.communicate()

    if stderrdata != None:
        logging.warning("Make produce error messages:")
        print stderrdata

    if make_with_args.count('clean') > 0:
        exit()

    logdata = texlog.parse(stdoutdata)

    if len(logdata.overfulls) > 0:
        print warning('Overfulls:')
        printOverfulls(logdata.overfulls)

    if len(logdata.underfulls) > 0:
        print warning('Underfulls: ')
        printOverfulls(logdata.underfulls)

