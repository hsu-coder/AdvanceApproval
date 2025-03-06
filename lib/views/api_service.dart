import 'dart:convert';
import 'package:advance_budget_request_system/views/data.dart';
import 'package:http/http.dart' as http;

class ApiService {
  final String baseUrl = "http://localhost:3000";
  final String budgetCodeEndpoint = "/budgetcode";
  final String budgetAmountEndpoint = "/budgetamount";
  final String projectEndPoint = "/projectinfo";
  final String tripEndPoint = "/tripinfo";
  final String advanceRequestEndPoint = "/advancerequest";
  final String cashPaymentEndPoint="/cashpayment";

  Future<List<Budget>> fetchBudgetCodeData() async {
    final response = await http.get(Uri.parse(baseUrl + budgetCodeEndpoint));
   if (response.statusCode == 200) {
      List<dynamic> body = json.decode(response.body);
      print("Budget Data: $body");
      return body.map((dynamic item) => Budget.fromJson(item)).toList();
    } else {
      throw Exception('Failed to load projects');
    }
  }

  Future<void> postBudgetCode(Budget newbudgetCode) async {
    final response = await http.post(Uri.parse(baseUrl + budgetCodeEndpoint),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(newbudgetCode));
    if (response.statusCode != 201) {
      throw Exception('Failed to insert budget code');
    }
  }

//project
  Future<List<ProjectInfo>> fetchProjectInfoData() async {
    final response = await http.get(Uri.parse(baseUrl + projectEndPoint));
    if (response.statusCode == 200) {
      List<dynamic> body = json.decode(response.body);
      print("Project Data: $body");
      return body.map((dynamic item) => ProjectInfo.fromJson(item)).toList();
    } else {
      throw Exception('Failed to load projects');
    }
  }

  Future<void> postProjectInfo(ProjectInfo newProject) async {
    final response = await http.post(Uri.parse(baseUrl + projectEndPoint),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(newProject.toJson()));
    if (response.statusCode == 201) {
      throw Exception('Failed to insert project');
    }
  }

// trip
  Future<List<TripInfo>> fetchTripinfoData() async {
    final response = await http.get(Uri.parse(baseUrl + tripEndPoint));
     print("Raw Project API Response: ${response.body}");
    if (response.statusCode == 200) {
      List<dynamic> body = json.decode(response.body);
      return body.map((dynamic item) => TripInfo.fromJson(item)).toList();
    } else {
      throw Exception('Failed to load trips');
    }
  }

  Future<void> postTripInfo(TripInfo newTrip) async {
    final response = await http.post(Uri.parse(baseUrl + tripEndPoint),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(newTrip));
    if (response.statusCode == 201) {
      throw Exception('Failed to insert trip');
    }
  }

// advance request
  Future<List<AdvanceRequest>> fetchAdvanceRequestData() async {
    final response =
        await http.get(Uri.parse(baseUrl + advanceRequestEndPoint));
    if (response.statusCode == 200) {
      List<dynamic> body = json.decode(response.body);
      return body.map((dynamic item) => AdvanceRequest.fromJson(item)).toList();
    } else {
      throw Exception('Failed to load Advance Requests');
    }
  }

  Future<void> postAdvanceRequest(AdvanceRequest newAdvance) async {
    final response =
        await http.post(Uri.parse(baseUrl + advanceRequestEndPoint),
            headers: <String, String>{
              'Content-Type': 'application/json; charset=UTF-8',
            },
            body: jsonEncode(newAdvance.toJson()));
            print(response.statusCode);
            print(response.body);
    if (response.statusCode != 201) {
      throw Exception('Failed to insert Advance Request');
      // print('Request can create successfully!');
    } 
  }

  // Cash Payment
  Future<List<CashPayment>> fetchCashPaymentData() async {
    final response =
        await http.get(Uri.parse(baseUrl + cashPaymentEndPoint));
    if (response.statusCode == 200) {
      List<dynamic> body = json.decode(response.body);
      return body.map((dynamic item) => CashPayment.fromJson(item)).toList();
    } else {
      throw Exception('Failed to load Cash Payment');
    }
  }

  Future<void> postCashPayment(CashPayment newPayment) async {
    final response =
        await http.post(Uri.parse(baseUrl + cashPaymentEndPoint),
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
}
