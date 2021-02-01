import { addMonths, isSameMonth, subMonths } from 'date-fns'
import React, { ReactElement } from 'react'
import { View } from 'react-native'
import Icon from 'react-native-vector-icons/MaterialIcons'
import { useRecoilState } from 'recoil'
import { Month } from '../components'
import { calendarDate } from '../recoil/calendarDate.atom'
import { Container, ControlRow } from './Calendar.styles'

interface CalendarButtonProps {
  name: string
  onPress: () => void
  label: string
}

function CalendarButton ({ name, label, onPress }: CalendarButtonProps): ReactElement {
  return (
    <View>
      <Icon.Button {...{ name, onPress }} size={30}>
        {label}
      </Icon.Button>
    </View>
  )
}

export function Calendar (): ReactElement {
  const [date, setDate] = useRecoilState(calendarDate)

  return (
    <Container>
      <ControlRow>
        <CalendarButton onPress={() => setDate(subMonths(date, 1))} label='Last Month' name='arrow-back' />
        <CalendarButton onPress={() => setDate(addMonths(date, 1))} label='Next Month' name='arrow-forward' />
      </ControlRow>
      <Month date={date} />
      <ControlRow>
        {!isSameMonth(date, new Date()) && <CalendarButton onPress={() => setDate(new Date())} label='Go to Today' name='calendar-today' />}
      </ControlRow>
    </Container>
  )
}
