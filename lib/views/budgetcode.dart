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
  TextEditingController _searchingController = TextEditingController();
  final numberFormat = NumberFormat("#,##0");
  List<Map<String, dynamic>> budgetInfo = List.generate(100, (int index) {
    return {
      'date': DateTime.now().add(Duration(days: index * 30)),
      'budget_code': 'B- $index',
      'description': 'BudgetDescription $index',
      'initial_amount': 400000,
      'revised_amount': 0,
      'currency': 'MMK',
      'action': '',
    };
  });
  String? sortColumn;
  bool isAscending = true;
  List<Map<String, dynamic>> filteredData = [];
  String searchQuery = '';

//budgetEntry form initialize variable
  final _formKey = GlobalKey<FormState>();
  String budgetCode = '';
  String description = '';
  double initialAmount = 0.0;

  //function of popup

  void _showBudgetPopup(BuildContext context) {
    String currentDateTime = DateFormat('yyyy-MM-dd').format(DateTime.now());
    String? selectedCurrency = 'MMK';
    double revisedAmount = 0.0;
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          
        
          title: Text("Add New Budget"),
          content: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  
                  decoration: InputDecoration(labelText: "Date",border: OutlineInputBorder()),
                  initialValue: currentDateTime,
                  readOnly: true,
                
                  // validator: (value) {
                  //   if (value == null || value.isEmpty) {
                  //     return "Please enter a budget code";
                  //   }
                  //   return null;
                  // },
                  onSaved: (value) {
                  
                    budgetCode = value!;
                  },
                ),SizedBox(height: 10,),
                // Budget Code Field
                TextFormField(
                  decoration: InputDecoration(labelText: "Budget Code",border: OutlineInputBorder()),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Please enter a budget code";
                    }
                    return null;
                  },
                  onSaved: (value) {
                    budgetCode = value!;
                  },
                ),
                SizedBox(height: 10,),
                // Description Field
                TextFormField(
                  decoration: InputDecoration(labelText: "Description",border: OutlineInputBorder()),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Please enter a description";
                    }
                    return null;
                  },
                  onSaved: (value) {
                    description = value!;
                  },
                ),
                SizedBox(height: 10,),
                // Initial Amount Field
                TextFormField(
                  decoration: InputDecoration(labelText: "Initial Amount",border: OutlineInputBorder()),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null ||
                        value.isEmpty ||
                        double.tryParse(value) == null) {
                      return "Please enter a valid amount";
                    }
                    return null;
                  },
                  onSaved: (value) {
                    initialAmount = double.parse(value!);
                  },
                ),
                SizedBox(height: 10,),
                TextFormField(
                  decoration: InputDecoration(labelText: "Revised Amount",border: OutlineInputBorder()),
                  initialValue: revisedAmount.toString(),
                  readOnly: true, // Prevent editing
                ),
                SizedBox(height: 10,),
                DropdownButtonFormField(
                    decoration: InputDecoration(labelText: "Currency",border: OutlineInputBorder()),
                    items: ['MMK', 'USD'].map((String currency) {
                      return DropdownMenuItem<String>(
                          value: currency, child: Text(currency));
                    }).toList(),
                    onChanged: (newValue) {
                      selectedCurrency = newValue!;
                    })
              ],
            ),
          ),
          actions: [
            // Cancel Button
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the popup
              },
              child: Text("Cancel"),
            ),
            // Submit Button
            ElevatedButton(
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  _formKey.currentState!.save(); // Save form data
                  setState(() {
                    // Add new entry to the existing list
                    budgetInfo.add({
                      'date': currentDateTime,
                      'budgetCode': budgetCode,
                      'description': description,
                      'initialAmount': initialAmount,
                      'revisedAmount': revisedAmount,
                      'currency': selectedCurrency,
                    });
                  });
                  Navigator.of(context).pop(); // Close the popup
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("Budget entry added successfully!")),
                  );
                }
              },
              child: Text("Submit"),
            ),
          ],
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();
    filteredData = budgetInfo;
  }

// Searchbarfilter f
  void _searchFilter(String query) {
    setState(() {
      searchQuery = query;
      filteredData = budgetInfo
          .where((item) =>
              item['budget_code'].toLowerCase().contains(query.toLowerCase()) ||
              item['description'].toLowerCase().contains(query.toLowerCase()) ||
              item['initial_amount'].toString().contains(query) ||
              item['currency'].toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
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
    DateTime endOfWeek = startOfWeek.add(Duration(days: 6)); // Sunday
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
          title: Text('Custom Date Range'),
          content: StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('Select Start Date:'),
                  SizedBox(height: 10),
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
                  SizedBox(height: 20),
                  Text('Select End Date:'),
                  SizedBox(height: 10),
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
              child: Text('Apply'),
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
                    SnackBar(content: Text('Please select valid dates.')),
                  );
                }
              },
            ),
            TextButton(
              child: Text('Cancel'),
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
        DateTime endOfWeek = startOfWeek.add(Duration(days: 6)); // Sunday
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
        final dataDate = data['date'] as DateTime;
        return dataDate.isAfter(dateRange.start.subtract(Duration(days: 1))) &&
            dataDate.isBefore(dateRange.end.add(Duration(days: 1)));
      }).toList();

      // Reset to first page
      // Your method to update pagination based on the new filtered data
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

      // Reset to first page after sorting
      // currentPage = 1;
      // _updatePagination();
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
            Text(
              "Budget_Code Information",
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(
              height: 10,
            ),
            Row(
              children: [
                Padding(
                  padding: EdgeInsets.only(right: 30),
                  child: DropdownButton<String>(
                    value: selectedDateFilter,
                    hint: Text('Filter by Date'),
                    items: [
                      DropdownMenuItem(
                        value: 'today',
                        child: Tooltip(
                          message: DateFormat.yMd().format(DateTime.now()),
                          child: Text('Today'),
                        ),
                      ),
                      DropdownMenuItem(
                        value: 'this_week',
                        child: Tooltip(
                          message: _getThisWeekRange(),
                          child: Text('This Week'),
                        ),
                      ),
                      DropdownMenuItem(
                          value: 'this_month',
                          child: Tooltip(
                            message: _getThisMonthRange(),
                            child: Text('This Month'),
                          )),
                      DropdownMenuItem(
                          value: 'this_year',
                          child: Tooltip(
                            message: _getThisYearRange(),
                            child: Text('This Year'),
                          )),
                      DropdownMenuItem(
                          value: 'custom',
                          child: Tooltip(
                            message: customDateRange != null
                                ? '${DateFormat.yMd().format(customDateRange!.start)} - ${DateFormat.yMd().format(customDateRange!.end)}'
                                : 'Select a custom date range',
                            child: Text('Custom'),
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
                SizedBox(
                  width: 20,
                ),
                SizedBox(
                  height: 40,
                  width: MediaQuery.of(context).size.width / 2,
                  child: SearchBar(
                    onChanged: _searchFilter,
                    leading: Icon(Icons.search),
                    hintText: "Search",
                  ),
                ),
                SizedBox(
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
                        icon: Icon(
                          Icons.add,
                          color: Colors.blueGrey,
                        )),
                    IconButton(
                        onPressed: _refreshList,
                        icon: Icon(
                          Icons.refresh,
                          color: Colors.blueGrey,
                        )),
                    IconButton(
                        onPressed: () {},
                        icon: Icon(
                          Icons.download,
                          color: Colors.blueGrey,
                        ))
                  ],
                )
              ],
            ),
            SizedBox(
              height: 20,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
              child: Container(
                child: Row(
                  children: const [
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
              ),
            ),
            const Divider(height: 1, thickness: 1),
            Expanded(
              child: filteredData.isNotEmpty
                  ? ListView.builder(
                      itemCount: filteredData.length,
                      itemBuilder: (context, index) {
                        final item = filteredData[index];
                        return Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 8, horizontal: 12),
                              child: Row(
                                children: [
                                  Expanded(
                                    flex: 1,
                                    child: Text(
                                      
                                        "${item['date'].year}-${item['date'].month}-${item['date'].day}"),
                                  ),
                                  Expanded(
                                      flex: 1,
                                      child: Text(item['budget_code'])),
                                  Expanded(
                                      flex: 3,
                                      child: Text(item['description'])),
                                  Expanded(
                                      flex: 2,
                                      child: Text(numberFormat
                                          .format(item['initial_amount']))),
                                  Expanded(
                                      flex: 2,
                                      child: Text(numberFormat
                                          .format(item['revised_amount']))),
                                  Expanded(
                                      flex: 1, child: Text(item['currency'])),
                                  Expanded(
                                    flex: 1,
                                    child: Row(
                                      children: [
                                        IconButton(
                                          icon: const Icon(Icons.edit,
                                              color: Colors.blueAccent),
                                          onPressed: () {
                                            // Handle edit action
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(
                                              SnackBar(
                                                  content: Text(
                                                      "Edit ${item['budget_code']}")),
                                            );
                                          },
                                        ),
                                        IconButton(
                                            onPressed: () {},
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

  void _refreshList() {
    setState(() {
      _searchingController.clear();
      selectedRequester = '';
      selectedDateRange = null;
      startDate = null;
      filteredData = List.from(budgetInfo);
      sortColumn = null;
      isAscending = true;
    });
  }
}


