import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/foundation.dart';

class ConnectivityService {
  final Connectivity _connectivity = Connectivity();
  final StreamController<bool> _connectionStatusController =
      StreamController<bool>.broadcast();
  late StreamSubscription<List<ConnectivityResult>> _connectivitySubscription;
  bool _isOnline = true;

  // Constructor
  ConnectivityService() {
    // Inicializar suscripción
    _initConnectivity();
    _connectivitySubscription = _connectivity.onConnectivityChanged.listen(
      _updateConnectionStatus,
    );
  }

  // Stream para escuchar cambios en la conectividad
  Stream<bool> get connectionStatus => _connectionStatusController.stream;

  // Obtener el estado actual de la conexión
  bool get isOnline => _isOnline;

  // Inicializar conectividad
  Future<void> _initConnectivity() async {
    List<ConnectivityResult> result;
    try {
      result = await _connectivity.checkConnectivity();
    } catch (e) {
      debugPrint('Error al verificar la conectividad: $e');
      result = [ConnectivityResult.none];
    }
    return _updateConnectionStatus(result);
  }

  // Actualizar el estado de la conexión
  void _updateConnectionStatus(List<ConnectivityResult> results) {
    // Si al menos uno de los resultados no es 'none', consideramos que hay conexión
    _isOnline =
        !results.contains(ConnectivityResult.none) && results.isNotEmpty;
    _connectionStatusController.add(_isOnline);
  }

  // Verificar si hay conexión a internet
  Future<bool> checkConnectivity() async {
    final result = await _connectivity.checkConnectivity();
    _isOnline = !result.contains(ConnectivityResult.none) && result.isNotEmpty;
    return _isOnline;
  }

  // Limpiar recursos
  void dispose() {
    _connectivitySubscription.cancel();
    _connectionStatusController.close();
  }
}
