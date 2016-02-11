from datetime import datetime
from subprocess import getoutput
from modules.common import *


class HeaderModule(Module):
    def __init__(self) -> None:

        hostname = getoutput("hostname -f")
        self.name = '{0} @ Coomansstraat 38'.format(hostname)

    def toPrintable(self):
        line = fmt.center(self.name, "=" + " " * (COLS - 2) + "=")
        str = COL_FILLER + NL + line + NL + COL_FILLER
        return str + NL + self.__print_last_updated() + NL

    def __print_last_updated(self):
        return fmt.center("System information as of " + fmt.str(datetime.now()) + NL)
