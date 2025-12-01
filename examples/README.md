# 📂 Examples

This directory contains example implementations to demonstrate how the multi-agent system works with real code.

## Structure

```
examples/
├── expo-app/          # React Native + Expo example
│   ├── app/           # Expo Router screens
│   ├── src/           # Components, hooks, stores
│   └── package.json
│
├── node-backend/      # Node.js + Express example
│   ├── src/           # Controllers, routes, models
│   └── package.json
│
└── tests/             # E2E test examples
    ├── e2e/
    └── integration/
```

## Usage

These examples are **optional reference implementations**. When you use this template:

1. **Keep them** - If you want to start with working boilerplate code
2. **Delete them** - If you're adding agents to an existing project
3. **Study them** - To understand patterns the agents expect

## Running the Examples

### Expo App
```bash
cd examples/expo-app
npm install
npx expo start
```

### Node Backend
```bash
cd examples/node-backend
npm install
npm run dev
```

## Notes

- Examples follow the patterns defined in `.cursor/rules/`
- Code structure matches what agents expect (controllers, services, etc.)
- These are minimal starters, not production-ready apps

