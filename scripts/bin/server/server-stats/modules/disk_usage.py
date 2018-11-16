from modules.common import *
from subprocess import getoutput


class DiskUsageModule(TableModule):

    def df(self, disk: str):
        return getoutput("df -B1 | tail -n+2 | while read fs size used rest ; do if [ $used ] ; then echo $fs $used $size; fi; done | grep " + disk).split(' ')

    def __init__(self):
        # df | tail -n+2 | while read fs size used rest ; do if [[ $used ]] ; then echo $fs $used $size; fi; done | grep /dev/sd
        da = self.df("sda1")
        db = self.df("sdb1")
        dc = self.df("sdc1")

        hda = ['SYS-DRIVE', da[0], '{0:-4.1f}%'.format((int(da[1])/int(da[2]))*100), fmt.from_bytes(int(da[2]))]
        hdb = ['WD-GREEN', db[0], '{0:-4.1f}%'.format((int(db[1])/int(db[2]))*100), fmt.from_bytes(int(db[2]))]
        hdc = ['SPINPOINT-F3', dc[0], '{0:-4.1f}%'.format((int(dc[1])/int(dc[2]))*100), fmt.from_bytes(int(dc[2]))]

        data = [
            ['Label', 'Mount point', 'Usage', 'Disk size'],
            hda,
            hdb,
            hdc
        ]

        super().__init__("DISK USAGE", data)

