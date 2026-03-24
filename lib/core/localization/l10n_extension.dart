import 'package:flutter/material.dart';

import 'package:vendrastor_app/l10n/app_localizations.dart';

/// Extension for convenient access to localized strings via [context.l10n].
extension L10nContext on BuildContext {
  AppLocalizations get l10n => AppLocalizations.of(this)!;
}
