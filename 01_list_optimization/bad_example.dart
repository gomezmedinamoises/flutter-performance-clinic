import 'dart:math';

import 'package:flutter/material.dart';

/// Extremely inefficient scrolling list that rebuilds 10k rows on every frame.
class BadListExample extends StatefulWidget {
  const BadListExample({super.key});

  @override
  State<BadListExample> createState() => _BadListExampleState();
}

class _BadListExampleState extends State<BadListExample> {
  late final ScrollController _controller;
  double _lastOffset = 0;

  @override
  void initState() {
    super.initState();
    _controller = ScrollController()
      ..addListener(() {
        setState(() {
          _lastOffset = _controller.offset;
        });
      });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  List<Widget> _buildHeavyChildren() {
    final random = Random(_lastOffset.toInt());
    return List<Widget>.generate(10000, (index) {
      final color = Colors.primaries[index % Colors.primaries.length];
      final heavyString = _generatePayload(random, index);
      final imageUrl =
          'https://picsum.photos/seed/${random.nextInt(10000)}/160/160?nocache=${DateTime.now().millisecondsSinceEpoch}';
      final opacity = 0.4 + ((sin((_lastOffset + index) / 50) + 1) / 4);

      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Opacity(
          opacity: opacity,
          child: Container(
            decoration: BoxDecoration(
              color: color.withOpacity(0.15 + (random.nextDouble() * 0.3)),
              borderRadius: BorderRadius.circular(16),
              boxShadow: const [
                BoxShadow(blurRadius: 18, color: Colors.black26),
              ],
            ),
            child: Row(
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Heavy List Tile #$index',
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          heavyString,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 12),
                        LinearProgressIndicator(
                          value: (random.nextDouble() * index % 100) / 100,
                        ),
                      ],
                    ),
                  ),
                ),
                Image.network(
                  imageUrl,
                  width: 160,
                  height: 160,
                  fit: BoxFit.cover,
                ),
              ],
            ),
          ),
        ),
      );
    });
  }

  String _generatePayload(Random random, int seed) {
    final buffer = StringBuffer('Payload $seed: ');
    for (var i = 0; i < 200; i++) {
      buffer.write(random.nextInt(9999).toRadixString(16));
      buffer.write('-');
    }
    return buffer.toString();
  }

  @override
  Widget build(BuildContext context) {
    final children = _buildHeavyChildren();
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16),
          child: Text(
            'Forces rebuilds every scroll tick (offset: ${_lastOffset.toStringAsFixed(0)})',
            style: Theme.of(context).textTheme.bodySmall,
          ),
        ),
        Expanded(
          child: ListView(
            controller: _controller,
            cacheExtent: 0,
            physics: const BouncingScrollPhysics(),
            children: children,
          ),
        ),
      ],
    );
  }
}
