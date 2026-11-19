/// Backend base URL. Override at run time, e.g.:
/// flutter run --dart-define=API_BASE_URL=http://10.0.2.2:8000  (Android emulator)
const String apiBaseUrl = String.fromEnvironment(
  'API_BASE_URL',
  defaultValue: 'http://localhost:8000',
);
