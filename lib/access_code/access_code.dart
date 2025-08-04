import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../model/access_code_model/access_code_model.dart';
import '../navigation/getX_navigation.dart';
import '../provider/access_code_provider/access_code_provider.dart';
import '../user/user_details_screen.dart';

class AccessCode extends StatefulWidget {
  const AccessCode({super.key});

  @override
  State<AccessCode> createState() => _AccessCodeState();
}

class _AccessCodeState extends State<AccessCode> {
  String searchQuery = '';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<AccessCodeProvider>(context, listen: false).getAccessCode();
    });
  }

  void showUserDialog(BuildContext context, List<dynamic> users) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.white,
        title: Text("Users with this PIN"),
        content: SizedBox(
          width: double.maxFinite,
          child: users.isEmpty
              ? Center(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.info_outline,
                          size: 48,
                          color: Colors.orangeAccent,
                        ),
                        SizedBox(height: 12),
                        Text(
                          "This PIN has not been used by any user yet!",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Colors.black54,
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              : ListView.builder(
                  shrinkWrap: true,
                  itemCount: users.length,
                  itemBuilder: (context, index) {
                    final user = users[index];
                    return InkWell(
                      onTap: () {
                        Navigator.pop(context); // Close the dialog
                        print("User tapped: ${user['_id']}");
                        GetxNavigation.next(
                          UserDetailsScreen.routeName,
                          arguments: user['_id'],
                        );

                        // Handle user tap if needed
                      },
                      child: Card(
                        color: Colors.white,
                        elevation: 2,
                        margin: const EdgeInsets.symmetric(vertical: 6),
                        child: ListTile(
                          title: Text(
                            "User Name: ${user['fName'][0]} ${user['mName'][0] ?? ''} ${user['lName'][0]}"
                                .trim(),
                            style: TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.bold,
                              color: Colors.green,
                            ),
                          ),
                          subtitle: Text(
                            "User Email${user['email'] ?? 'No Email'}",
                            style: TextStyle(fontSize: 17),
                          ),
                          trailing: Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                user['phone']?[0] ?? '',
                                style: TextStyle(fontSize: 15),
                              ),
                              SizedBox(height: 4),
                              Text(
                                "${user['area']?[0] ?? ''}, ${user['city']?[0] ?? ''}, ${user['state']?[0] ?? ''} - ${user['pinCode']?[0] ?? ''}",
                                textAlign: TextAlign.end,
                                style: TextStyle(fontSize: 13),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text("Close"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              decoration: InputDecoration(
                hintText: "Search Access Code...",
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onChanged: (value) {
                setState(() {
                  searchQuery = value;
                });
              },
            ),
            SizedBox(height: 12),
            Text(
              "Access Code",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Expanded(
              child: Consumer<AccessCodeProvider>(
                builder: (context, accessCodeProvider, child) {
                  if (accessCodeProvider.isLoading) {
                    return Center(child: CircularProgressIndicator());
                  }

                  // 🔽 Sort and filter
                  List<AccessCodeModel> sortedCodes = List.from(
                    accessCodeProvider.accessCodes,
                  );
                  sortedCodes.sort((a, b) => b.useCount.compareTo(a.useCount));
                  if (searchQuery.isNotEmpty) {
                    sortedCodes = sortedCodes
                        .where(
                          (code) => code.code.toLowerCase().contains(
                            searchQuery.toLowerCase(),
                          ),
                        )
                        .toList();
                  }

                  return ListView.builder(
                    itemCount: sortedCodes.length,
                    itemBuilder: (context, index) {
                      final code = sortedCodes[index];
                      return Card(
                        color: Colors.white,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Wrap(
                            spacing: 10,
                            runSpacing: 10,
                            crossAxisAlignment: WrapCrossAlignment.start,
                            alignment: WrapAlignment.spaceBetween,
                            children: [
                              Text(
                                "${index + 1}",
                                textAlign: TextAlign.start,
                                style: TextStyle(
                                  fontSize: 16,
                                  fontFeatures: [FontFeature.tabularFigures()],
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                "Code: ${code.code}",
                                textAlign: TextAlign.start,
                                style: TextStyle(
                                  fontFeatures: [FontFeature.tabularFigures()],
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              Text(
                                "Use Count: ${code.useCount}",
                                textAlign: TextAlign.start,
                                style: TextStyle(
                                  fontFeatures: [FontFeature.tabularFigures()],
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              Text(
                                "Remaining Count: ${code.maxUseCount - code.useCount}",
                                textAlign: TextAlign.start,
                                style: TextStyle(
                                  fontFeatures: [FontFeature.tabularFigures()],
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              InkWell(
                                onTap: () async {
                                  final accessCodeProv =
                                      Provider.of<AccessCodeProvider>(
                                        context,
                                        listen: false,
                                      );
                                  final users = await accessCodeProv
                                      .getUserByAccessCode(code.code);

                                  print(
                                    "Code: ${code.code} => Users found: ${users?.length ?? 0}",
                                  );

                                  if (!context.mounted) return;

                                  showUserDialog(context, users ?? []);
                                },
                                child: Text(
                                  "Use Pin View",
                                  textAlign: TextAlign.start,
                                  style: TextStyle(
                                    fontFeatures: [
                                      FontFeature.tabularFigures(),
                                    ],
                                    fontSize: 16,
                                  ),
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
}

/*class _AccessCodeState extends State<AccessCode> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<AccessCodeProvider>(context, listen: false).getAccessCode();
    });
  }


  void showUserDialog(BuildContext context, List<dynamic> users) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Users with this PIN"),
        content: SizedBox(
          width: double.maxFinite,
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: users.length,
            itemBuilder: (context, index) {
              final user = users[index];
              return Card(
                elevation: 2,
                margin: const EdgeInsets.symmetric(vertical: 6),
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundImage: NetworkImage(
                      "http://yourdomain.com${user['profileImage'][0]}",
                    ),
                  ),
                  title: Text(
                    "${user['fName'][0]} ${user['mName'][0] ?? ''} ${user['lName'][0]}".trim(),
                  ),
                  subtitle: Text(user['email'] ?? 'No Email'),
                  trailing: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(user['phone'][0]),
                      Text(user['state'][0]),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text("Close"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Text("Access Code"),
            Expanded(
              child: Consumer<AccessCodeProvider>(
                builder: (context, accessCodeProvider, child) {
                  if (accessCodeProvider.isLoading) {
                    return Center(child: CircularProgressIndicator());
                  }
                  return ListView.builder(
                    itemCount: accessCodeProvider.accessCodes.length,
                    itemBuilder: (context, index) {
                      // show data code,useCount,maxUseCount and index for number
                      return Card(
                        color: Colors.white,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                spacing: 5,
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "${index + 1}",
                                    style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    "Code: ${accessCodeProvider.accessCodes[index].code}",
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  Text(
                                    "Use Count: ${accessCodeProvider.accessCodes[index].useCount}",
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  Text(
                                    "Max Use Count: ${accessCodeProvider.accessCodes[index].maxUseCount}",
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                              InkWell(
                                onTap: () async {
                                  final accessCode = accessCodeProvider.accessCodes[index].code;
                                  final accessCodeProv = Provider.of<AccessCodeProvider>(context, listen: false);
                                  sortedCodes.sort((a, b) {
                                    // Used pins first
                                    return b.useCount.compareTo(a.useCount);
                                  });
                                  // Step 1: Call the API
                                  final users = await accessCodeProv.getUserByAccessCode(accessCode);

                                  // Step 2: Ensure context is still valid
                                  if (!context.mounted) return;

                                  // Step 3: Show dialog with user IDs
                                  showDialog(
                                    context: context,
                                    builder: (_) => AlertDialog(
                                      backgroundColor: Colors.white,
                                      title: Text("Assign Pin Users"),
                                      content: SizedBox(
                                        width: double.maxFinite,
                                        child: (users == null || users.isEmpty)
                                            ? Center(
                                          child: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Text(
                                              "No assigned PINs found.",
                                              style: TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.w500,
                                                color: Colors.redAccent,
                                              ),
                                            ),
                                          ),
                                        )
                                            : ListView.builder(
                                          shrinkWrap: true,
                                          itemCount: users.length,
                                          itemBuilder: (context, index) {
                                            final user = users[index];
                                            return Card(
                                              color: Colors.white,
                                              elevation: 2,
                                              margin: const EdgeInsets.symmetric(vertical: 8),
                                              shape: RoundedRectangleBorder(
                                                borderRadius: BorderRadius.circular(12),
                                              ),
                                              child: Padding(
                                                padding: const EdgeInsets.all(16.0),
                                                child: Row(
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    Icon(Icons.person, size: 30, color: Colors.blueAccent),
                                                    SizedBox(width: 12),
                                                    Expanded(
                                                      child: Column(
                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                        children: [
                                                          Text(
                                                            "#${index + 1}",
                                                            style: TextStyle(
                                                              fontWeight: FontWeight.bold,
                                                              fontSize: 14,
                                                              color: Colors.deepPurple,
                                                            ),
                                                          ),
                                                          SizedBox(height: 6),
                                                          Text(
                                                            "ID: ${user['_id'] ?? 'N/A'}",
                                                            style: TextStyle(
                                                              fontWeight: FontWeight.w600,
                                                              fontSize: 14,
                                                              color: Colors.grey[700],
                                                            ),
                                                          ),
                                                          SizedBox(height: 6),
                                                          Text(
                                                            "Name: ${user['fName']?[0] ?? ''} ${user['lName']?[0] ?? ''}",
                                                            style: TextStyle(
                                                              fontSize: 16,
                                                              fontWeight: FontWeight.bold,
                                                              color: Colors.black87,
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
                                        ),
                                      ),
                                      actions: [
                                        TextButton(
                                          onPressed: () => Navigator.pop(context),
                                          child: Text("Close"),
                                        ),
                                      ],
                                    ),
                                  );


                                },
                                child: Text(
                                  "Use Pin View",
                                  style: TextStyle(fontSize: 16),
                                ),
                              )


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
}*/
