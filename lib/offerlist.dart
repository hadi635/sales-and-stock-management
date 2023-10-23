import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Offerlist extends StatefulWidget {
  static const screenroute = 'offerlist_screen';
  
  const Offerlist({super.key});

  @override
  State<Offerlist> createState() => _OfferlistState();
}

class _OfferlistState extends State<Offerlist> {
  List<Map<String, dynamic>> offerList =
      []; // List to store offers with start date and end date

  // Function to add a new offer
  void addOffer(String offerName, DateTime startDate, DateTime endDate) {
    setState(() {
      offerList.add({
        'name': offerName,
        'startDate': startDate,
        'endDate': endDate,
      });
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

          return ListTile(
            title: Text(offerName),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Start Date: ${startDate.toLocal()}'),
                Text('End Date: ${endDate.toLocal()}'),
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
                          nameController.text, startDateValue, endDateValue);
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
