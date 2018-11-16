from modules.common import *
from subprocess import getoutput


class LoadAverageModule(Module):
    N = 1920  # amount of entries to save (20 days * 24 hours * 4)
    I = 6  # interval of the graph in hours (4 times a day * 20 days = 80 columns)

    d20 = {"lvl": [], "num1": [], "num2": []}
    h20 = {"lvl": [], "num1": [], "num2": []}
    name = 'SERVER LOAD'

    def __init__(self):
        raw_data = self.get_data()
        if len(raw_data) is 0:
            return
        data_h20 = dict()
        data_d20 = dict()
        for entry in raw_data:
            when = entry[0]
            """:type: datetime"""
            load = entry[1]
            """:type: float"""

            # force date into bin by rounding down to nearest I-hour interval
            ts_h20 = int(when.replace(minute=(when.minute // 15) * 15, second=0, microsecond=0).timestamp())
            ts_d20 = int(
                when.replace(hour=(when.hour // self.I) * self.I, minute=0, second=0, microsecond=0).timestamp())

            # check if timestamp exists and add or otherwise replace (20 hour case)
            if (datetime.now() - datetime.fromtimestamp(ts_h20)) > timedelta(hours=20):
                continue
            elif ts_h20 in data_h20.keys():
                avg = (data_h20[ts_h20][0] * data_h20[ts_h20][1] + load) / (data_h20[ts_h20][1] + 1)
                data_h20[ts_h20] = [avg, data_h20[ts_h20][1] + 1]
            else:
                data_h20[ts_h20] = [load, 1]

            # check if timestamp exists and add or otherwise replace (20 day case)
            if (datetime.now() - datetime.fromtimestamp(ts_h20)) > timedelta(days=20):
                continue
            elif ts_d20 in data_d20.keys():
                avg = (data_d20[ts_d20][0] * data_d20[ts_d20][1] + load) / (data_d20[ts_d20][1] + 1)
                data_d20[ts_d20] = [avg, data_d20[ts_d20][1] + 1]
            else:
                data_d20[ts_d20] = [load, 1]

        for entry in data_h20.values():
            num = int((entry[0] / 2) * 10)
            overflow = len(str(num)) > 1
            lvl = 0 if num < 5 else 1 if num < 8 else 2
            num_str = "{0:02d}".format(num)
            self.h20["lvl"].append(str(lvl))
            self.h20["num1"].append(num_str[-1:])
            self.d20["num2"].append("!" if overflow else " ")

        for entry in data_d20.values():
            num = int((entry[0] / 2) * 10)
            overflow = len(str(num)) > 1
            lvl = 0 if num < 5 else 1 if num < 8 else 2
            num_str = "{0:02d}".format(num)
            self.d20["lvl"].append(str(lvl))
            self.d20["num1"].append(num_str[-1:])
            self.d20["num2"].append("!" if overflow else " ")

    def toPrintable(self):
        if len(self.h20['lvl']) is 0:
            return ''
        else:
            return fmt.center(self.name, FILLER * self.size) + NL + \
                "Past 20 hours per 15 minutes" + NL + \
                getoutput("spark {0}".format(" ".join(self.h20["lvl"]))) + NL + \
                "".join(self.h20["num1"]) + NL + \
                "".join(self.h20["num2"]) + NL + NL + \
                "Past 20 days per 6 hours" + NL + \
                getoutput("spark {0}".format(" ".join(self.d20["lvl"]))) + NL + \
                "".join(self.d20["num1"]) + NL + \
                "".join(self.d20["num2"]) + NL + NL

    def get_data(self):
        """

        :return: list[list[datetime, float]]
        """
        data = getoutput("cat /var/log/loadavg").split("\n")
        data = data[-self.N:]
        with open('/var/log/loadavg', 'w') as file:
            file.write("\n".join(data) + NL)
        formatted = []
        for entry in data:
            if entry is '':
                continue
            values = entry.split(' ')
            formatted.append([datetime.fromtimestamp(int(values[0])), float(values[1])])
        return formatted
