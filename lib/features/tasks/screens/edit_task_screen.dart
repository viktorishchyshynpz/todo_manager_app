import 'dart:math';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../l10n/app_localizations.dart';
import '../../../core/services/analytics_service.dart';
import '../../../core/validators/content_validator.dart';

class EditTaskScreen extends StatefulWidget {
  final Map<String, dynamic> task;

  const EditTaskScreen({
    super.key,
    required this.task,
  });

  @override
  State<EditTaskScreen> createState() => _EditTaskScreenState();
}

class _EditTaskScreenState extends State<EditTaskScreen> {
  final _formKey = GlobalKey<FormState>(); // Додано ключ

  late TextEditingController _titleController;
  late TextEditingController _descriptionController;
  late TextEditingController _deadlineController;

  String? _selectedCategory;
  String? _selectedStatus;

  List<String> _categories = [];
  List<String> _statuses = [];

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final loc = AppLocalizations.of(context)!;
    _categories = [
      loc.categoryHome,
      loc.categoryStudy,
      loc.categoryWork,
    ];
    _statuses = [
      loc.statusNew,
      loc.statusInProgress,
      loc.statusCompleted,
      loc.statusCanceled,
    ];
  }

  DateTime? _selectedDateTime;
  final AnalyticsService _analytics = AnalyticsService.instance;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.task['title']);
    _descriptionController = TextEditingController(text: widget.task['description']);
    _deadlineController = TextEditingController(text: widget.task['due']);

    _selectedCategory = widget.task['category'];
    _selectedStatus = widget.task['status'];

    try {
      _selectedDateTime = DateFormat('dd.MM.yyyy HH:mm').parse(widget.task['due']);
    } catch (e) {
      _selectedDateTime = null;
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _deadlineController.dispose();
    super.dispose();
  }

  Future<void> _selectDateTime() async {
    // ... (код вибору дати без змін) ...
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: _selectedDateTime ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );

    if (pickedDate != null && mounted) {
      final TimeOfDay? pickedTime = await showTimePicker(
        context: context,
        initialTime: _selectedDateTime != null
            ? TimeOfDay.fromDateTime(_selectedDateTime!)
            : TimeOfDay.now(),
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
          l10n.editTask,
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
                child: Form( // Додано Form
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildLabel(l10n.title, minSide, textTheme),
                      SizedBox(height: height * 0.01),

                      // TextFormField для Title
                      TextFormField(
                        controller: _titleController,
                        validator: (value) => ContentValidator.validateTaskTitle(context, value),
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        decoration: InputDecoration(
                          hintText: l10n.hintEnterTaskTitle,
                        ),
                      ),

                      SizedBox(height: height * 0.025),

                      _buildLabel(l10n.description, minSide, textTheme),
                      SizedBox(height: height * 0.01),

                      // TextFormField для Description
                      TextFormField(
                        controller: _descriptionController,
                        maxLines: 4,
                        validator: (value) => ContentValidator.validateTaskDescription(context, value),
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        decoration: InputDecoration(
                          hintText: l10n.hintAddDescription,
                        ),
                      ),

                      SizedBox(height: height * 0.025),

                      // ... (Dropdowns без змін) ...
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
                      TextField(
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
                            l10n.saveChanges,
                            style: TextStyle(
                              fontWeight: FontWeight.w700,
                              fontSize: minSide * 0.05,
                            ),
                          ),
                        ),
                      ),

                      SizedBox(height: height * 0.02),

                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: theme.colorScheme.error,
                            foregroundColor: theme.colorScheme.onError,
                            padding: EdgeInsets.symmetric(vertical: height * 0.02),
                          ),
                          onPressed: _showDeleteConfirmationDialog,
                          child: Text(
                            l10n.delete,
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

  void _saveTask() {
    // Перевіряємо валідацію
    if (!_formKey.currentState!.validate()) {
      return;
    }

    widget.task['title'] = _titleController.text;
    widget.task['description'] = _descriptionController.text;
    widget.task['category'] = _selectedCategory;
    widget.task['status'] = _selectedStatus;
    widget.task['due'] = _deadlineController.text;

    _analytics.logTaskUpdated(
      title: widget.task['title'],
      category: widget.task['category'],
      status: widget.task['status'],
      due: widget.task['due'],
    );

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          AppLocalizations.of(context)!.taskUpdatedSuccessfully,
          style: const TextStyle(fontWeight: FontWeight.w700),
        ),
      ),
    );

    Navigator.pop(context);
  }

  void _showDeleteConfirmationDialog() {
    // ... (код без змін) ...
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(AppLocalizations.of(context)!.deleteTaskTitle, style: TextStyle(fontWeight: FontWeight.w700)),
          content: Text(AppLocalizations.of(context)!.confirmDeleteTask(widget.task['title'])),
          actions: [
            TextButton(onPressed: () => Navigator.pop(context), child: Text(AppLocalizations.of(context)!.cancel)),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                Navigator.pop(context);
                _analytics.logTaskDeleted(
                  title: widget.task['title'],
                  category: widget.task['category'],
                  status: widget.task['status'],
                );
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(AppLocalizations.of(context)!.taskDeletedSuccessfully)));
              },
              child: Text(AppLocalizations.of(context)!.delete, style: TextStyle(color: Theme.of(context).colorScheme.error)),
            ),
          ],
        );
      },
    );
  }
}