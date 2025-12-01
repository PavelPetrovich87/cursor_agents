import { create } from 'zustand'

type CounterState = {
  count: number
}

type CounterActions = {
  increment: () => void
  reset: () => void
}

export const useExampleStore = create<CounterState & CounterActions>((set) => ({
  count: 0,
  increment: () => {
    set((state) => ({ count: state.count + 1 }))
  },
  reset: () => {
    set({ count: 0 })
  }
}))






