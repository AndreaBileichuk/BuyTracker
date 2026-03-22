import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final Function clickHandler;

  const CustomButton({
    super.key,
    required this.text,
    required this.clickHandler
  });

  @override
  Widget build(BuildContext context) {
     return Container(
      margin: EdgeInsets.fromLTRB(30, 30, 30, 0),
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Theme.of(context).colorScheme.primary, Theme.of(context).colorScheme.secondary],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
        borderRadius: BorderRadius.circular(12),
      ),
      child: ElevatedButton(
        onPressed: () {
          clickHandler();
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          padding: EdgeInsets.symmetric(vertical: 14),
        ),
        child: Text(
          text,
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w600,
            fontSize: 18,
          ),
        ),
      ),
    );
  }
}