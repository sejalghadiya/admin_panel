import 'package:admin_panel/product/product_details_screen/bike/bike_details_screen.dart';
import 'package:admin_panel/product/product_details_screen/book_sport_hobby/book_sports_hobby_details_screen.dart';
import 'package:admin_panel/product/product_details_screen/car/car_details_screen.dart';
import 'package:admin_panel/product/product_details_screen/electronics/electronics_detail_screen.dart';
import 'package:admin_panel/product/product_details_screen/furniture/furniture_details_screen.dart';
import 'package:admin_panel/product/product_details_screen/job/job_details_screens.dart';
import 'package:admin_panel/product/product_details_screen/other/other_details_screen.dart';
import 'package:admin_panel/product/product_details_screen/pet/pet_details_screen.dart';
import 'package:admin_panel/product/product_details_screen/property/property_details_screen.dart';
import 'package:admin_panel/product/product_details_screen/services/services_details_screen.dart';
import 'package:admin_panel/product/product_details_screen/smart_phone/smart_phone_details_screen.dart';
import 'package:admin_panel/provider/product_provider/product_provider.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

import '../navigation/getX_navigation.dart';
import '../network_connection/apis.dart';

class AllProductGet extends StatefulWidget {
  static const routeName = "/all-product-get";

  const AllProductGet({super.key});

  @override
  State<AllProductGet> createState() => _AllProductGetState();
}

class _AllProductGetState extends State<AllProductGet>
    with SingleTickerProviderStateMixin {
  @override
  TabController? _tabController;

  String baseUrl = Apis.BASE_URL_IMAGE;
  String selectedCategory = "";
  int selectedProductTypeIndex = 0;
  TextEditingController searchController = TextEditingController();
  String searchQuery = '';

  @override
  void initState() {
    super.initState();
    final productProvider = Provider.of<ProductProvider>(
      context,
      listen: false,
    );
    getAllProducts();
    productProvider.getProductType().then((_) {
      _tabController = TabController(
        length: productProvider.products.length,
        vsync: this,
      );
    });
  }

  void getAllProducts() async {
    ProductProvider productProvider = Provider.of<ProductProvider>(
      context,
      listen: false,
    );
    if (productProvider.products.isNotEmpty) {
      String productTypeId = productProvider.products[0].id;
      productProvider.fetchProducts(productTypeId);
    }
  }

  @override
  void dispose() {
    _tabController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ProductProvider productProvider = Provider.of<ProductProvider>(
      context,
      listen: true,
    );
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          spacing: 15,
          children: [
            const SizedBox(height: 10,),
            Consumer<ProductProvider>(
              builder: (context, productProvider, child) {
                if (productProvider.products.isEmpty) {
                  return SizedBox.shrink();
                }

                return Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  alignment: WrapAlignment.center,
                  children: List.generate(productProvider.products.length, (index) {
                    final product = productProvider.products[index];
                    final isSelected = selectedProductTypeIndex == index;

                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          selectedProductTypeIndex = index;
                          selectedCategory = "";
                        });
                        final productTypeId = product.id;
                        productProvider.fetchProducts(productTypeId);
                        print(productTypeId);
                        print("+++++++++++");
                      },
                      child: Container(
                        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                        decoration: BoxDecoration(
                          color: isSelected ? Colors.green.shade700 : Colors.transparent,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: Colors.green.shade700,
                            width: 1.5,
                          ),
                        ),
                        child: Text(
                          "${product.name} (${product.count})",
                          style: TextStyle(
                            color: isSelected ? Colors.white : Colors.green.shade700,
                            fontSize: 15,
                            fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                          ),
                        ),
                      ),
                    );
                  }),
                );
              },
            ),

            Wrap(
              spacing: 50,
              runSpacing: 10,
              children: [
                InkWell(
                  highlightColor: Colors.transparent,
                  hoverColor: Colors.transparent,
                  splashColor: Colors.transparent,
                  onTap: () {
                    print("A");
                    if (selectedCategory == "A") {
                      setState(() {
                        selectedCategory = "";
                      });
                      String productTypeId =
                          productProvider.products[selectedProductTypeIndex].id;
                      productProvider.fetchProducts(productTypeId);
                    } else {
                      setState(() {
                        selectedCategory = "A";
                      });
                      String productTypeId =
                          productProvider.products[selectedProductTypeIndex].id;
                      productProvider.fetchProducts(
                        productTypeId,
                        category: "A",
                      );
                    }
                  },
                  child: Container(
                    margin: EdgeInsets.symmetric(horizontal: 20),
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: Colors.green.shade700,
                        width: 1.5,
                      ),
                      color:
                          selectedCategory == "A"
                              ? Colors.green.shade700
                              : Colors.white,
                    ),
                    child: Text("A ${productProvider.countByProductTypeId(selectedProductTypeIndex).A}",style: TextStyle(color: selectedCategory == "A" ? Colors.white : Colors.green),),
                  ),
                ),
                InkWell(
                  highlightColor: Colors.transparent,
                  hoverColor: Colors.transparent,
                  splashColor: Colors.transparent,
                  onTap: () {
                    print("B");
                    if (selectedCategory == "B") {
                      setState(() {
                        selectedCategory = "";
                      });
                      String productTypeId =
                          productProvider.products[selectedProductTypeIndex].id;
                      productProvider.fetchProducts(
                        productTypeId,
                      );
                    } else {
                      setState(() {
                        selectedCategory = "B";
                      });
                      String productTypeId =
                          productProvider.products[selectedProductTypeIndex].id;
                      productProvider.fetchProducts(
                        productTypeId,
                        category: "B",
                      );
                    }
                  },
                  child: Container(
                    margin: EdgeInsets.symmetric(horizontal: 20),
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: Colors.green.shade700,
                        width: 1.5,
                      ),
                      color:
                      selectedCategory == "B"
                          ? Colors.green.shade700
                          : Colors.white,
                    ),
                    child: Text("B ${productProvider.countByProductTypeId(selectedProductTypeIndex).B}",style: TextStyle(color: selectedCategory == "B" ? Colors.white : Colors.green),),
                  ),
                ),
                InkWell(
                  highlightColor: Colors.transparent,
                  hoverColor: Colors.transparent,
                  splashColor: Colors.transparent,
                  onTap: () {
                    print("C");
                    if (selectedCategory == "C") {
                      setState(() {
                        selectedCategory = "";
                      });
                      String productTypeId =
                          productProvider.products[selectedProductTypeIndex].id;
                      productProvider.fetchProducts(
                        productTypeId,
                      );
                    } else {
                      setState(() {
                        selectedCategory = "C";
                      });
                      String productTypeId =
                          productProvider.products[selectedProductTypeIndex].id;
                      productProvider.fetchProducts(
                        productTypeId,
                        category: "C",
                      );
                    }
                  },
                  child: Container(
                    margin: EdgeInsets.symmetric(horizontal: 20),
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: Colors.green.shade700,
                        width: 1.5,
                      ),
                      color:
                      selectedCategory == "C"
                          ? Colors.green.shade700
                          : Colors.white,
                    ),
                    child: Text("C ${productProvider.countByProductTypeId(selectedProductTypeIndex).C}",style: TextStyle(color: selectedCategory == "C" ? Colors.white : Colors.green),),
                  ),
                ),
                InkWell(
                  highlightColor: Colors.transparent,
                  hoverColor: Colors.transparent,
                  splashColor: Colors.transparent,
                  onTap: () {
                    print("D");
                    if (selectedCategory == "D") {
                      setState(() {
                        selectedCategory = "";
                      });
                      String productTypeId =
                          productProvider.products[selectedProductTypeIndex].id;
                      productProvider.fetchProducts(
                        productTypeId,
                      );
                    } else {
                      setState(() {
                        selectedCategory = "D";
                      });
                      String productTypeId =
                          productProvider.products[selectedProductTypeIndex].id;
                      productProvider.fetchProducts(
                        productTypeId,
                        category: "D",
                      );
                    }
                  },
                  child: Container(
                    margin: EdgeInsets.symmetric(horizontal: 20),
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: Colors.green.shade700,
                        width: 1.5,
                      ),
                      color:
                      selectedCategory == "D"
                          ? Colors.green.shade700
                          : Colors.white,
                    ),
                    child: Text("D ${productProvider.countByProductTypeId(selectedProductTypeIndex).D}",style: TextStyle(color: selectedCategory == "D" ? Colors.white : Colors.green),),
                  ),
                ),
                InkWell(
                  highlightColor: Colors.transparent,
                  hoverColor: Colors.transparent,
                  splashColor: Colors.transparent,
                  onTap: () {
                    print("E");
                    if (selectedCategory == "E") {
                      setState(() {
                        selectedCategory = "";
                      });
                      String productTypeId =
                          productProvider.products[selectedProductTypeIndex].id;
                      productProvider.fetchProducts(
                        productTypeId,
                      );
                    } else {
                      setState(() {
                        selectedCategory = "E";
                      });
                      String productTypeId =
                          productProvider.products[selectedProductTypeIndex].id;
                      productProvider.fetchProducts(
                        productTypeId,
                        category: "E",
                      );
                    }
                  },
                  child: Container(
                    margin: EdgeInsets.symmetric(horizontal: 20),
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: Colors.green.shade700,
                        width: 1.5,
                      ),
                      color:
                      selectedCategory == "E"
                          ? Colors.green.shade700
                          : Colors.white,
                    ),
                    child: Text("E ${productProvider.countByProductTypeId(selectedProductTypeIndex).E}",style: TextStyle(color: selectedCategory == "E" ? Colors.white : Colors.green),),
                  ),
                ),
              ],
            ),
            Container(
              height: 50,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Colors.black,width: 0.7),
                //color: Colors.grey.shade100
              ),
              child: Row(
                children: [
                  Container(
                      height: 50,
                      padding: EdgeInsets.symmetric(horizontal: 10),
                      decoration: BoxDecoration(
                          color: Colors.green.shade500,
                          borderRadius:
                          BorderRadius.horizontal(left: Radius.circular(10))),
                      child: Icon(Icons.search_rounded,color: Colors.white,)
                  ),
                  Builder(
                      builder: (context) {
                        return Expanded(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            child: TextField(
                              onChanged: (value) {
                                setState(() {
                                  searchQuery = value;
                                });

                                if (searchQuery.isNotEmpty) {
                                  productProvider.searchProduct(searchQuery,productProvider.getSelectedCategory,productProvider.modelName);
                                } else {
                                  if (productProvider.getSelectedCategory.isNotEmpty) {
                                    getAllProducts();
                                  } else {
                                    // getProductByCategory(userReadList[selectedIndex]);
                                  }
                                }
                              },
                              controller: searchController,
                              textCapitalization: TextCapitalization.words,
                              decoration: InputDecoration(
                                hintText: 'Search by...',
                                hintStyle: TextStyle(
                                  color:Colors.black
                                ),
                                border: InputBorder.none,
                              ),
                            ),
                          ),
                        );
                      }
                  ),

                ],
              ),
            ),
            Expanded(
              child: LayoutBuilder(
                builder: (context, constraints) {
                  double width = constraints.maxWidth;
                  int crossAxisCount = (width / 280).floor();
                  crossAxisCount = crossAxisCount < 2 ? 2 : crossAxisCount;

                  return GridView.builder(
                    padding: EdgeInsets.all(16),
                    gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                      maxCrossAxisExtent: 320, // Maximum width per item
                      mainAxisSpacing: 16,
                      crossAxisSpacing: 16,
                      childAspectRatio: 2.0, // You can adjust height ratio
                    ),
                    itemCount: productProvider.filteredProducts.length,
                    itemBuilder: (context, index) {
                      final product = productProvider.filteredProducts[index];
                      final title = product.adTitle.last.toString();
                      final price = product.price;
                      final description = product.description.last.toString();
                     // final area = product.address1.last.toString();
                      final imageUrl =
                          product.images.isNotEmpty
                              ? '$baseUrl${product.images.first}'
                              : '';
                      return GestureDetector(
                        onTap: () {
                          navigateToProductFormScreen(
                            product.modelName,
                            product.id,
                          );
                        },
                        child: Container(
                          padding: EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: Colors.green.shade700,
                              width: 1.5,
                            ),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    if (imageUrl.isNotEmpty)
                                      ClipRRect(
                                        borderRadius: BorderRadius.circular(10),
                                        child: Image.network(
                                          imageUrl,
                                          width: 90,
                                          height: 90,
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    SizedBox(width: 10),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          if(price.isNotEmpty)
                                            Text(
                                              '₹ $price',
                                              style: TextStyle(
                                                color: Colors.green.shade800,
                                                fontSize: 14,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          SizedBox(height: 4),
                                          Text(
                                            title,
                                            overflow: TextOverflow.ellipsis,
                                            style: TextStyle(
                                              fontWeight: FontWeight.w600,
                                              fontSize: 14,
                                            ),
                                          ),
                                          SizedBox(height: 4),
                                          Expanded(
                                            child: Text(
                                              description,
                                              maxLines: 3,
                                              overflow: TextOverflow.ellipsis,
                                              style: TextStyle(
                                                fontSize: 13,
                                                color: Colors.grey[800],
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(height: 6),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void navigateToProductFormScreen(String modelName, String productId) {
    print(modelName);
    Map<String, String> args = {"productId": productId, "modelName": modelName};
    switch (modelName.toLowerCase()) {
      case "bike":
        {
          GetxNavigation.next(BikeDetailsScreen.routeName, arguments: args);
          break;
        }
      case "property":
        {
          GetxNavigation.next(PropertyDetailsScreen.routeName, arguments: args);
          // GetxNavigation.next(Property.routeName,arguments: productSubType);
          break;
        }
      case "car":
        {
          GetxNavigation.next(CarDetailsScreen.routeName, arguments: args);
          break;
        }
      case "book_sport_hobby":
        {
          GetxNavigation.next(
            BookSportsHobbyDetailsScreen.routeName,
            arguments: args,
          );
          break;
        }
      case "electronic":
        {
          GetxNavigation.next(
            ElectronicsDetailsScreen.routeName,
            arguments: args,
          );
          break;
        }
      case "furniture":
        {
          GetxNavigation.next(
            FurnitureDetailsScreen.routeName,
            arguments: args,
          );
          break;
        }
      case "job":
        {
          GetxNavigation.next(JobDetailsScreen.routeName, arguments: args);
          break;
        }
      case "pet":
        {
          GetxNavigation.next(PetDetailsScreen.routeName, arguments: args);
          break;
        }
      case "smart_phone":
        {
          GetxNavigation.next(
            SmartPhoneDetailsScreen.routeName,
            arguments: args,
          );
          // GetxNavigation.next(SmartPhone.routeName,arguments: productSubType);
          break;
        }
      case "services":
        {
          GetxNavigation.next(ServicesDetailScreen.routeName, arguments: args);
          break;
        }
      case "other":
        {
          GetxNavigation.next(OtherProductDetails.routeName, arguments: args);
          // GetxNavigation.next(OtherScreen.routeName,arguments: productSubType);
          break;
        }
      default:
        {
          Get.snackbar(
            "Oops!!!!!",
            "Something went wrong while selecting option.",
            backgroundColor: Colors.red,
            colorText: Colors.white,
            snackPosition: SnackPosition.BOTTOM,
          );
        }
    }
  }
}
