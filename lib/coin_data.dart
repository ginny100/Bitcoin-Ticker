import 'dart:convert';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

const List<String> currenciesList = [
  'AUD',
  'BRL',
  'CAD',
  'CNY',
  'EUR',
  'GBP',
  'HKD',
  'IDR',
  'ILS',
  'INR',
  'JPY',
  'MXN',
  'NOK',
  'NZD',
  'PLN',
  'RON',
  'RUB',
  'SEK',
  'SGD',
  'USD',
  'ZAR'
];

const List<String> cryptoList = [
  'BTC',
  'ETH',
  'LTC',
];

const coinAPIURL = 'https://rest.coinapi.io/v1/exchangerate';
String apiKey = dotenv.env['API_KEY'];

class CoinData {
  // Get the coin data from coinapi.io
  Future getCoinData(String selectedCurrency) async {
    // Define a map storing prices of all cryptocurrencies
    Map<String, String> cryptoPrices = {};
    // Get price of each crypto
    for (String crypto in cryptoList) {
      // Update the URL to use the selected currency input
      String requestURL =
          '$coinAPIURL/$crypto/$selectedCurrency?apikey=' + apiKey;
      http.Response response = await http.get(Uri.parse(requestURL));
      // Check for the Status Code
      if (response.statusCode == 200) {
        var decodedData = jsonDecode(response.body);
        double price = decodedData['rate'];
        cryptoPrices[crypto] = price.toStringAsFixed(0);
      } else {
        print(response.statusCode);
        throw 'Problem with the get request';
      }
    }
    return cryptoPrices;
  }
}
