import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:meyor_lite/models/cost_model.dart';
import 'package:meyor_lite/services/local_database.dart';

class AppController extends ChangeNotifier {
  Future<String?> showCalendar(
    BuildContext context,
    DateTime? selectedDate,
    TextEditingController dateController,
  ) async {
    final DateTime? date = await showDatePicker(
      context: context,
      initialDate: selectedDate ?? DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
    );

    if (date != null) {
      final TimeOfDay? time = await showTimePicker(
        // ignore: use_build_context_synchronously
        context: context,
        initialTime: TimeOfDay.fromDateTime(selectedDate ?? DateTime.now()),
      );

      if (time != null) {
        final DateTime fullDateTime = DateTime(
          date.year,
          date.month,
          date.day,
          time.hour,
          time.minute,
        );
        selectedDate = fullDateTime;
        dateController.text = DateFormat(
          'yyyy-MM-dd HH:mm',
        ).format(fullDateTime);
        notifyListeners();
      }
    }
    return dateController.text;
  }

  final _localDatabase = LocalDatabase();
  List<CostModel> wallets = [];

  Future<void> getWallets() async {
    try {
      wallets = await _localDatabase.getData();
      notifyListeners();
    } catch (e) {
      print(e);
    }
  }

  Future<void> addWallet({
    required String title,
    required DateTime date,
    required double cost,
  }) async {
    try {
      final newWallet = CostModel(
        id: -1,
        costName: title,
        costDate: date,
        costPrice: cost,
      );
      final id = await _localDatabase.insert(newWallet);

      wallets.add(newWallet.copyWith(id: id));
      notifyListeners();
      print(id);
    } catch (e) {
      print(e);
    }
  }

  Future<void> editWallet(CostModel wallet) async {
    try {
      await _localDatabase.update(wallet);
      final currentIndex = wallets.indexWhere((t) => t.id == wallet.id);
      wallets[currentIndex] = wallet;
      notifyListeners();
    } catch (e) {
      print(e);
    }
  }

  Future<void> deleteWallet(int id) async {
    try {
      await _localDatabase.delete(id);
      wallets.removeWhere((t) => t.id == id);
      notifyListeners();
    } catch (e) {
      print(e);
    }
  }
}
