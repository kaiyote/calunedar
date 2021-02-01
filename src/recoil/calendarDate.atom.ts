import { atom } from 'recoil'

export const calendarDate = atom({
  key: 'calendar-date',
  default: new Date()
})
