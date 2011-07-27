#!/urs/bin/python

def parse(logtext):
    data = LogData()
    data._parse(logtext)
    return data

class LogData:
    """Parsed LaTeX log data"""

    def __init__(self):
        self.overfulls = []
        self.underfulls = []
        self.undefinedReferences = []
    
    def _parse(self, logtext):
        loglines = logtext.splitlines()
        current_file = ''
        line_number = 0
        for line in loglines:
            line_number += 1
            if line.startswith('('):
                current_file = line[1:]
            elif line.startswith('Overfull'):
                overfull = self._getInfo(current_file, line_number, line)
                self.overfulls.append(overfull)
            elif line.startswith('Underfull'):
                underfull = self._getInfo(current_file, line_number, line)
                self.underfulls.append(underfull)
        return

    def _getInfo(self, file, linum, line):
        return {'file': file, 'linum': linum, 'line': line}
