import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';

import '../../../l10n/app_localizations.dart';
import '../../../core/services/analytics_service.dart';
import '../../../core/validators/content_validator.dart';

// Blocs
import '../../categories/logic/bloc/categories_bloc.dart';
import '../../categories/logic/bloc/categories_state.dart';
import '../logic/bloc/tasks_bloc.dart';
import '../logic/bloc/tasks_event.dart';
import '../data/models/task_model.dart';

class NewTaskScreen extends StatefulWidget {
  const NewTaskScreen({super.key});

  @override
  State<NewTaskScreen> createState() => _NewTaskScreenState();
}

class _NewTaskScreenState extends State<NewTaskScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _deadlineController = TextEditingController();

  String? _selectedCategory;
  TaskStatus? _selectedStatus;

  DateTime? _selectedDateTime;
  final AnalyticsService _analytics = AnalyticsService.instance;

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _deadlineController.dispose();
    super.dispose();
  }

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
        leading: IconButton(icon: const Icon(Icons.arrow_back), onPressed: () => Navigator.pop(context)),
        title: Text(l10n.newTask, style: const TextStyle(fontWeight: FontWeight.w700)),
      ),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final width = constraints.maxWidth;
            final height = constraints.maxHeight;
            final minSide = min(width, height);

            return SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: width * 0.06, vertical: height * 0.02),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // --- Title (ЗАЛИШАЄТЬСЯ ОБОВ'ЯЗКОВИМ) ---
                      _buildLabel(l10n.title, minSide, textTheme),
                      SizedBox(height: height * 0.01),
                      TextFormField(
                        controller: _titleController,
                        // Тут валідатор потрібен, бо заголовок не може бути пустим
                        validator: (value) => ContentValidator.validateTaskTitle(context, value),
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        decoration: InputDecoration(hintText: l10n.hintEnterTaskTitle),
                      ),
                      SizedBox(height: height * 0.025),

                      // --- Description (ОПЦІОНАЛЬНО) ---
                      _buildLabel(l10n.description, minSide, textTheme),
                      SizedBox(height: height * 0.01),
                      TextFormField(
                        controller: _descriptionController,
                        maxLines: 5,
                        // Валідатор прибрано або він має пропускати пусті рядки
                        // validator: (value) => ContentValidator.validateTaskDescription(context, value),
                        decoration: InputDecoration(hintText: l10n.hintAddDescription),
                      ),
                      SizedBox(height: height * 0.025),

                      // --- Category (ОПЦІОНАЛЬНО) ---
                      _buildLabel(l10n.category, minSide, textTheme),
                      SizedBox(height: height * 0.01),
                      BlocBuilder<CategoriesBloc, CategoriesState>(
                        builder: (context, state) {
                          final categories = state.categories.map((e) => e.name).toList();
                          return DropdownButtonFormField<String>(
                            initialValue: _selectedCategory,
                            decoration: InputDecoration(
                              hintText: l10n.hintSelectCategory,
                              contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
                            ),
                            icon: const Icon(Icons.keyboard_arrow_down),
                            items: categories.map((String item) {
                              return DropdownMenuItem<String>(
                                value: item,
                                child: Text(item, style: textTheme.bodyLarge?.copyWith(fontSize: minSide * 0.04)),
                              );
                            }).toList(),
                            onChanged: (value) => setState(() => _selectedCategory = value),
                            // validator прибрано!
                          );
                        },
                      ),
                      SizedBox(height: height * 0.025),

                      // --- Status (ОПЦІОНАЛЬНО - буде New за замовчуванням) ---
                      _buildLabel(l10n.status, minSide, textTheme),
                      SizedBox(height: height * 0.01),
                      DropdownButtonFormField<TaskStatus>(
                        initialValue: _selectedStatus,
                        decoration: InputDecoration(
                          hintText: l10n.hintSelectStatus, // Або "Select Status (Optional)"
                          contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
                        ),
                        icon: const Icon(Icons.keyboard_arrow_down),
                        items: TaskStatus.values.map((TaskStatus status) {
                          return DropdownMenuItem<TaskStatus>(
                            value: status,
                            child: Text(
                              status.toLocalizedName(context),
                              style: textTheme.bodyLarge?.copyWith(fontSize: minSide * 0.04),
                            ),
                          );
                        }).toList(),
                        onChanged: (value) => setState(() => _selectedStatus = value),
                        // validator прибрано!
                      ),
                      SizedBox(height: height * 0.025),

                      // --- Deadline (ОПЦІОНАЛЬНО) ---
                      _buildLabel(l10n.deadline, minSide, textTheme),
                      SizedBox(height: height * 0.01),
                      TextFormField(
                        controller: _deadlineController,
                        readOnly: true,
                        onTap: _selectDateTime,
                        // validator прибрано!
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
                          style: ElevatedButton.styleFrom(padding: EdgeInsets.symmetric(vertical: height * 0.02)),
                          onPressed: _saveTask,
                          child: Text(l10n.saveTask, style: TextStyle(fontWeight: FontWeight.w700, fontSize: minSide * 0.05)),
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
      style: textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600, fontSize: minSide * 0.045),
    );
  }

  void _saveTask() {
    // Валідуємо тільки те, що залишилось обов'язковим (назва)
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final newTask = TaskModel(
      id: const Uuid().v4(),
      title: _titleController.text.trim(),
      // Перевіряємо на порожній рядок
      description: _descriptionController.text.trim().isEmpty ? null : _descriptionController.text.trim(),
      categoryName: _selectedCategory, // Може бути null
      status: _selectedStatus ?? TaskStatus.new_, // Якщо не вибрано, ставимо New
      dueDate: _selectedDateTime, // Може бути null
    );

    context.read<TasksBloc>().add(AddTask(newTask));

    _analytics.logTaskCreated(
      title: newTask.title,
      category: newTask.categoryName,
      status: newTask.status.name,
      due: newTask.dueDate?.toString(),
    );

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(AppLocalizations.of(context)!.taskSavedSuccessfully)),
    );

    Navigator.pop(context);
  }
}