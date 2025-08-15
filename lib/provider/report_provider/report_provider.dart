import 'dart:convert';

import 'package:admin_panel/local_Storage/admin_shredPreferences.dart';
import 'package:admin_panel/model/report_model/report_model.dart';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;

import '../../network_connection/apis.dart';

class ReportProvider extends ChangeNotifier {
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  int _reportCount = 0;
  int get reportCountValue => _reportCount;


  List<ReportModel> _reports = [];
  List<ReportModel> get reports => _reports;

  ReportModel? _selectedReport;
  ReportModel? get selectedReport => _selectedReport;

  void setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  Future<void> getReports() async {
    try {
      String token = await AdminSharedPreferences().getAuthToken();
      setLoading(true);
      var headers = {
        'Content-Type': 'application/json',
          'Authorization': 'Bearer $token'
      };
      var request = http.Request(
        'GET',
        Uri.parse('${Apis.BASE_URL}/admin/report_product'),
      );
      request.headers.addAll(headers);
      http.StreamedResponse response = await request.send();
      String responseBody = await response.stream.bytesToString();
      Map<String, dynamic> jsonData = json.decode(responseBody);

      if (response.statusCode == 200) {
        _reports = (jsonData['data'] as List<dynamic>).map((e) {
          return ReportModel.fromJson(e as Map<String, dynamic>);
        }).toList();
      } else {
        print("Error: ${response.reasonPhrase}");
      }
    } catch (e) {
      print("Exception in getReports: $e");
    } finally {
      setLoading(false);
    }
  }


  Future<void> reportsDetailsByReportId(String reportId)async{
    try {
      setLoading(true);
      String token = await AdminSharedPreferences().getAuthToken();
      var headers = {
        'Content-Type': 'application/json',
        'Authorization' : 'Bearer $token'
      };
      var request = http.Request('GET', Uri.parse('${Apis.BASE_URL}/admin/get_report_product_by_id?reportId=$reportId'));
      request.headers.addAll(headers);
      http.StreamedResponse response = await request.send();
      final responseBody = await response.stream.bytesToString();
      final jsonData = json.decode(responseBody);

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonData['data'];
        _selectedReport = ReportModel.fromJson(data);
      } else {
        print("Error: ${response.reasonPhrase}");
        return null;
      }
    } catch (e) {
      print("Exception in reportsDetailsByReportId: $e");
      return null;
    }
    finally {
      setLoading(false);
      notifyListeners();
    }
  }

  Future<void> reportCount() async {
    try {
      String token = await AdminSharedPreferences().getAuthToken();
      var headers = {
        'Content-Type': 'application/json',
        'Authorization' : 'Bearer $token'
      };
      var request = http.Request(
        'GET',
        Uri.parse('${Apis.BASE_URL}/admin/get_report_count'),
      );
      request.headers.addAll(headers);
      http.StreamedResponse response = await request.send();
      final responseBody = await response.stream.bytesToString();

      if (response.statusCode == 200) {
        final jsonData = json.decode(responseBody);
        _reportCount = jsonData['count'] ?? 0;
      } else {
        print("Error: ${response.reasonPhrase}");
      }
    } catch (e) {
      print("Exception in reportCount: $e");
    } finally {
      notifyListeners(); // Notify listeners when count changes
    }
  }

}
