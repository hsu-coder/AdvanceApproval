// import 'dart:math';

// import 'package:advance_budget_request_system/views/api_service.dart';
// import 'package:advance_budget_request_system/views/data.dart';
// import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';

// class SettlementEntry extends StatefulWidget {
//   final CashPayment selectedPayment;
//   final List<CashPayment> payment;
//   final Function(CashPayment) onPaymentSettled;
//   const SettlementEntry(
//       {Key? key,
//       required this.selectedPayment,
//       required this.onPaymentSettled,
//       required this.payment})
//       : super(key: key);

//   @override
//   State<SettlementEntry> createState() => _SettlementEntryState();
// }

// class _SettlementEntryState extends State<SettlementEntry> {
//   final _formkey = GlobalKey<FormState>();
//   List<CashPayment> payment = [];
//   List<Budget> _budgetDetails = [];
//   final Map<String, TextEditingController> _budgetAmountControllers = {};

//   @override
//   void initState() {
//     super.initState();
//     _populatedForm(widget.selectedPayment);
//     _settleAmountController.addListener(_updateRefundAmount);
//   }

//   void _fetchData() async {
//     List<CashPayment> payments = await ApiService().fetchCashPaymentData();
//     setState(() {
//       payment = payments;
//     });
//   }

//   final TextEditingController _dateController = TextEditingController(
//       text: DateFormat('yyyy-MM-dd').format(DateTime.now()));
//   final TextEditingController _paymentNoController = TextEditingController();
//   final TextEditingController _requestTypeController = TextEditingController();
//   final TextEditingController _withdrawnAmountController =
//       TextEditingController();
//   final TextEditingController _requestNoController = TextEditingController();
//   final TextEditingController _currency = TextEditingController();
//   final TextEditingController _settleAmountController = TextEditingController();
//   late TextEditingController _refundAmountController = TextEditingController();

//   CashPayment? _selectedPayment;
//   void _populatedForm(CashPayment payment) {
//     _paymentNoController.text = payment.paymentNo;
//     _requestTypeController.text = payment.requestType;
//     _currency.text = payment.currency;
//     _withdrawnAmountController.text = payment.paymentAmount.toString();
//     // _budgetDetails = payment.budgetDetails;
//     _requestNoController.text = payment.requestCode;

//     for (var budget in _budgetDetails) {
//       _budgetAmountControllers[budget.BudgetCode] = TextEditingController();
//     }
//   }

//   //generated ID
//   String generateRandomId(int length) {
//     const chars = 'abcdefghijklmnopqrstuvwxyz0123456789';
//     Random rnd = Random();
//     return List.generate(length, (_) => chars[rnd.nextInt(chars.length)])
//         .join();
//   }

//   //Calculate withdrawn amount
//   void _calculateSettleAmount() {
//     double total = 0.0;
//     for (var budget in _budgetDetails) {
//       double amount =
//           double.tryParse(_budgetAmountControllers[budget.BudgetCode]!.text) ??
//               0.0;
//       total += amount;
//     }
//     _settleAmountController.text = total.toStringAsFixed(2);
//     _updateRefundAmount();
//   }

//   //Refund Amount Calculation
//   void _updateRefundAmount() {
//     double withdrawnAmount =
//         double.tryParse(_withdrawnAmountController.text) ?? 0.0;
//     double settleAmount = double.tryParse(_settleAmountController.text) ?? 0.0;
//     double refundAmount = withdrawnAmount - settleAmount;
//     _refundAmountController.text = refundAmount.toStringAsFixed(2);
//   }

//   //Dispose
//   @override
//   void dispose() {
//     _withdrawnAmountController.removeListener(_updateRefundAmount);
//     _settleAmountController.removeListener(_updateRefundAmount);
//     _withdrawnAmountController.dispose();
//     _settleAmountController.dispose();
//     _refundAmountController.dispose();

//     super.dispose();
//   }

//   //generate AutoID
//   final apiService = ApiService();
//   Future<int> generateSettlementID() async {  
//     List<SettlementInfo> existingsettle = await apiService.fetchSettlementData();

//     if (existingsettle.isEmpty) {
//       return 1; 
//     }

//     // Find the highest existing ID
//     int maxId =
//         existingsettle.map((b) => b.id).reduce((a, b) => a > b ? a : b);
//     return maxId + 1;
//   }

//   //submit button
//   void _submitForm() async {
//     if (_formkey.currentState!.validate()) {
//       for (var budget in _budgetDetails) {
//         budget.Amount = double.tryParse(
//                 _budgetAmountControllers[budget.BudgetCode]!.text) ??
//             0.0;
//       }
//       double settleAmount =
//           double.tryParse(_settleAmountController.text) ?? 0.0;
//         int newId = await generateSettlementID();
//       SettlementInfo newSettlement = SettlementInfo(
//           id: newId,
//           date: DateFormat('yyyy-MM-dd').parse(_dateController.text),
//           paymentId: widget.selectedPayment.id,
//           currency: _currency.text,
//           requestNo: _requestNoController.text,
//           paymentNo: _paymentNoController.text,
//           withdrawnAmount:
//               double.tryParse(_withdrawnAmountController.text) ?? 0.0,
//           settleAmount: settleAmount,
//           refundAmount: double.tryParse(_refundAmountController.text) ?? 0.0,
//           settlementDetails: [],
//           budgetDetails: _budgetDetails);
//       try {
//         CashPayment updatepayment = widget.selectedPayment;
//         updatepayment.settledStatus = 1;
//         await ApiService().postSettlement(newSettlement);
//         await ApiService().updateCashPayment(updatepayment);
//         ScaffoldMessenger.of(context).showSnackBar(
//             const SnackBar(content: Text("Settlement added successfully!!")));
//         // Navigator.of(context)
//         //     .push(MaterialPageRoute(builder: (context) => const Settlement()));
//         Navigator.pop(context, _selectedPayment);
//       } catch (e) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(content: Text("Failed to add cash payment: $e")),
//         );
//       }
//     }
//   }

//   //Clear Text
//   void _clearText() {
//     setState(() {
//       _paymentNoController.text = '';
//       _requestTypeController.text = '';
//       _currency.text = '';
//       _withdrawnAmountController.text = '';
//       _settleAmountController.text = '';
//       _refundAmountController.text = '';
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text("Settlement Form"),
//       ),
//       body: Center(
//         child: Container(
//           decoration: BoxDecoration(
//               color: const Color.fromARGB(255, 103, 207, 177),
//               borderRadius: BorderRadius.circular(15)),
//           width: MediaQuery.of(context).size.width * 0.5,
//           child: Padding(
//             padding: const EdgeInsets.all(7.0),
//             child: SingleChildScrollView(
//               scrollDirection: Axis.vertical,
//               child: Container(
//                 width: MediaQuery.of(context).size.width * 0.5,
//                 child: Form(
//                     key: _formkey,
//                     child: Column(
//                       children: [
//                         const Padding(
//                           padding: EdgeInsets.all(8.0),
//                           child: Text(
//                             "Add Settlement",
//                             style: TextStyle(
//                                 fontSize: 20, fontWeight: FontWeight.bold),
//                           ),
//                         ),
//                         Center(
//                           child: IconButton(
//                             onPressed: () async {
//                               final selectedPayment =
//                                   await Navigator.push<CashPayment>(
//                                       context,
//                                       MaterialPageRoute(
//                                           builder: (context) => PaymentTable(
//                                               onRowSelected: (payment) =>
//                                                   payment,
//                                               payment: payment)));
//                               if (selectedPayment != null) {
//                                 setState(() {
//                                   _selectedPayment = selectedPayment;
//                                   _populatedForm(selectedPayment);
//                                 });
//                               }
//                             },
//                             icon: const Icon(Icons.arrow_drop_down),
//                             iconSize: 40,
//                           ),
//                         ),
//                         Row(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             Expanded(
//                                 child: Column(
//                               children: [
//                                 ListTile(
//                                   title: TextFormField(
//                                     controller: _paymentNoController,
//                                     decoration: const InputDecoration(
//                                         labelText: "Payment No"),
//                                     readOnly: true,
//                                   ),
//                                 ),
//                                 ListTile(
//                                   title: Row(
//                                     children: [
//                                       Expanded(
//                                         child: TextFormField(
//                                           controller:
//                                               _withdrawnAmountController,
//                                           decoration: const InputDecoration(
//                                               labelText: "Withdrawn Amount"),
//                                           keyboardType: TextInputType.number,
//                                           onChanged: (value) {
//                                             _updateRefundAmount();
//                                           },
//                                           readOnly: true,
//                                         ),
//                                       ),
//                                       const SizedBox(width: 10),
//                                       Center(
//                                         child: Text(
//                                           _currency.text,
//                                           style: const TextStyle(fontSize: 16),
//                                         ),
//                                       ),
//                                     ],
//                                   ),
//                                 ),
//                               ],
//                             )),
//                             Expanded(
//                                 child: Column(
//                               children: [
//                                 ListTile(
//                                   title: TextFormField(
//                                     controller: _requestNoController,
//                                     decoration: const InputDecoration(
//                                         labelText: "Request No"),
//                                     readOnly: true,
//                                   ),
//                                 ),
//                                 ListTile(
//                                   title: Row(
//                                     children: [
//                                       Expanded(
//                                         child: TextFormField(
//                                           controller: _settleAmountController,
//                                           decoration: const InputDecoration(
//                                               labelText: "Settled Amount"),
//                                           keyboardType: TextInputType.number,
//                                           onChanged: (value) {
//                                             _updateRefundAmount();
//                                           },
//                                           validator: (value) {
//                                             if (value == null ||
//                                                 value.isEmpty) {
//                                               return "Enter Total Amount";
//                                             }
//                                             final amount =
//                                                 double.tryParse(value);
//                                             if (amount == null) {
//                                               return "Enter a valid amount";
//                                             }
//                                             if (amount <= 0) {
//                                               return "Your Request Amount must be greater than 0";
//                                             }
//                                             double withdrawnAmount =
//                                                 double.tryParse(
//                                                         _withdrawnAmountController
//                                                             .text) ??
//                                                     0.0;
//                                             double settleAmount =
//                                                 double.tryParse(value) ?? 0.0;

//                                             if (settleAmount >
//                                                 withdrawnAmount) {
//                                               return "Settle amount cannot be \n greater than withdrawn amount";
//                                             }
//                                             return null;
//                                           },
//                                           readOnly: true,
//                                         ),
//                                       ),
//                                       const SizedBox(
//                                         width: 10,
//                                       ),
//                                       Text(
//                                         _currency.text, // Display the currency
//                                         style: const TextStyle(fontSize: 16),
//                                       ),
//                                     ],
//                                   ),
//                                 ),
//                               ],
//                             )),
//                             Expanded(
//                                 child: Column(
//                               children: [
//                                 ListTile(
//                                   title: TextFormField(
//                                     controller: _dateController,
//                                     decoration: const InputDecoration(
//                                         labelText: "Settlement Date"),
//                                     readOnly: true,
//                                   ),
//                                 ),
//                                 ListTile(
//                                   title: Row(
//                                     children: [
//                                       Expanded(
//                                         child: TextFormField(
//                                           controller: _refundAmountController,
//                                           decoration: const InputDecoration(
//                                               labelText: "Refund Amount"),
//                                           readOnly: true,
//                                         ),
//                                       ),
//                                       const SizedBox(width: 10),
//                                       Text(
//                                         _currency.text, // Display the currency
//                                         style: const TextStyle(fontSize: 16),
//                                       ),
//                                     ],
//                                   ),
//                                 ),
//                               ],
//                             ))
//                           ],
//                         ),
//                         const SizedBox(
//                           height: 40,
//                         ),
//                         if (_budgetDetails.isNotEmpty)
//                           Table(
//                             border: TableBorder.all(),
//                             children: [
//                               const TableRow(
//                                   decoration: BoxDecoration(),
//                                   children: [
//                                     Padding(
//                                       padding: EdgeInsets.all(8.0),
//                                       child: Text(
//                                         "Budget Code",
//                                         style: TextStyle(
//                                             fontWeight: FontWeight.bold),
//                                       ),
//                                     ),
//                                     Padding(
//                                       padding: EdgeInsets.all(8.0),
//                                       child: Text(
//                                         "Budget Name",
//                                         style: TextStyle(
//                                             fontWeight: FontWeight.bold),
//                                       ),
//                                     ),
//                                     Padding(
//                                       padding: EdgeInsets.all(8.0),
//                                       child: Text(
//                                         "Budget Amount",
//                                         style: TextStyle(
//                                             fontWeight: FontWeight.bold),
//                                       ),
//                                     ),
//                                   ]),
//                               ..._budgetDetails.map((budget) {
//                                 return TableRow(children: [
//                                   Padding(
//                                     padding: const EdgeInsets.all(8.0),
//                                     child: Text(budget.BudgetCode),
//                                   ),
//                                   Padding(
//                                     padding: const EdgeInsets.all(8.0),
//                                     child: Text(budget.Description),
//                                   ),
//                                   Padding(
//                                     padding: const EdgeInsets.all(8.0),
//                                     child: TextFormField(
//                                       controller: _budgetAmountControllers[
//                                           budget.BudgetCode],
//                                       keyboardType: TextInputType.number,
//                                       onChanged: (value) {
//                                         _calculateSettleAmount();
//                                       },
//                                       decoration: const InputDecoration(
//                                           border: OutlineInputBorder(),
//                                           hintText: "Enter Amount"),
//                                     ),
//                                   ),
//                                 ]);
//                               })
//                             ],
//                           ),
//                         const SizedBox(
//                           height: 40,
//                         ),
//                         Row(
//                           mainAxisAlignment: MainAxisAlignment.center,
//                           children: [
//                             ElevatedButton(
//                               onPressed: _submitForm,
//                               style: ElevatedButton.styleFrom(
//                                 textStyle: const TextStyle(
//                                   fontSize: 15,
//                                 ),
//                                 backgroundColor: Colors.white,
//                                 foregroundColor: Colors.black,
//                                 padding: const EdgeInsets.symmetric(
//                                     horizontal: 20, vertical: 12),
//                                 shape: RoundedRectangleBorder(
//                                   borderRadius: BorderRadius.circular(8),
//                                 ),
//                               ),
//                               child: const Text("Submit"),
//                             ),
//                             const SizedBox(
//                               width: 20,
//                             ),
//                             ElevatedButton(
//                               onPressed: () {
//                                 _clearText();
//                               },
//                               style: ElevatedButton.styleFrom(
//                                 textStyle: const TextStyle(
//                                   fontSize: 15,
//                                 ),
//                                 backgroundColor: Colors.white,
//                                 foregroundColor: Colors.black,
//                                 padding: const EdgeInsets.symmetric(
//                                     horizontal: 20, vertical: 12),
//                                 shape: RoundedRectangleBorder(
//                                   borderRadius: BorderRadius.circular(8),
//                                 ),
//                               ),
//                               child: const Text("Clear"),
//                             ),
//                           ],
//                         ),
//                         const SizedBox(
//                           height: 40,
//                         )
//                       ],
//                     )),
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }

// class PaymentTable extends StatelessWidget {
//   final Function(CashPayment) onRowSelected;
//   final List<CashPayment> payment;
//   const PaymentTable(
//       {Key? key, required this.onRowSelected, required this.payment})
//       : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     final filterPayment = payment
//         .where(
//             (payment) => payment.status == 0 && payment.settledStatus == 0)
//         .toList();

//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: const Color.fromRGBO(100, 207, 198, 0.855),
//         title: const Text("Choose Cash Payment"),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(30.0),
//         child: Center(
//           child: Column(
//             children: [
//               const Text(
//                 "Choose Cash Payment",
//                 style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
//               ),
//               const SizedBox(
//                 height: 8,
//               ),
//               Expanded(
//                   child: SingleChildScrollView(
//                 scrollDirection: Axis.vertical,
//                 child: Container(
//                   height: MediaQuery.of(context).size.height * 0.4,
//                   child: DataTable(
//                       border: TableBorder.all(),
//                       showCheckboxColumn: false,
//                       headingRowColor: MaterialStateProperty.resolveWith(
//                         (Set<MaterialState> states) {
//                           return const Color.fromARGB(255, 167, 230, 232);
//                         },
//                       ),
//                       columns: const [
//                         DataColumn(
//                             label: Text(
//                           "Payment No",
//                           style: TextStyle(fontWeight: FontWeight.bold),
//                         )),
//                         DataColumn(
//                             label: Text(
//                           "Request Type",
//                           style: TextStyle(fontWeight: FontWeight.bold),
//                         )),
//                         DataColumn(
//                             label: Text(
//                           "Payment Amount",
//                           style: TextStyle(fontWeight: FontWeight.bold),
//                         )),
//                         DataColumn(
//                             label: Text(
//                           "Currency",
//                           style: TextStyle(fontWeight: FontWeight.bold),
//                         )),
//                         DataColumn(
//                             label: Text(
//                           "Payment Method",
//                           style: TextStyle(fontWeight: FontWeight.bold),
//                         )),
//                         DataColumn(
//                             label: Text(
//                           "Payment Note",
//                           style: TextStyle(fontWeight: FontWeight.bold),
//                         )),
//                         DataColumn(
//                             label: Text(
//                           "Status",
//                           style: TextStyle(fontWeight: FontWeight.bold),
//                         )),
//                       ],
//                       rows: filterPayment.map((payment) {
//                         return DataRow(
//                             cells: [
//                               DataCell(Text(payment.paymentNo)),
//                               DataCell(Text(payment.requestType)),
//                               DataCell(Text(payment.paymentAmount.toString())),
//                               DataCell(Text(payment.currency)),
//                               DataCell(Text(payment.paymentMethod)),
//                               DataCell(Text(payment.paymentNote)),
//                               DataCell(Text(payment.settledStatus == 0
//                                   ? "Not Settled"
//                                   : "Settled")),
//                             ],
//                             onSelectChanged: (selected) async {
//                               if (selected != null) {
//                                 final updatePayment = await Navigator.of(
//                                         context)
//                                     .push(MaterialPageRoute(
//                                         builder: (context) => SettlementEntry(
//                                               selectedPayment: payment,
//                                               onPaymentSettled: onRowSelected,
//                                               payment: [],
//                                             )));
//                                 if (updatePayment != null) {
//                                   onRowSelected(updatePayment);
//                                   // onRowSelected(payment);
//                                 }
//                               }
//                             });
//                       }).toList()),
//                 ),
//               )),
//               Padding(
//                 padding: const EdgeInsets.all(8.0),
//                 child: ElevatedButton(
//                     onPressed: () {
//                       //Navigator.push(context, MaterialPageRoute(builder: (context)=>const Settlement()));
//                       Navigator.pop(context);
//                     },
//                     style: ElevatedButton.styleFrom(
//                       textStyle: const TextStyle(
//                         fontSize: 18,
//                       ),
//                       backgroundColor: const Color.fromARGB(255, 76, 178, 182),
//                       foregroundColor: Colors.black,
//                       padding: const EdgeInsets.symmetric(
//                           horizontal: 20, vertical: 12),
//                       shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(8),
//                       ),
//                     ),
//                     child: const Text(
//                       "Back",
//                       style:
//                           TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//                     )),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
