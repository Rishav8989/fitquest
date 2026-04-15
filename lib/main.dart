import 'dart:io';


import 'package:fitquest/screens/progress_screen.dart';
import 'package:fitquest/services/app_state.dart';
import 'package:fitquest/services/step_count_service.dart';
import 'package:fitquest/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:fitquest/screens/dashboard_screen.dart';
import 'package:fitquest/screens/workouts_screen.dart';
import 'package:fitquest/screens/food_tracking_screen.dart';
import 'package:fitquest/screens/profile_screen.dart';
import 'package:fitquest/screens/edit_profile_screen.dart';
import 'package:fitquest/screens/ai_food_questionnaire_screen.dart';
import 'package:fitquest/screens/ai_exercise_questionnaire_screen.dart';
import 'package:fitquest/screens/quick_add_screen.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:tutorial_coach_mark/tutorial_coach_mark.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (Platform.isWindows || Platform.isLinux) {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
  }
  final prefs = await SharedPreferences.getInstance();
  final isDark = prefs.getBool('nutriquest_theme_dark') ?? false;
  final themeProvider = ThemeProvider(initialDark: isDark);
  final appState = AppState();
  // Accurate step tracking from device motion (Android). No external devices.
  final stepService = StepCountService(onStepsUpdated: appState.setTodaySteps);
  await stepService.start();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: themeProvider),
        ChangeNotifierProvider.value(value: appState),
      ],
      child: const MyApp(),
    ),
  );
}

class ThemeProvider with ChangeNotifier {
  static const _key = 'nutriquest_theme_dark';

  ThemeMode _themeMode;

  ThemeProvider({bool initialDark = false})
      : _themeMode = initialDark ? ThemeMode.dark : ThemeMode.light;

  ThemeMode get themeMode => _themeMode;

  void toggleTheme() {
    _themeMode = _themeMode == ThemeMode.light ? ThemeMode.dark : ThemeMode.light;
    SharedPreferences.getInstance().then((prefs) {
      prefs.setBool(_key, _themeMode == ThemeMode.dark);
    });
    notifyListeners();
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) {
        return MaterialApp(
          title: 'NutriQuest',
          theme: AppTheme.light,
          darkTheme: AppTheme.dark,
          themeMode: themeProvider.themeMode,
          home: const HomeScreen(),
        );
      },
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  TutorialCoachMark? tutorialCoachMark;
  List<TargetFocus> targets = [];

  final GlobalKey _themeKey = GlobalKey();
  final GlobalKey _profileKey = GlobalKey();
  final GlobalKey _homeKey = GlobalKey();
  final GlobalKey _workoutKey = GlobalKey();
  final GlobalKey _foodKey = GlobalKey();
  final GlobalKey _progressKey = GlobalKey();
  final GlobalKey _fabKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    _checkFirstRun();
  }

  Future<void> _checkFirstRun() async {
    final prefs = await SharedPreferences.getInstance();
    final isFirstRun = prefs.getBool('first_run_tutorial') ?? true;
    if (isFirstRun) {
      Future.delayed(const Duration(milliseconds: 500), () async {
        if (context.mounted) {
          await Navigator.push(context, MaterialPageRoute(builder: (context) => const EditProfileScreen(isOnboarding: true)));
          if (context.mounted) {
            _askForTutorial();
          }
        }
      });
      await prefs.setBool('first_run_tutorial', false);
    }
  }

  void _askForTutorial() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: const Text("Welcome to FitQuest!"),
        content: const Text("Would you like a quick tour of the app features?"),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text("Skip All"),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              _showTutorial();
            },
            child: const Text("Start Tutorial"),
          ),
        ],
      ),
    );
  }

  void _showTutorial() {
    _initTargets();
    tutorialCoachMark = TutorialCoachMark(
      targets: targets,
      colorShadow: Colors.black,
      textSkip: "SKIP ALL",
      paddingFocus: 10,
      opacityShadow: 0.8,
      onFinish: () {},
      onClickTarget: (target) {
        if (target.identify == "HomeTab") {
          setState(() => _selectedIndex = 0);
        } else if (target.identify == "WorkoutTab") {
          setState(() => _selectedIndex = 1);
        } else if (target.identify == "FoodTab") {
          setState(() => _selectedIndex = 2);
        } else if (target.identify == "ProgressTab") {
          setState(() => _selectedIndex = 3);
        }
      },
      onClickOverlay: (target) {},
      onSkip: () => true,
    )..show(context: context);
  }

  void _initTargets() {
    targets.clear();
    targets.add(
      TargetFocus(
        identify: "ThemeToggle",
        keyTarget: _themeKey,
        contents: [
          TargetContent(
            align: ContentAlign.bottom,
            builder: (context, controller) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const <Widget>[
                  Text(
                    "Theme Toggle",
                    style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white, fontSize: 20.0),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 10.0),
                    child: Text(
                      "Switch between light and dark mode here.",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
    targets.add(
      TargetFocus(
        identify: "Profile",
        keyTarget: _profileKey,
        contents: [
          TargetContent(
            align: ContentAlign.bottom,
            builder: (context, controller) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const <Widget>[
                  Text(
                    "User Profile",
                    style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white, fontSize: 20.0),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 10.0),
                    child: Text(
                      "Access your profile settings, goals, and personal information.",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
    targets.add(
      TargetFocus(
        identify: "HomeTab",
        keyTarget: _homeKey,
        contents: [
          TargetContent(
            align: ContentAlign.top,
            builder: (context, controller) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const <Widget>[
                  Text(
                    "Dashboard",
                    style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white, fontSize: 20.0),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 10.0),
                    child: Text(
                      "Your daily summary of workouts, calories, and step counts.",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
    targets.add(
      TargetFocus(
        identify: "WorkoutTab",
        keyTarget: _workoutKey,
        contents: [
          TargetContent(
            align: ContentAlign.top,
            builder: (context, controller) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const <Widget>[
                  Text(
                    "Workouts",
                    style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white, fontSize: 20.0),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 10.0),
                    child: Text(
                      "Track your exercises, routines, and physical activities.",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
    targets.add(
      TargetFocus(
        identify: "FoodTab",
        keyTarget: _foodKey,
        contents: [
          TargetContent(
            align: ContentAlign.top,
            builder: (context, controller) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const <Widget>[
                  Text(
                    "Food Tracking",
                    style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white, fontSize: 20.0),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 10.0),
                    child: Text(
                      "Log your meals, count calories, and track macros.",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
    targets.add(
      TargetFocus(
        identify: "ProgressTab",
        keyTarget: _progressKey,
        contents: [
          TargetContent(
            align: ContentAlign.top,
            builder: (context, controller) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const <Widget>[
                  Text(
                    "Progress",
                    style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white, fontSize: 20.0),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 10.0),
                    child: Text(
                      "View your statistics, charts, and overall fitness journey.",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
    targets.add(
      TargetFocus(
        identify: "FAB",
        keyTarget: _fabKey,
        shape: ShapeLightFocus.Circle,
        contents: [
          TargetContent(
            align: ContentAlign.top,
            builder: (context, controller) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const <Widget>[
                  Text(
                    "Quick Add",
                    style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white, fontSize: 20.0),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 10.0),
                    child: Text(
                      "Tap here to quickly add a new workout or food log depending on the tab.",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }

  static const List<Widget> _widgetOptions = <Widget>[
    DashboardScreen(),
    WorkoutsScreen(),
    FoodTrackingScreen(),
    ProgressScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('FitQuest'),
        actions: [
          IconButton(
            key: _themeKey,
            onPressed: () {
              themeProvider.toggleTheme();
            },
            icon: Icon(
              themeProvider.themeMode == ThemeMode.light ? LucideIcons.moon : LucideIcons.sun,
            ),
          ),
          IconButton(
            key: _profileKey,
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const ProfileScreen()),
              );
            },
            icon: const Icon(LucideIcons.user),
          ),
        ],
      ),
      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 280),
        switchInCurve: Curves.easeOutCubic,
        switchOutCurve: Curves.easeInCubic,
        transitionBuilder: (child, animation) {
          return FadeTransition(
            opacity: animation,
            child: SlideTransition(
              position: Tween<Offset>(
                begin: const Offset(0.03, 0),
                end: Offset.zero,
              ).animate(animation),
              child: child,
            ),
          );
        },
        child: KeyedSubtree(
          key: ValueKey<int>(_selectedIndex),
          child: _widgetOptions.elementAt(_selectedIndex),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        type: BottomNavigationBarType.fixed,
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(LucideIcons.home, key: _homeKey),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(LucideIcons.dumbbell, key: _workoutKey),
            label: 'Workout',
          ),
          BottomNavigationBarItem(
            icon: Icon(LucideIcons.utensilsCrossed, key: _foodKey),
            label: 'Food',
          ),
          BottomNavigationBarItem(
            icon: Icon(LucideIcons.map, key: _progressKey),
            label: 'Progress',
          ),
        ],
      ),
      floatingActionButton: _AnimatedFAB(
        key: _fabKey,
        selectedIndex: _selectedIndex,
        onPressed: () {
          if (_selectedIndex == 0) {
            Navigator.push(context, MaterialPageRoute(builder: (context) => const QuickAddScreen()));
          } else if (_selectedIndex == 2) {
            Navigator.push(context, MaterialPageRoute(builder: (context) => const AiFoodQuestionnaireScreen()));
          } else if (_selectedIndex == 1) {
            Navigator.push(context, MaterialPageRoute(builder: (context) => const AiExerciseQuestionnaireScreen()));
          }
        },
      ),
    );
  }
}

class _AnimatedFAB extends StatefulWidget {
  const _AnimatedFAB({
    super.key,
    required this.selectedIndex,
    required this.onPressed,
  });

  final int selectedIndex;
  final VoidCallback onPressed;

  @override
  State<_AnimatedFAB> createState() => _AnimatedFABState();
}

class _AnimatedFABState extends State<_AnimatedFAB>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scale;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 120),
    );
    _scale = Tween<double>(begin: 1, end: 0.9).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: _scale,
      child: GestureDetector(
        onTapDown: (_) => _controller.forward(),
        onTapUp: (_) => _controller.reverse(),
        onTapCancel: () => _controller.reverse(),
        onTap: widget.onPressed,
        child: FloatingActionButton(
          onPressed: null,
          child: Icon(
            widget.selectedIndex == 2
                ? LucideIcons.utensilsCrossed
                : widget.selectedIndex == 1
                    ? LucideIcons.dumbbell
                    : LucideIcons.plus,
            size: 26,
          ),
        ),
      ),
    );
  }
}
