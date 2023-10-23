import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:salesandstockmanagement_app1/product.dart';

class Stockscreen extends StatefulWidget {
  static const screenroute = 'stock_screen';

  const Stockscreen({Key? key, required String clientId}) : super(key: key);

  @override
  State<Stockscreen> createState() => _StockscreenState();
}

class _StockscreenState extends State<Stockscreen> {
  final _firestore = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;
  late User signedInUser;
  String? prod;
  List<Productdetailsscreen> selectedProducts = [];
  late String searchKeyword; // الكلمة المستخدمة في البحث
  bool isSearching = false; // حالة التحقق من عملية البحث
  @override
  void initState() {
    super.initState();
    getCurrentUser();
    searchKeyword = ""; // تعيين الكلمة البحثية إلى قيمة فارغة عند بدء التشغيل
  }

  void searchproduct(String name) {
    setState(() {
      isSearching = true;
      prod = name;
    });
  }

  void getCurrentUser() {
    try {
      final user = _auth.currentUser;
      if (user != null) {
        signedInUser = user;
        print(signedInUser.email);
      }
    } catch (e) {
      print(e);
    }
  }

  void clientStreams() async {
    await for (var snapshot in _firestore.collection('product').snapshots()) {
      for (var clientdata in snapshot.docs) {
        print(clientdata.data());
      }
    }
  }

  void deleteClient(String docId) {
    _firestore.collection('product').doc(docId).delete();
  }

  void updateProductDetails(String productId, String newName, int newQty,
      int newBuyPrice, int newSellPrice, String newDescription) {
    _firestore.collection('product').doc(productId).update({
      'name': newName,
      'quantity': newQty,
      'buyingprice': newBuyPrice,
      'sellingprice': newSellPrice,
      'description': newDescription, // تحديث وصف المنتج
    });
  }

  void addToOrder(Productdetailsscreen product, int quantity) {
    Productdetailsscreen existingProduct = selectedProducts.firstWhere(
      (element) => element.productID == product.productID,
      orElse: () => Productdetailsscreen(
        productID: product.productID,
        productname: product.productname,
        productbuyprice: product.productbuyprice,
        productselprice: product.productselprice,
        productqty: 0,
         productdescription: product.productdescription, 
      ),
    );

    setState(() {
    int totalQuantity = existingProduct.productqty + quantity;
    if (totalQuantity >= 0 && totalQuantity <= product.productqty) {
      existingProduct.productqty = totalQuantity;
    } else {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Invalid Quantity'),
            content: Text('The selected quantity is not valid.'),
            actions: [
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text('OK'),
              ),
            ],
          );
        },
      );
    }
  });
}
  void placeOrder() {
    print('Order Placed:');
    for (var product in selectedProducts) {
      print('${product.productname}: ${product.productqty}');
    }
    setState(() {
      selectedProducts.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.yellow[900],
        title: Text('Products'),
        actions: [
          IconButton(
            onPressed: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: Text('Search Product'),
                    content: TextField(
                      onChanged: (value) {
                        setState(() {
                          searchKeyword = value;
                        });
                      },
                      decoration: InputDecoration(
                        hintText: 'Enter product name...',
                      ),
                    ),
                    actions: [
                      ElevatedButton(
                        onPressed: () {
                          Navigator.pop(context);
                          searchproduct(searchKeyword);
                        },
                        child: Text('Search'),
                      ),
                    ],
                  );
                },
              );
            },
            icon: Icon(Icons.search),
          ),
        ],
      ),
      body: SafeArea(
        child: StreamBuilder<QuerySnapshot>(
          stream: isSearching
              ? _firestore
                  .collection('product')
                  .where('name', isEqualTo: prod)
                  .snapshots()
              : _firestore.collection('product').snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return Center(
                child: CircularProgressIndicator(),
              );
            } else {
              final messages = snapshot.data!.docs;
              return ListView.builder(
                itemCount: messages.length,
                itemBuilder: (BuildContext context, int index) {
                  final productDoc = messages[index];
                  final productID = productDoc.id;
                  final productbuyprice = productDoc.get('buyingprice');
                  final productselprice = productDoc.get('sellingprice');
                  final productname = productDoc.get('name');
                  final productqty = productDoc.get('quantity');
                  final productdescription = productDoc.get('description');
                  return ListTile(
                    title: Text('$productname'),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: Icon(Icons.edit),
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                TextEditingController nameController =
                                    TextEditingController(text: productname);
                                TextEditingController qtyController =
                                    TextEditingController(
                                        text: productqty.toString());
                                TextEditingController bpriceController =
                                    TextEditingController(
                                        text: productbuyprice.toString());
                                TextEditingController spriceController =
                                    TextEditingController(
                                        text: productselprice.toString());
                                TextEditingController
                                    descriptionController = // إضافة هنا
                                    TextEditingController(
                                        text:
                                            productdescription); // تعيين الوصف الحالي

                                return AlertDialog(
                                  title: Text('Update Product'),
                                  content: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      TextField(
                                        onChanged: (value) {
                                          // تخزين قيمة الاسم
                                        },
                                        controller: nameController,
                                        decoration: InputDecoration(
                                          hintText: 'Enter product name...',
                                        ),
                                      ),
                                      TextField(
                                        onChanged: (value) {
                                          // تخزين الكمية
                                        },
                                        controller: qtyController,
                                        decoration: InputDecoration(
                                          hintText:
                                              'Enter quantity of product...',
                                        ),
                                      ),
                                      TextField(
                                        onChanged: (value) {
                                          // تخزين سعر الشراء
                                        },
                                        controller: bpriceController,
                                        decoration: InputDecoration(
                                          hintText: 'Enter buying price...',
                                        ),
                                      ),
                                      TextField(
                                        onChanged: (value) {
                                          // تخزين سعر البيع
                                        },
                                        controller: spriceController,
                                        decoration: InputDecoration(
                                          hintText: 'Enter selling price...',
                                        ),
                                      ),
                                      TextField(
                                        // إضافة حقل الوصف هنا
                                        onChanged: (value) {
                                          // تخزين الوصف
                                        },
                                        controller: descriptionController,
                                        decoration: InputDecoration(
                                          hintText:
                                              'Enter product description...',
                                        ),
                                      ),
                                    ],
                                  ),
                                  actions: [
                                    ElevatedButton(
                                      onPressed: () {
                                        updateProductDetails(
                                          productID,
                                          nameController.text,
                                          int.parse(qtyController.text),
                                          int.parse(bpriceController.text),
                                          int.parse(spriceController.text),
                                          descriptionController
                                              .text, // إضافة الوصف هنا
                                        );
                                        Navigator.pop(context);
                                      },
                                      child: Text('Update'),
                                    ),
                                    ElevatedButton(
                                      onPressed: () {
                                        Navigator.pop(context);
                                      },
                                      child: Text('Cancel'),
                                    ),
                                  ],
                                );
                              },
                            );
                          },
                        ),
                        IconButton(
                          icon: Icon(Icons.delete),
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: Text('Delete Product?'),
                                  content: Text(
                                      'Are you sure you want to delete this product?'),
                                  actions: [
                                    ElevatedButton(
                                      onPressed: () {
                                        deleteClient(productID);
                                        Navigator.pop(context);
                                      },
                                      child: Text('Delete'),
                                      style: ElevatedButton.styleFrom(
                                        primary: Colors.red,
                                      ),
                                    ),
                                    ElevatedButton(
                                      onPressed: () {
                                        Navigator.pop(context);
                                      },
                                      child: Text('Cancel'),
                                    ),
                                  ],
                                );
                              },
                            );
                          },
                        ),
                        IconButton(
                          icon: Icon(Icons.info),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => Productdetailsscreen(
                                  productID: productID,
                                  productbuyprice: productbuyprice,
                                  productname: productname,
                                  productqty: int.parse(productqty.toString()),
                                  productselprice:
                                      int.parse(productselprice.toString()),
                                       productdescription: productdescription, 
                                ),
                              ),
                            );
                          },
                        ),
                        IconButton(
                          icon: Icon(Icons.shopping_cart),
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                String quantity = '1';

                                return AlertDialog(
                                  title: Text('Add to Order'),
                                  content: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text('Product Name: $productname'),
                                      TextField(
                                        keyboardType: TextInputType.number,
                                        onChanged: (value) {
                                          quantity = value;
                                        },
                                        decoration: InputDecoration(
                                          hintText: 'Enter quantity...',
                                        ),
                                      ),
                                    ],
                                  ),
                                  actions: [
                                    ElevatedButton(
                                      onPressed: () {
                                        addToOrder(
                                          Productdetailsscreen(
                                            productID: productID,
                                            productname: productname,
                                            productbuyprice: int.parse(
                                                productbuyprice.toString()),
                                            productselprice: int.parse(
                                                productselprice.toString()),
                                            productqty: int.parse(
                                                productqty.toString()),
                                                 productdescription: productdescription, 
                                          ),
                                          int.tryParse(quantity) ?? 0,
                                        );
                                        Navigator.pop(context);
                                      },
                                      child: Text('Add to Order'),
                                    ),
                                    ElevatedButton(
                                      onPressed: () {
                                        Navigator.pop(context);
                                      },
                                      child: Text('Cancel'),
                                    ),
                                  ],
                                );
                              },
                            );
                          },
                        ),
                      ],
                    ),
                  );
                },
              );
            }
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.orange,
        onPressed: () {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              TextEditingController idController = TextEditingController();
              TextEditingController nameController = TextEditingController();
              TextEditingController qtyController = TextEditingController();
              TextEditingController bpriceController = TextEditingController();
              TextEditingController spriceController = TextEditingController();
              TextEditingController descriptionController =
                  TextEditingController(); // إضافة وحقل للوصف

              return AlertDialog(
                title: Text('Add Product'),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      onChanged: (value) {
                        // تخزين قيمة المعرّف
                      },
                      controller: idController,
                      decoration: InputDecoration(
                        hintText: 'Enter product ID...',
                      ),
                    ),
                    TextField(
                      onChanged: (value) {
                        // تخزين قيمة الاسم
                      },
                      controller: nameController,
                      decoration: InputDecoration(
                        hintText: 'Enter product name...',
                      ),
                    ),
                    TextField(
                      onChanged: (value) {
                        // تخزين العنوان
                      },
                      controller: qtyController,
                      decoration: InputDecoration(
                        hintText: 'Enter quantity of product...',
                      ),
                    ),
                    TextField(
                      onChanged: (value) {
                        // تخزين الرصيد الائتماني
                      },
                      controller: bpriceController,
                      decoration: InputDecoration(
                        hintText: 'Enter buying price...',
                      ),
                    ),
                    TextField(
                      onChanged: (value) {
                        // تخزين الرصيد المدين
                      },
                      controller: spriceController,
                      decoration: InputDecoration(
                        hintText: 'Enter selling price...',
                      ),
                    ),
                    TextField(
                      onChanged: (value) {
                        // تخزين الوصف
                      },
                      controller: descriptionController,
                      decoration: InputDecoration(
                        hintText: 'Enter product description...',
                      ),
                    ),
                  ],
                ),
                actions: [
                  ElevatedButton(
                    onPressed: () {
                      _firestore.collection('product').add({
                        'id': idController.text, // إضافة المعرّف
                        'name': nameController.text,
                        'buyingprice': int.tryParse(bpriceController.text) ?? 0,
                        'sellingprice':
                            int.tryParse(spriceController.text) ?? 0,
                        'quantity': int.tryParse(qtyController.text) ?? 0,
                        'description':
                            descriptionController.text, // إضافة الوصف
                        'sender': signedInUser.email,
                      });
                      Navigator.pop(context);
                      clientStreams();
                    },
                    child: Text('Add'),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text('Cancel'),
                  ),
                ],
              );
            },
          );
        },
        child: Icon(Icons.add),
      ),
      bottomNavigationBar: selectedProducts.isNotEmpty
          ? BottomAppBar(
              child: ElevatedButton(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Text('Confirm Order'),
                        content: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            for (var product in selectedProducts)
                              Text(
                                '${product.productname}: ${product.productqty}',
                              ),
                          ],
                        ),
                        actions: [
                          ElevatedButton(
                            onPressed: () {
                              placeOrder();
                              Navigator.pop(context);
                            },
                            child: Text('Done'),
                          ),
                          ElevatedButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: Text('Cancel'),
                          ),
                        ],
                      );
                    },
                  );
                },
                child: Text('View Order (${selectedProducts.length})'),
              ),
            )
          : null,
    );
  }
}
