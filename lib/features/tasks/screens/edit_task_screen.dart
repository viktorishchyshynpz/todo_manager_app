import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../../../l10n/app_localizations.dart';
import '../../../core/services/analytics_service.dart';
import '../../../core/validators/content_validator.dart';

import '../../categories/logic/bloc/categories_bloc.dart';
import '../../categories/logic/bloc/categories_state.dart';
import '../logic/bloc/tasks_bloc.dart';
import '../logic/bloc/tasks_event.dart';
import '../data/models/task_model.dart';

class EditTaskScreen extends StatefulWidget {
  final TaskModel task; // Тепер приймаємо типізований об'єкт

  const EditTaskScreen({super.key, required this.task});

  @override
  State<EditTaskScreen> createState() => _EditTaskScreenState();
}

class _EditTaskScreenState extends State<EditTaskScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _titleController;
  late TextEditingController _descriptionController;
  late TextEditingController _deadlineController;

  String? _selectedCategory;
  TaskStatus? _selectedStatus;
  DateTime? _selectedDateTime;

  final AnalyticsService _analytics = AnalyticsService.instance;

  @override
  void initState() {
    super.initState();
    // Використовуємо ?? '' для текстових полів, щоб уникнути null в контролері
    _titleController = TextEditingController(text: widget.task.title);
    _descriptionController = TextEditingController(text: widget.task.description ?? '');

    _selectedCategory = widget.task.categoryName;
    _selectedStatus = widget.task.status;
    _selectedDateTime = widget.task.dueDate;

    if (_selectedDateTime != null) {
      _deadlineController = TextEditingController(text: DateFormat('dd.MM.yyyy HH:mm').format(_selectedDateTime!));
    } else {
      _deadlineController = TextEditingController();
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _deadlineController.dispose();
    super.dispose();
  }

  // _selectDateTime залишається без змін...
  Future<void> _selectDateTime() async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: _selectedDateTime ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );

    if (pickedDate != null && mounted) {
      final TimeOfDay? pickedTime = await showTimePicker(
        context: context,
        initialTime: _selectedDateTime != null ? TimeOfDay.fromDateTime(_selectedDateTime!) : TimeOfDay.now(),
      );

      if (pickedTime != null && mounted) {
        setState(() {
          _selectedDateTime = DateTime(pickedDate.year, pickedDate.month, pickedDate.day, pickedTime.hour, pickedTime.minute);
          _deadlineController.text = DateFormat('dd.MM.yyyy HH:mm').format(_selectedDateTime!);
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // UI код майже ідентичний NewTaskScreen, за винятком заголовка і кнопки видалення
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.editTask, style: const TextStyle(fontWeight: FontWeight.w700)),
        leading: IconButton(icon: const Icon(Icons.arrow_back), onPressed: () => Navigator.pop(context)),
      ),
      body: SafeArea(
        child: LayoutBuilder(builder: (context, constraints) {
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
                    // Title, Description, Category, Status, Deadline - так само як в NewTaskScreen
                    // ...
                    _buildLabel(l10n.title, minSide, textTheme),
                    SizedBox(height: height * 0.01),
                    TextFormField(
                        controller: _titleController,
                        validator: (value) => ContentValidator.validateTaskTitle(context, value),
                        decoration: InputDecoration(hintText: l10n.hintEnterTaskTitle)),
                    SizedBox(height: height * 0.025),

                    _buildLabel(l10n.description, minSide, textTheme),
                    SizedBox(height: height * 0.01),
                    TextFormField(
                        controller: _descriptionController,
                        maxLines: 4,
                        decoration: InputDecoration(hintText: l10n.hintAddDescription)),
                    SizedBox(height: height * 0.025),

                    _buildLabel(l10n.category, minSide, textTheme),
                    SizedBox(height: height * 0.01),
                    BlocBuilder<CategoriesBloc, CategoriesState>(builder: (context, state) {
                      final categories = state.categories.map((e) => e.name).toList();
                      return DropdownButtonFormField<String>(
                        initialValue: categories.contains(_selectedCategory) ? _selectedCategory : null,
                        items: categories.map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
                        onChanged: (val) => setState(() => _selectedCategory = val),
                        decoration: InputDecoration(hintText: l10n.hintSelectCategory),
                      );
                    }),
                    SizedBox(height: height * 0.025),

                    _buildLabel(l10n.status, minSide, textTheme),
                    SizedBox(height: height * 0.01),
                    DropdownButtonFormField<TaskStatus>(
                      initialValue: _selectedStatus,
                      items: TaskStatus.values.map((e) => DropdownMenuItem(value: e, child: Text(e.toLocalizedName(context)))).toList(),
                      onChanged: (val) => setState(() => _selectedStatus = val),
                      decoration: InputDecoration(hintText: l10n.hintSelectStatus),
                    ),
                    SizedBox(height: height * 0.025),

                    _buildLabel(l10n.deadline, minSide, textTheme),
                    SizedBox(height: height * 0.01),
                    TextFormField(
                      controller: _deadlineController,
                      readOnly: true,
                      onTap: _selectDateTime,
                      decoration: InputDecoration(
                          hintText: l10n.hintDateMask,
                          suffixIcon: IconButton(icon: const Icon(Icons.calendar_today), onPressed: _selectDateTime)),
                    ),
                    SizedBox(height: height * 0.04),

                    // Buttons
                    SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                            style: ElevatedButton.styleFrom(padding: EdgeInsets.symmetric(vertical: height * 0.02)),
                            onPressed: _saveChanges,
                            child: Text(l10n.saveChanges, style: TextStyle(fontWeight: FontWeight.w700, fontSize: minSide * 0.05))
                        )
                    ),
                    SizedBox(height: height * 0.02),
                    SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                            style: ElevatedButton.styleFrom(backgroundColor: theme.colorScheme.error, foregroundColor: theme.colorScheme.onError, padding: EdgeInsets.symmetric(vertical: height * 0.02)),
                            onPressed: () => _showDeleteDialog(context, l10n),
                            child: Text(l10n.delete, style: TextStyle(fontWeight: FontWeight.w700, fontSize: minSide * 0.05)))),
                    SizedBox(height: height * 0.02),
                  ],
                ),
              ),
            ),
          );
        }),
      ),
    );
  }

  Widget _buildLabel(String text, double minSide, TextTheme textTheme) {
    return Text(
      text,
      style: textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600, fontSize: minSide * 0.045),
    );
  }

  void _saveChanges() {
    if (!_formKey.currentState!.validate()) return;

    final updatedTask = widget.task.copyWith(
      title: _titleController.text.trim(),
      description: _descriptionController.text.trim(),
      categoryName: _selectedCategory,
      status: _selectedStatus,
      dueDate: _selectedDateTime,
    );

    context.read<TasksBloc>().add(UpdateTask(updatedTask));
    _analytics.logTaskUpdated(title: updatedTask.title, category: updatedTask.categoryName, status: updatedTask.status.name, due: updatedTask.dueDate.toString());

    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(AppLocalizations.of(context)!.taskUpdatedSuccessfully)));
    Navigator.pop(context);
  }

  void _showDeleteDialog(BuildContext context, AppLocalizations l10n) {
    showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: Text(l10n.deleteTaskTitle),
          content: Text(l10n.confirmDeleteTask(widget.task.title)),
          actions: [
            TextButton(onPressed: () => Navigator.pop(ctx), child: Text(l10n.cancel)),
            TextButton(
                onPressed: () {
                  context.read<TasksBloc>().add(DeleteTask(widget.task.id));
                  _analytics.logTaskDeleted(title: widget.task.title, category: widget.task.categoryName, status: widget.task.status.name);
                  Navigator.pop(ctx);
                  Navigator.pop(context); // Back to home
                },
                child: Text(l10n.delete, style: TextStyle(color: Theme.of(context).colorScheme.error))),
          ],
        ));
  }
}