from src.service.working_time import WorkingTime
from datetime import datetime, timedelta, date

service = WorkingTime()

def test_calculate_working_time():
    assert service.working_time(datetime(2020, 1, 2, 8, 0), datetime(2020, 1, 3, 17, 0)) == timedelta(hours = 18, minutes = 0)
    assert service.working_time(datetime(2020, 1, 2, 0, 0), datetime(2020, 1, 3, 23, 59)) == timedelta(hours = 18, minutes = 0)
    assert service.working_time(datetime(2020, 1, 2, 8, 0), datetime(2020, 1, 2, 17, 0)) == timedelta(hours = 9, minutes = 0)
    assert service.working_time(datetime(2020, 1, 2, 8, 30), datetime(2020, 1, 2, 16, 45)) == timedelta(hours = 8, minutes = 15)
    assert service.working_time(datetime(2020, 1, 2, 8, 0), datetime(2020, 1, 6, 12, 0)) == timedelta(hours = 22, minutes = 0)
    assert service.working_time(datetime(2020, 1, 6, 0, 0), datetime(2020, 1, 10, 23, 59)) == timedelta(hours = 45, minutes = 0)
    assert service.working_time(datetime(2020, 1, 6, 16, 30), datetime(2020, 1, 10, 9, 55)) == timedelta(hours = 29, minutes = 25)
    assert service.working_time(datetime(2020, 1, 10, 12, 15), datetime(2020, 1, 13, 11, 0)) == timedelta(hours = 7, minutes = 45)
    assert service.working_time(datetime(2020, 1, 6, 16, 59), datetime(2020, 1, 7, 8, 1)) == timedelta(hours = 0, minutes = 2)
    assert service.working_time(datetime(2019, 12, 24, 16, 30), datetime(2019, 12, 26, 10, 0)) == timedelta(hours = 2, minutes = 30)
    assert service.working_time(datetime(2019, 12, 31, 14, 23), datetime(2020, 1, 2, 11, 47)) == timedelta(hours = 6, minutes = 24)
    assert service.working_time(datetime(2020, 3, 5, 7, 43), datetime(2020, 3, 5, 8, 12)) == timedelta(hours = 0, minutes = 12)
    assert service.working_time(datetime(2020, 3, 1, 13, 48), datetime(2020, 4, 1, 16, 11)) == timedelta(hours = 206, minutes = 11)
    assert service.working_time(datetime(2020, 3, 5, 9, 45), datetime(2020, 3, 6, 15, 22)) == timedelta(hours = 14, minutes = 37)

def test_weekend():
    assert service.is_weekend(date(2020, 3, 1)) # Sunday
    assert service.is_weekend(date(2020, 3, 7)) # Saturday
    assert not service.is_weekend(date(2020, 3, 2)) # Monday
    assert not service.is_weekend(date(2020, 3, 3)) # Tuesday
    assert not service.is_weekend(date(2020, 3, 4)) # Wednesday
    assert not service.is_weekend(date(2020, 3, 5)) # Thursday
    assert not service.is_weekend(date(2020, 3, 6)) # Friday

def test_holidays():
    assert service.is_holiday(date(2019, 9, 7))
    assert service.is_holiday(date(2019, 11, 15))
    assert service.is_holiday(date(2019, 12, 25))
    assert service.is_holiday(date(2020, 1, 1))
    assert service.is_holiday(date(2020, 2, 25))
    assert service.is_holiday(date(2020, 5, 1))
    
    assert not service.is_holiday(date(2020, 1, 2))
    assert not service.is_holiday(date(2020, 2, 24))
    assert not service.is_holiday(date(2020, 3, 25))
    assert not service.is_holiday(date(2020, 5, 15))

def test_working_day():
    assert not service.working_day(date(2020, 3, 1)) # Sunday
    assert not service.working_day(date(2020, 3, 7)) # Saturday
    assert not service.working_day(date(2020, 1, 1)) # Holiday
    assert not service.working_day(date(2020, 2, 25)) # Holiday
    assert not service.working_day(date(2019, 9, 7)) # Holiday
    assert not service.working_day(date(2019, 11, 15)) # Holiday
    assert not service.working_day(date(2019, 12, 25)) # Holiday
    assert not service.working_day(date(2020, 5, 1)) # Holiday
    
    assert service.working_day(date(2020, 5, 15))
    assert service.working_day(date(2020, 4, 14))
    assert service.working_day(date(2020, 3, 13))
