from modules.common import *
from subprocess import getoutput


class SystemLoadModule(KeyValueModule):

    def __init__(self):
        # awk '{print $1}' /proc/loadavg
        # free -m | grep 'Mem:' | awk '{print $3}'

        avg_1min = getoutput("awk '{print $1}' /proc/loadavg")
        avg_5min = getoutput("awk '{print $2}' /proc/loadavg")
        avg_15min = getoutput("awk '{print $3}' /proc/loadavg")

        mem_used = int(getoutput("free -m | grep 'Mem:' | awk '{print $3}'"))
        mem_free = int(getoutput("free -m | grep 'Mem:' | awk '{print $4}'"))
        mem_cached = int(getoutput("free -m | grep 'Mem:' | awk '{print $7}'"))

        mem_actually_used = str(mem_used - mem_cached)
        mem_actually_free = str(mem_free + mem_cached)

        super().__init__("NETWORK", {
            'CPU LOAD': {
                ' 1 min avg': avg_1min,
                ' 5 min avg': avg_5min,
                '15 min avg': avg_15min
            },
            'MEMORY USAGE': {
                'USED': "{0} MB".format(mem_actually_used),
                'FREE': "{0} MB".format(mem_actually_free)
            }
        }, DEMI)


