import 'dart:async';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:nexust/ui/screens/home/home_screen.dart';

// SplashScreen con animación de escala y fundido antes de redirigir
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

// Usamos SingleTickerProviderStateMixin para proveer un Ticker al AnimationController
class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController
  _controller; // Controla la duración y repetición
  late final Animation<double> _scaleAnimation; // Animación de escala (pulso)
  late final Animation<double>
  _fadeAnimation; // Animación de opacidad (fade in/out)

  @override
  void initState() {
    super.initState();

    // Inicializa el controlador de animación con 1.5s de duración
    _controller = AnimationController(
      vsync: this, // Vincula el ticker al State
      duration: const Duration(milliseconds: 1500),
    );

    // Define Tween para la escala entre 0.8 y 1.2 con curva easeInOut
    _scaleAnimation = Tween<double>(
      begin: 0.8,
      end: 1.2,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));

    // Define Tween para la opacidad entre 0.0 y 1.0 con curva easeIn
    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeIn));

    // Repite la animación de forma inversa para crear efecto de pulso continuo
    _controller.repeat(reverse: true);

    // Temporizador de 3s antes de navegar a HomeScreen
    Timer(const Duration(seconds: 3), () {
      _controller.stop(); // Detiene la animación para liberar recursos
      context.goNamed(HomeScreen.routeName); // Redirige usando go_router
    });
  }

  @override
  void dispose() {
    _controller.dispose(); // Limpia el controlador para evitar fugas de memoria
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        // FadeTransition y ScaleTransition aplican las animaciones al logo
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: ScaleTransition(
            scale: _scaleAnimation,
            child: Image.asset(
              'assets/images/icon.png',
              width: 200,
              height: 200,
            ),
          ),
        ),
      ),
    );
  }
}
