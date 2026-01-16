import 'package:flutter/material.dart';

class BadImageCachingExample extends StatefulWidget {
  const BadImageCachingExample({super.key});

  @override
  State<BadImageCachingExample> createState() => _BadImageCachingExampleState();
}

class _BadImageCachingExampleState extends State<BadImageCachingExample> {
  final List<String> _urls = List<String>.generate(
    60,
    (index) => 'https://picsum.photos/id/${index + 10}/300/200?nocache=$index',
  );

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.all(12),
      itemCount: _urls.length,
      itemBuilder: (context, index) {
        return Card(
          margin: const EdgeInsets.symmetric(vertical: 8),
          child: Column(
            children: [
              Image.network(
                _urls[index],
                fit: BoxFit.cover,
                loadingBuilder: (context, child, progress) {
                  if (progress == null) return child;
                  return SizedBox(
                    height: 200,
                    child: Center(
                      child: CircularProgressIndicator(
                        value: progress.expectedTotalBytes == null
                            ? null
                            : progress.cumulativeBytesLoaded /
                                  progress.expectedTotalBytes!,
                      ),
                    ),
                  );
                },
              ),
              ListTile(
                title: Text('Image ${index + 1}'),
                subtitle: const Text('Network image requested every rebuild.'),
              ),
            ],
          ),
        );
      },
    );
  }
}
