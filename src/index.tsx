import React, { ReactElement } from 'react'
import { Container } from './App.styles'
import { Calendar } from './screens'

export default function App (): ReactElement {
  return (
    <Container>
      <Calendar />
    </Container>
  )
}
