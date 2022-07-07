import 'package:flutter/material.dart';
import 'package:flutter_calendar_widget/flutter_calendar_widget.dart';
import 'package:get/get.dart';
import 'package:wecount/controllers/ledger_controller.dart';
import 'package:wecount/screens/ledger_item_edit.dart';
import 'package:wecount/screens/ledgers.dart';
import 'package:wecount/shared/home_header.dart' show HomeHeaderExpanded;
import 'package:wecount/utils/colors.dart';

class HomeCalendar extends StatefulWidget {
  const HomeCalendar({
    Key? key,
  }) : super(key: key);

  @override
  State<HomeCalendar> createState() => _HomeCalendarState();
}

class _HomeCalendarState extends State<HomeCalendar> {
  final LedgerController _ledgerController = Get.put(LedgerController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      body: Obx(
        () => CustomScrollView(
          slivers: <Widget>[
            HomeHeaderExpanded(
              title: _ledgerController.selectedLedger.value!.title,
              color: getColor(_ledgerController.selectedLedger.value!.color),
              actions: [
                IconButton(
                  onPressed: () => Get.to(
                    () => const Ledgers(),
                  ),
                  icon: const Icon(
                    Icons.book,
                    color: Colors.white,
                  ),
                ),
                IconButton(
                  onPressed: () => Get.to(
                    () => const LedgerItemEdit(),
                  ),
                  icon: const Icon(
                    Icons.add,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
            SliverList(
              delegate: SliverChildListDelegate(
                [
                  Column(
                    children: const <Widget>[
                      FlutterCalendar(),
                      Divider(
                        color: Colors.grey,
                        indent: 10,
                        endIndent: 10,
                      ),
                    ],
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
