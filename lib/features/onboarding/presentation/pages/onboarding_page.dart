import 'package:flutter/material.dart';

import '../../../../core/routing/app_router.dart';
import '../../../../core/di/injection_container.dart';
import '../../domain/usecases/complete_onboarding_usecase.dart';

/// Multi-page onboarding with skip/next/done.
class OnboardingPage extends StatefulWidget {
  const OnboardingPage({super.key});

  @override
  State<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {
  final PageController _controller = PageController();
  int _currentPage = 0;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  static final _pages = <_OnboardingStep>[
    _OnboardingStep(
      title: 'Welcome to VendraStor',
      description:
          'Browse beautiful products, add them to your cart, and checkout securely.',
      icon: Icons.shopping_bag_outlined,
    ),
    _OnboardingStep(
      title: 'Track Orders',
      description:
          'Review your orders, track delivery status, and manage your wishlist.',
      icon: Icons.local_shipping_outlined,
    ),
    _OnboardingStep(
      title: 'Fast & Secure',
      description:
          'Enjoy a fast checkout experience with secure payment options.',
      icon: Icons.lock_outline,
    ),
  ];

  void _goToNext() {
    if (_currentPage < _pages.length - 1) {
      _controller.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
      return;
    }
    _completeOnboarding();
  }

  Future<void> _completeOnboarding() async {
    await sl<CompleteOnboardingUseCase>().call();
    if (!mounted) return;
    Navigator.pushReplacementNamed(context, AppRouter.login);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: _completeOnboarding,
                  child: const Text('Skip'),
                ),
              ),
              Expanded(
                child: PageView.builder(
                  controller: _controller,
                  itemCount: _pages.length,
                  onPageChanged: (index) => setState(() {
                    _currentPage = index;
                  }),
                  itemBuilder: (context, index) {
                    final step = _pages[index];
                    return _OnboardingStepView(step: step);
                  },
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  _pages.length,
                  (index) => AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    width: _currentPage == index ? 24 : 10,
                    height: 10,
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.primary.withAlpha(
                        _currentPage == index ? 255 : (0.4 * 255).round(),
                      ),
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              FilledButton(
                onPressed: _goToNext,
                child: Text(
                  _currentPage == _pages.length - 1 ? 'Get Started' : 'Next',
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _OnboardingStep {
  const _OnboardingStep({
    required this.title,
    required this.description,
    required this.icon,
  });

  final String title;
  final String description;
  final IconData icon;
}

class _OnboardingStepView extends StatelessWidget {
  const _OnboardingStepView({required this.step});

  final _OnboardingStep step;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(step.icon, size: 96, color: Theme.of(context).colorScheme.primary),
        const SizedBox(height: 24),
        Text(
          step.title,
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.headlineSmall,
        ),
        const SizedBox(height: 12),
        Text(
          step.description,
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.bodyLarge,
        ),
      ],
    );
  }
}
