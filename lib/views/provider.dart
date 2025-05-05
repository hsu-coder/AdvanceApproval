import 'package:advance_budget_request_system/views/api_service.dart';
//import 'package:advance_budget_request_system/views/approvalsetup.dart';
import 'package:advance_budget_request_system/views/data.dart';
import 'package:flutter/material.dart';

class ApprovalStepProvider with ChangeNotifier{
  List<ApprovalStep> _approvalSteps=[];

   List<ApprovalStep> get approvalSteps => _approvalSteps;

   Future<void> fetchApprovalSteps()async{
    try{
      final apiService = ApiService();
      _approvalSteps = await apiService.fetchApprovalSteps();
      notifyListeners();
    }catch(e){
      print('Error fetching approval step:$e');
    }
  }

Future<void> addApprovalStep(ApprovalStep step)async{
  try{
    await ApiService.postApprovalStep(step);
    _approvalSteps.add(step);
    notifyListeners();
  }catch(e){
    print('Error inserting approval step:$e');
  }
}

//Update existing approval step
Future<void> updateApprovalStep(ApprovalStep step)async{
  try{
    await ApiService.updateApprovalStep(step);
    int index = _approvalSteps
    .indexWhere((s)=> s.id == s.id);
    if(index != -1){
      _approvalSteps[index]= step;
      notifyListeners();
    }
  }catch(e){
    print('Error updating approval step:$e');
  }
}

}

class ApprovalSetupProvider with ChangeNotifier{
  
  List<ApprovalSetup>_approvalSetups = [];

  List<ApprovalSetup>get approvalSetups => _approvalSetups;

  Future<void>fetchApprovalSetups() async{
    try{
      final apiService = ApiService();
      _approvalSetups = await apiService.fetchApprovalSetup();
      notifyListeners();
    }catch(e){
       print('Error fetching approval setup:$e');

    }
  }

 Future<void>addApprovalSetups(ApprovalSetup newsetup)async{
  try{
    await    ApiService.postApprovalSetup(newsetup);
    _approvalSetups.add(newsetup);
    notifyListeners();
  }catch(e){
    print('Error inserting approval setup:$e');
  }
 }


 Future<void> updateApprovalSetups(ApprovalSetup updatesetup)async{
  try{
    await ApiService.updateApprovalSetup(updatesetup);
    int index = _approvalSetups.indexWhere((s)=> s.id == s.id);
     if(index != -1){
      _approvalSetups[index]= updatesetup;
      notifyListeners();
    }
     
  }catch(e){
    throw Exception('Error updating approval setup:$e');
  }
 }


}