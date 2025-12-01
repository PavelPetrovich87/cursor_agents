# Fullstack Boilerplate

This repository contains a pnpm-managed monorepo with:

- `backend`: Node.js + Express + MongoDB API written in TypeScript
- `app`: React Native CLI application scaffolded with TypeScript and Zustand for state management

## Prerequisites

- Node.js 18.18 or newer
- pnpm 9 or newer
- MongoDB server (local or remote)
- React Native tooling for your target platforms (Xcode for iOS, Android Studio / SDK for Android)

## Install Dependencies

```bash
pnpm install
```

> **Note**: Package installation requires internet access. If the install fails because the registry cannot be reached, rerun the command when connectivity is available.

## Backend (`backend`)

- Duplicate `backend/.env.example` to `backend/.env` and set the required values
- Start the development server:

```bash
pnpm dev:backend
```

The server loads configuration from environment variables, validates them, connects to MongoDB via `mongoose`, and exposes a health check at `GET /health`.

## Mobile App (`app`)

The React Native package is configured for pnpm and TypeScript. It includes a simple Zustand counter store and a sample `HomeScreen` that exercises the state.

```bash
# Start Metro bundler
pnpm dev:app

# Run platform targets from the app package
pnpm --filter app android
pnpm --filter app ios
```

> **iOS / Android projects**: Native platform folders are not committed. Generate them by running the appropriate React Native CLI commands (e.g. `pnpm --filter app react-native run-android`) after installing platform toolchains.

## Environment Variables

The backend requires the following variables:

- `NODE_ENV`: `development`, `test`, or `production`
- `PORT`: Port number for the HTTP server
- `MONGO_URI`: MongoDB connection string

Missing or invalid values cause the application to exit with an explicit error.

## Project Structure

```
backend/
  src/
    app.ts
    server.ts
    config/
      env.ts
      database.ts
    routes/
      health.ts
app/
  App.tsx
  index.js
  src/
    screens/HomeScreen.tsx
    store/useExampleStore.ts
```

Use the workspace scripts to coordinate both services during development.
