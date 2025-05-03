import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nexust/data/services/connectivity_service.dart';
import 'package:nexust/presentation/blocs/sync/sync_state.dart';

class SyncCubit extends Cubit<SyncState> {
  final ConnectivityService _connectivityService;
  late StreamSubscription _connectivitySubscription;

  SyncCubit(this._connectivityService) : super(SyncState.initial()) {
    _init();
  }

  void _init() async {
    // Verificar el estado inicial de la conexión
    final isOnline = await _connectivityService.checkConnectivity();
    _updateConnectionStatus(isOnline);

    // Escuchar cambios de conectividad
    _connectivitySubscription = _connectivityService.connectionStatus.listen(
      _updateConnectionStatus,
    );
  }

  void _updateConnectionStatus(bool isOnline) {
    if (isOnline) {
      emit(state.copyWith(connectionStatus: ConnectionStatus.online));
    } else {
      emit(state.copyWith(connectionStatus: ConnectionStatus.offline));
    }
  }

  // Notificar que se ha iniciado una sincronización
  void startSync() {
    emit(state.copyWith(syncStatus: SyncStatus.syncing));
  }

  // Notificar que la sincronización ha finalizado con éxito
  void syncCompleted() {
    emit(
      state.copyWith(
        syncStatus: SyncStatus.synced,
        lastSyncTime: DateTime.now(),
      ),
    );
  }

  // Notificar que ha ocurrido un error durante la sincronización
  void syncError(String error) {
    emit(state.copyWith(syncStatus: SyncStatus.error, errorMessage: error));
  }

  // Forzar una sincronización manual
  Future<void> forceSynchronization() async {
    if (state.connectionStatus == ConnectionStatus.offline) {
      emit(
        state.copyWith(
          syncStatus: SyncStatus.error,
          errorMessage: 'No hay conexión a internet disponible',
        ),
      );
      return;
    }

    emit(state.copyWith(syncStatus: SyncStatus.syncing));

    // Aquí se podría implementar la lógica para forzar la sincronización
    // Por ejemplo, llamar a métodos específicos del repositorio

    // Simulamos un proceso de sincronización con un delay
    await Future.delayed(Duration(seconds: 2));

    emit(
      state.copyWith(
        syncStatus: SyncStatus.synced,
        lastSyncTime: DateTime.now(),
      ),
    );
  }

  @override
  Future<void> close() {
    _connectivitySubscription.cancel();
    return super.close();
  }
}
