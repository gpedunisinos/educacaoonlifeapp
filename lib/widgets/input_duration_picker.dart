import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class InputDurationPicker extends StatefulWidget {
  final String label;
  final int initialMinutes;
  final ValueChanged<int>? onChanged;

  const InputDurationPicker({
    super.key,
    required this.label,
    this.initialMinutes = 0,
    this.onChanged,
  });

  @override
  State<InputDurationPicker> createState() => _InputDurationPickerState();
}

class _InputDurationPickerState extends State<InputDurationPicker> {
  late int _minutes;

  @override
  void initState() {
    super.initState();
    _minutes = widget.initialMinutes;
  }

  Future<void> _showDurationPicker(BuildContext context) async {
    final initialDuration = Duration(minutes: _minutes);

    await showModalBottomSheet(
      context: context,
      builder: (_) {
        return Container(
          height: 250,
          color: Colors.white,
          child: CupertinoTimerPicker(
            mode: CupertinoTimerPickerMode.hm,
            initialTimerDuration: initialDuration,
            onTimerDurationChanged: (Duration value) {
              setState(() {
                _minutes = value.inMinutes;
              });
            },
          ),
        );
      },
    );

    widget.onChanged?.call(_minutes);
  }

  @override
  Widget build(BuildContext context) {
    final hours = _minutes ~/ 60;
    final minutes = _minutes % 60;

    return GestureDetector(
      onTap: () => _showDurationPicker(context),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        decoration: BoxDecoration(
          color: const Color(0xfffbfbfb),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: const Color(0xFFf2f2f2)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              widget.label,
              style: const TextStyle(fontSize: 16, color: Colors.black87),
            ),
            Text(
              '$hours h $minutes min',
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}
