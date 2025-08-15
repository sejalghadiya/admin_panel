import 'package:admin_panel/app_version/add_app_version_dialog.dart';
import 'package:admin_panel/app_version/app_version_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AppVersion extends StatefulWidget {
  static const routeName = "/app-version";

  const AppVersion({super.key});

  @override
  State<AppVersion> createState() => _AppVersionState();
}

class _AppVersionState extends State<AppVersion> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Future.microtask(() {
      Provider.of<AppVersionProvider>(
        context,
        listen: false,
      ).getAllAppVersion();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("App Versions"),
        centerTitle: true,
        leading: Container(),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: InkWell(
              onTap: () {
                // Add your create version logic here
                print("Create Version button pressed");
                showDialog(
                  context: context,
                  builder: (context) {
                    return AddAppVersionDialog();
                  },
                );
              },
              child: Container(
                padding: const EdgeInsets.all(0),
                // width: 100,
                // height: 50,
                decoration: BoxDecoration(
                  color: Colors.green,
                  borderRadius: BorderRadius.circular(10),
                  shape: BoxShape.rectangle,
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      const Icon(Icons.add, color: Colors.white),
                      const Text(
                        "Create Version",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: IconButton(
              icon: const Icon(Icons.refresh),
              onPressed: () {
                // Add your refresh logic here
                print("Refresh button pressed");
              },
            ),
          ),
          // add version create button using container
        ],
      ),
      body: Consumer<AppVersionProvider>(
        builder: (context, appVersionProvider, child) {
          return SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: DataTable(
              columns: const [
                DataColumn(label: Text('Version Name')),
                DataColumn(label: Text('Version Number')),
                DataColumn(label: Text('Release Date')),
                DataColumn(label: Text('APK Link')),
                DataColumn(label: Text('Changes')),
                DataColumn(label: Text('Active')),
                DataColumn(label: Text('Update')),
              ],
              rows: appVersionProvider.appVersions.map((appVersion) {
                return DataRow(
                  cells: [
                    DataCell(Text(appVersion.versionName)),
                    DataCell(Text(appVersion.versionNumber.toString())),
                    DataCell(
                      Text(
                        appVersion.releaseDate.toLocal().toString().split(
                          ' ',
                        )[0],
                      ),
                    ),
                    DataCell(Text(appVersion.apkLink)),
                    DataCell(Text(appVersion.changes)),
                    DataCell(
                      Icon(
                        appVersion.isActive ? Icons.check_circle : Icons.cancel,
                        color: appVersion.isActive ? Colors.green : Colors.red,
                      ),
                    ),
                    DataCell(
                      IconButton(
                        icon: const Icon(Icons.edit, color: Colors.blue),
                        onPressed: () {
                          // TODO: Implement update logic or show update dialog
                          print(
                            'Update pressed for version: \\${appVersion.versionName}',
                          );
                        },
                      ),
                    ),
                  ],
                );
              }).toList(),
            ),
          );
        },
      ),
    );
  }
}
