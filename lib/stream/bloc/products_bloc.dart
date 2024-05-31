
import 'dart:async';

const PRODUCTS = ['Microfono', 'Camara', 'Cable', 'Gafas'];
class ProductsBloc {

  ProductsBloc(){
    getProducts.listen((products) => _counterProducts.add(products.length));
  }

  Stream<List<String>> get getProducts async* {
    final List<String> products = [];
    for (var product in PRODUCTS) {
      await Future.delayed(const Duration(seconds: 2));
      products.add(product);
      yield products;
    } 
  } 

  final StreamController<int> _counterProducts = StreamController<int>();
  Stream<int> get productsCounter => _counterProducts.stream;

  void dispose() {
    _counterProducts.close();
  }
}