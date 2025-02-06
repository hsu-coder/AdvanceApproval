import 'package:advance_budget_request_system/views/tripEntry.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';

class TripInfo extends StatefulWidget {
  const TripInfo({super.key});

  @override
  State<TripInfo> createState() => _TripInfoState();
}

class _TripInfoState extends State<TripInfo> {
  List<Map<String, dynamic>> tripData = [
    {
      'Date': '2023/10/28',
      'tripID': '1',
      'description': 'Job Training',
      'Total Amount': '200000',
      'currency': 'MMK',
      'department': 'Admin',
      'Requestable': 'Pending'
    },
    {
      'Date': '2023/10/29',
      'tripID': '2',
      'description': 'Camping',
      'Total Amount': '500000',
      'currency': 'MMK',
      'department': 'HR',
      'Requestable': 'Pending'
    },
    {
      'Date': '2023/10/30',
      'tripID': '3',
      'description': 'Trip',
      'Total Amount': '700000',
      'currency': 'MMK',
      'department': 'Marketing',
      'Requestable': 'Pending'
    },
    {
      'Date': '2023/10/31',
      'tripID': '4',
      'description': 'Oversea',
      'Total Amount': '400000',
      'currency': 'MMK',
      'department': 'Admin',
      'Requestable': 'Pending'
    },
    {
      'Date': '2025/02/04',
      'tripID': '5',
      'description': 'Oversesa meeting',
      'Total Amount': '500000',
      'currency': 'MMK',
      'department': 'Admin',
      'Requestable': 'Pending'
    },
    {
      'Date': '2025/02/05',
      'tripID': '6',
      'description': 'Mandalay site vist',
      'Total Amount': '300000',
      'currency': 'MMK',
      'department': 'Admin',
      'Requestable': 'Pending'
    },
    {
      'Date': '2025/02/06',
      'tripID': '7',
      'description': 'Trip',
      'Total Amount': '100000',
      'currency': 'MMK',
      'department': 'Admin',
      'Requestable': 'Pending'
    },
    {
      'Date': '2025/10/28',
      'tripID': '8',
      'description': 'Oversea',
      'Total Amount': '300000',
      'currency': 'MMK',
      'department': 'Admin',
      'Requestable': 'Pending'
    },
    {
      'Date': '2023/11/01',
      'tripID': '9',
      'description': 'Camping',
      'Total Amount': '200000',
      'currency': 'MMK',
      'department': 'Admin',
      'Requestable': 'Pending'
    },
    {
      'Date': '2023/11/02',
      'tripID': '10',
      'description': 'Training',
      'Total Amount': '800000',
      'currency': 'MMK',
      'department': 'Admin',
      'Requestable': 'Pending'
    },
    {
      'Date': '2023/11/03',
      'tripID': '11',
      'description': 'Trip',
      'Total Amount': '300000',
      'currency': 'MMK',
      'department': 'Admin',
      'Requestable': 'Pending'
    },
    {
      'Date': '2023/11/04',
      'tripID': '12',
      'description': 'Oversea',
      'Total Amount': '400000',
      'currency': 'MMK',
      'department': 'Admin',
      'Requestable': 'Pending'
    },
    {
      'Date': '2023/11/05',
      'tripID': '13',
      'description': 'Site visit',
      'Total Amount': '500000',
      'currency': 'MMK',
      'department': 'Admin',
      'Requestable': 'Pending'
    },
    {
      'Date': '2023/11/06',
      'tripID': '14',
      'description': 'Training',
      'Total Amount': '200000',
      'currency': 'MMK',
      'department': 'Admin',
      'Requestable': 'Pending'
    },
    {
      'Date': '2023/11/07',
      'tripID': '15',
      'description': 'Oversea',
      'Total Amount': '300000',
      'currency': 'MMK',
      'department': 'Admin',
      'Requestable': 'Pending'
    },
    {
      'Date': '2023/11/08',
      'tripID': '16',
      'description': 'Camping',
      'Total Amount': '100000',
      'currency': 'MMK',
      'department': 'Admin',
      'Requestable': 'Pending'
    },
  ];
  List<Map<String, dynamic>> filteredData = [];

  final TextEditingController _searchController = TextEditingController();

  String? selectedDate;
  DateTimeRange? CustomDateRange;
  DateTimeRange? selectedDateRange;
  DateTime? startDate;
  DateTime? endDate;

  //Search Data
  String? selectedCurrency;
  String? selectedDepartment;
  String? selectedStatus;

  List<String> currency = ["MMK", "USD"];
  List<String> department = ["Admin", "Marketing", "HR"];
  List<String> status = ["Active", "Inactive"];

  @override
  void initState() {
    super.initState();
    filteredData = List.from(tripData);
  }

  String _getDateFilterDisplayName(String value) {
    switch (value) {
      case 'today':
        return 'Today';
      case 'this_week':
        return 'This week';
      case 'this_month':
        return 'This month';
      case 'this_year':
        return 'This year';
      case 'custom_date':
        return 'Custom Date';

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
    return '${DateFormat.yMd().format(startOfMonth)} - ${DateFormat.yMd().format(endOfMonth)}';
  }

  String _getThisYearRange() {
    DateTime now = DateTime.now();
    DateTime startOfYear = DateTime(now.year, 1, 1);
    DateTime endOfYear = DateTime(now.year, 12, 31);
    return '${DateFormat.yMd().format(startOfYear)} - ${DateFormat.yMd().format(endOfYear)}';
  }

  void _filterByCustomDate(DateTimeRange chooseDateRange) {
    _filterDataByDateRange(chooseDateRange);
  }

  void _filterDataByDateRange(DateTimeRange dateRange) {
    setState(() {
      filteredData = tripData.where((data) {
        final DateTime dataDate = data['date'] as DateTime;
        return dataDate
                .isAfter(dateRange.start.subtract(const Duration(days: 1))) &&
            dataDate.isBefore(dateRange.end.add(const Duration(days: 1)));
      }).toList();
    });
  }

  void _filterByPresetDate(String filterType) {
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
    if (dateRange != null) {
      setState(() {
        selectedDate = filterType;
      });
      _filterDataByDateRange(dateRange);
    }
  }

  void _showCustomDateRangeDialog(BuildContext context) {
    DateTime initialStartDate = DateTime.now();
    DateTime initialEndDate = DateTime.now();

    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text("Choose Custom Date"),
            content: StatefulBuilder(
                builder: (BuildContext context, StateSetter setState) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text("Select Start Date: "),
                  const SizedBox(
                    height: 10,
                  ),
                  ElevatedButton(
                      onPressed: () async {
                        DateTime? chooseStartDate = await showDatePicker(
                            context: context,
                            firstDate: DateTime(2000),
                            lastDate: DateTime(3000));

                        if (chooseStartDate != null) {
                          setState(() {
                            initialStartDate = chooseStartDate;
                          });
                        }
                      },
                      child: Text(DateFormat.yMd().format(initialStartDate))),
                  const SizedBox(
                    height: 20,
                  ),
                  const Text('Select End Date: '),
                  const SizedBox(
                    height: 10,
                  ),
                  ElevatedButton(
                      onPressed: () async {
                        DateTime? chooseEndDate = await showDatePicker(
                            context: context,
                            initialDate: initialEndDate,
                            firstDate: DateTime(2000),
                            lastDate: DateTime(3000));

                        if (chooseEndDate != null) {
                          setState(() {
                            initialEndDate = chooseEndDate;
                          });
                        }
                      },
                      child: Text(DateFormat.yMd().format(initialEndDate)))
                ],
              );
            }),
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

  // Search Data
  void _AdvanceSearchDialog() {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            content: StatefulBuilder(builder: (context, setStateDialog) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _dropDown(
                      title: "Currency",
                      value: selectedCurrency,
                      options: currency,
                      onChanged: (newValue) {
                        setStateDialog(() {
                          selectedCurrency = newValue;
                        });
                        _updateSearch();
                      }),
                  _dropDown(
                      title: "Department",
                      value: selectedDepartment,
                      options: department,
                      onChanged: (newValue) {
                        setStateDialog(() {
                          selectedDepartment = newValue;
                        });
                        _updateSearch();
                      }),
                  _dropDown(
                      title: "Status",
                      value: selectedStatus,
                      options: status,
                      onChanged: (newValue) {
                        setStateDialog(() {
                          selectedStatus = newValue;
                        });
                        _updateSearch();
                      })
                ],
              );
            }),
            actions: [
              TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text("Close"))
            ],
          );
        });
  }

  Widget _dropDown({
    required String title,
    required String? value,
    required List<String> options,
    required Function(String?) onChanged,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          DropdownButton(
              isExpanded: true,
              value: value,
              hint: Text("Select $title"),
              items: options.map((String option) {
                return DropdownMenuItem<String>(
                    value: option, child: Text(option));
              }).toList(),
              onChanged: onChanged)
        ],
      ),
    );
  }

  void _updateSearch() {
    List<String> filters = [];
    if (selectedCurrency != null) filters.add(selectedCurrency!);
    if (selectedDepartment != null) filters.add(selectedDepartment!);
    if (selectedStatus != null) filters.add(selectedStatus!);

    setState(() {
      _searchController.text = filters.join(" | ");
    });
  }

  void _addTrip(List<Map<String, String>> newTrip) {
    setState(() {
      tripData.addAll(newTrip);
    });
  }

  //Delete
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
        tripData.removeAt(index);
      });
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Trip Data is deleted successfully")));
    }
  }

  @override
  Widget build(BuildContext context) {
    List<Map<String, dynamic>> filteredTrip = tripData.where((trip) {
      return filteredData.every((filter) => trip.values.contains(filter));
    }).toList();
    return Scaffold(
      body: Column(
        children: [
          Row(
            children: [
              Container(
                child: Padding(
                  padding: const EdgeInsets.only(left: 20),
                  child: DropdownButton(
                      value: selectedDate,
                      hint: const Text('Filter by Date'),
                      items: [
                        DropdownMenuItem(
                            value: 'today',
                            child: Tooltip(
                              message: DateFormat.yMd().format(DateTime.now()),
                              child: const Text('Today'),
                            )),
                        DropdownMenuItem(
                            value: 'this_week',
                            child: Tooltip(
                              message: _getThisWeekRange(),
                              child: const Text('This Week'),
                            )),
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
                            value: 'custom_date',
                            child: Tooltip(
                              message: CustomDateRange != null
                                  ? '${DateFormat.yMd().format(CustomDateRange!.start)} - ${DateFormat.yMd().format(CustomDateRange!.end)}'
                                  : 'Choose a Custom Date Range',
                              child: const Text('Custom Date'),
                            )),
                      ],
                      onChanged: (String? newValue) {
                        setState(() {
                          selectedDate = newValue;
                          if (newValue == 'custom_date') {
                            _showCustomDateRangeDialog(context);
                          } else if (newValue != null) {
                            _filterByPresetDate(newValue);
                          }
                        });
                      }),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 50),
                child: Container(
                  width: MediaQuery.of(context).size.width * 0.4,
                  child: TextField(
                    controller: _searchController,
                    onChanged: null,
                    decoration: const InputDecoration(
                      labelText: 'Search',
                      prefixIcon: Icon(Icons.search),
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
              ),
              IconButton(
                  onPressed: _AdvanceSearchDialog,
                  icon: const Icon(Icons.more_vert)),
              Container(
                // width: MediaQuery.of(context).size.width*0.1,
                // color: Colors.grey,
                child: Row(
                  children: [
                    IconButton(
                        onPressed: () async {
                          final List<Map<String, String>>? newTrip =
                              await Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          AddTrip(onTripAdded: (newTrip) {
                                            setState(() {
                                              tripData.addAll(newTrip);
                                            });
                                          })));
                        },
                        icon: const Icon(Icons.add)),
                    IconButton(
                        onPressed: () {}, icon: const Icon(Icons.refresh)),
                    IconButton(
                        onPressed: () {}, icon: const Icon(Icons.download))
                  ],
                ),
              )
            ],
          ),
          const SizedBox(
            height: 10,
          ),
          Padding(
            padding: const EdgeInsets.all(0),
            child: Container(
              child: Table(
                border: const TableBorder.symmetric(
                  inside: BorderSide(color: Colors.grey, width: 1),
                  outside: BorderSide(color: Colors.grey, width: 1),
                ),
                columnWidths: const {
                  0: FlexColumnWidth(0.5),
                  1: FlexColumnWidth(0.5),
                  2: FlexColumnWidth(2.0),
                  3: FlexColumnWidth(0.8),
                  4: FlexColumnWidth(0.4),
                  5: FlexColumnWidth(0.4),
                  6: FlexColumnWidth(0.5),
                  7: FlexColumnWidth(0.7)
                },
                children: const [
                  TableRow(
                      decoration: BoxDecoration(
                          color: Color.fromARGB(255, 167, 230, 232)),
                      children: [
                        Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Text(
                            "Request Date",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Text("Trip Code",
                              style: TextStyle(fontWeight: FontWeight.bold)),
                        ),
                        Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Text(
                            "Trip Description",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Text(
                            "Total Amount",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Text(
                            "Currency",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Text(
                            "Department",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Text(
                            "Requestable",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Text(
                            "Action",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                      ]),
                ],
              ),
            ),
          ),
          Expanded(
              child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Container(
              // height: 500,
              child: Table(
                border: const TableBorder.symmetric(
                  inside: BorderSide(color: Colors.grey, width: 1),
                  outside: BorderSide(color: Colors.black, width: 1),
                ),
                columnWidths: const {
                  0: FlexColumnWidth(0.5),
                  1: FlexColumnWidth(0.5),
                  2: FlexColumnWidth(2.0),
                  3: FlexColumnWidth(0.8),
                  4: FlexColumnWidth(0.4),
                  5: FlexColumnWidth(0.4),
                  6: FlexColumnWidth(0.5),
                  7: FlexColumnWidth(0.7),
                },
                children: tripData.map((row) {
                  return TableRow(children: [
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
                              onPressed: () {},
                              icon: const Icon(Icons.edit),
                              color: Colors.black),
                          IconButton(
                              onPressed: () {
                                _deleteConfirmation(tripData.indexOf(row));
                              },
                              icon: const Icon(Icons.delete),
                              color: Colors.black),
                          IconButton(
                              onPressed: () {},
                              icon: const Icon(Icons.more_horiz_outlined),
                              color: Colors.black),
                        ],
                      ),
                    ),
                  ]);
                }).toList(),
              ),
            ),
          ))
        ],
      ),
    );
  }
}
