import styled from 'styled-components/native'

export interface ContainerProps {
  week: number
  dayOfWeek: 0 | 1 | 2 | 3 | 4 | 5 | 6
  isCurrentMonth: boolean
  isToday: boolean
}

export const Container = styled.View<ContainerProps>`
  border-color: black;
  width: ${100 / 7}%;
  aspect-ratio: 1;
  align-items: center;
  justify-content: center;
  border-top-width: ${({ week }) => week === 1 ? 1 : 0}px;
  border-right-width: ${({ dayOfWeek }) => dayOfWeek === 6 ? 1 : 0}px;
  border-bottom-width: 1px;
  border-left-width: 1px;
  background-color: ${({ isCurrentMonth, isToday }) => isToday ? 'lightblue' : isCurrentMonth ? 'white' : 'lightgrey'};
`

export interface TextProps {
  isCurrentMonth: boolean
}

export const Text = styled.Text<TextProps>`
  color: ${({ isCurrentMonth }) => isCurrentMonth ? 'black' : 'grey'};
`
