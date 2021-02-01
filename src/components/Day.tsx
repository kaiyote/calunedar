import { getDate, getDay, isToday } from 'date-fns'
import React, { ReactElement } from 'react'
import { Container, Text } from './Day.styles'

export interface DayProps {
  date: Date
  isCurrentMonth: boolean
  weekNumber: number
}

export function Day ({ date, isCurrentMonth, weekNumber }: DayProps): ReactElement {
  return (
    <Container week={weekNumber} dayOfWeek={getDay(date)} isCurrentMonth={isCurrentMonth} isToday={isToday(date)}>
      <Text isCurrentMonth={isCurrentMonth}>{getDate(date)}</Text>
    </Container>
  )
}
