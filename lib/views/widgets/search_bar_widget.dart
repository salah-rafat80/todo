import 'package:flutter/material.dart';

class SearchBarWidget extends StatelessWidget {
  final TextEditingController controller;
  final Function(String) onChanged;
  final VoidCallback? onClear;
  final bool showClearButton;
  final String hintText;

  const SearchBarWidget({
    Key? key,
    required this.controller,
    required this.onChanged,
    this.onClear,
    this.showClearButton = false,
    this.hintText = 'Search...',
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFF5F5F5),
        borderRadius: BorderRadius.circular(12),
      ),
      child: TextField(
        controller: controller,
        onChanged: onChanged,
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: const TextStyle(color: Colors.grey),
          prefixIcon: const Icon(Icons.search, color: Colors.grey),
          suffixIcon: showClearButton && onClear != null
              ? IconButton(
                  icon: const Icon(Icons.clear, color: Colors.grey),
                  onPressed: onClear,
                )
              : null,
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 14,
          ),
        ),
        style: const TextStyle(fontSize: 16),
      ),
    );
  }
}
