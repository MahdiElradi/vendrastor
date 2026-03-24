// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/config/theme/app_theme.dart';
import '../../../../l10n/app_localizations.dart';
import '../cubit/settings_cubit.dart';
import '../cubit/settings_state.dart';

/// Settings: theme (light/dark/system), language (en/ar).
class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(title: Text(l10n.settings)),
      body: BlocBuilder<SettingsCubit, SettingsState>(
        builder: (context, state) {
          if (state.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          return AnimatedSwitcher(
            duration: const Duration(milliseconds: 200),
            child: ListView(
              key: ValueKey<String>('${state.themeMode}_${state.languageCode}'),
              padding: const EdgeInsets.symmetric(
                vertical: AppSpacing.md,
                horizontal: AppSpacing.md,
              ),
              children: [
                _SectionTitle(title: l10n.theme),
                const SizedBox(height: AppSpacing.sm),
                _ThemeModeTile(
                  value: state.themeMode,
                  onChanged: (v) =>
                      context.read<SettingsCubit>().setThemeMode(v),
                  lightLabel: l10n.light,
                  darkLabel: l10n.dark,
                  systemLabel: l10n.system,
                ),
                const SizedBox(height: AppSpacing.lg),
                _SectionTitle(title: l10n.language),
                const SizedBox(height: AppSpacing.sm),
                _LanguageTile(
                  currentCode: state.languageCode,
                  onSelect: (code) =>
                      context.read<SettingsCubit>().setLanguageCode(code),
                  enLabel: l10n.english,
                  arLabel: l10n.arabic,
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle({required this.title});
  final String title;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm),
      child: Text(
        title,
        style: Theme.of(context).textTheme.titleSmall?.copyWith(
          color: Theme.of(context).colorScheme.primary,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

class _ThemeModeTile extends StatefulWidget {
  const _ThemeModeTile({
    required this.value,
    required this.onChanged,
    required this.lightLabel,
    required this.darkLabel,
    required this.systemLabel,
  });
  final String value;
  final ValueChanged<String> onChanged;
  final String lightLabel;
  final String darkLabel;
  final String systemLabel;

  @override
  State<_ThemeModeTile> createState() => _ThemeModeTileState();
}

class _ThemeModeTileState extends State<_ThemeModeTile>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    _animation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeIn),
    );
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _animation,
      child: Card(
        child: Column(
        children: [
          RadioListTile<String>(
            title: Text(widget.lightLabel),
            value: 'light',
            groupValue: widget.value,
            onChanged: (_) => widget.onChanged('light'),
          ),
          RadioListTile<String>(
            title: Text(widget.darkLabel),
            value: 'dark',
            groupValue: widget.value,
            onChanged: (_) => widget.onChanged('dark'),
          ),
          RadioListTile<String>(
            title: Text(widget.systemLabel),
            value: 'system',
            groupValue: widget.value,
            onChanged: (_) => widget.onChanged('system'),
          ),
        ],
      ),
      ),
    );
  }
}

class _LanguageTile extends StatefulWidget {
  const _LanguageTile({
    required this.currentCode,
    required this.onSelect,
    required this.enLabel,
    required this.arLabel,
  });
  final String currentCode;
  final ValueChanged<String> onSelect;
  final String enLabel;
  final String arLabel;

  @override
  State<_LanguageTile> createState() => _LanguageTileState();
}

class _LanguageTileState extends State<_LanguageTile>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    _animation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeIn),
    );
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _animation,
      child: Card(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
          child: Column(
            children: [
              ListTile(
                title: Text(widget.enLabel),
                trailing: widget.currentCode == 'en'
                    ? Icon(
                        Icons.check,
                        color: Theme.of(context).colorScheme.primary,
                      )
                    : null,
                onTap: () => widget.onSelect('en'),
              ),
              const Divider(height: 1),
              ListTile(
                title: Text(widget.arLabel),
                trailing: widget.currentCode == 'ar'
                    ? Icon(
                        Icons.check,
                        color: Theme.of(context).colorScheme.primary,
                      )
                    : null,
                onTap: () => widget.onSelect('ar'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
