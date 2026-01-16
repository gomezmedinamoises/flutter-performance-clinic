import 'package:flutter/material.dart';

class OptimizedListExample extends StatefulWidget {
  const OptimizedListExample({super.key});

  @override
  State<OptimizedListExample> createState() => _OptimizedListExampleState();
}

class _OptimizedListExampleState extends State<OptimizedListExample>
    with AutomaticKeepAliveClientMixin {
  late final List<_ListItemData> _items;
  final ScrollController _controller = ScrollController();

  @override
  void initState() {
    super.initState();
    _items = List<_ListItemData>.generate(10000, (index) {
      return _ListItemData(
        id: index,
        title: 'Optimized Tile #$index',
        subtitle: 'Generated once during initState',
        progress: (index % 100) / 100,
      );
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scrollbar(
      controller: _controller,
      thumbVisibility: true,
      child: ListView.separated(
        controller: _controller,
        cacheExtent: 600,
        itemCount: _items.length,
        itemBuilder: (context, index) {
          return _ListTile(
            key: ValueKey(_items[index].id),
            data: _items[index],
          );
        },
        separatorBuilder: (_, __) => const Divider(height: 0),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}

class _ListItemData {
  const _ListItemData({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.progress,
  });

  final int id;
  final String title;
  final String subtitle;
  final double progress;
}

class _ListTile extends StatelessWidget {
  const _ListTile({super.key, required this.data});

  final _ListItemData data;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 88,
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: Colors.green.shade100,
          foregroundColor: Colors.green.shade800,
          child: Text('${data.id % 100}'),
        ),
        title: Text(data.title),
        subtitle: Text(data.subtitle),
        trailing: SizedBox(
          width: 72,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('${(data.progress * 100).toStringAsFixed(0)}%'),
              const SizedBox(height: 8),
              LinearProgressIndicator(value: data.progress),
            ],
          ),
        ),
      ),
    );
  }
}
