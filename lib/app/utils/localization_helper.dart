import 'package:flutter/material.dart';
import 'package:vlad_ai/l10n/generated/app_localizations.dart';

class LocalizationHelper {
  static String get(BuildContext context, String key) {
    final l10n = AppLocalizations.of(context)!;

    switch (key) {
      case 'help_about':
        return l10n.help_about;
      case 'help_about_answer':
        return l10n.help_about_answer;

      case 'help_support':
        return l10n.help_support;
      case 'help_support_answer':
        return l10n.help_support_answer;

      case 'help_accountInfo':
        return l10n.help_accountInfo;
      case 'help_accountInfo_answer':
        return l10n.help_accountInfo_answer;

      case 'help_tech':
        return l10n.help_tech;
      case 'help_tech_answer':
        return l10n.help_tech_answer;

      case 'help_privacySecurity':
        return l10n.help_privacySecurity;
      case 'help_privacySecurity_answer':
        return l10n.help_privacySecurity_answer;
      default:
        return key; // fallback for missing keys
    }
  }
}
