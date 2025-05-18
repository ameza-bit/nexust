import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:nexust/presentation/blocs/auth/auth_cubit.dart';
import 'package:nexust/presentation/blocs/auth/auth_state.dart';
import 'package:nexust/presentation/widgets/common/primary_button.dart';

class HomeScreen extends StatelessWidget {
  static const String routeName = 'home';
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthCubit, AuthState>(
      listener: (context, state) {
        if (state.status == AuthStatus.unauthenticated) {
          context.go("/");
        }
      },
      child: Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            spacing: 24,
            children: [
              BlocBuilder<AuthCubit, AuthState>(
                builder: (context, state) {
                  if (state.status == AuthStatus.loading) {
                    return CircularProgressIndicator();
                  } else if (state.status == AuthStatus.error) {
                    return Text('Error: ${state.errorMessage}');
                  } else if (state.status == AuthStatus.authenticated) {
                    return Text('Welcome, ${state.user?.name}');
                  } else if (state.status == AuthStatus.unauthenticated) {
                    return Text('Please log in');
                  }

                  return Text('Home Screen');
                },
              ),
              PrimaryButton(
                text: 'Sign Out',
                fullWidth: false,
                onPressed: () => context.read<AuthCubit>().signOut(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
