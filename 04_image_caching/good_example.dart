import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class GoodImageCachingExample extends StatefulWidget {
  const GoodImageCachingExample({super.key});

  @override
  State<GoodImageCachingExample> createState() =>
      _GoodImageCachingExampleState();
}

class _GoodImageCachingExampleState extends State<GoodImageCachingExample> {
  final List<String> _urls = List<String>.generate(
    60,
    (index) => 'https://picsum.photos/id/${index + 10}/300/200',
  );

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      for (final url in _urls.take(6)) {
        precacheImage(CachedNetworkImageProvider(url), context);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.all(12),
      itemCount: _urls.length,
      itemBuilder: (context, index) {
        final imageUrl = _urls[index];
        return Card(
          margin: const EdgeInsets.symmetric(vertical: 8),
          child: Column(
            children: [
              CachedNetworkImage(
                imageUrl: imageUrl,
                fit: BoxFit.cover,
                width: double.infinity,
                progressIndicatorBuilder: (context, url, progress) {
                  return SizedBox(
                    height: 200,
                    child: Center(
                      child: CircularProgressIndicator(
                        value: progress.progress,
                      ),
                    ),
                  );
                },
                errorWidget: (context, url, error) => const SizedBox(
                  height: 200,
                  child: Center(child: Icon(Icons.broken_image)),
                ),
              ),
              ListTile(
                title: Text('Image ${index + 1}'),
                subtitle: const Text(
                  'cached_network_image + precacheImage prevents jank.',
                ),
                trailing: const Icon(Icons.check_circle, color: Colors.green),
              ),
            ],
          ),
        );
      },
    );
  }
}
