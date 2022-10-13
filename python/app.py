from datetime import datetime
from service.working_time import WorkingTime

service = WorkingTime()

def main():
    print('>> starting program...')

    start = datetime(2020, 3, 5, 9, 45)
    end = datetime(2020, 3, 6, 15, 22)

    print('>> example', start, 'to', end)

    time_spent = service.working_time(start, end)
    
    print('>> time spent', time_spent)
    

    start = datetime.strptime((input('>> insert the start date (YYYY-MM-DD HH:MM:SS)\n')), '%Y-%m-%d %H:%M:%S')
    end = datetime.strptime((input('>> insert the end date (YYYY-MM-DD HH:MM:SS)\n')), '%Y-%m-%d %H:%M:%S')

    time_spent = service.working_time(start, end)
    
    print('>> time spent', time_spent)

    return time_spent

main()