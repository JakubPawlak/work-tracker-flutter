import { useState, useEffect, useCallback } from 'react';
import { format, startOfMonth, endOfMonth, eachDayOfInterval, getWeek } from 'date-fns';
import { collection, doc, onSnapshot, setDoc, query } from 'firebase/firestore';
import { db } from '../config/firebase';
import { WorkDay, WorkType, MonthlyStats } from '../types/models';
import { isHoliday, isWeekend } from '../utils/polishHolidays';

export function useWorkData(userId: string | undefined) {
    const [workDays, setWorkDays] = useState<Record<string, WorkDay>>({});
    const [loading, setLoading] = useState(true);

    // Real-time sync with Firestore
    useEffect(() => {
        if (!userId) {
            setLoading(false);
            return;
        }

        setLoading(true);
        const q = query(collection(db, 'users', userId, 'workDays'));

        const unsubscribe = onSnapshot(q, (snapshot) => {
            const data: Record<string, WorkDay> = {};
            snapshot.forEach((doc) => {
                data[doc.id] = doc.data() as WorkDay;
            });
            setWorkDays(data);
            setLoading(false);
        }, (error) => {
            console.error("Error fetching work days:", error);
            setLoading(false);
        });

        return () => unsubscribe();
    }, [userId]);

    const getWorkType = useCallback((date: Date): WorkType => {
        const key = format(date, 'yyyy-MM-dd');
        return workDays[key]?.workType ?? WorkType.NotSet;
    }, [workDays]);

    const setWorkType = useCallback(async (date: Date, type: WorkType) => {
        if (!userId) return;

        const key = format(date, 'yyyy-MM-dd');
        const workDay: WorkDay = {
            id: key,
            date: key,
            workType: type
        };

        // Optimistic update
        setWorkDays(prev => ({
            ...prev,
            [key]: workDay
        }));

        // Firestore update
        try {
            await setDoc(doc(db, 'users', userId, 'workDays', key), workDay);
        } catch (error) {
            console.error("Error saving work day:", error);
            // Revert on error (optional, complicates logic significantly for rare case)
        }
    }, [userId]);

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
        getThreeMonthStats,
        loading
    };
}
