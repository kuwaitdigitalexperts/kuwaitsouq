import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'core/providers/auth_provider.dart';
import 'features/welcome/screens/welcome_screen.dart';
import 'features/auth/screens/login_screen.dart';
import 'features/auth/screens/register_screen.dart';
import 'features/home/screens/home_screen.dart';
import 'features/ads/screens/ad_detail_screen.dart';
import 'features/ads/screens/post_ad_screen.dart';
import 'features/ads/screens/search_screen.dart';
import 'features/ads/screens/category_ads_screen.dart';
import 'features/categories/screens/categories_screen.dart';
import 'features/categories/screens/subcategories_screen.dart';
import 'features/chat/screens/chat_screen.dart';
import 'features/chat/screens/conversations_screen.dart';
import 'features/saved/screens/saved_screen.dart';
import 'features/ads/screens/my_ads_screen.dart';
import 'features/ads/screens/boost_ad_screen.dart';
import 'features/listings/screens/listings_screen.dart';
import 'features/profile/screens/profile_screen.dart';
import 'shared/widgets/main_scaffold.dart';

GoRouter createRouter(BuildContext context) {
  final auth = Provider.of<AuthProvider>(context, listen: false);

  return GoRouter(
    initialLocation: '/',
    refreshListenable: auth,
    routes: [
      GoRoute(path: '/welcome', builder: (c, s) => const WelcomeScreen()),
      ShellRoute(
        builder: (context, state, child) => MainScaffold(child: child),
        routes: [
          GoRoute(path: '/', builder: (c, s) => const HomeScreen()),
          GoRoute(path: '/categories', builder: (c, s) => const CategoriesScreen()),
          GoRoute(path: '/listings', builder: (c, s) => const ListingsScreen()),
          GoRoute(path: '/account', builder: (c, s) => const ProfileScreen()),
          GoRoute(path: '/profile', builder: (c, s) => const ProfileScreen()),
          GoRoute(path: '/post-ad', builder: (c, s) => const PostAdScreen()),
          GoRoute(path: '/saved', builder: (c, s) => const SavedScreen()),
          GoRoute(
            path: '/subcategories/:parentId',
            builder: (c, s) {
              final extra = s.extra as Map<String, dynamic>? ?? {};
              return SubcategoriesScreen(
                parentId: int.parse(s.pathParameters['parentId']!),
                title: extra['title'] as String? ?? 'الأقسام',
              );
            },
          ),
          GoRoute(
            path: '/category-ads/:categoryId',
            builder: (c, s) {
              final extra = s.extra as Map<String, dynamic>? ?? {};
              return CategoryAdsScreen(
                categoryId: int.parse(s.pathParameters['categoryId']!),
                categoryName: extra['title'] as String? ?? 'الإعلانات',
                parentTitle: extra['parentTitle'] as String?,
              );
            },
          ),
          GoRoute(path: '/search', builder: (c, s) => const SearchScreen()),
          GoRoute(
            path: '/ads/:id',
            builder: (c, s) => AdDetailScreen(id: int.parse(s.pathParameters['id']!)),
          ),
          GoRoute(path: '/my-ads', builder: (c, s) => const MyAdsScreen()),
          GoRoute(path: '/messages', builder: (c, s) => const ConversationsScreen()),
          GoRoute(
            path: '/chat/:userId',
            builder: (c, s) {
              final extra = s.extra as Map<String, dynamic>? ?? {};
              return ChatScreen(
                userId: int.parse(s.pathParameters['userId']!),
                userName: extra['userName'] as String?,
                initialMessage: extra['initialMessage'] as String?,
                adId: extra['adId'] as int?,
              );
            },
          ),
          GoRoute(path: '/boost-ad', builder: (c, s) => const BoostAdScreen()),
        ],
      ),
      GoRoute(path: '/login', builder: (c, s) => const LoginScreen()),
      GoRoute(path: '/register', builder: (c, s) => const RegisterScreen()),
    ],
  );
}
