import 'package:admin_panel/local_Storage/admin_shredPreferences.dart';
import 'package:admin_panel/utils/list_formatter.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../../network_connection/apis.dart';
import '../../../provider/product_provider/product_provider.dart';
import '../../../utils/address_extractor.dart';
import '../../../widgets/loading_widget.dart';

class BookSportsHobbyDetailsScreen extends StatefulWidget {
  static const routeName = "/book-sports-hobby-details-screen";

  const BookSportsHobbyDetailsScreen({super.key});

  @override
  State<BookSportsHobbyDetailsScreen> createState() =>
      _BookSportsHobbyDetailsScreenState();
}

class _BookSportsHobbyDetailsScreenState
    extends State<BookSportsHobbyDetailsScreen> {
  final TextEditingController _adTitleController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool isEditable = false;
  int selectedIndex = 0;
  String productId = "";
  String modelName = "";
  String baseUrl = Apis.BASE_URL_IMAGE;
  bool showAppBarActions = true;
  final OutlineInputBorder border = OutlineInputBorder(
    borderSide: BorderSide(color: Colors.black, width: 0.5),
    borderRadius: BorderRadius.circular(8),
  );

  @override
  void initState() {
    super.initState();
    productId = Get.arguments['productId'] as String;
    modelName = Get.arguments['modelName'] as String;
    showAppBarActions = Get.arguments['isEdit'] as bool? ?? true;
    Future.microtask(() async {
      ProductProvider productDetailsProvider = Provider.of<ProductProvider>(
        context,
        listen: false,
      );
      await productDetailsProvider.fetchProductDetails(productId, modelName);
      setData();
    });
  }

  void setData(){
    ProductProvider productProvider = Provider.of<ProductProvider>(
      context,
      listen: false,
    );
    String oldAddress = AddressExtractor.extractAddress(
      street1: productProvider.bookList[0].street1,
      street2: productProvider.bookList[0].street2,

      area: productProvider.bookList[0].area,

      city: productProvider.bookList[0].city,

      state: productProvider.bookList[0].state,

      country: productProvider.bookList[0].country,

      pincode: productProvider.bookList[0].pincode,
    ).$1;
    String newAddress = AddressExtractor.extractAddress(
      street1: productProvider.bookList[0].street1,
      street2: productProvider.bookList[0].street2,

      area: productProvider.bookList[0].area,

      city: productProvider.bookList[0].city,

      state: productProvider.bookList[0].state,

      country: productProvider.bookList[0].country,

      pincode: productProvider.bookList[0].pincode,
    ).$2;
    String address = "";
    if (oldAddress.isNotEmpty) {
      address = oldAddress;
    }
    if (newAddress.isNotEmpty) {
      address = newAddress;
    }
    if(productProvider.bookList.isNotEmpty) {
      setState(() {
        _priceController.text = productProvider.bookList[0].price.last.toString();
        _adTitleController.text = productProvider.bookList[0].adTitle.last
            .toString();
        _descriptionController.text = productProvider.bookList[0].description.last
            .toString();
        _addressController.text = address;
      });

    }
  }
  @override
  Widget build(BuildContext context) {
    ProductProvider productProvider = Provider.of<ProductProvider>(
      context,
      listen: true,
    );
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        shadowColor: Colors.transparent,
        title: Text(
          "Book, Sports & Hobbies"
          "",
        ),
        actions: showAppBarActions
            ? [
                IconButton(
                  icon: Icon(Icons.edit, color: Colors.black),
                  onPressed: () async {
                    setData();
                    setState(() {
                      isEditable = !isEditable;
                    });
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
                                productProvider.bookList[0].id,
                                productProvider.bookList[0].productType,
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
                    productProvider.bookList.isNotEmpty
                        ? productProvider.bookList[0].isActive
                              ? Icons.visibility
                              : Icons.visibility_off
                        : Icons.error,
                    color: Colors.black,
                  ),
                  onPressed: () async {
                    if (productProvider.bookList.isNotEmpty) {
                      Map<String, dynamic> body = {
                        "productId": productProvider.bookList[0].id,
                        "productType": productProvider.bookList[0].productType,
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
          productProvider.bookList.isNotEmpty
              ? Padding(
                  padding: const EdgeInsets.all(10),
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
                              if (productProvider.bookList.isNotEmpty)
                                Column(
                                  spacing: 6,
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Text(
                                      productProvider.bookList.isNotEmpty &&
                                              productProvider
                                                  .bookList[0]
                                                  .timestamps
                                                  .isNotEmpty
                                          ? DateFormat(
                                              'd MMMM yyyy, hh:mm:ss a',
                                            ).format(
                                              DateTime.parse(
                                                productProvider
                                                    .bookList[0]
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
                                              .bookList[0]
                                              .user
                                              .fName
                                              .last
                                              .toString(),
                                        ),
                                        const SizedBox(width: 5),
                                        Text(
                                          productProvider
                                              .bookList[0]
                                              .user
                                              .lName
                                              .last
                                              .toString(),
                                        ),
                                      ],
                                    ),
                                    Text(
                                      "Product Category:--${productProvider.bookList[0].category}",
                                    ),
                                    Text(
                                      "User product deleted:--${productProvider.bookList[0].isDeleted}",
                                    ),
                                  ],
                                ),
                            ],
                          ),
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
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
                                              .bookList
                                              .isNotEmpty) ...[
                                            Stack(
                                              children: [
                                                Container(
                                                  padding: EdgeInsets.symmetric(
                                                    horizontal: 20,
                                                  ),
                                                  height: 400,
                                                  width: 400,
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.vertical(
                                                          top: Radius.circular(
                                                            8,
                                                          ),
                                                        ),
                                                  ),
                                                  child:
                                                      productProvider
                                                              .bookList
                                                              .isNotEmpty &&
                                                          productProvider
                                                              .bookList[0]
                                                              .images
                                                              .isNotEmpty &&
                                                          selectedIndex <
                                                              productProvider
                                                                  .bookList[0]
                                                                  .images
                                                                  .length &&
                                                          productProvider
                                                              .bookList[0]
                                                              .images[selectedIndex]
                                                              .isNotEmpty
                                                      ? CachedNetworkImage(
                                                          imageUrl:
                                                              '$baseUrl${productProvider.bookList[0].images[selectedIndex]}',
                                                          fit: BoxFit.fill,
                                                          width:
                                                              double.infinity,
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
                                                //                     "imagePath": productProvider.bookList[0].images[selectedIndex],
                                                //                     "modelName": productProvider.bookList[0].modelName
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
                                                //     child: const Icon(Icons.delete,
                                                //         size: 18, color: Colors.red),
                                                //   ),
                                                // ),
                                              ],
                                            ),
                                          ] else
                                            ...[],
                                          const SizedBox(height: 10),
                                          if (productProvider
                                              .bookList
                                              .isNotEmpty) ...[
                                            SizedBox(
                                              height: 50,
                                              child: ListView.builder(
                                                scrollDirection:
                                                    Axis.horizontal,
                                                itemCount: productProvider
                                                    .bookList[0]
                                                    .images
                                                    .length,
                                                shrinkWrap: true,
                                                itemBuilder: (context, index) {
                                                  bool isSelected =
                                                      index == selectedIndex;
                                                  final imageUrl =
                                                      productProvider
                                                          .bookList[0]
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
                                                                  color: Colors
                                                                      .blue,
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
                                                                fit:
                                                                    BoxFit.fill,
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
                                return SizedBox(
                                  width: 500,
                                  child: Card(
                                    color: Colors.white,
                                    elevation: 5,
                                    shadowColor: Colors.grey.shade300,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8),
                                    ),

                                    child: Padding(
                                      padding: const EdgeInsets.all(24.0),
                                      child: Form(
                                        key: _formKey,
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          spacing: 15,
                                          children: [
                                            TextFormField(
                                              controller: _priceController,
                                              enabled: false,
                                              decoration: InputDecoration(
                                                labelText: 'Price',
                                                prefixIcon: Icon(
                                                  Icons.currency_rupee,
                                                ),
                                                border: border,
                                                enabledBorder: border,
                                                focusedBorder: border,
                                              ),
                                              validator: (value) {
                                                if (value == null ||
                                                    value.isEmpty) {
                                                  return 'Please enter a price';
                                                }
                                                return null;
                                              },
                                            ),
                                            TextFormField(
                                              controller: _adTitleController,
                                              textCapitalization:
                                                  TextCapitalization.sentences,
                                              maxLines: null,
                                              enabled: isEditable,
                                              decoration: InputDecoration(
                                                labelText: 'Title',
                                                prefixIcon: Icon(Icons.title),
                                                border: border,
                                                enabledBorder: border,
                                                focusedBorder: border,
                                              ),
                                              validator: (value) {
                                                if (value == null ||
                                                    value.isEmpty) {
                                                  return 'Please enter a title';
                                                }
                                                return null;
                                              },
                                            ),
                                            TextFormField(
                                              controller:
                                                  _descriptionController,
                                              textCapitalization:
                                                  TextCapitalization.sentences,
                                              maxLines: null,
                                              enabled: isEditable,
                                              decoration: InputDecoration(
                                                labelText: 'Description',
                                                prefixIcon: Icon(
                                                  Icons.description,
                                                ),
                                                border: border,
                                                enabledBorder: border,
                                                focusedBorder: border,
                                              ),
                                              validator: (value) {
                                                if (value == null ||
                                                    value.isEmpty) {
                                                  return 'Please enter a description';
                                                }
                                                return null;
                                              },
                                            ),
                                            TextFormField(
                                              controller: _addressController,
                                              textCapitalization:
                                                  TextCapitalization.sentences,
                                              enabled: false,
                                              maxLines: null,
                                              decoration: InputDecoration(
                                                labelText: 'Location',
                                                prefixIcon: Icon(
                                                  Icons.location_pin,
                                                ),
                                                border: border,
                                                enabledBorder: border,
                                                focusedBorder: border,
                                              ),
                                              validator: (value) {
                                                if (value == null ||
                                                    value.isEmpty) {
                                                  return 'Please enter a location';
                                                }
                                                return null;
                                              },
                                            ),
                                            const SizedBox(height: 20),
                                            showAppBarActions
                                                ? Container(
                                                    color: Colors.grey.shade50,
                                                    child: Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                            8.0,
                                                          ),
                                                      child: ElevatedButton(
                                                        onPressed: !isEditable
                                                            ? null
                                                            : () async {
                                                                if (!isEditable) {
                                                                  return;
                                                                }
                                                                if (!_formKey
                                                                    .currentState!
                                                                    .validate()) {
                                                                  return;
                                                                }
                                                                String? userId =
                                                                    await AdminSharedPreferences()
                                                                        .getUserId();
                                                                /*List<String> filteredImagePaths = _selectedImages
                                                               .where((image) => !image.startsWith('http'))
                                                               .toList();
                                                           List<String> base64Images = [];
                                                           for (String imagePath in filteredImagePaths) {
                                                             String base64Image = await ImageHelper.imageToBase64(imagePath);
                                                             base64Images.add(base64Image);
                                                           }*/
                                                                Map<
                                                                  String,
                                                                  dynamic
                                                                >
                                                                body = {
                                                                  "userId":
                                                                      userId,
                                                                  "productId":
                                                                      productProvider
                                                                          .bookList[0]
                                                                          .id,
                                                                  "adTitle":
                                                                      _adTitleController
                                                                          .text,
                                                                  "price":
                                                                      _priceController
                                                                          .text,
                                                                  "description":
                                                                      _descriptionController
                                                                          .text,
                                                                  "address1":
                                                                      _addressController
                                                                          .text,
                                                                  "modelName":
                                                                      modelName,
                                                                  "images": productProvider
                                                                      .bookList[0]
                                                                      .images,
                                                                  "productType":
                                                                      productProvider
                                                                          .bookList[0]
                                                                          .productType,
                                                                  "subProductType":
                                                                      productProvider
                                                                          .bookList[0]
                                                                          .subProductType,
                                                                  "categories":
                                                                      productProvider
                                                                          .bookList[0]
                                                                          .category,
                                                                  //  "productImages":base64Images
                                                                };
                                                                print(body);
                                                                await productProvider
                                                                    .updateProduct(
                                                                      body,
                                                                    );
                                                              },
                                                        style: ElevatedButton.styleFrom(
                                                          foregroundColor:
                                                              Colors.white,
                                                          backgroundColor:
                                                              Colors.green,
                                                          // ✅ Green if checked, Grey if not
                                                          shape: RoundedRectangleBorder(
                                                            borderRadius:
                                                                BorderRadius.circular(
                                                                  7,
                                                                ),
                                                          ),
                                                          minimumSize: Size(
                                                            double.infinity,
                                                            50,
                                                          ),
                                                        ),
                                                        child: Text(
                                                          "Update",
                                                          style: Theme.of(context)
                                                              .textTheme
                                                              .titleLarge!
                                                              .copyWith(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w500,
                                                                color: Colors
                                                                    .white,
                                                              ),
                                                        ),
                                                      ),
                                                    ),
                                                  )
                                                : SizedBox(),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                          ],
                        ),

                        /* Consumer<ProductProvider>(builder: (context, productProvider, child){
                    return  Expanded(
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
                          padding: const EdgeInsets.all(15),
                          child: SingleChildScrollView(
                            child: Column(
                              spacing: 25,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        if(productProvider.bookList.isNotEmpty)...[
                                          Text(
                                            "₹ ${ListFormatter.formatList(productProvider.bookList[0].price)}",
                                            style: TextStyle(fontSize: 16)),]else...[],
                                      ],
                                    ),
                                    if(productProvider.bookList.isNotEmpty)...[
                                      Text(ListFormatter.formatList(productProvider.bookList[0].adTitle),
                                        style: TextStyle(fontSize: 15)),]else...[],
                                  ],
                                ),
                                Container(
                                  //padding: EdgeInsets.symmetric(vertical: 10),
                                    child: Row(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        //Text("Description :- "),
                                        Row(
                                          children: [
                                            Icon(Icons.location_on_outlined,size: 17,),
                                            const SizedBox(width: 5),
                                            if (productProvider.bookList.isNotEmpty)
                                              ...[
                                                Text(ListFormatter.formatList(productProvider.bookList[0].address1),
                                                  style: TextStyle(fontSize: 12),
                                                )
                                              ]
                                            else
                                              ...[],

                                          ],
                                        ),
                                      ],
                                    )),

                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text("Description: "),
                                    const SizedBox(height: 2,),
                                    if(productProvider.bookList.isNotEmpty)...[
                                    Text(ListFormatter.formatList(productProvider.bookList[0].description)  ,
                                        style: TextStyle(fontSize: 15)),]else...[],

                                  ],
                                ),
                                SizedBox(height: 10),
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  }),*/
                        SizedBox(height: 20),
                      ],
                    ),
                  ),
                )
              : LoadingWidget(),

          /// show the loading widget if isLoading is true
          productProvider.isLoading ? LoadingWidget() : Container(),
        ],
      ),
    );
  }
}
