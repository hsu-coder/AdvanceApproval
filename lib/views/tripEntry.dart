// ignore: file_names
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

class AddTrip extends StatefulWidget {
  final Function(List<Map<String, dynamic>>) onTripAdded;
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
      text: DateFormat('yyyy-MM-dd').format(DateTime.now()));

  String _selectedCurrency = 'MMK';

  final List<String> departments = ['Admin', 'HR', 'Marketing'];
  String? _selectedDepartment;

  List<Map<String, dynamic>> chooseBudgetCodes = [];
  final List<Map<String, dynamic>> BudgetDetails = [
    {'Budget Code': 'B001', 'Description': 'Marketing Campaign'},
    {'Budget Code': 'B002', 'Description': 'Short Trip'},
    {'Budget Code': 'B003', 'Description': 'Foreign Trip'},
    {'Budget Code': 'B004', 'Description': 'On Job Training'},
    {'Budget Code': 'B005', 'Description': 'On Job Training'},
    {'Budget Code': 'B006', 'Description': 'On Job Training'},
    {'Budget Code': 'B007', 'Description': 'On Job Training'},
    {'Budget Code': 'B008', 'Description': 'On Job Training'},
    {'Budget Code': 'B009', 'Description': 'On Job Training'},
    {'Budget Code': 'B010', 'Description': 'On Job Training'}
  ];

  //Budget Alert Dialog
  void _showBudgetCodeDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          content: Stack(
            children: [
              Padding(
                padding: const EdgeInsets.only(
                    top: 20.0, left: 16.0, right: 16.0, bottom: 16.0),
                child: Column(
                  children: [
                    const Text(
                      "Select Budget Code",
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 10),
                    SingleChildScrollView(
                      scrollDirection: Axis.vertical,
                      child: SizedBox(
                        width: MediaQuery.of(context).size.width * 0.35,
                        height: MediaQuery.of(context).size.height * 0.7,
                        child: SingleChildScrollView(
                          child: DataTable(
                            showCheckboxColumn: false,
                            columns: const [
                              DataColumn(label: Text("")),
                              DataColumn(label: Text("Budget Code")),
                              DataColumn(label: Text("Description")),
                            ],
                            rows: BudgetDetails.map((budgetCode) {
                              bool isSelected = chooseBudgetCodes.any((code) =>
                                  code['Budget Code'] ==
                                  budgetCode['Budget Code']);

                              return DataRow(
                                cells: [
                                  DataCell(
                                    isSelected
                                        ? IconButton(
                                            icon: const Icon(Icons.check_circle,
                                                color: Colors.green),
                                            onPressed: () {
                                              setState(() {
                                                chooseBudgetCodes.removeWhere(
                                                    (code) =>
                                                        code['Budget Code'] ==
                                                        budgetCode[
                                                            'Budget Code']);
                                              });
                                              Navigator.pop(context);
                                              _showBudgetCodeDialog();
                                            },
                                          )
                                        : const SizedBox.shrink(),
                                  ),
                                  DataCell(Text(budgetCode['Budget Code'])),
                                  DataCell(Text(budgetCode['Description'])),
                                ],
                                onSelectChanged: (selected) {
                                  if (selected != null && selected) {
                                    if (isSelected) {
                                      // Show error message if the budget code is already selected
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        const SnackBar(
                                          content: Text(
                                              "This budget code is already selected."),
                                          duration: Duration(seconds: 2),
                                        ),
                                      );
                                    } else {
                                      setState(() {
                                        chooseBudgetCodes.add(budgetCode);
                                      });
                                      Navigator.pop(context);
                                    }
                                  }
                                },
                              );
                            }).toList(),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Positioned(
                top: 8,
                right: 8,
                child: IconButton(
                  icon: const Icon(Icons.cancel_outlined, color: Colors.black),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _deleteBudgetCode(int index) {
    setState(() {
      chooseBudgetCodes.removeAt(index);
    });
  }

//Submit Button
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
          'BudgetDetails': jsonEncode(chooseBudgetCodes),
        }
      ];
      widget.onTripAdded(newTrip);
      Navigator.pop(context);
    }
  }

  //clear Button
  void _clearText() {
    setState(() {
      _tripCodeController.text = "";
      _tripDesController.text = "";
      _totalAmtController.text = "";
      _selectedDepartment = null;
      _selectedCurrency = 'MMK';
      chooseBudgetCodes = [];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromRGBO(100, 207, 198, 0.855),
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
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                  child: Column(
                                    children: [
                                      ListTile(
                                        title: TextFormField(
                                          controller: _tripCodeController,
                                          decoration: const InputDecoration(
                                              labelText: "Enter Trip Code"),
                                          validator: (value) {
                                            if (value == null ||
                                                value.isEmpty) {
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
                                              labelText:
                                                  "Enter Trip Description"),
                                          validator: (value) {
                                            if (value == null ||
                                                value.isEmpty) {
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
                                            if (value == null ||
                                                value.isEmpty) {
                                              return "Enter Total Amount";
                                            }
                                            final amount =
                                                double.tryParse(value);
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
                                    ],
                                  ),
                                ),
                                Expanded(
                                  child: Column(
                                    children: [
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
                                            if (value == null ||
                                                value.isEmpty) {
                                              return "Choose your Department";
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
                                                value: currency,
                                                child: Text(currency));
                                          }).toList(),
                                          onChanged: (value) {
                                            setState(() {
                                              _selectedCurrency = value!;
                                            });
                                          },
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                children: [
                                  ElevatedButton(
                                    onPressed: _showBudgetCodeDialog,
                                    style: ElevatedButton.styleFrom(
                                      textStyle: const TextStyle(fontSize: 15),
                                      backgroundColor: Colors.green,
                                      foregroundColor: Colors.black,
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 20, vertical: 12),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                    ),
                                    child: const Text("Add Budget Code"),
                                  ),
                                  const SizedBox(height: 10),
                                  Container(
                                    height: MediaQuery.of(context).size.height *
                                        0.3,
                                    child: SingleChildScrollView(
                                      scrollDirection: Axis.vertical,
                                      child: DataTable(
                                        border: TableBorder.all(),
                                        showCheckboxColumn: false,
                                        columns: const [
                                          DataColumn(
                                              label: Text("Budget Code")),
                                          DataColumn(
                                              label: Text("Description")),
                                          DataColumn(label: Text("Action")),
                                        ],
                                        rows:
                                            chooseBudgetCodes.map((budgetCode) {
                                          final index = chooseBudgetCodes
                                              .indexOf(budgetCode);
                                          return DataRow(
                                            cells: [
                                              DataCell(Text(
                                                  budgetCode['Budget Code'])),
                                              DataCell(Text(
                                                  budgetCode['Description'])),
                                              DataCell(
                                                IconButton(
                                                  onPressed: () {
                                                    _deleteBudgetCode(index);
                                                  },
                                                  icon:
                                                      const Icon(Icons.delete),
                                                ),
                                              ),
                                            ],
                                          );
                                        }).toList(),
                                      ),
                                    ),
                                  ),
                                ],
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
                            ),
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
  List<Map<String, dynamic>> chooseBudgetCodes = [];
  final List<Map<String, dynamic>> BudgetDetails = [
    {'Budget Code': 'B001', 'Description': 'Marketing Campaign'},
    {'Budget Code': 'B002', 'Description': 'Short Trip'},
    {'Budget Code': 'B003', 'Description': 'Foreign Trip'},
    {'Budget Code': 'B004', 'Description': 'On Job Training'},
    {'Budget Code': 'B005', 'Description': 'On Job Training'},
    {'Budget Code': 'B006', 'Description': 'On Job Training'},
    {'Budget Code': 'B007', 'Description': 'On Job Training'},
    {'Budget Code': 'B008', 'Description': 'On Job Training'},
    {'Budget Code': 'B009', 'Description': 'On Job Training'},
    {'Budget Code': 'B010', 'Description': 'On Job Training'}
  ];

  @override
  void initState() {
    super.initState();
    _tripCodeController.text = widget.tripData['tripID'];
    _tripDesController.text = widget.tripData['description'];
    _totalAmtController.text = widget.tripData['Total Amount'];
    _selectedCurrency = widget.tripData['currency'];
    _selectedDepartment = widget.tripData['department'];
    _dateController.text = widget.tripData['Date'];
    // chooseBudgetCodes =
    //     List<Map<String, dynamic>>.from(widget.tripData['BudgetDetails']);
    if (widget.tripData['BudgetDetails'] is String) {
      chooseBudgetCodes = List<Map<String, dynamic>>.from(
          jsonDecode(widget.tripData['BudgetDetails']));
    } else {
      chooseBudgetCodes =
          List<Map<String, dynamic>>.from(widget.tripData['BudgetDetails']);
    }
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
        'BudgetDetails': jsonEncode(chooseBudgetCodes),
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

  //Budget Alert Dialog
  void _showBudgetCodeDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          content: Stack(
            children: [
              Padding(
                padding: const EdgeInsets.only(
                    top: 20.0, left: 16.0, right: 16.0, bottom: 16.0),
                child: Column(
                  children: [
                    const Text(
                      "Select Budget Code",
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 10),
                    SingleChildScrollView(
                      scrollDirection: Axis.vertical,
                      child: SizedBox(
                        width: MediaQuery.of(context).size.width * 0.35,
                        height: MediaQuery.of(context).size.height * 0.7,
                        child: SingleChildScrollView(
                          child: DataTable(
                            showCheckboxColumn: false,
                            columns: const [
                              DataColumn(label: Text("")),
                              DataColumn(label: Text("Budget Code")),
                              DataColumn(label: Text("Description")),
                            ],
                            rows: BudgetDetails.map((budgetCode) {
                              bool isSelected = chooseBudgetCodes.any((code) =>
                                  code['Budget Code'] ==
                                  budgetCode['Budget Code']);

                              return DataRow(
                                cells: [
                                  DataCell(
                                    isSelected
                                        ? IconButton(
                                            icon: const Icon(Icons.check_circle,
                                                color: Colors.green),
                                            onPressed: () {
                                              setState(() {
                                                chooseBudgetCodes.removeWhere(
                                                    (code) =>
                                                        code['Budget Code'] ==
                                                        budgetCode[
                                                            'Budget Code']);
                                              });
                                              Navigator.pop(context);
                                              _showBudgetCodeDialog();
                                            },
                                          )
                                        : const SizedBox.shrink(),
                                  ),
                                  DataCell(Text(budgetCode['Budget Code'])),
                                  DataCell(Text(budgetCode['Description'])),
                                ],
                                onSelectChanged: (selected) {
                                  if (selected != null && selected) {
                                    if (isSelected) {
                                      // Show error message if the budget code is already selected
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        const SnackBar(
                                          content: Text(
                                              "This budget code is already selected."),
                                          duration: Duration(seconds: 2),
                                        ),
                                      );
                                    } else {
                                      setState(() {
                                        chooseBudgetCodes.add(budgetCode);
                                      });
                                      Navigator.pop(context);
                                    }
                                  }
                                },
                              );
                            }).toList(),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Positioned(
                top: 8,
                right: 8,
                child: IconButton(
                  icon: const Icon(Icons.cancel_outlined, color: Colors.black),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _deleteBudgetCode(int index) {
    // setState(() {
    //   chooseBudgetCodes.removeAt(index);
    // });
    if (index >= 0 && index < chooseBudgetCodes.length) {
      setState(() {
        chooseBudgetCodes.removeAt(index);
      });
    }
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
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Column(
                                children: [
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
                                ],
                              ),
                            ),
                            Expanded(
                                child: Column(
                              children: [
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
                                    decoration: const InputDecoration(),
                                    value: _selectedCurrency,
                                    items: ['MMK', 'USD'].map((currency) {
                                      return DropdownMenuItem(
                                          value: currency,
                                          child: Text(currency));
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
                                    value: _selectedDepartment,
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
                              ],
                            )),
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            children: [
                              ElevatedButton(
                                  onPressed: _showBudgetCodeDialog,
                                  style: ElevatedButton.styleFrom(
                                    textStyle: const TextStyle(fontSize: 15),
                                    backgroundColor: Colors.green,
                                    foregroundColor: Colors.black,
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 20, vertical: 12),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                  ),
                                  child: const Text("Add Budget Code")),
                              const SizedBox(height: 10),
                              Container(
                                height:
                                    MediaQuery.of(context).size.height * 0.3,
                                child: SingleChildScrollView(
                                  scrollDirection: Axis.vertical,
                                  child: DataTable(
                                    border: TableBorder.all(),
                                    showCheckboxColumn: false,
                                    columns: const [
                                      DataColumn(label: Text("Budget Code")),
                                      DataColumn(label: Text("Description")),
                                      DataColumn(label: Text("Action")),
                                    ],
                                    rows: chooseBudgetCodes.map((budgetCode) {
                                      final index =
                                          chooseBudgetCodes.indexOf(budgetCode);
                                      return DataRow(cells: [
                                        DataCell(
                                            Text(budgetCode['Budget Code'])),
                                        DataCell(
                                            Text(budgetCode['Description'])),
                                        DataCell(IconButton(
                                            onPressed: () {
                                              _deleteBudgetCode(index);
                                            },
                                            icon: const Icon(Icons.delete)))
                                      ]);
                                    }).toList(),
                                  ),
                                ),
                              )
                            ],
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
