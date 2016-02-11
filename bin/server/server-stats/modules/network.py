from modules.common import *
from subprocess import getoutput

class NetworkModule(KeyValueModule):

    LAN = 'p3p1'

    def __init__(self):
        # wanip=`wget http://ipecho.net/plain -O - -q ; echo`
        # lanip=`ifconfig p3p1 | grep 'inet addr:' | awk -F'inet addr:' '{print $2}' | awk -F' ' '{print $1}'`
        # macaddr=`ifconfig p3p1 | grep HWaddr | awk -F'HWaddr ' '{print $2}'`

        wanip = getoutput('curl -s ipecho.net/plain; echo').strip()
        lanip = getoutput("/sbin/ifconfig " + self.LAN + " | grep 'inet addr:' | awk -F'inet addr:' '{print $2}' | awk -F' ' '{print $1}'").strip()
        macaddr = getoutput("/sbin/ifconfig " + self.LAN + " | grep HWaddr | awk -F'HWaddr ' '{print $2}'").strip()

        super().__init__("NETWORK", {
            'LOCAL IP': lanip,
            'REMOTE IP': wanip,
            'MAC ADDRESS': macaddr
        }, DEMI)


