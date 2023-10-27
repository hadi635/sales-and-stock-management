import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class offerscreen extends StatefulWidget {
  static const screenroute = 'Offer_screen';
  const offerscreen({super.key});

  @override
  State<offerscreen> createState() => _offerscreenState();
}

class _offerscreenState extends State<offerscreen> {
  List<Map<String, dynamic>> offerList =
      []; // List to store offers with start date and end date
  final firestoreInstance = FirebaseFirestore.instance;
  @override
  void initState() {
    super.initState();
    fetchOffers().then((data) {
      setState(() {
        offerList = data;
      });
    });
  }

  void addOffer(String offerName, DateTime startDate, DateTime endDate,
      int discountPercentage) {
    CollectionReference offersCollection =
        FirebaseFirestore.instance.collection('offers');

    Map<String, dynamic> offerData = {
      'name': offerName,
      'startDate': Timestamp.fromDate(startDate),
      'endDate': Timestamp.fromDate(endDate),
      'discount': discountPercentage,
    };

    offersCollection.add(offerData).then((value) {
      print("Offer added with ID: ${value.id}");
    }).catchError((error) {
      print("Error adding offer: $error");
    });
  }

  void updateOfferInFirestore(int index, String offerName, DateTime startDate,
      DateTime endDate, int discountPercentage) {
    DocumentReference offerRef = firestoreInstance
        .collection('offers')
        .doc(offerList[index]['documentID']);

    Map<String, dynamic> updatedData = {
      'name': offerName,
      'startDate': Timestamp.fromDate(startDate),
      'endDate': Timestamp.fromDate(endDate),
      'discount': discountPercentage,
    };

    offerRef.update(updatedData).then((_) {
      print("Offer updated in Firestore");
    }).catchError((error) {
      print("Error updating offer in Firestore: $error");
    });
  }

  void deleteOfferFromFirestore(int index) {
    String documentID = offerList[index]['documentID'];
    DocumentReference offerRef =
        firestoreInstance.collection('offers').doc(documentID);

    offerRef.delete().then((_) {
      print("Offer deleted from Firestore");
    }).catchError((error) {
      print("Error deleting offer from Firestore: $error");
    });
  }

  Future<List<Map<String, dynamic>>> fetchOffers() async {
    List<Map<String, dynamic>> offers = [];

    try {
      final querySnapshot = await firestoreInstance.collection('offers').get();
      for (var doc in querySnapshot.docs) {
        Map<String, dynamic> offerData = doc.data();
        offerData['documentID'] = doc.id;
        offers.add(offerData);
      }
    } catch (e) {
      print('Error fetching data: $e');
    }

    return offers;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromRGBO(255, 152, 0, 1),
        title: const Text('Make Offers'),
      ),
      body: StreamBuilder<QuerySnapshot>(
          stream: firestoreInstance.collection('offers').snapshots(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                  child: CircularProgressIndicator(
                color: Colors.amber,
              ));
            }
            if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            }
            if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
              return Text('No offers available.');
            }

            return ListView.builder(
              itemCount: snapshot.data!.docs.length,
              itemBuilder: (BuildContext context, int index) {
                final offerData =
                    snapshot.data!.docs[index].data() as Map<String, dynamic>;
                final offerName = offerData['name'];
                final startDate =
                    (offerData['startDate'] as Timestamp).toDate();
                final endDate = (offerData['endDate'] as Timestamp).toDate();
                final formattedStartDate =
                    DateFormat('yyyy-MM-dd').format(startDate);
                final formattedEndDate =
                    DateFormat('yyyy-MM-dd').format(endDate);
                final discountPercentage = offerData['discount'];

                return ListTile(
                  title: Text(offerName),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Discount Percentage: $discountPercentage%'),
                      Text('Start Date: $formattedStartDate'),
                      Text('End Date: $formattedEndDate'),
                    ],
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.edit),
                        onPressed: () {
                          // Show a dialog to edit the offer details
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              TextEditingController nameController =
                                  TextEditingController(text: offerName);
                              DateTime startDateValue = startDate;
                              DateTime endDateValue = endDate;
                              int discountValue = discountPercentage;
                              return AlertDialog(
                                title: const Text('Edit Offer'),
                                content: SingleChildScrollView(
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      TextField(
                                        controller: nameController,
                                        decoration: const InputDecoration(
                                            labelText: 'Offer Name'),
                                      ),
                                      const SizedBox(height: 16),
                                      const Text('Discount Percentage:'),
                                      TextField(
                                        controller: TextEditingController(
                                            text: discountValue.toString()),
                                        onChanged: (value) {
                                          discountValue =
                                              int.tryParse(value) ?? 0;
                                        },
                                        keyboardType: TextInputType.number,
                                      ),
                                      const SizedBox(height: 16),
                                      const Text('Start Date:'),
                                      ElevatedButton(
                                        onPressed: () async {
                                          DateTime? pickedDate =
                                              await showDatePicker(
                                            context: context,
                                            initialDate: startDateValue,
                                            firstDate: DateTime(2000),
                                            lastDate: DateTime(2101),
                                          );
                                          if (pickedDate != null &&
                                              pickedDate != startDateValue) {
                                            setState(() {
                                              startDateValue = pickedDate;
                                            });
                                          }
                                        },
                                        child: const Text('Select Start Date'),
                                      ),
                                      const SizedBox(height: 16),
                                      const Text('End Date:'),
                                      ElevatedButton(
                                        onPressed: () async {
                                          DateTime? pickedDate =
                                              await showDatePicker(
                                            context: context,
                                            initialDate: endDateValue,
                                            firstDate: DateTime(2000),
                                            lastDate: DateTime(2101),
                                          );
                                          if (pickedDate != null &&
                                              pickedDate != endDateValue) {
                                            setState(() {
                                              endDateValue = pickedDate;
                                            });
                                          }
                                        },
                                        child: const Text('Select End Date'),
                                      ),
                                    ],
                                  ),
                                ),
                                actions: [
                                  ElevatedButton(
                                    onPressed: () {
                                      updateOfferInFirestore(
                                          index,
                                          nameController.text,
                                          startDateValue,
                                          endDateValue,
                                          discountValue);
                                      Navigator.pop(context);
                                    },
                                    child: const Text('Save'),
                                  ),
                                  ElevatedButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                    child: const Text('Cancel'),
                                  ),
                                ],
                              );
                            },
                          );
                        },
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete),
                        onPressed: () {
                          // Show a confirmation dialog before deleting the offer
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: const Text('Delete Offer'),
                                content: const Text(
                                    'Are you sure you want to delete this offer?'),
                                actions: [
                                  ElevatedButton(
                                    onPressed: () {
                                      deleteOfferFromFirestore(index);
                                      Navigator.pop(context);
                                    },
                                    child: const Text('Delete'),
                                  ),
                                  ElevatedButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                    child: const Text('Cancel'),
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
          }),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.orange,
        onPressed: () {
          // Show a dialog to add a new offer
          showDialog(
            context: context,
            builder: (BuildContext context) {
              TextEditingController nameController = TextEditingController();
              DateTime startDateValue = DateTime.now();
              DateTime endDateValue = DateTime.now();
              int discountValue = 0;

              return AlertDialog(
                title: const Text('Add Offer'),
                content: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TextField(
                        controller: nameController,
                        decoration:
                            const InputDecoration(labelText: 'Offer Name'),
                      ),
                      const SizedBox(height: 16),
                      const Text('Discount Percentage:'),
                      TextField(
                        onChanged: (value) {
                          discountValue = int.tryParse(value) ?? 0;
                        },
                        keyboardType: TextInputType.number,
                      ),
                      const SizedBox(height: 16),
                      const Text('Start Date:'),
                      ElevatedButton(
                        onPressed: () async {
                          DateTime? pickedDate = await showDatePicker(
                            context: context,
                            initialDate: startDateValue,
                            firstDate: DateTime(2000),
                            lastDate: DateTime(2101),
                          );
                          if (pickedDate != null &&
                              pickedDate != startDateValue) {
                            setState(() {
                              startDateValue = pickedDate;
                            });
                          }
                        },
                        child: const Text('Select Start Date'),
                      ),
                      const SizedBox(height: 16),
                      const Text('End Date:'),
                      ElevatedButton(
                        onPressed: () async {
                          DateTime? pickedDate = await showDatePicker(
                            context: context,
                            initialDate: endDateValue,
                            firstDate: DateTime(2000),
                            lastDate: DateTime(2101),
                          );
                          if (pickedDate != null &&
                              pickedDate != endDateValue) {
                            setState(() {
                              endDateValue = pickedDate;
                            });
                          }
                        },
                        child: const Text('Select End Date'),
                      ),
                    ],
                  ),
                ),
                actions: [
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        addOffer(nameController.text, startDateValue,
                            endDateValue, discountValue);
                      });
                      Navigator.pop(context);
                    },
                    child: const Text('Add'),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text('Cancel'),
                  ),
                ],
              );
            },
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
