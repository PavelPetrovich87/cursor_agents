import React from 'react'
import { Pressable, StyleSheet, Text, View } from 'react-native'

import { useExampleStore } from '../store/useExampleStore'

export const HomeScreen = (): React.JSX.Element => {
  const count = useExampleStore((state) => state.count)
  const increment = useExampleStore((state) => state.increment)
  const reset = useExampleStore((state) => state.reset)

  return (
    <View style={styles.container}>
      <Text style={styles.title}>React Native + Zustand Boilerplate</Text>
      <Text style={styles.counterValue}>{count}</Text>
      <View style={styles.actions}>
        <Pressable accessibilityRole="button" onPress={increment} style={styles.button}>
          <Text style={styles.buttonLabel}>Increment</Text>
        </Pressable>
        <Pressable accessibilityRole="button" onPress={reset} style={[styles.button, styles.secondaryButton]}>
          <Text style={styles.buttonLabel}>Reset</Text>
        </Pressable>
      </View>
    </View>
  )
}

const styles = StyleSheet.create({
  container: {
    flex: 1,
    paddingHorizontal: 24,
    justifyContent: 'center',
    alignItems: 'center',
    gap: 24,
    backgroundColor: '#f4f4f5'
  },
  title: {
    fontSize: 20,
    fontWeight: '600',
    textAlign: 'center'
  },
  counterValue: {
    fontSize: 48,
    fontWeight: '700'
  },
  actions: {
    flexDirection: 'row',
    gap: 16
  },
  button: {
    paddingHorizontal: 16,
    paddingVertical: 12,
    borderRadius: 8,
    backgroundColor: '#2563eb'
  },
  secondaryButton: {
    backgroundColor: '#64748b'
  },
  buttonLabel: {
    color: '#ffffff',
    fontSize: 16,
    fontWeight: '600'
  }
})






