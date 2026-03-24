/// Environment and API configuration.
/// Base URL and feature flags can be overridden per environment.
class EnvConfig {
  EnvConfig._();

  static const String baseUrl = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: 'https://api.example.com',
  );

  static const bool enableLogging = bool.fromEnvironment(
    'DEBUG',
    defaultValue: false,
  );

  static const int connectTimeoutMs = 15000;
  static const int receiveTimeoutMs = 15000;
  static const int sendTimeoutMs = 15000;
}
