import 'package:admin_panel/utils/list_formatter.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import '../../../local_Storage/admin_shredPreferences.dart';
import '../../../network_connection/apis.dart';
import '../../../provider/product_provider/product_provider.dart';
import '../../../utils/brand_list.dart';
import '../../../widgets/loading_widget.dart';


class SmartPhoneDetailsScreen extends StatefulWidget {
  static const routeName = '/smart-phone-details-screen';
  const SmartPhoneDetailsScreen({super.key});

  @override
  State<SmartPhoneDetailsScreen> createState() => _SmartPhoneDetailsScreenState();
}

class _SmartPhoneDetailsScreenState extends State<SmartPhoneDetailsScreen> {
  final TextEditingController _modelController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _batteryBackupController = TextEditingController();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  String? selectedBrand;
  String? selectedStorage;
  final List<String> storageOptions = ['64GB', '128GB', '256GB'];
  final OutlineInputBorder border = OutlineInputBorder(
    borderSide: BorderSide(color: Colors.black,width: 0.5),
    borderRadius: BorderRadius.circular(8),
  );
  bool isEditable = false;
  Set<String> favoriteProductIds = {};
  int selectedIndex = 0;
  String productId = "";
  String modelName = "";
  String baseUrl = Apis.BASE_URL_IMAGE;
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

  void setData()async{
    ProductProvider productProvider = Provider.of<ProductProvider>(context, listen: false);
     _modelController.text = productProvider.smartPhoneList[0].model.last.toString();
     _priceController.text = productProvider.smartPhoneList[0].price.last.toString();
     _descriptionController.text = productProvider.smartPhoneList[0].description.last.toString();
     _batteryBackupController.text = productProvider.smartPhoneList[0].batteryBackup.last.toString();
     _titleController.text = productProvider.smartPhoneList[0].adTitle.last.toString();
    // _addressController.text = productProvider.smartPhoneList[0].address1.last.toString();
     selectedBrand = productProvider.smartPhoneList[0].brand.last.toString();
      selectedStorage = productProvider.smartPhoneList[0].storage.last.toString();


  }

  @override
  Widget build(BuildContext context) {
    ProductProvider productProvider = Provider.of<ProductProvider>(context, listen: true);
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        shadowColor: Colors.transparent,
        title: const Text("Mobile Details",style: TextStyle(color: Colors.black),),
        actions: showAppBarActions ? [
          IconButton(
            icon: Icon(Icons.edit, color: Colors.black),
            onPressed: () async {
              setState(() {
                isEditable = !isEditable;
              });
              if(isEditable){
                // setData
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
                      productProvider.deleteProduct(
                          productProvider.smartPhoneList[0].id,
                          productProvider.smartPhoneList[0].productType
                      );
                      Navigator.of(context).pop(true);
                      setState(() {

                      });
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
              productProvider.smartPhoneList.isNotEmpty ?
              productProvider.smartPhoneList[0].isActive
                  ? Icons.visibility
                  : Icons.visibility_off : Icons.error,
              color: Colors.black,
            ),
            onPressed: () async {
              if (productProvider.smartPhoneList.isNotEmpty) {
                Map<String, dynamic> body = {
                  "productId": productProvider.smartPhoneList[0].id,
                  "productType" : productProvider.smartPhoneList[0].productType,
                };

                await productProvider.product_active_inactive(body);
              }
            },
          ),
        ]:[],
      ),
      body: Stack(
        children: [
          productProvider.smartPhoneList.isNotEmpty ?
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: SingleChildScrollView(
              child: Column(
                spacing: 15,
                children: [
                  Container(
                    alignment: Alignment.centerRight,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        if (productProvider.smartPhoneList.isNotEmpty)
                          Column(
                            spacing: 6,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                productProvider.smartPhoneList.isNotEmpty &&
                                    productProvider.smartPhoneList[0].timestamps.isNotEmpty
                                    ? DateFormat('d MMMM yyyy, hh:mm:ss a').format(
                                  DateTime.parse(productProvider.smartPhoneList[0].timestamps).toLocal(), // Convert to local time
                                )
                                    : 'N/A',
                                style: TextStyle(fontSize: 11, color: Colors.black),
                              ),

                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text("Add Product User Name:--"),
                                  Text(productProvider.smartPhoneList[0].user.fName.last.toString()),
                                  const SizedBox(width: 5),
                                  Text(productProvider.smartPhoneList[0].user.lName.last.toString()),
                                ],
                              ),
                              Text("Product Category:--${productProvider.smartPhoneList[0].category}"),
                              Text("User product deleted:--${productProvider.smartPhoneList[0].isDeleted}"),
                            ],
                          ),
                      ],
                    ),
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Column(
                        children: [
                          Consumer<ProductProvider>(
                              builder: (context, productDetailsProvider, child) {
                                return Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      if (productDetailsProvider.smartPhoneList.isNotEmpty) ...[
                                        Stack(
                                          children: [
                                            Container(
                                              padding: EdgeInsets.symmetric(horizontal: 20),
                                              height: 400,
                                              width: 400,
                                              decoration: BoxDecoration(
                                                  borderRadius: BorderRadius.vertical(top: Radius.circular(8)),
                                              ),
                                              child: productDetailsProvider.smartPhoneList.isNotEmpty &&
                                                  productDetailsProvider.smartPhoneList[0].images.isNotEmpty &&
                                                  selectedIndex < productDetailsProvider.smartPhoneList[0].images.length &&
                                                  productDetailsProvider.smartPhoneList[0].images[selectedIndex].isNotEmpty
                                                  ? Image.network(
                                                '$baseUrl${productDetailsProvider.smartPhoneList[0].images[selectedIndex]}',
                                                fit: BoxFit.contain,
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
                                            //                     "imagePath": productProvider.smartPhoneList[0].images[selectedIndex],
                                            //                     "modelName": productProvider.smartPhoneList[0].modelName
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
                                      if (productProvider.smartPhoneList.isNotEmpty) ...[
                                        SizedBox(
                                          height: 50,
                                          child: ListView.builder(
                                            scrollDirection: Axis.horizontal,
                                            itemCount:
                                            productProvider.smartPhoneList[0].images.length,
                                            shrinkWrap: true,
                                            itemBuilder: (context, index) {
                                              bool isSelected = index == selectedIndex;
                                              final imageUrl =
                                              productProvider.smartPhoneList[0].images[index];
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
                      Consumer<ProductProvider>(
                        builder: (context,productProvider,child) {
                          return Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              spacing: 15,
                              children: [
                                if(productProvider.smartPhoneList.isNotEmpty)...[
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
                                    Text("₹ ${ListFormatter.formatList(productProvider.smartPhoneList[0].price)}")
                                  ],
                                ]else...[],
                                if(productProvider.smartPhoneList.isNotEmpty)...[
                                  if(isEditable)...[
                                    TextField(
                                      controller: _titleController,
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
                                    Text(ListFormatter.formatList(productProvider.smartPhoneList[0].adTitle))
                                  ]
                                ]else...[],
                                if(productProvider.smartPhoneList.isNotEmpty)...[
                                  if(isEditable)...[
                                    TextField(
                                      controller: _modelController,
                                      textCapitalization: TextCapitalization.sentences,
                                      decoration: InputDecoration(
                                        labelText: 'Model',
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
                                              child: Text("Model")),
                                          Container(
                                            padding: EdgeInsets.symmetric(horizontal: 10,vertical: 5),
                                            child: Text(ListFormatter.formatList(productProvider.smartPhoneList[0].model), style: TextStyle(fontSize: 15)),),
                                        ],
                                      ),
                                    ),]
                                ]else...[],
                                if(productProvider.smartPhoneList.isNotEmpty)...[
                                  if(isEditable)...[
                                    DropdownButtonFormField<String>(
                                      value: (productProvider.smartPhoneList[0].brand.last.isNotEmpty)
                                          ? productProvider.smartPhoneList[0].brand.last.toString()
                                          : null,
                                      items: smartphoneBrands.map((val) {
                                        return DropdownMenuItem<String>(
                                          value: val,
                                          child: Text(val),
                                        );
                                      }).toList(),
                                      onChanged: (val) {
                                        selectedBrand = val!;
                                      },
                                      decoration: InputDecoration(
                                        labelText: 'Brand',
                                        border: border,
                                        enabledBorder: border,
                                        focusedBorder: border,
                                      ),
                                    ),
                                  ]else...[Container(
                                    width: double.infinity,
                                    decoration: BoxDecoration(
                                        color: Colors.white
                                    ),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Container(
                                            padding: EdgeInsets.symmetric(horizontal: 10,vertical: 5),
                                            child: Text("Brand")),
                                        Container(
                                          padding: EdgeInsets.symmetric(horizontal: 10,vertical: 5),
                                          child: Text(ListFormatter.formatList(productProvider.smartPhoneList[0].brand), style: TextStyle(fontSize: 15)),),
                                      ],
                                    ),
                                  ),]
                                ]else...[],
                                if(productProvider.smartPhoneList.isNotEmpty)...[
                                  if(isEditable)...[
                                    DropdownButtonFormField<String>(
                                      value: productProvider.smartPhoneList[0].storage.isNotEmpty
                                          ? productProvider.smartPhoneList[0].storage.last.toString()
                                          : null,
                                      items: storageOptions.map((val) {
                                        return DropdownMenuItem<String>(
                                          value: val,
                                          child: Text(val),
                                        );
                                      }).toList(),
                                      onChanged: (val) {
                                        selectedStorage = val!;
                                      },
                                      decoration: InputDecoration(
                                        labelText: 'Storage',
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
                                              child: Text("Storage")),
                                          Container(
                                            padding: EdgeInsets.symmetric(horizontal: 10,vertical: 5),
                                            child: Text(ListFormatter.formatList(productProvider.smartPhoneList[0].storage), style: TextStyle(fontSize: 15)),),
                                        ],
                                      ),
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
                  if(productProvider.smartPhoneList.isNotEmpty)...[
                    if(isEditable)...[
                      TextField(
                        controller: _addressController,
                        textCapitalization: TextCapitalization.sentences,
                        maxLines: null,
                        decoration: InputDecoration(
                          labelText: 'Location',
                          suffixIcon: Icon(Icons.edit),
                          border: border,
                          enabledBorder: border,
                          focusedBorder: border,
                        ),
                      ),
                    ]else...[
                      Container(
                          padding: EdgeInsets.symmetric(vertical: 10),
                          decoration: BoxDecoration(
                              color: Colors.white
                          ),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Icon(Icons.location_on_outlined,size: 17,),
                              const SizedBox(width: 5),
                              if (productProvider.smartPhoneList.isNotEmpty)
                                ...[
                                  // Text(ListFormatter.formatList(productProvider.smartPhoneList[0].address1),
                                  //   style: TextStyle(fontSize: 12),
                                  // )
                                ]
                              else
                                ...[],

                            ],
                          )),
                    ]
                  ]else...[],
                  if(productProvider.smartPhoneList.isNotEmpty)...[
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
                      Container(
                          width: double.infinity,
                          padding: EdgeInsets.symmetric(horizontal: 10,vertical: 5),
                          decoration: BoxDecoration(
                              color: Colors.white
                          ),
                          child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("Description: "),
                                Text(ListFormatter.formatList(productProvider.smartPhoneList[0].description))
                              ]
                          )),
                    ]
                  ]else...[],
                  SizedBox(height: 20),
                 showAppBarActions? Container(
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
                            "productId": productProvider.smartPhoneList[0].id,
                            "userId": userId,
                            "storage": selectedStorage.toString().trim(),
                            "brand": selectedBrand.toString().trim(),
                            "model": _modelController.text.trim(),
                            "price": _priceController.text.trim(),
                            "adTitle": _titleController.text.trim(),
                            "description": _descriptionController.text.trim(),
                            "productType": productProvider.smartPhoneList[0].productType,
                            "subProductType": productProvider.smartPhoneList[0].subProductType,
                            "categories": productProvider.smartPhoneList[0].category,
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
                  ) : SizedBox.shrink(),
                ],
              ),
            ),
          ) : LoadingWidget(),
          productProvider.isLoading ? LoadingWidget() : Container(),
        ],
      ),
    );
  }
}
