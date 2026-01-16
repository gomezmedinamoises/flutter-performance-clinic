import 'dart:async';

import 'package:flutter/material.dart';

class FixedMemoryExample extends StatefulWidget {
  const FixedMemoryExample({super.key});

  @override
  State<FixedMemoryExample> createState() => _FixedMemoryExampleState();
}

class _FixedMemoryExampleState extends State<FixedMemoryExample> {
  late final StreamSubscription<int> _tickerSub;
  final _ticker = Stream<int>.periodic(const Duration(milliseconds: 300));
  final TextEditingController _controller = TextEditingController();
  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _tickerSub = _ticker.listen((event) {
      if (!mounted) return;
      _controller.text = 'Last tick: $event';
    });
  }

  @override
  void dispose() {
    _tickerSub.cancel();
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        const Text(
          'Controller, focus node and subscription are cleaned up in dispose().\n'
          'Use the memory tab in DevTools to confirm snapshots stay flat even '
          'after pushing/pop screens.',
        ),
        const SizedBox(height: 16),
        TextField(
          controller: _controller,
          focusNode: _focusNode,
          decoration: const InputDecoration(labelText: 'Stream output'),
        ),
        const SizedBox(height: 24),
        FilledButton.icon(
          onPressed: () {
            Navigator.of(context).push(
              MaterialPageRoute<void>(builder: (_) => const _ExtraScreen()),
            );
          },
          icon: const Icon(Icons.memory),
          label: const Text('Navigate safely'),
        ),
      ],
    );
  }
}

class _ExtraScreen extends StatelessWidget {
  const _ExtraScreen();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Proper lifecycle')),
      body: const Center(child: Text('Dispose runs when this screen pops.')),
    );
  }
}
