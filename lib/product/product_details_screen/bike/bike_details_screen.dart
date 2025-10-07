import 'package:admin_panel/local_Storage/admin_shredPreferences.dart';
import 'package:admin_panel/utils/address_extractor.dart';
import 'package:admin_panel/utils/list_formatter.dart';
import 'package:admin_panel/widgets/loading_widget.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../../model/product_model/bike_model.dart';
import '../../../network_connection/apis.dart';
import '../../../provider/product_provider/product_provider.dart';
import '../../../utils/brand_list.dart';

class BikeDetailsScreen extends StatefulWidget {
  static const routeName = "/bike-details-screen";

  const BikeDetailsScreen({super.key});

  @override
  State<BikeDetailsScreen> createState() => _BikeDetailsScreenState();
}

class _BikeDetailsScreenState extends State<BikeDetailsScreen> {
  TextEditingController brandController = TextEditingController();
  TextEditingController modelController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController kmDrivenController = TextEditingController();
  TextEditingController priceController = TextEditingController();
  TextEditingController titleController = TextEditingController();
  TextEditingController address1Controller = TextEditingController();
  String? selectedYear;
  String? selectedBrand;

  List<String> generateYearList() {
    return List.generate(61, (index) => (2000 + index).toString());
  }

  bool isEditable = false;
  Set<String> favoriteProductIds = {};
  List favoriteProducts = [];
  String productId = "";
  String modelName = "";
  int selectedIndex = 0;
  String baseUrl = Apis.BASE_URL_IMAGE;
  final OutlineInputBorder border = OutlineInputBorder(
    borderSide: BorderSide(color: Colors.black, width: 0.5),
    borderRadius: BorderRadius.circular(8),
  );
  bool showAppBarActions = true;

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      productId = Get.arguments['productId'] as String;
      modelName = Get.arguments['modelName'] as String;
      showAppBarActions = Get.arguments['isEdit'] as bool? ?? true;
      ProductProvider productProvider = Provider.of<ProductProvider>(
        context,
        listen: false,
      );
      productProvider.fetchProductDetails(productId, modelName);
      setData();
    });
  }

  void setData() {
    ProductProvider productProvider = Provider.of<ProductProvider>(
      context,
      listen: false,
    );
    Future.delayed(Duration(seconds: 0), () {
      if (productProvider.bikeList.isNotEmpty){
        String oldAddress = AddressExtractor.extractAddress(
          street1: productProvider.bikeList[0].street1,
          street2: productProvider.bikeList[0].street2,

          area: productProvider.bikeList[0].area,

          city: productProvider.bikeList[0].city,

          state: productProvider.bikeList[0].state,

          country: productProvider.bikeList[0].country,

          pincode: productProvider.bikeList[0].pincode,
        ).$1;
        String newAddress = AddressExtractor.extractAddress(
          street1: productProvider.bikeList[0].street1,
          street2: productProvider.bikeList[0].street2,

          area: productProvider.bikeList[0].area,

          city: productProvider.bikeList[0].city,

          state: productProvider.bikeList[0].state,

          country: productProvider.bikeList[0].country,

          pincode: productProvider.bikeList[0].pincode,
        ).$2;
        String address = "";
        if (oldAddress.isNotEmpty) {
          address = oldAddress;
        }
        if (newAddress.isNotEmpty) {
            address = newAddress;
        }
        setState(() {
          if (productProvider.bikeList.isNotEmpty) {
            priceController.text = productProvider.bikeList[0].price.last
                .toString();
            modelController.text = productProvider.bikeList[0].model.last
                .toString();
            kmDrivenController.text = productProvider.bikeList[0].kmDriven.last
                .toString();
            titleController.text = productProvider.bikeList[0].adTitle.last
                .toString();
            descriptionController.text = productProvider
                .bikeList[0]
                .description
                .last
                .toString();
            brandController.text = productProvider.bikeList[0].brand.last
                .toString();
            address1Controller.text = address;
          }
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    ProductProvider productProvider = Provider.of<ProductProvider>(
      context,
      listen: true,
    );
    if (productProvider.bikeList.isNotEmpty) {
      priceController.text = productProvider.bikeList[0].price.last.toString();
      modelController.text = productProvider.bikeList[0].model.last.toString();
      kmDrivenController.text = productProvider.bikeList[0].kmDriven.last
          .toString();
      titleController.text = productProvider.bikeList[0].adTitle.last
          .toString();
      descriptionController.text = productProvider.bikeList[0].description.last
          .toString();
      brandController.text = productProvider.bikeList[0].brand.last.toString();
    }
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        shadowColor: Colors.transparent,
        title: Text('Bike Details'),
        actions: showAppBarActions
            ? [
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
                  icon: Icon(
                    productProvider.bikeList.isNotEmpty
                        ? productProvider.bikeList[0].isDeleted
                              ? Icons.restore_from_trash
                              : Icons.delete
                        : Icons.error,
                    color: productProvider.bikeList.isNotEmpty
                        ? productProvider.bikeList[0].isDeleted
                              ? Colors.grey
                              : Colors.red
                        : Colors.black,
                  ),
                  onPressed: () async {
                    final isDeleted = productProvider.bikeList[0].isDeleted;

                    final confirm = await showDialog<bool>(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: Text(
                          isDeleted ? "Restore Product" : "Delete Product",
                        ),
                        content: Text(
                          isDeleted
                              ? "Are you sure you want to restore this product?"
                              : "Are you sure you want to delete this product?",
                        ),
                        actions: [
                          TextButton(
                            child: const Text("Cancel"),
                            onPressed: () => Navigator.of(context).pop(false),
                          ),
                          TextButton(
                            onPressed: () async {
                              if (isDeleted) {
                                // Call restore API or update method
                                await productProvider.deleteProduct(
                                  productProvider.bikeList[0].id,
                                  productProvider.bikeList[0].productType,
                                );
                              } else {
                                // Call delete API (soft delete)
                                await productProvider.deleteProduct(
                                  productProvider.bikeList[0].id,
                                  productProvider.bikeList[0].productType,
                                );
                              }
                              Navigator.of(context).pop(true);
                              setState(() {});
                            },
                            child: Text(isDeleted ? "Restore" : "Delete"),
                          ),
                        ],
                      ),
                    );
                  },
                ),

                IconButton(
                  icon: Icon(
                    productProvider.bikeList.isNotEmpty
                        ? productProvider.bikeList[0].isActive
                              ? Icons.visibility
                              : Icons.visibility_off
                        : Icons.error,
                    color: Colors.black,
                  ),
                  onPressed: () async {
                    if (productProvider.bikeList.isNotEmpty) {
                      Map<String, dynamic> body = {
                        "productId": productProvider.bikeList[0].id,
                        "productType": productProvider.bikeList[0].productType,
                      };

                      await productProvider.product_active_inactive(body);
                    }
                  },
                ),
              ]
            : [],
        centerTitle: true,
      ),
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(10),
            child: SingleChildScrollView(
              child: Column(
                spacing: 20,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Container(
                    alignment: Alignment.centerRight,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        if (productProvider.bikeList.isNotEmpty)
                          Column(
                            spacing: 6,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                productProvider.bikeList.isNotEmpty &&
                                        productProvider
                                            .bikeList[0]
                                            .timestamps
                                            .isNotEmpty
                                    ? DateFormat(
                                        'd MMMM yyyy, hh:mm:ss a',
                                      ).format(
                                        DateTime.parse(
                                          productProvider
                                              .bikeList[0]
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
                                    productProvider.bikeList[0].user.fName.last
                                        .toString(),
                                  ),
                                  const SizedBox(width: 5),
                                  Text(
                                    productProvider.bikeList[0].user.lName.last
                                        .toString(),
                                  ),
                                ],
                              ),
                              Text(
                                "Product Category:--${productProvider.bikeList[0].category}",
                              ),
                              Text(
                                "User product deleted:--${productProvider.bikeList[0].isDeleted}",
                              ),
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
                            builder: (context, productProvider, child) {
                              return Column(
                                children: [
                                  if (productProvider.bikeList.isNotEmpty) ...[
                                    Consumer<ProductProvider>(
                                      builder: (context, productProvider, child) {
                                        return Stack(
                                          alignment: Alignment.topRight,
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
                                                      top: Radius.circular(8),
                                                    ),
                                              ),
                                              child:
                                                  productProvider
                                                          .bikeList
                                                          .isNotEmpty &&
                                                      productProvider
                                                          .bikeList[0]
                                                          .images
                                                          .isNotEmpty &&
                                                      selectedIndex <
                                                          productProvider
                                                              .bikeList[0]
                                                              .images
                                                              .length &&
                                                      productProvider
                                                          .bikeList[0]
                                                          .images[selectedIndex]
                                                          .isNotEmpty
                                                  ? CachedNetworkImage(
                                                      imageUrl:
                                                          '$baseUrl${productProvider.bikeList[0].images[selectedIndex]}',
                                                      fit: BoxFit.fill,
                                                      width: double.infinity,
                                                      errorWidget:
                                                          (
                                                            context,
                                                            error,
                                                            stackTrace,
                                                          ) => Icon(
                                                            Icons.broken_image,
                                                            size: 90,
                                                          ),
                                                    )
                                                  : Icon(Icons.image, size: 90),
                                            ),
                                          ],
                                        );
                                      },
                                    ),
                                  ] else
                                    ...[],
                                  const SizedBox(height: 10),
                                  if (productProvider.bikeList.isNotEmpty) ...[
                                    SizedBox(
                                      height: 50,
                                      child: ListView.builder(
                                        scrollDirection: Axis.horizontal,
                                        itemCount: productProvider
                                            .bikeList[0]
                                            .images
                                            .length,
                                        shrinkWrap: true,
                                        itemBuilder: (context, index) {
                                          bool isSelected =
                                              index == selectedIndex;
                                          final imageUrl = productProvider
                                              .bikeList[0]
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
                                                          color: Colors.blue,
                                                          width: 2,
                                                        )
                                                      : null,
                                                  borderRadius:
                                                      BorderRadius.circular(8),
                                                ),
                                                child:
                                                    imageUrl != null &&
                                                        imageUrl.isNotEmpty
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
                              );
                            },
                          ),
                        ],
                      ),
                      Consumer<ProductProvider>(
                        builder: (context, productProvider, child) {
                          return Expanded(
                            child: Container(
                              width: double.infinity,
                              decoration: BoxDecoration(color: Colors.white),
                              child: SingleChildScrollView(
                                child: Column(
                                  spacing: 15,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Column(
                                      spacing: 20,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        if (productProvider
                                            .bikeList
                                            .isNotEmpty) ...[
                                          TextField(
                                            controller: priceController,
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
                                            .bikeList
                                            .isNotEmpty) ...[
                                          TextFormField(
                                            controller: titleController,
                                            enabled:
                                                showAppBarActions && isEditable,
                                            textCapitalization:
                                                TextCapitalization.sentences,
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
                                      ],
                                    ),
                                    if (productProvider
                                        .bikeList
                                        .isNotEmpty) ...[
                                      TextFormField(
                                        controller: brandController,
                                        enabled: false,
                                        textCapitalization:
                                            TextCapitalization.sentences,
                                        maxLines: null,
                                        decoration: InputDecoration(
                                          labelText: 'Brand',
                                          border: border,
                                          enabledBorder: border,
                                          focusedBorder: border,
                                        ),
                                      ),
                                    ] else
                                      ...[],
                                    if (productProvider
                                        .bikeList
                                        .isNotEmpty) ...[
                                      TextField(
                                        controller: modelController,
                                        enabled: false,
                                        textCapitalization:
                                            TextCapitalization.sentences,
                                        decoration: InputDecoration(
                                          labelText: 'Model',
                                          border: border,
                                          enabledBorder: border,
                                          focusedBorder: border,
                                        ),
                                      ),
                                    ] else
                                      ...[],
                                    if (productProvider
                                        .bikeList
                                        .isNotEmpty) ...[
                                      TextField(
                                        controller: TextEditingController(
                                          text:
                                              productProvider
                                                  .bikeList[0]
                                                  .year
                                                  .isNotEmpty
                                              ? productProvider
                                                    .bikeList[0]
                                                    .year
                                                    .last
                                                    .toString()
                                              : '',
                                        ),
                                        enabled: false,
                                        textCapitalization:
                                            TextCapitalization.sentences,
                                        decoration: InputDecoration(
                                          labelText: 'Year',
                                          border: border,
                                          enabledBorder: border,
                                          focusedBorder: border,
                                        ),
                                      ),
                                    ] else
                                      ...[],
                                    if (productProvider
                                        .bikeList
                                        .isNotEmpty) ...[
                                      TextField(
                                        controller: kmDrivenController,
                                        enabled: false,
                                        decoration: InputDecoration(
                                          labelText: 'Kms Driven',
                                          border: border,
                                          enabledBorder: border,
                                          focusedBorder: border,
                                        ),
                                      ),
                                    ] else
                                      ...[],
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  if (productProvider.bikeList.isNotEmpty) ...[
                    TextField(
                      controller: descriptionController,
                      enabled: showAppBarActions && isEditable,
                      textCapitalization: TextCapitalization.sentences,
                      maxLines: null,
                      decoration: InputDecoration(
                        labelText: 'Description',
                        border: border,
                        enabledBorder: border,
                        focusedBorder: border,
                      ),
                    ),
                  ] else
                    ...[],
                  if (productProvider.bikeList.isNotEmpty) ...[
                    TextField(
                      controller: address1Controller,
                      enabled: false,
                      textCapitalization: TextCapitalization.sentences,
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
                  SizedBox(height: 20),
                  showAppBarActions && isEditable
                      ? Container(
                          color: Colors.grey.shade50,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: ElevatedButton(
                              onPressed: () async {
                                String? userId = await AdminSharedPreferences()
                                    .getUserId();
                                /* List<String> filteredImagePaths = _selectedImages
                                  .where((image) => !image.startsWith('http'))
                                  .toList();
                              List<String> base64Images = [];
                              for (String imagePath in filteredImagePaths) {
                                String base64Image = await ImageHelper.imageToBase64(imagePath);
                                base64Images.add(base64Image);
                              }*/
                                Map<String, dynamic> body = {
                                  "productId": productProvider.bikeList[0].id,
                                  "userId": userId,
                                  "brand": brandController.text.trim(),
                                  "model": modelController.text.trim(),
                                  "year": selectedYear.toString(),
                                  "price": priceController.text.trim(),
                                  "kmDriven": kmDrivenController.text.trim(),
                                  "adTitle": titleController.text.trim(),
                                  "description": descriptionController.text
                                      .trim(),
                                  "productType":
                                      productProvider.bikeList[0].productType,
                                  "subProductType": productProvider
                                      .bikeList[0]
                                      .subProductType,
                                  "categories":
                                      productProvider.bikeList[0].category,
                                  "address1": address1Controller.text.trim(),
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
                                style: Theme.of(context).textTheme.titleLarge!
                                    .copyWith(
                                      fontWeight: FontWeight.w500,
                                      color: Colors.white,
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
          productProvider.isLoading ? LoadingWidget() : Container(),
        ],
      ),
    );
  }
}
