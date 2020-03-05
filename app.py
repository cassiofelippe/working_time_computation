from datetime import datetime
from src.service.working_time import WorkingTime

service = WorkingTime()

def main():
    start = datetime(2020, 3, 5, 9, 45)
    end = datetime(2020, 3, 6, 15, 22)

    diff = service.working_time(start, end)

    print('diff', diff)
    
    return diff
