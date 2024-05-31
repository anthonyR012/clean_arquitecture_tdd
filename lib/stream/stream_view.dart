
import 'package:flutter/material.dart';
import 'package:tdd_test/stream/bloc/products_bloc.dart';

class StreamExample extends StatefulWidget {
  const StreamExample({
    super.key,
  });


  @override
  State<StreamExample> createState() => _StreamExampleState();
}

class _StreamExampleState extends State<StreamExample> {
  final productsBloc = ProductsBloc();


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: StreamBuilder(
          builder: (context, snapshot) {
            int length = snapshot.data ?? 0;
            return Text('Contador: $length');
          },
          stream: productsBloc.productsCounter)),
      
      body: StreamBuilder(
        builder: (context, snapshot) {
          final products = snapshot.data;
          if (snapshot.connectionState == ConnectionState.waiting ||
              products == null) {
            return const Text('Cargando...');
          }
          return ListView.builder(
            itemCount: products.length,
            itemBuilder: (context, index) {
              return Text('Item ${products[index]}');
            },
          );
        },
        stream: productsBloc.getProducts,
      ),
    );
  }
}
