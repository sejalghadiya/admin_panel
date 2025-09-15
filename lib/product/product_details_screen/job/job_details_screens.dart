import 'package:admin_panel/local_Storage/admin_shredPreferences.dart';
import 'package:admin_panel/utils/list_formatter.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../../network_connection/apis.dart';
import '../../../provider/product_provider/product_provider.dart';
import '../../../widgets/loading_widget.dart';

class JobDetailsScreen extends StatefulWidget {
  static const routeName = "/job-details-screen";
  const JobDetailsScreen({super.key});

  @override
  State<JobDetailsScreen> createState() => _JobDetailsScreenState();
}

class _JobDetailsScreenState extends State<JobDetailsScreen> {
  final TextEditingController _salaryFroController = TextEditingController();
  final TextEditingController _salaryToController = TextEditingController();
  final TextEditingController _adTitleController = TextEditingController();
  final TextEditingController _additionalInfoController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  List<String> selectedTypes = ["Services", "Job"];
  List<String> selectedSalaryTypes = ["Hourly", "Weekly", "Monthly", "Yearly"];
  List<String> selectedPositionTypes = ["Temporary", "Contract", "Part Time", "Full Time"];
  String? selectedSalaryType;
  String? selectedPositionalType;
  String? selectedForTypes;
  bool isEditable = false;
  Set<String> favoriteProductIds = {};
  String productId = "";
  String modelName = "";
  int selectedIndex = 0;
  final PageController _pageController = PageController();
  bool isExpanded = false; // For expandable text
  String baseUrl = Apis.BASE_URL_IMAGE;
  final OutlineInputBorder border = OutlineInputBorder(
    borderSide: BorderSide(color: Colors.black,width: 0.5),
    borderRadius: BorderRadius.circular(8),
  );
  bool showAppBarActions = true;
  @override
  void initState() {
    super.initState();
    productId = Get.arguments['productId'] as String;
    modelName = Get.arguments['modelName'] as String;
    showAppBarActions = Get.arguments['isEdit'] as bool? ?? true;
    ProductProvider productProvider = Provider.of<ProductProvider>(context, listen: false);
    productProvider.fetchProductDetails(productId, modelName);
  }
  void setData() async{
    ProductProvider productProvider = Provider.of<ProductProvider>(context, listen: false);
    selectedPositionalType = productProvider.jobList[0].positionType.last.toString();
    selectedSalaryType = productProvider.jobList[0].salaryPeriod.last.toString();
    _salaryFroController.text = productProvider.jobList[0].salaryFrom.last.toString();
    _salaryToController.text = productProvider.jobList[0].salaryTo.last.toString();
    _adTitleController.text = productProvider.jobList[0].adTitle.last.toString();
    _additionalInfoController.text = productProvider.jobList[0].description.last.toString();
   // _addressController.text = productProvider.jobList[0].address1.last.toString();
    selectedSalaryType = productProvider.jobList[0].salaryPeriod.last.toString();
    selectedForTypes = productProvider.jobList[0].productType.toString();


  }

  @override
  Widget build(BuildContext context) {
    ProductProvider productProvider = Provider.of<ProductProvider>(context,listen: true);
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        shadowColor: Colors.transparent,
        title: Text("Job Details"),
        actions:showAppBarActions? [
          IconButton(
            icon: Icon(Icons.edit, color: Colors.black),
            onPressed: () async {
              setState(() {
                isEditable = !isEditable;
              });
              if(isEditable){
                setData();
              }
            }
          ),
          IconButton(
            icon: Icon(Icons.delete, color: Colors.black),
            onPressed: () async {
              final confirm = await showDialog<bool>(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text("Delete Product"),
                  content: const Text("Are you sure you want to delete this product?"),
                  actions: [
                    TextButton(
                      child: const Text("Cancel"),
                      onPressed: () => Navigator.of(context).pop(false),
                    ),
                    TextButton(onPressed: () async {
                      await productProvider.deleteProduct(
                        productProvider.jobList[0].id,
                        productProvider.jobList[0].productType,
                      );
                      Navigator.of(context).pop(true);

                    },
                      child: const Text("Delete"),
                    )
                  ],
                ),
              );
            },
          ),
          IconButton(
            icon: Icon(
              productProvider.jobList.isNotEmpty ?
              productProvider.jobList[0].isActive
                  ? Icons.visibility
                  : Icons.visibility_off : Icons.error,
              color: Colors.black,
            ),
            onPressed: () async {
              if (productProvider.jobList.isNotEmpty) {
                Map<String, dynamic> body = {
                  "productId": productProvider.jobList[0].id,
                  "productType" : productProvider.jobList[0].productType,
                };

                await productProvider.product_active_inactive(body);
              }
            },
          ),
        ]:[],
        centerTitle: true,
      ),
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: SingleChildScrollView(
              child: Column(
                spacing: 15,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    alignment: Alignment.centerRight,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        if (productProvider.jobList.isNotEmpty)
                          Column(
                            spacing: 6,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                productProvider.jobList.isNotEmpty &&
                                    productProvider.jobList[0].timestamps.isNotEmpty
                                    ? DateFormat('d MMMM yyyy, hh:mm:ss a').format(
                                  DateTime.parse(productProvider.jobList[0].timestamps).toLocal(), // Convert to local time
                                )
                                    : 'N/A',
                                style: TextStyle(fontSize: 11, color: Colors.black),
                              ),

                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text("Add Product User Name:--"),
                                  Text(productProvider.jobList[0].user.fName.last.toString()),
                                  const SizedBox(width: 5),
                                  Text(productProvider.jobList[0].user.lName.last.toString()),
                                ],
                              ),
                              Text("Product Category:--${productProvider.jobList[0].category}"),
                              Text("User product deleted:--${productProvider.jobList[0].isDeleted}"),
                            ],
                          ),
                      ],
                    ),
                  ),
                 Row(
                   crossAxisAlignment:  CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                   children: [
                     Consumer<ProductProvider>(
                         builder: (context, productProvider, child) {
                           return Padding(
                             padding: const EdgeInsets.all(8.0),
                             child: Column(
                               children: [
                                 if (productProvider.jobList.isNotEmpty) ...[
                                   Stack(
                                     children: [
                                       Container(
                                         padding: EdgeInsets.symmetric(horizontal: 20),
                                         height: 400,
                                         width: 400,
                                         decoration: BoxDecoration(
                                           borderRadius: BorderRadius.vertical(top: Radius.circular(8)),
                                         ),
                                         child: productProvider.jobList.isNotEmpty &&
                                             productProvider.jobList[0].images.isNotEmpty &&
                                             selectedIndex < productProvider.jobList[0].images.length &&
                                             productProvider.jobList[0].images[selectedIndex].isNotEmpty
                                             ? Image.network(
                                           '$baseUrl${productProvider.jobList[0].images[selectedIndex]}',
                                           fit: BoxFit.fill,
                                           width: double.infinity,
                                           errorBuilder: (context, error, stackTrace) =>
                                               Icon(Icons.broken_image, size: 90),
                                         )
                                             : Icon(Icons.image, size: 90),
                                       ),
                                       // Positioned(
                                       //   right: 4,
                                       //   top: 4,
                                       //   child: GestureDetector(
                                       //     onTap: () {
                                       //       showDialog(
                                       //         context: context,
                                       //         builder: (context) {
                                       //           return AlertDialog(
                                       //             backgroundColor: Colors.white,
                                       //             title: const Text('Delete Image'),
                                       //             content: const Text('Are you sure you want to delete this image?'),
                                       //             actions: [
                                       //               TextButton(
                                       //                 onPressed: () {
                                       //                   Navigator.of(context).pop();
                                       //                 },
                                       //                 child: const Text('Cancel'),
                                       //               ),
                                       //               TextButton(
                                       //                 onPressed: () async {
                                       //                   Map<String,dynamic> body = {
                                       //                     "productId": productId,
                                       //                     "imagePath": productProvider.jobList[0].images[selectedIndex],
                                       //                     "modelName": productProvider.jobList[0].modelName
                                       //                   };
                                       //                   print(body);
                                       //                   productProvider.deleteProductImage(body);
                                       //
                                       //                   Navigator.of(context).pop();
                                       //                 },
                                       //                 child: const Text('Delete'),
                                       //               ),
                                       //             ],
                                       //           );
                                       //         },
                                       //       );
                                       //     },
                                       //     child: const Icon(Icons.cancel,
                                       //         size: 18, color: Colors.red),
                                       //   ),
                                       // ),
                                     ],
                                   )
                                 ] else ...[],
                                 const SizedBox(
                                   height: 10,
                                 ),
                                 if (productProvider.jobList.isNotEmpty) ...[
                                   SizedBox(
                                     height: 50,
                                     child: ListView.builder(
                                       scrollDirection: Axis.horizontal,
                                       itemCount:
                                       productProvider.jobList[0].images.length,
                                       shrinkWrap: true,
                                       itemBuilder: (context, index) {
                                         bool isSelected = index == selectedIndex;
                                         final imageUrl =
                                         productProvider.jobList[0].images[index];
                                         return GestureDetector(
                                           onTap: () {
                                             setState(() {
                                               selectedIndex = index;
                                             });
                                           },
                                           child: Padding(
                                             padding: const EdgeInsets.symmetric(
                                               horizontal: 10,
                                               vertical: 5,
                                             ),
                                             child: Container(
                                               width: 60,
                                               decoration: BoxDecoration(
                                                 border:
                                                 isSelected
                                                     ? Border.all(
                                                   color: Colors.blue,
                                                   width: 2,
                                                 )
                                                     : null,
                                                 borderRadius: BorderRadius.circular(
                                                   8,
                                                 ),
                                               ),
                                               child:
                                               imageUrl != null &&
                                                   imageUrl.isNotEmpty
                                                   ? Image.network(
                                                 '$baseUrl$imageUrl',
                                                 fit: BoxFit.fill,
                                                 errorBuilder:
                                                     (
                                                     context,
                                                     error,
                                                     stackTrace,
                                                     ) => Icon(
                                                   Icons.broken_image,
                                                   size: 40,
                                                 ),
                                               )
                                                   : Icon(Icons.image, size: 40),
                                             ),
                                           ),
                                         );
                                       },
                                     ),
                                   ),
                                 ] else
                                   ...[],

                               ],
                             ),
                           );
                         }
                     ),
                      const SizedBox(width: 10),
                     Consumer<ProductProvider>(
                       builder: (context, productProvider, child) {
                         return Expanded(
                           child: Column(
                             crossAxisAlignment: CrossAxisAlignment.start,
                             spacing: 15,
                             children: [
                               if(productProvider.jobList.isNotEmpty)...[
                                 Text(ListFormatter.formatList(productProvider.jobList[0].price),
                                     style: TextStyle(fontSize: 15,color: Colors.black)),]else...[],
                               if(productProvider.jobList.isNotEmpty)...[
                                 if(isEditable)...[
                                  /* DropdownButtonFormField<String>(
                                     value: selectedTypes.contains(productProvider.jobList[0].serviceJob)
                                         ? productProvider.jobList[0].serviceJob
                                         : null,
                                     items: selectedTypes.map((val) {
                                       return DropdownMenuItem<String>(
                                         value: val,
                                         child: Text(val),
                                       );
                                     }).toList(),
                                     onChanged: (val) {
                                       selectedForTypes = val;
                                     },
                                     decoration: InputDecoration(
                                       labelText: 'Service/Job',
                                       border: border,
                                       enabledBorder: border,
                                       focusedBorder: border,
                                     ),
                                   ),*/
                                   Container(
                                     width: double.infinity,
                                     decoration: BoxDecoration(
                                         color: Colors.white
                                     ),
                                     child: Row(
                                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                       children: [
                                         Container(
                                             padding: EdgeInsets.symmetric(horizontal: 10,vertical: 5),
                                             child: Text("Service/Job")),
                                         Container(
                                           padding: EdgeInsets.symmetric(horizontal: 10,vertical: 5),
                                           child:  Text(productProvider.jobList[0].serviceJob, style: TextStyle(fontSize: 14)),),
                                       ],
                                     ),
                                   ),
                                 ]else...[
                                   Container(
                                     width: double.infinity,
                                     decoration: BoxDecoration(
                                         color: Colors.white
                                     ),
                                     child: Row(
                                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                       children: [
                                         Container(
                                             padding: EdgeInsets.symmetric(horizontal: 10,vertical: 5),
                                             child: Text("Service/Job")),
                                         Container(
                                           padding: EdgeInsets.symmetric(horizontal: 10,vertical: 5),
                                           child:  Text(productProvider.jobList[0].serviceJob, style: TextStyle(fontSize: 14)),),
                                       ],
                                     ),
                                   ),
                                 ]
                               ]else...[],
                               if(productProvider.jobList.isNotEmpty)...[
                                 if(isEditable)...[
                                   DropdownButtonFormField<String>(
                                     value: productProvider.jobList[0].positionType.last.isNotEmpty
                                         ? productProvider.jobList[0].positionType.last.toString()
                                         : null,
                                     items: selectedPositionTypes.map((val) {
                                       return DropdownMenuItem<String>(
                                         value: val,
                                         child: Text(val),
                                       );
                                     }).toList(),
                                     onChanged: (val) {
                                       selectedPositionalType = val;
                                     },
                                     decoration: InputDecoration(
                                       labelText: 'Selected Position Type',
                                       border: border,
                                       enabledBorder: border,
                                       focusedBorder: border,
                                     ),
                                   ),
                                 ]else...[
                                   Container(
                                     width: double.infinity,
                                     decoration: BoxDecoration(
                                         color: Colors.white
                                     ),
                                     child: Row(
                                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                       children: [
                                         Container(
                                             padding: EdgeInsets.symmetric(horizontal: 10,vertical: 5),
                                             child: Text("Position type")),
                                         Container(
                                           padding: EdgeInsets.symmetric(horizontal: 10,vertical: 5),
                                           child:  Text(ListFormatter.formatList(productProvider.jobList[0].positionType), style: TextStyle(fontSize: 14)),),
                                       ],
                                     ),
                                   ),
                                 ]
                               ]else...[],
                              if(productProvider.jobList.isNotEmpty)...[
                                if(isEditable)...[
                                  DropdownButtonFormField<String>(
                                    value: selectedSalaryTypes.contains(productProvider.jobList[0].salaryPeriod)
                                        ? productProvider.jobList[0].salaryPeriod.last.toString()
                                        : null,
                                    items: selectedSalaryTypes.map((val) {
                                      return DropdownMenuItem<String>(
                                        value: val,
                                        child: Text(val),
                                      );
                                    }).toList(),
                                    onChanged: (val) {
                                      selectedSalaryType = val;
                                    },
                                    decoration: InputDecoration(
                                      labelText: 'Salary Period',
                                      border: border,
                                      enabledBorder: border,
                                      focusedBorder: border,
                                    ),
                                  ),
                                ]else...[
                                  Container(
                                    width: double.infinity,
                                    decoration: BoxDecoration(
                                        color: Colors.white
                                    ),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Container(
                                            padding: EdgeInsets.symmetric(horizontal: 10,vertical: 5),
                                            child: Text("Salary period")),
                                        Container(
                                          padding: EdgeInsets.symmetric(horizontal: 10,vertical: 5),
                                          child:  Text(ListFormatter.formatList(productProvider.jobList[0].salaryPeriod),  style: TextStyle(fontSize: 14)),),
                                      ],
                                    ),
                                  ),
                                ]
                              ]else...[],
                              if(productProvider.jobList.isNotEmpty)...[
                                if(isEditable)...[
                                  TextField(
                                    controller: _salaryFroController,
                                    decoration: InputDecoration(
                                      labelText: 'Salary From',
                                      suffixIcon: Icon(Icons.edit),
                                      border: border,
                                      enabledBorder: border,
                                      focusedBorder: border,
                                    ),
                                  ),
                                ]else...[
                                  Container(
                                    width: double.infinity,
                                    decoration: BoxDecoration(
                                        color: Colors.white
                                    ),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Container(
                                            padding: EdgeInsets.symmetric(horizontal: 10,vertical: 5),
                                            child: Text("Salary from")),
                                        Container(
                                          padding: EdgeInsets.symmetric(horizontal: 10,vertical: 5),
                                          child:  Text(ListFormatter.formatList(productProvider.jobList[0].salaryFrom), style: TextStyle(fontSize: 14)),),
                                      ],
                                    ),
                                  ),
                                ]
                              ]else...[],
                               if(productProvider.jobList.isNotEmpty)...[
                                 if(isEditable)...[
                                   TextField(
                                     controller: _salaryToController,
                                     decoration: InputDecoration(
                                       labelText: 'Salary To',
                                       suffixIcon: Icon(Icons.edit),
                                       border: border,
                                       enabledBorder: border,
                                       focusedBorder: border,
                                     ),
                                   ),
                                 ]else...[
                                   Container(
                                     width: double.infinity,
                                     decoration: BoxDecoration(
                                         color: Colors.white
                                     ),
                                     child: Row(
                                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                       children: [
                                         Container(
                                             padding: EdgeInsets.symmetric(horizontal: 10,vertical: 5),
                                             child: Text("Salary to")),
                                         Container(
                                           padding: EdgeInsets.symmetric(horizontal: 10,vertical: 5),
                                           child:  Text(ListFormatter.formatList(productProvider.jobList[0].salaryTo), style: TextStyle(fontSize: 14)),),
                                       ],
                                     ),
                                   ),
                                 ]
                               ]else...[],
                               if(productProvider.jobList.isNotEmpty)...[
                                 if(isEditable)...[
                                   TextField(
                                     controller: _adTitleController,
                                     textCapitalization: TextCapitalization.sentences,
                                     maxLines: null,
                                     decoration: InputDecoration(
                                       labelText: 'Title',
                                       suffixIcon: Icon(Icons.edit),
                                       border: border,
                                       enabledBorder: border,
                                       focusedBorder: border,
                                     ),
                                   ),
                                 ]else...[
                                   Text(ListFormatter.formatList(productProvider.jobList[0].adTitle),)
                                 ]
                               ]else...[],
                             ],
                           ),
                         );
                       }
                     )
                   ],
                 ),
                  if(productProvider.jobList.isNotEmpty)...[
                    if(isEditable)...[
                      TextField(
                        controller: _addressController,
                        textCapitalization: TextCapitalization.sentences,
                        maxLines: null,
                        decoration: InputDecoration(
                          labelText: 'Address',
                          suffixIcon: Icon(Icons.edit),
                          border: border,
                          enabledBorder: border,
                          focusedBorder: border,
                        ),
                      ),
                    ]else...[
                      Row(
                        children: [
                          Icon(Icons.location_on_outlined,size: 17,),
                          const SizedBox(width: 5),
                          if (productProvider.jobList.isNotEmpty)
                            ...[
                              // Text(ListFormatter.formatList(productProvider.jobList[0].address1),
                              //   style: TextStyle(fontSize: 12),
                              // )
                            ]
                          else
                            ...[],

                        ],
                      ),
                    ]
                  ]else...[],
                  if(productProvider.jobList.isNotEmpty)...[
                    if(isEditable)...[
                      TextField(
                        controller: _additionalInfoController,
                        textCapitalization: TextCapitalization.sentences,
                        maxLines: null,
                        decoration: InputDecoration(
                          labelText: 'Additional Information',
                          suffixIcon: Icon(Icons.edit),
                          border: border,
                          enabledBorder: border,
                          focusedBorder: border,
                        ),
                      ),
                    ]else...[
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Description: "),
                          if(productProvider.jobList.isNotEmpty)...[
                            Text(ListFormatter.formatList(productProvider.jobList[0].description),
                                style: TextStyle(fontSize: 15)),]else...[],
                        ],
                      ),
                    ]
                  ]else...[],

                  const SizedBox(height: 20),
                 showAppBarActions? Container(
                    color: Colors.grey.shade50,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ElevatedButton(
                        onPressed: () async {
                          String? userId = await AdminSharedPreferences().getUserId();
                          Map<String,dynamic> body = {
                            "userId": userId,
                            "productId": productProvider.jobList[0].id,
                           // "service_job": selectedForTypes.toString(),
                            "adTitle": _adTitleController.text,
                            "description": _additionalInfoController.text,
                            "address1": _addressController.text,
                            "salaryFrom": _salaryFroController.text,
                            "salaryTo": _salaryToController.text,
                            "serviceJob": selectedForTypes.toString(),
                            "positionType": selectedPositionalType.toString(),
                            "salaryPeriod": selectedSalaryType.toString(),
                            "productType": productProvider.jobList[0].productType,
                            "subProductType": productProvider.jobList[0].subProductType,
                            "categories": productProvider.jobList[0].category,
                           // "productImages":base64Images
                          };
                          print(body);
                          await productProvider.updateProduct(body);
                        },
                        style: ElevatedButton.styleFrom(
                          foregroundColor: Colors.white,
                          backgroundColor: Colors.green,
                          // ✅ Green if checked, Grey if not
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(7),
                          ),
                          minimumSize: Size(double.infinity, 50),
                        ),
                        child: Text(
                          "Update",
                          style: Theme.of(context)
                              .textTheme
                              .titleLarge!
                              .copyWith(
                            fontWeight: FontWeight.w500,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ) : SizedBox.shrink(),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ) ,
          productProvider.isLoading ? LoadingWidget() : Container(),
        ],
      ),
    );
  }
}