import 'package:admin_panel/local_Storage/admin_shredPreferences.dart';
import 'package:admin_panel/utils/list_formatter.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../../network_connection/apis.dart';
import '../../../provider/product_provider/product_provider.dart';
import '../../../widgets/loading_widget.dart';
class ServicesDetailScreen extends StatefulWidget {
  static const String routeName = "/services-details-screen";
  const ServicesDetailScreen({super.key});

  @override
  State<ServicesDetailScreen> createState() => _ServicesDetailScreenState();
}

class _ServicesDetailScreenState extends State<ServicesDetailScreen> {
  final TextEditingController _adTitleController = TextEditingController();
  final TextEditingController _additionalInformationController = TextEditingController();
  final TextEditingController _addServiceOrJobType = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  bool isEditable = false;
  String baseUrl = Apis.BASE_URL_IMAGE;
  int selectedIndex = 0;
  String productId = "";
  String modelName = "";
  String? selectedValue;
  List<String> serviceValue = ["Service", "Job"];

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
    ProductProvider productProvider = Provider.of<ProductProvider>(context,listen: false);
    productProvider.fetchProductDetails(productId, modelName);
  }
  void setData()async {
    ProductProvider productProvider = Provider.of<ProductProvider>(context,listen: false);
    setState(() {
      _adTitleController.text = productProvider.servicesList[0].adTitle.last.toString();
      _additionalInformationController.text = productProvider.servicesList[0].description.last.toString();
      _addServiceOrJobType.text = productProvider.servicesList[0].serviceJob;
     // _addressController.text = productProvider.servicesList[0].address1.last.toString();
    });
  }

  @override
  Widget build(BuildContext context) {
    ProductProvider productProvider = Provider.of<ProductProvider>(context,listen: true);
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        shadowColor: Colors.transparent,
        title: Text(
          'Services Details',
        ),
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
            },
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
                    TextButton(
                      onPressed: () async {
                      await productProvider.deleteProduct(
                        productProvider.servicesList[0].id,
                        productProvider.servicesList[0].productType,
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
              productProvider.servicesList.isNotEmpty ?
              productProvider.servicesList[0].isActive
                  ? Icons.visibility
                  : Icons.visibility_off : Icons.error,
              color: Colors.black,
            ),
            onPressed: () async {
              if (productProvider.servicesList.isNotEmpty) {
                Map<String, dynamic> body = {
                  "productId": productProvider.servicesList[0].id,
                  "productType" : productProvider.servicesList[0].productType,
                };

                await productProvider.product_active_inactive(body);
              }
            },
          ),
        ]:[],
      ),
      body: Stack(
        children: [
          productProvider.servicesList.isNotEmpty ?
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              spacing: 15,
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment:  MainAxisAlignment.start,
              children: [
                Container(
                  alignment: Alignment.centerRight,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      if (productProvider.servicesList.isNotEmpty)
                        Column(
                          spacing: 6,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              productProvider.servicesList.isNotEmpty &&
                                  productProvider.servicesList[0].timestamps.isNotEmpty
                                  ? DateFormat('d MMMM yyyy, hh:mm:ss a').format(
                                DateTime.parse(productProvider.servicesList[0].timestamps).toLocal(), // Convert to local time
                              )
                                  : 'N/A',
                              style: TextStyle(fontSize: 11, color: Colors.black),
                            ),

                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text("Add Product User Name:--"),
                                Text(productProvider.servicesList[0].user.fName.last.toString()),
                                const SizedBox(width: 5),
                                Text(productProvider.servicesList[0].user.lName.last.toString()),
                              ],
                            ),
                            Text("Product Category:--${productProvider.servicesList[0].category}"),
                            Text("User product deleted:--${productProvider.servicesList[0].isDeleted}"),
                          ],
                        ),
                    ],
                  ),
                ),
               Row(
                 crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                 children: [
                   Column(
                     children: [
                       Consumer<ProductProvider>(
                           builder: (context, productProvider, child) {
                             return Padding(
                               padding: const EdgeInsets.all(8.0),
                               child: Column(
                                 children: [
                                   if (productProvider.servicesList.isNotEmpty) ...[
                                    Stack(
                                      children: [
                                        Container(
                                          padding: EdgeInsets.symmetric(horizontal: 20),
                                          height: 400,
                                          width: 400,
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.vertical(top: Radius.circular(8)),
                                          ),
                                          child: productProvider.servicesList.isNotEmpty &&
                                              productProvider.servicesList[0].images.isNotEmpty &&
                                              selectedIndex < productProvider.servicesList[0].images.length &&
                                              productProvider.servicesList[0].images[selectedIndex].isNotEmpty
                                              ? Image.network(
                                            '$baseUrl${productProvider.servicesList[0].images[selectedIndex]}',
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
                                        //                     "imagePath": productProvider.servicesList[0].images[selectedIndex],
                                        //                     "modelName": productProvider.servicesList[0].modelName
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
                                   if (productProvider.servicesList.isNotEmpty) ...[
                                     SizedBox(
                                       height: 50,
                                       child: ListView.builder(
                                         scrollDirection: Axis.horizontal,
                                         itemCount:
                                         productProvider.servicesList[0].images.length,
                                         shrinkWrap: true,
                                         itemBuilder: (context, index) {
                                           bool isSelected = index == selectedIndex;
                                           final imageUrl =
                                           productProvider.servicesList[0].images[index];
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
                     ],
                   ),
                    const SizedBox(width: 10),
                   Consumer<ProductProvider>(
                     builder: (context,productProvider,child) {
                       return Expanded(
                         child: Column(
                           spacing: 15,
                           crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                           children: [
                             if(productProvider.servicesList.isNotEmpty)...[
                               if(isEditable)...[
                                 Text('Service/Job:--  ${productProvider.servicesList[0].serviceJob}',
                                     style: TextStyle(fontSize: 15))
                               ]else...[
                                 Row(
                                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                   children: [
                                     Text('Service/Job:',
                                         style: TextStyle(fontSize: 15)),
                                     Text(productProvider.servicesList[0].serviceJob),
                                   ],
                                 )
                               ]
                             ]else...[],
                             if(productProvider.servicesList.isNotEmpty)...[
                              if(isEditable)...[
                                /*DropdownButtonFormField<String>(
                                  value:  null,
                                  decoration: InputDecoration(
                                    labelText: 'Service/Job',
                                    border: border,
                                    enabledBorder: border,
                                    focusedBorder: border,
                                  ),
                                  icon: Icon(Icons.arrow_drop_down),
                                  items: serviceValue.map((String value) {
                                    return DropdownMenuItem<String>(
                                      value: value,
                                      child: Text(value),
                                    );
                                  }).toList(),
                                  onChanged: (newValue) {
                                    setState(() {
                                      selectedValue = newValue!;
                                    });
                                  },
                                ),*/
                                TextField(
                                  controller: _addServiceOrJobType,
                                  textCapitalization: TextCapitalization.sentences,
                                  decoration: InputDecoration(
                                    labelText: 'Select Service Or Job Work Type',
                                    suffixIcon: Icon(Icons.edit),
                                    border: border,
                                    enabledBorder: border,
                                    focusedBorder: border,
                                  ),
                                )
                              ] else...[
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text("Services or job work type:"),
                                    Text("${productProvider.servicesList[0].serviceType}"),
                                  ],
                                )
                              ]
                             ]else...[],
                             if(productProvider.servicesList.isNotEmpty)...[
                               if(isEditable)...[
                                  TextField(
                                    controller: _adTitleController,
                                    textCapitalization: TextCapitalization.sentences,
                                    decoration: InputDecoration(
                                      labelText: 'Ad Title',
                                      suffixIcon: Icon(Icons.edit),
                                      border: border,
                                      enabledBorder: border,
                                      focusedBorder: border,
                                    ),
                                  )
                               ]else...[
                                 Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                   children: [
                                     Text("Title:"),
                                     Text(ListFormatter.formatList(productProvider.servicesList[0].adTitle),
                                         style: TextStyle(fontSize: 15)),
                                   ],
                                 )
                               ]
                             ]else...[],
                             if(productProvider.servicesList.isNotEmpty)...[
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
                                     if (productProvider.servicesList.isNotEmpty)
                                       ...[
                                         // Text(ListFormatter.formatList(productProvider.servicesList[0].address1),
                                         //   style: TextStyle(fontSize: 12),
                                         // )
                                       ]
                                     else
                                       ...[],

                                   ],
                                 ),
                               ]
                             ]else...[],
                             if(productProvider.servicesList.isNotEmpty)...[
                               if(isEditable)...[
                                 TextField(
                                   controller: _additionalInformationController,
                                   textCapitalization: TextCapitalization.sentences,
                                   decoration: InputDecoration(
                                     labelText: 'Additional Information',
                                     suffixIcon: Icon(Icons.edit),
                                     border: border,
                                     enabledBorder: border,
                                     focusedBorder: border,
                                   ),
                                 )
                               ]else...[
                                 Column(
                                   crossAxisAlignment: CrossAxisAlignment.start,
                                   children: [
                                     Text("Description: "),
                                     if(productProvider.servicesList.isNotEmpty)...[
                                       Text(ListFormatter.formatList(productProvider.servicesList[0].description),
                                           style: TextStyle(fontSize: 15)),]else...[],
                                   ],
                                 ),
                               ]
                             ]else...[],
                           ],
                         ),
                       );
                     }
                   )
                 ],
               ),
               showAppBarActions? Container(
                  color: Colors.grey.shade50,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ElevatedButton(
                      onPressed: () async {
                        String? userId = await AdminSharedPreferences().getUserId();
                        Map<String,dynamic> body = {
                          "userId": userId,
                          "productId": productProvider.servicesList[0].id,
                          "adTitle": _adTitleController.text,
                          // "service_job": selectedForTypes.toString(),
                          "service_type": _addServiceOrJobType.text.trim(),
                          "description": _additionalInformationController.text,
                          "address1": _addressController.text,
                          "productType": productProvider.servicesList[0].productType,
                          "subProductType": productProvider.servicesList[0].subProductType,
                          "categories": productProvider.servicesList[0].category,
                          //"productImages":base64Images
                        };
                        print("Body : $body");
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
                SizedBox(height: 20),
              ],
            ),
          ) : LoadingWidget(),
          productProvider.isLoading ? LoadingWidget() : Container(),
        ],
      ),
    );
  }
}
