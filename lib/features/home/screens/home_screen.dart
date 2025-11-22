import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../../../core/routes/app_routes.dart';
import '../../../l10n/app_localizations.dart';

// Blocs
import '../../categories/logic/bloc/categories_bloc.dart';
import '../../categories/logic/bloc/categories_state.dart';
import '../../tasks/logic/bloc/tasks_bloc.dart';
import '../../tasks/logic/bloc/tasks_state.dart';
import '../../tasks/data/models/task_model.dart';
import '../../tasks/logic/bloc/tasks_event.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // Змінна для фільтрації. null = "Всі"
  String? _selectedCategoryFilter;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, AppRoutes.newTask);
        },
        child: const Icon(Icons.add, size: 28),
      ),
      body: SafeArea(
        child: BlocBuilder<TasksBloc, TasksState>(
          builder: (context, tasksState) {
            if (tasksState.status == TasksStatus.loading) {
              return const Center(child: CircularProgressIndicator());
            }

            // Фільтруємо завдання
            final allTasks = tasksState.tasks;
            final tasksToShow = _selectedCategoryFilter == null
                ? allTasks
                : allTasks.where((t) => t.categoryName == _selectedCategoryFilter).toList();

            return LayoutBuilder(
              builder: (context, constraints) {
                final width = constraints.maxWidth;
                final height = constraints.maxHeight;
                final minSide = min(width, height);

                return CustomScrollView(
                  slivers: [
                    // 1. Header (My Tasks + Settings)
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: width * 0.06,
                          vertical: height * 0.02,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              l10n.myTasks,
                              style: textTheme.headlineMedium?.copyWith(
                                fontSize: minSide * 0.08,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            IconButton(
                              icon: Icon(Icons.settings, size: minSide * 0.08),
                              onPressed: () {
                                Navigator.pushNamed(context, AppRoutes.settings);
                              },
                            ),
                          ],
                        ),
                      ),
                    ),

                    // 2. Categories Filter Header
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: width * 0.06),
                        child: Text(
                          l10n.categories,
                          style: textTheme.bodyLarge?.copyWith(
                            fontSize: minSide * 0.045,
                          ),
                        ),
                      ),
                    ),

                    SliverToBoxAdapter(child: SizedBox(height: height * 0.015)),

                    // 3. Categories Horizontal List (BlocBuilder for Categories)
                    SliverToBoxAdapter(
                      child: SizedBox(
                        height: minSide * 0.12,
                        child: BlocBuilder<CategoriesBloc, CategoriesState>(
                          builder: (context, categoriesState) {
                            return ListView(
                              scrollDirection: Axis.horizontal,
                              padding: EdgeInsets.symmetric(horizontal: width * 0.06),
                              children: [
                                // Кнопка редагування категорій
                                ActionChip(
                                  avatar: Icon(Icons.edit, size: minSide * 0.045),
                                  label: Text(l10n.edit),
                                  onPressed: () => Navigator.pushNamed(context, AppRoutes.manageCategories),
                                ),
                                SizedBox(width: width * 0.02),

                                // Кнопка "All"
                                FilterChip(
                                  label: Text(l10n.categoryAll),
                                  selected: _selectedCategoryFilter == null,
                                  onSelected: (selected) {
                                    setState(() {
                                      _selectedCategoryFilter = null;
                                    });
                                  },
                                ),
                                SizedBox(width: width * 0.02),

                                // Динамічні категорії
                                ...categoriesState.categories.map((cat) {
                                  final isSelected = _selectedCategoryFilter == cat.name;
                                  return Padding(
                                    padding: EdgeInsets.only(right: width * 0.02),
                                    child: FilterChip(
                                      label: Text(cat.name),
                                      selected: isSelected,
                                      onSelected: (selected) {
                                        setState(() {
                                          // Якщо натиснули на вже вибрану - скидаємо фільтр (показуємо всі)
                                          _selectedCategoryFilter = isSelected ? null : cat.name;
                                        });
                                      },
                                    ),
                                  );
                                }),
                              ],
                            );
                          },
                        ),
                      ),
                    ),

                    SliverToBoxAdapter(child: SizedBox(height: height * 0.03)),

                    // 4. Tasks Header
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: width * 0.06),
                        child: Text(
                          l10n.tasks,
                          style: textTheme.bodyLarge?.copyWith(
                            fontSize: minSide * 0.045,
                          ),
                        ),
                      ),
                    ),

                    SliverToBoxAdapter(child: SizedBox(height: height * 0.015)),

                    // 5. Task List (SliverList)
                    if (tasksToShow.isEmpty)
                      SliverToBoxAdapter(
                        child: Padding(
                          padding: EdgeInsets.only(top: height * 0.05),
                          child: Center(
                            child: Text(
                              l10n.noCategoriesYet,
                              style: textTheme.bodyLarge?.copyWith(
                                fontSize: 20,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                      )
                    else
                      SliverList(
                        delegate: SliverChildBuilderDelegate(
                              (context, index) {
                            final task = tasksToShow[index];
                            return Padding(
                              padding: EdgeInsets.symmetric(horizontal: width * 0.06, vertical: height * 0.007),
                              child: _TaskCard(
                                task: task,
                                width: width,
                                height: height,
                                minSide: minSide,
                                l10n: l10n,
                              ),
                            );
                          },
                          childCount: tasksToShow.length,
                        ),
                      ),

                    // Відступ знизу для FAB
                    SliverToBoxAdapter(child: SizedBox(height: height * 0.1)),
                  ],
                );
              },
            );
          },
        ),
      ),
    );
  }
}

// Виніс картку завдання в окремий віджет для читабельності
class _TaskCard extends StatelessWidget {
  final TaskModel task;
  final double width;
  final double height;
  final double minSide;
  final AppLocalizations l10n;

  const _TaskCard({
    super.key,
    required this.task,
    required this.width,
    required this.height,
    required this.minSide,
    required this.l10n,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final detailTextStyle = theme.textTheme.bodyMedium?.copyWith(fontSize: minSide * 0.035);
    final isCompleted = task.status == TaskStatus.completed;

    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: BorderSide(color: theme.dividerColor, width: 1.5),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: () {
          Navigator.pushNamed(context, AppRoutes.editTask, arguments: task);
        },
        child: Padding(
          padding: EdgeInsets.all(width * 0.03),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // --- ЛОГІКА ЧЕКБОКСА ---
              Transform.scale(
                scale: 1.2,
                child: Checkbox(
                  value: isCompleted,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
                  onChanged: (value) {
                    if (value == null) return;

                    // 1. Визначаємо новий статус
                    // Якщо поставили галочку -> Completed, якщо зняли -> повертаємо в InProgress
                    final newStatus = value ? TaskStatus.completed : TaskStatus.inProgress;

                    // 2. Створюємо оновлену модель
                    final updatedTask = task.copyWith(status: newStatus);

                    // 3. Відправляємо подію в BLoC
                    context.read<TasksBloc>().add(UpdateTask(updatedTask));
                  },
                ),
              ),
              // -----------------------

              SizedBox(width: width * 0.03),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      task.title,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                        fontSize: minSide * 0.045,
                        // Закреслення, якщо виконано
                        decoration: isCompleted ? TextDecoration.lineThrough : null,
                        // Сірий колір, якщо виконано
                        color: isCompleted ? theme.disabledColor : null,
                      ),
                    ),
                    SizedBox(height: height * 0.01),
                    Wrap(
                      spacing: width * 0.04,
                      runSpacing: 4,
                      children: [
                        Text(
                          '${l10n.status}: ${task.status.toLocalizedName(context)}',
                          style: detailTextStyle,
                        ),
                        if (task.categoryName != null)
                          Text(
                            '${l10n.category}: ${task.categoryName}',
                            style: detailTextStyle,
                          ),
                      ],
                    ),
                    if (task.dueDate != null) ...[
                      SizedBox(height: height * 0.005),
                      Text(
                        l10n.dueWithValue(DateFormat('dd.MM.yyyy HH:mm').format(task.dueDate!)),
                        style: detailTextStyle?.copyWith(
                          color: task.isOverdue ? theme.colorScheme.error : null,
                        ),
                      ),
                    ]
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}