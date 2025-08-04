
import 'package:admin_panel/local_Storage/admin_shredPreferences.dart';
import 'package:admin_panel/utils/list_formatter.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../../provider/product_provider/product_provider.dart';
import '../../../widgets/loading_widget.dart';

class FurnitureDetailsScreen extends StatefulWidget {
  static const routeName = "/furniture-details-screen";
  const FurnitureDetailsScreen({super.key});

  @override
  State<FurnitureDetailsScreen> createState() => _FurnitureDetailsScreenState();
}

class _FurnitureDetailsScreenState extends State<FurnitureDetailsScreen> {
  final TextEditingController _adTitleController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  bool isEditable = false;
  final List<String> _selectedImages = [];
  int selectedIndex = 0;
  String productId = "";
  String modelName = "";
  String baseUrl = 'https://api.bhavnika.shop';
  final OutlineInputBorder border = OutlineInputBorder(
    borderSide: BorderSide(color: Colors.black,width: 0.5),
    borderRadius: BorderRadius.circular(8),
  );
  @override
  void initState() {
    super.initState();
    productId = Get.arguments['productId'] as String;
    modelName = Get.arguments['modelName'] as String;
    ProductProvider productProvider = Provider.of<ProductProvider>(context, listen: false);
    productProvider.fetchProductDetails(productId, modelName);
  }

  void setData() {
    ProductProvider productProvider = Provider.of<ProductProvider>(context, listen: false);
    _priceController.text = productProvider.furnitureList[0].price.last.toString();
    _adTitleController.text = productProvider.furnitureList[0].adTitle.last.toString();
    _descriptionController.text = productProvider.furnitureList[0].description.last.toString();
    //_addressController.text = productProvider.furnitureList[0].address1.last.toString();
  }


  @override
  Widget build(BuildContext context) {
    ProductProvider productProvider = Provider.of<ProductProvider>(context,listen: true);
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        shadowColor: Colors.transparent,
        title: Text("Furniture Screen", style: TextStyle(color: Colors.black)),
        actions: [
          IconButton(
            icon: Icon(Icons.edit, color: Colors.black),
            onPressed: () async {
              setState(() {
                isEditable = !isEditable;
              });
              if (isEditable) {
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
                builder:
                    (context) => AlertDialog(
                  title: const Text("Delete Product"),
                  content: const Text(
                    "Are you sure you want to delete this product?",
                  ),
                  actions: [
                    TextButton(
                      child: const Text("Cancel"),
                      onPressed: () => Navigator.of(context).pop(false),
                    ),
                    TextButton(
                      onPressed: () async {
                        productProvider.deleteProduct(
                          productProvider.furnitureList[0].id,
                          productProvider.furnitureList[0].productType,
                        );
                        Navigator.of(context).pop(true);
                        setState(() {});
                      },
                      child: const Text("Delete"),
                    ),
                  ],
                ),
              );
            },
          ),
          IconButton(
            icon: Icon(
              productProvider.furnitureList.isNotEmpty ?
              productProvider.furnitureList[0].isActive
                  ? Icons.visibility
                  : Icons.visibility_off : Icons.error,
              color: Colors.black,
            ),
            onPressed: () async {
              if (productProvider.furnitureList.isNotEmpty) {
                Map<String, dynamic> body = {
                  "productId": productProvider.furnitureList[0].id,
                  "productType" : productProvider.furnitureList[0].productType,
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
            padding: const EdgeInsets.all(10.0),
            child: Column(
              spacing: 15,
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                  alignment: Alignment.centerRight,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      if (productProvider.furnitureList.isNotEmpty)
                        Column(
                          spacing: 6,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              productProvider.furnitureList.isNotEmpty &&
                                  productProvider.furnitureList[0].timestamps.isNotEmpty
                                  ? DateFormat('d MMMM yyyy, hh:mm:ss a').format(
                                DateTime.parse(productProvider.furnitureList[0].timestamps).toLocal(), // Convert to local time
                              )
                                  : 'N/A',
                              style: TextStyle(fontSize: 11, color: Colors.black),
                            ),

                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text("Add Product User Name:--"),
                                Text(productProvider.furnitureList[0].user.fName.last.toString()),
                                const SizedBox(width: 5),
                                Text(productProvider.furnitureList[0].user.lName.last.toString()),
                              ],
                            ),
                            Text("Product Category:--${productProvider.furnitureList[0].category}"),
                            Text("User product deleted:--${productProvider.furnitureList[0].isDeleted}"),
                          ],
                        ),
                    ],
                  ),
                ),
                Row(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Consumer<ProductProvider>(
                            builder: (context,productDetailsProvider,child) {
                              return Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  children: [
                                    if (productDetailsProvider.furnitureList.isNotEmpty) ...[
                                      Stack(
                                        children: [
                                          Container(
                                            padding: EdgeInsets.symmetric(horizontal: 20),
                                            height: 200,
                                            width: 400,
                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius.vertical(top: Radius.circular(8)),
                                            ),
                                            child: productDetailsProvider.furnitureList.isNotEmpty &&
                                                productDetailsProvider.furnitureList[0].images.isNotEmpty &&
                                                selectedIndex < productDetailsProvider.furnitureList[0].images.length &&
                                                productDetailsProvider.furnitureList[0].images[selectedIndex].isNotEmpty
                                                ? Image.network(
                                              '$baseUrl${productDetailsProvider.furnitureList[0].images[selectedIndex]}',
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
                                                              "imagePath": productProvider.furnitureList[0].images[selectedIndex],
                                                              "modelName": productProvider.furnitureList[0].modelName
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
                                    if (productProvider.furnitureList.isNotEmpty) ...[
                                      SizedBox(
                                        height: 50,
                                        child: ListView.builder(
                                          scrollDirection: Axis.horizontal,
                                          itemCount:
                                          productProvider.furnitureList[0].images.length,
                                          shrinkWrap: true,
                                          itemBuilder: (context, index) {
                                            bool isSelected = index == selectedIndex;
                                            final imageUrl =
                                            productProvider.furnitureList[0].images[index];
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
                          child: Column(crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            spacing: 15,
                            children: [
                              if(productProvider.furnitureList.isNotEmpty)...[
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
                                  Text('₹ ${ListFormatter.formatList(productProvider.furnitureList[0].price)}'),
                                ]
                              ]else...[],
                              if(productProvider.furnitureList.isNotEmpty)...[
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
                                  Text("Title: ${ListFormatter.formatList(productProvider.furnitureList[0].adTitle)}"),
                                ]
                              ]else...[],
                              if(productProvider.furnitureList.isNotEmpty)...[
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
                                  Text("Description: ${ListFormatter.formatList(productProvider.furnitureList[0].description)}"),
                                ]
                              ]else...[],
                              if(productProvider.furnitureList.isNotEmpty)...[
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
                                    child: Row(
                                      children: [
                                        Icon(
                                          Icons.location_on_outlined,
                                          size: 17,
                                        ),
                                        const SizedBox(width: 5),
                                        // Text(
                                        //   ListFormatter.formatList(
                                        //     productProvider
                                        //         .furnitureList[0]
                                        //         .address1,
                                        //   ),
                                        //   style: TextStyle(fontSize: 12),
                                        // ),
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
                Container(
                  color: Colors.grey.shade50,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ElevatedButton(
                      onPressed: () async {
                        String userId = await AdminSharedPreferences().getUserId();
                       /* SharedPreferences prefs = await SharedPreferences.getInstance();
                        String? userId = prefs.getString('userId');
                        List<String> filteredImagePaths = _selectedImages
                            .where((image) => !image.startsWith('http'))
                            .toList();
                        List<String> base64Images = [];
                        for (String imagePath in filteredImagePaths) {
                          String base64Image = await ImageHelper.imageToBase64(imagePath);
                          base64Images.add(base64Image);
                        }*/
                        Map<String,dynamic> body = {
                          "userId": userId,
                          "productId": productProvider.furnitureList[0].id,
                          "modelName": modelName,
                          "adTitle": _adTitleController.text,
                          "price": _priceController.text,
                          "description": _descriptionController.text,
                          "address1": _addressController.text,
                          "productType": productProvider.furnitureList[0].productType,
                          "subProductType": productProvider.furnitureList[0].subProductType,
                          "categories": productProvider.furnitureList[0].category,
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
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
          productProvider.isLoading ? LoadingWidget() : Container()
        ],
      ),
    );
  }
}
