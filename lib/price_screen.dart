import 'dart:io' show Platform;

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'coin_data.dart';

class PriceScreen extends StatefulWidget {
  @override
  _PriceScreenState createState() => _PriceScreenState();
}

class _PriceScreenState extends State<PriceScreen> {
  String selectedCurrency = 'AUD';
  // String bitcoinValue = '?';
  Map<String, String> coinValues = {};
  bool isWaiting = false;

  // Create an Android Material dropdown list
  DropdownButton<String> androidDropdown() {
    // Define the dropdown list
    List<DropdownMenuItem<String>> dropdownItems = [];
    // Add items to the dropdown list
    for (String currency in currenciesList) {
      var newItem = DropdownMenuItem(
        child: Text(currency),
        value: currency,
      );
      dropdownItems.add(newItem);
    }
    // Return a DropdownButton object containing all items in the list
    return DropdownButton<String>(
      value: selectedCurrency, // A default value of the dropdown list
      items: dropdownItems,
      onChanged: (value) {
        setState(() {
          selectedCurrency = value;
          // print(selectedCurrency);
          getData();
        });
      },
    );
  }

  // Create the iOS Cupertino Picker
  CupertinoPicker iOSPicker() {
    // Define the list of items
    List<Text> pickerItems = [];
    // Add items to the dropdown list
    for (String currency in currenciesList) {
      pickerItems.add(Text(
        currency,
        style: TextStyle(color: Colors.white, fontWeight: FontWeight.w500),
      ));
    }
    // Return a CupertinoPicker object containing all items in the list
    return CupertinoPicker(
      backgroundColor: Color(0xFF3C4C79),
      itemExtent: 32.0,
      onSelectedItemChanged: (selectedIndex) {
        setState(() {
          selectedCurrency = currenciesList[selectedIndex];
          // print(selectedCurrency);
          getData();
        });
      },
      children: pickerItems,
    );
  }

  // Get data from API
  void getData() async {
    isWaiting = true;
    try {
      var data = await CoinData().getCoinData(selectedCurrency);
      isWaiting = false;
      setState(() {
        coinValues = data;
        // print(coinValues);
      });
    } catch (e) {
      print(e);
    }
  }

  @override
  void initState() {
    super.initState();
    getData();
  }

  // Make cards for all available cryptocurrencies
  Column makeCards() {
    // Define the list of crypto cards
    List<CryptoCard> cryptoCards = [];
    // Add cards to the list
    for (String crypto in cryptoList) {
      cryptoCards.add(
        CryptoCard(
          cryptoCurrency: crypto,
          bitcoinValue: isWaiting ? '?' : coinValues[crypto],
          selectedCurrency: selectedCurrency,
        ),
      );
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: cryptoCards,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF3C4C79),
        title: Text('🤑 Coin Ticker'),
      ),
      backgroundColor: Color(0xFF253356),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          makeCards(),
          Container(
            height: 150.0,
            alignment: Alignment.center,
            padding: EdgeInsets.only(bottom: 30.0),
            color: Color(0xFF3C4C79),
            child: Platform.isIOS ? iOSPicker() : androidDropdown(),
          ),
        ],
      ),
    );
  }
}

class CryptoCard extends StatelessWidget {
  // Constructor
  const CryptoCard({
    this.cryptoCurrency,
    this.bitcoinValue,
    this.selectedCurrency,
  });

  // Properties
  final String cryptoCurrency;
  final String bitcoinValue;
  final String selectedCurrency;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(18.0, 18.0, 18.0, 0),
      child: Card(
        color: Color(0xFF3C4C79),
        elevation: 5.0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 28.0),
          child: Text(
            '1 $cryptoCurrency = $bitcoinValue $selectedCurrency',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 20.0,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}
