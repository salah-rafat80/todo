import 'package:flutter/material.dart';

class WelcomeHeaderWidget extends StatelessWidget {
  final String title;
  final String subtitle;

  const WelcomeHeaderWidget({
    Key? key,
    required this.title,
    required this.subtitle,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Blue checkmark icon
        Container(
          width: 80,
          height: 80,
          decoration: const BoxDecoration(
            color: Color(0xFF4A90E2),
            shape: BoxShape.circle,
          ),
          child: const Icon(
            Icons.check,
            color: Colors.white,
            size: 50,
          ),
        ),
        const SizedBox(height: 40),

        // Welcome text
        Text(
          title,
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 8),

        // Subtitle
        Text(
          subtitle,
          style: const TextStyle(
            fontSize: 14,
            color: Colors.grey,
          ),
        ),
      ],
    );
  }
}
