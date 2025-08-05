import 'package:admin_panel/model/user_model/user_model.dart';
import 'package:admin_panel/navigation/getX_navigation.dart';
import 'package:admin_panel/provider/access_code_provider/access_code_provider.dart';
import 'package:admin_panel/user/user_details_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../model/user_model/user_tab_model.dart';
import '../provider/user_provider/user_provider.dart';

class UserScreen extends StatefulWidget {
  static const routeName = "/user-screen";

  const UserScreen({super.key});

  @override
  State<UserScreen> createState() => _UserScreenState();
}

class _UserScreenState extends State<UserScreen>
    with SingleTickerProviderStateMixin {
  TabController? _tabController;

  @override
  void initState() {
    super.initState();
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    AccessCodeProvider accessCodeProvider = Provider.of<AccessCodeProvider>(
      context,
      listen: false,
    );
    accessCodeProvider.getAccessCode();
    userProvider.getUserCategory().then((_) {
      if (userProvider.userCategories.isNotEmpty) {
        final firstCategory = userProvider.userCategories[1];
        userProvider.getUser();
        // Create tab controller
        if (mounted) {
          setState(() {
            _tabController = TabController(
              length: userProvider.userCategories.length,
              vsync: this,
            );
          });
        }
      }
    });
  }

  @override
  void dispose() {
    _tabController?.dispose();
    super.dispose();
  }

  // Future<void> showAccessCodeDialog(UserModel user) async {
  //   //   AccessCodeProvider accessCodeProvider = Provider.of<AccessCodeProvider>(
  //   //     context,
  //   //     listen: false,
  //   //   );
  //   //   await accessCodeProvider.getAccessCode();
  //   //   showDialog(
  //   //     context: context,
  //   //     builder: (context) => StatefulBuilder(
  //   //       builder: (context, setState) => AlertDialog(
  //   //         title: const Text("Access Code List"),
  //   //         content: SizedBox(
  //   //           width: double.maxFinite,
  //   //           child: SingleChildScrollView(
  //   //             scrollDirection: Axis.vertical,
  //   //             child: Column(
  //   //               mainAxisSize: MainAxisSize.min,
  //   //               children: [
  //   //                 LayoutBuilder(
  //   //                   builder: (context, constraints) {
  //   //                     // Calculate number of columns based on available width
  //   //                     int crossAxisCount = (constraints.maxWidth / 150)
  //   //                         .floor(); // Each tile ~150px wide
  //   //                     return GridView.builder(
  //   //                       shrinkWrap: true,
  //   //                       physics: const NeverScrollableScrollPhysics(),
  //   //                       itemCount: accessCodeProvider.accessCodes.length,
  //   //                       gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
  //   //                         crossAxisCount: crossAxisCount,
  //   //                         crossAxisSpacing: 10,
  //   //                         mainAxisSpacing: 10,
  //   //                         childAspectRatio: 2,
  //   //                       ),
  //   //                       itemBuilder: (context, index) {
  //   //                         final codeItem =
  //   //                             accessCodeProvider.accessCodes[index];
  //   //                         return InkWell(
  //   //                           onTap: () {
  //   //                             Map<String,dynamic> body = {
  //   //                               "code": codeItem.code,
  //   //                               "email": user.email,
  //   //                               "userCategory": user.category,
  //   //                             };
  //   //                             accessCodeProvider.userAccess(body);
  //   //                           },
  //   //                           child: Card(
  //   //                             color: Colors.white,
  //   //                             elevation: 1,
  //   //                             child: Padding(
  //   //                               padding: const EdgeInsets.all(8.0),
  //   //                               child: Column(
  //   //                                 mainAxisAlignment: MainAxisAlignment.center,
  //   //                                 crossAxisAlignment: CrossAxisAlignment.start,
  //   //                                 children: [
  //   //                                   Text(
  //   //                                     "Code: ${codeItem.code}",
  //   //                                     style: const TextStyle(
  //   //                                       fontWeight: FontWeight.bold,
  //   //                                       fontSize: 10,
  //   //                                     ),
  //   //                                   ),
  //   //                                   //const SizedBox(height: 4),
  //   //                                   Text(
  //   //                                     "Use Count: ${codeItem.useCount}",
  //   //                                     style: const TextStyle(fontSize: 12),
  //   //                                   ),
  //   //                                   Align(
  //   //                                     alignment: Alignment.bottomRight,
  //   //                                     child: Icon(
  //   //                                       Icons.check_circle,
  //   //                                       color: Colors.grey,
  //   //                                       size: 14,
  //   //                                     ),
  //   //                                   ),
  //   //                                 ],
  //   //                               ),
  //   //                             ),
  //   //                           ),
  //   //                         );
  //   //                       },
  //   //                     );
  //   //                   },
  //   //                 ),
  //   //               ],
  //   //             ),
  //   //           ),
  //   //         ),
  //   //       ),
  //   //     ),
  //   //   );
  //   // }

  Future<void> showAccessCodeDialog(UserModel user) async {
    AccessCodeProvider accessCodeProvider = Provider.of<AccessCodeProvider>(
      context,
      listen: false,
    );
    await accessCodeProvider.getAccessCode();

    String? selectedCode;
    int cancelCount = 0;

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          title: const Text("Access Code List"),
          content: SizedBox(
            width: double.maxFinite,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Expanded(
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      int crossAxisCount = (constraints.maxWidth / 150).floor();
                      return GridView.builder(
                        shrinkWrap: true,
                        physics: const AlwaysScrollableScrollPhysics(),
                        itemCount: accessCodeProvider.accessCodes.length,
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: crossAxisCount,
                          crossAxisSpacing: 10,
                          mainAxisSpacing: 10,
                          childAspectRatio: 2,
                        ),
                        itemBuilder: (context, index) {
                          final codeItem =
                              accessCodeProvider.accessCodes[index];
                          final isSelected = selectedCode == codeItem.code;

                          return InkWell(
                            onTap: () {
                              setState(() {
                                selectedCode = isSelected
                                    ? null
                                    : codeItem.code;
                                cancelCount =
                                    0; // Reset cancel count on selection
                              });
                            },
                            child: Card(
                              color: isSelected
                                  ? Colors.green.shade100
                                  : Colors.white,
                              elevation: 2,
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Code: ${codeItem.code}",
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 10,
                                      ),
                                    ),
                                    Text(
                                      "Use Count: ${codeItem.useCount}",
                                      style: const TextStyle(fontSize: 12),
                                    ),
                                    // Align(
                                    //   alignment: Alignment.bottomRight,
                                    //   child: Icon(
                                    //     Icons.check_circle,
                                    //     color: isSelected ? Colors.green : Colors.grey,
                                    //     size: 14,
                                    //   ),
                                    // ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      );
                    },
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () {
                        setState(() {
                          if (selectedCode != null) {
                            selectedCode = null;
                            cancelCount = 1;
                          } else {
                            cancelCount++;
                            if (cancelCount >= 2) {
                              Navigator.pop(context); // Close dialog
                            }
                          }
                        });
                      },
                      child: const Text("Cancel"),
                    ),
                    const SizedBox(width: 8),
                    ElevatedButton(
                      onPressed: selectedCode != null
                          ? () {
                              Map<String, dynamic> body = {
                                "code": selectedCode,
                                "email": user.email,
                                "userCategory": user.category,
                              };
                              accessCodeProvider.userAccess(body);
                              Navigator.pop(context); // Close dialog
                            }
                          : null,
                      child: const Text("Send"),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    AccessCodeProvider accessCodeProvider = Provider.of<AccessCodeProvider>(
      context,
      listen: true,
    );
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          children: [
            Consumer<UserProvider>(
              builder: (context, userProvider, child) {
                List<UserTabModel> categories = userProvider.userCategories;

                if (categories.isEmpty || _tabController == null) {
                  return Center(child: CircularProgressIndicator());
                }
                // Make sure the tab controller is in sync with the selected category
                int selectedIndex = -1;

                // If found valid index, update the tab controller
                if (selectedIndex != -1 &&
                    _tabController!.index != selectedIndex) {
                  _tabController!.animateTo(selectedIndex);
                }

                return Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TabBar(
                      isScrollable: true,
                      controller: _tabController,
                      dividerColor: Colors.transparent,
                      splashFactory: NoSplash.splashFactory,
                      overlayColor: WidgetStateProperty.all(Colors.transparent),
                      labelColor: Colors.white,
                      // Text color for selected tab
                      unselectedLabelColor: Colors.green.shade700,
                      // Text color for unselected tabs
                      labelStyle: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                      ),
                      unselectedLabelStyle: TextStyle(fontSize: 15),
                      indicator: BoxDecoration(
                        color: Colors.green.shade700, // Selected tab background
                        borderRadius: BorderRadius.circular(12),
                      ),
                      onTap: (index) {
                        String selectedCategory = categories[index].category;
                        if (selectedCategory == "All") {
                          selectedCategory = "";
                        }
                        userProvider.setSelectedCategory(selectedCategory);
                        userProvider.getUser();
                      },
                      tabs: categories.map((category) {
                        final displayCategory = category;
                        final count = userProvider.usersByCategory.length;
                        return Tab(
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 10,
                            ),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: Colors.green.shade700,
                                width: 1.5,
                              ),
                            ),
                            child: Text(
                              "${displayCategory.category} (${displayCategory.count})",
                              textAlign: TextAlign.center,
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                    Expanded(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Wrap(
                            spacing: 10,
                            runSpacing: 10,
                            alignment: WrapAlignment.center,
                            children: [
                              _buildFilterButton(context, 'Pending'),
                              _buildFilterButton(context, 'Disabled'),
                              _buildFilterButton(context, 'Deleted'),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                );
              },
            ),
            const SizedBox(height: 10),
            Expanded(
              child: Consumer<UserProvider>(
                builder: (context, userProvider, _) {
                  final users = userProvider.usersByCategory;
                  if (userProvider.isLoading) {
                    return Center(child: CircularProgressIndicator());
                  }
                  if (users.isEmpty) {
                    return Center(child: Text("No users found"));
                  }

                  return ListView.builder(
                    itemCount: users.length,
                    itemBuilder: (context, index) {
                      final user = users[index];
                      return InkWell(
                        onTap: () {
                          GetxNavigation.next(
                            UserDetailsScreen.routeName,
                            arguments: user.id,
                          );
                        },
                        child: Container(
                          margin: EdgeInsets.symmetric(vertical: 10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  CircleAvatar(
                                    radius: 30,
                                    backgroundColor: Colors.grey,
                                    backgroundImage:
                                        user.profilePicture.last
                                            .toString()
                                            .isNotEmpty
                                        ? NetworkImage(
                                            "https://api.bhavnika.shop${user.profilePicture.last.toString()}",
                                          )
                                        : null,
                                    child:
                                        user.profilePicture.last
                                            .toString()
                                            .isEmpty
                                        ? Icon(Icons.person)
                                        : null,
                                  ),
                                  SizedBox(width: 20),
                                  Text(
                                    "${user.fName.last.toString()} ${user.lName.last.toString()} ",
                                  ),
                                ],
                              ),
                              Container(
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    // Active/Inactive button
                                    /*SizedBox(
                                      width: 100,
                                      child: IconButton(
                                        onPressed: () async {
                                          await Provider.of<UserProvider>(context, listen: false)
                                              .userActiveInactive('${user.id}');
                                          setState(() {
                                            user.isActive = !user.isActive;
                                          });
                                        },
                                        icon: Icon(
                                          user.isActive ? Icons.visibility : Icons.visibility_off,
                                          color: user.isActive ? Colors.green : Colors.red,
                                        ),
                                      ),
                                    ),*/
                                    SizedBox(
                                      width: 100,
                                      child: Consumer<UserProvider>(
                                        builder:
                                            (context, userProvider, child) =>
                                                IconButton(
                                                  onPressed: () async {
                                                    bool success =
                                                        await userProvider
                                                            .userActiveInactive(
                                                              '${user.id}',
                                                            );
                                                    if (success) {
                                                      setState(() {
                                                        user.isActive =
                                                            !user.isActive;
                                                      });
                                                    }
                                                  },
                                                  icon: Icon(
                                                    user.isActive
                                                        ? Icons.visibility
                                                        : Icons.visibility_off,
                                                    color: user.isActive
                                                        ? Colors.green
                                                        : Colors.red,
                                                  ),
                                                ),
                                      ),
                                    ),

                                    // Verify/Unverified button
                                    SizedBox(
                                      width: 100,
                                      child: TextButton(
                                        onPressed: () async {
                                          if ((user.category == 'A' ||
                                                  user.category == 'α') &&
                                              !user.isPinVerified) {
                                            showAccessCodeDialog(
                                              user,
                                            ); // Send/show PIN
                                          } else if ((user.category == 'B' ||
                                                  user.category == 'β') &&
                                              !user.isOtpVerified) {
                                            Map<String, dynamic> body = {
                                              "email": user.email,
                                              "userCategory": user.category,
                                            };
                                            accessCodeProvider.userAccess(body);
                                          }
                                        },
                                        child: Text(
                                          (user.category == 'A' ||
                                                  user.category == 'α')
                                              ? (user.isPinVerified
                                                    ? 'Verify'
                                                    : 'Pending')
                                              : (user.isOtpVerified
                                                    ? 'Verify'
                                                    : 'Pending'),
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            color:
                                                ((user.category == 'A' ||
                                                        user.category == 'α')
                                                    ? user.isPinVerified
                                                    : user.isOtpVerified)
                                                ? Colors.green
                                                : Colors.red,
                                          ),
                                        ),
                                      ),
                                    ),
                                    // Delete button
                                    user.isDeleted
                                        ? SizedBox(
                                            width: 100,
                                            child: IconButton(
                                              icon: Icon(
                                                Icons.restore_outlined,
                                                color: Colors.grey,
                                              ),
                                              onPressed: () async {
                                                bool?
                                                confirm = await showDialog(
                                                  context: context,
                                                  builder: (context) => AlertDialog(
                                                    title: const Text(
                                                      "Confirm Restore",
                                                    ),
                                                    content: const Text(
                                                      "Are you sure you want to Restore this user?",
                                                    ),
                                                    actions: [
                                                      TextButton(
                                                        onPressed: () {
                                                          Navigator.of(
                                                            context,
                                                          ).pop(false);
                                                        },
                                                        child: const Text(
                                                          "Cancel",
                                                        ),
                                                      ),
                                                      ElevatedButton(
                                                        style:
                                                            ElevatedButton.styleFrom(
                                                              backgroundColor:
                                                                  Colors.green,
                                                            ),
                                                        onPressed: () async {
                                                          await userProvider
                                                              .deleteUser(
                                                                '${user.id}',
                                                              );
                                                        },
                                                        child: const Text(
                                                          "Restore",
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                );
                                              },
                                            ),
                                          )
                                        : SizedBox(
                                            width: 100,
                                            child: IconButton(
                                              icon: Icon(
                                                Icons.delete,
                                                color: Colors.red,
                                              ),
                                              onPressed: () async {
                                                bool?
                                                confirm = await showDialog(
                                                  context: context,
                                                  builder: (context) => AlertDialog(
                                                    title: const Text(
                                                      "Confirm Deletion",
                                                    ),
                                                    content: const Text(
                                                      "Are you sure you want to delete this user?",
                                                    ),
                                                    actions: [
                                                      TextButton(
                                                        onPressed: () {
                                                          Navigator.of(
                                                            context,
                                                          ).pop(false);
                                                        },
                                                        child: const Text(
                                                          "Cancel",
                                                        ),
                                                      ),
                                                      ElevatedButton(
                                                        style:
                                                            ElevatedButton.styleFrom(
                                                              backgroundColor:
                                                                  Colors.red,
                                                            ),
                                                        onPressed: () async {
                                                          await userProvider
                                                              .deleteUser(
                                                                '${user.id}',
                                                              );
                                                          // Navigator.of(context).pop(true);
                                                        },
                                                        child: const Text(
                                                          "Delete",
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                );
                                              },
                                            ),
                                          ),
                                  ],
                                ),
                              ),
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

  Widget _buildFilterButton(BuildContext context, String label) {
    final userProvider = Provider.of<UserProvider>(context);
    final isSelected = userProvider.statusFilter == label;
    var count = 0;
    int pendingCount = 0;
    for (var user in userProvider.usersByCategory) {
      if (!user.isPinVerified || !user.isOtpVerified) {
        print(user.email);
        pendingCount++;
      }
    }
    int disabledCount = 0;
    for (var user in userProvider.usersByCategory) {
      if (!user.isActive) {
        disabledCount++;
      }
    }
    int deletedCount = 0;
    for (var user in userProvider.usersByCategory) {
      if (user.isDeleted) {
        deletedCount++;
      }
    }
    switch (label) {
      case 'Pending':
        count = pendingCount;
        break;
      case 'Disabled':
        count = disabledCount;
        break;
      case 'Deleted':
        count = deletedCount;
        break;
      default:
        count = 0; // Default case if label doesn't match
    }
    return TextButton(
      onPressed: () {
        final newVal = isSelected ? '' : label;
        userProvider.setStatusFilter(newVal);
        userProvider.getUser();
      },
      style: TextButton.styleFrom(
        backgroundColor: isSelected ? Colors.green.shade700 : Colors.white,
        foregroundColor: isSelected ? Colors.white : Colors.green.shade700,
        side: BorderSide(color: Colors.green.shade700),
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
      child: Text("$label ($count)"),
    );
  }
}
