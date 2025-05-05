import 'package:advance_budget_request_system/views/api_service.dart';
import 'package:advance_budget_request_system/views/data.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class Approvalsetupentry extends StatefulWidget {
  const Approvalsetupentry({super.key});

  @override
  State<Approvalsetupentry> createState() => _ApprovalsetupentryState();
}

class _ApprovalsetupentryState extends State<Approvalsetupentry> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold();
  }
}

class ApprovalEntryForm extends StatefulWidget {
  final Function(ApprovalSetup) approvalAdded;

  const ApprovalEntryForm({Key? key, required this.approvalAdded})
      : super(key: key);
  @override
  State<ApprovalEntryForm> createState() => _ApprovalEntryFormState();
}

class _ApprovalEntryFormState extends State<ApprovalEntryForm> {
  List<ApprovalSetup> filterData = [];
  String? selectedDepartmentId;
  String? selectedDepartmentName;
  String? selectedReqType;
  String? selectedCurrencies;
  int? selectedSteps;
  String managementApprover = "No";

  final _formkey = GlobalKey<FormState>();

  final TextEditingController flownameController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  late List<TextEditingController> approverControllers = [];
  late List<TextEditingController> maxAmountControllers = [];
  late List<TextEditingController> emailControllers = [];

  final List<int> _steps = [1, 2, 3, 4, 5];
  List<Department> _departments = [];
  final List<String> _currencies = ['MMK', 'USD'];

  final List<String> _type = ['Project', 'Trip', 'Operation'];

  // ignore: unused_element
  void _clearText() {
    setState(() {
      flownameController.clear();
      descriptionController.clear();
      approverControllers.forEach((controller) => controller.clear());
      maxAmountControllers.forEach((controller) => controller.clear());
      emailControllers.forEach((controller) => controller.clear());
      selectedCurrencies = 'MMK';
      selectedReqType = null;
      selectedDepartmentName = null;
      selectedSteps = 1;
      managementApprover = "No";
      _initializeControllers();
    });
  }

  @override
  void initState() {
    super.initState();
    selectedSteps = 1;
    _initializeControllers();
    _fetchData();
  }

  void _fetchData() async {
    final ApiService apiService = ApiService();
    try {
      List<Department> departments = await apiService.fetchDepartment();
      setState(() {
        _departments = departments;
      });
    } catch (e) {
      // Handle error
      print('Error fetching departments: $e');
    }
  }

  void _initializeControllers() {
     for (var controller in approverControllers) {
      controller.dispose();
    }
    for (var controller in maxAmountControllers) {
      controller.dispose();
    }
    for (var controller in emailControllers) {
      controller.dispose();
    }

    // Create new controllers
    approverControllers = 
        List.generate(selectedSteps!, (index) => TextEditingController());
    maxAmountControllers = 
        List.generate(selectedSteps!, (index) => TextEditingController());
    emailControllers = 
        List.generate(selectedSteps!, (index) => TextEditingController());
  }

  // void _submitForm() async {
  //   if (_formkey.currentState!.validate()) {
  //      for (int i = 0; i < selectedSteps!; i++) {
  //       if (approverControllers[i].text.isEmpty || 
  //           maxAmountControllers[i].text.isEmpty ||
  //           emailControllers[i].text.isEmpty) {
  //         ScaffoldMessenger.of(context).showSnackBar(
  //           const SnackBar(content: Text('Please fill all approver fields')),
  //         );
  //         return;
  //       }
  //     }

  //     //generated ID
  //     final ApiService apiService = ApiService();

  //     Future<int> generateID() async {
  //       List<ApprovalStep> existingStep = await apiService.fetchApprovalSteps();

  //       if (existingStep.isEmpty) {
  //         return 1; // Start from 1 if no budget exists
  //       }

  //       // Find the highest existing ID
  //       int maxId =
  //           existingStep.map((b) => b.id).reduce((a, b) => a > b ? a : b);
  //       return maxId + 1;
  //     }
  //     Future<int> generateSetupID() async {
  //       List<ApprovalSetup> existingSetup = await apiService.fetchApprovalSetup();

  //       if (existingSetup.isEmpty) {
  //         return 1; // Start from 1 if no budget exists
  //       }

  //       // Find the highest existing ID
  //       int maxId =
  //           existingSetup.map((b) => b.id).reduce((a, b) => a > b ? a : b);
  //       return maxId + 1;
  //     }

  //     List<ApprovalStep> approvalSteps = [];
  //     // String approvalSetupId = DateTime.now().millisecondsSinceEpoch.toString();
  //     for (int i = 0; i < selectedSteps!; i++) {
  //       approvalSteps.add(
  //         ApprovalStep(
  //           id: await generateID(),
  //           setupid: await generateSetupID(),
  //           stepNo: i + 1,
  //           approver: approverControllers[i].text,
  //           approverEmail: emailControllers[i].text,
  //           maxAmount: double.tryParse(maxAmountControllers[i].text) ?? 0.0,
  //         ),
  //       );
  //     }

  //     ApprovalSetup newApproval = ApprovalSetup(
  //         id: await generateSetupID(),
  //         FlowName: flownameController.text,
  //         departmentId: int.parse(selectedDepartmentId!),
  //         departmentName: selectedDepartmentName!,
  //         RequestType: selectedReqType!,
  //         Currency: selectedCurrencies!,
  //         Description: descriptionController.text,
  //         No_of_Steps: int.parse(selectedSteps.toString()),
  //         Management: managementApprover == "Yes" ? "Yes" : "No",
  //         ApprovalSteps: approvalSteps);
      

  //     print('New Approval Setup: $newApproval');

  //     try {
  //       await ApiService.postApprovalSetup(newApproval);
  //       for (ApprovalStep step in approvalSteps) {
  //         await ApiService.postApprovalStep(step);
  //       }

  //       ScaffoldMessenger.of(context).showSnackBar(
  //         const SnackBar(content: Text("Approval data can add successfully!!")),
  //       );
  //       widget.approvalAdded(newApproval);
  //       Navigator.pop(context, true);
  //     } catch (e) {
  //       ScaffoldMessenger.of(context).showSnackBar(
  //         SnackBar(content: Text('Failed to add Approval: $e')),
  //       );
  //     }
  //   }
  // }

//   void _submitForm() async {
//   if (_formkey.currentState!.validate()) {
//     // Validate all fields
//     if (selectedDepartmentId == null || 
//         selectedReqType == null ||
//         selectedCurrencies == null) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text('Please fill all required fields')),
//       );
//       return;
//     }

//     // Validate all approver fields
//     for (int i = 0; i < selectedSteps!; i++) {
//       if (approverControllers[i].text.isEmpty || 
//           maxAmountControllers[i].text.isEmpty ||
//           emailControllers[i].text.isEmpty) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           const SnackBar(content: Text('Please fill all approver fields')),
//         );
//         return;
//       }
//     }

    // //generated ID
    final ApiService apiService = ApiService();
    Future<int> generateID() async {
      List<ApprovalStep> existingStep = await apiService.fetchApprovalSteps();

      if (existingStep.isEmpty) {
        return 1; // Start from 1 if no budget exists
      }

      // Find the highest existing ID
      int maxId =
          existingStep.map((b) => b.id).reduce((a, b) => a > b ? a : b);
      return maxId + 1;
    }
    Future<int> generateSetupID() async {
      List<ApprovalSetup> existingSetup = await apiService.fetchApprovalSetup();

      if (existingSetup.isEmpty) {
        return 1; // Start from 1 if no budget exists
      }

      // Find the highest existing ID
      int maxId =
          existingSetup.map((b) => b.id).reduce((a, b) => a > b ? a : b);
      return maxId + 1;
    }
//     try {
//      final nextId= await generateSetupID();
//       // First create the ApprovalSetup
//       final newApproval = ApprovalSetup(
//         id: nextId, 
//         FlowName: flownameController.text,
//         departmentId: int.parse(selectedDepartmentId!),
//         departmentName: selectedDepartmentName!,
//         RequestType: selectedReqType!,
//         Currency: selectedCurrencies!,
//         Description: descriptionController.text,
//         No_of_Steps: selectedSteps!,
//         Management: managementApprover == "Yes" ? "Yes" : "No",
//         ApprovalSteps: [], // Empty for now
//       );

//       // POST the setup first
//       final createdSetup = await ApiService.postApprovalSetup(newApproval);
//       int setupId = createdSetup.id; // Get the ID from the created setup
      
//       // Then create the steps with the valid setup ID
//       final List<ApprovalStep> approvalSteps = [];
//       for (int i = 0; i < selectedSteps!; i++) {
//         final step = ApprovalStep(
//           id: await generateID(), 
//           setupid: setupId, 
//           stepNo: i + 1,
//           approver: approverControllers[i].text,
//           approverEmail: emailControllers[i].text,
//           maxAmount: double.tryParse(maxAmountControllers[i].text) ?? 0.0,
//         );
//         approvalSteps.add(step);
//         await ApiService.postApprovalStep(step);
//       }

//       // Update the setup with the steps (if needed)
//       // final updatedSetup = createdSetup.copyWith(ApprovalSteps: approvalSteps);

//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text("Approval created successfully!")),
//       );
//       // widget.approvalAdded(updatedSetup);
//       Navigator.pop(context, true);
//     } catch (e) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('Failed to create approval: $e')),
//       );
//     }
//   }
// }

// void _submitForm() async {
//   if (_formkey.currentState!.validate()) {
//     try {

//       // Prepare approval steps (without setupid for now)
//       final approvalSteps = List.generate(selectedSteps!, (i) async => ApprovalStep(
//         id: 0, // Will be assigned by server
//         setupid: 0, // Will be updated after setup creation
//         stepNo: i + 1,
//         approver: approverControllers[i].text,
//         approverEmail: emailControllers[i].text,
//         maxAmount: double.tryParse(maxAmountControllers[i].text) ?? 0.0,
//       ));

//       // Create the ApprovalSetup
//       final newApproval = ApprovalSetup(
//         id: 0, // Will be assigned by server
//         FlowName: flownameController.text,
//         departmentId: int.parse(selectedDepartmentId!),
//         departmentName: selectedDepartmentName!,
//         RequestType: selectedReqType!,
//         Currency: selectedCurrencies!,
//         Description: descriptionController.text,
//         No_of_Steps: selectedSteps!,
//         Management: managementApprover == "Yes" ? "Yes" : "No",
//         ApprovalSteps: await Future.wait(approvalSteps),
//       );

//       // Post to API (which will handle the two-step creation)
//       final createdSetup = await ApiService.postApprovalSetup(newApproval);

//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text("Approval created successfully!")),
//       );
//       widget.approvalAdded(createdSetup);
//       Navigator.pop(context, true);
//     } catch (e) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('Failed to create approval: $e')),
//       );
//     }
//   }
// }

void _submitForm() async {
  if (_formkey.currentState!.validate()) {
    try {
      // Create the ApprovalSetup without ID and steps
      final newApproval = ApprovalSetup(
        id: await generateSetupID(), // Send 0 or null, let server assign ID
        FlowName: flownameController.text,
        departmentId: int.parse(selectedDepartmentId!),
        departmentName: selectedDepartmentName!,
        RequestType: selectedReqType!,
        Currency: selectedCurrencies!,
        Description: descriptionController.text,
        No_of_Steps: selectedSteps!,
        Management: managementApprover == "Yes" ? "Yes" : "No",
        ApprovalSteps: [], 
      );


      final createdSetup = await ApiService.postApprovalSetup(newApproval);
      
      for (int i = 0; i < selectedSteps!; i++) {
        final step = ApprovalStep(
          id: await generateID(), // Let server generate
          setupid: createdSetup.id, // Use ID from created setup
          stepNo: i + 1,
          approver: approverControllers[i].text,
          approverEmail: emailControllers[i].text,
          maxAmount: double.tryParse(maxAmountControllers[i].text) ?? 0.0,
        );
        await ApiService.postApprovalStep(step);
      }

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Approval created successfully!")),
      );
      widget.approvalAdded(createdSetup);
      Navigator.pop(context, true);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to create approval: $e')),
      );
    }
  }
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Approval Setup Entry Form'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: Container(
            width: MediaQuery.of(context).size.width * 0.5,
            padding: const EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              color: const Color.fromARGB(255, 103, 207, 177),
              borderRadius: BorderRadius.circular(15),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.3),
                  blurRadius: 10,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: Form(
              key: _formkey,
              child: Column(
                children: [
                  const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Center(
                      child: Text(
                        "Add Approval Setup",
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
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
                                controller: flownameController,
                                decoration: const InputDecoration(
                                  labelText: "Enter Flow Name",
                                ),
                                validator: (value) {
                                  if (value == null) {
                                    return "Please Enter Flow Name";
                                  }
                                  return null;
                                },
                              ),
                            ),
                            ListTile(
                              title: DropdownButtonFormField<String>(
                                value: selectedDepartmentName,
                                decoration: const InputDecoration(
                                    labelText: "Department"),
                                items: _departments.map((dept) {
                                  return DropdownMenuItem<String>(
                                    value: dept.departmentName,
                                    child: Text(dept.departmentName),
                                    onTap: () {
                                      selectedDepartmentId =
                                          dept.id.toString(); // Store ID
                                    },
                                  );
                                }).toList(),
                                onChanged: (value) {
                                  setState(() {
                                    selectedDepartmentName = value;
                                  });
                                },
                                validator: (value) =>
                                    value == null ? "Select department" : null,
                              ),
                            ),
                            ListTile(
                              title: TextFormField(
                                controller: descriptionController,
                                decoration: const InputDecoration(
                                  labelText: "Enter Description",
                                ),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return "Please Enter Description";
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
                              title: DropdownButtonFormField(
                                decoration: const InputDecoration(
                                    labelText: "Selected Request Type"),
                                items: _type.map((type) {
                                  return DropdownMenuItem(
                                      value: type, child: Text(type));
                                }).toList(),
                                onChanged: (value) {
                                  setState(() {
                                    selectedReqType = value!;
                                  });
                                },
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return "Please select request type";
                                  }
                                  return null;
                                },
                              ),
                            ),
                            ListTile(
                              title: DropdownButtonFormField(
                                decoration: const InputDecoration(
                                    labelText: "Selected Currency"),
                                items: _currencies.map((currency) {
                                  return DropdownMenuItem(
                                      value: currency, child: Text(currency));
                                }).toList(),
                                onChanged: (value) {
                                  setState(() {
                                    selectedCurrencies = value!;
                                  });
                                },
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return "Please select currency";
                                  }
                                  return null;
                                },
                              ),
                            ),
                            ListTile(
                              title: DropdownButtonFormField<int>(
                                decoration: const InputDecoration(
                                    labelText: "Selected Approval Steps"),
                                value: selectedSteps,
                                items: _steps.map((step) {
                                  return DropdownMenuItem<int>(
                                      value: step,
                                      child: Text(step.toString()));
                                }).toList(),
                                onChanged: (value) {
                                  setState(() {
                                    selectedSteps = value!;
                                    _initializeControllers();
                                  });
                                },
                                validator: (value) {
                                  if (value == null) {
                                    return "Please select approval steps";
                                  }
                                  return null;
                                },
                              ),
                            ),
                            const SizedBox(height: 20),
                            Row(children: [
                              Checkbox(
                                value: managementApprover.toString() == "Yes",
                                onChanged: (value) {
                                  setState(() {
                                    managementApprover = value! ? "Yes" : "No";
                                  });
                                },
                              ),
                              const Text('Management Approver'),
                            ])
                          ],
                        ),
                      )
                    ],
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  if (selectedSteps != null)
                    Expanded(
                      child: SingleChildScrollView(
                        child: Table(
                          border: TableBorder.all(color: Colors.grey),
                          columnWidths: const {
                            0: FlexColumnWidth(1),
                            1: FlexColumnWidth(2),
                            2: FlexColumnWidth(2),
                            3: FlexColumnWidth(2),
                          },
                          children: [
                            const TableRow(
                              children: [
                                Padding(
                                  padding: EdgeInsets.all(8.0),
                                  child: Text('Step No',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold)),
                                ),
                                Padding(
                                  padding: EdgeInsets.all(8.0),
                                  child: Text('Approvers',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold)),
                                ),
                                Padding(
                                  padding: EdgeInsets.all(8.0),
                                  child: Text('Maximum Amount',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold)),
                                ),
                                Padding(
                                  padding: EdgeInsets.all(8.0),
                                  child: Text('Approver Email',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold)),
                                ),
                              ],
                            ),
                            ...List.generate(selectedSteps!, (index) {
                              return TableRow(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(16.0),
                                    child: Text((index + 1).toString()),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: TextFormField(
                                      controller: approverControllers[index],
                                      decoration: const InputDecoration(
                                        hintText: 'Enter Approver',
                                        border: OutlineInputBorder(),
                                        enabledBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                              color: Colors.grey, width: 1.0),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: TextFormField(
                                      controller: maxAmountControllers[index],
                                      decoration: const InputDecoration(
                                        hintText: 'Enter  Maximum Amount',
                                        border: OutlineInputBorder(),
                                        enabledBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                              color: Colors.grey, width: 1.0),
                                        ),
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
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: TextFormField(
                                      controller: emailControllers[index],
                                      decoration: const InputDecoration(
                                        hintText: 'Enter Approver Email',
                                        border: OutlineInputBorder(),
                                        enabledBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                              color: Colors.grey, width: 1.0),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              );
                            }),
                          ],
                        ),
                      ),
                    ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      ElevatedButton(
                        onPressed: _submitForm,
                        child: const Text('Submit'),
                      ),
                      const SizedBox(width: 10),
                      ElevatedButton(
                        onPressed: () {
                          _clearText();
                        },
                        child: const Text('Cancel'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
