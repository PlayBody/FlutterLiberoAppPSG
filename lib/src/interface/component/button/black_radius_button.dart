import 'package:flutter/material.dart';

class BlackRadiusButton extends StatelessWidget {
  final String label;
  final tapFunc;
  const BlackRadiusButton(
      {required this.label, required this.tapFunc, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: tapFunc,
      child: Text(label),
      style: ElevatedButton.styleFrom(
          padding: EdgeInsets.symmetric(vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(32.0),
          ),
          primary: Colors.black,
          onPrimary: Colors.white,
          textStyle: TextStyle(
              fontSize: 16, fontWeight: FontWeight.bold, letterSpacing: 2)),
    );
  }
}
