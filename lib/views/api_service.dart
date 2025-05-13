import 'dart:convert';
import 'package:advance_budget_request_system/views/data.dart';
import 'package:http/http.dart' as http;

class ApiService {
  static String url = "https://approvalbackend-e4d9gwawejg9d3bg.eastasia-01.azurewebsites.net/api/budget/";

  static String projectEndPoint = "https://approvalbackend-e4d9gwawejg9d3bg.eastasia-01.azurewebsites.net/api/project/";
  final String projectBudgetEndPoint =
      "https://approvalbackend-e4d9gwawejg9d3bg.eastasia-01.azurewebsites.net/api/projectbudget/";
  final String tripEndPoint = "https://approvalbackend-e4d9gwawejg9d3bg.eastasia-01.azurewebsites.net/api/trip/";
  final String tripBudgetEndPoint = "https://approvalbackend-e4d9gwawejg9d3bg.eastasia-01.azurewebsites.net/api/tripbudget/";
  final String TripCodeAutoIncrementEndPoint =
      "https://approvalbackend-e4d9gwawejg9d3bg.eastasia-01.azurewebsites.net/api/next-code/";
  final String operationEndPoint = "https://approvalbackend-e4d9gwawejg9d3bg.eastasia-01.azurewebsites.net/api//";
  final String operationBudgetEndPoint =
      "https://approvalbackend-e4d9gwawejg9d3bg.eastasia-01.azurewebsites.net/api/operationbudget/";
  final String operationCodeAutoIncrementEndPoint =
      "https://approvalbackend-e4d9gwawejg9d3bg.eastasia-01.azurewebsites.net/api/next-code/";
  final String advanceRequestEndPoint =
      "https://approvalbackend-e4d9gwawejg9d3bg.eastasia-01.azurewebsites.net/api/advancerequest/";
  final String advanceCodeAutoIncrementEndPoint =
      "https://approvalbackend-e4d9gwawejg9d3bg.eastasia-01.azurewebsites.net/api/requests/next-code/";
  final String cashPaymentEndPoint = "https://approvalbackend-e4d9gwawejg9d3bg.eastasia-01.azurewebsites.net/api/cashpayment/";
  final String cashPaymentAutoIncrementEndPoint= "https://approvalbackend-e4d9gwawejg9d3bg.eastasia-01.azurewebsites.net/api/requests/next-code/";
  final String settlementEndPoint = "https://approvalbackend-e4d9gwawejg9d3bg.eastasia-01.azurewebsites.net/api/settlement/";
  final String settlementDetailEndPoint =
      "https://approvalbackend-e4d9gwawejg9d3bg.eastasia-01.azurewebsites.net/api/settlementdetail/";
  final String userLoginEndPoint = "https://approvalbackend-e4d9gwawejg9d3bg.eastasia-01.azurewebsites.net/api/user/";
  final String departmentEndPoint = "https://approvalbackend-e4d9gwawejg9d3bg.eastasia-01.azurewebsites.net/api/department/";
  static String approvalsetupEndPoint =
      "https://approvalbackend-e4d9gwawejg9d3bg.eastasia-01.azurewebsites.net/api/requestsetup/";
  static String approvalstepEndPoint =
      "https://approvalbackend-e4d9gwawejg9d3bg.eastasia-01.azurewebsites.net/api/approversetupstep/";

  Future<List<Budget>> fetchBudgetCodeData() async {
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      List<dynamic> body = jsonDecode(response.body);
      return body.map((dynamic item) => Budget.fromJson(item)).toList();
    } else {
      throw Exception('Failed to load data');
    }
  }

  Future<bool> postBudgetCode(Budget newbudgetCode) async {
    //  print("API Call: ${jsonEncode(newbudgetCode .toJson())}");
    final response = await http.post(Uri.parse(url),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(newbudgetCode.toJson()));
    //print("Response Status Code: ${response.statusCode}");
    // print("Response Body: ${response.body}");
    if (response.statusCode != 201) {
      throw Exception('Failed to insert budget code');
    } else {
      return true;
    }
  }

  Future<bool> updateBudget(Budget budget) async {
    final response = await http.put(
      Uri.parse('$url${budget.id}/'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8'
      },
      body: json.encode(budget.toJson()),
    );

    // Debug: Check the full URL
    // print("Final API URL: ${'$baseUrl$budgetCodeEndpoint/${budget.id}'}");
    // print("Response Status Code: ${response.statusCode}");
    // print("Response Body: ${response.body}");
    if (response.statusCode != 200) {
      throw Exception('Failed to update budget');
    } else {
      return true;
    }
  }

  Future<void> deleteBudget(int id) async {
    final response = await http.delete(Uri.parse('$url$id'));
    if (response.statusCode != 204) {
      throw Exception('Failed to delete BudgetCode');
    }
  }

  //project
  Future<List<Projects>> fetchProjectInfoData() async {
    final response = await http.get(Uri.parse(projectEndPoint));
    if (response.statusCode == 200) {
      List<dynamic> body = json.decode(response.body);
      print("Project Data: $body");
      return body.map((dynamic item) => Projects.fromJson(item)).toList();
    } else {
      throw Exception('Failed to load projects');
    }
  }

  Future<void> postProjectInfo(Projects newProject) async {
    final response = await http.post(Uri.parse(projectEndPoint),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(newProject.toJson()));

    if (response.statusCode != 201) {
      throw Exception('Failed to insert project');
    }
  }

  Future<void> postProjectBudget(int projectId, int budgetId) async {
    try {
      final response = await http.post(
        Uri.parse(projectBudgetEndPoint),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'Project_ID': projectId, 'Budget_ID': budgetId}),
      );

      if (response.statusCode == 201) {
        return;
      } else if (response.statusCode == 400) {
        final error = jsonDecode(response.body);
        if (error['non_field_errors'] != null &&
            error['non_field_errors'].contains('unique set')) {
          // Relationship already exists - treat as success
          return;
        }
        throw Exception('Validation error: ${response.body}');
      } else {
        throw Exception('Failed to create projectbudget: ${response.body}');
      }
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }

  Future<void> updateProjectInfo(Projects updatedProject) async {
    final jsonData = updatedProject.toJson();
    print("Sending updated JSON data: $jsonData");

    final response = await http.put(
      Uri.parse('$projectEndPoint${updatedProject.id}/'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(jsonData), // Send the JSON data
    );

    print("API Response Status: ${response.statusCode}");
    print("API Response Body: ${response.body}");

    if (response.statusCode != 200) {
      throw Exception('Failed to update project: ${response.body}');
    }
  }

  Future<http.Response> updateProjectBudget(Projects project, int id) async {
    final response = await http.post(
      Uri.parse('$projectEndPoint$id/'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(project.toJson()),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to update project');
    }
    return response;
  }

  Future<void> deleteProject(int id) async {
    final response = await http.delete(Uri.parse('$projectEndPoint$id/'));
    print(response.statusCode);
    print("responsebody${response.body}");
    if (response.statusCode != 200  && response.statusCode != 204) {
      throw Exception('Failed to delete ProjectCode');
    }
  }

// trip
  Future<List<Trip>> fetchTripinfoData() async {
    final response = await http.get(Uri.parse(tripEndPoint));
    if (response.statusCode == 200) {
      List<dynamic> body = json.decode(response.body);
      print("Status Code: $response.statusCode");
      print("Trip Data:$body");
      return body.map((dynamic item) => Trip.fromJson(item)).toList();
    } else {
      throw Exception('Failed to load Trips');
    }
  }

  Future<String> fetchNextTripCode() async {
    final response = await http.get(Uri.parse(TripCodeAutoIncrementEndPoint));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['next_trip_code'] as String;
    } else {
      throw Exception('Failed to fetch trip code');
    }
  }

  Future<void> postTripInfo(Trip newTrip) async {
    final jsonData = newTrip.toJson();
    print("Sending JSON data: $jsonData");
    final response = await http.post(Uri.parse(tripEndPoint),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(jsonData));
    print("API Response Status: ${response.statusCode}");
    print("API Response Body: ${response.body}");
    if (response.statusCode != 201) {
      throw Exception('Failed to insert trip');
    }
  }

  Future<void> postTripBudget(int tripId, int budgetId) async {
    final response = await http.post(
      Uri.parse(tripBudgetEndPoint),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'Trip_ID': tripId, 'Budget_ID': budgetId}),
    );

    if (response.statusCode == 201) {
      return;
    } else if (response.statusCode == 400) {
      final error = jsonDecode(response.body);
      if (error['non_field_errors'] != null &&
          error['non_field_errors'].contains('unique set')) {
        return;
      }
      throw Exception('Validation error: ${response.body}');
    } else {
      throw Exception('Failed to create tripbudget: ${response.body}');
    }
  }

  // Update a trip
  Future<void> updateTripInfo(Trip updatedTrip) async {
    final jsonData = updatedTrip.toJson(); // Convert Trip object to JSON
    print("Sending updated JSON data: $jsonData"); // Debug: Print the JSON data

    final response = await http.put(
      Uri.parse('$tripEndPoint${updatedTrip.id}/'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(jsonData), // Send the JSON data
    );

    print("API Response Status: ${response.statusCode}");
    print("API Response Body: ${response.body}");

    if (response.statusCode != 200) {
      throw Exception('Failed to update trip: ${response.body}');
    }
  }

  //delete trip
  Future<void> deleteTrip(String tripID) async {
    // Ensure there is no space between baseUrl and tripEndPoint
    final response =
        await http.delete(Uri.parse('$tripEndPoint$tripID/'));

    // Check if the request was successful
    if (response.statusCode != 200 && response.statusCode != 204) {
      throw Exception(
          'Failed to delete trip. Status code: ${response.statusCode}');
    }
  }

  //operation
  Future<List<Operation>> fetchOperationData() async {
    final response = await http.get(Uri.parse(operationEndPoint));
    if (response.statusCode == 200) {
      List<dynamic> body = json.decode(response.body);
      print("Operation Data: $body");
      return body.map((dynamic item) => Operation.fromJson(item)).toList();
    } else {
      throw Exception('Failed to load operation');
    }
  }

  Future<void> postOperation(Operation newOperation) async {
    final response =
        await http.post(Uri.parse(operationCodeAutoIncrementEndPoint),
            headers: <String, String>{
              'Content-Type': 'application/json; charset=UTF-8',
            },
            body: jsonEncode(newOperation.toJson()));
    print(response.statusCode);
    print(response.body);
    if (response.statusCode != 201) {
      throw Exception('Failed to insert operation');
    }
  }

  Future<String> fetchNextOperationCode() async {
    final response = await http.get(Uri.parse(operationBudgetEndPoint));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['next_operation_code'] as String;
    } else {
      throw Exception('Failed to fetch operation code');
    }
  }

// advance request
  Future<List<AdvanceRequest>> fetchAdvanceRequestData() async {
    final response =
        await http.get(Uri.parse(advanceRequestEndPoint));
    if (response.statusCode == 200) {
      List<dynamic> body = json.decode(response.body);
      return body.map((dynamic item) => AdvanceRequest.fromJson(item)).toList();
    } else {
      throw Exception('Failed to load Advance Requests');
    }
  }

  Future<void> postAdvanceRequest(AdvanceRequest newAdvance) async {
    print("Posting advance request: ${newAdvance.toJson()}");
    final response =
        await http.post(Uri.parse(advanceRequestEndPoint),
            headers: <String, String>{
              'Content-Type': 'application/json; charset=UTF-8',
            },
            body: jsonEncode(newAdvance.toJson()));
    print(response.statusCode);
    print(response.body);
    if (response.statusCode != 201) {
      throw Exception('Failed to insert Advance Request ${response.statusCode} + ${response.body}');
      
      // print('Request can create successfully!');
    }
  }

  Future<String> fetchNextAdvanceCode() async {
    final response =
        await http.get(Uri.parse(advanceCodeAutoIncrementEndPoint));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['next_request_code'] as String;
    } else {
      throw Exception('Failed to fetch advance code');
    }
  }


  // Cash Payment
  Future<List<CashPayment>> fetchCashPaymentData() async {
    final response = await http.get(Uri.parse(cashPaymentEndPoint));
    if (response.statusCode == 200) {
      List<dynamic> body = json.decode(response.body);
      print(response.body);
      return body.map((dynamic item) => CashPayment.fromJson(item)).toList();
    } else {
      throw Exception('Failed to load Cash Payment');
    }
  }

  Future<String> fetchNextPaymentCode() async {
    final response = await http.get(Uri.parse(cashPaymentAutoIncrementEndPoint));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['next_payment_code'] as String;
    } else {
      throw Exception('Failed to fetch payment code');
    }
  }

  Future<void> postCashPayment(CashPayment newPayment) async {
    final response = await http.post(Uri.parse(cashPaymentEndPoint),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(newPayment.toJson()));
    print(response.statusCode);
    print(response.body);
    if (response.statusCode != 201) {
      throw Exception('Failed to insert Cash Payment');
      // print('Request can create successfully!');
    }
  }

  Future<bool> updateCashPayment(CashPayment cashpayment) async {
    final response = await http.put(
      Uri.parse('$cashPaymentEndPoint${cashpayment.id}/'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8'
      },
      body: json.encode(cashpayment.toJson()),
    );

    if (response.statusCode != 200) {
      throw Exception(
          'Failed to update cashpayment ${response.statusCode} + ${response.body}');
    } else {
      return true;
    }
  }

  //Settlement
  Future<List<SettlementInfo>> fetchSettlementData() async {
    final response = await http.get(Uri.parse(settlementEndPoint));
    if (response.statusCode == 200) {
      List<dynamic> body = json.decode(response.body);
      return body.map((dynamic item) => SettlementInfo.fromJson(item)).toList();
    } else {
      throw Exception(
          'Failed to load Settlement ${response.statusCode}  ${response.body}');
    }
  }

  Future<void> postSettlement(SettlementInfo newSettlement) async {
    final response = await http.post(Uri.parse(settlementEndPoint),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(newSettlement.toJson()));
    print(response.statusCode);
    print(response.body);
    if (response.statusCode != 201) {
      throw Exception(
          'Failed to insert Settlement ${response.statusCode}  ${response.body}');
      // print('Request can create successfully!');
    }
  }

  //settlement detail
  Future<List<SettlementDetail>> fetchSettlementDetailData() async {
    final response = await http.get(Uri.parse(settlementDetailEndPoint));
    if (response.statusCode == 200) {
      List<dynamic> body = json.decode(response.body);
      return body
          .map((dynamic item) => SettlementDetail.fromJson(item))
          .toList();
    } else {
      throw Exception(
          'Failed to load Settlement Detail ${response.statusCode}  ${response.body}');
    }
  }

  Future<void> postSettlementDetail(SettlementDetail newSettlement) async {
    final response = await http.post(Uri.parse(settlementDetailEndPoint),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(newSettlement.toJson()));
    print(response.statusCode);
    print(response.body);
    if (response.statusCode != 201) {
      throw Exception(
          'Failed to insert Settlement Detail ${response.statusCode}  ${response.body}');
      // print('Request can create successfully!');
    }
  }

  //User
  Future<List<User>> fetchUser() async {
    final response = await http.get(Uri.parse(userLoginEndPoint));
    if (response.statusCode == 200) {
      List<dynamic> body = json.decode(response.body);
      print(response.body);
      return body.map((dynamic item) => User.fromJson(item)).toList();
    } else {
      throw Exception('Failed to load User');
    }
  }

  Future<void> postUser(User newuser) async {
    final response = await http.post(Uri.parse(userLoginEndPoint),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(newuser.toJson()));
    if (response.statusCode != 201) {
      throw Exception("Fail to add UserLogin");
    }
  }

  Future<void> registerUser(Map<String, dynamic> userData) async {
    final response = await http.post(
      Uri.parse('http://127.0.0.1:8000/api/user/'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'UserName': userData['username'],
        'User_Email': userData['email'],
        'Password': userData['password'],
        'Role': userData['role'],
        'Department_ID': userData['departmentId'],
      }),
    );

    if (response.statusCode == 201) {
      final data = jsonDecode(response.body);
      print('Registration success: ${data['message']}');
    } else {
      final error = jsonDecode(response.body);
      print('Registration failed: ${error['message']}');
    }
  }

  Future<Map<String, dynamic>?> loginUser(
      String email, String password, String departmentId) async {
    final response = await http.post(
      Uri.parse('http://127.0.0.1:8000/api/login/'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'User_Email': email,
        'Password': password,
        'Department_ID': departmentId,
      }),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['data'];
    } else {
      final error = jsonDecode(response.body);
      print('Login failed: ${error['message']}');
      return null;
    }
  }

  //Department
  Future<List<Department>> fetchDepartment() async {
    final response = await http.get(Uri.parse(departmentEndPoint));
    if (response.statusCode == 200) {
      List<dynamic> body = json.decode(response.body);
      print(response.body);
      return body.map((dynamic item) => Department.fromJson(item)).toList();
    } else {
      throw Exception('Failed to load Department');
    }
  }

  //fetch approval steps from the server
  Future<List<ApprovalStep>> fetchApprovalSteps() async {
    final response = await http.get(Uri.parse(approvalstepEndPoint));

    if (response.statusCode == 200) {
      List<dynamic> body = json.decode(response.body);
      return body.map((json) => ApprovalStep.fromJson(json)).toList();
    } else {
      throw Exception(
          'Failed to load approval steps ${response.statusCode} + ${response.body}');
    }
  }

  //Insert new approval step
  static Future<void> postApprovalStep(ApprovalStep step) async {
    final response = await http.post(Uri.parse(approvalstepEndPoint),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(step.toJson()));
    print(" Step statuscode : ${response.statusCode} + ${response.body}");
    if (response.statusCode != 201) {
      throw Exception(
          'Failed to insert approval step ${response.statusCode} + ${response.body}');
    }
  }

  //Update an existing approval step
  static Future<void> updateApprovalStep(ApprovalStep step) async {
    final response = await http.put(
        Uri.parse('$approvalstepEndPoint/${step.id}/'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(step.toJson()));
    print(" Stepupdate statuscode : ${response.statusCode} + ${response.body}");
    if (response.statusCode != 200) {
      throw Exception('Failed to update approval step');
    }
  }

  Future<void> deleteApprovalStep(int id) async {
    final response = await http.delete(Uri.parse('$approvalstepEndPoint$id/'));
    print(response.statusCode);
    print("responsebody${response.body}");
    if (response.statusCode != 200) {
      throw Exception(
          'Failed to delete approval step ${response.statusCode} + ${response.body}');
    }
  }

  //fetch approvalsetup from server
  Future<List<ApprovalSetup>> fetchApprovalSetup() async {
    final response = await http.get(Uri.parse(approvalsetupEndPoint));
    if (response.statusCode == 200) {
      List<dynamic> body = jsonDecode(response.body);
      return body.map((json) => ApprovalSetup.fromJson(json)).toList();
    } else {
      throw Exception(
          'Failed to load ApprovalSetup ${response.statusCode} + ${response.body}');
    }
  }


  static Future<ApprovalSetup> postApprovalSetup(ApprovalSetup newSetup) async {
    final response = await http.post(
      Uri.parse(approvalsetupEndPoint),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(newSetup.toJson()),
    );

    if (response.statusCode == 201) {
      return ApprovalSetup.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to create setup: ${response.body}');
    }
  }

  static Future<void> updateApprovalSetup(ApprovalSetup updatesetup) async {
    final response = await http.put(
        Uri.parse('$approvalsetupEndPoint${updatesetup.id}/'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(updatesetup.toJson()));
    if (response.statusCode != 200) {
      throw Exception(
          "Failed to update Approval Setup ${response.statusCode} + ${response.body}");
    }
  }

  Future<void> deleteApprovalSetup(int id) async {
    final response = await http.delete(Uri.parse('$approvalsetupEndPoint$id/'));
    print(response.statusCode);
    print("responsebody${response.body}");
    if (response.statusCode != 200 && response.statusCode != 204) {
      throw Exception(
          'Failed to delete approval setup ${response.statusCode}  ${response.body}');
    }
  }
}
