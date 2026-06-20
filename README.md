<p align="center">
  <img src="https://raw.githubusercontent.com/JoaooffZz/session_auth_auto/main/assets/session_auth_auto_logo.png" width="300px" alt="Session Auth Auto Logo" onerror="this.style.display='none'">
</p>
<h2 align="center">Transparent and Automated Session & Token Management for Flutter</h2>

<p align="center">
  <a href="https://pub.dev/packages/session_auth_auto">
    <img src="https://img.shields.io/badge/pub.dev-session__auth__auto-00FF66?labelColor=333940&logo=dart">
  </a>
  <img src="https://img.shields.io/badge/platform-flutter-00FF66?labelColor=333940">
  <img src="https://img.shields.io/badge/license-Apache%202.0-00FF66?labelColor=333940">
</p>

---

O **Session Auth Auto** é uma biblioteca Flutter de alta performance projetada para abstrair completamente o gerenciamento de sessões autenticadas e tokens de acesso. Com ela, o desenvolvedor **nunca** precisa lidar manualmente com expiração de tokens, refresh tokens ou reautenticação — a biblioteca gerencia tudo silenciosamente em segundo plano, garantindo que a chamada de `getToken()` sempre retorne um token válido.

### 🎯 Para quem é destinado?
Desenvolvedores Flutter que buscam eliminar o *boilerplate* de interceptores de rede, controle manual de expiração e fluxos complexos de re-login. Se o seu app precisa armazenar credenciais com segurança de nível de sistema (Keychain/Keystore), persistir tokens estruturados localmente e renovar as credenciais automaticamente e proativamente (inclusive ao abrir o app após um período de tempo), o Session Auth Auto foi feito para você.

---

## Recursos Principais 🌟

- **🔑 Segurança em Duas Camadas:**
  - **Secure Enclave:** Credenciais confidenciais (usuário e senha) são salvas criptografadas no Keychain/Keystore via `flutter_secure_storage`.
  - **SQLite Local (Drift):** Tokens de acesso, metadados do usuário (nome, cargo, avatar) e logs de auditoria são mantidos em banco de dados estruturado de alta performance.
- **🔄 Renovação Reativa Transparente:** Ao chamar `getToken()`, a biblioteca analisa a validade do token com margem de segurança configurável (*clock skew*) e, se expirado, realiza o refresh de forma síncrona/transparente antes de entregar a string ao seu cliente HTTP.
- **🛡️ Login de Recuperação (Fallback):** Se o refresh token estiver expirado ou falhar, a biblioteca tenta refazer o login silenciosamente usando as credenciais do armazenamento seguro.
- **📅 Auto-Refresh Proativo:** Além de reagir à expiração, a biblioteca compara datas na inicialização do app e executa uma renovação proativa caso o intervalo configurado (ex: a cada 24h) tenha passado.
- **📊 Auditoria Drift (Logs de Auditoria):** Cada tentativa de login, refresh ou auto-refresh é registrada localmente em uma tabela dedicada de auditoria com expurgo automático configurável.

---

## Começando Rápido 🚀

### 1. 🔗 Adicione as Dependências

Adicione `session_auth_auto` ao seu arquivo `pubspec.yaml`:

```yaml
dependencies:
  session_auth_auto: ^1.0.0
```

### 2. 🏡 Inicialize o Session Auth Auto

Configure a biblioteca no ponto de entrada do seu aplicativo (`main.dart`). Você deve fornecer os callbacks responsáveis por realizar o login remoto e o refresh na sua API externa:

```dart
import 'package:flutter/material.dart';
import 'package:session_auth_auto/session_auth_auto.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Inicializa o gerenciador de sessão transparente
  await SessionAuthAuto.init(
    onLogin: (credentials) async {
      // Chame o endpoint de login da sua API
      final res = await myApi.login(credentials.username, credentials.password);
      return AuthToken(
        accessToken: res.token,
        refreshToken: res.refreshToken,
        expiresAt: res.expiresAt,
      );
    },
    onRefresh: (refreshToken) async {
      // Chame o endpoint de refresh token da sua API
      final res = await myApi.refresh(refreshToken);
      return AuthToken(
        accessToken: res.token,
        refreshToken: res.refreshToken,
        expiresAt: res.expiresAt,
      );
    },
    config: const SessionAuthAutoConfig(
      refreshIntervalHours: 24, // Renovação diária proativa ao abrir o app
      tokenExpiryBufferSeconds: 30, // Margem de segurança de expiração
      autoReloginOnRefreshFailure: true, // Login fallback se o refresh falhar
    ),
  );

  runApp(const MyApp());
}
```

---

## 🛠️ Como Usar

### 🏁 1. Definir o Usuário Autenticado (Set User)
Quando o usuário digita as credenciais pela primeira vez na tela de Login, passe os dados para o `SessionAuthAuto`. A biblioteca fará o login inicial, salvará as credenciais no cofre seguro, salvará os metadados no SQLite e iniciará a sessão.

```dart
await SessionAuthAuto.setUser(
  AuthUser(
    id: 'user-id-123',
    credentials: Credentials(username: 'ana@email.com', password: 'senha_secreta'),
    metadata: {
      'name': 'Ana Silva',
      'avatarUrl': 'https://example.com/avatar.png',
      'role': 'Manager',
    },
  ),
);
```

### 🔑 2. Obter o Token de Acesso Válido
Em suas chamadas HTTP ou interceptores (como no `Dio`, `http` ou `Chopper`), basta solicitar o token de acesso. A biblioteca se encarrega de verificar a validade e renovar se necessário.

```dart
final token = await SessionAuthAuto.getToken();
// Adicione o cabeçalho: Authorization: Bearer $token
```

### 🚪 3. Encerrar Sessão (Logout)
Limpa de forma atômica o estado em memória, apaga credenciais do Secure Storage, exclui metadados do SQLite e invalida os tokens locais.

```dart
await SessionAuthAuto.logout();
```

### 📡 4. Escutar Alterações na UI (Getters Síncronos)
Você pode expor dados de sessão dinamicamente em suas views usando os getters estáticos:

```dart
final user = SessionAuthAuto.currentUser; // Retorna AuthUser?
final isAuth = SessionAuthAuto.isAuthenticated; // Retorna bool
final nextRefresh = SessionAuthAuto.nextScheduledRefreshAt; // Retorna DateTime?
final lastRefresh = SessionAuthAuto.lastRefreshedAt; // Retorna DateTime?
```

---

## 📊 Histórico de Auditoria e Logs

Para depuração interna ou exibição em telas administrativas de suporte do app, você pode ler os logs de tentativas de refresh armazenados no SQLite:

```dart
List<RefreshLog> logs = await SessionAuthAuto.getRefreshLogs();
for (var log in logs) {
  print('Origem: ${log.triggeredBy} | Sucesso: ${log.success} | Horário: ${log.attemptedAt}');
}
```

---

## 🎮 Aplicativo de Exemplo (Playground)

O projeto inclui um aplicativo de demonstração completo no diretório [example/](file:///Users/macbook/projects/session_auth_auto/example) projetado com uma interface visual dark mode moderna. Ele simula tokens de mock que expiram a cada 15 segundos para você testar a expiração reativa e acompanhar os logs do Drift sendo escritos na tela instantaneamente.

### Como rodar o exemplo:
1. Conecte um emulador ou dispositivo físico.
2. Execute a partir do diretório do exemplo:
```bash
cd example
flutter run
```

---

## 📜 Licença

```
Copyright 2026 Session Auth Auto Team

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
```
