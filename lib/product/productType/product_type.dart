import 'package:admin_panel/product/productType/sub_product_type.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ProductType extends StatefulWidget {
  static const routeName = "/product-type";
  const ProductType({super.key});

  @override
  State<ProductType> createState() => _ProductTypeState();
}

class _ProductTypeState extends State<ProductType> {
  List<dynamic> productTypes = [];
  TextEditingController nameController = TextEditingController();
  TextEditingController modelNameController = TextEditingController();
  @override
  void initState() {
    super.initState();
    getProductType();
  }

  Future<void> addProductType()async{
    var headers = {
      'Content-Type': 'application/json'
    };
    var request = http.Request('POST', Uri.parse(''));
    request.body = json.encode({
      "name": nameController.text.trim(),
      "modelName": modelNameController.text.trim()
    });
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      print(await response.stream.bytesToString());
      getProductType();
    }
    else {
      print(response.reasonPhrase);
    }

  }
  Future<void> getProductType() async {
    var response = await http.get(
      Uri.parse(''),
    );

    if (response.statusCode == 200) {
      var data = json.decode(response.body);
      print("API Response: ${jsonEncode(data)}");

      setState(() {
        productTypes = data["data"];
      });

      print("Product List Length: ${productTypes.length}");

      for (var product in productTypes) {
        print("Product Name: ${product['name']}");
        print("Product Type ID: ${product['_id']}");
      }

    } else {
      print("Error: ${response.reasonPhrase}");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
          leading: Container(),
          title: Text("Product Types")),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          spacing: 25,
          children: [
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: nameController,
                    decoration: InputDecoration(
                      hintText: "Add Type",
                      border: OutlineInputBorder(),
                      contentPadding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    ),
                  ),
                ),
                SizedBox(width: 10),
                Expanded(
                  child: TextFormField(
                    controller: modelNameController,
                    decoration: InputDecoration(
                      hintText: "Add Model class",
                      border: OutlineInputBorder(),
                      contentPadding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    ),
                  ),
                ),
                SizedBox(width: 10),
                ElevatedButton(
                  onPressed: () {
                    addProductType();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: EdgeInsets.symmetric(horizontal: 24, vertical: 15), // optional
                  ),
                  child: Text(
                    "Create",
                    style: TextStyle(
                      color: Colors.white, // ✅ Text Color
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                )
              ],
            ),

            Expanded(
              child: ListView.builder(
                itemCount: productTypes.length,
                itemBuilder: (context, index) {
                  var product = productTypes[index];
                  return GestureDetector(
                    onTap: (){
                      Get.toNamed(SubProductType.routeName,arguments: {
                        "productTypeId": product["_id"],
                        "productTypeName": product["name"],
                      });

                    },
                    child: Container(
                      margin: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(7),
                          border: Border.all(
                              color: Colors.black26,
                              width: 0.7
                          )
                      ),
                      child: ListTile(
                        title: Text(product["name"] ?? "No Name"),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      )
    );
  }
}
