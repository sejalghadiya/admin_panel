import 'package:admin_panel/utils/list_formatter.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import '../../../local_Storage/admin_shredPreferences.dart';
import '../../../network_connection/apis.dart';
import '../../../provider/product_provider/product_provider.dart';
import '../../../widgets/loading_widget.dart';

class PetDetailsScreen extends StatefulWidget {
  static const routeName = '/pet-details-screen';
  const PetDetailsScreen({super.key});

  @override
  State<PetDetailsScreen> createState() => _PetDetailsScreenState();
}

class _PetDetailsScreenState extends State<PetDetailsScreen> {
  final TextEditingController _adTitleController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
bool isEditable = false;
  int selectedIndex = 0;
  String productId = "";
  String modelName = "";
  String baseUrl = Apis.BASE_URL_IMAGE;
  final OutlineInputBorder border = OutlineInputBorder(
    borderSide: BorderSide(color: Colors.black,width: 1),
    borderRadius: BorderRadius.circular(8),
  );
  @override
  void initState() {
    super.initState();
    productId = Get.arguments['productId'] as String;
    modelName = Get.arguments['modelName'] as String;
    ProductProvider productProvider = Provider.of(context,listen: false);
    productProvider.fetchProductDetails(productId, modelName);
  }

  void setData()async{
    ProductProvider productProvider = Provider.of(context,listen: false);
    _adTitleController.text = productProvider.petList[0].adTitle.last.toString();
    _priceController.text = productProvider.petList[0].price.last.toString();
    _descriptionController.text = productProvider.petList[0].description.last.toString();
    // _addressController.text = productProvider.petList[0].address1.last.toString();
  }

  @override
  Widget build(BuildContext context) {

    ProductProvider productProvider = Provider.of(context,listen: true);
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        shadowColor: Colors.transparent,
        title: Text(
          'Pet Details',
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.edit, color: Colors.black),
            onPressed: ()async {
              setState(() {
                isEditable = !isEditable;
              });
              if(isEditable) {
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
                    TextButton(onPressed: () async {
                      await productProvider.deleteProduct(
                        productProvider.petList[0].id,
                        productProvider.petList[0].productType,
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
              productProvider.petList.isNotEmpty ?
              productProvider.petList[0].isActive
                  ? Icons.visibility
                  : Icons.visibility_off : Icons.error,
              color: Colors.black,
            ),
            onPressed: () async {
              if (productProvider.petList.isNotEmpty) {
                Map<String, dynamic> body = {
                  "productId": productProvider.petList[0].id,
                  "productType" : productProvider.petList[0].productType,
                };

                await productProvider.product_active_inactive(body);
              }
            },
          ),
        ],
      ),
      body: Stack(
       children: [
         Padding(
           padding: const EdgeInsets.all(8.0),
           child: Column(
             children: [
               Container(
                 alignment: Alignment.centerRight,
                 child: Column(
                   crossAxisAlignment: CrossAxisAlignment.end,
                   mainAxisAlignment: MainAxisAlignment.center,
                   children: [
                     if (productProvider.petList.isNotEmpty)
                       Column(
                         spacing: 6,
                         crossAxisAlignment: CrossAxisAlignment.end,
                         children: [
                           Text(
                             productProvider.petList.isNotEmpty &&
                                 productProvider.petList[0].timestamps.isNotEmpty
                                 ? DateFormat('d MMMM yyyy, hh:mm:ss a').format(
                               DateTime.parse(productProvider.petList[0].timestamps).toLocal(), // Convert to local time
                             )
                                 : 'N/A',
                             style: TextStyle(fontSize: 11, color: Colors.black),
                           ),

                           Row(
                             mainAxisAlignment: MainAxisAlignment.end,
                             mainAxisSize: MainAxisSize.min,
                             children: [
                               Text("Add Product User Name:--"),
                               Text(productProvider.petList[0].user.fName.last.toString()),
                               const SizedBox(width: 5),
                               Text(productProvider.petList[0].user.lName.last.toString()),
                             ],
                           ),
                           Text("Product Category:--${productProvider.petList[0].category}"),
                           Text("User product deleted:--${productProvider.petList[0].isDeleted}"),
                         ],
                       ),
                   ],
                 ),
               ),
               Row(
                 crossAxisAlignment: CrossAxisAlignment.start,
                 children: [
                   Consumer<ProductProvider>(
                       builder: (context,productProvider,child) {
                         return Padding(
                           padding: const EdgeInsets.all(8.0),
                           child: Column(
                             crossAxisAlignment: CrossAxisAlignment.start,
                             children: [
                               if (productProvider.petList.isNotEmpty) ...[
                                 Stack(
                                   children: [
                                     Container(
                                       padding: EdgeInsets.symmetric(horizontal: 20),
                                       height: 400,
                                       width: 400,
                                       decoration: BoxDecoration(
                                         borderRadius: BorderRadius.vertical(top: Radius.circular(8)),
                                       ),
                                       child: productProvider.petList.isNotEmpty &&
                                           productProvider.petList[0].images.isNotEmpty &&
                                           selectedIndex < productProvider.petList[0].images.length &&
                                           productProvider.petList[0].images[selectedIndex].isNotEmpty
                                           ? Image.network(
                                         '$baseUrl${productProvider.petList[0].images[selectedIndex]}',
                                         fit: BoxFit.fill,
                                         width: double.infinity,
                                         errorBuilder: (context, error, stackTrace) =>
                                             Icon(Icons.broken_image, size: 90),
                                       )
                                           : Icon(Icons.image, size: 90),
                                     ),
                                     Positioned(
                                       right: 4,
                                       top: 4,
                                       child: GestureDetector(
                                         onTap: () {
                                           showDialog(
                                             context: context,
                                             builder: (context) {
                                               return AlertDialog(
                                                 backgroundColor: Colors.white,
                                                 title: const Text('Delete Image'),
                                                 content: const Text('Are you sure you want to delete this image?'),
                                                 actions: [
                                                   TextButton(
                                                     onPressed: () {
                                                       Navigator.of(context).pop();
                                                     },
                                                     child: const Text('Cancel'),
                                                   ),
                                                   TextButton(
                                                     onPressed: () async {
                                                       Map<String,dynamic> body = {
                                                         "productId": productId,
                                                         "imagePath": productProvider.petList[0].images[selectedIndex],
                                                         "modelName": productProvider.petList[0].modelName
                                                       };
                                                       print(body);
                                                       productProvider.deleteProductImage(body);

                                                       Navigator.of(context).pop();
                                                     },
                                                     child: const Text('Delete'),
                                                   ),
                                                 ],
                                               );
                                             },
                                           );
                                         },
                                         child: const Icon(Icons.cancel,
                                             size: 18, color: Colors.red),
                                       ),
                                     ),
                                   ],
                                 )
                               ] else ...[],
                               const SizedBox(
                                 height: 10,
                               ),
                               if (productProvider.petList.isNotEmpty) ...[
                                 SizedBox(
                                   height: 50,
                                   child: ListView.builder(
                                     scrollDirection: Axis.horizontal,
                                     itemCount:
                                     productProvider.petList[0].images.length,
                                     shrinkWrap: true,
                                     itemBuilder: (context, index) {
                                       bool isSelected = index == selectedIndex;
                                       final imageUrl =
                                       productProvider.petList[0].images[index];
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
                       builder: (context,productProvider,child) {
                         return Expanded(
                           child: Column(
                             spacing: 15,
                             crossAxisAlignment:  CrossAxisAlignment.start,
                             children: [
                               if(productProvider.petList.isNotEmpty)...[
                                 if(isEditable)...[
                                   TextField(
                                     controller: _priceController,
                                     decoration: InputDecoration(
                                       labelText: 'Price',
                                       suffixIcon: Icon(Icons.edit),
                                       border: border,
                                       enabledBorder: border,
                                       focusedBorder: border,
                                     ),
                                   ),
                                 ]else...[
                                   Text(ListFormatter.formatList(productProvider.petList[0].price),
                                       style: TextStyle(fontSize: 16)),
                                 ]
                               ]else...[],
                               if(productProvider.petList.isNotEmpty)...[
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
                                   Text(ListFormatter.formatList(productProvider.petList[0].adTitle),
                                       style: TextStyle(fontSize: 15)),
                                 ]
                               ]else...[],
                               if(productProvider.petList.isNotEmpty)...[
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
                                       // Text(ListFormatter.formatList(productProvider.petList[0].address1),
                                       //   style: TextStyle(fontSize: 12),
                                       // )
                                     ],
                                   ),
                                 ]
                               ]else...[],
                               if(productProvider.petList.isNotEmpty)...[
                                 if(isEditable)...[
                                   TextField(
                                     controller: _descriptionController,
                                     textCapitalization: TextCapitalization.sentences,
                                     maxLines: null,
                                     decoration: InputDecoration(
                                       labelText: 'Description',
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
                                       const SizedBox(height: 2,),
                                       Text(ListFormatter.formatList(productProvider.petList[0].description),
                                           style: TextStyle(fontSize: 15)),
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
               const SizedBox(height: 20),
               Container(
                 color: Colors.grey.shade50,
                 child: Padding(
                   padding: const EdgeInsets.all(8.0),
                   child: ElevatedButton(
                     onPressed: () async {
                       String? userId = await AdminSharedPreferences().getUserId();
                       /* List<String> filteredImagePaths = _selectedImages
                                    .where((image) => !image.startsWith('http'))
                                    .toList();
                                List<String> base64Images = [];
                                for (String imagePath in filteredImagePaths) {
                                  String base64Image = await ImageHelper.imageToBase64(imagePath);
                                  base64Images.add(base64Image);
                                }*/
                       Map<String,dynamic> body = {
                         "productId": productProvider.petList[0].id,
                         "userId": userId,
                         "price": _priceController.text.trim(),
                         "adTitle": _adTitleController.text.trim(),
                         "description": _descriptionController.text.trim(),
                         "productType": productProvider.petList[0].productType,
                         "subProductType": productProvider.petList[0].subProductType,
                         "categories": productProvider.petList[0].category,
                         "address1": _addressController.text.trim(),
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
                       style: Theme.of(context).textTheme.titleLarge!.copyWith(
                         fontWeight: FontWeight.w500,
                         color: Colors.white,
                       ),
                     ),
                   ),
                 ),
               ),
               const SizedBox(height: 10),
               /* Consumer<ProductProvider>(
                      builder: (context,productProvider,child) {
                        return Expanded(
                          child: Container(
                            width: double.infinity,
                            decoration: BoxDecoration(
                                color: Colors.white,
                                border: Border(
                                  top: BorderSide(
                                    color: Colors.grey.shade300,
                                    width: 1,
                                  ),
                                )
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(20.0),
                              child: SingleChildScrollView(
                                child: Column(
                                  spacing: 20,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Column(
                                      spacing: 20,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        if(productProvider.petList.isNotEmpty)...[
                                         if(isEditable)...[
                                           TextField(
                                             controller: _priceController,
                                             decoration: InputDecoration(
                                               labelText: 'Price',
                                               suffixIcon: Icon(Icons.edit),
                                               border: border,
                                               enabledBorder: border,
                                               focusedBorder: border,
                                             ),
                                           ),
                                         ]else...[
                                           Text(ListFormatter.formatList(productProvider.petList[0].price),
                                               style: TextStyle(fontSize: 16)),
                                         ]
                                        ]else...[],
                                        if(productProvider.petList.isNotEmpty)...[
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
                                            Text(ListFormatter.formatList(productProvider.petList[0].adTitle),
                                                style: TextStyle(fontSize: 15)),
                                          ]
                                          ]else...[],
                                      ],
                                    ),
                                    if(productProvider.petList.isNotEmpty)...[
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
                                                Text(ListFormatter.formatList(productProvider.petList[0].address1),
                                                  style: TextStyle(fontSize: 12),
                                                )
                                          ],
                                        ),
                                      ]
                                    ]else...[],
                                    if(productProvider.petList.isNotEmpty)...[
                                      if(isEditable)...[
                                        TextField(
                                          controller: _descriptionController,
                                          textCapitalization: TextCapitalization.sentences,
                                          maxLines: null,
                                          decoration: InputDecoration(
                                            labelText: 'Description',
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
                                            const SizedBox(height: 2,),
                                            Text(ListFormatter.formatList(productProvider.petList[0].description),
                                                style: TextStyle(fontSize: 15)),
                                          ],
                                        ),
                                      ]
                                    ]else...[],
                                    const SizedBox(height: 20,),

                                  ],

                                ),
                              ),
                            ),
                          ),
                        );
                      }
                  ),*/
             ],
           ),
         ),
         productProvider.isLoading ? LoadingWidget() : Container(),
       ],
      )

    );
  }
}
