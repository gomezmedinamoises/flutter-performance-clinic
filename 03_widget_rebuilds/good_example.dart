import 'package:flutter/material.dart';

class GoodRebuildsExample extends StatefulWidget {
  const GoodRebuildsExample({super.key});

  @override
  State<GoodRebuildsExample> createState() => _GoodRebuildsExampleState();
}

class _GoodRebuildsExampleState extends State<GoodRebuildsExample> {
  final ValueNotifier<Set<int>> _selected = ValueNotifier<Set<int>>({});
  final List<String> _filters = List<String>.generate(
    150,
    (index) => 'Chip #$index',
  );

  @override
  void dispose() {
    _selected.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        const Text(
          'Uses ValueListenableBuilder + keys so only the affected chip rebuilds. '
          'Const widgets keep the summary card stable.',
        ),
        const SizedBox(height: 16),
        ValueListenableBuilder<Set<int>>(
          valueListenable: _selected,
          builder: (context, selected, _) {
            return Wrap(
              spacing: 8,
              runSpacing: 8,
              children: List<Widget>.generate(_filters.length, (index) {
                return _SelectableChip(
                  key: ValueKey(index),
                  label: _filters[index],
                  selected: selected.contains(index),
                  onTap: () {
                    final next = Set<int>.from(selected);
                    if (next.contains(index)) {
                      next.remove(index);
                    } else {
                      next
                        ..clear()
                        ..add(index);
                    }
                    _selected.value = next;
                  },
                );
              }),
            );
          },
        ),
        const SizedBox(height: 24),
        ValueListenableBuilder<Set<int>>(
          valueListenable: _selected,
          builder: (context, selected, _) {
            final title = selected.isEmpty
                ? 'Tap a chip'
                : _filters[selected.first];
            return _SummaryCard(title: title);
          },
        ),
      ],
    );
  }
}

class _SelectableChip extends StatelessWidget {
  const _SelectableChip({
    super.key,
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return FilterChip(
      label: Text(label),
      selected: selected,
      onSelected: (_) => onTap(),
      selectedColor: Colors.green.shade200,
    );
  }
}

class _SummaryCard extends StatelessWidget {
  const _SummaryCard({required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 8),
            const Text('Only the chip row and this text rebuild.'),
          ],
        ),
      ),
    );
  }
}
