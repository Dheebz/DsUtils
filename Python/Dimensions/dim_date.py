from dataclasses import dataclass
from datetime import date, timedelta
from typing import Generator

CONST_WINDOW_START = date(2020, 1, 1)
CONST_WINDOW_END = date(2049, 12, 31)


@dataclass
class DimDateRecord:
    datekey: int
    datevalue: date
    year_start: date
    year_end: date
    quarter_start: date
    quarter_end: date
    month_start: date
    month_end: date
    week_start: date
    week_end: date
    is_weekend: bool
    month_name: str
    month_abbr: str
    day_name: str
    day_abbr: str
    quarter_of_year: int
    month_of_year: int
    week_of_year: int
    day_of_year: int
    month_of_quarter: int
    week_of_quarter: int
    day_of_quarter: int
    week_of_month: int
    day_of_month: int
    day_of_week: int


def generate_date_dimension() -> Generator[DimDateRecord, None, None]:
    current_date = CONST_WINDOW_START
    while current_date <= CONST_WINDOW_END:
        quarter = (current_date.month - 1) // 3 + 1
        year_start = date(current_date.year, 1, 1)
        quarter_start = date(current_date.year, 3 * quarter - 2, 1)
        month_start = date(current_date.year, current_date.month, 1)
        week_start = current_date - timedelta(days=current_date.weekday())

        yield DimDateRecord(
            datekey=int(current_date.strftime("%Y%m%d")),
            datevalue=current_date,
            year_start=year_start,
            year_end=date(current_date.year, 12, 31),
            quarter_start=quarter_start,
            quarter_end=(date(current_date.year, 3 * quarter, 1) - timedelta(days=1)),
            month_start=month_start,
            month_end=(
                (date(current_date.year, current_date.month + 1, 1) - timedelta(days=1))
                if current_date.month < 12
                else date(current_date.year, 12, 31)
            ),
            week_start=week_start,
            week_end=week_start + timedelta(days=6),
            is_weekend=current_date.weekday() >= 5,
            month_name=current_date.strftime("%B"),
            month_abbr=current_date.strftime("%b"),
            day_name=current_date.strftime("%A"),
            day_abbr=current_date.strftime("%a"),
            quarter_of_year=quarter,
            month_of_year=current_date.month,
            week_of_year=current_date.isocalendar()[1],
            day_of_year=(current_date - year_start).days + 1,
            month_of_quarter=(current_date.month - 1) % 3 + 1,
            week_of_quarter=((current_date - quarter_start).days // 7) + 1,
            day_of_quarter=(current_date - quarter_start).days + 1,
            week_of_month=((current_date.day - 1) // 7) + 1,
            day_of_month=current_date.day,
            day_of_week=current_date.weekday(),
        )
        current_date += timedelta(days=1)


if __name__ == "__main__":
    for record in generate_date_dimension():
        print(record)
