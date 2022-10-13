from datetime import datetime, timedelta, time
import holidays

INITIAL_WORKING_HOUR = 8
INITIAL_WORKING_MINUTE = 0
FINAL_WORKING_HOUR = 17
FINAL_WORKING_MINUTE = 0
WORKING_HOURS_PER_DAY = FINAL_WORKING_HOUR - INITIAL_WORKING_HOUR

class WorkingTime:
    
    # computate the working time (INITIAL_WORKING_HOUR to FINAL_WORKING_HOUR) between the two dates
    # returns a timedelta of the difference
    def working_time(self, initial_date, final_date):
        print('>> calculating worktime between', self.humanize_date(INITIAL_WORKING_HOUR, INITIAL_WORKING_MINUTE), 'to', self.humanize_date(FINAL_WORKING_HOUR, FINAL_WORKING_MINUTE))

        # check if it's the same day
        same_day = initial_date.date() == final_date.date()

        # sets the initial working date
        begin = initial_date if self.working_day(initial_date) or same_day else self.next_working_day(initial_date)
        # sets the final working date
        end = final_date if self.working_day(final_date) or same_day else self.next_working_day(final_date)
        # sets the current date
        current_day = begin

        # if started before INITIAL_WORKING_HOUR, sets initial date to INITIAL_WORKING_HOUR
        if initial_date.time().hour < INITIAL_WORKING_HOUR:
            begin = self.initial_working_time(begin)
        # if started at FINAL_WORKING_HOUR or later, sets initial date to INITIAL_WORKING_HOUR of next working day
        elif initial_date.time().hour >= FINAL_WORKING_HOUR:
            begin += timedelta(days = 1)
            begin = self.initial_working_time(begin)

        # if started before INITIAL_WORKING_HOUR, sets initial date to INITIAL_WORKING_HOUR
        if final_date.time().hour < INITIAL_WORKING_HOUR:
            end = self.initial_working_time(end)
        # if ended after FINAL_WORKING_HOUR, sets the time to final working time
        elif final_date.time().hour >= FINAL_WORKING_HOUR:
            end = self.final_working_time(final_date)

        # initialize var
        time_spent = timedelta()

        # if had started and ended on the same day (the original or the working dates)
        if same_day or begin.date() == end.date():
            # only compute time if it's a working day and time
            if self.working_day(begin) and end > begin:
                time_spent += end - begin

            return time_spent
        else:
            # calculate the time spent on first day
            time_spent += self.final_working_time(begin) - begin

        current_day = self.next_working_day(current_day)

        # while the current day is before the final day
        while current_day.date() < end.date():
            # increases one working day to time spent 
            time_spent += timedelta(hours = WORKING_HOURS_PER_DAY)
            current_day = self.next_working_day(current_day)

        if current_day.date() == end.date():
            time_spent += end - self.initial_working_time(end)
        else:
            return timedelta()

        return time_spent


    # is a working day if it's not a holiday or weekend
    def working_day(self, date):
        return not self.is_holiday(date) and not self.is_weekend(date)
    

    def is_weekend(self, date):
        return date.weekday() > 4


    def is_holiday(self, date):
        if isinstance(date, datetime):
            date = date.date()

        return date in holidays.BR()


    # returns the next working day from some date, or itself if it's a valid working day
    def next_working_day(self, date):
        # if it's not a working day, must set time to INITIAL_WORKING_HOUR and INITIAL_WORKING_MINUTE
        if not self.working_day(date):
            date = self.initial_working_time(date)

        date += timedelta(days = 1)

        while not self.working_day(date):
            date += timedelta(days = 1)
            date = self.initial_working_time(date)

        return date


    # returns the initial working time of the day
    def initial_working_time(self, date):
        return date.replace(hour = INITIAL_WORKING_HOUR, minute = INITIAL_WORKING_MINUTE)


    # returns the final working time of the day
    def final_working_time(self, date):
        return date.replace(hour = FINAL_WORKING_HOUR, minute = FINAL_WORKING_MINUTE)


    def humanize_date(self, hour, minute):
        return '{}:{}'.format('0' + str(hour) if hour < 10 else str(hour), '0' + str(minute) if minute < 10 else minute)
