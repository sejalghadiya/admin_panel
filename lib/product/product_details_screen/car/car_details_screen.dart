import 'package:admin_panel/local_Storage/admin_shredPreferences.dart';
import 'package:admin_panel/utils/list_formatter.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../../provider/product_provider/product_provider.dart';
import '../../../utils/brand_list.dart';
import '../../../widgets/loading_widget.dart';

class CarDetailsScreen extends StatefulWidget {
  static const String routeName = "/car-details-screen";
  const CarDetailsScreen({super.key});

  @override
  State<CarDetailsScreen> createState() => _CarDetailsScreenState();
}

class _CarDetailsScreenState extends State<CarDetailsScreen> {
  TextEditingController brandController = TextEditingController();
  TextEditingController yearController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController titleController = TextEditingController();
  TextEditingController modelController = TextEditingController();
  TextEditingController priceController = TextEditingController();
  TextEditingController kilometersDrivenController = TextEditingController();
  TextEditingController fuelTypeController = TextEditingController();
  TextEditingController transmissionTypeController = TextEditingController();
  TextEditingController noOfOwnerController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  String? selectedBrand;
  String? selectedYear;
  String? selectedFuelType;
  bool isEditable = false;
  int selectedIndex = 0;
  String productId = "";
  String modelName = "";
  String baseUrl = "https://api.bhavnika.shop";
  List<String> fuelType = ['CNG & Hybrid','Diesel','Electric','LPG','Petrol'];
  List<String> generateYearList() {
    return List.generate(61, (index) => (2000 + index).toString());
  }
  final OutlineInputBorder border = OutlineInputBorder(
    borderSide: BorderSide(color: Colors.black,width: 0.5),
    borderRadius: BorderRadius.circular(8),
  );
  @override
  void initState() {
    super.initState();
    productId = Get.arguments['productId'] as String;
    modelName = Get.arguments['modelName'] as String;
    ProductProvider productDetailsProvider = Provider.of<ProductProvider>(context, listen: false);
    productDetailsProvider.fetchProductDetails(productId, modelName);
  }
  void setData()async{
    ProductProvider productProvider = Provider.of<ProductProvider>(context,listen: false);
    setState(() {
      brandController.text = productProvider.carList[0].brand.last.toString();
      yearController.text = productProvider.carList[0].year.last.toString();
      descriptionController.text = productProvider.carList[0].description.last.toString();
      titleController.text = productProvider.carList[0].title.last.toString();
      modelController.text = productProvider.carList[0].model.last.toString();
      priceController.text = productProvider.carList[0].price.last.toString();
      kilometersDrivenController.text = productProvider.carList[0].kmDriven.last.toString();
      fuelTypeController.text = productProvider.carList[0].fuel.last.toString();
      transmissionTypeController.text = productProvider.carList[0].transmission.last.toString();
      noOfOwnerController.text = productProvider.carList[0].noOfOwners.last.toString();
     // addressController.text = productProvider.carList[0].address1.last.toString();

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
        title: const Text('Car Details'),
        actions: [
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
                    TextButton(onPressed: () async {
                      await productProvider.deleteProduct(
                        productProvider.carList[0].id,
                        productProvider.carList[0].productType,
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
              productProvider.carList.isNotEmpty ?
              productProvider.carList[0].isActive
                  ? Icons.visibility
                  : Icons.visibility_off : Icons.error,
              color: Colors.black,
            ),
            onPressed: () async {
              if (productProvider.carList.isNotEmpty) {
                Map<String, dynamic> body = {
                  "productId": productProvider.carList[0].id,
                  "productType" : productProvider.carList[0].productType,
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
          productProvider.carList.isNotEmpty ?
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
                        if (productProvider.carList.isNotEmpty)
                          Column(
                            spacing: 6,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                productProvider.carList.isNotEmpty &&
                                    productProvider.carList[0].timestamps.isNotEmpty
                                    ? DateFormat('d MMMM yyyy, hh:mm:ss a').format(
                                  DateTime.parse(productProvider.carList[0].timestamps).toLocal(), // Convert to local time
                                )
                                    : 'N/A',
                                style: TextStyle(fontSize: 11, color: Colors.black),
                              ),

                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text("Add Product User Name:--"),
                                  Text(productProvider.carList[0].user.fName.last.toString()),
                                  const SizedBox(width: 5),
                                  Text(productProvider.carList[0].user.lName.last.toString()),
                                ],
                              ),
                              Text("Product Category:--${productProvider.carList[0].category}"),
                              Text("User product deleted:--${productProvider.carList[0].isDeleted}"),
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
                              builder: (context,productProvider,child) {
                                return Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                    children: [
                                      if (productProvider.carList.isNotEmpty) ...[
                                        Stack(
                                          children: [
                                            Container(
                                              padding: EdgeInsets.symmetric(horizontal: 20),
                                              height: 400,
                                              width: 400,
                                              decoration: BoxDecoration(
                                                borderRadius: BorderRadius.vertical(top: Radius.circular(8)),
                                              ),
                                              child: productProvider.carList.isNotEmpty &&
                                                  productProvider.carList[0].images.isNotEmpty &&
                                                  selectedIndex < productProvider.carList[0].images.length &&
                                                  productProvider.carList[0].images[selectedIndex].isNotEmpty
                                                  ? Image.network(
                                                '$baseUrl${productProvider.carList[0].images[selectedIndex]}',
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
                                                                "imagePath": productProvider.carList[0].images[selectedIndex],
                                                                "modelName": productProvider.carList[0].modelName
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
                                      if (productProvider.carList.isNotEmpty) ...[
                                        SizedBox(
                                          height: 50,
                                          child: ListView.builder(
                                            scrollDirection: Axis.horizontal,
                                            itemCount:
                                            productProvider.carList[0].images.length,
                                            shrinkWrap: true,
                                            itemBuilder: (context, index) {
                                              bool isSelected = index == selectedIndex;
                                              final imageUrl =
                                              productProvider.carList[0].images[index];
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
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              spacing: 15,
                              children: [
                                if(productProvider.carList.isNotEmpty)...[
                                  if(isEditable)...[
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
                                  ]else...[
                                    Text(
                                        "₹ ${ListFormatter.formatList(productProvider.carList[0].price)}",
                                        style: TextStyle(fontSize: 16)),
                                  ]
                                ]else...[],
                                if(productProvider.carList.isNotEmpty)...[
                                  if(isEditable)...[
                                    TextField(
                                      controller: titleController,
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
                                    Text(ListFormatter.formatList(productProvider.carList[0].title),
                                        style: TextStyle(fontSize: 15)),
                                  ]
                                ]else...[],
                                if(productProvider.carList.isNotEmpty)...[
                                  if(isEditable)...[
                                    DropdownButtonFormField<String>(
                                      value:  (productProvider.carList[0].brand.isNotEmpty) ? productProvider.carList[0].brand.last.toString() : null,
                                      items: brand.map((val) {
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
                                  ]
                                  else...[
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
                                              child: Text("Brand")),
                                          Container(
                                            padding: EdgeInsets.symmetric(horizontal: 10,vertical: 5),
                                            child:  Text(ListFormatter.formatList(productProvider.carList[0].brand), style: TextStyle(fontSize: 14)),),
                                        ],
                                      ),
                                    ),
                                  ]
                                ]else...[],
                                if(productProvider.carList.isNotEmpty)...[
                                  if(isEditable)...[
                                    TextField(
                                      controller: modelController,
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
                                            child:  Text(ListFormatter.formatList(productProvider.carList[0].model), style: TextStyle(fontSize: 14)),),
                                        ],
                                      ),
                                    ),
                                  ]
                                ]else...[],
                                if(productProvider.carList.isNotEmpty)...[
                                  if(isEditable)...[
                                    DropdownButtonFormField<String>(
                                      value: productProvider.carList[0].year.isNotEmpty ? productProvider.carList[0].year.last.toString() : null,
                                      items: generateYearList().map((year) {
                                        return DropdownMenuItem<String>(
                                          value: year,
                                          child: Text(year),
                                        );
                                      }).toList(),
                                      onChanged: (val) {
                                        selectedYear = val;
                                      },
                                      decoration: InputDecoration(
                                        labelText: 'Year',
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
                                              child: Text("Year")),
                                          Container(
                                            padding: EdgeInsets.symmetric(horizontal: 10,vertical: 5),
                                            child:  Text(ListFormatter.formatList(productProvider.carList[0].year), style: TextStyle(fontSize: 14)),),
                                        ],
                                      ),
                                    ),
                                  ]
                                ]else...[],
                                if(productProvider.carList.isNotEmpty)...[
                                  if(isEditable)...[
                                    TextField(
                                      controller: kilometersDrivenController,
                                      textCapitalization: TextCapitalization.sentences,
                                      decoration: InputDecoration(
                                        labelText: 'Km Driven',
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
                                              child: Text("Km driven")),
                                          Container(
                                            padding: EdgeInsets.symmetric(horizontal: 10,vertical: 5),
                                            child:  Text(ListFormatter.formatList(productProvider.carList[0].kmDriven) , style: TextStyle(fontSize: 14)),),
                                        ],
                                      ),
                                    ),
                                  ]
                                ]else...[],
                                if(productProvider.carList.isNotEmpty)...[
                                  if(isEditable)...[
                                    DropdownButtonFormField<String>(
                                      value: productProvider.carList[0].fuel.isNotEmpty ? productProvider.carList[0].fuel.last.toString() : null,
                                      items: fuelType.map((value) {
                                        return DropdownMenuItem<String>(
                                          value: value,
                                          child: Text(value),
                                        );
                                      }).toList(),
                                      onChanged: (val) {
                                        selectedFuelType = val;
                                      },
                                      decoration: InputDecoration(
                                        labelText: 'Fuel Type',
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
                                              child: Text("Fuel Type")),
                                          Container(
                                            padding: EdgeInsets.symmetric(horizontal: 10,vertical: 5),
                                            child:  Text(ListFormatter.formatList(productProvider.carList[0].fuel), style: TextStyle(fontSize: 14)),),
                                        ],
                                      ),
                                    ),
                                  ]
                                ]else...[],
                                if(productProvider.carList.isNotEmpty)...[
                                  if(isEditable)...[
                                    TextField(
                                      controller: transmissionTypeController,
                                      textCapitalization: TextCapitalization.sentences,
                                      decoration: InputDecoration(
                                        labelText: 'Transmission',
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
                                              child: Text("Transmission")),
                                          Container(
                                            padding: EdgeInsets.symmetric(horizontal: 10,vertical: 5),
                                            child:  Text(ListFormatter.formatList(productProvider.carList[0].transmission), style: TextStyle(fontSize: 14)),),
                                        ],
                                      ),
                                    ),
                                  ]
                                ]else...[],
                                if(productProvider.carList.isNotEmpty)...[
                                  if(isEditable)...[
                                    TextField(
                                      controller: noOfOwnerController,
                                      textCapitalization: TextCapitalization.sentences,
                                      decoration: InputDecoration(
                                        labelText: 'No of Owner',
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
                                              child: Text("Owner")),
                                          Container(
                                            padding: EdgeInsets.symmetric(horizontal: 10,vertical: 5),
                                            child:  Text(ListFormatter.formatList(productProvider.carList[0].noOfOwners), style: TextStyle(fontSize: 14)),),
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

                 if(productProvider.carList.isNotEmpty)...[
                   if(isEditable)...[
                      TextField(
                        controller: addressController,
                        textCapitalization: TextCapitalization.sentences,
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
                         Icon(
                           Icons.location_on_outlined,
                           size: 17,
                         ),
                         const SizedBox(width: 5),
                         if (productProvider.carList.isNotEmpty)
                           ...[
                             // Text(ListFormatter.formatList(productProvider.carList[0].address1),
                             //   style: TextStyle(fontSize: 12),
                             // )
                           ]
                         else
                           ...[],

                       ],
                     ),
                   ]
                 ]else...[],
                 if(productProvider.carList.isNotEmpty)...[
                   if(isEditable)...[
                      TextField(
                        controller: descriptionController,
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
                         Text("Description: ",style: TextStyle(fontSize: 14),),
                         if(productProvider.carList.isNotEmpty)...[
                           Text(ListFormatter.formatList(productProvider.carList[0].description),
                               style: TextStyle(fontSize: 15)),]else...[],
                       ],
                     ),
                   ]
                 ]else...[],

                  /*Consumer<ProductProvider>(
                      builder: (context,productProvider,child){
                        return Container(
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
                            padding: const EdgeInsets.all(12.0),
                            child: Column(
                              spacing: 15,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Text("Wireless Earphone", style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold)),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        if(productProvider.carList.isNotEmpty)...[
                                          Text(
                                            "₹ ${ListFormatter.formatList(productProvider.carList[0].price)}",
                                            style: TextStyle(fontSize: 16)),]else...[],
                                      ],
                                    ),
                                    if(productProvider.carList.isNotEmpty)...[
                                      Text(ListFormatter.formatList(productProvider.carList[0].title),
                                        style: TextStyle(fontSize: 15)),]else...[],

                                  ],
                                ),
                                Container(
                                    padding: EdgeInsets.symmetric(vertical: 10),
                                    decoration: BoxDecoration(
                                        color: Colors.white
                                    ),
                                    child: Row(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        //Text("Description :- "),
                                        Row(
                                          children: [
                                            Icon(
                                              Icons.location_on_outlined,
                                              size: 17,
                                            ),
                                            const SizedBox(width: 5),
                                            if (productProvider.carList.isNotEmpty)
                                              ...[
                                                Text(ListFormatter.formatList(productProvider.carList[0].address1),
                                                  style: TextStyle(fontSize: 12),
                                                )
                                              ]
                                            else
                                              ...[],

                                          ],
                                        ),
                                      ],
                                    )),

                                Container(
                                    width: double.infinity,
                                    decoration: BoxDecoration(
                                        color: Colors.white
                                    ),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text("Description: ",style: TextStyle(fontSize: 14),),
                                        if(productProvider.carList.isNotEmpty)...[
                                          Text(ListFormatter.formatList(productProvider.carList[0].description),
                                            style: TextStyle(fontSize: 15)),]else...[],
                                      ],
                                    )),

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
                                            child: Text("Brand")),
                                        Container(
                                          padding: EdgeInsets.symmetric(horizontal: 10,vertical: 5),
                                          child:  Text(ListFormatter.formatList(productProvider.carList[0].brand), style: TextStyle(fontSize: 14)),),
                                      ],
                                    ),
                                  ),
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
                                          child:  Text(ListFormatter.formatList(productProvider.carList[0].model), style: TextStyle(fontSize: 14)),),
                                      ],
                                    ),
                                  ),
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
                                            child: Text("Year")),
                                        Container(
                                          padding: EdgeInsets.symmetric(horizontal: 10,vertical: 5),
                                          child:  Text(ListFormatter.formatList(productProvider.carList[0].year), style: TextStyle(fontSize: 14)),),
                                      ],
                                    ),
                                  ),
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
                                            child: Text("Km driven")),
                                        Container(
                                          padding: EdgeInsets.symmetric(horizontal: 10,vertical: 5),
                                          child:  Text(ListFormatter.formatList(productProvider.carList[0].kmDriven) , style: TextStyle(fontSize: 14)),),
                                      ],
                                    ),
                                  ),
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
                                            child: Text("Fuel Type")),
                                        Container(
                                          padding: EdgeInsets.symmetric(horizontal: 10,vertical: 5),
                                          child:  Text(ListFormatter.formatList(productProvider.carList[0].fuel), style: TextStyle(fontSize: 14)),),
                                      ],
                                    ),
                                  ),
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
                                            child: Text("Transmission")),
                                        Container(
                                          padding: EdgeInsets.symmetric(horizontal: 10,vertical: 5),
                                          child:  Text(ListFormatter.formatList(productProvider.carList[0].transmission), style: TextStyle(fontSize: 14)),),
                                      ],
                                    ),
                                  ),
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
                                            child: Text("Owner")),
                                        Container(
                                          padding: EdgeInsets.symmetric(horizontal: 10,vertical: 5),
                                          child:  Text(ListFormatter.formatList(productProvider.carList[0].noOfOwners), style: TextStyle(fontSize: 14)),),
                                      ],
                                    ),
                                  ),
                                SizedBox(height: 10),
                              ],
                            ),
                          ),
                        );
                      }),*/
                  Container(
                    color: Colors.grey.shade50,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ElevatedButton(
                        onPressed: () async {
                          String? userId = await AdminSharedPreferences().getUserId();
                          // List<String> filteredImagePaths = _selectedImages
                          //     .where((image) => !image.startsWith('http'))
                          //     .toList();
                          // List<String> base64Images = [];
                          // for (String imagePath in filteredImagePaths) {
                          //   String base64Image = await ImageHelper.imageToBase64(imagePath);
                          //   base64Images.add(base64Image);
                          // }
                          Map<String,dynamic> body = {
                            "productId": productProvider.carList[0].id,
                            "userId": userId,
                            "model": modelController.text.trim(),
                            "brand": selectedBrand,
                            "price": priceController.text,
                            "year": selectedYear,
                            "kmDriven": kilometersDrivenController.text,
                            "fuelType": fuelTypeController.text,
                            "transmissionType": transmissionTypeController.text,
                            "noOfOwners": noOfOwnerController.text,//noOfOwners
                            "adTitle": titleController.text,
                            "description": descriptionController.text,
                            "address1": addressController.text,
                            "productType": productProvider.carList[0].productType,
                            "subProductType": productProvider.carList[0].subProductType,
                            "categories": productProvider.carList[0].category,
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
                  ),
                  const SizedBox(height: 30,)
                ],
              ),
            ),
          ) :LoadingWidget(),

          /// show loading widget when data is not available
          productProvider.isLoading ? LoadingWidget() : Container()
        ],
      ),
    );
  }
}