import 'dart:math';

import 'package:flutter/material.dart';

class BadRebuildsExample extends StatefulWidget {
  const BadRebuildsExample({super.key});

  @override
  State<BadRebuildsExample> createState() => _BadRebuildsExampleState();
}

class _BadRebuildsExampleState extends State<BadRebuildsExample> {
  final random = Random();
  final List<String> _filters = List<String>.generate(
    150,
    (index) => 'Chip #$index',
  );
  int _selected = -1;

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        const Text(
          'Every tap calls setState on the entire screen. 150 chips + the summary '
          'card rebuild simultaneously causing jank.',
        ),
        const SizedBox(height: 16),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: _filters.map((label) {
            final index = _filters.indexOf(label);
            return _ExpensiveChip(
              label: label,
              index: index,
              selected: _selected == index,
              onTap: () {
                setState(() {
                  _selected = index;
                });
              },
            );
          }).toList(),
        ),
        const SizedBox(height: 24),
        _SummaryCard(
          title: _selected >= 0 ? _filters[_selected] : 'Tap a chip',
          value: random.nextDouble() * 100,
        ),
      ],
    );
  }
}

class _ExpensiveChip extends StatelessWidget {
  const _ExpensiveChip({
    required this.label,
    required this.index,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final int index;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final gradient = LinearGradient(
      colors: [
        Colors.blueGrey.shade200.withOpacity(selected ? 0.7 : 0.3),
        Colors.blueGrey.shade50.withOpacity(selected ? 0.7 : 0.3),
      ],
    );

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          gradient: gradient,
          borderRadius: BorderRadius.circular(32),
          border: Border.all(
            color: selected ? Colors.blue : Colors.blueGrey.shade200,
            width: 2,
          ),
          boxShadow: const [BoxShadow(blurRadius: 12, color: Colors.black12)],
        ),
        child: Text('[$index] $label'),
      ),
    );
  }
}

class _SummaryCard extends StatelessWidget {
  const _SummaryCard({required this.title, required this.value});
  final String title;
  final double value;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 12),
            Text('Random KPI ${(value).toStringAsFixed(2)}%'),
            const SizedBox(height: 8),
            LinearProgressIndicator(value: value / 100),
          ],
        ),
      ),
    );
  }
}
