import 'package:flutter/material.dart';

class HeaderText extends StatelessWidget {
  final String title;
  final String subtitle;
  final Color titleColor;

  const HeaderText({
    super.key,
    required this.title,
    required this.subtitle,
    this.titleColor = const Color(0xFFFF6B00), 
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          title,
          style: TextStyle(
            color: titleColor,
            fontSize: 40,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          subtitle,
          style: const TextStyle(color: Colors.white60),
        ),
      ],
    );
  }
}
