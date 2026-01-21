import { useState, useEffect, useCallback } from 'react';
import { format, startOfMonth, endOfMonth, eachDayOfInterval, getWeek } from 'date-fns';
import { WorkDay, WorkType, MonthlyStats } from '../types/models';
import { saveWorkDays, loadWorkDays } from '../utils/storage';
import { isHoliday, isWeekend } from '../utils/polishHolidays';

export function useWorkData() {
    const [workDays, setWorkDays] = useState<Record<string, WorkDay>>({});

    useEffect(() => {
        const loaded = loadWorkDays();
        setWorkDays(loaded);
    }, []);

    const getWorkType = useCallback((date: Date): WorkType => {
        const key = format(date, 'yyyy-MM-dd');
        return workDays[key]?.workType ?? WorkType.NotSet;
    }, [workDays]);

    const setWorkType = useCallback((date: Date, type: WorkType) => {
        const key = format(date, 'yyyy-MM-dd');
        const newWorkDays = {
            ...workDays,
            [key]: {
                id: Date.now().toString(),
                date: key,
                workType: type
            }
        };
        setWorkDays(newWorkDays);
        saveWorkDays(newWorkDays);
    }, [workDays]);

    const getMonthlyStats = useCallback((date: Date): MonthlyStats => {
        const start = startOfMonth(date);
        const end = endOfMonth(date);
        const days = eachDayOfInterval({ start, end });

        let totalWorkDays = 0;
        let officeDays = 0;
        let remoteDays = 0;
        let daysOff = 0;
        const weeklyOfficeDays: Record<number, number> = {};
        const weeklyWorkDays: Record<number, number> = {};

        days.forEach(day => {
            if (isWeekend(day) || isHoliday(day)) return;

            const workType = getWorkType(day);
            const weekOfYear = getWeek(day, { weekStartsOn: 1 });

            switch (workType) {
                case WorkType.Office:
                    totalWorkDays++;
                    officeDays++;
                    weeklyOfficeDays[weekOfYear] = (weeklyOfficeDays[weekOfYear] || 0) + 1;
                    weeklyWorkDays[weekOfYear] = (weeklyWorkDays[weekOfYear] || 0) + 1;
                    break;
                case WorkType.Remote:
                    totalWorkDays++;
                    remoteDays++;
                    weeklyWorkDays[weekOfYear] = (weeklyWorkDays[weekOfYear] || 0) + 1;
                    break;
                case WorkType.DayOff:
                    daysOff++;
                    break;
            }
        });

        // Calculate average weekly office percentage
        let averageOfficeDaysPerWeek = 0;
        const weeks = Object.keys(weeklyWorkDays);
        if (weeks.length > 0) {
            let totalPercentage = 0;
            weeks.forEach(week => {
                const weekNum = parseInt(week);
                const workDaysInWeek = weeklyWorkDays[weekNum] || 0;
                if (workDaysInWeek > 0) {
                    const officeDaysInWeek = weeklyOfficeDays[weekNum] || 0;
                    const weekPercentage = (officeDaysInWeek / workDaysInWeek) * 100;
                    totalPercentage += weekPercentage;
                }
            });
            averageOfficeDaysPerWeek = totalPercentage / weeks.length;
        }

        return {
            totalWorkDays,
            officeDays,
            remoteDays,
            daysOff,
            averageOfficeDaysPerWeek
        };
    }, [getWorkType]);

    const getThreeMonthStats = useCallback((date: Date): MonthlyStats => {
        let totalWorkDays = 0;
        let officeDays = 0;
        let remoteDays = 0;
        let daysOff = 0;
        const weeklyOfficeDays: Record<number, number> = {};
        const weeklyWorkDays: Record<number, number> = {};

        // Iterate through current month and 2 previous months
        for (let monthOffset = 0; monthOffset < 3; monthOffset++) {
            const targetDate = new Date(date.getFullYear(), date.getMonth() - monthOffset, 1);
            const start = startOfMonth(targetDate);
            const end = endOfMonth(targetDate);
            const days = eachDayOfInterval({ start, end });

            days.forEach(day => {
                if (isWeekend(day) || isHoliday(day)) return;

                const workType = getWorkType(day);
                // Use year * 100 + week to handle year boundaries
                const weekKey = day.getFullYear() * 100 + getWeek(day, { weekStartsOn: 1 });

                switch (workType) {
                    case WorkType.Office:
                        totalWorkDays++;
                        officeDays++;
                        weeklyOfficeDays[weekKey] = (weeklyOfficeDays[weekKey] || 0) + 1;
                        weeklyWorkDays[weekKey] = (weeklyWorkDays[weekKey] || 0) + 1;
                        break;
                    case WorkType.Remote:
                        totalWorkDays++;
                        remoteDays++;
                        weeklyWorkDays[weekKey] = (weeklyWorkDays[weekKey] || 0) + 1;
                        break;
                    case WorkType.DayOff:
                        daysOff++;
                        break;
                }
            });
        }

        // Calculate average weekly office percentage
        let averageOfficeDaysPerWeek = 0;
        const weeks = Object.keys(weeklyWorkDays);
        if (weeks.length > 0) {
            let totalPercentage = 0;
            weeks.forEach(week => {
                const weekNum = parseInt(week);
                const workDaysInWeek = weeklyWorkDays[weekNum] || 0;
                if (workDaysInWeek > 0) {
                    const officeDaysInWeek = weeklyOfficeDays[weekNum] || 0;
                    const weekPercentage = (officeDaysInWeek / workDaysInWeek) * 100;
                    totalPercentage += weekPercentage;
                }
            });
            averageOfficeDaysPerWeek = totalPercentage / weeks.length;
        }

        return {
            totalWorkDays,
            officeDays,
            remoteDays,
            daysOff,
            averageOfficeDaysPerWeek
        };
    }, [getWorkType]);

    return {
        getWorkType,
        setWorkType,
        getMonthlyStats,
        getThreeMonthStats
    };
}
