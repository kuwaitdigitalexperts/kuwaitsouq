import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../shared/widgets/kuwaitsouq_logo.dart';
import '../../../../core/localization/app_localizations.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isArabic = context.isArabic;

    return Scaffold(
      backgroundColor: const Color(0xFF0F172A),
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Background Gradient with Kuwait/GCC Blue Tone
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color(0xFF1E3A8A),
                  Color(0xFF1E293B),
                  Color(0xFF0F172A),
                ],
              ),
            ),
          ),

          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 20),
              child: Column(
                children: [
                  const SizedBox(height: 20),

                  // KuwaitSouq Logo
                  const KuwaitSouqLogo(
                    fontSize: 34.0,
                    isWhite: true,
                    showTagline: true,
                  ),

                  const Spacer(),

                  // Center GCC Feature Cards
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.08),
                      borderRadius: BorderRadius.circular(24),
                      border: Border.all(color: Colors.white.withOpacity(0.15)),
                    ),
                    child: Column(
                      children: [
                        _buildFeatureRow(
                          icon: Icons.directions_car_filled,
                          title: isArabic ? 'حراج السيارات والمركبات' : 'Cars & Vehicles Market',
                          subtitle: isArabic ? 'عروض حصرية وفحص كايشها الفوري' : 'Exclusive deals & instant Kayishha inspection',
                        ),
                        const Divider(color: Colors.white12, height: 24),
                        _buildFeatureRow(
                          icon: Icons.apartment,
                          title: isArabic ? 'عقارات، أجهزة، ووظائف' : 'Real Estate, Electronics & Jobs',
                          subtitle: isArabic ? 'آلاف الإعلانات المتجددة يومياً' : 'Thousands of new listings updated daily',
                        ),
                        const Divider(color: Colors.white12, height: 24),
                        _buildFeatureRow(
                          icon: Icons.chat_bubble_outline,
                          title: isArabic ? 'تواصل مباشر وفوري' : 'Instant Direct Contact',
                          subtitle: isArabic ? 'محادثة مباشرة واتصال وواتساب بنقرة واحدة' : 'Live chat, phone call & WhatsApp in one tap',
                        ),
                      ],
                    ),
                  ),

                  const Spacer(),

                  // Kuwait Areas Badge
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      isArabic
                          ? '🇰🇼 سوق الكويت • جميع المناطق والمحافظات'
                          : '🇰🇼 Kuwait Souq • All Areas & Governorates',
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Explore Button
                  SizedBox(
                    width: double.infinity,
                    height: 52,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF2563EB),
                        foregroundColor: Colors.white,
                        elevation: 4,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      onPressed: () => context.go('/'),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            isArabic ? 'ابدأ التصفح الآن' : 'Start Exploring Now',
                            style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Icon(isArabic ? Icons.arrow_back_rounded : Icons.arrow_forward_rounded, size: 20),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 12),

                  // Sign In Button
                  SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.white,
                        side: BorderSide(color: Colors.white.withOpacity(0.3), width: 1.2),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      onPressed: () => context.push('/login'),
                      child: Text(
                        isArabic ? 'تسجيل الدخول / إنشاء حساب' : 'Sign In / Register',
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 12),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFeatureRow({
    required IconData icon,
    required String title,
    required String subtitle,
  }) {
    return Row(
      children: [
        Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            color: const Color(0xFF2563EB).withOpacity(0.2),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, color: const Color(0xFF60A5FA), size: 24),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                subtitle,
                style: const TextStyle(
                  fontSize: 11,
                  color: Color(0xFF94A3B8),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
