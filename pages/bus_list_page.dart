import 'package:flutter/material.dart';

class BusListPage extends StatelessWidget {
  String destination;
  BusListPage({required this.destination});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Bus List"),
      ),
      body: Center(
        child: Text(destination),
      ),
    );
  }
}
