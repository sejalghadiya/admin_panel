import 'package:admin_panel/provider/user_provider/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:web/web.dart' as web;
import '../navigation/getX_navigation.dart';
import '../product/product_details_screen/bike/bike_details_screen.dart';
import '../product/product_details_screen/book_sport_hobby/book_sports_hobby_details_screen.dart';
import '../product/product_details_screen/car/car_details_screen.dart';
import '../product/product_details_screen/electronics/electronics_detail_screen.dart';
import '../product/product_details_screen/furniture/furniture_details_screen.dart';
import '../product/product_details_screen/job/job_details_screens.dart';
import '../product/product_details_screen/other/other_details_screen.dart';
import '../product/product_details_screen/pet/pet_details_screen.dart';
import '../product/product_details_screen/property/property_details_screen.dart';
import '../product/product_details_screen/services/services_details_screen.dart';
import '../product/product_details_screen/smart_phone/smart_phone_details_screen.dart';
import '../provider/report_provider/report_provider.dart';
import '../user/user_details_screen.dart';

class ReportDetailsScreen extends StatefulWidget {
  static String routeName = "/report-details-screen";
  const ReportDetailsScreen({super.key});

  @override
  State<ReportDetailsScreen> createState() => _ReportDetailsScreenState();
}

class _ReportDetailsScreenState extends State<ReportDetailsScreen> {
  String? reportId;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    reportId = Get.arguments;
    print("Report ID: $reportId");
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final reportProvider = Provider.of<ReportProvider>(context, listen: false);
      reportProvider.reportsDetailsByReportId(reportId!);
    });
  }
  void openInNewTab(String url) {
    web.window.open(url, '_blank');
  }
  @override
  Widget build(BuildContext context) {
    ReportProvider reportProvider = Provider.of<ReportProvider>(context, listen: false);
    UserProvider userProvider = Provider.of<UserProvider>(context, listen: false);
    final report = reportProvider.selectedReport;
    return Scaffold(
      appBar: AppBar(
        title: Text("Report Details"),
        actions: [
          Consumer<ReportProvider>(
            builder: (context, reportProvider, child) {
              final report = reportProvider.selectedReport;

              if (report == null) {
                return Center(child: Text("No report details available."));
              }

              return SizedBox(
                width: 100,
                child: IconButton(
                  onPressed: () async {
                    await Provider.of<UserProvider>(context, listen: false)
                        .userActiveInactive(report.productId); // Use the correct user ID

                    // Optional: Update active state if needed
                    setState(() {
                      report.isActive = !report.isActive;
                    });
                  },
                  icon: Icon(
                    report.isActive ? Icons.visibility : Icons.visibility_off,
                    color: report.isActive ? Colors.green : Colors.red,
                  ),
                ),
              );
            },
          ),
        ],
        ),
      backgroundColor: Colors.white,
       body: Consumer<ReportProvider>(
        builder: (context, reportProvider, child) {
      final report = reportProvider.selectedReport;
      if (report == null) {
        return Center(child: Text("No report details available."));
      }

      return ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Image
          InkWell(
            onTap: () {
              openInNewTab('https://api.bhavnika.shop${report.image}');
            },
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.network(
                'https://api.bhavnika.shop${report.image}',
                height: 300,
                width: 300,

                errorBuilder: (context, error, stackTrace) =>
                    Center(child: Icon(Icons.broken_image, size: 100)),
              ),
            ),
          ),
          const SizedBox(height: 20),
          Card(
            color: Colors.white,
            elevation: 4,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("📋 Report Details", style: Theme.of(context).textTheme.titleMedium),
                  const Divider(height: 20),
                  Text("Created At: ${DateFormat('d MMMM yyyy, hh:mm:ss a').format(DateTime.parse(report.createdAt).toLocal())}"),
                  Text("Model Name: ${report.modelName}"),
                  Text("Complaint: ${report.description}"),
                ],
              ),
            ),
          ),
          // Row(
          //   children: [
          //     Expanded(child:
          //     Card(
          //       color: Colors.white,
          //       elevation: 4,
          //       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          //       child: Padding(
          //         padding: const EdgeInsets.all(16),
          //         child: Column(
          //           crossAxisAlignment: CrossAxisAlignment.start,
          //           children: [
          //             Text("🧑 Product User Details", style: Theme.of(context).textTheme.titleMedium),
          //             const Divider(height: 20),
          //             Text("FName: ${report.productUserFName}"),
          //             Text("LName: ${report.productUserLName}"),
          //             Text("DOB: ${report.productUserDOB}"),
          //             Text("Phone: ${report.productUserPhone}"),
          //             Text("Email: ${report.productUserEmail}"),
          //             Text("State: ${report.productUserState}"),
          //             Text("District: ${report.productUserDistrict}"),
          //             Text("Area: ${report.productUserArea}"),
          //             Text("Occupation : ${report.productUserOccupation}"),
          //           ],
          //         ),
          //       ),
          //     ),
          //     ),
          //     const SizedBox(width: 50,),
          //     Expanded(child:
          //     Card(
          //       color: Colors.white,
          //       elevation: 4,
          //       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          //       child: Padding(
          //         padding: const EdgeInsets.all(16),
          //         child: Column(
          //           crossAxisAlignment: CrossAxisAlignment.start,
          //           children: [
          //             Text("📋 Report User Details", style: Theme.of(context).textTheme.titleMedium),
          //             const Divider(height: 20),
          //             Text("Created At: ${DateFormat('d MMMM yyyy, hh:mm:ss a').format(DateTime.parse(report.createdAt).toLocal())}"),
          //             Text("Model Name: ${report.modelName}"),
          //             Text("Complaint: ${report.description}"),
          //             Text("User Name: ${report.userName}"),
          //             Text("Email: ${report.userEmail}"),
          //             Text("State: ${report.userState}"),
          //             Text("District: ${report.userDistrict}"),
          //             Text("Area: ${report.userArea}"),
          //             //Text("Occupation: ${report.userOccupation}"),
          //           ],
          //         ),
          //       ),
          //     ),
          //     )
          //   ],
          // ),
          // // Product User Details

          Row(
            children: [
              // Product User Card
              Expanded(
                child: Card(
                  color: Colors.white,
                  elevation: 4,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("🧑 Product User Details", style: Theme.of(context).textTheme.titleMedium),
                        const Divider(height: 20),
                        Text("FName: ${report.productUserFName}"),
                        Text("LName: ${report.productUserLName}"),
                        Text("Phone: ${report.productUserPhone}"),
                        Text("Email: ${report.productUserEmail}"),
                        const SizedBox(height: 10),
                        Align(
                          alignment: Alignment.centerRight,
                          child: TextButton.icon(
                            onPressed: () {
                              Get.toNamed(
                                UserDetailsScreen.routeName,
                                arguments: report.productUserId, // make sure this ID is available in report
                              );
                            },
                            icon: const Icon(Icons.info_outline),
                            label: const Text("More Details"),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              const SizedBox(width: 50),

              // Report User Card
              Expanded(
                child: Card(
                  color: Colors.white,
                  elevation: 4,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("📋 Report User Details", style: Theme.of(context).textTheme.titleMedium),
                        const Divider(height: 20),
                        Text("FName: ${report.userName.split(" ").first}"),
                        Text("LName: ${report.userName.split(" ").last}"),
                        Text("Phone: ${report.userPhone}"),
                        Text("Email: ${report.userEmail}"),
                        const SizedBox(height: 10),
                        Align(
                          alignment: Alignment.centerRight,
                          child: TextButton.icon(
                            onPressed: () {
                              Get.toNamed(
                                UserDetailsScreen.routeName,
                                arguments: report.userId, // make sure this ID is available in report
                              );
                            },
                            icon: const Icon(Icons.info_outline),
                            label: const Text("More Details"),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          // Product Details
          Card(
            color: Colors.white,
            elevation: 4,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("📦 Product Details", style: Theme.of(context).textTheme.titleMedium),
                  const Divider(height: 20),
                  Text("Title: ${report.productTitle}"),
                  Text("Description: ${report.productDescription}"),
                  Text("Price: ${report.productPrice}"),
                  Text("Category: ${report.productCategory}"),
                  Text("Address: ${report.productAddress}"),
                  const SizedBox(height: 10),
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton.icon(
                      onPressed: () {
                        print("Product ID: ${report.productId}");
                        print("Model Name: ${report.modelName}");
                        navigateToProductFormScreen(
                          report.modelName,
                          report.productId,
                        );
                      },
                      icon: const Icon(Icons.remove_red_eye_outlined),
                      label: const Text("View Product"),
                    ),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 16),

          // Report User Details

        ],
      );
    },
    ),

    );
  }
  void navigateToProductFormScreen(String modelName, String productId) {
    print(modelName);
    Map<String, dynamic> args = {"productId": productId, "modelName": modelName,"isEdit": false};
    switch (modelName.toLowerCase()) {
      case "bike":
        {
          GetxNavigation.next(BikeDetailsScreen.routeName, arguments: args);
          break;
        }
      case "property":
        {
          GetxNavigation.next(PropertyDetailsScreen.routeName, arguments: args);
          // GetxNavigation.next(Property.routeName,arguments: productSubType);
          break;
        }
      case "car":
        {
          GetxNavigation.next(CarDetailsScreen.routeName, arguments: args);
          break;
        }
      case "book_sport_hobby":
        {
          GetxNavigation.next(
            BookSportsHobbyDetailsScreen.routeName,
            arguments: args,
          );
          break;
        }
      case "electronic":
        {
          GetxNavigation.next(
            ElectronicsDetailsScreen.routeName,
            arguments: args,
          );
          break;
        }
      case "furniture":
        {
          GetxNavigation.next(
            FurnitureDetailsScreen.routeName,
            arguments: args,
          );
          break;
        }
      case "job":
        {
          GetxNavigation.next(JobDetailsScreen.routeName, arguments: args);
          break;
        }
      case "pet":
        {
          GetxNavigation.next(PetDetailsScreen.routeName, arguments: args);
          break;
        }
      case "smart_phone":
        {
          GetxNavigation.next(
            SmartPhoneDetailsScreen.routeName,
            arguments: args,
          );
          // GetxNavigation.next(SmartPhone.routeName,arguments: productSubType);
          break;
        }
      case "services":
        {
          GetxNavigation.next(ServicesDetailScreen.routeName, arguments: args);
          break;
        }
      case "other":
        {
          GetxNavigation.next(OtherProductDetails.routeName, arguments: args);
          // GetxNavigation.next(OtherScreen.routeName,arguments: productSubType);
          break;
        }
      default:
        {
          Get.snackbar(
            "Oops!!!!!",
            "Something went wrong while selecting option.",
            backgroundColor: Colors.red,
            colorText: Colors.white,
            snackPosition: SnackPosition.BOTTOM,
          );
        }
    }
  }
}
