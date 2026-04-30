import 'package:flutter/material.dart';
import '../l10n/app_localizations.dart';
import 'create_post_screen.dart';
import 'explore_screen.dart';
import 'feed_tab.dart';
import 'profile_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int selectedIndex = 0;

  final List<Widget> screens = const [
    FeedTab(),
    CreatePostScreen(),
    ExploreScreen(),
    ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    final lang = AppLocalizations.of(context);

    final titles = [
      lang.text('feed'),
      lang.text('create'),
      lang.text('explore'),
      lang.text('profile'),
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text(titles[selectedIndex]),
        centerTitle: true,
      ),
      body: PageTransitionSwitcher(
        child: screens[selectedIndex],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: selectedIndex,
        type: BottomNavigationBarType.fixed,
        onTap: (index) {
          setState(() {
            selectedIndex = index;
          });
        },
        items: [
          BottomNavigationBarItem(
            icon: const Icon(Icons.home),
            label: lang.text('feed'),
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.add_circle_outline),
            label: lang.text('create'),
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.explore),
            label: lang.text('explore'),
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.person),
            label: lang.text('profile'),
          ),
        ],
      ),
    );
  }
}

class PageTransitionSwitcher extends StatelessWidget {
  final Widget child;

  const PageTransitionSwitcher({
    super.key,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 250),
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
        key: ValueKey(child.runtimeType),
        child: child,
      ),
    );
  }
}