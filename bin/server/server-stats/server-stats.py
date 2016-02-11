#!/usr/bin/env python3
from modules.backups import BackupsModule

from modules.disk_usage import DiskUsageModule
from modules.header import HeaderModule
from modules.boot_stats import BootStatsModule
from modules.loadavg import LoadAverageModule
from modules.memtop import MemtopModule
from modules.network import NetworkModule
from modules.common import print_parallel
from modules.online import CurrentlyOnlineModule
from modules.system_load import SystemLoadModule
from modules.temperature import TemperatureModule

modules = [
    HeaderModule(),
    BootStatsModule(),
    NetworkModule(),
    TemperatureModule(),
    SystemLoadModule(),
    BackupsModule(),
    DiskUsageModule(),
    CurrentlyOnlineModule(),
    MemtopModule(),
    # LoadAverageModule()
]

buffer = None

for module in modules:
    if module.isDemi() and buffer is None:
        buffer = module
    elif module.isDemi() and buffer is not None:
        print_parallel(buffer.toPrintable(), module.toPrintable())
        buffer = None
    else:
        if buffer is not None:
            print(buffer.toPrintable(), end='')
            buffer = None
        print(module.toPrintable(), end='')

if buffer is not None:
    print(buffer.toPrintable(), end='')
