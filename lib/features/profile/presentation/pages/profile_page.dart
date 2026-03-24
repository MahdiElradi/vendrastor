import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/config/theme/app_theme.dart';
import '../../../../core/routing/app_router.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../auth/presentation/cubit/auth_cubit.dart';
import '../../../auth/presentation/cubit/auth_state.dart';
import '../../../../core/utils/url_launcher.dart';
import '../cubit/profile_cubit.dart';
import '../cubit/profile_state.dart';

/// Profile: name, email, avatar placeholder, edit, logout.
class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key, this.useScaffold = true});

  final bool useScaffold;

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage>
    with TickerProviderStateMixin {
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Ensure profile loads anytime profile screen is shown.
    context.read<ProfileCubit>().loadProfile();
  }

  late AnimationController _controller;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.1),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    final content = BlocListener<ProfileCubit, ProfileState>(
      listenWhen: (prev, curr) =>
          curr.errorMessage != null || curr.successMessage != null,
      listener: (context, state) {
        if (state.errorMessage != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.errorMessage!),
              backgroundColor: Theme.of(context).colorScheme.error,
            ),
          );
        }
        if (state.successMessage != null) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(state.successMessage!)));
        }
      },
      child: BlocListener<AuthCubit, AuthState>(
        listenWhen: (prev, curr) => curr is AuthUnauthenticated,
        listener: (context, _) {
          Navigator.of(
            context,
          ).pushNamedAndRemoveUntil(AppRouter.login, (route) => false);
        },
        child: Builder(
          builder: (context) {
            return BlocBuilder<ProfileCubit, ProfileState>(
              builder: (context, state) {
                if (state.isLoading && state.user == null) {
                  return const Center(child: CircularProgressIndicator());
                }
                final user = state.user;
                if (user == null) {
                  return const Center(child: Text(''));
                }
                return SingleChildScrollView(
                  padding: const EdgeInsets.all(AppSpacing.md),
                  child: SlideTransition(
                    position: _slideAnimation,
                    child: Column(
                      children: [
                        const SizedBox(height: AppSpacing.lg),
                        CircleAvatar(
                          radius: 48,
                          backgroundColor: Theme.of(
                            context,
                          ).colorScheme.primaryContainer,
                          child: Text(
                            (user.name?.isNotEmpty == true
                                    ? user.name!.substring(0, 1)
                                    : user.email.substring(0, 1))
                                .toUpperCase(),
                            style: Theme.of(context).textTheme.headlineMedium
                                ?.copyWith(
                                  color: Theme.of(
                                    context,
                                  ).colorScheme.onPrimaryContainer,
                                ),
                          ),
                        ),
                        const SizedBox(height: AppSpacing.lg),
                        Text(
                          user.name ?? user.email,
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                        const SizedBox(height: AppSpacing.xs),
                        Text(
                          user.email,
                          style: Theme.of(context).textTheme.bodyMedium
                              ?.copyWith(
                                color: Theme.of(
                                  context,
                                ).colorScheme.onSurfaceVariant,
                              ),
                        ),
                        const SizedBox(height: AppSpacing.lg),
                        Card(
                          margin: EdgeInsets.zero,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Column(
                            children: [
                              ListTile(
                                leading: const Icon(Icons.receipt_long),
                                title: Text(l10n.myOrders),
                                trailing: const Icon(Icons.chevron_right),
                                onTap: () => Navigator.pushNamed(
                                  context,
                                  AppRouter.orders,
                                ),
                              ),
                              const Divider(height: 1),
                              ListTile(
                                leading: const Icon(Icons.location_on),
                                title: Text(l10n.myAddresses),
                                trailing: const Icon(Icons.chevron_right),
                                onTap: () => Navigator.pushNamed(
                                  context,
                                  AppRouter.addresses,
                                ),
                              ),
                              const Divider(height: 1),
                              ListTile(
                                leading: const Icon(Icons.favorite_outline),
                                title: Text(l10n.wishlist),
                                trailing: const Icon(Icons.chevron_right),
                                onTap: () => Navigator.pushNamed(
                                  context,
                                  AppRouter.wishlist,
                                ),
                              ),
                              const Divider(height: 1),
                              ListTile(
                                leading: const Icon(Icons.privacy_tip_outlined),
                                title: Text(l10n.privacyPolicy),
                                trailing: const Icon(Icons.chevron_right),
                                onTap: () =>
                                    openUrl('https://example.com/privacy'),
                              ),
                              const Divider(height: 1),
                              ListTile(
                                leading: const Icon(Icons.description_outlined),
                                title: Text(l10n.termsAndConditions),
                                trailing: const Icon(Icons.chevron_right),
                                onTap: () =>
                                    openUrl('https://example.com/terms'),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: AppSpacing.lg),
                        OutlinedButton.icon(
                          onPressed: () =>
                              _showEditNameDialog(context, user.name),
                          icon: const Icon(Icons.edit_outlined),
                          label: Text(l10n.editProfile),
                        ),
                        const SizedBox(height: AppSpacing.lg),
                        SizedBox(
                          width: double.infinity,
                          child: FilledButton.icon(
                            onPressed: state.isUpdating
                                ? null
                                : () => _confirmLogout(context, l10n),
                            icon: state.isUpdating
                                ? const SizedBox(
                                    width: 20,
                                    height: 20,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                    ),
                                  )
                                : const Icon(Icons.logout),
                            label: Text(l10n.logout),
                          ),
                        ),
                        const SizedBox(height: AppSpacing.lg),
                        Card(
                          margin: EdgeInsets.zero,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(AppSpacing.md),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                Text(
                                  'Connect with us',
                                  style: Theme.of(context).textTheme.titleMedium
                                      ?.copyWith(fontWeight: FontWeight.bold),
                                ),
                                const SizedBox(height: AppSpacing.sm),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    _SocialIconButton(
                                      icon: Icons.facebook,
                                      label: 'Facebook',
                                      onTap: () => _showSocialDialog(
                                        context,
                                        title: 'Facebook',
                                        url:
                                            'https://www.facebook.com/vendrastor',
                                      ),
                                    ),
                                    _SocialIconButton(
                                      icon: Icons.camera_alt_outlined,
                                      label: 'Instagram',
                                      onTap: () => _showSocialDialog(
                                        context,
                                        title: 'Instagram',
                                        url:
                                            'https://www.instagram.com/vendrastor',
                                      ),
                                    ),
                                    _SocialIconButton(
                                      icon: Icons.alternate_email,
                                      label: 'Twitter',
                                      onTap: () => _showSocialDialog(
                                        context,
                                        title: 'Twitter',
                                        url:
                                            'https://www.twitter.com/vendrastor',
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: AppSpacing.sm),
                                Text(
                                  'About VendraStor',
                                  style: Theme.of(context).textTheme.titleMedium
                                      ?.copyWith(fontWeight: FontWeight.bold),
                                ),
                                const SizedBox(height: AppSpacing.xs),
                                Text(
                                  'VendraStor is a demo e-commerce app showcasing modern UI and clean architecture.\n\nVersion 1.0.0',
                                  style: Theme.of(context).textTheme.bodyMedium,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
    );

    return widget.useScaffold
        ? Scaffold(
            appBar: AppBar(
              title: Text(l10n.profile),
              actions: [
                IconButton(
                  icon: const Icon(Icons.settings_outlined),
                  onPressed: () =>
                      Navigator.pushNamed(context, AppRouter.settings),
                ),
              ],
            ),
            body: content,
          )
        : content;
  }

  void _showEditNameDialog(BuildContext context, String? currentName) {
    final controller = TextEditingController(text: currentName ?? '');
    final l10n = AppLocalizations.of(context)!;
    showDialog<void>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(l10n.editProfile),
        content: TextField(
          controller: controller,
          decoration: InputDecoration(
            labelText: l10n.name,
            border: const OutlineInputBorder(),
          ),
          autofocus: true,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            // child: Text(MaterialLocalizations.of(ctx).cancelButtonLabel),
            child: Text(MaterialLocalizations.of(ctx).cancelButtonLabel),
          ),
          FilledButton(
            onPressed: () {
              final name = controller.text.trim();
              if (name.isNotEmpty) {
                context.read<ProfileCubit>().updateProfile(name: name);
              }
              Navigator.pop(ctx);
            },
            child: Text(l10n.save),
          ),
        ],
      ),
    );
  }

  void _confirmLogout(BuildContext context, AppLocalizations l10n) {
    showDialog<void>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(l10n.logout),
        content: const Text('Are you sure you want to sign out?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(MaterialLocalizations.of(ctx).cancelButtonLabel),
          ),
          FilledButton(
            onPressed: () {
              Navigator.pop(ctx);
              context.read<ProfileCubit>().logout();
            },
            child: Text(l10n.logout),
          ),
        ],
      ),
    );
  }

  void _showSocialDialog(
    BuildContext context, {
    required String title,
    required String url,
  }) {
    showDialog<void>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(title),
        content: Text('Open $url in your browser?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(MaterialLocalizations.of(ctx).cancelButtonLabel),
          ),
          FilledButton(
            onPressed: () {
              Navigator.pop(ctx);
              openUrl(url);
            },
            child: const Text('Open'),
          ),
        ],
      ),
    );
  }
}

class _SocialIconButton extends StatelessWidget {
  const _SocialIconButton({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16),
          child: Container(
            padding: const EdgeInsets.all(AppSpacing.sm),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surfaceContainerHighest,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Icon(icon, size: 22),
          ),
        ),
        const SizedBox(height: AppSpacing.xs),
        Text(label, style: Theme.of(context).textTheme.labelSmall),
      ],
    );
  }
}
