import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:salesandstockmanagement_app1/product.dart';

class ProductListScreen extends StatelessWidget {
  static const screenroute = 'productlist_screen';
  final _firestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.yellow[900],
        title: Text('Product List'),
      ),
      body: SafeArea(
        child: StreamBuilder<QuerySnapshot>(
          stream: _firestore.collection('product').snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return Center(
                child: CircularProgressIndicator(),
              );
            } else {
              final products = snapshot.data!.docs;
              return ListView.builder(
                itemCount: products.length,
                itemBuilder: (BuildContext context, int index) {
                  final productDoc = products[index];
                  final productID = productDoc.id;
                  final productbuyprice = productDoc.get('buyingprice');
                  final productselprice = productDoc.get('sellingprice');
                  final productname = productDoc.get('name');
                  final productqty = productDoc.get('quantity');

                  return ListTile(
                    title: Text('$productname'),
                    subtitle: Text('ID: $productID, Quantity: $productqty'),
                    trailing: IconButton(
                      icon: Icon(Icons.info),
                      onPressed: () {
                        Navigator.push(
    context,
    MaterialPageRoute(
        builder: (context) => Productdetailsscreen(
            productID: 'your_product_id_here',
            productbuyprice: 50,
            productname: 'Product Name',
            productqty: 100,
            productselprice: 70,
            productdescription:'aaa',
        ),
    ),
);
                      },
                    ),
                  );
                },
              );
            }
          },
        ),
      ),
    );
  }
}
