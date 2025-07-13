import re


class DurationParser:
    def __init__(self):
        self.units = {
            's': 1,
            'm': 60,
            'h': 3600,
            'd': 86400
        }

    def parse(self, duration_str):
        pattern = r'^(\d+)([smhd])$'
        match = re.match(pattern, duration_str.lower())

        if not match:
            return None

        value, unit = match.groups()
        return int(value) * self.units[unit]