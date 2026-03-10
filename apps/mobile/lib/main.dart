import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'blocs/auth/auth_bloc.dart';
import 'services/auth_service.dart';
import 'screens/login_screen.dart';

void main() {
  runApp(const E2EEChatApp());
}

class E2EEChatApp extends StatelessWidget {
  const E2EEChatApp({super.key});

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider(
      create: (context) => AuthService(),
      child: BlocProvider(
        create: (context) => AuthBloc(context.read<AuthService>())..add(AppStarted()),
        child: MaterialApp(
          title: 'E2EE Photography Chat',
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(
              seedColor: Colors.deepPurple,
              brightness: Brightness.dark,
            ),
            useMaterial3: true,
          ),
          home: const AuthWrapper(),
        ),
      ),
    );
  }
}

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        if (state is Authenticated) {
          return const HomeScreen();
        }
        return const LoginScreen();
      },
    );
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final state = context.read<AuthBloc>().state;
    String username = "Usuario";
    if (state is Authenticated) {
       username = state.username;
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('E2EE Chat'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              context.read<AuthBloc>().add(LogoutRequested());
            },
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Icon(Icons.lock_outline, size: 64, color: Colors.deepPurpleAccent),
            const SizedBox(height: 16),
            Text(
              '¡Hola, $username!',
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text('Bienvenido al Grupo de Fotografía'),
            const SizedBox(height: 8),
            const Text(
              'Máxima privacidad (E2EE) activada.',
              style: TextStyle(color: Colors.greenAccent),
            ),
          ],
        ),
      ),
    );
  }
}
