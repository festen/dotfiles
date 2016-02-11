from modules.common import *
from subprocess import getoutput


class BackupsModule(TableModule):

    def __init__(self):
        #du -st 1M /backup/*/*
        backups = []
        for b in getoutput("(cd /backup && du -sbt 1M */* | sed -e 's_[\t/ ]_$_g')").split('\n'):
            b = b.split('$')
            size = b[0]
            timestamp = datetime.fromtimestamp(int(getoutput("stat -c %Y /backup/{0}/{1}".format(b[1], b[2]))))
            b[0] = "{0} ({1})".format(b[1], b[2]).replace('.sparsebundle', '')
            b[1] = fmt.from_bytes(int(size), to="GB")
            b[2] = fmt.str(datetime.now() - timestamp)
            backups.append(b)
        data = [['LABEL', 'DISK SIZE', 'MOST RECENT']]
        data.extend(backups)
        super().__init__("BACKUPS", data)

# NAME		NEWEST BACKUP	SIZE
# david		17 Oct 14:17	2.3T
