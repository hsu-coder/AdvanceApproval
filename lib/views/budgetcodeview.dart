import 'dart:convert';
import 'dart:html' as html;
import 'dart:io';
import 'dart:math';
import 'package:advance_budget_request_system/views/api_service.dart';
import 'package:advance_budget_request_system/views/data.dart';
import 'package:csv/csv.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

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
  // Pagination variables
  int rowsPerPage = 10;
  int currentPage = 1;
  int totalPages = 1;

  String? sortColumn;
  bool sortAscending = true;

  String searchQuery = '';
  final TextEditingController _searchingController = TextEditingController();

  Future<void> fetchBudgetCodes() async {
    final apiService = ApiService();
    try {
      List<Budget> data = await apiService.fetchBudgetCodeData();
      setState(() {
        budgetInformation = data;
        filteredData = data;
        _updatePagination();
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

  // Build Pagination Controls

  Widget _buildPaginationControls() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Previous Button
          IconButton(
            onPressed: currentPage > 1
                ? () {
                    setState(() {
                      currentPage--;
                      _updatePagination();
                    });
                  }
                : null,
            icon: const Icon(Icons.arrow_back),
          ),
          // Page Indicator
          Text('Page $currentPage of $totalPages'),
          // Next Button
          IconButton(
            onPressed: currentPage < totalPages
                ? () {
                    setState(() {
                      currentPage++;
                      _updatePagination();
                    });
                  }
                : null,
            icon: const Icon(Icons.arrow_forward),
          ),
          const SizedBox(width: 20),
          // Rows per page selector
          DropdownButton<int>(
            value: rowsPerPage,
            items: [10, 15, 20].map((int value) {
              return DropdownMenuItem<int>(
                value: value,
                child: Text('$value rows'),
              );
            }).toList(),
            onChanged: (value) {
              if (value != null) {
                setState(() {
                  rowsPerPage = value;
                  currentPage =
                      1; // Reset to page 1 when rows per page is changed
                  _updatePagination();
                });
              }
            },
          ),
        ],
      ),
    );
  }

  // Pagination update
  void _updatePagination() {
    setState(() {
      totalPages = (filteredData.length / rowsPerPage).ceil();
      if (currentPage > totalPages && totalPages != 0) {
        currentPage = totalPages;
      } else if (totalPages == 0) {
        currentPage = 1;
      }
    });
  }

  List<Budget> get paginatedData {
    int start = (currentPage - 1) * rowsPerPage;
    int end = start + rowsPerPage < filteredData.length
        ? start + rowsPerPage
        : filteredData.length;
    return filteredData.sublist(start, end);
  }

  //download button to export CSV
  Future<void> exportToCSV() async {
    try {
      List<List<dynamic>> csvData = [];

      //Add the header row
      csvData.add([
        "Budget Code",
        "Budget Description",
      ]);

      //Add the data rows
      for (var budget in budgetInformation) {
        csvData.add([budget.BudgetCode, budget.Description]);
      }

      String csv = const ListToCsvConverter().convert(csvData);
      if (kIsWeb) {
        final bytes = utf8.encode(csv);
        final blob = html.Blob([bytes]);
        final url = html.Url.createObjectUrlFromBlob(blob);
        final anchor = html.AnchorElement(href: url)
          ..setAttribute("download", "budget.csv")
          ..click();

        html.Url.revokeObjectUrl(url);
        print("CSV file downloaded in browser");
      } else {
        final directory = await getApplicationDocumentsDirectory();
        final path = "${directory.path}/budget.csv";
        final file = File(path);
        await file.writeAsString(csv);
      }
    } catch (e) {
      print("Error exporting to CSV: $e");
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
    _updatePagination();
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
    _updatePagination();
  }

  //Refresh function
  void _refreshTable() {
    setState(() {
      _searchingController.clear();
      filteredData = List.from(budgetInformation);
      fetchBudgetCodes();
      sortColumn = null;
      sortAscending = true;
      currentPage = 1;
      _updatePagination();
    });
  }

  void _deleteConfirmation(Budget bg) async {
    bool? confirm = await showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text("Delete Confirmation"),
            content: const Text("Are you sure to delete this BudgetCode?"),
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
      try {
        await ApiService().deleteBudget(bg.id);
        setState(() {
          budgetInformation.removeWhere((item) => item.id == bg.id);
          filteredData.remove(bg);
        });

        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text("BudgetCode Data is deleted successfully")));
      } catch (e) {
        print('Failed to delete Budgetcode');
      }
    }
  }

  void _sortDataColumn(String column) {
    setState(() {
      if (sortColumn == column) {
        sortAscending = !sortAscending;
      } else {
        sortColumn = column;
        sortAscending = true;
      }

      filteredData.sort((a, b) {
        dynamic aValue;
        dynamic bValue;

        switch (column) {
          case 'BudgetCode':
            aValue = a.BudgetCode;
            bValue = b.BudgetCode;
            break;
          case 'Description':
            aValue = a.Description;
            bValue = b.Description;
            break;
          default:
            return 0;
        }

        if (aValue == null || bValue == null) return 0;

        if (sortAscending) {
          return aValue.compareTo(bValue);
        } else {
          return bValue.compareTo(aValue);
        }
      });
      _updatePagination();
    });
  }

  Widget _buildHeaderCell(String label, String column) {
    return InkWell(
      onTap: () {
        _sortDataColumn(column);
      },
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: [
            Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
            if (sortColumn == column)
              Icon(
                sortAscending ? Icons.arrow_upward : Icons.arrow_downward,
                size: 16,
              )
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Center(
            child: Text(
              "BudgetCode Information",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  height: 50,
                  width: MediaQuery.of(context).size.width * 0.5,
                  child: TextField(
                    controller: _searchingController,
                    onChanged: _searchFilter,
                    decoration: const InputDecoration(
                      labelText: 'Search',
                      prefixIcon: Icon(Icons.search),
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
              ),
              const SizedBox(
                width: 20,
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
                      icon: const Icon(Icons.add),
                      color: Colors.black,
                    ),
                    IconButton(
                      onPressed: () {
                        _refreshTable();
                      },
                      icon: const Icon(Icons.refresh),
                      color: Colors.black,
                    ),
                    IconButton(
                      onPressed: exportToCSV,
                      icon: const Icon(Icons.download),
                      color: Colors.black,
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
              0: FlexColumnWidth(0.8),
              1: FlexColumnWidth(2.5),
              2: FlexColumnWidth(2.5),
            },
            children: [
              TableRow(
                  decoration: const BoxDecoration(
                      color: Color.fromARGB(255, 167, 230, 232)),
                  children: [
                    Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: _buildHeaderCell("BudgetCode", "BudgetCode")
                        //  Text("BudgetCode",
                        //     style: TextStyle(fontWeight: FontWeight.bold)),
                        ),
                    Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: _buildHeaderCell("Description", "Description")
                        //  Text("Description",
                        //     style: TextStyle(fontWeight: FontWeight.bold)),
                        ),
                    const Padding(
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
                    0: FlexColumnWidth(0.8),
                    1: FlexColumnWidth(2.5),
                    2: FlexColumnWidth(2.5),
                  },
                  children: paginatedData.asMap().entries.map((entry) {
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
                              icon: const Icon(Icons.edit, color: Colors.black),
                              onPressed: () {
                                int actualIndex =
                                    (currentPage - 1) * rowsPerPage + index;
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => BudgetCodeEdit(
                                            budgetInformation:
                                                budgetInformation[actualIndex],
                                            onBudgetUpdated: (updatedBudget) {
                                              setState(() {
                                                int index = budgetInformation
                                                    .indexWhere((element) =>
                                                        element.id ==
                                                        updatedBudget.id);
                                                _updatePagination();

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
                                print("Edit for ${row.BudgetCode}");
                              },
                            ),
                            IconButton(
                              icon:
                                  const Icon(Icons.delete, color: Colors.black),
                              onPressed: () {
                                _deleteConfirmation(row);
                                //  print("Edit for ${row["Project Code"]}");
                              },
                            ),
                          ],
                        ),
                      )
                    ]);
                  }).toList()),
            ),
          ),
          _buildPaginationControls()
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

  Future<int> generateBudgetCodeID() async {
    List<Budget> existingBudgets = await apiService.fetchBudgetCodeData();

    if (existingBudgets.isEmpty) {
      return 1; // Start from 1 if no budget exists
    }

    // Find the highest existing ID
    int maxId =
        existingBudgets.map((b) => b.id).reduce((a, b) => a > b ? a : b);
    return maxId + 1;
  }

  void _submitForm() async {
    if (_formKey.currentState!.validate()) {
      try {
        List<Budget> existingBudgets = await apiService.fetchBudgetCodeData();

        bool isDuplicate = existingBudgets
            .any((budget) => budget.BudgetCode == _budgetcodeController.text);
        if (isDuplicate) {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
              content: Text(
                  "Budget Code already exists!Please enter a unique code")));
          return;
        }
        int newId = await generateBudgetCodeID();
        print('newid= $newId');
        Budget newBudgetAdd = Budget(
          id: newId,
          BudgetCode: _budgetcodeController.text,
          Description: _descriptionController.text,
          InitialAmount: 0,
          ReviseAmount: 0,
          BudgetAmount: 0,
          Amount: 0,
        );

        //print("Budget Payload:$newBudgetAdd");
        // Budget budgetObj = Budget.fromJson(newBudgetAdd);
        bool isSuccess = await apiService.postBudgetCode(newBudgetAdd);
        if (isSuccess) {
          widget.onBudgetAdded([newBudgetAdd]);
          Navigator.pop(context);
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
                content:
                    Text("Budget Information can be added successfully!!")),
          );
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
        appBar: AppBar(title: const Text("BudgetCode Entry Form")),
        body: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Center(
            child: Container(
              width: MediaQuery.of(context).size.width / 3,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color.fromARGB(255, 103, 207, 177),
                borderRadius: BorderRadius.circular(15), // Rounded corners
                // border:
                //     Border.all(color: Colors.black, width: 1), // Border color
                // boxShadow: [
                //   BoxShadow(
                //     color: Colors.grey.withOpacity(0.3), // Shadow color
                //     blurRadius: 10,
                //     offset: const Offset(0, 5),
                //   ),
                // ],
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
                        // RegExp regex = RegExp(r'^B-(\d{1,3}|1000)$');
                        // if (!regex.hasMatch(value)) {
                        //   return "Budget Code must be in format B-1 to B-1000";
                        // }

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
                            child: const Text(
                              "Submit",
                              style: TextStyle(color: Colors.black),
                            )),
                        const SizedBox(
                          width: 10,
                        ),
                        ElevatedButton(
                            onPressed: () {
                              _clearText();
                            },
                            child: const Text("Clear",
                                style: TextStyle(color: Colors.black))),
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

  // String generateBudgetCodeID(int length) {
  //   const chars = 'abcdefghijklmnopqrstuvwxyz0123456789';
  //   Random rnd = Random();
  //   return length > 0
  //       ? List.generate(length, (_) => chars[rnd.nextInt(chars.length)]).join()
  //       : '0000';
  // }

  Future<void> _submiteditForm() async {
    if (_formKey.currentState!.validate()) {
      Budget updatedBudget = Budget(
          id: widget.budgetInformation.id,
          // generateBudgetCodeID(4),
          BudgetCode: _budgetcodeController.text,
          Description: _descriptionController.text,
          InitialAmount: 0,
          ReviseAmount: 0,
          BudgetAmount: 0,
          Amount: 0
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
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
                content:
                    Text("Budget informaiton can be updated successfully!!")),
          );
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
        title: const Text("BudgetCode Edit Form"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: Container(
            width: MediaQuery.of(context).size.width / 3,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color.fromARGB(255, 103, 207, 177),
              borderRadius: BorderRadius.circular(15), // Rounded corners
              //   border: Border.all(color: Colors.black, width: 1), // Border color
              //   boxShadow: [
              //     BoxShadow(
              //       color: Colors.grey.withOpacity(0.3), // Shadow color
              //       blurRadius: 10,
              //       offset: const Offset(0, 5),
              //     ),
              //   ],
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
                      decoration:
                          const InputDecoration(labelText: 'Description'),
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
                          onPressed: _submiteditForm,
                          child: const Text("Update",
                              style: TextStyle(color: Colors.black))),
                      const SizedBox(
                        width: 10,
                      ),
                      ElevatedButton(
                          onPressed: () {
                            _clearText();
                          },
                          child: const Text("Clear",
                              style: TextStyle(color: Colors.black)))
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
