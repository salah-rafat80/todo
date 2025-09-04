import 'package:flutter/material.dart';

class DatePickerWidget extends StatelessWidget {
  final DateTime? selectedDate;
  final Function(DateTime) onDateSelected;
  final String label;

  const DatePickerWidget({
    Key? key,
    required this.selectedDate,
    required this.onDateSelected,
    this.label = 'Deadline',
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Icon(
          Icons.calendar_today_outlined,
          size: 20,
          color: Colors.grey,
        ),
        const SizedBox(width: 8),
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            color: Colors.grey,
            fontWeight: FontWeight.w500,
          ),
        ),
        const Spacer(),
        InkWell(
          onTap: () async {
            final DateTime? picked = await showDatePicker(
              context: context,
              initialDate: DateTime.now(),
              firstDate: DateTime.now(),
              lastDate: DateTime(2025),
            );
            if (picked != null) {
              onDateSelected(picked);
            }
          },
          child: Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 8,
            ),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey.shade300),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Row(
              children: [
                Text(
                  selectedDate != null
                      ? '${selectedDate!.month}/${selectedDate!.day}/${selectedDate!.year}'
                      : 'mm/dd/yyyy',
                  style: TextStyle(
                    fontSize: 14,
                    color: selectedDate != null
                        ? Colors.black87
                        : Colors.grey,
                  ),
                ),
                const SizedBox(width: 8),
                const Icon(
                  Icons.calendar_today_outlined,
                  size: 16,
                  color: Colors.grey,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
