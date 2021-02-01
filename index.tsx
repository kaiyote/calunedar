import { registerRootComponent } from 'expo'
import React, { ReactElement } from 'react'
import { RecoilRoot } from 'recoil'
import App from './src'

export default function Root (): ReactElement {
  return (
    <RecoilRoot>
      <App />
    </RecoilRoot>
  )
}

registerRootComponent(Root)
