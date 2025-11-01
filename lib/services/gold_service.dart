import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/gold_price_model.dart';

class GoldService {
  // Replace with your key or inject via env / secure storage
  final String apiKey = "YOUR_GOLDAPI_KEY";
  final String url = "https://www.goldapi.io/api/XAU/INR";

  Future<GoldPriceModel?> fetchLatest() async {
    try {
      final res = await http.get(Uri.parse(url), headers: {
        "x-access-token": apiKey,
        "Content-Type": "application/json",
      });

      if (res.statusCode == 200) {
        final json = jsonDecode(res.body);
        final price = (json['price'] as num?)?.toDouble();
        return GoldPriceModel(pricePerOunce: price, timestamp: DateTime.now());
      } else {
        // Handle non-200
        return null;
      }
    } catch (e) {
      // log or throw
      return null;
    }
  }
}
