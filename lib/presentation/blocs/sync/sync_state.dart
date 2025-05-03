import 'package:equatable/equatable.dart';

enum ConnectionStatus { online, offline }

enum SyncStatus { initial, syncing, synced, error }

class SyncState extends Equatable {
  final ConnectionStatus connectionStatus;
  final SyncStatus syncStatus;
  final DateTime? lastSyncTime;
  final String? errorMessage;

  const SyncState({
    required this.connectionStatus,
    required this.syncStatus,
    this.lastSyncTime,
    this.errorMessage,
  });

  factory SyncState.initial() {
    return const SyncState(
      connectionStatus: ConnectionStatus.online,
      syncStatus: SyncStatus.initial,
    );
  }

  SyncState copyWith({
    ConnectionStatus? connectionStatus,
    SyncStatus? syncStatus,
    DateTime? lastSyncTime,
    String? errorMessage,
  }) {
    return SyncState(
      connectionStatus: connectionStatus ?? this.connectionStatus,
      syncStatus: syncStatus ?? this.syncStatus,
      lastSyncTime: lastSyncTime ?? this.lastSyncTime,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [
    connectionStatus,
    syncStatus,
    lastSyncTime,
    errorMessage,
  ];
}
