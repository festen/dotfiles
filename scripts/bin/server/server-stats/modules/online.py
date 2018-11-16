from modules.common import *
from subprocess import getoutput


class CurrentlyOnlineModule(TableModule):

    def __init__(self):
        ppl = getoutput("who --ips --lookup | sed -e 's/ \{2,20\}/$/g' | sed -e 's/\([0-9]\{2\}:[0-9]\{2\}\) /\\1$/'").split('\n')
        ppl = [person.split('$') for person in ppl]

        exists = ppl[0][0]
        if exists:
            data = [['User', 'Line', 'Since', 'Origin']]
            data.extend(ppl)
            super().__init__("CURRENTLY ONLINE", data)
        else:
            super().__init__()

#david    pts/0        2015-10-17 18:04 192.168.0.104
