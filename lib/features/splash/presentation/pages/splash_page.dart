import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/widgets/app_logo.dart';
import '../../../../core/widgets/loading_spinner.dart';
import '../cubit/splash_cubit.dart';

/// Splash screen with app logo; navigation decided by SplashCubit.
class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();
    context.read<SplashCubit>().checkAuth();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<SplashCubit, SplashState>(
      listener: (context, state) {
        if (state.status == SplashStatus.loaded && state.route != null) {
          Navigator.of(context).pushReplacementNamed(state.route!);
        }
      },
      child: Scaffold(
        body: Stack(
          fit: StackFit.expand,
          children: [
            Image.asset(
              'assets/images/banners/pexels-the-glorious-studio-3584518-6716441.jpg',
              fit: BoxFit.cover,
            ),
            Container(
              color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.72),
            ),
            Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const VendraStorLogo(size: 96),
                  const SizedBox(height: 24),
                  const LoadingSpinner(size: 28, color: Colors.white),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
