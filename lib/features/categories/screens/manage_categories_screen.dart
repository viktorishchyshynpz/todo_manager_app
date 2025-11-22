import 'dart:math';
import 'package:flutter/material.dart';
import '../../../l10n/app_localizations.dart';
import '../../../core/services/analytics_service.dart';
import '../../../core/validators/content_validator.dart';

class ManageCategoriesScreen extends StatefulWidget {
  const ManageCategoriesScreen({super.key});

  @override
  State<ManageCategoriesScreen> createState() => _ManageCategoriesScreenState();
}

class _ManageCategoriesScreenState extends State<ManageCategoriesScreen> {
  // Список ініціалізуємо порожнім
  List<String> _categories = [];
  // Прапорець, щоб ініціалізація відбулася лише один раз
  bool _isInitialized = false;

  final AnalyticsService _analytics = AnalyticsService.instance;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Ініціалізуємо список тут, де доступний context і AppLocalizations
    if (!_isInitialized) {
      _categories = [
        AppLocalizations.of(context)!.categoryWork,
        AppLocalizations.of(context)!.categoryStudy,
        AppLocalizations.of(context)!.categoryHome,
      ];
      _isInitialized = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text(
          l10n.manageCategories,
          style: const TextStyle(fontWeight: FontWeight.w700),
        ),
      ),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final width = constraints.maxWidth;
            final height = constraints.maxHeight;
            final minSide = min(width, height);

            return Padding(
              padding: EdgeInsets.symmetric(
                horizontal: width * 0.06,
                vertical: height * 0.02,
              ),
              child: ListView.builder(
                itemCount: _categories.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: EdgeInsets.only(bottom: height * 0.015),
                    child: _buildCategoryItem(
                      context,
                      _categories[index],
                      width,
                      height,
                      minSide,
                    ),
                  );
                },
              ),
            );
          },
        ),
      ),
      floatingActionButton: LayoutBuilder(
        builder: (context, constraints) {
          final minSide = min(constraints.maxWidth, constraints.maxHeight);
          return FloatingActionButton(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            onPressed: () {
              _showAddCategoryDialog(l10n);
            },
            child: Icon(
              Icons.add,
              size: minSide * 0.08,
            ),
          );
        },
      ),
    );
  }

  Widget _buildCategoryItem(
      BuildContext context,
      String categoryName,
      double width,
      double height,
      double minSide,
      ) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final borderColor = theme.brightness == Brightness.light
        ? Colors.black
        : colorScheme.onSurface;

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: borderColor,
          width: 1.5,
        ),
      ),
      padding: EdgeInsets.symmetric(
        horizontal: width * 0.05,
        vertical: height * 0.02,
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              categoryName,
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: minSide * 0.045,
              ),
            ),
          ),
          IconButton(
            icon: Icon(Icons.edit, size: minSide * 0.07),
            onPressed: () => _showEditCategoryDialog(categoryName, AppLocalizations.of(context)!),
          ),
          SizedBox(width: width * 0.02),
          IconButton(
            icon: Icon(Icons.delete, size: minSide * 0.07),
            onPressed: () => _showDeleteConfirmationDialog(categoryName, AppLocalizations.of(context)!),
          ),
        ],
      ),
    );
  }

  // Передаємо l10n як аргумент, щоб не викликати .of(context) зайвий раз
  void _showAddCategoryDialog(AppLocalizations l10n) {
    final TextEditingController controller = TextEditingController();
    final formKey = GlobalKey<FormState>();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(
            l10n.addCategoryTitle,
            style: const TextStyle(fontWeight: FontWeight.w700),
          ),
          content: Form(
            key: formKey,
            child: TextFormField(
              controller: controller,
              autofocus: true,
              validator: (value) => ContentValidator.validateCategoryName(context, value),
              autovalidateMode: AutovalidateMode.onUserInteraction,
              decoration: InputDecoration(
                hintText: l10n.categoryName,
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(l10n.cancel, style: const TextStyle(fontWeight: FontWeight.w600)),
            ),
            TextButton(
              onPressed: () {
                if (formKey.currentState!.validate()) {
                  setState(() {
                    _categories.add(controller.text.trim());
                  });
                  _analytics.logCategoryCreated(controller.text.trim());
                  Navigator.pop(context);
                }
              },
              child: Text(l10n.add, style: const TextStyle(fontWeight: FontWeight.w600)),
            ),
          ],
        );
      },
    );
  }

  void _showEditCategoryDialog(String categoryName, AppLocalizations l10n) {
    final TextEditingController controller = TextEditingController(text: categoryName);
    final formKey = GlobalKey<FormState>();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(
            l10n.editCategoryTitle,
            style: const TextStyle(fontWeight: FontWeight.w700),
          ),
          content: Form(
            key: formKey,
            child: TextFormField(
              controller: controller,
              autofocus: true,
              validator: (value) => ContentValidator.validateCategoryName(context, value),
              autovalidateMode: AutovalidateMode.onUserInteraction,
              decoration: InputDecoration(
                hintText: l10n.categoryName,
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(l10n.cancel, style: const TextStyle(fontWeight: FontWeight.w600)),
            ),
            TextButton(
              onPressed: () {
                if (formKey.currentState!.validate()) {
                  setState(() {
                    final index = _categories.indexOf(categoryName);
                    if (index != -1) {
                      _categories[index] = controller.text.trim();
                    }
                  });
                  _analytics.logCategoryUpdated(
                    oldName: categoryName,
                    newName: controller.text.trim(),
                  );
                  Navigator.pop(context);
                }
              },
              child: Text(l10n.save, style: const TextStyle(fontWeight: FontWeight.w600)),
            ),
          ],
        );
      },
    );
  }

  void _showDeleteConfirmationDialog(String categoryName, AppLocalizations l10n) {
    showDialog(
      context: context,
      builder: (context) {
        final errorColor = Theme.of(context).colorScheme.error;

        return AlertDialog(
          title: Text(
            l10n.deleteCategoryTitle,
            style: const TextStyle(fontWeight: FontWeight.w700),
          ),
          content: Text(l10n.confirmDeleteCategory(categoryName)),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text(
                l10n.cancel,
                style: const TextStyle(fontWeight: FontWeight.w600),
              ),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  _categories.remove(categoryName);
                });
                _analytics.logCategoryDeleted(categoryName);
                Navigator.pop(context);
              },
              child: Text(
                l10n.delete,
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  color: errorColor,
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}