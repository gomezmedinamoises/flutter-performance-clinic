import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_performance_clinic/src/models/product.dart';
import 'package:http/http.dart' as http;

class BadNetworkListExample extends StatelessWidget {
  const BadNetworkListExample({super.key});

  Future<List<Product>> _fetchProducts() async {
    final response = await http.get(
      Uri.parse('https://dummyjson.com/products?limit=1000'),
    );
    final data = jsonDecode(response.body) as Map<String, dynamic>;
    final items = data['products'] as List<dynamic>;
    return items
        .map((raw) => Product.fromJson(raw as Map<String, dynamic>))
        .toList(growable: false);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Product>>(
      future: _fetchProducts(),
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return const Center(child: CircularProgressIndicator());
        }
        final products = snapshot.data ?? const [];
        return ListView(
          children: products.map((product) {
            return ListTile(
              title: Text(product.title),
              subtitle: Text(product.description),
              leading: Image.network(
                '${product.thumbnail}?cacheBust=${DateTime.now().millisecondsSinceEpoch}',
                width: 72,
                fit: BoxFit.cover,
              ),
              trailing: Text('\$${product.price.toStringAsFixed(0)}'),
            );
          }).toList(),
        );
      },
    );
  }
}
