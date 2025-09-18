import 'package:admin_panel/local_Storage/admin_shredPreferences.dart';
import 'package:admin_panel/utils/list_formatter.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../../network_connection/apis.dart';
import '../../../provider/product_provider/product_provider.dart';
import '../../../widgets/loading_widget.dart';

class OtherProductDetails extends StatefulWidget {
  static const routeName = "/other-details-screen";

  const OtherProductDetails({super.key});

  @override
  State<OtherProductDetails> createState() => _OtherProductDetailsState();
}

class _OtherProductDetailsState extends State<OtherProductDetails> {
  final TextEditingController _addSubProductTypeController =
      TextEditingController();
  final TextEditingController _adTitleController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  bool isEditable = false;
  String baseUrl = Apis.BASE_URL_IMAGE;
  int selectedIndex = 0;
  String productId = "";
  String modelName = "";
  final OutlineInputBorder border = OutlineInputBorder(
    borderSide: BorderSide(color: Colors.black, width: 0.5),
    borderRadius: BorderRadius.circular(8),
  );
  bool showAppBarActions = true;

  @override
  void initState() {
    super.initState();
    productId = Get.arguments['productId'] as String;
    modelName = Get.arguments['modelName'] as String;
    showAppBarActions = Get.arguments['isEdit'] as bool? ?? true;
    ProductProvider productProvider = Provider.of<ProductProvider>(
      context,
      listen: false,
    );
    productProvider.fetchProductDetails(productId, modelName);
  }

  void setData() {
    ProductProvider productProvider = Provider.of<ProductProvider>(
      context,
      listen: false,
    );
    if (productProvider.otherList.isNotEmpty) {
      setState(() {
        _adTitleController.text = productProvider.otherList[0].adTitle.last
            .toString();
        _priceController.text = productProvider.otherList[0].price.last
            .toString();
        _descriptionController.text = productProvider
            .otherList[0]
            .description
            .last
            .toString();
        // _addressController.text = productProvider.otherList[0].address1.last.toString();
        _addSubProductTypeController.text =
            productProvider.otherList[0].subProductType;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    ProductProvider productProvider = Provider.of<ProductProvider>(
      context,
      listen: true,
    );
    if (productProvider.otherList.isNotEmpty) {
        _adTitleController.text = productProvider.otherList[0].adTitle.last
            .toString();
        _priceController.text = productProvider.otherList[0].price.last
            .toString();
        _descriptionController.text = productProvider
            .otherList[0]
            .description
            .last
            .toString();
        // _addressController.text = productProvider.otherList[0].address1.last.toString();
        _addSubProductTypeController.text =
            productProvider.otherList[0].subProductType;
    }
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        shadowColor: Colors.transparent,
        title: Text('Others Details'),
        actions: showAppBarActions
            ? [
                IconButton(
                  icon: Icon(Icons.edit, color: Colors.black),
                  onPressed: () async {
                    setState(() {
                      isEditable = !isEditable;
                    });
                    if (isEditable) {
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
                              await productProvider.deleteProduct(
                                productProvider.otherList[0].id,
                                productProvider.otherList[0].productType,
                              );
                              Navigator.of(context).pop(true);
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
                    productProvider.otherList.isNotEmpty
                        ? productProvider.otherList[0].isActive
                              ? Icons.visibility
                              : Icons.visibility_off
                        : Icons.error,
                    color: Colors.black,
                  ),
                  onPressed: () async {
                    if (productProvider.otherList.isNotEmpty) {
                      Map<String, dynamic> body = {
                        "productId": productProvider.otherList[0].id,
                        "productType": productProvider.otherList[0].productType,
                      };

                      await productProvider.product_active_inactive(body);
                    }
                  },
                ),
              ]
            : [],
      ),
      body: Stack(
        children: [
          productProvider.otherList.isNotEmpty
              ? Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    spacing: 15,
                    children: [
                      Container(
                        alignment: Alignment.centerRight,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            if (productProvider.otherList.isNotEmpty)
                              Column(
                                spacing: 6,
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Text(
                                    productProvider.otherList.isNotEmpty &&
                                            productProvider
                                                .otherList[0]
                                                .timestamps
                                                .isNotEmpty
                                        ? DateFormat(
                                            'd MMMM yyyy, hh:mm:ss a',
                                          ).format(
                                            DateTime.parse(
                                              productProvider
                                                  .otherList[0]
                                                  .timestamps,
                                            ).toLocal(), // Convert to local time
                                          )
                                        : 'N/A',
                                    style: TextStyle(
                                      fontSize: 11,
                                      color: Colors.black,
                                    ),
                                  ),

                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text("Add Product User Name:--"),
                                      Text(
                                        productProvider
                                            .otherList[0]
                                            .user
                                            .fName
                                            .last
                                            .toString(),
                                      ),
                                      const SizedBox(width: 5),
                                      Text(
                                        productProvider
                                            .otherList[0]
                                            .user
                                            .lName
                                            .last
                                            .toString(),
                                      ),
                                    ],
                                  ),
                                  Text(
                                    "Product Category:--${productProvider.otherList[0].category}",
                                  ),
                                  Text(
                                    "User product deleted:--${productProvider.otherList[0].isDeleted}",
                                  ),
                                ],
                              ),
                          ],
                        ),
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            spacing: 15,
                            children: [
                              Consumer<ProductProvider>(
                                builder: (context, productProvider, child) {
                                  return Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Column(
                                      children: [
                                        if (productProvider
                                            .otherList
                                            .isNotEmpty) ...[
                                          Stack(
                                            children: [
                                              Container(
                                                height: 400,
                                                width: 400,
                                                decoration: BoxDecoration(
                                                  // border: Border.all(),
                                                  borderRadius:
                                                      BorderRadius.vertical(
                                                        top: Radius.circular(8),
                                                      ),
                                                ),
                                                child:
                                                    productProvider
                                                        .otherList[0]
                                                        .images[selectedIndex]
                                                        .isNotEmpty
                                                    ? CachedNetworkImage(
                                                        imageUrl:
                                                            '$baseUrl${productProvider.otherList[0].images[selectedIndex]}',
                                                        fit: BoxFit.contain,
                                                        width: double.infinity,
                                                        errorWidget:
                                                            (
                                                              context,
                                                              error,
                                                              stackTrace,
                                                            ) => Icon(
                                                              Icons
                                                                  .broken_image,
                                                              size: 90,
                                                            ),
                                                      )
                                                    : Icon(
                                                        Icons.image,
                                                        size: 90,
                                                      ),
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
                                              //                     "imagePath": productProvider.otherList[0].images[selectedIndex],
                                              //                     "modelName": productProvider.otherList[0].modelName
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
                                          ),
                                        ] else
                                          ...[],
                                        const SizedBox(height: 10),
                                        if (productProvider
                                            .otherList
                                            .isNotEmpty) ...[
                                          SizedBox(
                                            height: 50,
                                            child: ListView.builder(
                                              scrollDirection: Axis.horizontal,
                                              itemCount: productProvider
                                                  .otherList[0]
                                                  .images
                                                  .length,
                                              shrinkWrap: true,
                                              itemBuilder: (context, index) {
                                                bool isSelected =
                                                    index == selectedIndex;
                                                final imageUrl = productProvider
                                                    .otherList[0]
                                                    .images[index];
                                                return GestureDetector(
                                                  onTap: () {
                                                    setState(() {
                                                      selectedIndex = index;
                                                    });
                                                  },
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.symmetric(
                                                          horizontal: 10,
                                                          vertical: 5,
                                                        ),
                                                    child: Container(
                                                      width: 60,
                                                      decoration: BoxDecoration(
                                                        border: isSelected
                                                            ? Border.all(
                                                                color:
                                                                    Colors.blue,
                                                                width: 2,
                                                              )
                                                            : null,
                                                        borderRadius:
                                                            BorderRadius.circular(
                                                              8,
                                                            ),
                                                      ),
                                                      child:
                                                          imageUrl != null &&
                                                              imageUrl
                                                                  .isNotEmpty
                                                          ? CachedNetworkImage(
                                                              imageUrl:
                                                                  '$baseUrl$imageUrl',
                                                              fit: BoxFit.fill,
                                                              errorWidget:
                                                                  (
                                                                    context,
                                                                    error,
                                                                    stackTrace,
                                                                  ) => Icon(
                                                                    Icons
                                                                        .broken_image,
                                                                    size: 40,
                                                                  ),
                                                            )
                                                          : Icon(
                                                              Icons.image,
                                                              size: 40,
                                                            ),
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
                                },
                              ),
                            ],
                          ),
                          Consumer<ProductProvider>(
                            builder: (context, productProvider, child) {
                              return Expanded(
                                child: Column(
                                  spacing: 15,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    if (productProvider
                                        .otherList
                                        .isNotEmpty) ...[
                                      TextField(
                                        controller: TextEditingController(
                                          text: productProvider
                                              .otherList[0]
                                              .subProductName,
                                        ),
                                        enabled: false,
                                        decoration: InputDecoration(
                                          labelText: 'Product Type',

                                          border: border,
                                          enabledBorder: border,
                                          focusedBorder: border,
                                        ),
                                      ),
                                    ] else
                                      ...[],
                                    if (productProvider
                                        .otherList
                                        .isNotEmpty) ...[
                                      TextField(
                                        controller: _priceController,
                                        enabled: false,
                                        decoration: InputDecoration(
                                          labelText: 'Price',

                                          border: border,
                                          enabledBorder: border,
                                          focusedBorder: border,
                                        ),
                                      ),
                                    ] else
                                      ...[],
                                    if (productProvider
                                        .otherList
                                        .isNotEmpty) ...[
                                      TextField(
                                        controller: _adTitleController,
                                        textCapitalization:
                                            TextCapitalization.sentences,
                                        enabled: isEditable,
                                        maxLines: null,
                                        decoration: InputDecoration(
                                          labelText: 'Title',

                                          border: border,
                                          enabledBorder: border,
                                          focusedBorder: border,
                                        ),
                                      ),
                                    ] else
                                      ...[],
                                    if (productProvider
                                        .otherList
                                        .isNotEmpty) ...[
                                      TextField(
                                        controller: _addressController,
                                        textCapitalization:
                                            TextCapitalization.sentences,
                                        enabled: false,
                                        maxLines: null,
                                        decoration: InputDecoration(
                                          labelText: 'Address',

                                          border: border,
                                          enabledBorder: border,
                                          focusedBorder: border,
                                        ),
                                      ),
                                    ] else
                                      ...[],
                                    if (productProvider
                                        .otherList
                                        .isNotEmpty) ...[
                                      TextField(
                                        controller: _descriptionController,
                                        enabled: isEditable,
                                        textCapitalization:
                                            TextCapitalization.sentences,
                                        maxLines: null,
                                        decoration: InputDecoration(
                                          labelText: 'Additional Information',

                                          border: border,
                                          enabledBorder: border,
                                          focusedBorder: border,
                                        ),
                                      ),
                                    ] else
                                      ...[],
                                  ],
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                      showAppBarActions && isEditable
                          ? Container(
                              color: Colors.grey.shade50,
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: ElevatedButton(
                                  onPressed: () async {
                                    String? userId =
                                        await AdminSharedPreferences()
                                            .getUserId();
                                    // List<String> filteredImagePaths = _selectedImages
                                    //     .where((image) => !image.startsWith('http'))
                                    //     .toList();
                                    // List<String> base64Images = [];
                                    // for (String imagePath in filteredImagePaths) {
                                    //   String base64Image = await ImageHelper.imageToBase64(imagePath);
                                    //   base64Images.add(base64Image);
                                    // }
                                    Map<String, dynamic> body = {
                                      "userId": userId,
                                      "productId":
                                          productProvider.otherList[0].id,
                                      "adTitle": _adTitleController.text,
                                      "price": _priceController.text,
                                      "description":
                                          _descriptionController.text,
                                      "address1": _addressController.text,
                                      "productType": productProvider
                                          .otherList[0]
                                          .productType,
                                      "subProductType": productProvider
                                          .otherList[0]
                                          .subProductType,
                                      "categories":
                                          productProvider.otherList[0].category,
                                      // "productImages":base64Images
                                    };
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
                            )
                          : SizedBox.shrink(),
                      const SizedBox(height: 20),
                    ],
                  ),
                )
              : LoadingWidget(),
          productProvider.isLoading ? LoadingWidget() : Container(),
        ],
      ),
    );
  }
}
