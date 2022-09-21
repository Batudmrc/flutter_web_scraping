// ignore_for_file: prefer_const_constructors, sort_child_properties_last, prefer_const_literals_to_create_immutables, unused_local_variable, avoid_print, unnecessary_string_interpolations

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:html/parser.dart' as parser;

import 'models/products.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData.dark(),
      debugShowCheckedModeBanner: false,
      home: const ProductList(),
    );
  }
}

class ProductList extends StatefulWidget {
  const ProductList({Key? key}) : super(key: key);

  @override
  State<ProductList> createState() => _ProductListState();
}

class _ProductListState extends State<ProductList> {
  var url = "https://www.mediamarkt.com.tr/tr/category/_laptop-504926.html";
  List<Laptops> laptops = [];
  Future getData() async {
    var res = await http.get(
      Uri.parse(url),
    );
    final body = res.body;
    final document = parser.parse(body);
    var response = document.getElementsByClassName('products-list')[0]
      ..getElementsByClassName('product-wrapper').forEach((element) {
        setState(() {
          laptops.add(Laptops(
              image: element.children[0].children[0].children[0].children[0]
                  .attributes["data-original"]
                  .toString(),
              title: element.children[0].children[0].children[0].children[0]
                  .attributes["alt"]
                  .toString(),
              price: element
                  .children[1].children[0].children[0].children[0].text));
        });
      });
  }

  @override
  void initState() {
    super.initState();
    getData();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text('Laptops'),
          centerTitle: true,
        ),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: GridView.builder(
              gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                  maxCrossAxisExtent: 200,
                  childAspectRatio: 2 / 2.9,
                  crossAxisSpacing: 20,
                  mainAxisSpacing: 20),
              itemCount: laptops.length,
              itemBuilder: (context, index) {
                return Container(
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(15)),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.network('https:${laptops[index].image}'),
                      Padding(
                        padding: const EdgeInsets.all(6.0),
                        child: Text(
                          maxLines: 4,
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.center,
                          laptops[index].title,
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 13,
                              fontWeight: FontWeight.w500),
                        ),
                      ),
                      SizedBox(height: 5),
                      Text(
                        "${laptops[index].price}TL",
                        textAlign: TextAlign.start,
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 20,
                            fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 20),
                      Padding(
                        padding: const EdgeInsets.only(left: 8),
                        child: Row(
                          children: [
                            SizedBox(width: 10),
                            Icon(
                              FontAwesomeIcons.truck,
                              color: Colors.green,
                              size: 15,
                            ),
                            SizedBox(width: 13),
                            Text(
                              'KARGO BEDAVA',
                              style: TextStyle(
                                  color: Colors.green,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                );
              }),
        ),
      ),
    );
  }
}
