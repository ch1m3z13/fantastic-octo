import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/driver_stats_model.dart';
import '../repositories/driver_repository.dart';
import 'auth_provider.dart';

// 1. Dependency Injection for the Repository
final driverRepositoryProvider = Provider<DriverRepository>((ref) {
  final apiService = ref.watch(apiServiceProvider);
  final authRepository = ref.watch(authRepositoryProvider);
  return DriverRepository(apiService, authRepository);
});

// 2. State for the Driver Dashboard
class DriverDashboardState {
  final DriverStats stats;
  final bool isLoading;
  final String? errorMessage;

  const DriverDashboardState({
    required this.stats,
    this.isLoading = false,
    this.errorMessage,
  });

  factory DriverDashboardState.initial() => DriverDashboardState(
    stats: DriverStats.initial(),
  );

  DriverDashboardState copyWith({
    DriverStats? stats,
    bool? isLoading,
    String? errorMessage,
  }) {
    return DriverDashboardState(
      stats: stats ?? this.stats,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage,
    );
  }
}

// 3. The Notifier (Controller)
class DriverDashboardNotifier extends StateNotifier<DriverDashboardState> {
  final DriverRepository _repository;

  DriverDashboardNotifier(this._repository) : super(DriverDashboardState.initial()) {
    refreshStats();
  }

  Future<void> refreshStats() async {
    state = state.copyWith(isLoading: true, errorMessage: null);
    
    try {
      final stats = await _repository.getDriverStats();
      state = state.copyWith(
        isLoading: false,
        stats: stats,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: 'Failed to load dashboard data',
      );
    }
  }
}

// 4. The Main Provider consumed by the UI
final driverDashboardProvider = StateNotifierProvider<DriverDashboardNotifier, DriverDashboardState>((ref) {
  final repository = ref.watch(driverRepositoryProvider);
  return DriverDashboardNotifier(repository);
});