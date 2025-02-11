import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class budgetcode extends StatefulWidget {
  @override
  State<budgetcode> createState() => _budgetcodeState();
}

class _budgetcodeState extends State<budgetcode> {
  String selectedRequester = '';
  DateTimeRange? selectedDateRange;
  DateTime? startDate;
  DateTime? endDate;
  dynamic hoverRow;
  String? selectedDateFilter;
  DateTimeRange? customDateRange;

  // formfield controller
  final TextEditingController _searchingController = TextEditingController();
  final TextEditingController _dateController = TextEditingController(
      text:"${DateFormat('yyyy-MM-dd').format(DateTime.now())}"
          //"${DateTime.now().year}-${DateTime.now().month}-${DateTime.now().day}"
          );
  final TextEditingController _revisedAmountController =
      TextEditingController(text: "0");
  final TextEditingController _budget_codeController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _initialAmountController =
      TextEditingController();
  String _selectedCurrency = '';

  final numberFormat = NumberFormat("#,##0");

  //List<Map<String, dynamic>> budgetInfo = [];
  List<Map<String, dynamic>> budgetInfo = List.generate(100, (int index) {
    return {
      'Date': DateTime.now().add(Duration(days: index * 30)),
      'Budget_Code': 'B- $index',
      'Description': 'BudgetDescription $index',
      'Initial_Amount': 400000,
      'Revised_Amount': 0,
      'Currency': 'MMK',
      'Action': '',
    };
  });
  String? sortColumn;
  bool isAscending = true;
  List<Map<String, dynamic>> filteredData = [];
  String searchQuery = '';

//budgetEntry form initialize variable
  final _formKey = GlobalKey<FormState>();
 

  //function of Add popup
  void _showBudgetPopup(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: const Color.fromARGB(255, 189, 231, 248),
          title: Text("Add New Budget"),
          content: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                //date field
                TextFormField(
                  controller: _dateController,
                  decoration: InputDecoration(
                      labelText: "Date", border: OutlineInputBorder()),
                  readOnly: true,
                ),

                SizedBox(
                  height: 10,
                ),

                // Budget Code Field
                TextFormField(
                  controller: _budget_codeController,
                  decoration: InputDecoration(
                      labelText: "Budget Code", border: OutlineInputBorder()),
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
                      labelText: "Description", border: OutlineInputBorder()),
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

                // Initial Amount Field
                TextFormField(
                  controller: _initialAmountController,
                  decoration: InputDecoration(
                      labelText: "Initial_Amount",
                      border: OutlineInputBorder()),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null ||
                        value.isEmpty ||
                        double.tryParse(value) == null) {
                      return "Please enter a valid amount";
                    }
                    return null;
                  },
                ),

                SizedBox(
                  height: 10,
                ),

                TextFormField(
                  controller: _revisedAmountController,
                  decoration: InputDecoration(
                      labelText: "Revised_Amount",
                      border: OutlineInputBorder()),
                  readOnly: true, // Prevent editing
                ),

                SizedBox(
                  height: 10,
                ),

                DropdownButtonFormField(
                    decoration: InputDecoration(
                        labelText: "Currency", 
                        border: OutlineInputBorder()),
                        items: ['MMK', 'USD'].map((String currency) {
                            return DropdownMenuItem<String>(
                              value: currency, child: Text(currency));
                        }).toList(),
                    onChanged: (newValue) {
                      _selectedCurrency = newValue!;
                    },
                    validator: (value) =>
                        value == null ? 'Please select a currency' : null),
              ],
            ),
          ),
          actions: [
            // Cancel Button
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the popup
              },
              child: const Text("Cancel"),
            ),
            // Submit Button
            ElevatedButton(
              onPressed: () {
                if (_dateController.text.isEmpty ||
                    _budget_codeController.text.isEmpty ||
                    _descriptionController.text.isEmpty ||
                    _initialAmountController.text.isEmpty ||
                    _revisedAmountController.text.isEmpty ||
                    _selectedCurrency.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Please fill all the fields!!')));
                  return;
                }
                _submit();
              },
              child: const Text("Submit"),
            ),
          ],
        );
      },
    );
  }

//  // submit button function of add popup
  void _submit() {
    if (_formKey.currentState!.validate()) {
      // _formKey.currentState!.save(); // Save form data
      setState(() {
        DateTime parsedDate =
            DateFormat('yyyy-MM-dd').parse(_dateController.text);
        // Add new entry to the existing list
        budgetInfo.add({
          'Date': _dateController.text.isEmpty ? "Unknown Date" : parsedDate,
          'Budget_Code': _budget_codeController.text.isEmpty
              ? "Unknown Code"
              : _budget_codeController.text,
          'Description': _descriptionController.text.isEmpty
              ? "No Description"
              : _descriptionController.text,
          'Initial_Amount': _initialAmountController.text.isEmpty
              ? "0"
              :  _initialAmountController.text,
          'Revised_Amount': _revisedAmountController.text.isEmpty
              ? "0"
              : _revisedAmountController.text,
          'Currency': _selectedCurrency ?? "Unknown Currency",
        });
        filteredData = List.from(budgetInfo); // Update filtered data
//         print(budgetInfo);
//        print(budgetInfo.runtimeType);
//        Map<String, dynamic> item = budgetInfo[0]; // Get first index
//       item.forEach((key, value) {
//   print("$key: ${value.runtimeType}");
// });
      });
      Navigator.of(context).pop(); // Close the popup
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Budget entry added successfully!")),
      );
      // Clear input fields
      // _dateController.clear();
      _budget_codeController.clear();
      _descriptionController.clear();
      _initialAmountController.clear();
      // _revisedAmountController.clear();
      _selectedCurrency = 'USD';
    }
  }

//edit popup function
  void _editPopup(BuildContext context, Map<String, dynamic> item, int index) {
   // final _formKey = GlobalKey<FormState>();
    // Controllers for form fields
    final TextEditingController _dateController = TextEditingController(
        text: DateFormat('yyyy-MM-dd').format(item['Date']));
    final TextEditingController _budgetCodeController =
        TextEditingController(text: item['Budget_Code']);
    final TextEditingController _descriptionController =
        TextEditingController(text: item['Description']);
    final TextEditingController _initialAmountController =
        TextEditingController(text: item['Initial_Amount'].toString());
    final TextEditingController _revisedAmountController =
        TextEditingController(text: item['Revised_Amount'].toString());
    String _selectedCurrency = item['Currency'];

    showDialog(
    
        context: context,
        builder: (context) {
          return AlertDialog(
            
            title: Text("Edit Budget Information"),
            backgroundColor: const Color.fromARGB(255, 189, 231, 248),
            content: Form(
              
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: _dateController,
                    decoration: InputDecoration(
                      labelText: "Date",
                    ),
                    
                  ),
                  TextField(
                    controller: _budgetCodeController,
                    decoration: InputDecoration(labelText: 'Budget_Code'),
                  ),
                  TextField(
                    controller: _descriptionController,
                    decoration: InputDecoration(labelText: 'Description'),
                  ),
                  TextField(
                    controller: _initialAmountController,
                    decoration: InputDecoration(labelText: 'Initial Amount'),
                    keyboardType: TextInputType.number,
                  ),
                  TextField(
                    controller: _revisedAmountController,
                    decoration: InputDecoration(labelText: 'Revised Amount'),
                    keyboardType: TextInputType.number,
                  ),
                  
                  DropdownButtonFormField<String>(
                    value: _selectedCurrency,
                    onChanged: (String? newValue) {
                      _selectedCurrency = newValue!;
                    },
                    items: [
                      'USD',
                      'MMK',
                    ]
                        .map((currency) => DropdownMenuItem<String>(
                              value: currency,
                              child: Text(currency),
                            ))
                        .toList(),
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text('Cancel'),
              ),
              TextButton(
                onPressed: () {
                   DateTime parsedUpadedDate =
                      DateFormat('yyyy-MM-dd').parse(_dateController.text);
                  // Save the updated data back to the list
                  Map<String, dynamic> updatedItem = {
                    'Date': parsedUpadedDate,//_dateController.text,
                    'Budget_Code': _budgetCodeController.text,
                    'Description': _descriptionController.text,
                    'Initial_Amount':
                        double.parse(_initialAmountController.text),
                    'Revised_Amount':
                        double.parse(_revisedAmountController.text),
                    'Currency': _selectedCurrency,
                  };

                  // Update the item at the specified index
                  budgetInfo[index] = updatedItem;

                  // Close the dialog and refresh the UI
                  Navigator.pop(context);
                },
                child: Text('Save'),
              ),
            ],
          );
        });
  }



//Delete
  void _deleteConfirmation(int index) async {
    bool? confirm = await showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Delete Confirmation"),
            content: Text("Are you sure to delete this Budget Data?"),
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
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Budget Data is deleted successfully")));
    }
  }

  @override
  void initState() {
    super.initState();
    filteredData = budgetInfo;
  }

  // Date filter function
  String _getDateFilterDisplayName(String value) {
    switch (value) {
      case 'today':
        return 'Today';
      case 'this_week':
        return 'This Week';
      case 'this_month':
        return 'This Month';
      case 'this_year':
        return 'This Year';
      case 'custom':
        return 'Custom';
      default:
        return value;
    }
  }

  String _getThisWeekRange() {
    DateTime now = DateTime.now();
    DateTime startOfWeek =
        now.subtract(Duration(days: now.weekday - 1)); // Monday
    DateTime endOfWeek = startOfWeek.add(const Duration(days: 6)); // Sunday
    return '${DateFormat.yMd().format(startOfWeek)} - ${DateFormat.yMd().format(endOfWeek)}';
  }

  String _getThisMonthRange() {
    DateTime now = DateTime.now();
    DateTime startOfMonth = DateTime(now.year, now.month, 1);
    DateTime endOfMonth =
        DateTime(now.year, now.month + 1, 0); // Last day of the month
    return '${DateFormat.yMd().format(startOfMonth)} - ${DateFormat.yMd().format(endOfMonth)}';
  }

  String _getThisYearRange() {
    DateTime now = DateTime.now();
    DateTime startOfYear = DateTime(now.year, 1, 1);
    DateTime endOfYear = DateTime(now.year, 12, 31);
    return '${DateFormat.yMd().format(startOfYear)} - ${DateFormat.yMd().format(endOfYear)}';
  }

  void _showCustomDateRangeDialog(BuildContext context) {
    DateTime initialStartDate = DateTime.now();
    DateTime initialEndDate = DateTime.now();

    showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Custom Date Range'),
          content: StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text('Select Start Date:'),
                  const SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: () async {
                      DateTime? pickedStartDate = await showDatePicker(
                        context: context,
                        initialDate: initialStartDate,
                        firstDate: DateTime(2000),
                        lastDate: DateTime(3000),
                      );
                      if (pickedStartDate != null) {
                        setState(() {
                          initialStartDate = pickedStartDate;
                        });
                      }
                    },
                    child: Text(DateFormat.yMd().format(initialStartDate)),
                  ),
                  const SizedBox(height: 20),
                  const Text('Select End Date:'),
                  const SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: () async {
                      DateTime? pickedEndDate = await showDatePicker(
                        context: context,
                        initialDate: initialEndDate,
                        firstDate: DateTime(2000),
                        lastDate: DateTime(2101),
                      );
                      if (pickedEndDate != null) {
                        setState(() {
                          initialEndDate = pickedEndDate;
                        });
                      }
                    },
                    child: Text(DateFormat.yMd().format(initialEndDate)),
                  ),
                ],
              );
            },
          ),
          actions: [
            TextButton(
              child: const Text('Apply'),
              onPressed: () {
                if (initialStartDate.isBefore(initialEndDate)) {
                  setState(() {
                    customDateRange = DateTimeRange(
                      start: initialStartDate,
                      end: initialEndDate,
                    );
                  });
                  _filterByCustomDate(customDateRange!);
                  Navigator.of(context).pop(); // Close dialog
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Please select valid dates.')),
                  );
                }
              },
            ),
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _filterByPresetDate(String filterType) {
    DateTime now = DateTime.now();
    DateTimeRange? dateRange;

    switch (filterType) {
      case 'today':
        dateRange = DateTimeRange(start: now, end: now);
        break;
      case 'this_week':
        DateTime startOfWeek =
            now.subtract(Duration(days: now.weekday - 1)); // Monday
        DateTime endOfWeek = startOfWeek.add(const Duration(days: 6)); // Sunday
        dateRange = DateTimeRange(start: startOfWeek, end: endOfWeek);
        break;
      case 'this_month':
        DateTime startOfMonth = DateTime(now.year, now.month, 1);
        DateTime endOfMonth =
            DateTime(now.year, now.month + 1, 0); // Last day of the month
        dateRange = DateTimeRange(start: startOfMonth, end: endOfMonth);
        break;
      case 'this_year':
        DateTime startOfYear = DateTime(now.year, 1, 1);
        DateTime endOfYear = DateTime(now.year, 12, 31);
        dateRange = DateTimeRange(start: startOfYear, end: endOfYear);
        break;
    }

    if (dateRange != null) {
      _filterDataByDateRange(dateRange);
    }
  }

  void _filterByCustomDate(DateTimeRange pickedDateRange) {
    _filterDataByDateRange(pickedDateRange);
  }

  void _filterDataByDateRange(DateTimeRange dateRange) {
    setState(() {
      filteredData = budgetInfo.where((data) {
        final dataDate = data['Date'] as DateTime;
        return dataDate.isAfter(dateRange.start.subtract(Duration(days: 1))) &&
            dataDate.isBefore(dateRange.end.add(Duration(days: 1)));
      }).toList();


    });
  }

  // Sorting function
  void _sortData(String column, bool ascending) {
    setState(() {
      sortColumn = column;
      isAscending = ascending;

      filteredData.sort((a, b) {
        var aValue = a[column];
        var bValue = b[column];

        // Handle different data types
        if (aValue is String && bValue is String) {
          return ascending
              ? aValue.compareTo(bValue)
              : bValue.compareTo(aValue);
        } else if (aValue is num && bValue is num) {
          return ascending
              ? aValue.compareTo(bValue)
              : bValue.compareTo(aValue);
        } else if (aValue is DateTime && bValue is DateTime) {
          return ascending
              ? aValue.compareTo(bValue)
              : bValue.compareTo(aValue);
        } else {
          return 0;
        }
      });
    });
  }

// Searchbarfilter fuction
  void _searchFilter(String query) {
    setState(() {
      searchQuery = query;
      filteredData = budgetInfo
          .where((item) =>
              item['Budget_Code'].toLowerCase().contains(query.toLowerCase()) ||
              item['Description'].toLowerCase().contains(query.toLowerCase()) ||
              item['Initial_Amount'].toString().contains(query) ||
              item['Currency'].toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

  //Refresh function
  void _refreshList() {
    setState(() {
      _searchingController.clear();
      selectedRequester = '';
      selectedDateRange = null;
      startDate = null;
      filteredData = List.from(budgetInfo);
      selectedDateFilter= null;
      sortColumn = null;
      isAscending = true;
    });
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
              "Budget_Code Information",
              style: TextStyle(fontSize: 18),
            ),
            const SizedBox(
              height: 10,
            ),
            Row(
              children: [
                Padding(
                  padding: const EdgeInsets.only(right: 30),
                  child: DropdownButton<String>(
                    value: selectedDateFilter,
                    hint: const Text('Filter by Date'),
                    items: [
                      DropdownMenuItem(
                        value: 'today',
                        child: Tooltip(
                          message: DateFormat.yMd().format(DateTime.now()),
                          child: const Text('Today'),
                        ),
                      ),
                      DropdownMenuItem(
                        value: 'this_week',
                        child: Tooltip(
                          message: _getThisWeekRange(),
                          child: const Text('This Week'),
                        ),
                      ),
                      DropdownMenuItem(
                          value: 'this_month',
                          child: Tooltip(
                            message: _getThisMonthRange(),
                            child: const Text('This Month'),
                          )),
                      DropdownMenuItem(
                          value: 'this_year',
                          child: Tooltip(
                            message: _getThisYearRange(),
                            child: const Text('This Year'),
                          )),
                      DropdownMenuItem(
                          value: 'custom',
                          child: Tooltip(
                            message: customDateRange != null
                                ? '${DateFormat.yMd().format(customDateRange!.start)} - ${DateFormat.yMd().format(customDateRange!.end)}'
                                : 'Select a custom date range',
                            child: const Text('Custom'),
                          )),
                    ],
                    onChanged: (String? newValue) {
                      setState(() {
                        selectedDateFilter = newValue;
                        if (newValue == 'custom') {
                          _showCustomDateRangeDialog(context);
                        } else if (newValue != null) {
                          _filterByPresetDate(newValue);
                        }
                      });
                    },
                  ),
                ),
                const SizedBox(
                  width: 20,
                ),
                SizedBox(
                  height: 40,
                  width: MediaQuery.of(context).size.width / 2,
                  child: SearchBar(
                    onChanged: _searchFilter,
                    leading: const Icon(Icons.search),
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
                        onPressed: () => _showBudgetPopup(context),
                        // onPressed: () {
                        //   Navigator.push(
                        //       context,
                        //       MaterialPageRoute(
                        //           builder: (context) => BudgetEntryForm()));
                        // },
                        icon: const Icon(
                          Icons.add,
                          color: Colors.blueGrey,
                        )),
                    IconButton(
                        onPressed: _refreshList,
                        icon: const Icon(
                          Icons.refresh,
                          color: Colors.blueGrey,
                        )),
                    IconButton(
                        onPressed: () {},
                        icon: const Icon(
                          Icons.download,
                          color: Colors.blueGrey,
                        ))
                  ],
                )
              ],
            ),
            const SizedBox(
              height: 20,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
              child: Container(
                child: const Row(
                  children: [
                    Expanded(
                        flex: 1,
                        child: Text('Date',
                            style: TextStyle(fontWeight: FontWeight.bold))),
                    Expanded(
                        flex: 1,
                        child: Text('Budget_Code',
                            style: TextStyle(fontWeight: FontWeight.bold))),
                    Expanded(
                        flex: 3,
                        child: Text('Description',
                            style: TextStyle(fontWeight: FontWeight.bold))),
                    Expanded(
                        flex: 2,
                        child: Text('Initial_Amount',
                            style: TextStyle(fontWeight: FontWeight.bold))),
                    Expanded(
                        flex: 2,
                        child: Text('Revised_Amount',
                            style: TextStyle(fontWeight: FontWeight.bold))),
                    Expanded(
                        flex: 1,
                        child: Text('Currency',
                            style: TextStyle(fontWeight: FontWeight.bold))),
                    Expanded(
                        flex: 1,
                        child: Text('Action',
                            style: TextStyle(fontWeight: FontWeight.bold))),
                  ],
                ),
              )
            ),
            
            const Divider(height: 1, thickness: 1),
            Expanded(
              child: filteredData.isNotEmpty
                  ? ListView.builder(
                      itemCount: filteredData.length,
                      // itemCount: budgetInfo.length,
                      itemBuilder: (context, index) {
                        final item = filteredData[index];
                        final fields = [
                          {'value': item['Date'], 'flex': 1}, // DateTime type
                          {
                            'value': item['Budget_Code'],
                            'flex': 1
                          }, // String type
                          {
                            'value': item['Description'],
                            'flex': 3
                          }, // String type
                          {
                            'value': item['Initial_Amount'],
                            'flex': 2
                          }, // double type
                          {
                            'value': item['Revised_Amount'],
                            'flex': 2
                          }, // double type
                          {'value': item['Currency'], 'flex': 1}, // String type
                        ];
                        return Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 8, horizontal: 12),
                              child: Row(
                                children: [
                                  ...fields.map((field) {
                                    final value =
                                        field['value']; // Extract the value
                                    String displayValue;

                                    // Handle type formatting
                                    if (value is DateTime) {
                                      displayValue =DateFormat('yyyy-MM-dd').format(value);
                                         // "${value.year}-${value.month}-${value.day}";
                                    } else if (value is num) {
                                      displayValue = numberFormat
                                          .format(value); // Format numbers
                                    } else {
                                      displayValue =
                                          value.toString(); // Default to string
                                    }

                                    return Expanded(
                                      flex: field['flex'] as int,
                                      child: Text(
                                        displayValue,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    );
                                  }).toList(),

                                  // Expanded(
                                  //   flex: 1,
                                  //   child: Text(//'${item['date']}'
                                  //       "${item['date'].year}-${item['date'].month}-${item['date'].day}"
                                  //      // "${item['Date']}"
                                  //       ),
                                  // ),
                                  // Expanded(
                                  //     flex: 1,
                                  //     child: Text("${item['Budget_Code']}")
                                  //    // Text(item['budget_code'])
                                  //     ),
                                  // Expanded(
                                  //     flex: 3,
                                  //     child: Text("${item['Description']}"
                                  //       //item['description']
                                  //       )),
                                  // Expanded(
                                  //     flex: 2,
                                  //     child: Text(numberFormat.format("${item['Initial_Amount']}")
                                  //         //.format(item['initial_amount'])
                                  //         )),
                                  // Expanded(
                                  //     flex: 2,
                                  //     child: Text(numberFormat.format("${item['Revised_Amount']}")
                                  //         //.format(item['revised_amount'])
                                  //         )),
                                  // Expanded(
                                  //     flex: 1, child: Text("${item['Currency']}"
                                  //       //item['currency']
                                  //       )),
                                  Expanded(
                                    flex: 1,
                                    child: Row(
                                      children: [
                                        IconButton(
                                          onPressed: () {
                                            _editPopup(context,
                                                budgetInfo[index], index);
                                            print(
                                                "Edit button pressed for index: $index");
                                          },
                                          icon: const Icon(Icons.edit,
                                              color: Colors.blueAccent),
                                        ),
                                        IconButton(
                                            onPressed: () {
                                              _deleteConfirmation(index);
                                            },
                                            icon: Icon(
                                              Icons.delete,
                                              color: Colors.blueAccent,
                                            ))
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const Divider(height: 1, thickness: 1),
                          ],
                        );
                      },
                    )
                  : const Center(
                      child: Text("No results found"),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
