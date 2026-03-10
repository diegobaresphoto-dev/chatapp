import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../../services/auth_service.dart';
import '../../services/signal_service.dart';
import '../../services/keys_service.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthService _authService;
  final _storage = const FlutterSecureStorage();

  AuthBloc(this._authService) : super(AuthInitial()) {
    on<AppStarted>(_onAppStarted);
    on<LoginRequested>(_onLoginRequested);
    on<RegisterRequested>(_onRegisterRequested);
    on<LogoutRequested>(_onLogoutRequested);
  }

  Future<void> _onAppStarted(AppStarted event, Emitter<AuthState> emit) async {
    final token = await _storage.read(key: 'token');
    final username = await _storage.read(key: 'username');
    if (token != null && username != null) {
      emit(Authenticated(token, username));
    } else {
      emit(Unauthenticated());
    }
  }

  Future<void> _onLoginRequested(LoginRequested event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      final response = await _authService.login(event.identifier, event.password);
      final token = response['access_token'];
      final username = response['user']['username'];
      
      await _storage.write(key: 'token', value: token);
      await _storage.write(key: 'username', value: username);
      
      emit(Authenticated(token, username));
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }

  Future<void> _onRegisterRequested(RegisterRequested event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      // 1. Register User
      final regResponse = await _authService.register(
        event.email, 
        event.username, 
        event.password, 
        event.inviteCode
      );
      
      final token = regResponse['access_token'];
      final username = regResponse['user']['username'];

      // 2. Generate E2EE Keys
      // For MVP, we use deviceId: 1. In production, this should be handled properly.
      final bundle = await SignalService.generatePreKeyBundle(1);
      
      // 3. Upload Keys
      final keysService = KeysService(token);
      await keysService.uploadKeys(bundle);

      // 4. Persist Auth State
      await _storage.write(key: 'token', value: token);
      await _storage.write(key: 'username', value: username);
      
      emit(Authenticated(token, username));
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }

  Future<void> _onLogoutRequested(LogoutRequested event, Emitter<AuthState> emit) async {
    await _storage.deleteAll();
    emit(Unauthenticated());
  }
}
