import math
from datetime import datetime, timedelta

COLS = 80  # maximum number of columns to print
DEMI = 36  # size of halve modules (<50% ensures gutter)
GUTTER = COLS - DEMI * 2

FILLER = "="  # filler symbol
EMPTY = " "  # empty symbol
NL = "\n"  # new line
COL_EMPTY = EMPTY * COLS  # empty column
COL_FILLER = FILLER * COLS  # filler column


class Module:
    name = "Empty Module"
    size = COLS

    def toPrintable(self) -> str:
        """

        :return: str
        """
        return fmt.center(self.name, COL_FILLER) + NL + fmt.center("No content")

    def isDemi(self) -> bool:
        return self.size <= COLS // 2


class KeyValueModule(Module):
    def __init__(self, name, data, size=COLS):
        self.name = name
        self.data = data
        self.size = size

    def toPrintable(self):
        string = fmt.center(self.name, FILLER * self.size) + NL
        pad_amount = max(len(str(x)) for x in self.data.keys()) + 2
        inner_dict = [x for x in self.data.values() if isinstance(x, dict)]
        if inner_dict:
            pad_amount = max(pad_amount, max([max([len(str(k)) for k in d]) for d in inner_dict]) + 6)
        for key, value in self.data.items():
            if isinstance(value, dict):
                string += fmt.pad_right(key, pad_amount) + NL + self.__asTree(value, pad_amount)
            else:
                string += fmt.pad_right(key + ":", pad_amount) + fmt.str(value) + NL
        return string

    def __asTree(self, d: dict, pad_amount: int):
        returnString = []
        """:type: list[str]"""
        for key, value in d.items():
            returnString.append(fmt.pad_right("├── {0}:".format(key), pad_amount) + value + NL)
        returnString[-1] = returnString[-1].replace('├──', '└──')
        return ''.join(returnString)


class TableModule(Module):
    SPACE = 4

    def __init__(self, name=None, data=None):
        self.name = name
        self.data = data

    def toPrintable(self):
        if not self.name or not self.data:
            return ""
        else:
            return fmt.center(self.name, COL_FILLER) + NL + str(self.format_data()) + NL

    def get_column_widths(self):
        col_widths = []
        for col in range(len(self.data[0])):
            col_widths.append(len(self.data[0][col]) + self.SPACE)
            for row in range(len(self.data)):
                col_widths[col] = max(col_widths[col], len(self.data[row][col]) + self.SPACE)
        return col_widths

    def format_data(self):
        width = self.get_column_widths()
        return_value = ''
        for row in range(len(self.data)):
            for col in range(len(self.data[row])):
                value = self.data[row][col]
                if row is 0:
                    return_value += fmt.pad_right(fmt.str(value), width[col], underline=True)
                else:
                    return_value += fmt.pad_right(fmt.str(value), width[col])
            return_value += NL
        return return_value


class fmt:
    """Has the responsibility to format strings"""

    @staticmethod
    def center(fg: str, bg: str = COL_EMPTY) -> str:
        before = math.floor((len(bg) - len(fg) - 2) / 2)
        after = math.ceil((len(bg) - len(fg) - 2) / 2)
        result = bg[:before] + " " + fg + " " + bg[-after:]
        return result

    @staticmethod
    def pad_right(text: str, pad: int, underline: bool = False) -> str:
        extra = pad - len(text)
        if underline:
            text = "\033[4m" + text + "\033[0m"
        return text + " " * extra

    @staticmethod
    def str(var):
        if isinstance(var, datetime):
            return var.strftime("%b %d %H:%M")
        if isinstance(var, timedelta):
            return fmt.time_ago(var)
        else:
            return str(var)

    @staticmethod
    def from_bytes(b: int, to: str = None):
        if to is "GB" or b > 1024 ** 3:
            return "{0:-6.1f} GB".format(b / 1024 ** 3)
        elif to is "MB" or b > 1024 ** 2:
            return "{0:-6.1f} MB".format(b / 1024 ** 2)
        elif to is "KB" or b > 1024 ** 1:
            return "{0:-6.1f} KB".format(b / 1024 ** 1)
        else:
            return "{0} bytes".format(b)

    @staticmethod
    def time_ago(interval: timedelta) -> str:
        ago_string = ''
        s = interval.total_seconds()
        if (s >= 31536000):
            return "{0:-4.1f} years".format(s/31536000)
        elif (s >= 2628000):
            return "{0:-4.1f} months".format(s/2628000)
        elif (s >= 604800):
            return "{0:-4.1f} weeks".format(s/604800)
        elif (s >= 86400):
            return "{0:-4.1f} days".format(s/86400)
        elif (s >= 3600):
            return "{0:-4.1f} hours".format(s/3600)
        elif (s >= 60):
            return "{0:-4.1f} minutes".format(s/60)
        else:
            return "{0:-4.1f} seconds".format(s)


def print_parallel(left: str, right: str) -> None:
    lbuf = left.split('\n')
    rbuf = right.split('\n')
    for i in range(0, max(len(lbuf), len(rbuf))):
        if i < len(lbuf):
            print(fmt.pad_right(lbuf[i], DEMI + GUTTER), end='')
        if i < len(rbuf):
            print(rbuf[i])
