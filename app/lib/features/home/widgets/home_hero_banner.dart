import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../../../core/providers/auth_provider.dart';
import '../../../../core/providers/ads_provider.dart';
import '../../../../shared/widgets/auth_bottom_sheet.dart';

class HomeHeroBanner extends StatelessWidget {
  const HomeHeroBanner({super.key});

  Future<void> _onPostAdTapped(BuildContext context) async {
    final auth = Provider.of<AuthProvider>(context, listen: false);
    if (!auth.isAuthenticated) {
      final ok = await AuthBottomSheet.show(context);
      if (ok == true && context.mounted) {
        try {
          context.read<AdsProvider>().fetchAds();
        } catch (_) {}
        context.push('/post-ad');
      }
      return;
    }
    context.push('/post-ad');
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final w = constraints.maxWidth;
        final h = w * (285.0 / 571.0); // Exact aspect ratio of the hero graphic

        return SizedBox(
          width: w,
          height: h,
          child: Stack(
            fit: StackFit.expand,
            children: [
              // 1. Scenic hero banner graphic with clean fallback
              Image.asset(
                'assets/images/home_hero_banner.png',
                width: w,
                height: h,
                fit: BoxFit.fill,
                errorBuilder: (ctx, err, stack) => Container(
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Color(0xFF0F766E), Color(0xFF0D9488)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: const Center(
                    child: Text(
                      'سوق الكويت والخليج - بيع واشتري كل شي',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),

              // 2. Interactive Search Bar Overlay
              Positioned(
                left: w * 0.04,
                width: w * 0.69,
                top: h * 0.56,
                bottom: h * 0.28,
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    borderRadius: BorderRadius.circular(24),
                    onTap: () => context.push('/search'),
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(24),
                      ),
                    ),
                  ),
                ),
              ),

              // 3. Interactive Red/Orange "Post Ad" Banner Button Overlay
              Positioned(
                left: w * 0.04,
                width: w * 0.59,
                top: h * 0.74,
                bottom: h * 0.04,
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    borderRadius: BorderRadius.circular(24),
                    onTap: () => _onPostAdTapped(context),
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(24),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
