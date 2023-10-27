// ignore_for_file: file_names, camel_case_types

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:salesandstockmanagement_app1/client.dart';

class clientscreen extends StatefulWidget {
  static const screenroute = 'Client_screen';

  const clientscreen({Key? key}) : super(key: key);

  @override
  State<clientscreen> createState() => _clientscreenState();
}

class _clientscreenState extends State<clientscreen> {
  final _firestore = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;
  late User signedInUser;
  String? client;
  int currentClientId = 0;
  late String searchKeyword; // الكلمة المستخدمة في البحث
  bool isSearching = false; // حالة التحقق من عملية البحث
  @override
  void initState() {
    super.initState();
    getCurrentUser();
    searchKeyword = ""; // تعيين الكلمة البحثية إلى قيمة فارغة عند بدء التشغيل
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

  List<String> _getProductsListFromStock() {
    List<String> productsList = [];
    _firestore.collection('product').get().then((snapshot) {
      for (var productDoc in snapshot.docs) {
        productsList.add(productDoc['name']);
      }
    });
    return productsList;
  }

  void searchClient(String name) {
    setState(() {
      isSearching = true;
      client = name;
    });
  }

  void deleteClient(String docId) {
    _firestore.collection('Clients').doc(docId).delete();
  }

  void updateClient(
      String docId, String newName, String newPhone, String newAddress) {
    _firestore.collection('Clients').doc(docId).update({
      'name': newName,
      'nbtelephone': newPhone,
      'adress': newAddress,
    });
  }

  List<Map<String, dynamic>> currentOrder = [];

  void addToOrder(String clientId, String productName, int quantity) {
    _firestore
        .collection('product')
        .where('name', isEqualTo: productName)
        .get()
        .then((snapshot) {
      if (snapshot.size > 0) {
        final productDoc = snapshot.docs.first;
        int currentQuantity = productDoc['quantity'] ?? 0;
        int newQuantity = currentQuantity - quantity;
        if (newQuantity >= 0) {
          Map<String, dynamic> productData = {
            'productName': productName,
            'quantity': quantity,
          };
          _firestore.collection('Orders').add({
            'clientId': clientId,
            'orderDate': DateTime.now().toString(),
            'products': [productData],
          }).then((value) {
            _firestore
                .collection('product')
                .doc(productDoc.id)
                .update({'quantity': newQuantity});
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: Text('Order Added'),
                  content: Text('Order has been added successfully.'),
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
          });
        } else {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text('Insufficient Quantity'),
                content: Text('The quantity in stock is not sufficient.'),
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
      } else {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Product Not Found'),
              content: Text('The product is not available in stock.'),
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

  void _updateProductQuantities() {
    for (var productData in currentOrder) {
      String productName = productData['productName'];
      int quantity = productData['quantity'];
      _firestore
          .collection('product')
          .where('name', isEqualTo: productName)
          .get()
          .then((snapshot) {
        if (snapshot.size > 0) {
          final productDoc = snapshot.docs.first;
          int currentQuantity = productDoc['quantity'] ?? 0;
          int newQuantity = currentQuantity - quantity;
          _firestore
              .collection('product')
              .doc(productDoc.id)
              .update({'quantity': newQuantity});
        }
      });
    }
    currentOrder.clear();
  }

  void saveOrderToDatabase(
      String clientId, List<Map<String, dynamic>> orderData) {
    _firestore.collection('Orders').add({
      'clientId': clientId,
      'orderDate': Timestamp.now(),
      'products': orderData,
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.yellow[900],
        title: Text('Clients'),
        actions: [
          IconButton(
            onPressed: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: Text('Search Client'),
                    content: TextField(
                      onChanged: (value) {
                        searchKeyword = value;
                      },
                      decoration: InputDecoration(
                        hintText: 'Enter client name...',
                      ),
                    ),
                    actions: [
                      ElevatedButton(
                        onPressed: () {
                          searchClient(searchKeyword);
                          Navigator.pop(context);
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
                  .collection('Clients')
                  .where('name', isEqualTo: client)
                  .snapshots()
              : _firestore.collection('Clients').snapshots(),
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
                  final clientDoc = messages[index];
                  final clientText = clientDoc.get('name');
                  final clientId = clientDoc.id;
                  String phoneNumber =
                      clientDoc.get('nbtelephone')?.toString() ?? '';
                  String address = clientDoc.get('adress')?.toString() ?? '';
                  final credit = clientDoc.get('credit') ?? 0;
                  final debit = clientDoc.get('debit') ?? 0;

                  return ListTile(
                    title: Text('$clientText'),
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
                                    TextEditingController(text: clientText);
                                TextEditingController nbTelephoneController =
                                    TextEditingController(text: phoneNumber);
                                TextEditingController addressController =
                                    TextEditingController(text: address);

                                return AlertDialog(
                                  title: Text('Update Client'),
                                  content: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      TextField(
                                        onChanged: (value) {
                                          setState(() {
                                            client = value;
                                          });
                                        },
                                        controller: nameController,
                                        decoration: InputDecoration(
                                          hintText: 'Enter new client name...',
                                        ),
                                      ),
                                      TextField(
                                        onChanged: (value) {
                                          setState(() {
                                            phoneNumber = value;
                                          });
                                        },
                                        controller: nbTelephoneController,
                                        decoration: InputDecoration(
                                          hintText:
                                              'Enter new client phone number...',
                                        ),
                                      ),
                                      TextField(
                                        onChanged: (value) {
                                          setState(() {
                                            address = value;
                                          });
                                        },
                                        controller: addressController,
                                        decoration: InputDecoration(
                                          hintText:
                                              'Enter new client address...',
                                        ),
                                      ),
                                    ],
                                  ),
                                  actions: [
                                    ElevatedButton(
                                      onPressed: () {
                                        updateClient(
                                            clientId,
                                            nameController.text,
                                            nbTelephoneController.text,
                                            addressController.text);
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
                                  title: Text('Delete Client?'),
                                  content: Text(
                                    'Are you sure you want to delete this client?',
                                  ),
                                  actions: [
                                    ElevatedButton(
                                      onPressed: () {
                                        deleteClient(clientId);
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
                          icon: Icon(Icons.shopping_cart),
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                List<String> productsList =
                                    _getProductsListFromStock();
                                String? selectedProduct;
                                int selectedQuantity = 0;

                                return StatefulBuilder(
                                  builder: (context, setState) {
                                    return AlertDialog(
                                      title: Text('Add Order'),
                                      content: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          DropdownButtonFormField<String>(
                                            value: selectedProduct,
                                            onChanged: (newValue) {
                                              setState(() {
                                                selectedProduct = newValue;
                                              });
                                            },
                                            items: productsList.map((product) {
                                              return DropdownMenuItem<String>(
                                                value: product,
                                                child: Text(product),
                                              );
                                            }).toList(),
                                            hint: Text('Select Product'),
                                            decoration: InputDecoration(
                                              hintText: 'Select Product',
                                            ),
                                          ),
                                          SizedBox(height: 16),
                                          TextField(
                                            onChanged: (value) {
                                              setState(() {
                                                selectedQuantity =
                                                    int.tryParse(value) ?? 0;
                                              });
                                            },
                                            keyboardType: TextInputType.number,
                                            decoration: InputDecoration(
                                              hintText: 'Enter Quantity',
                                            ),
                                          ),
                                        ],
                                      ),
                                      actions: [
                                        ElevatedButton(
                                          onPressed: () {
                                            if (selectedProduct != null &&
                                                selectedQuantity > 0) {
                                              addToOrder(
                                                  clientId,
                                                  selectedProduct!,
                                                  selectedQuantity);
                                              Navigator.pop(context);
                                            }
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
                            );
                          },
                        ),
                        IconButton(
                          icon: Icon(Icons.info),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ClientDetailsScreen(
                                  clientId: clientId,
                                  clientName: clientText,
                                  phoneNumber: phoneNumber,
                                  address: address,
                                  credit: credit,
                                  debit: debit,
                                ),
                              ),
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
              TextEditingController nameController = TextEditingController();
              TextEditingController nbTelephoneController =
                  TextEditingController();
              TextEditingController addressController = TextEditingController();

              return AlertDialog(
                title: Text('Add Client'),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      onChanged: (value) {
                        // Store the name value
                      },
                      controller: nameController,
                      decoration: InputDecoration(
                        hintText: 'Enter client name...',
                      ),
                    ),
                    TextField(
                      onChanged: (value) {
                        // Store the phone number
                      },
                      controller: nbTelephoneController,
                      decoration: InputDecoration(
                        hintText: 'Enter client phone number...',
                      ),
                    ),
                    TextField(
                      onChanged: (value) {
                        // Store the address
                      },
                      controller: addressController,
                      decoration: InputDecoration(
                        hintText: 'Enter client address...',
                      ),
                    ),
                  ],
                ),
                actions: [
                  ElevatedButton(
                    onPressed: () {
                      String name = nameController.text;
                      String phoneNumber = nbTelephoneController.text;
                      String address = addressController.text;

                      // Check for valid input
                      if (name.isNotEmpty &&
                          phoneNumber.isNotEmpty &&
                          address.isNotEmpty) {
                        _firestore.collection('Clients').add({
                          'name': name,
                          'nbtelephone': phoneNumber,
                          'adress': address,
                          'credit': 0.0,
                          'debit': 0.0,
                        });
                        Navigator.pop(context);
                      } else {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: Text('Missing Information'),
                              content: Text('Please fill in all the fields.'),
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
    );
  }
}
