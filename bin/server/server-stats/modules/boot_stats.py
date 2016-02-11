from modules.common import *
from datetime import datetime
from subprocess import getoutput

class BootStatsModule(KeyValueModule):
    def __init__(self):
        # last boot: who -b | sed -e 's/[ a-z~]*//'

        cmd_last_boot = "who -b | sed -e 's/[ a-z~]*//'"
        output = getoutput(cmd_last_boot).strip()
        since = datetime.strptime(output, "%Y-%m-%d %H:%M")
        super().__init__("BOOT STATS", {
            "SINCE": since,
            "UPTIME": datetime.now() - since
        }, DEMI)
