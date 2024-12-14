from typing import Generator
from dataclasses import dataclass
from datetime import time, timedelta, datetime

# Constants
TIME_START = time(0, 0, 0)
TIME_END = time(23, 59, 59)
INTERVAL = timedelta(seconds=1)


@dataclass
class DimTimeRecord:
    """Data class for representing time dimension records."""

    time_key: int
    timevalue: time
    hour_int: int
    hour_time: time
    minute_int: int
    minute_time: time
    second_int: int


def get_time_range() -> Generator[time, None, None]:
    """
    Generator for creating a range of time objects at 1-second intervals.

    Yields:
        time: A time object for each second in the defined range.
    """
    current_datetime = datetime.combine(datetime.today(), TIME_START)
    end_datetime = datetime.combine(datetime.today(), TIME_END)

    while current_datetime <= end_datetime:
        yield current_datetime.time()
        current_datetime += INTERVAL


def get_dim_time_records() -> Generator[DimTimeRecord, None, None]:
    """
    Generator for creating DimTimeRecord objects for each second in the range.

    Yields:
        DimTimeRecord: A data class instance containing time dimension details.
    """
    for timevalue in get_time_range():
        hour = timevalue.hour
        minute = timevalue.minute
        second = timevalue.second

        yield DimTimeRecord(
            time_key=int(timevalue.strftime("%H%M%S")),
            timevalue=timevalue,
            hour_int=hour,
            hour_time=time(hour, 0, 0),
            minute_int=minute,
            minute_time=time(hour, minute, 0),
            second_int=second,
        )


if __name__ == "__main__":
    for record in get_dim_time_records():
        print(record)
