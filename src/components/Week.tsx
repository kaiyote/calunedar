import { eachDayOfInterval, getMonth } from 'date-fns'
import React, { ReactElement } from 'react'
import { Day } from './Day'
import { Container } from './Week.styles'

export interface WeekProps {
  start: Date
  end: Date
  month: number
  weekNumber: number
}

export function Week ({ start, end, month, weekNumber }: WeekProps): ReactElement {
  return (
    <Container>
      {eachDayOfInterval({ start, end }).map((day, i) => <Day date={day} key={i} isCurrentMonth={getMonth(day) === month} weekNumber={weekNumber} />)}
    </Container>
  )
}
