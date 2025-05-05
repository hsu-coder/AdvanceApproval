import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ProjectEntry extends StatefulWidget {
  const ProjectEntry({super.key});

  @override
  State<ProjectEntry> createState() => _ProjectEntryState();
}

class _ProjectEntryState extends State<ProjectEntry> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold();
  }
}

class EntryForm extends StatefulWidget {
  final Function(List<Map<String, dynamic>>) onProjectAdded;

  const EntryForm({Key? key, required this.onProjectAdded}) : super(key: key);
  @override
  State<EntryForm> createState() => _EntryFormState();
}

class _EntryFormState extends State<EntryForm> {
  final _formkey = GlobalKey<FormState>();

  //final TextEditingController dateController=TextEditingController();
  final TextEditingController projectController = TextEditingController();

  final TextEditingController desciptionController = TextEditingController();
  final TextEditingController amountController = TextEditingController();
  final TextEditingController dateController = TextEditingController(
      text:
          "${DateTime.now().year}-${DateTime.now().month}-${DateTime.now().day}");

  String? _selectedDepartment;
  String _selectedCurrency = "MMK";
  //String? _selectedRequestable='No';
  final List<String> _departments = [
    'HR',
    'IT',
    'Finance',
    'Admin',
    'Production',
    'Engineering',
    'Marketing',
    'Sales'
  ];
  final List<String> _currencies = ['MMK', 'USD'];
  //final List<String> _requestable=['Yes','No'];

  void _submitForm() {
    if (_formkey.currentState!.validate()) {
      List<Map<String, dynamic>> newProject = [
        {
          "Date": dateController.text,
          "ProjectID": projectController.text,
          "Description": desciptionController.text,
          "Total Budget Amount": amountController.text,
          "Currency": _selectedCurrency ?? '',
          "Department": _selectedDepartment ?? '',
          "Requestable": 'No',
        }
      ];
      widget.onProjectAdded(newProject);
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Request Form")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: Container(
            width: MediaQuery.of(context).size.width / 3,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color.fromARGB(255, 149, 239, 233),
              borderRadius: BorderRadius.circular(15), // Rounded corners
              border: Border.all(color: Colors.black, width: 1), // Border color
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.3), // Shadow color
                  blurRadius: 10,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: Form(
              key: _formkey,
              child: Column(
                children: [
                  TextFormField(
                    controller: dateController,
                    decoration: const InputDecoration(
                      labelText: "Date",
                      labelStyle: TextStyle(fontSize: 15, color: Colors.black),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Please enter date";
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: projectController,
                    decoration: const InputDecoration(
                        labelText: "ProjectID",
                        labelStyle: TextStyle(
                          fontSize: 15,
                          // fontWeight: FontWeight.bold,
                          color: Colors.black,
                        )),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Please enter project code";
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 10),
                  TextFormField(
                    controller: desciptionController,
                    decoration: const InputDecoration(
                      labelText: "Description",
                      labelStyle: TextStyle(
                        fontSize: 15,
                        // fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Please enter description";
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 5),
                  TextFormField(
                    controller: amountController,
                    decoration: const InputDecoration(
                      labelText: "Total Budget Amount",
                      labelStyle: TextStyle(
                        fontSize: 15,
                        // fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Please enter budget amount";
                      }
                      if (!RegExp(r'^[0-9]+(\.[0-9]{1,2})?$').hasMatch(value)) {
                        return "Please enter valid amount";
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 5),
                  DropdownButtonFormField<String>(
                    decoration: const InputDecoration(
                      labelText: 'Currency',
                      labelStyle: TextStyle(
                        fontSize: 15,
                        // fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    value: _selectedCurrency,
                    items: _currencies.map((String Currency) {
                      return DropdownMenuItem<String>(
                        value: Currency,
                        child: Text(Currency),
                      );
                    }).toList(),
                    onChanged: (String? newValue) {
                      setState(() {
                        _selectedCurrency = newValue!;
                      });
                    },
                    validator: (value) =>
                        value == null ? 'Select a currency' : null,
                  ),
                  const SizedBox(height: 5),
                  DropdownButtonFormField<String>(
                    decoration: const InputDecoration(
                      labelText: 'Department',
                      labelStyle: TextStyle(
                        fontSize: 15,
                        // fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    value: _selectedDepartment,
                    items: _departments.map((String department) {
                      return DropdownMenuItem<String>(
                        value: department,
                        child: Text(department),
                      );
                    }).toList(),
                    onChanged: (String? newValue) {
                      setState(() {
                        _selectedDepartment = newValue;
                      });
                    },
                    validator: (value) =>
                        value == null ? 'Select a department' : null,
                  ),
                  const SizedBox(height: 5),
                  TextFormField(
                    decoration: const InputDecoration(
                      labelText: "Requestable",
                      labelStyle: TextStyle(
                        fontSize: 15,
                        //fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    initialValue: 'No',
                    readOnly: true,
                  ),
                  const SizedBox(height: 20),
                  Center(
                    child: ElevatedButton(
                      onPressed: _submitForm,
                      child: const Text('Register'),
                      style: ElevatedButton.styleFrom(
                        textStyle: const TextStyle(
                          fontSize: 15,
                        ),
                        backgroundColor: Colors.lightBlueAccent,
                        foregroundColor: Colors.black,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
