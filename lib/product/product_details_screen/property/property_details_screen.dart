import 'package:admin_panel/local_Storage/admin_shredPreferences.dart';
import 'package:admin_panel/utils/list_formatter.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../../network_connection/apis.dart';
import '../../../provider/product_provider/product_provider.dart';
import '../../../widgets/loading_widget.dart';

class PropertyDetailsScreen extends StatefulWidget {
  static const routeName = "/property-details-screen";
  const PropertyDetailsScreen({super.key});

  @override
  State<PropertyDetailsScreen> createState() => _PropertyDetailsScreenState();
}

class _PropertyDetailsScreenState extends State<PropertyDetailsScreen> {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController lengthController = TextEditingController();
  final TextEditingController breadthController = TextEditingController();
  final TextEditingController totalFloresController = TextEditingController();
  final TextEditingController areaController = TextEditingController();
  final TextEditingController projectNameController = TextEditingController();
  final TextEditingController additionalInformationController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  String? selectedBHK;
  String? selectedType;
  String? selectedPropertyType;
  String? selectedFurnishing;
  String? selectedProjectStatus;
  String? selectedListedBy;
  String? selectedYear;
  String? selectedFacing;
  final List<String> facing = ['East', 'North', 'North-east', 'North-west','South','South-east', 'South-west', 'West'];
  List<String> rentOrSell = ["For Rent", "For Sell"];
  List<String> furniture = ["Fully Furnished", "Semi Furnished", "Unfurnished",];
  List<String> listedBy = ["Owner", "Builder", "Dealer",];
  List<String> projectStatus = ["New Launch", "Ready to Move", "Under Construction",];
  List<String> bhkOption = ["1", "2", "3","4","4+"];
  bool isEditable = false;
  int selectedIndex = 0;
  String productId = "";
  String modelName = "";
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
  void setData()async{
    ProductProvider productProvider = Provider.of<ProductProvider>(context, listen: false);
    setState(() {
      selectedBHK = productProvider.propertyList[0].bhk.last.toString();
      selectedFurnishing = productProvider.propertyList[0].furnishing.last.toString();
      selectedListedBy = productProvider.propertyList[0].listedBy.last.toString();
      selectedProjectStatus = productProvider.propertyList[0].projectStatus.last.toString();
      selectedFacing = productProvider.propertyList[0].facing.last.toString();
      selectedType = productProvider.propertyList[0].type;
      selectedPropertyType = productProvider.propertyList[0].productType;
      titleController.text = productProvider.propertyList[0].adTitle.last.toString();
      areaController.text = productProvider.propertyList[0].area.last.toString();
      projectNameController.text = productProvider.propertyList[0].projectName.last.toString();
      additionalInformationController.text = productProvider.propertyList[0].description.last.toString();
     // addressController.text = productProvider.propertyList[0].address1.last.toString();
    });
  }
  @override
  Widget build(BuildContext context) {
    ProductProvider productProvider = Provider.of<ProductProvider>(context, listen: true);
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(

        elevation: 0,
        shadowColor: Colors.transparent,
        title: Text(
          'Property Details',
        ),
        actions:showAppBarActions? [
          IconButton(
            icon: Icon(Icons.edit, color: Colors.black),
            onPressed: () async{
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
                    TextButton(onPressed: () async {
                      await productProvider.deleteProduct(
                        productProvider.propertyList[0].id,
                        productProvider.propertyList[0].productType,
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
              productProvider.propertyList.isNotEmpty ?
              productProvider.propertyList[0].isActive
                  ? Icons.visibility
                  : Icons.visibility_off : Icons.error,
              color: Colors.black,
            ),
            onPressed: () async {
              if (productProvider.propertyList.isNotEmpty) {
                Map<String, dynamic> body = {
                  "productId": productProvider.propertyList[0].id,
                  "productType" : productProvider.propertyList[0].productType,
                };

                await productProvider.product_active_inactive(body);
              }
            },
          ),
        ]:[],
      ),
      body: Stack(
        children: [
          productProvider.propertyList.isNotEmpty ?
          SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                spacing: 15,
                children: [
                  Container(
                    alignment: Alignment.centerRight,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        if (productProvider.propertyList.isNotEmpty)
                          Column(
                            spacing: 6,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                productProvider.propertyList.isNotEmpty &&
                                    productProvider.propertyList[0].timestamps.isNotEmpty
                                    ? DateFormat('d MMMM yyyy, hh:mm:ss a').format(
                                  DateTime.parse(productProvider.propertyList[0].timestamps).toLocal(), // Convert to local time
                                )
                                    : 'N/A',
                                style: TextStyle(fontSize: 11, color: Colors.black),
                              ),

                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text("Add Product User Name:--"),
                                  Text(productProvider.propertyList[0].user.fName.last.toString()),
                                  const SizedBox(width: 5),
                                  Text(productProvider.propertyList[0].user.lName.last.toString()),
                                ],
                              ),
                              Text("Product Category:--${productProvider.propertyList[0].category}"),
                              Text("User product deleted:--${productProvider.propertyList[0].isDeleted}"),
                            ],
                          ),
                      ],
                    ),
                  ),
                  Row(
                    children: [
                      Column(
                        children: [
                          Consumer<ProductProvider>(
                              builder: (context,productProvider,child) {
                                return Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                    children: [
                                      if (productProvider.propertyList.isNotEmpty) ...[
                                       Stack(
                                         children: [
                                           Container(
                                             padding: EdgeInsets.symmetric(horizontal: 20),
                                             height: 400,
                                             width: 400,
                                             decoration: BoxDecoration(
                                               borderRadius: BorderRadius.vertical(top: Radius.circular(8)),
                                             ),
                                             child: productProvider.propertyList.isNotEmpty &&
                                                 productProvider.propertyList[0].images.isNotEmpty &&
                                                 selectedIndex < productProvider.propertyList[0].images.length &&
                                                 productProvider.propertyList[0].images[selectedIndex].isNotEmpty
                                                 ? Image.network(
                                               '$baseUrl${productProvider.propertyList[0].images[selectedIndex]}',
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
                                           //                     "imagePath": productProvider.propertyList[0].images[selectedIndex],
                                           //                     "modelName": productProvider.propertyList[0].modelName
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
                                      if (productProvider.propertyList.isNotEmpty) ...[
                                        SizedBox(
                                          height: 50,
                                          child: ListView.builder(
                                            scrollDirection: Axis.horizontal,
                                            itemCount:
                                            productProvider.propertyList[0].images.length,
                                            shrinkWrap: true,
                                            itemBuilder: (context, index) {
                                              bool isSelected = index == selectedIndex;
                                              final imageUrl =
                                              productProvider.propertyList[0].images[index];
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
                              spacing: 15,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                if(productProvider.propertyList.isNotEmpty)...[
                                  if(isEditable)...[
                                    //title
                                    TextField(
                                      controller: titleController,
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
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text("Title:"),
                                        Text(
                                            ListFormatter.formatList(productProvider.propertyList[0].adTitle),
                                            style: TextStyle(fontSize: 15)),
                                      ],
                                    )
                                  ]
                                ]else...[],
                                if(productProvider.propertyList.isNotEmpty)...[
                                  if(isEditable)...[
                                    DropdownButtonFormField<String>(
                                      value: selectedBHK,
                                      decoration: InputDecoration(
                                        labelText: 'Select BHK',
                                        labelStyle: TextStyle(color: Colors.black),
                                        border: border,
                                        enabledBorder: border,
                                        focusedBorder: border,
                                      ),
                                      iconEnabledColor: Colors.black, // down arrow color
                                      dropdownColor: Colors.white,
                                      items: bhkOption.map((year) {
                                        return DropdownMenuItem<String>(
                                          value: year,
                                          child: Text(year),
                                        );
                                      }).toList(),
                                      onChanged: (value) {
                                        setState(() {
                                          selectedBHK = value!;
                                        });
                                      },
                                      // validator: (value){
                                      //   if (value == null || value.isEmpty) {
                                      //     return 'Please select a type';
                                      //   }
                                      //   return null;
                                      // },
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
                                              child: Text("BHK")),
                                          Container(
                                            padding: EdgeInsets.symmetric(horizontal: 10,vertical: 5),
                                            child: Text(ListFormatter.formatList(productProvider.propertyList[0].bhk), style: TextStyle(fontSize: 15)),),
                                        ],
                                      ),
                                    ),
                                  ]
                                ]else...[],
                                if(productProvider.propertyList.isNotEmpty)...[
                                  if(isEditable)...[
                                    DropdownButtonFormField<String>(
                                      value: selectedFurnishing,
                                      decoration: InputDecoration(
                                        labelText: 'Select Furnishing',
                                        labelStyle: TextStyle(color: Colors.black),
                                        border: border,
                                        enabledBorder: border,
                                        focusedBorder: border,
                                      ),
                                      iconEnabledColor: Colors.black, // down arrow color
                                      dropdownColor: Colors.white,
                                      items: furniture.map((year) {
                                        return DropdownMenuItem<String>(
                                          value: year,
                                          child: Text(year),
                                        );
                                      }).toList(),
                                      onChanged: (value) {
                                        setState(() {
                                          selectedFurnishing = value!;
                                        });
                                      },
                                      validator: (value){
                                        if (value == null || value.isEmpty) {
                                          return 'Please select a furnishing type';
                                        }
                                        return null;
                                      },
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
                                              child: Text("Furnished")),
                                          Container(
                                            padding: EdgeInsets.symmetric(horizontal: 10,vertical: 5),
                                            child: Text(ListFormatter.formatList(productProvider.propertyList[0].furnishing), style: TextStyle(fontSize: 15)),),
                                        ],
                                      ),
                                    ),
                                  ]
                                ]else...[],
                                if(productProvider.propertyList.isNotEmpty)...[
                                  if(isEditable)...[
                                    DropdownButtonFormField<String>(
                                      value: selectedListedBy,
                                      decoration: InputDecoration(
                                        labelText: 'Listed By',
                                        labelStyle: TextStyle(color: Colors.black),
                                        border: border,
                                        enabledBorder: border,
                                        focusedBorder: border,
                                      ),
                                      iconEnabledColor: Colors.black, // down arrow color
                                      dropdownColor: Colors.white,
                                      items: listedBy.map((year) {
                                        return DropdownMenuItem<String>(
                                          value: year,
                                          child: Text(year),
                                        );
                                      }).toList(),
                                      onChanged: (value) {
                                        setState(() {
                                          selectedListedBy = value!;
                                        });
                                      },
                                      validator: (value){
                                        if (value == null || value.isEmpty) {
                                          return 'Please select a listed by';
                                        }
                                        return null;
                                      },
                                    ),
                                  ] else...[
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
                                              child: Text("Listed By")),
                                          Container(
                                            padding: EdgeInsets.symmetric(horizontal: 10,vertical: 5),
                                            child: Text(ListFormatter.formatList(productProvider.propertyList[0].listedBy), style: TextStyle(fontSize: 15)),),
                                        ],
                                      ),
                                    ),
                                  ]
                                ]else...[],
                                if(productProvider.propertyList.isNotEmpty)...[
                                  if(isEditable)...[
                                    DropdownButtonFormField<String>(
                                      value: selectedProjectStatus,
                                      decoration: InputDecoration(
                                        labelText: 'Project Status',
                                        labelStyle: TextStyle(color: Colors.black),
                                        border: border,
                                        enabledBorder: border,
                                        focusedBorder: border,
                                      ),
                                      iconEnabledColor: Colors.black, // down arrow color
                                      dropdownColor: Colors.white,
                                      items: projectStatus.map((year) {
                                        return DropdownMenuItem<String>(
                                          value: year,
                                          child: Text(year),
                                        );
                                      }).toList(),
                                      onChanged: (value) {
                                        setState(() {
                                          selectedProjectStatus = value!;
                                        });
                                      },
                                      validator: (value){
                                        if (value == null || value.isEmpty) {
                                          return 'Please select a project status';
                                        }
                                        return null;
                                      },
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
                                              child: Text("Project Status")),
                                          Container(
                                            padding: EdgeInsets.symmetric(horizontal: 10,vertical: 5),
                                            child: Text(ListFormatter.formatList(productProvider.propertyList[0].projectStatus), style: TextStyle(fontSize: 15)),),
                                        ],
                                      ),
                                    ),
                                  ]
                                ]else...[],
                                if(productProvider.propertyList.isNotEmpty)...[if(isEditable)...[
                                  DropdownButtonFormField<String>(
                                    value: selectedFacing,
                                    decoration: InputDecoration(
                                      labelText: 'Facing',
                                      labelStyle: TextStyle(color: Colors.black),
                                      border: border,
                                      enabledBorder: border,
                                      focusedBorder: border,
                                    ),
                                    iconEnabledColor: Colors.black, // down arrow color
                                    dropdownColor: Colors.white,
                                    items: facing.map((year) {
                                      return DropdownMenuItem<String>(
                                        value: year,
                                        child: Text(year),
                                      );
                                    }).toList(),
                                    onChanged: (value) {
                                      setState(() {
                                        selectedFacing = value!;
                                      });
                                    },
                                    validator: (value){
                                      if (value == null || value.isEmpty) {
                                        return 'Please select a facing';
                                      }
                                      return null;
                                    },
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
                                            child: Text("Facing")),
                                        Container(
                                          padding: EdgeInsets.symmetric(horizontal: 10,vertical: 5),
                                          child: Text(ListFormatter.formatList(productProvider.propertyList[0].facing), style: TextStyle(fontSize: 15)),),
                                      ],
                                    ),
                                  ),
                                ]]else...[],
                                if(productProvider.propertyList.isNotEmpty)...[if(isEditable)...[
                                  TextField(
                                    controller: areaController,
                                    textCapitalization: TextCapitalization.sentences,
                                    maxLines: null,
                                    decoration: InputDecoration(
                                      labelText: 'Area',
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
                                            child: Text("Area")),
                                        Container(
                                          padding: EdgeInsets.symmetric(horizontal: 10,vertical: 5),
                                          child: Text(ListFormatter.formatList(productProvider.propertyList[0].area), style: TextStyle(fontSize: 15)),),
                                      ],
                                    ),
                                  ),
                                ]]else...[],
                              ],
                            ),
                          );
                        }
                      )
                    ],
                  ),
                  if(productProvider.propertyList.isNotEmpty)...[
                    if(isEditable)...[
                      TextField(
                        controller: titleController,
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
                      Row(
                          children: [
                            Icon(Icons.location_on_outlined,size: 17,),
                            const SizedBox(width: 5),
                            // Text(
                            //   ListFormatter.formatList(productProvider.propertyList[0].address1),
                            //   style: TextStyle(fontSize: 12),
                            // )
                          ]
                      ),
                    ]
                  ]else...[],
                  if(productProvider.propertyList.isNotEmpty)...[
                    if(isEditable)...[
                      TextField(
                        controller: additionalInformationController,
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
                    ] else...[
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Description: "),
                          Text(
                              ListFormatter.formatList(productProvider.propertyList[0].description),
                              style: TextStyle(fontSize: 15))
                        ],
                      )
                    ]
                  ]else...[],
                 showAppBarActions? Container(
                    color: Colors.grey.shade50,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ElevatedButton(
                        onPressed: () async {
                          String? userId = await AdminSharedPreferences().getUserId();
                          Map<String,dynamic> body = {
                            "userId": userId,
                            "productId": productProvider.propertyList[0].id,
                            "bhk": selectedBHK.toString(),
                            "furnishing": selectedFurnishing.toString(),
                            "listedBy": selectedListedBy.toString(),
                            "area": areaController.text,
                            "projectStatus": selectedProjectStatus.toString(),
                            "facing": selectedFacing.toString(),
                            "adTitle": titleController.text,
                            "description": additionalInformationController.text,
                            "address1": addressController.text,
                            "productType": productProvider.propertyList[0].productType,
                            "subProductType": productProvider.propertyList[0].subProductType,
                            "categories": productProvider.propertyList[0].category,
                            //"productImages":base64Images
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
                  ):SizedBox.shrink(),
                  const SizedBox(height: 20),
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