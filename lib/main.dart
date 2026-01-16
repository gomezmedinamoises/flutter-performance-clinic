import 'package:flutter/material.dart';

import 'package:flutter_performance_clinic/01_list_optimization/bad_example.dart';
import 'package:flutter_performance_clinic/01_list_optimization/good_example.dart';
import 'package:flutter_performance_clinic/02_memory_leaks/fixed_example.dart';
import 'package:flutter_performance_clinic/02_memory_leaks/leak_example.dart';
import 'package:flutter_performance_clinic/03_widget_rebuilds/bad_example.dart';
import 'package:flutter_performance_clinic/03_widget_rebuilds/good_example.dart';
import 'package:flutter_performance_clinic/04_image_caching/bad_example.dart';
import 'package:flutter_performance_clinic/04_image_caching/good_example.dart';
import 'package:flutter_performance_clinic/05_network_lists/bad_example.dart';
import 'package:flutter_performance_clinic/05_network_lists/good_example.dart';

void main() {
  runApp(const PerformanceClinicApp());
}

class PerformanceClinicApp extends StatelessWidget {
  const PerformanceClinicApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Performance Clinic',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),
        useMaterial3: true,
      ),
      home: const DemoHomePage(),
    );
  }
}

class DemoHomePage extends StatelessWidget {
  const DemoHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Flutter Performance Clinic'),
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 16),
            child: Icon(Icons.monitor_heart),
          ),
        ],
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: demos.length,
        itemBuilder: (context, index) {
          final scenario = demos[index];
          return Card(
            margin: const EdgeInsets.symmetric(vertical: 8),
            child: ListTile(
              title: Text(scenario.title),
              subtitle: Text(scenario.description),
              trailing: Chip(label: Text(scenario.metricHighlight)),
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute<void>(
                    builder: (_) => ScenarioDetailPage(scenario: scenario),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}

class ScenarioDetailPage extends StatelessWidget {
  const ScenarioDetailPage({super.key, required this.scenario});

  final DemoScenario scenario;

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text(scenario.title),
          bottom: const TabBar(
            tabs: [
              Tab(text: 'Bad example'),
              Tab(text: 'Optimized'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            _ScenarioPane(
              scenario: scenario,
              builder: scenario.badBuilder,
              isBad: true,
            ),
            _ScenarioPane(
              scenario: scenario,
              builder: scenario.goodBuilder,
              isBad: false,
            ),
          ],
        ),
      ),
    );
  }
}

class _ScenarioPane extends StatelessWidget {
  const _ScenarioPane({
    required this.scenario,
    required this.builder,
    required this.isBad,
  });

  final DemoScenario scenario;
  final WidgetBuilder builder;
  final bool isBad;

  @override
  Widget build(BuildContext context) {
    final statusColor = isBad ? Colors.red.shade400 : Colors.green.shade400;
    final statusLabel = isBad ? 'Janky / problematic' : 'Smooth / fixed';

    return Column(
      children: [
        Material(
          color: statusColor.withOpacity(0.12),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      isBad ? Icons.warning_amber : Icons.check_circle,
                      color: statusColor,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      statusLabel,
                      style: Theme.of(
                        context,
                      ).textTheme.titleMedium?.copyWith(color: statusColor),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Text(scenario.description),
                const SizedBox(height: 12),
                Wrap(
                  spacing: 8,
                  children: scenario.devToolsFocus
                      .map(
                        (focus) => Chip(
                          label: Text(focus),
                          avatar: const Icon(Icons.speed, size: 16),
                        ),
                      )
                      .toList(),
                ),
                const SizedBox(height: 8),
                Text(
                  'Docs: ${scenario.docsPath}',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
            ),
          ),
        ),
        const Divider(height: 0),
        Expanded(child: builder(context)),
      ],
    );
  }
}

class DemoScenario {
  const DemoScenario({
    required this.id,
    required this.title,
    required this.description,
    required this.metricHighlight,
    required this.docsPath,
    required this.devToolsFocus,
    required this.badBuilder,
    required this.goodBuilder,
  });

  final String id;
  final String title;
  final String description;
  final String metricHighlight;
  final String docsPath;
  final List<String> devToolsFocus;
  final WidgetBuilder badBuilder;
  final WidgetBuilder goodBuilder;
}

final List<DemoScenario> demos = [
  DemoScenario(
    id: 'list-optimization',
    title: 'List w/ 10k rows',
    description: 'Eager ListView vs lazy ListView.builder with caching.',
    metricHighlight: '45ms -> 8ms',
    docsPath: '01_list_optimization/README.md',
    devToolsFocus: const ['Frame chart', 'Raster stats'],
    badBuilder: (_) => const BadListExample(),
    goodBuilder: (_) => const OptimizedListExample(),
  ),
  DemoScenario(
    id: 'memory-leaks',
    title: 'Leaking StreamSubscription',
    description: 'Forgets to cancel controllers vs proper dispose().',
    metricHighlight: '80MB -> 32MB',
    docsPath: '02_memory_leaks/README.md',
    devToolsFocus: const ['Memory timeline', 'Snapshot diff'],
    badBuilder: (_) => const MemoryLeakExample(),
    goodBuilder: (_) => const FixedMemoryExample(),
  ),
  DemoScenario(
    id: 'widget-rebuilds',
    title: 'Unnecessary rebuilds',
    description: '150 chips rebuild vs ValueListenable/const widgets.',
    metricHighlight: 'Rebuilds 150 -> 1',
    docsPath: '03_widget_rebuilds/README.md',
    devToolsFocus: const ['Rebuild profiler', 'Widget rebuild stats'],
    badBuilder: (_) => const BadRebuildsExample(),
    goodBuilder: (_) => const GoodRebuildsExample(),
  ),
  DemoScenario(
    id: 'image-caching',
    title: 'Image caching / precache',
    description: 'Repeated network fetch vs cached_network_image.',
    metricHighlight: 'Bandwidth ↓ 78%',
    docsPath: '04_image_caching/README.md',
    devToolsFocus: const ['Network tab', 'Raster spikes'],
    badBuilder: (_) => const BadImageCachingExample(),
    goodBuilder: (_) => const GoodImageCachingExample(),
  ),
  DemoScenario(
    id: 'network-pagination',
    title: 'Network pagination',
    description: 'One giant request vs incremental paging + caching.',
    metricHighlight: 'Load time 4.2s -> 620ms',
    docsPath: '05_network_lists/README.md',
    devToolsFocus: const ['CPU profile', 'Network timeline'],
    badBuilder: (_) => const BadNetworkListExample(),
    goodBuilder: (_) => const GoodNetworkListExample(),
  ),
];
