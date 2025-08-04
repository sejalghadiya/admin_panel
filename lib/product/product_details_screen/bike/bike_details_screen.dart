import 'package:admin_panel/local_Storage/admin_shredPreferences.dart';
import 'package:admin_panel/utils/list_formatter.dart';
import 'package:admin_panel/widgets/loading_widget.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
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
  String baseUrl = 'https://api.bhavnika.shop';
  final OutlineInputBorder border = OutlineInputBorder(
    borderSide: BorderSide(color: Colors.black, width: 0.5),
    borderRadius: BorderRadius.circular(8),
  );

  @override
  void initState() {
    super.initState();
    productId = Get.arguments['productId'] as String;
    modelName = Get.arguments['modelName'] as String;
    ProductProvider productProvider = Provider.of<ProductProvider>(context, listen: false,);
    productProvider.fetchProductDetails(productId, modelName);
  }

  void setData() {
    ProductProvider productProvider = Provider.of<ProductProvider>(
      context,
      listen: false,
    );
    setState(() {
      priceController.text = productProvider.bikeList[0].price.last.toString();
      modelController.text = productProvider.bikeList[0].model.last.toString();
      kmDrivenController.text = productProvider.bikeList[0].kmDriven.last.toString();
      titleController.text = productProvider.bikeList[0].adTitle.last.toString();
      descriptionController.text = productProvider.bikeList[0].description.last.toString();
      brandController.text  = productProvider.bikeList[0].brand.last.toString();
    });
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
        title: Text('Bike Details'),
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
          /*IconButton(
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
                              productProvider.bikeList[0].id,
                              productProvider.bikeList[0].productType,
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
          ),*/
          IconButton(
            icon: Icon(
              productProvider.bikeList[0].isDeleted
                  ? Icons.restore_from_trash
                  : Icons.delete,
              color: productProvider.bikeList[0].isDeleted
                  ? Colors.grey
                  : Colors.red,
            ),
            onPressed: () async {
              final isDeleted = productProvider.bikeList[0].isDeleted;

              final confirm = await showDialog<bool>(
                context: context,
                builder: (context) => AlertDialog(
                  title: Text(isDeleted ? "Restore Product" : "Delete Product"),
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
              productProvider.bikeList.isNotEmpty ?
              productProvider.bikeList[0].isActive
                  ? Icons.visibility
                  : Icons.visibility_off : Icons.error,
              color: Colors.black,
            ),
            onPressed: () async {
              if (productProvider.bikeList.isNotEmpty) {
                Map<String, dynamic> body = {
                  "productId": productProvider.bikeList[0].id,
                  "productType" : productProvider.bikeList[0].productType,
                };

                await productProvider.product_active_inactive(body);
              }
            },
          ),
        ],
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
                                    productProvider.bikeList[0].timestamps.isNotEmpty
                                    ? DateFormat('d MMMM yyyy, hh:mm:ss a').format(
                                  DateTime.parse(productProvider.bikeList[0].timestamps).toLocal(), // Convert to local time
                                )
                                    : 'N/A',
                                style: TextStyle(fontSize: 11, color: Colors.black),
                              ),

                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text("Add Product User Name:--"),
                                  Text(productProvider.bikeList[0].user.fName.last.toString()),
                                  const SizedBox(width: 5),
                                  Text(productProvider.bikeList[0].user.lName.last.toString()),
                                ],
                              ),
                              Text("Product Category:--${productProvider.bikeList[0].category}"),
                              Text("User product deleted:--${productProvider.bikeList[0].isDeleted}"),
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
                                            padding: EdgeInsets.symmetric(horizontal: 20),
                                            height: 400,
                                            width: 400,
                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius.vertical(
                                                top: Radius.circular(8),
                                              ),
                                            ),
                                            child:
                                            productProvider.bikeList.isNotEmpty &&
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
                                                ? Image.network(
                                              '$baseUrl${productProvider.bikeList[0].images[selectedIndex]}',
                                              fit: BoxFit.fill,
                                              width: double.infinity,
                                              errorBuilder:
                                                  (context, error, stackTrace) =>
                                                  Icon(
                                                    Icons.broken_image,
                                                    size: 90,
                                                  ),
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
                                                              "imagePath": productProvider.bikeList[0].images[selectedIndex],
                                                              "modelName": productProvider.bikeList[0].modelName
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
                                      itemCount:
                                      productProvider.bikeList[0].images.length,
                                      shrinkWrap: true,
                                      itemBuilder: (context, index) {
                                        bool isSelected = index == selectedIndex;
                                        final imageUrl =
                                        productProvider.bikeList[0].images[index];
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
                            decoration: BoxDecoration(
                              color: Colors.white,
                              border: Border(
                                top: BorderSide(
                                  color: Colors.grey.shade200,
                                  width: 1,
                                ),
                              ),
                            ),
                            child: SingleChildScrollView(
                              child: Column(
                                spacing: 15,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Column(
                                    spacing: 20,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      if (productProvider.bikeList.isNotEmpty) ...[
                                        if (isEditable) ...[
                                          TextField(
                                            controller: priceController,
                                            decoration: InputDecoration(
                                              labelText: 'Price',
                                              suffixIcon: Icon(Icons.edit),
                                              border: border,
                                              enabledBorder: border,
                                              focusedBorder: border,
                                            ),
                                          ),
                                        ] else ...[
                                          Padding(
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 10,
                                              vertical: 10,
                                            ),
                                            child: Text(
                                             '₹ ${ ListFormatter.formatList(
                                            productProvider.bikeList[0].price,
                                            )}',
                                              style: TextStyle(fontSize: 16),
                                            ),
                                          ),
                                        ],
                                      ] else
                                        ...[],
                                      if (productProvider.bikeList.isNotEmpty) ...[
                                          if (isEditable) ...[
                                          TextFormField(
                                            controller: titleController,
                                            textCapitalization:
                                            TextCapitalization.sentences,
                                            maxLines: null,
                                            decoration: InputDecoration(
                                              labelText: 'Title',
                                              suffixIcon: Icon(Icons.edit),
                                              border: border,
                                              enabledBorder: border,
                                              focusedBorder: border,
                                            ),
                                          ),
                                        ] else ...[
                                          Padding(
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 10,
                                            ),
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Text("Title"),
                                                Text(
                                                  ListFormatter.formatList(
                                                    productProvider.bikeList[0].adTitle,
                                                  ),
                                                  style: TextStyle(fontSize: 16),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ] else
                                        ...[],
                                    ],
                                  ),
                                  if (productProvider.bikeList.isNotEmpty) ...[
                                    if (isEditable) ...[
                                      DropdownButtonFormField2(
                                        value: (productProvider.bikeList[0].brand.isNotEmpty)
                                            ? productProvider.bikeList[0].brand.last.toString()
                                            : null,
                                        items: bikeBrands.map((val) {
                                          return DropdownMenuItem<String>(
                                            value: val,
                                            child: Text(val),
                                          );
                                        }).toList(),
                                        onChanged: (val) {
                                          setState(() {
                                            brandController.text = val!;
                                          });
                                        },
                                        decoration: InputDecoration(
                                          labelText: 'Brand',
                                          border: border,
                                          enabledBorder: border,
                                          focusedBorder: border,
                                        ),
                                        dropdownStyleData: DropdownStyleData(
                                          maxHeight: 200,
                                          width: 300,
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(8),
                                          ),
                                        ),
                                      ),
                                    ] else ...[
                                      Container(
                                        width: double.infinity,
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                        ),
                                        child: Row(
                                          mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                          children: [
                                            Container(
                                              padding: EdgeInsets.symmetric(
                                                horizontal: 10,
                                                vertical: 5,
                                              ),
                                              child: Text("Brand"),
                                            ),
                                            if (productProvider
                                                .bikeList
                                                .isNotEmpty) ...[
                                              Container(
                                                padding: EdgeInsets.symmetric(
                                                  horizontal: 10,
                                                  vertical: 5,
                                                ),
                                                child: Text(
                                                  ListFormatter.formatList(
                                                    productProvider
                                                        .bikeList[0]
                                                        .brand,
                                                  ),
                                                  style: TextStyle(fontSize: 15),
                                                ),
                                              ),
                                            ] else
                                              ...[],
                                          ],
                                        ),
                                      ),
                                    ],
                                  ] else
                                    ...[],
                                  if (productProvider.bikeList.isNotEmpty) ...[
                                    if (isEditable) ...[
                                      TextField(
                                        controller: modelController,
                                        textCapitalization:
                                        TextCapitalization.sentences,
                                        decoration: InputDecoration(
                                          labelText: 'Model',
                                          suffixIcon: Icon(Icons.edit),
                                          border: border,
                                          enabledBorder: border,
                                          focusedBorder: border,
                                        ),
                                      ),
                                    ] else ...[
                                      Container(
                                        width: double.infinity,
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                        ),
                                        child: Row(
                                          mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                          children: [
                                            Container(
                                              padding: EdgeInsets.symmetric(
                                                horizontal: 10,
                                                vertical: 5,
                                              ),
                                              child: Text("Model"),
                                            ),
                                            Container(
                                              padding: EdgeInsets.symmetric(
                                                horizontal: 10,
                                                vertical: 5,
                                              ),
                                              child: Text(
                                                ListFormatter.formatList(
                                                  productProvider.bikeList[0].model,
                                                ),
                                                style: TextStyle(fontSize: 15),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ] else
                                    ...[],
                                  if (productProvider.bikeList.isNotEmpty) ...[
                                    if (isEditable) ...[
                                      DropdownButtonFormField<String>(
                                        // (productProvider.bikeList[0].brand.isNotEmpty)
                                        //     ? productProvider.bikeList[0].brand.last.toString()
                                        //     : null,
                                        value: productProvider.bikeList[0].year.isNotEmpty ? productProvider.bikeList[0].year.last.toString() : null,
                                        items: generateYearList().map((year) {
                                          return DropdownMenuItem<String>(
                                            value: year,
                                            child: Text(year),
                                          );
                                        }).toList(),
                                        onChanged: (val) {
                                          setState(() {
                                            selectedYear = val;
                                          });

                                        },
                                        decoration: InputDecoration(
                                          labelText: 'Year',
                                          border: border,
                                          enabledBorder: border,
                                          focusedBorder: border,
                                        ),
                                      ),
                                    ] else ...[
                                      Container(
                                        width: double.infinity,
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                        ),
                                        child: Row(
                                          mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                          children: [
                                            Container(
                                              padding: EdgeInsets.symmetric(
                                                horizontal: 10,
                                                vertical: 5,
                                              ),
                                              child: Text("Year"),
                                            ),
                                            Container(
                                              padding: EdgeInsets.symmetric(
                                                horizontal: 10,
                                                vertical: 5,
                                              ),
                                              child: Text(
                                                ListFormatter.formatList(
                                                  productProvider.bikeList[0].year,
                                                ),
                                                style: TextStyle(fontSize: 15),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ] else
                                    ...[],
                                  if (productProvider.bikeList.isNotEmpty) ...[
                                    if (isEditable) ...[
                                      TextField(
                                        controller: kmDrivenController,
                                        decoration: InputDecoration(
                                          labelText: 'Kms Driven',
                                          suffixIcon: Icon(Icons.edit),
                                          border: border,
                                          enabledBorder: border,
                                          focusedBorder: border,
                                        ),
                                      ),
                                    ] else ...[
                                      Container(
                                        width: double.infinity,
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                        ),
                                        child: Row(
                                          mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                          children: [
                                            Container(
                                              padding: EdgeInsets.symmetric(
                                                horizontal: 10,
                                                vertical: 5,
                                              ),
                                              child: Text("KM driven"),
                                            ),
                                            Container(
                                              padding: EdgeInsets.symmetric(
                                                horizontal: 10,
                                                vertical: 5,
                                              ),
                                              child: Text(
                                                ListFormatter.formatList(
                                                  productProvider
                                                      .bikeList[0]
                                                      .kmDriven,
                                                ),
                                                style: TextStyle(fontSize: 15),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
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
                    if (isEditable) ...[
                      TextField(
                        controller: descriptionController,
                        textCapitalization:
                        TextCapitalization.sentences,
                        maxLines: null,
                        decoration: InputDecoration(
                          labelText: 'Description',
                          suffixIcon: Icon(Icons.edit),
                          border: border,
                          enabledBorder: border,
                          focusedBorder: border,
                        ),
                      ),
                    ] else ...[
                      Container(
                        width: double.infinity,
                        padding: EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 10,
                        ),
                        child: Column(
                          crossAxisAlignment:
                          CrossAxisAlignment.start,
                          children: [
                            Text("Description: "),
                            Text(
                              ListFormatter.formatList(
                                productProvider
                                    .bikeList[0]
                                    .description,
                              ),
                              style: TextStyle(fontSize: 15),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ] else
                    ...[],
                  if (productProvider.bikeList.isNotEmpty) ...[
                    if (isEditable) ...[
                      TextField(
                        controller: address1Controller,
                        textCapitalization:
                        TextCapitalization.sentences,
                        maxLines: null,
                        decoration: InputDecoration(
                          labelText: 'Address',
                          suffixIcon: Icon(Icons.edit),
                          border: border,
                          enabledBorder: border,
                          focusedBorder: border,
                        ),
                      ),
                    ] else ...[
                      Container(
                        padding: EdgeInsets.symmetric(
                          vertical: 10,
                          horizontal: 10,
                        ),
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
                            //         .bikeList[0]
                            //         .address1,
                            //   ),
                            //   style: TextStyle(fontSize: 12),
                            // ),
                          ],
                        ),
                      ),
                    ],
                  ] else
                    ...[],
                  SizedBox(height: 20),
                  Container(
                    color: Colors.grey.shade50,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ElevatedButton(
                        onPressed: () async {
                          String? userId =
                              await AdminSharedPreferences().getUserId();
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
                            "description": descriptionController.text.trim(),
                            "productType":
                                productProvider.bikeList[0].productType,
                            "subProductType":
                                productProvider.bikeList[0].subProductType,
                            "categories": productProvider.bikeList[0].category,
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
                          style: Theme.of(context).textTheme.titleLarge!.copyWith(
                            fontWeight: FontWeight.w500,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
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
