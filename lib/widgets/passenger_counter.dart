import 'package:flutter/material.dart';

class PassengerCounter extends StatelessWidget {
  final String label;
  final int count;
  final int? maxValue;
  final ValueChanged<int> onChanged;

  const PassengerCounter({
    super.key,
    required this.label,
    required this.count,
    required this.onChanged,
    this.maxValue,
  });

  @override
  Widget build(BuildContext context) {
    final bool canIncrement = maxValue == null || count < maxValue!;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: const TextStyle(fontSize: 16)),
        Row(
          children: [
            IconButton(
              icon: const Icon(Icons.remove_circle_outline),
              onPressed: () => onChanged(count - 1),
            ),
            Text(count.toString(), style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            IconButton(
              icon: const Icon(Icons.add_circle_outline),
              onPressed: canIncrement ? () => onChanged(count + 1) : null,
            ),
          ],
        ),
      ],
    );
  }
}
