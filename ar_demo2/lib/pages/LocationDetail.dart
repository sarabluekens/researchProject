import 'package:ar_demo2/styles.dart';
import 'package:flutter/material.dart';

class LocationDetail extends StatelessWidget {
  const LocationDetail({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Demo flutter App'),
        shadowColor: Colors.red,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _section(
            'First',
            Colors.red,
          ),
          _section('Second', Colors.blue),
          _section('Third', Colors.green),
        ],
      ),
    );
  }

  Widget _section(String title, Color color) {
    return Container(
      decoration: BoxDecoration(
        color: color,
        borderRadius: const BorderRadius.all(Radius.circular(10)),
      ),
      padding: const EdgeInsets.all(16),
      child: Text(
        title,
        style: Styles.textDefault,
      ),
    );
  }
}
