import 'dart:math';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../l10n/app_localizations.dart';
import '../../../core/services/analytics_service.dart';
import '../../../core/validators/content_validator.dart';

class NewTaskScreen extends StatefulWidget {
  const NewTaskScreen({super.key});

  @override
  State<NewTaskScreen> createState() => _NewTaskScreenState();
}

class _NewTaskScreenState extends State<NewTaskScreen> {
  final _formKey = GlobalKey<FormState>();
  // Контролери полів вводу
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _deadlineController = TextEditingController();

  // Вибрані значення
  String? _selectedCategory;
  String? _selectedStatus;

  List<String> _categories = [];
  List<String> _statuses = [];

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final l10n = AppLocalizations.of(context)!;
    _categories = [
      l10n.categoryHome,
      l10n.categoryStudy,
      l10n.categoryWork,
    ];
    _statuses = [
      l10n.statusNew,
      l10n.statusInProgress,
      l10n.statusCompleted,
      l10n.statusCanceled,
    ];
  }

  DateTime? _selectedDateTime;

  final AnalyticsService _analytics = AnalyticsService.instance;

  // Очищення ресурсів
  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _deadlineController.dispose();
    super.dispose();
  }

  // Вибір дати та часу
  Future<void> _selectDateTime() async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );

    if (pickedDate != null && mounted) {
      final TimeOfDay? pickedTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.now(),
      );

      if (pickedTime != null && mounted) {
        setState(() {
          _selectedDateTime = DateTime(
            pickedDate.year,
            pickedDate.month,
            pickedDate.day,
            pickedTime.hour,
            pickedTime.minute,
          );
          _deadlineController.text = DateFormat('dd.MM.yyyy HH:mm').format(_selectedDateTime!);
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          l10n.newTask,
          style: const TextStyle(fontWeight: FontWeight.w700),
        ),
      ),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final width = constraints.maxWidth;
            final height = constraints.maxHeight;
            final minSide = min(width, height);

            return SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: width * 0.06,
                  vertical: height * 0.02,
                ),
                // Огортаємо контент у Form
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildLabel(l10n.title, minSide, textTheme),
                      SizedBox(height: height * 0.01),

                      // Замінено на TextFormField
                      TextFormField(
                        controller: _titleController,
                        validator: (value) => ContentValidator.validateTaskTitle(context, value), // Валідатор
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        decoration: InputDecoration(
                          hintText: l10n.hintEnterTaskTitle,
                        ),
                      ),

                      SizedBox(height: height * 0.025),

                      _buildLabel(l10n.description, minSide, textTheme),
                      SizedBox(height: height * 0.01),

                      // Замінено на TextFormField
                      TextFormField(
                        controller: _descriptionController,
                        maxLines: 5,
                        validator: (value) => ContentValidator.validateTaskDescription(context, value), // Валідатор
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        decoration: InputDecoration(
                          hintText: l10n.hintAddDescription,
                        ),
                      ),

                      SizedBox(height: height * 0.025),

                      // ... (Dropdowns для Категорії та Статусу без змін) ...
                      _buildLabel(l10n.category, minSide, textTheme),
                      SizedBox(height: height * 0.01),
                      DropdownButtonFormField<String>(
                        initialValue: _selectedCategory,
                        decoration: InputDecoration(
                          hintText: l10n.hintSelectCategory,
                          contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 18),
                        ),
                        icon: const Icon(Icons.keyboard_arrow_down),
                        items: _categories.map((String item) {
                          return DropdownMenuItem<String>(
                            value: item,
                            child: Text(item, style: textTheme.bodyLarge?.copyWith(fontSize: minSide * 0.04)),
                          );
                        }).toList(),
                        onChanged: (value) => setState(() => _selectedCategory = value),
                      ),
                      SizedBox(height: height * 0.025),

                      _buildLabel(l10n.status, minSide, textTheme),
                      SizedBox(height: height * 0.01),
                      DropdownButtonFormField<String>(
                        initialValue: _selectedStatus,
                        decoration: InputDecoration(
                          hintText: l10n.hintSelectStatus,
                          contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 18),
                        ),
                        icon: const Icon(Icons.keyboard_arrow_down),
                        items: _statuses.map((String item) {
                          return DropdownMenuItem<String>(
                            value: item,
                            child: Text(item, style: textTheme.bodyLarge?.copyWith(fontSize: minSide * 0.04)),
                          );
                        }).toList(),
                        onChanged: (value) => setState(() => _selectedStatus = value),
                      ),

                      SizedBox(height: height * 0.025),

                      _buildLabel(l10n.deadline, minSide, textTheme),
                      SizedBox(height: height * 0.01),
                      TextField( // Можна залишити TextField, бо тут тільки вибір дати
                        controller: _deadlineController,
                        readOnly: true,
                        onTap: _selectDateTime,
                        decoration: InputDecoration(
                          hintText: l10n.hintDateMask,
                          suffixIcon: IconButton(
                            icon: Icon(Icons.calendar_today, size: minSide * 0.06),
                            onPressed: _selectDateTime,
                          ),
                        ),
                      ),

                      SizedBox(height: height * 0.04),

                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            padding: EdgeInsets.symmetric(vertical: height * 0.02),
                          ),
                          onPressed: _saveTask,
                          child: Text(
                            l10n.saveTask,
                            style: TextStyle(
                              fontWeight: FontWeight.w700,
                              fontSize: minSide * 0.05,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: height * 0.02),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildLabel(String text, double minSide, TextTheme textTheme) {
    return Text(
      text,
      style: textTheme.titleMedium?.copyWith(
        fontWeight: FontWeight.w600,
        fontSize: minSide * 0.045,
      ),
    );
  }

  // Оновлений метод збереження
  void _saveTask() {
    // Перевіряємо валідацію через форму
    if (!_formKey.currentState!.validate()) {
      return; // Якщо є помилки, не зберігаємо
    }

    _analytics.logTaskCreated(
      title: _titleController.text,
      category: _selectedCategory,
      status: _selectedStatus,
      due: _deadlineController.text,
    );

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          AppLocalizations.of(context)!.taskSavedSuccessfully,
          style: const TextStyle(fontWeight: FontWeight.w700),
        ),
      ),
    );

    Navigator.pop(context);
  }
}