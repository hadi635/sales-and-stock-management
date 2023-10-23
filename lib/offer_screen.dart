import 'package:flutter/material.dart';

class offerscreen extends StatefulWidget {
  static const screenroute = 'Offer_screen';
  const offerscreen({super.key});

  @override
  State<offerscreen> createState() => _offerscreenState();
}

class _offerscreenState extends State<offerscreen> {
  List<Map<String, dynamic>> offerList = []; // List to store offers with start date and end date

  // Function to add a new offer
  void addOffer(
      String offerName, DateTime startDate, DateTime endDate, int discountPercentage) {
    setState(() {
      offerList.add({
        'name': offerName,
        'startDate': startDate,
        'endDate': endDate,
        'discount': discountPercentage,
      });
    });
  }

  // Function to update an offer
  void updateOffer(
      int index, String offerName, DateTime startDate, DateTime endDate, int discountPercentage) {
    setState(() {
      offerList[index] = {
        'name': offerName,
        'startDate': startDate,
        'endDate': endDate,
        'discount': discountPercentage,
      };
    });
  }

  // Function to delete an offer
  void deleteOffer(int index) {
    setState(() {
      offerList.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.orange,
        title: Text('Make Offers'),
      ),
      body: ListView.builder(
        itemCount: offerList.length,
        itemBuilder: (BuildContext context, int index) {
          String offerName = offerList[index]['name'];
          DateTime startDate = offerList[index]['startDate'];
          DateTime endDate = offerList[index]['endDate'];
          int discountPercentage = offerList[index]['discount'];

          return ListTile(
            title: Text(offerName),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Discount Percentage: $discountPercentage%'),
                Text('Start Date: ${startDate.toLocal()}'),
                Text('End Date: ${endDate.toLocal()}'),
              ],
            ),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: Icon(Icons.edit),
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
                          title: Text('Edit Offer'),
                          content: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              TextField(
                                controller: nameController,
                                decoration:
                                    InputDecoration(labelText: 'Offer Name'),
                              ),
                              SizedBox(height: 16),
                              Text('Discount Percentage:'),
                              TextField(
                                controller: TextEditingController(text: discountValue.toString()),
                                onChanged: (value) {
                                  discountValue = int.tryParse(value) ?? 0;
                                },
                                keyboardType: TextInputType.number,
                              ),
                              SizedBox(height: 16),
                              Text('Start Date:'),
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
                                child: Text('Select Start Date'),
                              ),
                              SizedBox(height: 16),
                              Text('End Date:'),
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
                                child: Text('Select End Date'),
                              ),
                            ],
                          ),
                          actions: [
                            ElevatedButton(
                              onPressed: () {
                                updateOffer(index, nameController.text,
                                    startDateValue, endDateValue, discountValue);
                                Navigator.pop(context);
                              },
                              child: Text('Save'),
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
                    // Show a confirmation dialog before deleting the offer
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: Text('Delete Offer'),
                          content: Text(
                              'Are you sure you want to delete this offer?'),
                          actions: [
                            ElevatedButton(
                              onPressed: () {
                                deleteOffer(index);
                                Navigator.pop(context);
                              },
                              child: Text('Delete'),
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
      ),
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
                title: Text('Add Offer'),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      controller: nameController,
                      decoration: InputDecoration(labelText: 'Offer Name'),
                    ),
                    SizedBox(height: 16),
                    Text('Discount Percentage:'),
                    TextField(
                      onChanged: (value) {
                        discountValue = int.tryParse(value) ?? 0;
                      },
                      keyboardType: TextInputType.number,
                    ),
                    SizedBox(height: 16),
                    Text('Start Date:'),
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
                      child: Text('Select Start Date'),
                    ),
                    SizedBox(height: 16),
                    Text('End Date:'),
                    ElevatedButton(
                      onPressed: () async {
                        DateTime? pickedDate = await showDatePicker(
                          context: context,
                          initialDate: endDateValue,
                          firstDate: DateTime(2000),
                          lastDate: DateTime(2101),
                        );
                        if (pickedDate != null && pickedDate != endDateValue) {
                          setState(() {
                            endDateValue = pickedDate;
                          });
                        }
                      },
                      child: Text('Select End Date'),
                    ),
                  ],
                ),
                actions: [
                  ElevatedButton(
                    onPressed: () {
                      addOffer(
                          nameController.text, startDateValue, endDateValue, discountValue);
                      Navigator.pop(context);
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
