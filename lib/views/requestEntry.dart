import 'package:advance_budget_request_system/views/advanceRequest.dart';
import 'package:advance_budget_request_system/views/api_service.dart';
import 'package:advance_budget_request_system/views/data.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class AdvanceRequestEntry extends StatefulWidget {
  final Function(AdvanceRequest) onRequestAdded;
  const AdvanceRequestEntry({Key? key, required this.onRequestAdded})
      : super(key: key);

  @override
  State<AdvanceRequestEntry> createState() => _AdvanceRequestEntryState();
}

class _AdvanceRequestEntryState extends State<AdvanceRequestEntry> {
  final _formkey = GlobalKey<FormState>();
  bool project_bcodeTable = false;
  bool trip_bcodeTable = false;
  bool multiselect = false;

  late final TextEditingController _reqNoController;
  final TextEditingController _requester = TextEditingController(text: "May");
  final TextEditingController _dateController = TextEditingController(
      text: DateFormat('yyyy-MM-dd').format(DateTime.now()));
  final TextEditingController _totalAmtController = TextEditingController();
  final TextEditingController _reqPurposeController = TextEditingController();
  final TextEditingController _reqCodeController = TextEditingController();
  final TextEditingController _reqDescriptionController =
      TextEditingController();

  String _selectedCurrency = "MMK";
  String? selectedType;
  int _nextId = 1;
  int operationCounter = 1;

  List<Budget> selectedBudgetCodes = [];
  List<Budget> selectedProjectBudgets = [];
  List<Budget> selectedTripBudgets = [];

  List<AdvanceRequest> advanceRequest = [];
  List<ProjectInfo> project = [];
  List<TripInfo> trip = [];
  List<Budget> budget = [];

  @override
  void initState() {
    super.initState();
    _reqNoController = TextEditingController(
        text: 'Req-2425-${_nextId.toString().padLeft(3, '0')}');
    _fetchData();
  }

  //fetch Data
  void _fetchData() async {
    try {
      List<AdvanceRequest> advanceRequests =
          await ApiService().fetchAdvanceRequestData();
      List<ProjectInfo> projects = await ApiService().fetchProjectInfoData();
      List<TripInfo> trips = await ApiService().fetchTripinfoData();
      List<Budget> budgets = await ApiService().fetchBudgetCodeData();
      setState(() {
        advanceRequest = advanceRequests;
        project = projects;
        trip = trips;
        budget = budgets;
        print("Projects: $project");
        print("Trips: $trips");
        //AutoID
        _reqNoController.text =
            'Req-2425-${_nextId.toString().padLeft(3, '0')}';

        if (advanceRequests.isNotEmpty) {
          int maxId = advanceRequests
              .map((r) => int.tryParse(r.requestNo.split('-')[2]) ?? 0)
              .reduce((a, b) => a > b ? a : b);
          _nextId = maxId + 1;
        }
      });
    } catch (e) {
      print("Fail to load $e");
    }
  }

  //Budget Code table
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
                            rows: budget.map((budgetCode) {
                              bool isSelected = selectedBudgetCodes.any(
                                  (code) =>
                                      code.budgetCode == budgetCode.budgetCode);

                              return DataRow(
                                cells: [
                                  DataCell(
                                    isSelected
                                        ? IconButton(
                                            icon: const Icon(Icons.check_circle,
                                                color: Colors.green),
                                            onPressed: () {
                                              setState(() {
                                                selectedBudgetCodes.removeWhere(
                                                    (code) =>
                                                        code.budgetCode ==
                                                        code.description);
                                              });
                                              Navigator.pop(context);
                                              _showBudgetCodeDialog();
                                            },
                                          )
                                        : const SizedBox.shrink(),
                                  ),
                                  DataCell(Text(budgetCode.budgetCode)),
                                  DataCell(Text(budgetCode.description)),
                                ],
                                onSelectChanged: (selected) {
                                  if (selected != null && selected) {
                                    if (isSelected) {
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
                                        selectedBudgetCodes.add(budgetCode);
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
    if (selectedBudgetCodes.isNotEmpty &&
        index >= 0 &&
        index < selectedBudgetCodes.length) {
      setState(() {
        selectedBudgetCodes.removeAt(index);
      });
    } else {
      print('Cannot delete: Index $index is out of bounds or list is empty.');
    }
  }

  //clear text
  void _clearText() {
    selectedType = null;
    _reqCodeController.text = '';
    _reqDescriptionController.text = '';
    _totalAmtController.text = '';
    _selectedCurrency = 'MMK';
    _reqPurposeController.text = '';
    selectedBudgetCodes = [];
  }

  //submit button

bool _isSubmitting = false;
void _submitForm() async {
  if (_formkey.currentState!.validate() && !_isSubmitting) {
    setState(() {
      _isSubmitting = true;
    });

    AdvanceRequest newAdvance = AdvanceRequest(
      date: DateFormat('yyyy-MM-dd').parse(_dateController.text),
      requestNo: 'Req-2425-${_nextId.toString().padLeft(3, '0')}', // Use _nextId
      requestCode: _reqCodeController.text,
      requestType: selectedType!,
      requestAmount: double.tryParse(_totalAmtController.text) ?? 0.0,
      currency: _selectedCurrency,
      requester: _requester.text,
      department: 'Admin',
      approveAmount: 0.0,
      purpose: _reqPurposeController.text,
      status: 'Pending',
    );

    try {
      await ApiService().postAdvanceRequest(newAdvance);
      setState(() {
         _reqNoController.text = 'Req-2425-${_nextId.toString().padLeft(3, '0')}';
        _nextId++; // Increment _nextId
        // Update the request no
        _isSubmitting = false;
        widget.onRequestAdded(newAdvance);
      });
      _clearText();
      
      Navigator.of(context).push( 
        MaterialPageRoute(builder: (context) => Advancerequest()),
      );
      _fetchData();
    } catch (e) {
      setState(() {
        _isSubmitting = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to add request: $e'),
          duration: Duration(seconds: 3),
        ),
      );
      print('Failed to add request: $e');
    }
  }
}



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Advance Request Form"),
      ),
      body: Center(
        child: Container(
          color: const Color.fromARGB(255, 103, 207, 177),
          width: MediaQuery.of(context).size.width * 0.5,
          child: Padding(
            padding: const EdgeInsets.all(7.0),
            child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Center(
                child: Container(
                  width: MediaQuery.of(context).size.width * 0.5,
                  child: Form(
                      key: _formkey,
                      child: Column(
                        children: [
                          const Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              'Add Advnace Request',
                              style: TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold),
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
                                      controller: _reqNoController,
                                      decoration: const InputDecoration(
                                          labelText: "Request Code"),
                                      readOnly: true,
                                    ),
                                  ),
                                  ListTile(
                                      title: DropdownButtonFormField(
                                    value: selectedType,
                                    items: ['project', 'trip', 'operation']
                                        .map((selectedType) => DropdownMenuItem(
                                              value: selectedType,
                                              child: Text(selectedType),
                                            ))
                                        .toList(),
                                    onChanged: (value) {
                                      setState(() {
                                        selectedType = value!;
                                        if (selectedType == "project") {
                                          showProjectDialog();
                                          multiselect = false;
                                          trip_bcodeTable = false;
                                          selectedBudgetCodes = [];
                                        } else if (selectedType == "trip") {
                                          showTripDialog();
                                          multiselect = false;
                                          project_bcodeTable = false;
                                          selectedBudgetCodes = [];
                                        } else if (selectedType ==
                                            "operation") {
                                          multiselect == true;
                                          project_bcodeTable = false;
                                          trip_bcodeTable = false;
                                          _reqCodeController.text =
                                              'OPT-2425-${operationCounter.toString().padLeft(4, '0')}';
                                          operationCounter++;
                                          _reqDescriptionController.text =
                                              'No need to Filled';
                                        } else {
                                          multiselect = false;
                                          project_bcodeTable = false;
                                          trip_bcodeTable = false;
                                        }
                                      });
                                    },
                                    decoration: const InputDecoration(
                                      labelText: 'Request Type',
                                    ),
                                  )),
                                  ListTile(
                                    title: TextFormField(
                                      controller: _totalAmtController,
                                      decoration: const InputDecoration(
                                          labelText: "Enter Total Amount"),
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
                              )),
                              Expanded(
                                  child: Column(
                                children: [
                                  ListTile(
                                    title: TextFormField(
                                      controller: _requester,
                                      decoration: const InputDecoration(
                                          labelText: "Requester"),
                                      readOnly: true,
                                    ),
                                  ),
                                  ListTile(
                                    title: TextFormField(
                                      controller: _reqCodeController,
                                      decoration: const InputDecoration(
                                          labelText: "Request Code"),
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
                                ],
                              )),
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
                                    title: TextFormField(
                                      controller: _reqDescriptionController,
                                      decoration: const InputDecoration(
                                          labelText: "Request Description"),
                                      readOnly: true,
                                      style: TextStyle(
                                        color: selectedType == "operation"
                                            ? Colors.red
                                            : Colors.black,
                                      ),
                                    ),
                                  ),
                                  ListTile(
                                    title: TextFormField(
                                      controller: _reqPurposeController,
                                      decoration: const InputDecoration(
                                          labelText: "Enter Request Purpose"),
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return "Enter Request Purpose";
                                        }
                                        return null;
                                      },
                                    ),
                                  ),
                                ],
                              ))
                            ],
                          ),
                          // if (selectedType != null)
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              children: [
                                if (selectedType == "operation")
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
                                  height:
                                      MediaQuery.of(context).size.height * 0.3,
                                  child: SingleChildScrollView(
                                      scrollDirection: Axis.vertical,
                                      child: DataTable(
                                        border: TableBorder.all(),
                                        columns: [
                                          const DataColumn(
                                              label: Text("Budget Code")),
                                          const DataColumn(
                                              label: Text("Description")),
                                          if (selectedType == "operation")
                                            const DataColumn(
                                                label: Text("Action"))
                                        ],
                                        rows: selectedBudgetCodes
                                            .map((budgetCode) {
                                          final index = selectedBudgetCodes
                                              .indexOf(budgetCode);
                                          return DataRow(cells: [
                                            DataCell(
                                                Text(budgetCode.budgetCode)),
                                            DataCell(
                                                Text(budgetCode.description)),
                                            if (selectedType == "operation")
                                              DataCell(
                                                IconButton(
                                                  onPressed: () {
                                                    _deleteBudgetCode(index);
                                                  },
                                                  icon:
                                                      const Icon(Icons.delete),
                                                ),
                                              ),
                                          ]);
                                        }).toList(),
                                      )),
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    ElevatedButton(
                                      onPressed:_isSubmitting ? null : _submitForm,
                                      style: ElevatedButton.styleFrom(
                                        textStyle: const TextStyle(
                                          fontSize: 15,
                                        ),
                                        backgroundColor: Colors.white,
                                        foregroundColor: Colors.black,
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 20, vertical: 12),
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(8),
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
                                          borderRadius:
                                              BorderRadius.circular(8),
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
                            ),
                          )
                        ],
                      )),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  //Project Dialog
  void showProjectDialog() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return StatefulBuilder(builder: (context, setState) {
            return AlertDialog(
              title: const Text("Project Table"),
              content: SingleChildScrollView(
                child: ProjectTable(
                    projects: project,
                    onRowSelected:
                        (String selectedProjectCode, String selectedDes) {
                      setState(() {
                        _reqCodeController.text = selectedProjectCode;
                        _reqDescriptionController.text = selectedDes;

                        // ProjectInfo selectedProject = project.firstWhere(
                        //     (project) =>
                        //         project.projectID == selectedProjectCode);
                      });
                    }),
              ),
              actions: [
                TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: const Text("OK")),
              ],
            );
          });
        });
  }

  //Trip Dialog
  void showTripDialog() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
              title: const Text("Trip Table"),
              content: SingleChildScrollView(
                child: TripTable(
                    trips: trip,
                    onRowSelected:
                        (String selectedTripCode, String selectedDes) {
                      setState(() {
                        _reqCodeController.text = selectedTripCode;
                        _reqDescriptionController.text = selectedDes;

                        // TripInfo selectedTrip = trip.firstWhere(
                        //     (trip) => trip.tripID == selectedTripCode);
                      });
                    }),
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text("OK"),
                )
              ]);
        });
  }
}

//Project Table
class ProjectTable extends StatelessWidget {
  final List<ProjectInfo> projects;
  final void Function(String, String) onRowSelected;
  const ProjectTable(
      {required this.projects, required this.onRowSelected, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    //filter projects data (requestable yes only)
    final filteredProjects =
        projects.where((project) => project.requestable == "Yes").toList();

    if (filteredProjects.isEmpty) {
      return const Center(
        child: Text("No project"),
      );
    }

    return Container(
      // width: 400,
      // height: 300,
      child: DataTable(
          showCheckboxColumn: false,
          columns: const [
            DataColumn(
                label: Text(
              "Project Code",
              style: TextStyle(fontWeight: FontWeight.bold),
            )),
            DataColumn(
                label: Text(
              "Project Description",
              style: TextStyle(fontWeight: FontWeight.bold),
            )),
            DataColumn(
                label: Text(
              "Total Amount",
              style: TextStyle(fontWeight: FontWeight.bold),
            )),
            DataColumn(
                label: Text(
              "Currency",
              style: TextStyle(fontWeight: FontWeight.bold),
            )),
            DataColumn(
                label: Text(
              "Requestable",
              style: TextStyle(fontWeight: FontWeight.bold),
            )),
          ],
          rows: filteredProjects.map((project) {
            return DataRow(
                cells: [
                  DataCell(Text(project.projectID)),
                  DataCell(Text(project.description)),
                  DataCell(Text(project.totalAmount)),
                  DataCell(Text(project.currency)),
                  DataCell(Text(project.requestable)),
                ],
                onSelectChanged: (bool? selected) {
                  if (selected ?? false) {
                    onRowSelected(project.projectID, project.description);
                    Future.delayed(const Duration(milliseconds: 100), () {
                      Navigator.of(context).pop();
                    });
                  }
                });
          }).toList()),
    );
  }
}

// //Trip Table
class TripTable extends StatelessWidget {
  final List<TripInfo> trips;
  final void Function(String, String) onRowSelected;
  const TripTable({required this.trips, required this.onRowSelected, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      // width: 400,
      // height: 400,
      child: DataTable(
        showCheckboxColumn: false,
        columns: const [
          DataColumn(
              label: Text(
            "Trip Code",
            style: TextStyle(fontWeight: FontWeight.bold),
          )),
          DataColumn(
              label: Text(
            "Trip Description",
            style: TextStyle(fontWeight: FontWeight.bold),
          )),
          DataColumn(
              label: Text(
            "Total Amount",
            style: TextStyle(fontWeight: FontWeight.bold),
          )),
          DataColumn(
              label: Text(
            "Currency",
            style: TextStyle(fontWeight: FontWeight.bold),
          )),
        ],
        rows: trips.map((trip) {
          return DataRow(
              cells: [
                DataCell(Text(trip.tripID)),
                DataCell(Text(trip.description)),
                DataCell(Text(trip.totalAmount)),
                DataCell(Text(trip.currency)),
              ],
              onSelectChanged: (bool? selected) {
                if (selected ?? false) {
                  onRowSelected(trip.tripID, trip.description);
                  Future.delayed(const Duration(milliseconds: 100), () {
                    Navigator.of(context).pop();
                  });
                }
              });
        }).toList(),
      ),
    );
  }
}
