import express, { type Express } from 'express'

import { healthRouter } from './routes/health'

export const createApp = (): Express => {
  const app = express()

  app.use(express.json())

  app.use('/health', healthRouter)

  return app
}






