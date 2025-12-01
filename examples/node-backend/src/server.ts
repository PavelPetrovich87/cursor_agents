import http from 'node:http'

import { createApp } from './app'
import { connectToDatabase } from './config/database'
import { env } from './config/env'

const startServer = async (): Promise<void> => {
  await connectToDatabase()

  const app = createApp()
  const server = http.createServer(app)

  server.listen(env.PORT, () => {
    console.log(`Backend listening on port ${env.PORT}`)
  })
}

startServer().catch((error) => {
  console.error('Failed to start backend server', error)
  process.exitCode = 1
})






