from modules.common import *
from subprocess import getoutput


class MemtopModule(Module):

    N = 8

    def toPrintable(self):
        return fmt.center("TOP " + str(self.N) + " MEMORY CONSUMERS", COL_FILLER) + NL \
               + "     \033[4mMemory\033[0m    \033[4mPid\033[0m       \033[4mUser\033[0m   \033[4mCommand\033[0m\n" \
               + getoutput("/usr/local/bin/memtop -n " + str(self.N)) + NL + NL

