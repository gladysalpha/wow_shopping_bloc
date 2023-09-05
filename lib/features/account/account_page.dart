import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wow_shopping/backend/backend.dart';
import 'package:wow_shopping/features/login/bloc/auth_bloc.dart';
import 'package:wow_shopping/features/login/login_screen.dart';
import 'package:wow_shopping/widgets/app_button.dart';
import 'package:wow_shopping/widgets/common.dart';

class AccountPage extends StatelessWidget {
  const AccountPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AuthBloc(authRepo: context.authRepo)
        ..add(AuthStatusSubscriptionRequested()),
      child: const AuthPageView(),
    );
  }
}

@immutable
class AuthPageView extends StatelessWidget {
  const AuthPageView({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox.expand(
      child: Material(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Text('Account'),
            verticalMargin48,
            verticalMargin48,
            BlocListener<AuthBloc, AuthState>(
              listener: (context, state) {
                if (state is AuthUnauthenticated) {
                  Navigator.pushAndRemoveUntil(
                      context, LoginScreen.route(), (route) => false);
                }
              },
              child: AppButton(
                onPressed: () =>
                    context.read<AuthBloc>().add(AuthLogoutRequested()),
                label: 'Logout',
              ),
            ),
          ],
        ),
      ),
    );
  }
}
