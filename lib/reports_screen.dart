import 'package:flutter/material.dart';

class reportscreen extends StatefulWidget {
  static const screenroute = 'report_screen';
  const reportscreen({super.key});

  @override
  State<reportscreen> createState() => _reportscreenState();
}

class _reportscreenState extends State<reportscreen> {



  List<String> reportList = [
    'Report 1',
    'Report 2',
    'Report 3',
    'Report 4',
    'Report 5',
    // Add more reports as needed
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Reports'),
      ),
      body: ListView.builder(
        itemCount: reportList.length,
        itemBuilder: (BuildContext context, int index) {
          return ListTile(
            title: Text(reportList[index]),
            onTap: () {
              // Implement your logic to handle tapping on a report
              // For example, you can navigate to a detailed report screen
              // using Navigator.push or display some information about the report.
            },
          );
        },
      ),
    );
  }
}



 
