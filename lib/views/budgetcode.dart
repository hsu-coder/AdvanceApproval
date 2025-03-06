import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

class Budgetcodeview extends StatefulWidget {
  const Budgetcodeview({super.key});

  @override
  State<Budgetcodeview> createState() => _BudgetcodeviewState();
}

class _BudgetcodeviewState extends State<Budgetcodeview> {
  List<Map<String, dynamic>> budgetInformation =
      List.generate(100, (int index) {
    return {
      'BudgetCode': 'B-$index',
      'Description': 'BudgetDescription $index',
      'Action': '',
    };
  });

  // List<Map<String, dynamic>> budgetInformation = [];

  Future<List<dynamic>> fetchBudgetCodeData() async {
    final response =
        await http.get(Uri.parse('http://localhost:3000/budgetInformation'));
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to load data');
    }
  }

  List<Map<String, dynamic>> filteredData = [];
  String searchQuery = '';

  final TextEditingController _searchingController = TextEditingController();

  void initState() {
    super.initState();
    filteredData = List.from(budgetInformation);
  }

  // Searchbarfilter fuction
  void _searchFilter(String query) {
    setState(() {
      searchQuery = query;
      filteredData = budgetInformation
          .where((item) =>
              item['BudgetCode'].toLowerCase().contains(query.toLowerCase()) ||
              item['Description'].toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

  //Refresh function
  void _refreshTable() {
    setState(() {
      _searchingController.clear();
      filteredData = List.from(budgetInformation);
    });
  }

  void _deleteConfirmation(int index) async {
    bool? confirm = await showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text("Delete Confirmation"),
            content: const Text("Are you sure to delete this Project Data?"),
            actions: [
              TextButton(
                  onPressed: () {
                    Navigator.of(context).pop(false);
                  },
                  child: const Text("Cancel")),
              TextButton(
                  onPressed: () {
                    Navigator.of(context).pop(true);
                  },
                  child: const Text("Delete")),
            ],
          );
        });

    if (confirm != null && confirm) {
      setState(() {
        filteredData.removeAt(index);
      });
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text("Project Data is deleted successfully")));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "BudgetCode Information",
            style: TextStyle(fontSize: 18),
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              SizedBox(
                height: 40,
                width: MediaQuery.of(context).size.width / 2,
                child: SearchBar(
                  controller: _searchingController,
                  onChanged: _searchFilter,
                  leading: const Icon(Icons.search),
                  hintText: "Search",
                ),
              ),
              const SizedBox(
                width: 50,
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                  // width: MediaQuery.of(context).size.width*0.1,
                  borderRadius: BorderRadius.circular(20),
                  color: const Color.fromARGB(255, 150, 212, 234),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    IconButton(
                      onPressed: () async {
                        // ignore: unused_local_variable
                        final List<Map<String, dynamic>>? newBudget =
                            await Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => BudgetCodeEntry(
                                            onBudgetAdded: (newBudget) {
                                          setState(() {
                                            _refreshTable();
                                            budgetInformation.addAll(newBudget);
                                          });
                                        })));
                      },
                      icon: const Icon(Icons.add),
                      color: Colors.blueGrey,
                    ),
                    IconButton(
                      onPressed: () {
                        _refreshTable();
                      },
                      icon: const Icon(Icons.refresh),
                      color: Colors.blueGrey,
                    ),
                    IconButton(
                      onPressed: () {},
                      icon: const Icon(Icons.download),
                      color: Colors.blueGrey,
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 20,
          ),
          Table(
            border: const TableBorder.symmetric(
              inside: BorderSide(color: Colors.grey, width: 1),
              outside: BorderSide(color: Colors.grey, width: 1),
            ),
            columnWidths: const {
              0: FlexColumnWidth(0.5),
              1: FlexColumnWidth(2.5),
              2: FlexColumnWidth(2.5),
            },
            children: const [
              TableRow(
                  decoration:
                      BoxDecoration(color: Color.fromARGB(255, 167, 230, 232)),
                  children: [
                    Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text("BudgetCode",
                          style: TextStyle(fontWeight: FontWeight.bold)),
                    ),
                    Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text("Description",
                          style: TextStyle(fontWeight: FontWeight.bold)),
                    ),
                    Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text("Action",
                          style: TextStyle(fontWeight: FontWeight.bold)),
                    ),
                  ])
            ],
          ),
          Expanded(
            child: SingleChildScrollView(
              child: Table(
                  border: const TableBorder.symmetric(
                    inside: BorderSide(color: Colors.grey, width: 1),
                    outside: BorderSide(color: Colors.grey, width: 1),
                  ),
                  columnWidths: const {
                    0: FlexColumnWidth(0.5),
                    1: FlexColumnWidth(2.5),
                    2: FlexColumnWidth(2.5),
                  },
                  children: filteredData.asMap().entries.map((entry) {
                    int index = entry.key;
                    var row = entry.value;
                    return TableRow(children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(row['BudgetCode'] ?? '1'),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(row['Description'] ?? 'null'),
                      ),
                      Row(
                        children: [
                          IconButton(
                            icon:
                                const Icon(Icons.edit, color: Colors.blueGrey),
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => BudgetCodeEdit(
                                          budgetInformation:
                                              budgetInformation[index],
                                          onBudgetUpdated: (updatedBudget) {
                                            setState(() {
                                              _refreshTable();
                                              budgetInformation[index] =
                                                  updatedBudget;
                                            });
                                          })));
                              //  print("Edit for ${row["Project Code"]}");
                            },
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete,
                                color: Colors.blueGrey),
                            onPressed: () {
                              _deleteConfirmation(index);
                              //  print("Edit for ${row["Project Code"]}");
                            },
                          ),
                        ],
                      )
                    ]);
                  }).toList()),
            ),
          )
        ],
      ),
    ));
  }
}

class BudgetCodeEntry extends StatefulWidget {
  final Function(List<Map<String, dynamic>>) onBudgetAdded;

  const BudgetCodeEntry({Key? key, required this.onBudgetAdded})
      : super(key: key);

  //const BudgetCodeEntry({super.key});
  @override
  State<BudgetCodeEntry> createState() => _BudgetCodeEntryState();
}

class _BudgetCodeEntryState extends State<BudgetCodeEntry> {
  //budgetEntry form initialize variable
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _budgetcodeController = TextEditingController();

  final TextEditingController _descriptionController = TextEditingController();

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      List<Map<String, dynamic>> newProject = [
        {
          "BudgetCode": _budgetcodeController.text,
          "Description": _descriptionController.text,
        }
      ];
      widget.onBudgetAdded(newProject);
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text("BudgetCode Entry Form")),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Center(
            child: Container(
              width: MediaQuery.of(context).size.width / 3,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color.fromARGB(255, 149, 239, 233),
                borderRadius: BorderRadius.circular(15), // Rounded corners
                border:
                    Border.all(color: Colors.black, width: 1), // Border color
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.3), // Shadow color
                    blurRadius: 10,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Budget Code Field
                    TextFormField(
                      controller: _budgetcodeController,
                      decoration: const InputDecoration(
                          labelText: "Budget Code",
                          border: OutlineInputBorder()),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Please enter a budget code";
                        }
                        return null;
                      },
                    ),

                    const SizedBox(
                      height: 10,
                    ),
                    // Description Field
                    TextFormField(
                      controller: _descriptionController,
                      decoration: const InputDecoration(
                          labelText: "Description",
                          border: OutlineInputBorder()),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Please enter a description";
                        }
                        return null;
                      },
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ElevatedButton(
                            onPressed: () {
                              _submitForm();
                            },
                            child: const Text("Submit")),
                        const SizedBox(
                          width: 10,
                        ),
                        ElevatedButton(onPressed: () {}, child: const Text("Cancel")),
                      ],
                    )
                  ],
                ),
              ),
            ),
          ),
        ));
  }
}

class BudgetCodeEdit extends StatefulWidget {
  final Map<String, dynamic> budgetInformation;

  final Function(Map<String, dynamic>) onBudgetUpdated;
  const BudgetCodeEdit(
      {Key? key,
      required this.budgetInformation,
      required this.onBudgetUpdated})
      : super(key: key);

  // const BudgetCodeEdit({super.key});

  @override
  State<BudgetCodeEdit> createState() => _BudgetCodeEditState();
}

class _BudgetCodeEditState extends State<BudgetCodeEdit> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _budgetcodeController = TextEditingController();

  final TextEditingController _descriptionController = TextEditingController();

  void initState() {
    super.initState();

    _budgetcodeController.text = widget.budgetInformation['BudgetCode'];
    _descriptionController.text = widget.budgetInformation['Description'];
  }

  void _submiteditForm() {
    if (_formKey.currentState!.validate()) {
      Map<String, dynamic> updatedBudget = {
        'BudgetCode': _budgetcodeController.text,
        'Description': _descriptionController.text,
        // Keep the existing status
      };

      widget.onBudgetUpdated(updatedBudget);
      Navigator.pop(context);
    }
  }

  void _clearText() {
    setState(() {
      _descriptionController.clear();
      _budgetcodeController.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("BudgetCode Edit Form"),
      ),
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
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextFormField(
                      controller: _budgetcodeController,
                      decoration: const InputDecoration(
                        labelText: 'BudgetCode',
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Please enter BudgetCode";
                        }
                        return null;
                      }),
                  TextFormField(
                      controller: _descriptionController,
                      decoration: const InputDecoration(labelText: 'Description'),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Please enter Description";
                        }
                        return null;
                      }),
                  const SizedBox(
                    height: 10,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton(
                          onPressed: _submiteditForm, child: const Text("Submit")),
                      const SizedBox(
                        width: 10,
                      ),
                      ElevatedButton(
                          onPressed: () {
                            _clearText();
                          },
                          child: const Text("Cancel"))
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
