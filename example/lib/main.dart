import 'dart:async';
import 'package:flutter/material.dart';
import 'package:session_auth_auto/session_auth_auto.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Inicializa o gerenciador de sessão com callbacks simulados de API
  await SessionAuthAuto.init(
    onLogin: (credentials) async {
      // Simula uma requisição HTTP de Login
      await Future.delayed(const Duration(milliseconds: 800));
      if (credentials.username.isEmpty || credentials.password.isEmpty) {
        throw Exception('Usuário ou senha não podem ser vazios.');
      }
      // Retorna um token que expira muito rápido (15 segundos) para facilitar o teste da expiração reativa!
      return AuthToken(
        accessToken: 'mock_jwt_access_token_${DateTime.now().millisecondsSinceEpoch}',
        refreshToken: 'mock_refresh_token_xyz123',
        expiresAt: DateTime.now().add(const Duration(seconds: 15)),
      );
    },
    onRefresh: (refreshToken) async {
      // Simula uma requisição HTTP de Refresh
      await Future.delayed(const Duration(milliseconds: 600));
      // Retorna um novo token expirando em mais 15 segundos
      return AuthToken(
        accessToken: 'mock_jwt_refreshed_token_${DateTime.now().millisecondsSinceEpoch}',
        refreshToken: 'mock_refresh_token_xyz123',
        expiresAt: DateTime.now().add(const Duration(seconds: 15)),
      );
    },
    config: SessionAuthAutoConfig(
      refreshIntervalHours: 1, // Intervalo curto para fins de demonstração
      tokenExpiryBufferSeconds: 5, // Buffer curto
      autoReloginOnRefreshFailure: true,
      onAutoRefreshSuccess: (token) {
        debugPrint('Auto-refresh proativo executado com sucesso!');
      },
      onAutoRefreshFailed: (err, stack) {
        debugPrint('Auto-refresh proativo falhou: $err');
      },
    ),
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Session Auth Auto Demo',
      debugShowCheckedModeBanner: false,
      themeMode: ThemeMode.dark,
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF6C63FF),
          brightness: Brightness.dark,
          primary: const Color(0xFF6C63FF),
          secondary: const Color(0xFF00F2FE),
          background: const Color(0xFF0F0E17),
          surface: const Color(0xFF1F1E26),
        ),
        cardTheme: const CardThemeData(
          color: Color(0xFF1F1E26),
          elevation: 4,
          margin: EdgeInsets.symmetric(vertical: 8),
        ),
      ),
      home: const DashboardPage(),
    );
  }
}

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  final TextEditingController _usernameController = TextEditingController(text: 'dev@session.com');
  final TextEditingController _passwordController = TextEditingController(text: 'senha123');

  String _statusMessage = 'Aguardando ações...';
  String _lastTokenObtained = 'Nenhum token obtido ainda.';
  List<RefreshLog> _logs = [];
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _loadLogs();
    // Atualiza a tela a cada 1 segundo para o usuário poder acompanhar a contagem regressiva da expiração
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (mounted) {
        setState(() {});
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _loadLogs() async {
    final logs = await SessionAuthAuto.getRefreshLogs();
    setState(() {
      _logs = logs;
    });
  }

  void _showMessage(String msg) {
    setState(() {
      _statusMessage = msg;
    });
    _loadLogs();
  }

  Future<void> _handleLogin() async {
    try {
      _showMessage('Autenticando usuário...');
      final user = AuthUser(
        id: 'user_dev_99',
        credentials: Credentials(
          username: _usernameController.text,
          password: _passwordController.text,
        ),
        metadata: {
          'name': 'Desenvolvedor Flutter',
          'role': 'Admin',
        },
      );
      await SessionAuthAuto.setUser(user);
      _showMessage('Usuário autenticado com sucesso via setUser()!');
    } catch (e) {
      _showMessage('Erro no login: $e');
    }
  }

  Future<void> _handleGetToken() async {
    try {
      _showMessage('Obtendo token (com validação automática de expiração)...');
      final token = await SessionAuthAuto.getToken();
      setState(() {
        _lastTokenObtained = token;
      });
      _showMessage('Token obtido com sucesso!');
    } catch (e) {
      _showMessage('Erro ao obter token: $e');
    }
  }

  Future<void> _handleManualRefresh() async {
    try {
      _showMessage('Forçando refresh manual...');
      await SessionAuthAuto.refresh();
      _showMessage('Refresh manual executado com sucesso!');
    } catch (e) {
      _showMessage('Erro no refresh manual: $e');
    }
  }

  Future<void> _handleLogout() async {
    try {
      await SessionAuthAuto.logout();
      setState(() {
        _lastTokenObtained = 'Nenhum token obtido ainda.';
      });
      _showMessage('Usuário deslogado.');
    } catch (e) {
      _showMessage('Erro no logout: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final isAuthenticated = SessionAuthAuto.isAuthenticated;
    final currentUser = SessionAuthAuto.currentUser;
    final nextRefresh = SessionAuthAuto.nextScheduledRefreshAt;
    final lastRefreshed = SessionAuthAuto.lastRefreshedAt;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'session_auth_auto Demo',
          style: TextStyle(fontWeight: FontWeight.bold, letterSpacing: 1.1),
        ),
        centerTitle: true,
        backgroundColor: colorScheme.background,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh_sharp),
            onPressed: _loadLogs,
            tooltip: 'Atualizar logs',
          )
        ],
      ),
      body: Container(
        color: colorScheme.background,
        child: Row(
          children: [
            // Lado Esquerdo - Painel de Controle e Formulários
            Expanded(
              flex: 3,
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Card de Status de Autenticação
                    Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16),
                          gradient: LinearGradient(
                            colors: isAuthenticated
                                ? [colorScheme.primary.withOpacity(0.15), colorScheme.secondary.withOpacity(0.15)]
                                : [Colors.red.withOpacity(0.1), Colors.orange.withOpacity(0.1)],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                        ),
                        padding: const EdgeInsets.all(20.0),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    Icon(
                                      isAuthenticated ? Icons.verified_user : Icons.lock_outline,
                                      color: isAuthenticated ? colorScheme.secondary : Colors.redAccent,
                                      size: 28,
                                    ),
                                    const SizedBox(width: 12),
                                    Text(
                                      isAuthenticated ? 'Sessão Ativa' : 'Sessão Inativa',
                                      style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                        color: isAuthenticated ? Colors.white : Colors.redAccent,
                                      ),
                                    ),
                                  ],
                                ),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                  decoration: BoxDecoration(
                                    color: isAuthenticated ? Colors.green.withOpacity(0.2) : Colors.red.withOpacity(0.2),
                                    borderRadius: BorderRadius.circular(12),
                                    border: Border.all(
                                      color: isAuthenticated ? Colors.green : Colors.red,
                                      width: 1,
                                    ),
                                  ),
                                  child: Text(
                                    isAuthenticated ? 'CONECTADO' : 'DESCONECTADO',
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                      color: isAuthenticated ? Colors.greenAccent : Colors.redAccent,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            if (isAuthenticated && currentUser != null) ...[
                              const Divider(height: 30),
                              _buildInfoRow('Nome:', currentUser.metadata['name'] ?? ''),
                              _buildInfoRow('Usuário/E-mail:', currentUser.credentials.username),
                              _buildInfoRow('Função:', currentUser.metadata['role'] ?? ''),
                              if (lastRefreshed != null)
                                _buildInfoRow('Último Refresh:', _formatTime(lastRefreshed)),
                              if (nextRefresh != null)
                                _buildInfoRow('Próximo Auto-Refresh:', _formatTime(nextRefresh)),
                            ],
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),

                    // Formulário de Login (se deslogado)
                    if (!isAuthenticated) ...[
                      Card(
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              const Text(
                                'Simular Credenciais de Login',
                                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(height: 16),
                              TextField(
                                controller: _usernameController,
                                decoration: const InputDecoration(
                                  labelText: 'Username',
                                  prefixIcon: Icon(Icons.person),
                                  border: OutlineInputBorder(),
                                ),
                              ),
                              const SizedBox(height: 12),
                              TextField(
                                controller: _passwordController,
                                obscureText: true,
                                decoration: const InputDecoration(
                                  labelText: 'Senha',
                                  prefixIcon: Icon(Icons.lock),
                                  border: OutlineInputBorder(),
                                ),
                              ),
                              const SizedBox(height: 16),
                              ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: colorScheme.primary,
                                  foregroundColor: Colors.white,
                                  padding: const EdgeInsets.symmetric(vertical: 16),
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                                ),
                                onPressed: _handleLogin,
                                child: const Text('Iniciar Sessão (setUser)', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ] else ...[
                      // Ações de Sessão Ativa
                      Card(
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              const Text(
                                'Ações de Sessão',
                                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(height: 16),
                              ElevatedButton.icon(
                                icon: const Icon(Icons.vpn_key),
                                label: const Text('Obter Token de Acesso (getToken)', style: TextStyle(fontWeight: FontWeight.bold)),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: colorScheme.secondary.withOpacity(0.2),
                                  foregroundColor: colorScheme.secondary,
                                  side: BorderSide(color: colorScheme.secondary),
                                  padding: const EdgeInsets.symmetric(vertical: 14),
                                ),
                                onPressed: _handleGetToken,
                              ),
                              const SizedBox(height: 12),
                              Row(
                                children: [
                                  Expanded(
                                    child: ElevatedButton.icon(
                                      icon: const Icon(Icons.sync),
                                      label: const Text('Forçar Refresh'),
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.white.withOpacity(0.05),
                                        foregroundColor: Colors.white,
                                        padding: const EdgeInsets.symmetric(vertical: 14),
                                      ),
                                      onPressed: _handleManualRefresh,
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: ElevatedButton.icon(
                                      icon: const Icon(Icons.logout),
                                      label: const Text('Deslogar (logout)'),
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.redAccent.withOpacity(0.1),
                                        foregroundColor: Colors.redAccent,
                                        side: const BorderSide(color: Colors.redAccent),
                                        padding: const EdgeInsets.symmetric(vertical: 14),
                                      ),
                                      onPressed: _handleLogout,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                    const SizedBox(height: 12),

                    // Card de Detalhes do Token
                    Card(
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            const Text(
                              'Último Token Obtido na Tela',
                              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 8),
                            Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: Colors.black.withOpacity(0.3),
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(color: Colors.white.withOpacity(0.1)),
                              ),
                              child: Text(
                                _lastTokenObtained,
                                style: const TextStyle(
                                  fontFamily: 'Courier',
                                  fontSize: 13,
                                  color: Colors.greenAccent,
                                ),
                              ),
                            ),
                            const SizedBox(height: 8),
                            const Text(
                              '* Dica: Como o token de mock expira em 15 segundos, clique em "Obter Token de Acesso" após 15s e observe no painel lateral de logs que a biblioteca renovará o token automaticamente (refresh reativo) antes de entregá-lo para a tela!',
                              style: TextStyle(fontSize: 12, color: Colors.grey, fontStyle: FontStyle.italic),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),

                    // Status geral
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: colorScheme.surface,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: colorScheme.primary.withOpacity(0.3)),
                      ),
                      child: Text(
                        'Status: $_statusMessage',
                        style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Lado Direito - Auditoria e Logs do SQLite
            Expanded(
              flex: 2,
              child: Container(
                decoration: BoxDecoration(
                  border: Border(
                    left: BorderSide(
                      color: Colors.white.withOpacity(0.1),
                      width: 1,
                    ),
                  ),
                  color: colorScheme.surface.withOpacity(0.5),
                ),
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Row(
                          children: [
                            Icon(Icons.list_alt, color: Colors.cyanAccent),
                            SizedBox(width: 8),
                            Text(
                              'Histórico de Refresh (Drift)',
                              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                        Text(
                          '${_logs.length} logs',
                          style: TextStyle(fontSize: 12, color: Colors.white.withOpacity(0.5)),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Expanded(
                      child: _logs.isEmpty
                          ? Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.history_toggle_off, size: 48, color: Colors.white.withOpacity(0.2)),
                                  const SizedBox(height: 8),
                                  Text(
                                    'Sem tentativas de refresh ainda.\nOs logs auditados pelo Drift aparecerão aqui.',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(color: Colors.white.withOpacity(0.4)),
                                  ),
                                ],
                              ),
                            )
                          : ListView.builder(
                              itemCount: _logs.length,
                              itemBuilder: (context, index) {
                                final log = _logs[index];
                                return Card(
                                  color: Colors.black.withOpacity(0.2),
                                  margin: const EdgeInsets.only(bottom: 8),
                                  child: ListTile(
                                    leading: Icon(
                                      log.success ? Icons.check_circle : Icons.error,
                                      color: log.success ? Colors.green : Colors.red,
                                    ),
                                    title: Text(
                                      'Trigger: ${log.triggeredBy.toUpperCase()}',
                                      style: const TextStyle(fontWeight: FontWeight.bold),
                                    ),
                                    subtitle: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        const SizedBox(height: 4),
                                        Text('Data/Hora: ${_formatTime(log.attemptedAt)}'),
                                        if (log.errorMessage != null) ...[
                                          const SizedBox(height: 4),
                                          Text(
                                            'Erro: ${log.errorMessage}',
                                            style: const TextStyle(color: Colors.redAccent, fontSize: 12),
                                          ),
                                        ]
                                      ],
                                    ),
                                  ),
                                );
                              },
                            ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 140,
            child: Text(
              label,
              style: TextStyle(
                fontWeight: FontWeight.w600,
                color: Colors.white.withOpacity(0.6),
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _formatTime(DateTime dateTime) {
    final localTime = dateTime.toLocal();
    final hour = localTime.hour.toString().padLeft(2, '0');
    final minute = localTime.minute.toString().padLeft(2, '0');
    final second = localTime.second.toString().padLeft(2, '0');
    return '$hour:$minute:$second';
  }
}
