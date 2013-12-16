package com.mapps.utils;

import java.util.Calendar;
import java.util.Date;


import com.sun.istack.internal.Nullable;

/**
 *
 *
 */
public enum DateToCalendar implements Bijection<Date, Calendar>{
    INSTANCE;

    @Override
    public Calendar apply(@Nullable Date from) {
        final Calendar calendar = Calendar.getInstance();
        calendar.setTime(from);
        return calendar;
    }

    @Override
    public Bijection<Calendar, Date> inverse() {
        return CalendarToDate.INSTANCE;
    }

    @Override
    public String toString() {
        return CalendarToDate.INSTANCE.toString() + ".inverse()";
    }
}
