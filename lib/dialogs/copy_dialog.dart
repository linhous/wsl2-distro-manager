import 'package:localization/localization.dart';
import 'package:wsl2distromanager/components/analytics.dart';
import 'package:wsl2distromanager/components/api.dart';
import 'package:wsl2distromanager/dialogs/base_dialog.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:wsl2distromanager/components/helpers.dart';
import 'package:wsl2distromanager/components/constants.dart';

/// Copy Dialog
/// @param context: context
/// @param item: distro name
/// @param api: WSLApi
/// @param statusMsg: Function(String, {bool loading})
copyDialog(context, item, Function(String, {bool loading}) statusMsg) {
  WSLApi api = WSLApi();
  plausible.event(page: 'copy');
  dialog(
      context: context,
      item: item,
      statusMsg: statusMsg,
      title: '${'copy-text'.i18n()} \'$item\'',
      body: 'copyinstance-text'.i18n([distroLabel(item)]),
      submitText: 'copy-text'.i18n(),
      submitStyle: const ButtonStyle(),
      onSubmit: (inputText) async {
        if (inputText.length > 0) {
          statusMsg('copyinginstance-text'.i18n([item]), loading: true);
          await api.copy(item, inputText);
          // Copy settings
          String? startPath = prefs.getString('StartPath_' + item) ?? '';
          String? startName = prefs.getString('StartUser_' + item) ?? '';
          prefs.setString('StartPath_' + inputText, startPath);
          prefs.setString('StartUser_' + inputText, startName);
          // Save distro path
          prefs.setString('Path_' + inputText, defaultPath + inputText);
          statusMsg(
              'donecopyinginstance-text'.i18n([distroLabel(item), inputText]),
              loading: false);
        } else {
          statusMsg('errorentername-text'.i18n(), loading: false);
        }
      });
}
