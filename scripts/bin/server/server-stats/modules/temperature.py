from modules.common import *
from subprocess import getoutput


class TemperatureModule(KeyValueModule):

    def __init__(self):
        # sensors | grep  C | grep 'Core 0:' | awk -F'+|.0°C' '{print $2}'

        core0 = getoutput("sensors | grep  C | grep 'Core 0:' | awk -F'+|.0°C' '{print $2}'").strip() + "°C"
        core1 = getoutput("sensors | grep  C | grep 'Core 1:' | awk -F'+|.0°C' '{print $2}'").strip() + "°C"

        hda = getoutput("/usr/sbin/hddtemp /dev/sda | awk -F\"(: | C)\" '{print $3}'")
        hdb = getoutput("/usr/sbin/hddtemp /dev/sdb | awk -F\"(: | C)\" '{print $3}'")
        hdc = getoutput("/usr/sbin/hddtemp /dev/sdc | awk -F\"(: | C)\" '{print $3}'")

        super().__init__("TEMPERATURE", {
            'CPU': {
                'Core 0': core0,
                'Core 1': core1
            },
            'HDD': {
                'hda': hda,
                'hdb': hdb,
                'hdc': hdc
            }
        }, DEMI)


