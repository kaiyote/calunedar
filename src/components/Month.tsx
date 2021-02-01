import { eachWeekOfInterval, endOfMonth, endOfWeek, format, getMonth, startOfMonth } from 'date-fns'
import React, { ReactElement } from 'react'
import { Container, Header } from './Month.styles'
import { Week } from './Week'

export interface MonthProps {
  date: Date
}

export function Month ({ date }: MonthProps): ReactElement {
  const weekThings = eachWeekOfInterval({ start: startOfMonth(date), end: endOfMonth(date) })
  const month = getMonth(date)

  return (
    <Container>
      <Header>{format(date, 'MMMM, yyyy')}</Header>
      {weekThings.map((w, i) => <Week start={w} end={endOfWeek(w)} month={month} weekNumber={i + 1} key={i} />)}
    </Container>
  )
}
