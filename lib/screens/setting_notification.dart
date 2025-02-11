import 'package:flutter/material.dart';
import 'package:wecount/shared/header.dart';

import '../utils/localization.dart';
import '../utils/logger.dart';

class SettingNotification extends StatefulWidget {
  static const String name = '/setting_notification';

  const SettingNotification({Key? key}) : super(key: key);

  @override
  State<SettingNotification> createState() => _SettingNotificationState();
}

class _SettingNotificationState extends State<SettingNotification> {
  bool _addLedgerSwitch = false;
  bool _updateLedgerSwitch = false;

  void _onChangeAddingLedgerSwitch(bool value) {
    setState(() => _addLedgerSwitch = value);
    logger.d('value: $value');
  }

  void _onChangeUpdateLedgerSwitch(bool value) {
    setState(() => _updateLedgerSwitch = value);
    logger.d('value: $value');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      appBar: renderHeaderBack(
        centerTitle: false,
        context: context,
        iconColor: Theme.of(context).iconTheme.color,
        brightness: Theme.of(context).brightness,
        title: Text(
          t('NOTIFICATION'),
          style: TextStyle(
            fontSize: 20,
            color: Theme.of(context).textTheme.headline1!.color,
          ),
        ),
      ),
      body: SafeArea(
        child: ListView(
          cacheExtent: 120,
          children: <Widget>[
            Row(
              children: <Widget>[
                Container(
                  padding: const EdgeInsets.only(left: 40, right: 40, top: 44),
                  child: Text(
                    t('ADDING_LEDGER_ITEM'),
                    style: TextStyle(
                      fontSize: 16,
                      color: Theme.of(context).textTheme.headline1!.color,
                    ),
                  ),
                ),
              ],
            ),
            Row(
              children: <Widget>[
                Container(
                  padding: const EdgeInsets.only(left: 40, top: 16),
                  child: Switch(
                    value: _addLedgerSwitch,
                    onChanged: _onChangeAddingLedgerSwitch,
                    activeTrackColor: Theme.of(context).primaryColor,
                    activeColor: Theme.of(context).colorScheme.secondary,
                  ),
                ),
              ],
            ),
            Row(
              children: <Widget>[
                Container(
                  padding: const EdgeInsets.only(left: 40, right: 40, top: 44),
                  child: Text(
                    t('UPDATING_LEDGER_ITEM'),
                    style: TextStyle(
                      fontSize: 16,
                      color: Theme.of(context).textTheme.headline1!.color,
                    ),
                  ),
                ),
              ],
            ),
            Row(
              children: <Widget>[
                Container(
                  padding: const EdgeInsets.only(left: 40, top: 16),
                  child: Switch(
                    value: _updateLedgerSwitch,
                    onChanged: _onChangeUpdateLedgerSwitch,
                    activeTrackColor: Theme.of(context).primaryColor,
                    activeColor: Theme.of(context).colorScheme.secondary,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
