import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../l10n/app_localizations.dart';
import '../../../core/services/analytics_service.dart';
import '../../../core/validators/content_validator.dart';
// Імпорти Блоку
import '../logic/bloc/categories_bloc.dart';
import '../logic/bloc/categories_event.dart';
import '../logic/bloc/categories_state.dart';
import '../data/models/category_model.dart';

class ManageCategoriesScreen extends StatelessWidget {
  const ManageCategoriesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final analytics = AnalyticsService.instance;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          l10n.manageCategories,
          style: const TextStyle(fontWeight: FontWeight.w700),
        ),
      ),
      body: SafeArea(
        child: BlocConsumer<CategoriesBloc, CategoriesState>(
          listener: (context, state) {
            if (state.status == CategoriesStatus.failure) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.errorMessage ?? 'Error'),
                  backgroundColor: Theme.of(context).colorScheme.error,
                ),
              );
            }
          },
          builder: (context, state) {
            if (state.status == CategoriesStatus.loading && state.categories.isEmpty) {
              return const Center(child: CircularProgressIndicator());
            }

            // LayoutBuilder для адаптивності
            return LayoutBuilder(
              builder: (context, constraints) {
                final width = constraints.maxWidth;
                final height = constraints.maxHeight;
                final minSide = min(width, height);

                if (state.categories.isEmpty) {
                  final textTheme = Theme.of(context).textTheme;
                  return Center(
                    child: Text(
                      l10n.noCategoriesYet,
                      style: textTheme.bodyLarge?.copyWith(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  );
                }

                return Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: width * 0.06,
                    vertical: height * 0.02,
                  ),
                  child: ListView.builder(
                    itemCount: state.categories.length,
                    itemBuilder: (context, index) {
                      final category = state.categories[index];
                      return Padding(
                        padding: EdgeInsets.only(bottom: height * 0.015),
                        child: _CategoryItem(
                          category: category,
                          width: width,
                          height: height,
                          minSide: minSide,
                          onEdit: () => _showEditCategoryDialog(context, category, l10n, analytics),
                          onDelete: () => _showDeleteConfirmationDialog(context, category, l10n, analytics),
                        ),
                      );
                    },
                  ),
                );
              },
            );
          },
        ),
      ),
      floatingActionButton: LayoutBuilder(
        builder: (context, constraints) {
          final minSide = min(constraints.maxWidth, constraints.maxHeight);
          return FloatingActionButton(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            onPressed: () => _showAddCategoryDialog(context, l10n, analytics),
            child: Icon(Icons.add, size: minSide * 0.08),
          );
        },
      ),
    );
  }

  // --- Діалоги ---

  void _showAddCategoryDialog(BuildContext context, AppLocalizations l10n, AnalyticsService analytics) {
    final controller = TextEditingController();
    final formKey = GlobalKey<FormState>();

    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: Text(l10n.addCategoryTitle, style: const TextStyle(fontWeight: FontWeight.w700)),
          content: Form(
            key: formKey,
            child: TextFormField(
              controller: controller,
              autofocus: true,
              validator: (value) => ContentValidator.validateCategoryName(context, value),
              autovalidateMode: AutovalidateMode.onUserInteraction,
              decoration: InputDecoration(hintText: l10n.categoryName),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: Text(l10n.cancel, style: const TextStyle(fontWeight: FontWeight.w600)),
            ),
            TextButton(
              onPressed: () {
                if (formKey.currentState!.validate()) {
                  final name = controller.text.trim();
                  // Використовуємо головний context, переданий в функцію,
                  // або краще dialogContext (якщо CategoriesBloc доступний вище)
                  context.read<CategoriesBloc>().add(AddCategory(name));
                  analytics.logCategoryCreated(name);
                  Navigator.pop(dialogContext);
                }
              },
              child: Text(l10n.add, style: const TextStyle(fontWeight: FontWeight.w600)),
            ),
          ],
        );
      },
    );
  }

  void _showEditCategoryDialog(BuildContext context, CategoryModel category, AppLocalizations l10n, AnalyticsService analytics) {
    final controller = TextEditingController(text: category.name);
    final formKey = GlobalKey<FormState>();

    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: Text(l10n.editCategoryTitle, style: const TextStyle(fontWeight: FontWeight.w700)),
          content: Form(
            key: formKey,
            child: TextFormField(
              controller: controller,
              autofocus: true,
              validator: (value) => ContentValidator.validateCategoryName(context, value),
              autovalidateMode: AutovalidateMode.onUserInteraction,
              decoration: InputDecoration(hintText: l10n.categoryName),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: Text(l10n.cancel, style: const TextStyle(fontWeight: FontWeight.w600)),
            ),
            TextButton(
              onPressed: () {
                if (formKey.currentState!.validate()) {
                  final newName = controller.text.trim();
                  final updatedCategory = category.copyWith(name: newName);
                  context.read<CategoriesBloc>().add(UpdateCategory(updatedCategory));
                  analytics.logCategoryUpdated(oldName: category.name, newName: newName);
                  Navigator.pop(dialogContext);
                }
              },
              child: Text(l10n.save, style: const TextStyle(fontWeight: FontWeight.w600)),
            ),
          ],
        );
      },
    );
  }

  void _showDeleteConfirmationDialog(BuildContext context, CategoryModel category, AppLocalizations l10n, AnalyticsService analytics) {
    showDialog(
      context: context,
      builder: (dialogContext) {
        final errorColor = Theme.of(context).colorScheme.error;
        return AlertDialog(
          title: Text(l10n.deleteCategoryTitle, style: const TextStyle(fontWeight: FontWeight.w700)),
          content: Text(l10n.confirmDeleteCategory(category.name)),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: Text(l10n.cancel, style: const TextStyle(fontWeight: FontWeight.w600)),
            ),
            TextButton(
              onPressed: () {
                context.read<CategoriesBloc>().add(DeleteCategory(category.id));
                analytics.logCategoryDeleted(category.name);
                Navigator.pop(dialogContext);
              },
              child: Text(l10n.delete, style: TextStyle(fontWeight: FontWeight.w600, color: errorColor)),
            ),
          ],
        );
      },
    );
  }
}

// Окремий віджет для елемента списку (для чистоти коду)
class _CategoryItem extends StatelessWidget {
  final CategoryModel category;
  final double width;
  final double height;
  final double minSide;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const _CategoryItem({
    required this.category,
    required this.width,
    required this.height,
    required this.minSide,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final borderColor = theme.brightness == Brightness.light ? Colors.black : theme.colorScheme.onSurface;

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: borderColor, width: 1.5),
      ),
      padding: EdgeInsets.symmetric(horizontal: width * 0.05, vertical: height * 0.02),
      child: Row(
        children: [
          Expanded(
            child: Text(
              category.name,
              style: TextStyle(fontWeight: FontWeight.w600, fontSize: minSide * 0.045),
            ),
          ),
          IconButton(
            icon: Icon(Icons.edit, size: minSide * 0.07),
            onPressed: onEdit,
          ),
          SizedBox(width: width * 0.02),
          IconButton(
            icon: Icon(Icons.delete, size: minSide * 0.07),
            onPressed: onDelete,
          ),
        ],
      ),
    );
  }
}