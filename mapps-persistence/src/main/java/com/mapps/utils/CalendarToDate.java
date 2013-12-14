package com.mapps.utils;

import java.util.Calendar;
import java.util.Date;

import com.sun.istack.internal.Nullable;

enum CalendarToDate implements Bijection<Calendar, Date> {

    INSTANCE;

    @Override
    public Date apply(@Nullable Calendar from) {
        return from == null ? null : from.getTime();
    }

    @Override
    public Bijection<Date, Calendar> inverse() {
        return DateToCalendar.INSTANCE;
    }

    @Override
    public String toString() {
        return "Calendars.getTime()";
    }

}
