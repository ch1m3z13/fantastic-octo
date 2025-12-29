import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../api/api_service.dart';
import '../models/user_model.dart';
import '../repositories/auth_repository.dart';

// State class
class AuthState {
  final String? token;
  final UserData? user;
  final String? role;
  final bool isLoading;
  final String? errorMessage;

  const AuthState({
    this.token,
    this.user,
    this.role,
    this.isLoading = false,
    this.errorMessage,
  });

  AuthState copyWith({
    String? token,
    UserData? user,
    String? role,
    bool? isLoading,
    String? errorMessage,
  }) {
    return AuthState(
      token: token ?? this.token,
      user: user ?? this.user,
      role: role ?? this.role,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage,
    );
  }

  bool get isAuthenticated => token != null && user != null;
  bool get isDriver => user?.roles == 'DRIVER';
}

// Auth Notifier
class AuthNotifier extends StateNotifier<AuthState> {
  final AuthRepository _repository;

  AuthNotifier(this._repository) : super(const AuthState()) {
    _loadAuthState();
  }

  Future<void> _loadAuthState() async {
    try {
      final token = await _repository.getToken();
      if (token != null) {
        final user = await _repository.getStoredUser();
        if (user != null) {
          state = AuthState(
            token: token,
            user: user,
            role: user.roles,
          );
        }
      }
    } catch (e) {
      state = const AuthState();
    }
  }

  Future<bool> register(RegisterUserDTO dto) async {
    state = state.copyWith(isLoading: true, errorMessage: null);

    try {
      final response = await _repository.register(dto);
      state = AuthState(
        token: response.token,
        user: response.user,
        role: response.user.roles,
        isLoading: false,
      );
      return true;
    } on ApiException catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: e.message,
      );
      return false;
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: 'An unexpected error occurred',
      );
      return false;
    }
  }

  Future<bool> login(LoginDTO dto) async {
    state = state.copyWith(isLoading: true, errorMessage: null);

    try {
      final response = await _repository.login(dto);
      state = AuthState(
        token: response.token,
        user: response.user,
        role: response.user.roles,
        isLoading: false,
      );
      return true;
    } on ApiException catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: e.message,
      );
      return false;
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: 'An unexpected error occurred',
      );
      return false;
    }
  }

  Future<void> logout() async {
    await _repository.logout();
    state = const AuthState();
  }

  void clearError() {
    state = state.copyWith(errorMessage: null);
  }
}

// Providers
final apiServiceProvider = Provider<ApiService>((ref) => ApiService());

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  final apiService = ref.watch(apiServiceProvider);
  return AuthRepository(apiService);
});

final authProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  final repository = ref.watch(authRepositoryProvider);
  return AuthNotifier(repository);
});