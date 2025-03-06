import 'package:intl/intl.dart';

class Budget {
  final String id;
  final String BudgetCode;
  final String Description;
  final int InitialAmount;

  Budget(
      {required this.id, required this.BudgetCode, required this.Description,required this.InitialAmount});

  factory Budget.fromJson(Map<String, dynamic> json) {
    return Budget(
      id: json['id']??'',
      BudgetCode: json['BudgetCode']??'',
      Description: json['Description']??'',
    InitialAmount: json['InitialAmount']?? 0
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'BudgetCode': BudgetCode,
      'Description': Description,
      'InitialAmount': InitialAmount
    };
  }
}
class BudgetAmount {
  final String? id;
  final String? BudgetCode;
  final String? Description;
  final int? InitialAmount;

  BudgetAmount(
      {required this.id,
      required this.BudgetCode,
      required this.Description,
      required this.InitialAmount});

  factory BudgetAmount.fromJson(Map<String, dynamic> json) {
    return BudgetAmount(
        id: json['id'],
        BudgetCode: json['BudgetCode'],
        Description: json['Description'],
        InitialAmount: json['InitialAmount']);
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'BudgetCode': BudgetCode,
      'Description': Description,
      'InitialAmount': InitialAmount
    };
  }
}
//for project

class ProjectInfo {
  final DateTime date;
  final String projectID;
  final String description;
  final String totalAmount;
  final String currency;
  final String approveAmount;
  final String department;
  final String requestable;
  // final List<Map<String, String>> budgetDetail;

  ProjectInfo({required this.date,required this.projectID,required this.description, required this.totalAmount,required this.currency,required this.approveAmount,required this.department,
    required this.requestable });

  factory ProjectInfo.fromJson(Map<String, dynamic> json) {
    return ProjectInfo(
      date: json['Date'] != null ? DateFormat('yyyy-MM-dd').parse(json['Date']) : DateTime.now(),
      projectID: json['ProjectID']??'j',
      description: json['Description']??'des',
      totalAmount: json['Total Budget Amount']?? '8000',
      currency: json['Currency']?? 'MMK',
      approveAmount: json['Approved Amount']?? '8000',
      department: json['Department']?? 'Admin',
      requestable: json['Requestable']??'Yes',
      // budgetDetail:List<Map<String, String>>.from(
      //   json['BudgetDetails'].map((detail) => {
      //     'Budget Code': detail['Budget Code'],
      //     'Description': detail['Description'],
      //   }),
      // ),
    );
  }

   Map<String, dynamic> toJson() {
    return {
      'Date': date,
      'ProjectID': projectID,
      'Description': description,
      'Total Budget Amount': totalAmount,
      'Currency': currency,
      'Approved Amount': approveAmount,
      'Department': department,
      'Requestable': requestable,
      // 'BudgetDetails': budgetDetail,

    };
  }

}

//for trip
class TripInfo {
  final DateTime date;
  final String tripID;
  final String description;
  final String totalAmount;
  final String currency;
  final String department;
    // final List<String> budgetDetail;
  

  TripInfo({required this.date,required this.tripID,required this.description, required this.totalAmount,required this.currency,required this.department
   });

  factory TripInfo.fromJson(Map<String, dynamic> json) {
    return TripInfo(
      date: DateFormat('yyyy-MM-dd').parse(json['Date']),
      tripID: json['tripID'],
      description: json['description'],
      totalAmount: json['Total Amount'],
      currency: json['currency'],
      department: json['department'],
      // budgetDetail: List<String>.from(json['BudgetDetails'])
    );
  }

   Map<String, dynamic> toJson() {
    return {
      'Date': date,
      'tripID': tripID,
      'description': description,
      'Total Amount': totalAmount,
      'currency': currency,
      'department': department,
      // 'BudgetDetails': budgetDetail,

    };
  }
}

//for Advance Request
class AdvanceRequest {
  final DateTime date;
  final String requestNo;
  final String requestCode;
  final String requestType;
  final double requestAmount;
  final String currency;
  final String requester;
  final String department;
  final double approveAmount;
  final String purpose;
  final String status; 


  AdvanceRequest({required this.date,required this.requestNo,required this.requestCode, required this.requestType,required this.requestAmount,required this.currency,
   required this.requester, required this.department, required this.approveAmount, required this.purpose,required this.status });

  factory AdvanceRequest.fromJson(Map<String, dynamic> json) {
    return AdvanceRequest(
      date:DateFormat('yyyy-MM-dd').parse(json['Date']),
      requestNo: json['RequestNo'],
      requestCode: json['RequestCode'],
      requestType: json['RequestType'],
      requestAmount: json['RequestAmount'].toDouble(),
      currency: json['Currency'],
      requester: json['Requester'],
      department: json['Department'],
      approveAmount: json['ApprovedAmount'].toDouble(),
      purpose: json['Purpose'],
      status: json['Status']
    );
  }


Map<String, dynamic> toJson() {
    return {
      'Date':  DateFormat('yyyy-MM-dd').format(date),
      'RequestNo': requestNo,
      'RequestCode': requestCode,
      'RequestType': requestType,
      'RequestAmount': requestAmount,
      'Currency': currency,
      'Requester': requester,
      'Department': department,
      'ApprovedAmount': approveAmount,
      'Purpose':purpose,
      'Status':status

    };
  }
}

//for Cash Payment
class CashPayment {
  final DateTime date;
  final String paymentNo;
  final String requestType; 
  final String paymentAmount;
  final String currency;
  final String paymentMethod;
  final String paidPerson;
  final String receivePerson;
  final double paymentNote;
  final String status;

  CashPayment({required this.date,required this.paymentNo,required this.requestType, required this.paymentAmount,required this.currency, required this.paymentMethod,
   required this.paidPerson, required this.receivePerson, required this.paymentNote, required this.status});

  factory CashPayment.fromJson(Map<String, dynamic> json) {
    return CashPayment(
      date:DateFormat('yyyy-MM-dd').parse(json['PaymentDate']),
      paymentNo: json['PaymentNo'],
      requestType: json['RequestType'],
      paymentAmount: json['PaymentAmount'].toDouble(),
      currency: json['Currency'],
      paymentMethod: json['PaymentMethod'],
      paidPerson: json['PaidPerson'],
      receivePerson: json['ReceivePerson'],
      paymentNote: json['PaymentNote'],
      status: json['Status']
    );
  }

   Map<String, dynamic> toJson() {
    return {
      'PaymentDate':  DateFormat('yyyy-MM-dd').format(date),
      "PaymentNo": paymentNo,
      "RequestType": requestType,
      "PaymentAmount": paymentAmount,
      "Currency": currency,
      "PaymentMethod": paymentMethod,
      "PaidPerson": paidPerson,
      "ReceivePerson": receivePerson,
      "PaymentNote": paymentNote,
      "Status": status

    };
  }
}
