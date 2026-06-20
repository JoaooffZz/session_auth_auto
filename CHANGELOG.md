# Changelog

## 1.0.0

- **Initial Release** of Session Auth Auto: Transparent and automated session & token management for Flutter.
- **Secure Two-Layer Persistence**: Caches credentials using Keychain/Keystore via `flutter_secure_storage` and tokens/metadata using Drift/SQLite.
- **Transparent Reactive Refresh**: Seamlessly catches expired tokens on `getToken()` and performs refresh token calls before returning the new token to HTTP clients.
- **Proactive Auto-Refresh Scheduler**: Runs proactive checks on app start to refresh credentials in configurable intervals (e.g. every 24 hours).
- **Fallback Recovery Login**: Attempts fallback logins using stored secure credentials when refresh tokens fail.
- **Audit Logs Database**: Stores logs of all login, refresh, and auto-refresh attempts in Drift SQLite with configurable log pruning.
- **Unit Tests**: Full unit test suite with mockable memory-based databases and secure storage wrappers.
- **Example App Dashboard**: Modern dark-themed dashboard app to test credentials persistence, token expirations, manual refresh, and check local Drift audit logs.
