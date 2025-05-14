import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'UserDataProvider.dart';

class MyDataPage extends StatefulWidget {
  @override
  _MyDataPageState createState() => _MyDataPageState();
}

class _MyDataPageState extends State<MyDataPage> {
  // Month names to map indexes
  final List<String> monthNames = ['January', 'February', 'March', 'April', 'May'];

  @override
  void initState() {
    super.initState();

    // Populate initial dummy data if provider has no data yet
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final userData = Provider.of<UserDataProvider>(context, listen: false);
      if (userData.monthlyData.isEmpty) {
        userData.setMonthlyData([25.5, 26.5, 25.0, 24.0, 27.8]);
        print("Default Data Set:  ${userData.monthlyData}");
      }
    });
  }

  void _editData(int index) {
    final userData = Provider.of<UserDataProvider>(context, listen: false);
    TextEditingController controller = TextEditingController(
      text: userData.monthlyData[index].toString(),
    );

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Edit Data for ${monthNames[index]}'),
          content: TextField(
            controller: controller,
            keyboardType: TextInputType.numberWithOptions(decimal: true),
            decoration: InputDecoration(hintText: 'Enter new value in GB'),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                if (controller.text.isNotEmpty) {
                  double newValue = double.tryParse(controller.text) ?? userData.monthlyData[index];
                  userData.updateMonth(index, newValue);
                }
                Navigator.pop(context);
              },
              child: Text('Save'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final userData = Provider.of<UserDataProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'My Data',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.indigo,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: userData.monthlyData.length,
                itemBuilder: (context, index) {
                  return Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 5,
                    margin: EdgeInsets.symmetric(vertical: 8),
                    child: ListTile(
                      title: Text(
                        '${monthNames[index]} Usage',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text(
                        '${userData.monthlyData[index].toStringAsFixed(1)} GB',
                        style: TextStyle(color: Colors.grey[700]),
                      ),
                      trailing: IconButton(
                        icon: Icon(Icons.edit, color: Colors.indigo),
                        onPressed: () => _editData(index),
                      ),
                    ),
                  );
                },
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context); // Return to previous screen
              },
              child: Text('Okay'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.indigo,
                foregroundColor: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
