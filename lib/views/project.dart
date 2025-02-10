import 'dart:ui';

import 'package:advance_budget_request_system/views/projectEntry.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ProjectInfo extends StatefulWidget {
  @override
  _ProjectInfoState createState() => _ProjectInfoState();
}

class _ProjectInfoState extends State<ProjectInfo> {
  String selectedRequester = '';
  String? selectedDate;
  DateTime? startDate;
  DateTime? endDate;

  dynamic hoverRow;
  String? selectedFilter;
  DateTimeRange? selectedDateRange;
  DateTimeRange? CustomDateRange;
  TextEditingController _searchController = TextEditingController();
  final numberFormat = NumberFormat("#,##0");

  String? sortColumn;
  bool isAscending = true;
  List<Map<String, dynamic>> filterData = [];
  String searchQuery = '';

  List<String> selectedFilters = [];
  List<Map<String, dynamic>> projectData = [
    {
      'Date': '2025-2-1',
      'ProjectID': 'PRJ-2324-001',
      'Description': 'Final Project',
      'Total Budget Amount': '100,000 ',
      'Currency': 'MMK', // 'Approved Amount': '60,000 MMK',''
      'Department': 'IT',
      'Requestable': 'Yes',
    },
    {
      'Date': '2025-2-1',
      'ProjectID': 'PRJ-2324-002',
      'Description': 'Final Project',
      'Total Budget Amount': '200,000 ',
      'Currency': 'MMK', // 'Approved Amount': '60,000 MMK',''
      'Department': 'IT',
      'Requestable': 'Yes',
    },
    {
      'Date': '2025-2-1',
      'ProjectID': 'PRJ-2324-003',
      'Description': 'Final Project',
      'Total Budget Amount': '50000,000 ',
      'Currency': 'MMK', // 'Approved Amount': '60,000 MMK',''
      'Department': 'IT',
      'Requestable': 'Yes',
    },
    {
      'Date': '2025-2-1',
      'ProjectID': 'PRJ-2324-004',
      'Description': 'Final Project',
      'Total Budget Amount': '10100,000 ',
      'Currency': 'MMK', // 'Approved Amount': '60,000 MMK',''
      'Department': 'IT',
      'Requestable': 'Yes',
    },
    {
      'Date': '2025-2-1',
      'ProjectID': 'PRJ-2324-005',
      'Description': 'Final Project',
      'Total Budget Amount': '100,000 ',
      'Currency': 'USD', // 'Approved Amount': '60,000 MMK',''
      'Department': 'IT',
      'Requestable': 'Yes',
    },
    {
      'Date': '2025-2-1',
      'ProjectID': 'PRJ-2324-006',
      'Description': 'Final Project',
      'Total Budget Amount': '100,000 ',
      'Currency': 'MMK',
      'Department': 'Admin', // 'Approved Amount': '60,000 MMK',''
      'Requestable': 'Yes',
    },
    {
      'Date': '2025-2-1',
      'ProjectID': 'PRJ-2324-007',
      'Description': 'Final Project',
      'Total Budget Amount': '6600,000 ',
      'Currency': 'MMK', // 'Approved Amount': '60,000 MMK',''
      'Department': 'HR',
      'Requestable': 'Yes',
    },
    {
      'Date': '2025-2-1',
      'ProjectID': 'PRJ-2324-008',
      'Description': 'Final Project',
      'Total Budget Amount': '100,000 ',
      'Currency': 'MMK', // 'Approved Amount': '60,000 MMK',''
      'Department': 'Marketing',
      'Requestable': 'Yes',
    },
    {
      'Date': '2025-2-1',
      'ProjectID': 'PRJ-2324-009',
      'Description': 'Final Project',
      'Total Budget Amount': '100,000 ',
      'Currency': 'USD', // 'Approved Amount': '60,000 MMK',''
      'Department': 'Finance',
      'Requestable': 'Yes',
    },
    {
      'Date': '2025-2-1',
      'ProjectID': 'PRJ-2324-010',
      'Description': 'Final Project',
      'Total Budget Amount': '100,000 ',
      'Currency': 'MMK', // 'Approved Amount': '60,000 MMK',''
      'Department': 'HR',
      'Requestable': 'Yes',
    },
    {
      'Date': '2025-2-1',
      'ProjectID': 'PRJ-2324-011',
      'Description': 'Final Project',
      'Total Budget Amount': '1100,000 ',
      'Currency': 'MMK', // 'Approved Amount': '60,000 MMK',''
      'Department': 'IT',
      'Requestable': 'Yes',
    },
    {
      'Date': '2025-2-1',
      'ProjectID': 'PRJ-2324-012',
      'Description': 'Final Project',
      'Total Budget Amount': '1000,000 ',
      'Currency': 'MMK', // 'Approved Amount': '60,000 MMK',''
      'Department': 'IT',
      'Requestable': 'No',
    },
    {
      'Date': '2025-2-1',
      'ProjectID': 'PRJ-2324-013',
      'Description': 'Final Project',
      'Total Budget Amount': '500,000 ',
      'Currency': 'MMK', // 'Approved Amount': '60,000 MMK',''
      'Department': 'IT',
      'Requestable': 'No',
    },
    {
      'Date': '2025-2-1',
      'ProjectID': 'PRJ-2324-014',
      'Description': 'Final Project',
      'Total Budget Amount': '100,000 ',
      'Currency': 'MMK', // 'Approved Amount': '60,000 MMK',''
      'Department': 'Admin',
      'Requestable': 'Yes',
    },
    {
      'Date': '2025-2-1',
      'ProjectID': 'PRJ-2324-015',
      'Description': 'Final Project',
      'Total Budget Amount': '100,000 ',
      'Currency': 'MMK', // 'Approved Amount': '60,000 MMK',''
      'Department': 'IT',
      'Requestable': 'Yes',
    },
    {
      'Date': '2025-2-1',
      'ProjectID': 'PRJ-2324-016',
      'Description': 'Final Project',
      'Total Budget Amount': '7000,000 ',
      'Currency': 'MMK', // 'Approved Amount': '60,000 MMK',''
      'Department': 'IT',
      'Requestable': 'Yes',
    },
    {
      'Date': '2025-2-1',
      'ProjectID': 'PRJ-2324-017',
      'Description': 'Final Project',
      'Total Budget Amount': '1,000 ',
      'Currency': 'USD', // 'Approved Amount': '60,000 MMK',''
      'Department': 'IT',
      'Requestable': 'Yes',
    },
    {
      'Date': '2025-2-1',
      'ProjectID': 'PRJ-2324-018',
      'Description': 'Final Project',
      'Total Budget Amount': '100,000 ',
      'Currency': 'MMK', // 'Approved Amount': '60,000 MMK',''
      'Department': 'IT',
      'Requestable': 'No',
    },
    {
      'Date': '2025-2-1',
      'ProjectID': 'PRJ-2324-019',
      'Description': 'Final Project',
      'Total Budget Amount': '100,000 ',
      'Currency': 'MMK', // 'Approved Amount': '60,000 MMK',''
      'Department': 'IT',
      'Requestable': 'Yes',
    },
    {
      'Date': '2025-2-1',
      'ProjectID': 'PRJ-2324-020',
      'Description': 'Final Project',
      'Total Budget Amount': '100,000 ',
      'Currency': 'MMK', // 'Approved Amount': '60,000 MMK',''
      'Department': 'IT',
      'Requestable': 'Yes',
    },
    {
      'Date': '2025-2-1',
      'ProjectID': 'PRJ-2324-021',
      'Description': 'Final Project',
      'Total Budget Amount': '100,000 ',
      'Currency': 'MMK', // 'Approved Amount': '60,000 MMK',''
      'Department': 'IT',
      'Requestable': 'No',
    },
    {
      'Date': '2025-2-1',
      'ProjectID': 'PRJ-2324-022',
      'Description': 'Final Project',
      'Total Budget Amount': '100,000 ',
      'Currency': 'MMK', // 'Approved Amount': '60,000 MMK',''
      'Department': 'IT',
      'Requestable': 'Yes',
    },
  ];

  // ignore: unused_element
  void _addProject(List<Map<String, String>> newProject) {
    setState(() {
      projectData.addAll(newProject);
    });
  }

  // ignore: unused_element
  void _refreshData() {
    setState(() {
      _searchController.clear();
      selectedDateRange = null;
      startDate = null;
      endDate = null;
      filterData = projectData;
    });
  }

  void _deleteConfirmation(int index) async {
    bool? confirm = await showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Delete Confirmation"),
            content: Text("Are you sure to delete this Trip Data?"),
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
        projectData.removeAt(index);
      });
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text("Project Data is deleted successfully")));
    }
  }

  TextEditingController searchController = TextEditingController();
  // Stores selected values

  final Map<String, List<String>> dropdownOptions = {
    "Currency": ["MMK", "USD"],
    "Department": [
      'HR',
      'IT',
      'Finance',
      'Admin',
      'Production',
      'Engineering',
      'Marketing',
      'Sales'
    ],
    "Status": ["Active", "Inactive"],
  };

  void initState() {
    super.initState();
    filterData = List.from(projectData);
  }

  void _filterTable(String query) {
    setState(() {
      if (query.isEmpty) {
        filterData = List.from(projectData); // Reset when search is empty
      } else {
        filterData = projectData.where((row) {
          return row.values.any(
              (value) => value.toLowerCase().contains(query.toLowerCase()));
        }).toList();
      }
    });
  }

// ignore: unused_element
  void _removeFilters(String filter) {
    setState(() {
      selectedFilters.remove(filter);
      _filterTable(_searchController.text);
    });
  }

  // ignore: unused_element
  String _getDateFilterDisplayName(String value) {
    switch (value) {
      case 'today':
        return 'Today';
      case 'this_week':
        return 'This_week';
      case 'this_month':
        return 'This_month';
      case 'this_year':
        return 'This_year';
      case 'custom':
        return 'Custom';
      default:
        return value;
    }
  }

  String _getThisWeekRange() {
    DateTime now = DateTime.now();
    DateTime startOfWeek = now.subtract(Duration(days: now.weekday - 1));
    DateTime endOfWeek = startOfWeek.add(const Duration(days: 6));
    return '${DateFormat.yMd().format(startOfWeek)} - ${DateFormat.yMd().format(endOfWeek)}';
  }

  String _getThisMonthRange() {
    DateTime now = DateTime.now();
    DateTime startOfMonth = DateTime(now.year, now.month, 1);
    DateTime endOfMonth = DateTime(now.year, now.month + 1, 0);
    return '${DateFormat.yMd().format(startOfMonth)}-${DateFormat.yMd().format(endOfMonth)}';
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

    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text("Custom Data Range"),
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
                          //  initialDate: initialStartDate,
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
                  onPressed: () {
                    if (initialStartDate.isBefore(initialEndDate) ||
                        initialStartDate.isAtSameMomentAs(initialEndDate)) {
                      setState(() {
                        CustomDateRange = DateTimeRange(
                            start: initialStartDate, end: initialEndDate);
                        selectedDate = 'custom_date';
                      });
                      _filterByCustomDate(CustomDateRange!);
                      Navigator.of(context).pop();
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                          content: Text("Please choose available Dates.")));
                    }
                  },
                  child: const Text("Apply")),
              TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text('Cancel'))
            ],
          );
        });
  }

  void _filterByPresentDate(String filterType) {
    DateTime now = DateTime.now();
    DateTimeRange? dateRange;
    switch (filterType) {
      case 'today':
        dateRange = DateTimeRange(start: now, end: now);
        break;
      case 'this_week':
        DateTime startOfWeek = now.subtract(Duration(days: now.weekday - 1));
        DateTime endOfWeek = startOfWeek.add(const Duration(days: 6));
        dateRange = DateTimeRange(start: startOfWeek, end: endOfWeek);
        break;
      case 'this_month':
        DateTime startOfMonth = DateTime(now.year, now.month, 1);
        DateTime endOfMonth = DateTime(now.year, now.month + 1, 0);
        dateRange = DateTimeRange(start: startOfMonth, end: endOfMonth);
        break;
      case 'this_year':
        DateTime startOfYear = DateTime(now.year, 1, 1);
        DateTime endOfYear = DateTime(now.year, 12, 31);
        dateRange = DateTimeRange(start: startOfYear, end: endOfYear);
        break;
      default:
        return;
    }
    // ignore: unnecessary_null_comparison
    if (dateRange != null) {
      setState(() {
        selectedDate = filterType;
      });
      _filterDataByDateRange(dateRange);
    }
  }

  void _filterByCustomDate(DateTimeRange pickedDateRange) {
    _filterDataByDateRange(pickedDateRange);
  }

  void _filterDataByDateRange(DateTimeRange dateRange) {
    setState(() {
      filterData = projectData.where((data) {
        final dataDate = data['Date'] as DateTime;
        return dataDate.isAfter(dateRange.start.subtract(Duration(days: 1))) &&
            dataDate.isBefore(dateRange.end.add(Duration(days: 1)));
      }).toList();

      // Reset to first page
      // Your method to update pagination based on the new filtered data
    });
  }

  void _openAdvancedSearchDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AdvancedSearchDialog(
          dropdownOptions: dropdownOptions,
          onFilterSelected: (selectedValue) {
            setState(() {
              if (!selectedFilters.contains(selectedValue)) {
                selectedFilters.add(selectedValue);
              }
              _updateSearchField(); // Add selected value to the list
            });
          },
        );
      },
    );
  }

  void _updateSearchField() {
    searchController.text = selectedFilters.join(", ");
  }

  // ignore: unused_element
  void _clearSearch() {
    setState(() {
      selectedFilters.clear();
      searchController.clear();
    });
  }

  void _removeFilter(String value) {
    setState(() {
      selectedFilters.remove(value); // Remove the selected value
    });
  }

  Widget build(BuildContext context) {
    // {
    //   'Project Code': 'PRJ-2324-001',
    //   'Description': 'Final Project',
    //   'Department': 'IT',
    //   'Total Budget Amount': '100,000 ',
    //  'Currency':'MMK', // 'Approved Amount': '60,000 MMK',''
    //   // 'Status': 'Active',
    //   'Requestable': 'Yes',
    // },

    double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          //mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Padding(
                  padding: const EdgeInsets.only(right: 30),
                  child: DropdownButton<String>(
                    value: selectedFilter,
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
                            message: CustomDateRange != null
                                ? '${DateFormat.yMd().format(CustomDateRange!.start)} - ${DateFormat.yMd().format(CustomDateRange!.end)}'
                                : 'Select a custom date range',
                            child: const Text('Custom'),
                          )),
                    ],
                    onChanged: (String? newValue) {
                      setState(() {
                        selectedFilter = newValue;
                        if (newValue == 'custom') {
                          _showCustomDateRangeDialog(context);
                        } else if (newValue != null) {
                          _filterByPresentDate(newValue);
                        }
                      });
                    },
                  ),
                ),
                const SizedBox(
                  width: 20,
                ),
                // SizedBox(
                //   height: 40,
                //   width: MediaQuery.of(context).size.width / 2,
                //   child: SearchBar(
                //     onChanged: _searchFilter,
                //     leading: Icon(Icons.search),
                //     hintText: "Search",
                //   ),
                // ),
                const SizedBox(width: 10),
                Expanded(
                  child: Container(
                    height: 50,
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.search, color: Colors.black),
                          onPressed: () {
                            _filterTable(_searchController.text);
                          },
                        ),
                        Expanded(
                          child: TextField(
                            controller: _searchController,
                            onChanged: (query) {
                              _filterTable(query);
                            },
                            // textDirection: TextDirection.LTR,
                            textAlign: TextAlign.start,
                            decoration: const InputDecoration(
                              hintText: "Search",
                              border: InputBorder.none,
                              contentPadding: EdgeInsets.all(8.0),
                              isCollapsed: true,
                            ),
                          ),
                        ),

                        const SizedBox(height: 8),
                        // if(selectedFilters.isNotEmpty)
                        //  Expanded(
                        //   child: Padding(
                        //     padding: const EdgeInsets.only(top: 8.0),
                        //     child:
                        Wrap(
                          alignment: WrapAlignment.start,
                          spacing: 8.0,
                          runSpacing: 4.0,
                          children: selectedFilters.map((filter) {
                            return Chip(
                              label: Text(filter),
                              backgroundColor: Colors.blue.shade100,
                              deleteIcon: const Icon(Icons.close,
                                  size: 18, color: Colors.red),
                              onDeleted: () => _removeFilter(filter),
                            );
                          }).toList(),
                        ),
                      ],
                    ),
                  ),
                ),
                //  SizedBox(height: 10),

                // 🏷️ Wrap for Filters

                const SizedBox(
                    width: 30), // Space between search bar and filters button

                ElevatedButton.icon(
                  icon: const Icon(Icons.more_vert),
                  label: const Text("Filters"),
                  onPressed: _openAdvancedSearchDialog,
                ),

                SizedBox(width: MediaQuery.of(context).size.width / 3.3),

                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(255, 150, 212, 234),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: Colors.greenAccent),
                  ),
                  child: Row(
                    // mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.add, color: Colors.black),
                        onPressed: () async {
                          // ignore: unused_local_variable
                          final List<Map<String, dynamic>>? newProject =
                              await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  EntryForm(onProjectAdded: (newProject) {
                                setState(() {
                                  projectData.addAll(newProject);
                                });
                              }),
                            ),
                          );
                        },
                      ),
                      IconButton(
                        icon: const Icon(Icons.refresh, color: Colors.black),
                        onPressed: () {
                          //  _refreshData(projectData.indexOf(row));
                          setState(() {});
                        },
                      ),
                      IconButton(
                        icon: const Icon(Icons.download, color: Colors.black),
                        onPressed: () {
                          setState(() {});
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Column(
              children: [
                const SizedBox(height: 20),
                Container(
                  width: screenWidth,
                  child: Table(
                    border: const TableBorder.symmetric(
                      inside: BorderSide(color: Colors.grey, width: 1),
                      outside: BorderSide(color: Colors.grey, width: 1),
                    ),
                    columnWidths: const {
                      0: FlexColumnWidth(0.5),
                      1: FlexColumnWidth(1),
                      2: FlexColumnWidth(2.5),
                      3: FlexColumnWidth(1.3),
                      4: FlexColumnWidth(0.5),
                      5: FlexColumnWidth(0.5),
                      6: FlexColumnWidth(0.6),
                      7: FlexColumnWidth(0.8),
                    },
                    children: const [
                      TableRow(
                        decoration: BoxDecoration(
                            color: Color.fromARGB(255, 167, 230, 232)),
                        children: [
                          Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Text("Date",
                                style: TextStyle(fontWeight: FontWeight.bold)),
                          ),
                          Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Text("ProjectID",
                                style: TextStyle(fontWeight: FontWeight.bold)),
                          ),
                          Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Text("Description",
                                style: TextStyle(fontWeight: FontWeight.bold)),
                          ),
                          Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Text("Total Budget Amount",
                                style: TextStyle(fontWeight: FontWeight.bold)),
                          ),
                          Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Text("Currency",
                                style: TextStyle(fontWeight: FontWeight.bold)),
                          ),
                          Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Text("Department",
                                style: TextStyle(fontWeight: FontWeight.bold)),
                          ),
                          Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Text("Requestable",
                                style: TextStyle(fontWeight: FontWeight.bold)),
                          ),
                          Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Text("Action",
                                style: TextStyle(fontWeight: FontWeight.bold)),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Expanded(
              child: SingleChildScrollView(
                child: Table(
                  border: const TableBorder.symmetric(
                    inside: BorderSide(color: Colors.grey, width: 1),
                    outside: BorderSide(color: Colors.black, width: 1),
                  ),
                  columnWidths: const {
                    0: FlexColumnWidth(0.5),
                    1: FlexColumnWidth(1),
                    2: FlexColumnWidth(2.5),
                    3: FlexColumnWidth(1.3),
                    4: FlexColumnWidth(0.5),
                    5: FlexColumnWidth(0.5),
                    6: FlexColumnWidth(0.6),
                    7: FlexColumnWidth(0.8),
                  },
                  children: filterData.map(
                    (row) {
                      return TableRow(
                        children: [
                          for (var key in row.keys)
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(row[key]!),
                            ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                IconButton(
                                  icon: const Icon(Icons.edit,
                                      color: Colors.black),
                                  onPressed: () {
                                    print("Edit for ${row["Project Code"]}");
                                  },
                                ),
                                IconButton(
                                    onPressed: () {
                                      _deleteConfirmation(
                                          projectData.indexOf(row));
                                    },
                                    icon: const Icon(Icons.delete),
                                    color: Colors.black),
                                IconButton(
                                  icon: const Icon(Icons.more_horiz_outlined,
                                      color: Colors.black),
                                  onPressed: () {
                                    print("Details for ${row["Project Code"]}");
                                  },
                                ),
                              ],
                            ),
                          ),
                        ],
                      );
                    },
                  ).toList(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class AdvancedSearchDialog extends StatefulWidget {
  final Map<String, List<String>> dropdownOptions;
  final Function(String) onFilterSelected;

  AdvancedSearchDialog({
    required this.dropdownOptions,
    required this.onFilterSelected,
  });

  @override
  _AdvancedSearchDialogState createState() => _AdvancedSearchDialogState();
}

class _AdvancedSearchDialogState extends State<AdvancedSearchDialog> {
  Map<String, String?> selectedValues = {};
  TextEditingController searchTextController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("Advanced Search"),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: searchTextController,
            decoration: const InputDecoration(
              labelText: "Enter search text",
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 10),
          ...widget.dropdownOptions.keys.map((category) {
            return _buildDropdown(
              title: category,
              options: widget.dropdownOptions[category]!,
              selectedValue: selectedValues[category],
              onChanged: (newValue) {
                setState(() {
                  selectedValues[category] = newValue;
                });
              },
            );
          }).toList(),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text("Close"),
        ),
        ElevatedButton(
          onPressed: () {
            if (searchTextController.text.isNotEmpty) {
              widget.onFilterSelected(searchTextController.text);
            }

            selectedValues.forEach((key, query) {
              if (query != null) {
                widget.onFilterSelected(query);
              }
            });
            Navigator.pop(context);
          },
          child: const Text("Search"),
        ),
      ],
    );
  }

  Widget _buildDropdown({
    required String title,
    required List<String> options,
    required String? selectedValue,
    required Function(String?) onChanged,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
          DropdownButton<String>(
            isExpanded: true,
            value: selectedValue,
            hint: Text("Select $title"),
            items: options.map((String option) {
              return DropdownMenuItem<String>(
                value: option,
                child: Text(option),
              );
            }).toList(),
            onChanged: onChanged,
          ),
        ],
      ),
    );
  }
}

@override
Widget build(BuildContext context) {
  return Scaffold(
    appBar: AppBar(
      title: const Text("Project Infomation"),
    ),
  );
}
