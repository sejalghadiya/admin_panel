import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../model/about_us_model.dart';
import '../provider/about_us_provider.dart';

class AboutUsScreen extends StatefulWidget {
  static const String routeName = '/about-us';
  const AboutUsScreen({super.key});

  @override
  State<AboutUsScreen> createState() => _AboutUsScreenState();
}

class _AboutUsScreenState extends State<AboutUsScreen> {
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = true;

  // Text editing controllers
  final _nameController = TextEditingController();
  final _tagLineController = TextEditingController();
  final _ourMissionController = TextEditingController();
  final _ourStoryController = TextEditingController();
  final _happyCustomerController = TextEditingController();
  final _productsController = TextEditingController();
  final _satisfactionController = TextEditingController();

  // Controllers for values (will be dynamically managed)
  List<Map<String, TextEditingController>> _valueControllers = [];

  @override
  void initState() {
    super.initState();

    // Use Future.microtask to ensure this runs after the build cycle
    Future.microtask(() {
      final aboutUsProvider = Provider.of<AboutUsProvider>(context, listen: false);
      aboutUsProvider.fetchAboutUs().then((_) {
        if (!mounted) return;

        final aboutUs = aboutUsProvider.aboutUs;
        if (aboutUs != null) {
          setState(() {
            _nameController.text = aboutUs.name;
            _tagLineController.text = aboutUs.tagLine;
            _ourMissionController.text = aboutUs.ourMission;
            _ourStoryController.text = aboutUs.ourStory;
            _happyCustomerController.text = aboutUs.happyCustomer.toString();
            _productsController.text = aboutUs.products.toString();
            _satisfactionController.text = aboutUs.satisfaction.toString();

            // Initialize controllers for values
            _valueControllers = aboutUs.ourValues.map((value) {
              return {
                'icon': TextEditingController(text: value.icon),
                'title': TextEditingController(text: value.title),
                'description': TextEditingController(text: value.description),
              };
            }).toList();

            _isLoading = false;
          });
        } else {
          setState(() {
            _isLoading = false;
          });
        }
      });
    });
  }

  @override
  void dispose() {
    _nameController.dispose();
    _tagLineController.dispose();
    _ourMissionController.dispose();
    _ourStoryController.dispose();
    _happyCustomerController.dispose();
    _productsController.dispose();
    _satisfactionController.dispose();

    // Dispose all value controllers
    for (var controllers in _valueControllers) {
      controllers.forEach((_, controller) => controller.dispose());
    }

    super.dispose();
  }

  Future<void> _saveForm() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final aboutUsProvider = Provider.of<AboutUsProvider>(context, listen: false);
    final currentAboutUs = aboutUsProvider.aboutUs;

    if (currentAboutUs != null) {
      // Update the model with form values
      final updatedAboutUs = AboutUsModel(
        id: currentAboutUs.id,
        name: _nameController.text,
        tagLine: _tagLineController.text,
        ourMission: _ourMissionController.text,
        ourStory: _ourStoryController.text,
        happyCustomer: int.tryParse(_happyCustomerController.text) ?? 0,
        products: int.tryParse(_productsController.text) ?? 0,
        satisfaction: int.tryParse(_satisfactionController.text) ?? 0,
        ourValues: List.generate(_valueControllers.length, (index) {
          final valueId = index < currentAboutUs.ourValues.length
              ? currentAboutUs.ourValues[index].id
              : DateTime.now().millisecondsSinceEpoch.toString() + index.toString();

          return OurValueModel(
            id: valueId,
            icon: _valueControllers[index]['icon']!.text,
            title: _valueControllers[index]['title']!.text,
            description: _valueControllers[index]['description']!.text,
          );
        }),
        createdAt: currentAboutUs.createdAt,
        updatedAt: currentAboutUs.updatedAt,
      );

      // Save to API
      final success = await aboutUsProvider.updateAboutUs(updatedAboutUs);

      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('About Us updated successfully!')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: ${aboutUsProvider.error}')),
        );
      }
    }
  }

  void _addNewValue() {
    setState(() {
      _valueControllers.add({
        'icon': TextEditingController(),
        'title': TextEditingController(),
        'description': TextEditingController(),
      });
    });
  }

  void _removeValue(int index) {
    setState(() {
      // First dispose the controllers
      _valueControllers[index].forEach((_, controller) => controller.dispose());
      _valueControllers.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('About Us Management'),
        actions: [
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: _saveForm,
            tooltip: 'Save Changes',
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Consumer<AboutUsProvider>(
              builder: (ctx, aboutUsProvider, _) {
                if (aboutUsProvider.isLoading) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (aboutUsProvider.aboutUs == null) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          aboutUsProvider.error.isNotEmpty
                              ? 'Error: ${aboutUsProvider.error}'
                              : 'No about us data found.',
                          style: TextStyle(color: Theme.of(context).colorScheme.error),
                        ),
                        const SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: () {
                            setState(() => _isLoading = true);
                            aboutUsProvider.fetchAboutUs().then((_) {
                              setState(() => _isLoading = false);
                            });
                          },
                          child: const Text('Retry'),
                        ),
                      ],
                    ),
                  );
                }

                return Form(
                  key: _formKey,
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(16.0),
                    child: LayoutBuilder(
                      builder: (context, constraints) {
                        // Responsive design - adjust layout based on width
                        bool isWideScreen = constraints.maxWidth > 900;

                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Company Information Section
                            _buildSectionTitle('Company Information'),
                            if (isWideScreen)
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Expanded(
                                    child: _buildTextField(
                                      _nameController,
                                      'Company Name',
                                      'Enter company name',
                                      maxLines: 1,
                                    ),
                                  ),
                                  const SizedBox(width: 16),
                                  Expanded(
                                    child: _buildTextField(
                                      _tagLineController,
                                      'Tag Line',
                                      'Enter company tagline',
                                      maxLines: 1,
                                    ),
                                  ),
                                ],
                              )
                            else
                              Column(
                                children: [
                                  _buildTextField(
                                    _nameController,
                                    'Company Name',
                                    'Enter company name',
                                    maxLines: 1,
                                  ),
                                  const SizedBox(height: 16),
                                  _buildTextField(
                                    _tagLineController,
                                    'Tag Line',
                                    'Enter company tagline',
                                    maxLines: 1,
                                  ),
                                ],
                              ),

                            const SizedBox(height: 24),

                            // Company Mission & Story
                            _buildSectionTitle('Mission & Story'),
                            _buildTextField(
                              _ourMissionController,
                              'Our Mission',
                              'Enter company mission',
                              maxLines: 3,
                            ),
                            const SizedBox(height: 16),
                            _buildTextField(
                              _ourStoryController,
                              'Our Story',
                              'Enter company story',
                              maxLines: 5,
                            ),

                            const SizedBox(height: 24),

                            // Statistics Section
                            _buildSectionTitle('Statistics'),
                            if (isWideScreen)
                              Row(
                                children: [
                                  Expanded(
                                    child: _buildTextField(
                                      _happyCustomerController,
                                      'Happy Customers',
                                      'Enter number of happy customers',
                                      isNumber: true,
                                    ),
                                  ),
                                  const SizedBox(width: 16),
                                  Expanded(
                                    child: _buildTextField(
                                      _productsController,
                                      'Products',
                                      'Enter number of products',
                                      isNumber: true,
                                    ),
                                  ),
                                  const SizedBox(width: 16),
                                  Expanded(
                                    child: _buildTextField(
                                      _satisfactionController,
                                      'Satisfaction (%)',
                                      'Enter satisfaction percentage',
                                      isNumber: true,
                                    ),
                                  ),
                                ],
                              )
                            else
                              Column(
                                children: [
                                  _buildTextField(
                                    _happyCustomerController,
                                    'Happy Customers',
                                    'Enter number of happy customers',
                                    isNumber: true,
                                  ),
                                  const SizedBox(height: 16),
                                  _buildTextField(
                                    _productsController,
                                    'Products',
                                    'Enter number of products',
                                    isNumber: true,
                                  ),
                                  const SizedBox(height: 16),
                                  _buildTextField(
                                    _satisfactionController,
                                    'Satisfaction (%)',
                                    'Enter satisfaction percentage',
                                    isNumber: true,
                                  ),
                                ],
                              ),

                            const SizedBox(height: 24),

                            // Our Values Section
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                _buildSectionTitle('Our Values'),
                                ElevatedButton.icon(
                                  onPressed: _addNewValue,
                                  icon: const Icon(Icons.add),
                                  label: const Text('Add Value'),
                                ),
                              ],
                            ),

                            const SizedBox(height: 8),

                            // Values List
                            ..._buildValuesList(isWideScreen),

                            const SizedBox(height: 32),

                            // Submit Button
                            Center(
                              child: ElevatedButton(
                                onPressed: _saveForm,
                                style: ElevatedButton.styleFrom(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 40,
                                    vertical: 12,
                                  ),
                                  textStyle: const TextStyle(fontSize: 16),
                                ),
                                child: const Text('Save Changes'),
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                  ),
                );
              },
            ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildTextField(
    TextEditingController controller,
    String label,
    String hint, {
    int maxLines = 1,
    bool isNumber = false,
  }) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      maxLines: maxLines,
      keyboardType: isNumber ? TextInputType.number : TextInputType.text,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter $label';
        }
        if (isNumber && int.tryParse(value) == null) {
          return 'Please enter a valid number';
        }
        return null;
      },
    );
  }

  List<Widget> _buildValuesList(bool isWideScreen) {
    return List.generate(
      _valueControllers.length,
      (index) => Card(
        margin: const EdgeInsets.symmetric(vertical: 8.0),
        elevation: 2,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Value ${index + 1}',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    onPressed: () => _removeValue(index),
                    tooltip: 'Remove Value',
                  ),
                ],
              ),
              const SizedBox(height: 8),
              if (isWideScreen)
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: _buildTextField(
                        _valueControllers[index]['icon']!,
                        'Icon Name',
                        'Enter icon name',
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      flex: 2,
                      child: _buildTextField(
                        _valueControllers[index]['title']!,
                        'Title',
                        'Enter value title',
                      ),
                    ),
                  ],
                )
              else
                Column(
                  children: [
                    _buildTextField(
                      _valueControllers[index]['icon']!,
                      'Icon Name',
                      'Enter icon name',
                    ),
                    const SizedBox(height: 16),
                    _buildTextField(
                      _valueControllers[index]['title']!,
                      'Title',
                      'Enter value title',
                    ),
                  ],
                ),
              const SizedBox(height: 16),
              _buildTextField(
                _valueControllers[index]['description']!,
                'Description',
                'Enter value description',
                maxLines: 3,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
