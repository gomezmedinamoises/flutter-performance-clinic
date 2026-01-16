import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_performance_clinic/src/models/product.dart';
import 'package:http/http.dart' as http;
import 'package:transparent_image/transparent_image.dart';

class GoodNetworkListExample extends StatefulWidget {
  const GoodNetworkListExample({super.key});

  @override
  State<GoodNetworkListExample> createState() => _GoodNetworkListExampleState();
}

class _GoodNetworkListExampleState extends State<GoodNetworkListExample> {
  final List<Product> _items = [];
  final ScrollController _controller = ScrollController();
  bool _isLoading = false;
  bool _hasMore = true;
  int _skip = 0;

  @override
  void initState() {
    super.initState();
    _controller.addListener(_maybeLoadMore);
    _loadNextPage();
  }

  @override
  void dispose() {
    _controller
      ..removeListener(_maybeLoadMore)
      ..dispose();
    super.dispose();
  }

  Future<void> _loadNextPage({bool refresh = false}) async {
    if (_isLoading) return;
    setState(() => _isLoading = true);

    if (refresh) {
      _skip = 0;
      _items.clear();
      _hasMore = true;
    }

    final response = await http.get(
      Uri.parse('https://dummyjson.com/products?limit=20&skip=$_skip'),
    );
    final json = jsonDecode(response.body) as Map<String, dynamic>;
    final rawProducts = json['products'] as List<dynamic>;
    final newItems = rawProducts
        .map((raw) => Product.fromJson(raw as Map<String, dynamic>))
        .toList(growable: false);

    setState(() {
      _items.addAll(newItems);
      _skip += newItems.length;
      _hasMore = newItems.isNotEmpty && _skip < (json['total'] as int);
      _isLoading = false;
    });
  }

  void _maybeLoadMore() {
    if (_controller.position.pixels >=
            _controller.position.maxScrollExtent - 200 &&
        _hasMore &&
        !_isLoading) {
      _loadNextPage();
    }
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () => _loadNextPage(refresh: true),
      child: ListView.builder(
        controller: _controller,
        physics: const AlwaysScrollableScrollPhysics(),
        itemCount: _items.length + (_hasMore ? 1 : 0),
        itemBuilder: (context, index) {
          if (index >= _items.length) {
            return const Padding(
              padding: EdgeInsets.symmetric(vertical: 24),
              child: Center(child: CircularProgressIndicator()),
            );
          }
          final product = _items[index];
          return ListTile(
            key: ValueKey(product.id),
            leading: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: FadeInImage.memoryNetwork(
                placeholder: kTransparentImage,
                image: product.thumbnail,
                width: 64,
                height: 64,
                fit: BoxFit.cover,
              ),
            ),
            title: Text(product.title),
            subtitle: Text(
              product.description,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            trailing: Text('\$${product.price.toStringAsFixed(0)}'),
          );
        },
      ),
    );
  }
}
