import 'package:admin_panel/navigation/getX_navigation.dart';
import 'package:admin_panel/provider/report_provider/report_provider.dart';
import 'package:admin_panel/report/report_details_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

class ReportScreen extends StatefulWidget {
  static String routeName = "/report-screen";
  const ReportScreen({super.key});

  @override
  State<ReportScreen> createState() => _ReportScreenState();
}

class _ReportScreenState extends State<ReportScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final reportProvider = Provider.of<ReportProvider>(context, listen: false);
      reportProvider.getReports();
    });
  }


  @override
  Widget build(BuildContext context) {
    ReportProvider reportProvider = Provider.of<ReportProvider>(context, listen: false);
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          spacing: 15,
          children: [
            Text("Reports",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            Expanded(
              child: Consumer<ReportProvider>(
                builder: (context, reportProvider, child) {
                  if (reportProvider.isLoading) {
                    return Center(child: CircularProgressIndicator());
                  }

                  if (reportProvider.reports.isEmpty) {
                    return Center(child: Text('No reports found.'));
                  }

                  return ListView.builder(
                    itemCount: reportProvider.reports.length,
                    itemBuilder: (context, index) {
                      final report = reportProvider.reports[index];
                      return InkWell(
                        onTap: (){
                          print("++++++++++");
                          GetxNavigation.next(ReportDetailsScreen.routeName,arguments: report.id);
                        },
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          child: Card(
                            color: Colors.white,
                            child: Container(
                              margin: EdgeInsets.symmetric(horizontal: 10,vertical: 15),
                              padding: EdgeInsets.symmetric(horizontal: 5,vertical: 5),
                              height: 100,width: 100,
                              child: Row(
                                spacing: 15,
                                children: [
                                  Container(
                                    height: 100,width: 100,
                                    child: Image.network('https://api.bhavnika.shop${report.image}',fit: BoxFit.fill,),
                                  ),

                                  Column(
                                    spacing: 10,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(report.modelName),
                                      Text('Reported by: ${report.userName} - ${report.userEmail}'),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      )
    );
  }
}

