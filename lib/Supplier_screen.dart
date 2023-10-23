import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:salesandstockmanagement_app1/spplier.dart';


class SupplierScreen extends StatefulWidget {
  static const screenroute = 'Supplier_screen';
  const SupplierScreen({super.key});

  @override
  State<SupplierScreen> createState() => _SupplierScreenState();
}

class _SupplierScreenState extends State<SupplierScreen> {
  final _firestore = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;
  late User signedInUser;
  String? supplier;
 late String searchKeyword; // الكلمة المستخدمة في البحث
  bool isSearching = false; // حالة التحقق من عملية البحث
  @override
  void initState() {
    super.initState();
    getCurrentUser();
    searchKeyword = ""; // تعيين الكلمة البحثية إلى قيمة فارغة عند بدء التشغيل
  }
void searchsupplier(String name) {
    setState(() {
      isSearching = true;
      supplier = name;
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

  void supplierStreams() async {
    await for (var snapshot in _firestore.collection('supplier').snapshots()) {
      for (var clientdata in snapshot.docs) {
        print(clientdata.data());
      }
    }
  }

  void deleteClient(String docId) {
    _firestore.collection('supplier').doc(docId).delete();
  }

  void updateClient(
      String docId, String newName, String newPhone, String newAddress) {
    _firestore.collection('supplier').doc(docId).update({
      'name': newName,
      'nbtelephone': newPhone,
      'adress': newAddress,
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.yellow[900],
        title: Text('supplier'),
        actions: [
          IconButton(
            onPressed: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: Text('Search supplier'),
                    content: TextField(
                      onChanged: (value) {
                        setState(() {
                       searchKeyword = value;
                        });
                      },
                      decoration: InputDecoration(
                        hintText: 'Enter supplier name...',
                      ),
                    ),
                    actions: [
                      ElevatedButton(
                        onPressed: () {
                           searchsupplier(searchKeyword);
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
              ? _firestore.collection('supplier').where('name', isEqualTo: supplier).snapshots()
              : _firestore.collection('supplier').snapshots(),
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
                  final supplierDoc = messages[index];
                  final supplierText = supplierDoc.get('name').toString();
                  final supplierId = supplierDoc.id;
                  var supplieradress = supplierDoc.get('adress').toString();
                  String phoneNumber = supplierDoc.get('nbtelephone').toString();

                  final credit = supplierDoc.get('credit') ?? 0;
                  final debit = supplierDoc.get('debit') ?? 0;

                  return ListTile(
                    title: Text('$supplierText'),
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
                                    TextEditingController(text: supplierText);
                                TextEditingController nbTelephoneController =
                                    TextEditingController(text: phoneNumber);
                                TextEditingController adressController =
                                    TextEditingController(text: supplieradress);
                                return AlertDialog(
                                  title: Text('Update supplier'),
                                  content: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      TextField(
                                        onChanged: (value) {
                                          setState(() {
                                            supplier = value;
                                          });
                                        },
                                        controller: nameController,
                                        decoration: InputDecoration(
                                          hintText: 'Enter new supplier name...',
                                        ),
                                      ),
                                      TextField(
                                        onChanged: (value) {
                                          setState(() {
                                            supplieradress = value;
                                          });
                                        },
                                        controller: adressController,
                                        decoration: InputDecoration(
                                          hintText: 'Enter new supplier address...',
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
                                          hintText: 'Enter new supplier phone number...',
                                        ),
                                      ),
                                    ],
                                  ),
                                  actions: [
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
                                  title: Text('Delete supplier?'),
                                  content: Text(
                                    'Are you sure you want to delete this supplier?'),
                                  actions: [
                                    ElevatedButton(
                                      onPressed: () {
                                        deleteClient(supplierId);
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
    builder: (context) => supplierDetailsScreen(
      supplierId: supplierId,
      supplierName: supplierText,
      phoneNumber: phoneNumber,
      adress: supplieradress,
      credit: double.parse(credit.toString()),
      debit: double.parse(debit.toString()),
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
              String newName = '';
              String newPhone = '';
              String newAddress = '';

              return AlertDialog(
                title: Text('Add supplier'),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextFormField(
                      onChanged: (value) {
                        newName = value;
                      },
                      decoration: InputDecoration(
                        hintText: 'Enter supplier name...',
                      ),
                    ),
                    TextFormField(
                      onChanged: (value) {
                        newPhone = value;
                      },
                      decoration: InputDecoration(
                        hintText: 'Enter supplier phone number...',
                      ),
                    ),
                    TextFormField(
                      onChanged: (value) {
                        newAddress = value;
                      },
                      decoration: InputDecoration(
                        hintText: 'Enter supplier address...',
                      ),
                    ),
                  ],
                ),
                actions: [
                  ElevatedButton(
                    onPressed: () {
                      _firestore.collection('supplier').add({
                        'name': newName,
                        'nbtelephone': newPhone,
                        'adress': newAddress,
                        'credit': 0.0,
                        'debit': 0.0,
                      });
                      Navigator.pop(context);
                      supplierStreams();
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
