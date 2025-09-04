import 'package:flutter/material.dart';

class SearchResultsCounterWidget extends StatelessWidget {
  final int resultsCount;
  final bool isVisible;

  const SearchResultsCounterWidget({
    Key? key,
    required this.resultsCount,
    this.isVisible = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (!isVisible) return const SizedBox.shrink();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Text(
        '$resultsCount result${resultsCount == 1 ? '' : 's'} found',
        style: TextStyle(
          fontSize: 14,
          color: Colors.grey.shade600,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}
