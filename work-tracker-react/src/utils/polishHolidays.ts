import { format } from 'date-fns';

const POLISH_HOLIDAYS: Record<string, string> = {
    '01-01': 'Nowy Rok',
    '01-06': 'Święto Trzech Króli',
    '05-01': 'Święto Pracy',
    '05-03': 'Święto Konstytucji 3 Maja',
    '08-15': 'Wniebowzięcie NMP',
    '11-01': 'Wszystkich Świętych',
    '11-11': 'Święto Niepodległości',
    '12-25': 'Boże Narodzenie',
    '12-26': 'Drugi Dzień Bożego Narodzenia'
};

export function isHoliday(date: Date): boolean {
    const key = format(date, 'MM-dd');
    return key in POLISH_HOLIDAYS;
}

export function getHolidayName(date: Date): string | null {
    const key = format(date, 'MM-dd');
    return POLISH_HOLIDAYS[key] || null;
}

export function isWeekend(date: Date): boolean {
    const day = date.getDay();
    return day === 0 || day === 6; // Sunday or Saturday
}
