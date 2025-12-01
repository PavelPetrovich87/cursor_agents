import mongoose from 'mongoose'

import { env } from './env'

class DatabaseConnectionError extends Error {
  public readonly cause: unknown

  constructor(message: string, cause: unknown) {
    super(message)
    this.name = 'DatabaseConnectionError'
    this.cause = cause
  }
}

export const connectToDatabase = async (): Promise<typeof mongoose> => {
  try {
    return await mongoose.connect(env.MONGO_URI)
  } catch (error) {
    throw new DatabaseConnectionError('Failed to connect to MongoDB', error)
  }
}

