import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

class AddTrip extends StatefulWidget {
  final Function(List<Map<String, String>>) onTripAdded;
  const AddTrip({Key? key, required this.onTripAdded}) : super(key: key);

  @override
  State<AddTrip> createState() => _AddTripState();
}

class _AddTripState extends State<AddTrip> {
  final _formkey = GlobalKey<FormState>();

  final TextEditingController _tripCodeController = TextEditingController();
  final TextEditingController _tripDesController = TextEditingController();
  final TextEditingController _totalAmtController = TextEditingController();
  final TextEditingController _dateController = TextEditingController(
      text:
              DateFormat('yyyy-MM-dd').format(DateTime.now()));

  String _selectedCurrency = 'MMK';

  
  final List<String> departments = ['Admin', 'HR', 'Marketing'];
  String? _selectedDepartment;
  


  void _submitForm() {
    if (_formkey.currentState!.validate()) {
      List<Map<String, String>> newTrip = [
        {
          'Date': _dateController.text,
          'tripID': _tripCodeController.text,
          'description': _tripDesController.text,
          'Total Amount': _totalAmtController.text,
          'currency': _selectedCurrency,
          'department': _selectedDepartment ?? '',
          'Requestable': 'Pending',
        }
      ];
      widget.onTripAdded(newTrip);
      Navigator.pop(context);
    }
  }

  //clear
  void _clearText() {
    setState(() {
      _tripCodeController.text = "";
      _tripDesController.text = "";
      _totalAmtController.text = "";
      _selectedDepartment = null;
      _selectedCurrency = 'MMK';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Trip Request Form"),
      ),
      body: Center(
        child: Container(
          color: const Color.fromARGB(255, 103, 207, 177),
          width: MediaQuery.of(context).size.width * 0.5,
          child: Padding(
            padding: const EdgeInsets.all(7.0),
            child: SingleChildScrollView(
              child: Center(
                child: Container(
                    width: MediaQuery.of(context).size.width * 0.5,
                    child: Form(
                        key: _formkey,
                        child: Column(
                          children: [
                            const Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Center(
                                child: Text(
                                  'Add Trip Request',
                                  style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),
                            ListTile(
                              title: TextFormField(
                                controller: _dateController,
                                decoration: const InputDecoration(
                                    labelText: "Request Date"),
                                readOnly: true,
                              ),
                            ),
                            ListTile(
                              title: TextFormField(
                                controller: _tripCodeController,
                                decoration: const InputDecoration(
                                    labelText: "Enter Trip Code"),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return "Enter Trip Code";
                                  }
                                  return null;
                                },
                              ),
                            ),
                            ListTile(
                              title: TextFormField(
                                controller: _tripDesController,
                                decoration: const InputDecoration(
                                    labelText: "Enter Trip Description"),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return "Enter Trip Description";
                                  }
                                  return null;
                                },
                              ),
                            ),
                            ListTile(
                              title: TextFormField(
                                controller: _totalAmtController,
                                decoration: const InputDecoration(
                                  labelText: "Enter Total Amount",
                                ),
                                keyboardType: TextInputType.number,
                                inputFormatters: [
                                  FilteringTextInputFormatter.allow(
                                      RegExp(r'^\d*\.?\d*')),
                                ],
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return "Enter Total Amount";
                                  }
                                  final amount = double.tryParse(value);
                                  if (amount == null) {
                                    return "Enter a valid amount";
                                  }
                                  if (amount <= 0) {
                                    return "Your Request Amount must be greater than 0";
                                  }

                                  return null;
                                },
                              ),
                            ),
                            ListTile(
                              title: DropdownButtonFormField(
                                decoration: const InputDecoration(),
                                value: _selectedCurrency,
                                items: ['MMK', 'USD'].map((currency) {
                                  return DropdownMenuItem(
                                      value: currency, child: Text(currency));
                                }).toList(),
                                onChanged: (value) {
                                  setState(() {
                                    _selectedCurrency = value!;
                                  });
                                },
                              ),
                            ),
                            
                            ListTile(
                              title: DropdownButtonFormField(
                                decoration: const InputDecoration(
                                  labelText: "Choose your Department",
                                ),
                                items: departments.map((department) {
                                  return DropdownMenuItem(
                                      value: department,
                                      child: Text(department));
                                }).toList(),
                                onChanged: (value) {
                                  setState(() {
                                    _selectedDepartment = value!;
                                  });
                                },
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return "Choose your Department";
                                  }
                                  return null;
                                },
                              ),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                ElevatedButton(
                                  onPressed: () {
                                    _submitForm();
                                  },
                                  style: ElevatedButton.styleFrom(
                                    textStyle: const TextStyle(
                                      fontSize: 15,
                                    ),
                                    backgroundColor: Colors.white,
                                    foregroundColor: Colors.black,
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 20, vertical: 12),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                  ),
                                  child: const Text("Submit"),
                                ),
                                const SizedBox(
                                  width: 20,
                                ),
                                ElevatedButton(
                                  onPressed: () {
                                    _clearText();
                                  },
                                  style: ElevatedButton.styleFrom(
                                    textStyle: const TextStyle(
                                      fontSize: 15,
                                    ),
                                    backgroundColor: Colors.white,
                                    foregroundColor: Colors.black,
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 20, vertical: 12),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                  ),
                                  child: const Text("Clear"),
                                )
                              ],
                            ),
                            const SizedBox(
                              height: 20,
                            )
                          ],
                        ))),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// Edit Trip Request
class EditTrip extends StatefulWidget {
  final Map<String, dynamic> tripData;
  final Function(Map<String, dynamic>) onTripUpdated;
  const EditTrip(
      {Key? key, required this.tripData, required this.onTripUpdated})
      : super(key: key);

  @override
  State<EditTrip> createState() => _EditTripState();
}

class _EditTripState extends State<EditTrip> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _tripCodeController = TextEditingController();
  final TextEditingController _tripDesController = TextEditingController();
  final TextEditingController _totalAmtController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();

  String _selectedCurrency = 'MMK';
  final List<String> departments = ['Admin', 'HR', 'Marketing'];
  String? _selectedDepartment;

  @override
  void initState() {
    super.initState();
    _tripCodeController.text = widget.tripData['tripID'];
    _tripDesController.text = widget.tripData['description'];
    _totalAmtController.text = widget.tripData['Total Amount'];
    _selectedCurrency = widget.tripData['currency'];
    _selectedDepartment = widget.tripData['department'];
    _dateController.text = widget.tripData['Date'];
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      Map<String, dynamic> updatedTrip = {
        'Date': _dateController.text,
        'tripID': _tripCodeController.text,
        'description': _tripDesController.text,
        'Total Amount': _totalAmtController.text,
        'currency': _selectedCurrency,
        'department': _selectedDepartment ?? '',
        'Requestable':
            widget.tripData['Requestable'], // Keep the existing status
      };

      widget.onTripUpdated(updatedTrip);
      Navigator.pop(context);
    }
  }

  void _clearText() {
    setState(() {
      _tripCodeController.clear();
      _tripDesController.clear();
      _totalAmtController.clear();
      _selectedDepartment = null;
      _selectedCurrency = 'MMK';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Edit Trip Request"),
      ),
      body: Center(
        child: Container(
          color: const Color.fromARGB(255, 103, 207, 177),
          width: MediaQuery.of(context).size.width * 0.5,
          child: Padding(
            padding: const EdgeInsets.all(7.0),
            child: SingleChildScrollView(
              child: Center(
                child: Container(
                  width: MediaQuery.of(context).size.width * 0.5,
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        const Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Center(
                            child: Text(
                              'Edit Trip Request',
                              style: TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                        ListTile(
                          title: TextFormField(
                            controller: _tripCodeController,
                            decoration: const InputDecoration(
                                labelText: "Enter Trip Code"),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return "Enter Trip Code";
                              }
                              return null;
                            },
                          ),
                        ),
                        ListTile(
                          title: TextFormField(
                            controller: _tripDesController,
                            decoration: const InputDecoration(
                                labelText: "Enter Trip Description"),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return "Enter Trip Description";
                              }
                              return null;
                            },
                          ),
                        ),
                        ListTile(
                          title: TextFormField(
                            controller: _totalAmtController,
                            decoration: const InputDecoration(
                              labelText: "Enter Total Amount",
                            ),
                            keyboardType: TextInputType.number,
                            inputFormatters: [
                              FilteringTextInputFormatter.allow(
                                  RegExp(r'^\d*\.?\d*')),
                            ],
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return "Enter Total Amount";
                              }
                              final amount = double.tryParse(value);
                              if (amount == null) {
                                return "Enter a valid amount";
                              }
                              if (amount <= 0) {
                                return "Your Request Amount must be greater than 0";
                              }
                              return null;
                            },
                          ),
                        ),
                        ListTile(
                          title: DropdownButtonFormField(
                            decoration: const InputDecoration(),
                            value: _selectedCurrency,
                            items: ['MMK', 'USD'].map((currency) {
                              return DropdownMenuItem(
                                  value: currency, child: Text(currency));
                            }).toList(),
                            onChanged: (value) {
                              setState(() {
                                _selectedCurrency = value!;
                              });
                            },
                          ),
                        ),
                        ListTile(
                          title: TextFormField(
                            controller: _dateController,
                            decoration: const InputDecoration(
                                labelText: "Request Date"),
                            readOnly: true,
                          ),
                        ),
                        ListTile(
                          title: DropdownButtonFormField(
                            decoration: const InputDecoration(
                              labelText: "Choose your Department",
                            ),
                            value: _selectedDepartment,
                            items: departments.map((department) {
                              return DropdownMenuItem(
                                  value: department, child: Text(department));
                            }).toList(),
                            onChanged: (value) {
                              setState(() {
                                _selectedDepartment = value!;
                              });
                            },
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return "Choose your Department";
                              }
                              return null;
                            },
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            ElevatedButton(
                              onPressed: _submitForm,
                              style: ElevatedButton.styleFrom(
                                textStyle: const TextStyle(
                                  fontSize: 15,
                                ),
                                backgroundColor: Colors.white,
                                foregroundColor: Colors.black,
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 20, vertical: 12),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              child: const Text("Update"),
                            ),
                            const SizedBox(
                              width: 20,
                            ),
                            ElevatedButton(
                              onPressed: _clearText,
                              style: ElevatedButton.styleFrom(
                                textStyle: const TextStyle(
                                  fontSize: 15,
                                ),
                                backgroundColor: Colors.white,
                                foregroundColor: Colors.black,
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 20, vertical: 12),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              child: const Text("Clear"),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}


