import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
class SubProductType extends StatefulWidget {
  static const routeName = "/sup-product-type";
  const SubProductType({super.key});

  @override
  State<SubProductType> createState() => _SubProductTypeState();
}

class _SubProductTypeState extends State<SubProductType> {
  List<dynamic> subProductTypes = [];
  String? productTypeName;
  String? productTypeId;
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _modelNameController = TextEditingController();
  @override
  void initState() {
    super.initState();

    final args = Get.arguments as Map<String, dynamic>?;

    if (args != null && args.containsKey("productTypeId")) {
      productTypeId = args["productTypeId"];
      productTypeName = args["productTypeName"];   // ✅ yeh line add kar
      print("Product Type ID: $productTypeId");
      print("Product Type Name: $productTypeName");  // optional
      getSubProductType();
    }

  }

  Future<void> addSubProductType()async{
    var headers = {
      'Content-Type': 'application/json'
    };
    var request = http.Request('POST', Uri.parse(''));
    request.body = json.encode({
      "name": _nameController.text.trim(),
      "productType": productTypeId
    });
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 201) {
      print(await response.stream.bytesToString());
      getSubProductType();
    }
    else {
      print(response.reasonPhrase);
    }

  }

  Future<void> getSubProductType() async {
    var request = http.Request(
      'GET',
      Uri.parse(''),
    );

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      var responseData = await response.stream.bytesToString();
      var data = json.decode(responseData);
      print("API Response: $data");

      setState(() {
        subProductTypes = data["data"];
      });
    } else {
      print("Error: ${response.reasonPhrase}");
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Sub Product Types"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: _nameController,
                    decoration: InputDecoration(
                      hintText: "Add Type",
                      border: OutlineInputBorder(),
                      contentPadding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    ),
                  ),
                ),
                SizedBox(width: 10),
              /*  Container(
                  margin: EdgeInsets.symmetric(horizontal: 10),
                    padding: EdgeInsets.symmetric(horizontal: 10,vertical: 12),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(7),
                     border: Border.all(
                         color: Colors.black
                     )
                    ),
                    child: Text('$productTypeName')),*/

                SizedBox(width: 10),
                ElevatedButton(
                  onPressed: () {
                    print('HHH');
                    addSubProductType();
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
                itemCount: subProductTypes.length,
                itemBuilder: (context, index) {
                  var subProduct = subProductTypes[index];
                  return Container(
                    margin: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(7),
                        border: Border.all(
                            color: Colors.black26,
                            width: 0.7
                        )
                    ),
                    child: ListTile(
                      title: Text(subProduct["name"] ?? "No Name"),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

