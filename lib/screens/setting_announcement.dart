import 'package:flutter/material.dart';

import 'package:wecount/shared/header.dart' show renderHeaderBack;

import '../utils/localization.dart';

// One entry in the multilevel list displayed by this app.
class Entry {
  Entry(this.title, [this.children = const <Entry>[]]);

  final String? title;
  final List<Entry> children;
}

class EntryItem extends StatelessWidget {
  const EntryItem(
    this.entry, {
    Key? key,
  }) : super(key: key);

  final Entry entry;

  Widget _buildTiles(Entry root) {
    if (root.children.isEmpty) return ListTile(title: Text(root.title!));
    return ExpansionTile(
      key: PageStorageKey<Entry>(root),
      title: Text(root.title ?? ''),
      children: root.children.map(_buildTiles).toList(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return _buildTiles(entry);
  }
}

class SettingAnnouncement extends StatelessWidget {
  static const String name = '/setting_announcement';

  const SettingAnnouncement({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final List<Entry> data = <Entry>[
      Entry(
        t('ANNOUNCEMENT_1'),
        <Entry>[Entry(t('ANNOUNCEMENT_TXT_1'))],
      ),
      Entry(
        t('ANNOUNCEMENT_2'),
        <Entry>[Entry(t('ANNOUNCEMENT_TXT_2'))],
      ),
    ];
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      appBar: renderHeaderBack(
        centerTitle: false,
        context: context,
        iconColor: Theme.of(context).iconTheme.color,
        brightness: Theme.of(context).brightness,
        title: Text(
          t('ANNOUNCEMENT'),
          style: TextStyle(
            fontSize: 20,
            color: Theme.of(context).textTheme.headline1!.color,
          ),
        ),
      ),
      body: ListView.builder(
        itemBuilder: (BuildContext context, int index) =>
            EntryItem(data[index]),
        itemCount: data.length,
      ),
    );
  }
}
