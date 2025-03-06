import 'dart:convert';
import 'dart:math';
import 'package:advance_budget_request_system/views/api_service.dart';
import 'package:advance_budget_request_system/views/data.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

class Budgetcodeview extends StatefulWidget {
  const Budgetcodeview({super.key});

  @override
  State<Budgetcodeview> createState() => _BudgetcodeviewState();
}

class _BudgetcodeviewState extends State<Budgetcodeview> {
  // List<Map<String, dynamic>> budgetInformation = [];
  // List<dynamic> budgetInformation = [];
  // List<dynamic> filteredData = [];
  List<Budget> budgetInformation = [];
  List<Budget> filteredData = [];

  String searchQuery = '';
  final TextEditingController _searchingController = TextEditingController();

  Future<void> fetchBudgetCodes() async {
    final apiService = ApiService();
    try {
      List<Budget> data = await apiService.fetchBudgetCodeData();
      setState(() {
        budgetInformation = data;
        filteredData = data;
        // if (filteredData.isNotEmpty) {
        //   int maxID = filteredData
        //       .map((b) => int.parse(b.BudgetCode.split('-')[2]))
        //       .reduce((a, b) => a > b ? a : b);
        // }
      });
      print("Fetched Budget Codes: $data");
    } catch (e) {
      print("Error fetching data: $e");
    }
  }

  // void addnewBudgetcode(String BudgetCode, String Description) async {
  //   final apiService = ApiService();
  //   Map<String, dynamic> newbg = {
  //     "BudgetCode": BudgetCode,
  //     "Description": Description
  //   };

  //   bool success = await apiService.postBudgetCode(newbg);
  //   if (success) {
  //     setState(() {
  //       fetchBudgetCodes();
  //     });
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       SnackBar(content: Text("Budget Code added successfully!")),
  //     );
  //   } else {
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       SnackBar(content: Text("Failed to add Budget Code!")),
  //     );
  //   }
  // }

  @override
  void initState() {
    super.initState();
    fetchBudgetCodes();
  }

  // Searchbarfilter fuction
  void _searchFilter(String query) {
    setState(() {
      searchQuery = query;
      filteredData = budgetInformation
          .where((item) =>
              item.BudgetCode.toLowerCase().contains(query.toLowerCase()) ||
              item.Description.toLowerCase().contains(query.toLowerCase()))
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
            title: Text("Delete Confirmation"),
            content: Text("Are you sure to delete this Project Data?"),
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
          SizedBox(height: 10),
          Row(
            children: [
              SizedBox(
                height: 40,
                width: MediaQuery.of(context).size.width / 2,
                child: SearchBar(
                  controller: _searchingController,
                  onChanged: _searchFilter,
                  leading: Icon(Icons.search),
                  hintText: "Search",
                ),
              ),
              const SizedBox(
                width: 50,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  IconButton(
                    onPressed: () async {
                      // ignore: unused_local_variable
                      final List<Budget>? newBudget = await Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => BudgetCodeEntry(
                                      onBudgetAdded:
                                          (List<Budget> newBudgetList) {
                                    setState(() {
                                      _refreshTable();
                                      budgetInformation.addAll(newBudgetList);
                                    });
                                  })));
                    },
                    icon: Icon(Icons.add),
                    color: Colors.blueGrey,
                  ),
                  IconButton(
                    onPressed: () {
                      _refreshTable();
                    },
                    icon: Icon(Icons.refresh),
                    color: Colors.blueGrey,
                  ),
                  IconButton(
                    onPressed: () {},
                    icon: Icon(Icons.download),
                    color: Colors.blueGrey,
                  ),
                ],
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
                        // child: Text(row.'BudgetCode' ?? '1'),
                        child: Text(row.BudgetCode ?? '1'),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        // child: Text(row['Description'] ?? 'null'),
                        child: Text(row.Description ?? 'null'),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(0.0),
                        child: Row(
                          children: [
                            IconButton(
                              icon: const Icon(Icons.edit,
                                  color: Colors.blueGrey),
                              onPressed: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => BudgetCodeEdit(
                                            budgetInformation:
                                                budgetInformation[index],
                                            onBudgetUpdated: (updatedBudget) {
                                              setState(() {
                                                int index = budgetInformation
                                                    .indexWhere((element) =>
                                                        element.id ==
                                                        updatedBudget.id);

                                                if (index != -1) {
                                                  budgetInformation[index] =
                                                      updatedBudget;
                                                           // Ensure it's not a list
                                                  _refreshTable();
                                                } else {
                                                  print(
                                                      "Error: Budget code not found in the list.");
                                                }

                                                // int index = budgetInformation
                                                //     .indexOf(row);
                                                // budgetInformation[index] =
                                                //     updatedBudget;
                                                // _refreshTable();
                                                // budgetInformation[index] =
                                                //     updatedBudget;
                                              });
                                            })));
                                print("Edit for ${row.BudgetCode }");
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
                        ),
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
  //final Function(List<Map<String, dynamic>>) onBudgetAdded;
  final Function(List<Budget>) onBudgetAdded;

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
  final ApiService apiService = ApiService();

  String generateBudgetCodeID(int length) {
    const chars = 'abcdefghijklmnopqrstuvwxyz0123456789';
    Random rnd = Random();
    return length > 0
        ? List.generate(length, (_) => chars[rnd.nextInt(chars.length)]).join()
        : '0000';
  }

  void _submitForm() async {
    if (_formKey.currentState!.validate()) {
      Budget newBudgetAdd = Budget(
          id:generateBudgetCodeID(4),
          BudgetCode: _budgetcodeController.text,
          Description: _descriptionController.text,
          InitialAmount: 0);
          
          
      try {
        //print("Budget Payload:$newBudgetAdd");
        // Budget budgetObj = Budget.fromJson(newBudgetAdd);
        bool isSuccess = await apiService.postBudgetCode(newBudgetAdd);
        if (isSuccess) {
          widget.onBudgetAdded([newBudgetAdd]);
          Navigator.pop(context);
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Failed to add Budget Code: $e")),
        );
      }
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
        appBar: AppBar(title: Text("BudgetCode Entry Form")),
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
                      decoration: InputDecoration(
                          labelText: "Budget Code",
                          border: OutlineInputBorder()),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Please enter a budget code";
                        }
                        return null;
                      },
                    ),

                    SizedBox(
                      height: 10,
                    ),
                    // Description Field
                    TextFormField(
                      controller: _descriptionController,
                      decoration: InputDecoration(
                          labelText: "Description",
                          border: OutlineInputBorder()),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Please enter a description";
                        }
                        return null;
                      },
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ElevatedButton(
                            onPressed: () {
                              _submitForm();
                            },
                            child: Text("Submit")),
                        SizedBox(
                          width: 10,
                        ),
                        ElevatedButton(
                            onPressed: () {
                              _clearText();
                            },
                            child: Text("Cancel")),
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
  final Function(Budget) onBudgetUpdated;
  // final Map<String, dynamic> budgetInformation;
  final Budget budgetInformation;
  // final Function(Map<String, dynamic>) onBudgetUpdated;
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
  final ApiService apiService = ApiService();

  @override
  void initState() {
    super.initState();
    _budgetcodeController.text = widget.budgetInformation.BudgetCode;
    _descriptionController.text = widget.budgetInformation.Description;
  }

  String generateBudgetCodeID(int length) {
    const chars = 'abcdefghijklmnopqrstuvwxyz0123456789';
    Random rnd = Random();
    return length > 0
        ? List.generate(length, (_) => chars[rnd.nextInt(chars.length)]).join()
        : '0000';
  }

  Future<void> _submiteditForm() async {
    if (_formKey.currentState!.validate()) {
      Budget updatedBudget = Budget(
        id:widget.budgetInformation.id,
        // generateBudgetCodeID(4),
        BudgetCode: _budgetcodeController.text,
        Description: _descriptionController.text,
         InitialAmount: 0
        //InitialAmount: int.tryParse('')
        // Keep the existing status
      );
      try {
        //print("Budget Payload:$newBudgetAdd");
        // Budget budgetObj = Budget.fromJson(newBudgetAdd);
        bool isSuccess = await apiService.updateBudget(updatedBudget);
        if (isSuccess) {
          widget.onBudgetUpdated(updatedBudget);
          Navigator.pop(context);
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Failed to Update Budget Code: $e")),
        );
      }

      // bool success = await ApiService().upBudgetCode(widget. BudgetCode,updatedBudget);
      // if(success){
      //    widget.onBudgetUpdated(updatedBudget);
      // Navigator.pop(context);
      // }else {
      //   print('Failed to update Budget');
      // }
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
        title: Text("BudgetCode Edit Form"),
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
                      decoration: InputDecoration(
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
                      decoration: InputDecoration(labelText: 'Description'),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Please enter Description";
                        }
                        return null;
                      }),
                  SizedBox(
                    height: 10,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton(
                          onPressed: _submiteditForm, child: Text("Submit")),
                      SizedBox(
                        width: 10,
                      ),
                      ElevatedButton(
                          onPressed: () {
                            _clearText();
                          },
                          child: Text("Cancel"))
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
