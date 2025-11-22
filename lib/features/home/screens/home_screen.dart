import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '/core/routes/app_routes.dart';
import '../../../l10n/app_localizations.dart';
import '../../auth/data/repositories/auth_repository.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // Зберігаємо категорію.
  // Важливо: при зміні мови значення 'All' зміниться на 'Всі', тому логіка фільтрації по назві може ламатися.
  // В реальному додатку використовують ID ('all', 'work'), а відображають переклад.
  // Для цієї лаби ми просто ініціалізуємо це пізніше.
  String? _selectedCategory;

  DateTime? _lastBackPressed;

  @override
  void initState() {
    super.initState();
    _checkEmailVerification();
  }

  void _checkEmailVerification() async {
    final user = AuthRepository.instance.currentUser;
    if (user != null && !user.emailVerified) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Navigator.pushNamedAndRemoveUntil(
          context,
          AppRoutes.emailVerification,
              (route) => false,
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    final l10n = AppLocalizations.of(context)!;

    // Ініціалізуємо категорію за замовчуванням, якщо вона пуста
    _selectedCategory ??= l10n.categoryAll;

    // СТВОРЮЄМО СПИСКИ ВСЕРЕДИНІ BUILD, ЩОБ МАТИ ДОСТУП ДО l10n
    final List<Map<String, dynamic>> categories = [
      {'name': l10n.categoryAll, 'selected': _selectedCategory == l10n.categoryAll},
      {'name': l10n.categoryWork, 'selected': _selectedCategory == l10n.categoryWork},
      {'name': l10n.categoryStudy, 'selected': _selectedCategory == l10n.categoryStudy},
      {'name': l10n.categoryHome, 'selected': _selectedCategory == l10n.categoryHome},
    ];

    final List<Map<String, dynamic>> tasks = [
      {
        'title': 'Finish Lab 2',
        'description': 'nothing',
        'category': l10n.categoryStudy, // Використовуємо localized string
        'status': l10n.statusInProgress,
        'due': '27.10.2025 22:00',
        'completed': false,
      },
      {
        'title': 'Read Chapter 5',
        'description': 'none',
        'category': l10n.categoryStudy,
        'status': l10n.statusNew,
        'due': '09.09.2025 18:00',
        'completed': false,
      },
      {
        'title': 'Team Meeting',
        'description': 'none',
        'category': l10n.categoryWork,
        'status': l10n.statusInProgress,
        'due': '03.11.2025 10:00',
        'completed': false,
      },
      {
        'title': 'Clean the house',
        'description': 'none',
        'category': l10n.categoryHome,
        'status': l10n.statusInProgress,
        'due': '30.10.2025 18:00',
        'completed': false,
      },
      {
        'title': 'Finish Lab 3',
        'description': 'none',
        'category': l10n.categoryStudy,
        'status': l10n.statusInProgress,
        'due': '10.11.2025 22:00',
        'completed': false,
      },
    ];

    return WillPopScope(
      onWillPop: () async {
        final now = DateTime.now();
        final maxDuration = const Duration(seconds: 2);

        if (_lastBackPressed == null || now.difference(_lastBackPressed!) > maxDuration) {
          _lastBackPressed = now;
          ScaffoldMessenger.of(context)
            ..removeCurrentSnackBar()
            ..showSnackBar(
              SnackBar(
                content: Text(l10n.pressAgainToExit),
                duration: maxDuration,
                backgroundColor: Theme.of(context).colorScheme.primary,
              ),
            );
          return false;
        }

        await SystemNavigator.pop();
        return false;
      },
      child: Scaffold(
        body: SafeArea(
          child: LayoutBuilder(
            builder: (context, constraints) {
              final width = constraints.maxWidth;
              final height = constraints.maxHeight;
              final minSide = min(width, height);

              return Column(
                children: [
                  // Верхній рядок
                  Padding(
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
                          icon: Icon(
                            Icons.settings,
                            size: minSide * 0.08,
                          ),
                          onPressed: () {
                            Navigator.pushNamed(context, AppRoutes.settings);
                          },
                        ),
                      ],
                    ),
                  ),

                  Expanded(
                    child: SingleChildScrollView(
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: width * 0.06),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(height: height * 0.02),

                            // Підзаголовок: Категорії
                            Text(
                              l10n.categories,
                              style: textTheme.bodyLarge?.copyWith(
                                fontSize: minSide * 0.045,
                              ),
                            ),

                            SizedBox(height: height * 0.015),

                            // Горизонтальний список категорій
                            SizedBox(
                              height: minSide * 0.12,
                              child: ListView(
                                scrollDirection: Axis.horizontal,
                                children: [
                                  ActionChip(
                                    avatar: Icon(
                                      Icons.edit,
                                      size: minSide * 0.045,
                                      color: theme.chipTheme.labelStyle?.color ?? theme.iconTheme.color,
                                    ),
                                    label: Text(
                                      l10n.edit,
                                      style: TextStyle(
                                        fontWeight: FontWeight.w700,
                                        fontSize: minSide * 0.04,
                                      ),
                                    ),
                                    onPressed: () {
                                      Navigator.pushNamed(context, AppRoutes.manageCategories);
                                    },
                                  ),

                                  SizedBox(width: width * 0.02),

                                  // Чіпи категорій
                                  ...categories.map((category) {
                                    final isSelected = _selectedCategory == category['name'];
                                    return Padding(
                                      padding: EdgeInsets.only(right: width * 0.02),
                                      child: FilterChip(
                                        label: Text(
                                          category['name'],
                                          style: TextStyle(
                                            fontWeight: FontWeight.w600,
                                            fontSize: minSide * 0.04,
                                            color: isSelected
                                                ? theme.colorScheme.onPrimary
                                                : theme.textTheme.bodyMedium?.color,
                                          ),
                                        ),
                                        selected: isSelected,
                                        side: isSelected
                                            ? BorderSide(color: theme.colorScheme.primary)
                                            : null,

                                        onSelected: (selected) {
                                          setState(() {
                                            _selectedCategory = category['name'];
                                          });
                                        },
                                      ),
                                    );
                                  }),
                                ],
                              ),
                            ),

                            SizedBox(height: height * 0.03),

                            // Підзаголовок: Завдання
                            Text(
                              l10n.tasks,
                              style: textTheme.bodyLarge?.copyWith(
                                fontSize: minSide * 0.045,
                              ),
                            ),

                            SizedBox(height: height * 0.015),

                            // Список карток завдань
                            ...tasks.map((task) {
                              return Padding(
                                padding: EdgeInsets.only(bottom: height * 0.015),
                                child: _buildTaskCard(
                                  context,
                                  task,
                                  width,
                                  height,
                                  minSide,
                                  l10n, // Передаємо l10n далі
                                ),
                              );
                            }),

                            SizedBox(height: height * 0.1),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.pushNamed(context, AppRoutes.newTask);
          },
          child: const Icon(Icons.add, size: 28),
        ),
      ),
    );
  }

  Widget _buildTaskCard(
      BuildContext context,
      Map<String, dynamic> task,
      double width,
      double height,
      double minSide,
      AppLocalizations l10n,
      ) {
    final theme = Theme.of(context);
    final detailTextStyle = theme.textTheme.bodyMedium?.copyWith(
      fontSize: minSide * 0.035,
    );

    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: BorderSide(
          color: theme.dividerColor,
          width: 1.5,
        ),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: () {
          Navigator.pushNamed(
            context,
            AppRoutes.editTask,
            arguments: task,
          );
        },
        child: Padding(
          padding: EdgeInsets.all(width * 0.03),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Center(
                child: Builder(builder: (context) {
                  const double baseCheckboxSize = 20.0;
                  final double desiredSize = (minSide * 0.05).clamp(12.0, 50.0);
                  final double checkboxScale = desiredSize / baseCheckboxSize;

                  return Transform.scale(
                    scale: checkboxScale,
                    alignment: Alignment.center,
                    child: SizedBox(
                      width: baseCheckboxSize,
                      height: baseCheckboxSize,
                      child: Checkbox(
                        value: task['completed'],
                        onChanged: (value) {
                          setState(() {
                            task['completed'] = value ?? false;
                          });
                        },
                      ),
                    ),
                  );
                }),
              ),

              SizedBox(width: width * 0.03),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      task['title'],
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                        fontSize: minSide * 0.045,
                        decoration: task['completed'] ? TextDecoration.lineThrough : null,
                      ),
                    ),
                    SizedBox(height: height * 0.01),

                    LayoutBuilder(
                      builder: (context, constraints) {
                        final spacing = width * 0.04;
                        Widget infoItem(String label, String value) {
                          return ConstrainedBox(
                            constraints: BoxConstraints(maxWidth: constraints.maxWidth),
                            child: Text(
                              '$label: $value',
                              style: detailTextStyle,
                              softWrap: false,
                              overflow: TextOverflow.ellipsis,
                            ),
                          );
                        }

                        return Wrap(
                          spacing: spacing,
                          runSpacing: 4,
                          children: [
                            // Тут використовуємо ключі з l10n
                            infoItem(l10n.status, task['status']),
                            infoItem(l10n.category, task['category']),
                          ],
                        );
                      },
                    ),

                    SizedBox(height: height * 0.005),
                    Text(
                      l10n.dueWithValue(task['due']),
                      style: detailTextStyle,
                    ),
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