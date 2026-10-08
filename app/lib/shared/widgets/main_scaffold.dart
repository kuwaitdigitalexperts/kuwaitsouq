import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'kuwaitsouq_logo.dart';

class MainScaffold extends StatefulWidget {
  final Widget child;
  const MainScaffold({super.key, required this.child});

  @override
  State<MainScaffold> createState() => _MainScaffoldState();
}

class _MainScaffoldState extends State<MainScaffold> {
  int _currentIndex = 0;

  static const _routes = ['/', '/categories', '/post-ad', '/listings', '/account'];

  void _onTabTapped(int index) {
    setState(() => _currentIndex = index);
    context.go(_routes[index]);
  }

  @override
  Widget build(BuildContext context) {
    final location = GoRouterState.of(context).matchedLocation;
    if (location == '/') {
      _currentIndex = 0;
    } else if (location.startsWith('/categories')) {
      _currentIndex = 1;
    } else if (location == '/post-ad') {
      _currentIndex = 2;
    } else if (location == '/listings') {
      _currentIndex = 3;
    } else if (location == '/account' || location == '/profile') {
      _currentIndex = 4;
    }

    return Scaffold(
      drawer: _buildAppDrawer(context),
      body: widget.child,
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          border: const Border(top: BorderSide(color: Color(0xFFE2E8F0), width: 1.0)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 8,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 4),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildNavItem(0, Icons.home_outlined, Icons.home, 'الرئيسية'),
                _buildNavItem(1, Icons.grid_view_outlined, Icons.grid_view, 'الأقسام'),
                _buildPostAdNavItem(),
                _buildNavItem(3, Icons.article_outlined, Icons.article, 'إعلاناتي'),
                _buildNavItem(4, Icons.person_outline, Icons.person, 'حسابي'),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(int index, IconData outlineIcon, IconData solidIcon, String label) {
    final isSelected = _currentIndex == index;
    const activeColor = Color(0xFF2563EB); // Royal Blue
    const inactiveColor = Color(0xFF64748B);

    return InkWell(
      onTap: () => _onTabTapped(index),
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              isSelected ? solidIcon : outlineIcon,
              color: isSelected ? activeColor : inactiveColor,
              size: 24,
            ),
            const SizedBox(height: 2),
            Text(
              label,
              style: TextStyle(
                fontSize: 10.5,
                fontWeight: isSelected ? FontWeight.w900 : FontWeight.w600,
                color: isSelected ? activeColor : inactiveColor,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Prominent Center "Post Ad" Button (+)
  Widget _buildPostAdNavItem() {
    return InkWell(
      onTap: () => _onTabTapped(2),
      borderRadius: BorderRadius.circular(20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF2563EB), Color(0xFF1D4ED8)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF2563EB).withOpacity(0.35),
                  blurRadius: 8,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: const Icon(Icons.add, color: Colors.white, size: 26),
          ),
          const SizedBox(height: 2),
          const Text(
            'أضف إعلان',
            style: TextStyle(
              fontSize: 10.5,
              fontWeight: FontWeight.bold,
              color: Color(0xFF2563EB),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAppDrawer(BuildContext context) {
    return Drawer(
      child: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(20),
              child: KuwaitSouqLogo(fontSize: 22.0, showTagline: true),
            ),
            const Divider(height: 1),
            ListTile(
              leading: const Icon(Icons.home, color: Color(0xFF2563EB)),
              title: const Text('الرئيسية'),
              onTap: () {
                Navigator.pop(context);
                context.go('/');
              },
            ),
            ListTile(
              leading: const Icon(Icons.grid_view, color: Color(0xFF0D9488)),
              title: const Text('الأقسام والتصنيفات'),
              onTap: () {
                Navigator.pop(context);
                context.go('/categories');
              },
            ),
            ListTile(
              leading: const Icon(Icons.favorite_outline, color: Color(0xFFE11D48)),
              title: const Text('المفضلة والإعلانات المحفوظة'),
              onTap: () {
                Navigator.pop(context);
                context.push('/saved');
              },
            ),
            ListTile(
              leading: const Icon(Icons.chat_bubble_outline, color: Color(0xFF2563EB)),
              title: const Text('الرسائل والمحادثات'),
              onTap: () {
                Navigator.pop(context);
                context.push('/messages');
              },
            ),
            ListTile(
              leading: const Icon(Icons.article, color: Color(0xFFF59E0B)),
              title: const Text('إعلاناتي'),
              onTap: () {
                Navigator.pop(context);
                context.go('/listings');
              },
            ),
            ListTile(
              leading: const Icon(Icons.person, color: Color(0xFF8B5CF6)),
              title: const Text('حسابي'),
              onTap: () {
                Navigator.pop(context);
                context.go('/account');
              },
            ),
            const Spacer(),
            const Padding(
              padding: EdgeInsets.all(16),
              child: Text(
                'KuwaitSouq v1.0.0 • سوق الكويت',
                style: TextStyle(fontSize: 11, color: Color(0xFF94A3B8)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
