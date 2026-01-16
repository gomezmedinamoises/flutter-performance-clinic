import 'dart:async';

import 'package:flutter/material.dart';

class MemoryLeakExample extends StatefulWidget {
  const MemoryLeakExample({super.key});

  @override
  State<MemoryLeakExample> createState() => _MemoryLeakExampleState();
}

class _MemoryLeakExampleState extends State<MemoryLeakExample> {
  final stream = Stream<int>.periodic(const Duration(milliseconds: 300));
  final TextEditingController _controller = TextEditingController();
  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        const Text(
          'This screen intentionally forgets to clean up controllers, focus nodes '
          'and a long lived StreamSubscription. Navigate away repeatedly and '
          'watch memory climb.',
        ),
        const SizedBox(height: 16),
        TextField(
          controller: _controller,
          focusNode: _focusNode,
          decoration: const InputDecoration(labelText: 'Stream output'),
        ),
        const SizedBox(height: 24),
        FilledButton(
          onPressed: () {
            Navigator.of(context).push(
              MaterialPageRoute<void>(builder: (_) => const _ExtraScreen()),
            );
          },
          child: const Text('Push extra screen to leak more'),
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
      appBar: AppBar(title: const Text('Dummy screen')),
      body: const Center(child: Text('Pop me to create orphan subscriptions.')),
    );
  }
}
