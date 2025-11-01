import 'dart:async';
import 'package:flutter/material.dart';
import '../models/gold_price_model.dart';
import '../services/gold_service.dart';

class GoldViewModel extends ChangeNotifier {
  final GoldService _service = GoldService();

  GoldPriceModel? _latest;
  GoldPriceModel? get latest => _latest;

  bool _loading = false;
  bool get loading => _loading;

  Timer? _timer;

  GoldViewModel() {
    _fetch();
    _timer = Timer.periodic(const Duration(seconds: 10), (_) => _fetch());
  }

  Future<void> _fetch() async {
    _loading = true;
    notifyListeners();
    final result = await _service.fetchLatest();
    if (result != null) {
      _latest = result;
    }
    _loading = false;
    notifyListeners();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}
