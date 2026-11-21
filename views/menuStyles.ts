import { StyleSheet } from 'react-native';

export const menu = StyleSheet.create({
  container: { flex: 1, alignItems: 'center', justifyContent: 'center', backgroundColor: '#000' },
  title: { color: '#00ff00', fontSize: 46, fontWeight: 'bold', textAlign: 'center' },
  stat: { color: '#fff', marginTop: 12, fontSize: 18 },
  button: { marginTop: 34, borderColor: '#00ff00', borderWidth: 2, paddingHorizontal: 30, paddingVertical: 14 },
  buttonText: { color: '#00ff00', fontWeight: 'bold', fontSize: 20 },
  hint: { color: '#fff', marginTop: 24, fontSize: 16 },
});
