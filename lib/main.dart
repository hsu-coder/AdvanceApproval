import 'package:advance_budget_request_system/views/dashoard.dart';
import 'package:advance_budget_request_system/views/login.dart';
import 'package:advance_budget_request_system/views/register.dart';
import 'package:advance_budget_request_system/views/trip.dart';
import 'package:advance_budget_request_system/views/tripEntry.dart';
import 'package:flutter/material.dart';

void main(){
  runApp(
    const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: TripInfo(),
    )
  );
}