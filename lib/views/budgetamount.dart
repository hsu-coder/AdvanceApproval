import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'dart:html' as html;
import 'package:advance_budget_request_system/views/api_service.dart';
import 'package:advance_budget_request_system/views/data.dart';
import 'package:csv/csv.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';

class Budgetamount extends StatefulWidget {
  const Budgetamount({super.key});
  @override
  State<Budgetamount> createState() => _BudgetamountState();
}

class _BudgetamountState extends State<Budgetamount> {
  List<Budget> budgetamountInformation = [];
  List<Budget> filteredBudgetAmount = [];
  String searchQuery = '';
  TextEditingController _searchingController = TextEditingController();
  final NumberFormat thousandSeparator = NumberFormat("#,##0", "en_US");

  // Pagination variables
  int rowsPerPage = 10;
  int currentPage = 1;
  int totalPages = 1;

  String? sortColumn;
  bool sortAscending = true;

  // List<Map<String, dynamic>> filteredBudgetAmount = [];
  Future<void> fetchBudgetAmount() async {
    final apiService = ApiService();
    try {
      List<Budget> data = await apiService.fetchBudgetCodeData();
      setState(() {
        budgetamountInformation = data;
        filteredBudgetAmount = data;
        _updatePagination();
        // if (filteredBudgetAmount.isNotEmpty) {
        //   int maxID = filteredBudgetAmount
        //       .map((b) => int.parse(b.BudgetCode.split('-')[2]))
        //       .reduce((a, b) => a > b ? a : b);
        // }
      });
      //  print("Fetched Budget Amount: $data");
    } catch (e) {
      print("Error fetching data: $e");
    }
  }

  @override
  void initState() {
    super.initState();
    fetchBudgetAmount();
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
      totalPages = (filteredBudgetAmount.length / rowsPerPage).ceil();
      if (currentPage > totalPages && totalPages != 0) {
        currentPage = totalPages;
      } else if (totalPages == 0) {
        currentPage = 1;
      }
    });
  }

  List<Budget> get paginatedData {
    int start = (currentPage - 1) * rowsPerPage;
    int end = start + rowsPerPage < filteredBudgetAmount.length
        ? start + rowsPerPage
        : filteredBudgetAmount.length;
    return filteredBudgetAmount.sublist(start, end);
  }

  // Searchbarfilter fuction
  void _searchFilter(String query) {
    setState(() {
      searchQuery = query;
      filteredBudgetAmount = budgetamountInformation
          .where((item) =>
              item.BudgetCode!.toLowerCase().contains(query.toLowerCase()) ||
              item.Description!.toLowerCase().contains(query.toLowerCase()) ||
              item.InitialAmount.toString().contains(query.toLowerCase()))
          .toList();
    });
    _updatePagination();
  }

  //Refresh function
  void _refreshbudgetamountTable() {
    setState(() {
      _searchingController.clear();
      filteredBudgetAmount = List.from(budgetamountInformation);
      sortColumn = null;
      sortAscending = true;
      currentPage = 1;
      _updatePagination();
    });
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
      for (var budget in budgetamountInformation) {
        csvData.add([
          budget.BudgetCode,
          budget.Description,
          budget.InitialAmount
      
        ]);
      }

      String csv = const ListToCsvConverter().convert(csvData);
      if (kIsWeb) {
        final bytes = utf8.encode(csv);
        final blob = html.Blob([bytes]);
        final url = html.Url.createObjectUrlFromBlob(blob);
        final anchor = html.AnchorElement(href: url)
          ..setAttribute("download", "budgetAmount.csv")
          ..click();

        html.Url.revokeObjectUrl(url);
        print("CSV file downloaded in browser");
      } else {
        final directory = await getApplicationDocumentsDirectory();
        final path = "${directory.path}/budgetAmount.csv";
        final file = File(path);
        await file.writeAsString(csv);
      }
    } catch (e) {
      print("Error exporting to CSV: $e");
    }
  }

//Sorting Column
  void _sortDataColumn(String column) {
    setState(() {
      if (sortColumn == column) {
        sortAscending = !sortAscending;
      } else {
        sortColumn = column;
        sortAscending = true;
      }

      filteredBudgetAmount.sort((a, b) {
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
          case 'InitialAmount':
            aValue = a.InitialAmount;
            bValue = b.InitialAmount;
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
                "BudgetAmount Information",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
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
                const SizedBox(width: 20),
                // IconButton(
                //     onPressed: () {},
                //     icon: Icon(
                //       Icons.add,
                //       color: Colors.blueGrey,
                //     )),
                Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: const Color.fromARGB(255, 150, 212, 234),
                    ),
                    child: Row(children: [
                      IconButton(
                          onPressed: () {
                            _refreshbudgetamountTable();
                          },
                          icon: const Icon(
                            Icons.refresh,
                            color: Colors.black,
                          )),
                      IconButton(
                          onPressed: exportToCSV,
                          icon: const Icon(
                            Icons.download,
                            color: Colors.black,
                          ))
                    ]))
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
                0: FlexColumnWidth(1.5),
                1: FlexColumnWidth(2.5),
                2: FlexColumnWidth(2.5),
                3: FlexColumnWidth(2.5)
              },
              children: [
                TableRow(
                    decoration: const BoxDecoration(
                        color: Color.fromARGB(255, 167, 230, 232)),
                    children: [
                      Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: _buildHeaderCell("BudgetCode", "BudgetCode")
                          // Text("BudgetCode",
                          //     style: TextStyle(fontWeight: FontWeight.bold)),
                          ),
                      Padding(
                          padding: const EdgeInsets.all(8.0),
                          child:
                              _buildHeaderCell("Description", "Description")),
                      Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: _buildHeaderCell(
                              "InitialAmount", "InitialAmount")),
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
                    0: FlexColumnWidth(1.5),
                    1: FlexColumnWidth(2.5),
                    2: FlexColumnWidth(2.5),
                    3: FlexColumnWidth(2.5)
                  },
                  children: paginatedData.asMap().entries.map((entry) {
                    int index = entry.key;
                    var row = entry.value;
                    return TableRow(children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(row.BudgetCode ?? 'null'),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(row.Description ?? 'null'),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          thousandSeparator.format(int.tryParse(
                              row.InitialAmount?.toString() ?? '0')),
                          textAlign: TextAlign.right,
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          IconButton(
                              onPressed: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            BudgetInitialAmount(
                                                budgetamountInformation:
                                                    budgetamountInformation[
                                                        index],
                                                OnBudgetAmountUpdated:
                                                    (AddInitialAmount) {
                                                  setState(() {
                                                    int index =
                                                        budgetamountInformation
                                                            .indexWhere((element) =>
                                                                element.id ==
                                                                AddInitialAmount
                                                                    .id);

                                                    if (index != -1) {
                                                      budgetamountInformation[
                                                              index] =
                                                          AddInitialAmount;

                                                      _refreshbudgetamountTable();
                                                    } else {
                                                      print(
                                                          "Error: Budget code not found in the list.");
                                                    }
                                                  });
                                                })));
                              },
                              icon: const Icon(
                                Icons.input,
                                color: Colors.black,
                              )),
                        ],
                      )
                    ]);
                  }).toList()),
            )),
            _buildPaginationControls()
          ],
        ),
      ),
    );
  }
}

class BudgetInitialAmount extends StatefulWidget {
  //  final Map<String, dynamic> budgetamountInformation;

  final Budget budgetamountInformation;
  //final Function(Map<String, dynamic>) OnBudgetAmountUpdated;
  final Function(Budget) OnBudgetAmountUpdated;

  const BudgetInitialAmount(
      {Key? key,
      required this.budgetamountInformation,
      required this.OnBudgetAmountUpdated})
      : super(key: key);

  @override
  State<BudgetInitialAmount> createState() => _BudgetInitialAmountState();
}

class _BudgetInitialAmountState extends State<BudgetInitialAmount> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _budgetCodeController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _initialamountController =
      TextEditingController();
  final ApiService apiService = ApiService();
  String generateBudgetAmountID(int length) {
    const chars = 'abcdefghijklmnopqrstuvwxyz0123456789';
    Random rnd = Random();
    return length > 0
        ? List.generate(length, (_) => chars[rnd.nextInt(chars.length)]).join()
        : '0000';
  }

  void initState() {
    super.initState();
    _budgetCodeController.text =
        widget.budgetamountInformation.BudgetCode ?? '';
    _descriptionController.text =
        widget.budgetamountInformation.Description ?? '';
    _initialamountController.text =
        widget.budgetamountInformation.InitialAmount?.toString() ?? '';
  }

  void _submitInitialAmount() async {
    if (_formKey.currentState!.validate()) {
      Budget AddInitialAmount = Budget(
          id: widget.budgetamountInformation.id,
          BudgetCode: _budgetCodeController.text,
          Description: _descriptionController.text,
          InitialAmount: double.parse(_initialamountController.text),
          ReviseAmount: 0.0,
          BudgetAmount: 0.0,
          Amount: 0);

      try {
        bool isSuccess = await apiService.updateBudget(AddInitialAmount);
        if (isSuccess) {
          widget.OnBudgetAmountUpdated(AddInitialAmount);
          Navigator.pop(context);
          ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Budget Initial amount can be added successfully!!")),
        );
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Failed to add BudgetAmount: $e")),
        );
      }
      // {
      //   'BudgetCode': _budgetCodeController.text,
      //   'Description': _descriptionController.text,
      //   'InitialAmount': _initialamountController.text,
      // };

      // widget.OnBudgetAmountUpdated(UpdatedInitialAmount);
      // Navigator.pop(context);
    }
  }

  void _clearText() {
    setState(() {
      _initialamountController.clear();
    });
  }

  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text("Initial Budget Amount")),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Center(
            child: Container(
                width: MediaQuery.of(context).size.width / 3,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 103, 207, 177),
                  borderRadius: BorderRadius.circular(15), // Rounded corners
                  // border: Border.all(color: Colors.black, width: 1),
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
                      TextFormField(
                        controller: _budgetCodeController,
                        decoration: const InputDecoration(
                          labelText: 'BudgetCode',
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Please enter BudgetCode";
                          }
                          return null;
                        },
                        readOnly: true,
                      ),
                      TextFormField(
                        controller: _descriptionController,
                        decoration:
                            const InputDecoration(labelText: 'Description'),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Please enter Description";
                          }
                          return null;
                        },
                        readOnly: true,
                      ),
                      TextFormField(
                        controller: _initialamountController,
                        decoration:
                            const InputDecoration(labelText: 'InitialAmount'),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Please enter InitialAmount";
                          }
                          final amount = double.tryParse(value);
                          if (amount == null) {
                            return "Enter a valid amount";
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
                                _submitInitialAmount();
                              },
                              child: const Text("Submit",
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
                )),
          ),
        ));
  }
}
