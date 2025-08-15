import 'package:admin_panel/app_version/app_version_model.dart';
import 'package:admin_panel/app_version/app_version_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AddAppVersionDialog extends StatefulWidget {
  const AddAppVersionDialog({super.key});

  @override
  State<AddAppVersionDialog> createState() => _AddAppVersionDialogState();
}

class _AddAppVersionDialogState extends State<AddAppVersionDialog> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _versionNameController = TextEditingController();
  final TextEditingController _versionCodeController = TextEditingController();
  final TextEditingController _releaseNotesController = TextEditingController();
  final TextEditingController _releaseAppLinkController =
      TextEditingController();
  InputBorder? inputBorder = OutlineInputBorder(
    borderRadius: BorderRadius.circular(7),
    borderSide: BorderSide(color: Colors.green),
  );

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("Add App Version"),
      content: SizedBox(
        width: 300,
        child: Form(
          key: _formKey,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          child: SingleChildScrollView(
            child: Column(
              spacing: 8,
              children: [
                TextFormField(
                  controller: _versionNameController,
                  cursorColor: Colors.black,
                  decoration: InputDecoration(
                    labelText: "Version Name",
                    labelStyle: const TextStyle(
                      fontSize: 16,
                      color: Colors.black,
                    ),
                    border: inputBorder,
                    enabledBorder: inputBorder,
                    focusedBorder: inputBorder,
                    filled: true,
                    fillColor: Colors.white,
                    hintStyle: TextStyle(fontSize: 16),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Please enter version name";
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _versionCodeController,
                  cursorColor: Colors.black,
                  decoration: InputDecoration(
                    labelText: "Version NUmber",
                    labelStyle: const TextStyle(
                      fontSize: 16,
                      color: Colors.black,
                    ),
                    border: inputBorder,
                    enabledBorder: inputBorder,
                    focusedBorder: inputBorder,
                    filled: true,
                    fillColor: Colors.white,
                    hintStyle: TextStyle(fontSize: 16),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Please enter version number";
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _releaseNotesController,
                  cursorColor: Colors.black,
                  decoration: InputDecoration(
                    labelText: "Release Notes",
                    labelStyle: const TextStyle(
                      fontSize: 16,
                      color: Colors.black,
                    ),
                    border: inputBorder,
                    enabledBorder: inputBorder,
                    focusedBorder: inputBorder,
                    filled: true,
                    fillColor: Colors.white,
                    hintStyle: TextStyle(fontSize: 16),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Please enter release notes";
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _releaseAppLinkController,
                  cursorColor: Colors.black,
                  decoration: InputDecoration(
                    labelText: "App Link",
                    labelStyle: const TextStyle(
                      fontSize: 16,
                      color: Colors.black,
                    ),
                    border: inputBorder,
                    enabledBorder: inputBorder,
                    focusedBorder: inputBorder,
                    filled: true,
                    fillColor: Colors.white,
                    hintStyle: TextStyle(fontSize: 16),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Please enter app link";
                    }
                    return null;
                  },
                ),
              ],
            ),
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text("Cancel"),
        ),
        ElevatedButton(
          onPressed: () {
            if (_formKey.currentState!.validate()) {
              // Here you can handle the save action, e.g., send data to the server
              print("Version Name: ${_versionNameController.text}");
              print("Version Number: ${_versionCodeController.text}");
              print("Release Notes: ${_releaseNotesController.text}");
              print("App Link: ${_releaseAppLinkController.text}");

              AppVersionProvider appVersionProvider =
              Provider.of<AppVersionProvider>(context, listen: false);
              appVersionProvider.createAppVersion(
                AppVersionModel(
                  id: "",
                  versionNumber: _versionCodeController.text,
                  versionName: _versionNameController.text,
                  releaseDate: DateTime.now(),
                  apkLink: _releaseAppLinkController.text,
                  changes: _releaseNotesController.text,
                  isActive: true,
                ),
              );
            }
          },
          child: const Text("Save"),
        ),
      ],
    );
  }
}
