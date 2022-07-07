import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:wecount/controllers/user_controller.dart';
import 'package:wecount/utils/logger.dart';

import '../models/ledger_model.dart';

class LedgerController extends GetxController {
  static LedgerController get to => Get.find();
  final UserController _userController = Get.put(UserController());
  final _db = FirebaseFirestore.instance;
  final CollectionReference<LedgerModel> _ledgerRef = FirebaseFirestore.instance
      .collection('ledgers')
      .withConverter<LedgerModel>(
        fromFirestore: (snapshot, _) => LedgerModel.fromJson(
          snapshot.data(),
        ),
        toFirestore: (ledger, _) => ledger.toJson(),
      );

  Rxn<LedgerModel> selectedLedger = Rxn<LedgerModel>();

  Future<void> updateSelectedLedger(String ledgerId) async {
    DocumentSnapshot<LedgerModel> snapshot =
        await _ledgerRef.doc(ledgerId).get();
    logger.i(snapshot.data());

    if (snapshot.exists) {
      selectedLedger(snapshot.data());
    }
  }

  Future<void> createLedger(LedgerModel ledger) async {
    DocumentReference ledgerDocRef = await _ledgerRef.add(ledger);

    try {
      await _db.runTransaction((transaction) async {
        WriteBatch batch = _db.batch();

        for (String adminId in ledger.adminIds) {
          batch.set(
            ledgerDocRef.collection('admins').doc(adminId),
            {
              'id': adminId,
            },
          );
        }

        for (String memberId in ledger.memberIds) {
          batch.set(
            ledgerDocRef.collection('members').doc(memberId),
            {
              'id': memberId,
            },
          );
        }

        batch.set(
          _userController.userRef
              .doc(_userController.currentUser.uid)
              .collection('ledgers')
              .doc(ledgerDocRef.id),
          {
            'id': ledgerDocRef.id,
          },
        );

        batch.update(
          _userController.userRef.doc(_userController.currentUser.uid),
          {
            'selectedLedgerId': ledgerDocRef.id,
          },
        );

        await batch.commit();
      });
    } catch (e) {
      await ledgerDocRef.delete();

      rethrow;
    }
  }
}
