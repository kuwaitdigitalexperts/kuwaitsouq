import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/providers/auth_provider.dart';
import '../../core/providers/ads_provider.dart';
import '../../core/localization/app_localizations.dart';
import '../../core/services/social_auth_service.dart';
import '../theme/app_theme.dart';
import 'kuwaitsouq_logo.dart';

/* 
 * NOTE: Phone Auth is commented out for now as requested.
 * Email & Password + Google + Apple are active.
 *
 * import '../../core/providers/country_provider.dart';
 * import '../../core/constants/country_codes.dart';
 * import 'country_picker_bottom_sheet.dart';
 */

class AuthBottomSheet {
  static Future<bool?> show(BuildContext context) {
    return showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => const _AuthSheetContent(),
    );
  }
}

class _AuthSheetContent extends StatefulWidget {
  const _AuthSheetContent();

  @override
  State<_AuthSheetContent> createState() => _AuthSheetContentState();
}

class _AuthSheetContentState extends State<_AuthSheetContent> {
  bool _isSignUp = false;
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;
  bool _isLoading = false;
  String? _activeProvider;
  String _loadingStatus = '';
  String? _errorMessage;

  /*
   * Phone auth state (commented out for now):
   * CountryCode _selectedCountry = CountryCodes.defaultCountry;
   * final TextEditingController _phoneController = TextEditingController();
   */

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _handleEmailAuth() async {
    if (_isLoading) return;

    final isAr = context.isArabic;
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();
    final name = _nameController.text.trim();

    if (_isSignUp && name.isEmpty) {
      setState(() => _errorMessage = isAr ? 'يرجى إدخال الاسم بالكامل' : 'Please enter your full name');
      return;
    }

    if (email.isEmpty || !email.contains('@') || !email.contains('.')) {
      setState(() => _errorMessage = isAr ? 'يرجى إدخال بريد إلكتروني صحيح' : 'Please enter a valid email address');
      return;
    }

    if (password.length < 6) {
      setState(() => _errorMessage = isAr ? 'كلمة المرور يجب أن لا تقل عن 6 أحرف' : 'Password must be at least 6 characters');
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = null;
      _loadingStatus = _isSignUp ? (isAr ? 'جاري إنشاء الحساب...' : 'Creating account...') : (isAr ? 'جاري تسجيل الدخول...' : 'Signing in...');
    });

    try {
      final auth = context.read<AuthProvider>();
      bool ok;
      if (_isSignUp) {
        ok = await auth.register(name, email, password);
      } else {
        ok = await auth.login(email, password);
      }

      if (!mounted) return;

      if (ok) {
        try {
          context.read<AdsProvider>().fetchAds();
        } catch (_) {}

        Navigator.of(context).pop(true);

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: const Color(0xFF059669),
            content: Text(
              _isSignUp
                  ? (isAr ? 'تم إنشاء الحساب بنجاح! أهلاً بك' : 'Account created successfully! Welcome')
                  : (isAr ? 'مرحباً بك مجدداً!' : 'Welcome back!'),
            ),
          ),
        );
      } else {
        setState(() {
          _errorMessage = auth.error ?? (isAr ? 'فشل تسجيل الدخول. تحقق من البيانات' : 'Authentication failed. Please check your credentials');
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = e.toString();
      });
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
          _loadingStatus = '';
        });
      }
    }
  }

  Future<void> _handleSocialLogin(String provider) async {
    if (_isLoading) return;

    final isAr = context.isArabic;
    setState(() {
      _isLoading = true;
      _activeProvider = provider;
      _loadingStatus = isAr ? 'جاري الاتصال بـ $provider...' : 'Connecting to $provider...';
      _errorMessage = null;
    });

    try {
      SocialAuthResult result;
      if (provider == 'Google') {
        result = await SocialAuthService.signInWithGoogle();
      } else if (provider == 'Apple') {
        result = await SocialAuthService.signInWithApple();
      } else {
        result = SocialAuthResult.error('Provider not supported', provider: provider);
      }

      if (!mounted) return;

      if (result.isCanceled) {
        setState(() {
          _isLoading = false;
          _activeProvider = null;
          _loadingStatus = '';
        });
        return;
      }

      if (result.isSuccess && result.email != null) {
        setState(() {
          _loadingStatus = isAr ? 'جاري الدخول إلى سوق الكويت...' : 'Signing in to KuwaitSouq...';
        });

        final auth = context.read<AuthProvider>();
        final ok = await auth.loginWithSocial(
          email: result.email!,
          name: result.displayName ?? 'KuwaitSouq User',
          provider: provider,
          photoUrl: result.photoUrl,
        );

        if (!mounted) return;

        if (ok) {
          try {
            context.read<AdsProvider>().fetchAds();
          } catch (_) {}

          Navigator.of(context).pop(true);

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              backgroundColor: const Color(0xFF059669),
              content: Text(
                isAr
                    ? 'أهلاً بك، ${result.displayName ?? "عضو سوق الكويت"}!'
                    : 'Welcome, ${result.displayName ?? "KuwaitSouq Member"}!',
              ),
            ),
          );
          return;
        } else {
          setState(() {
            _errorMessage = auth.error ?? (isAr ? 'فشل الدخول بحساب $provider' : 'Sign in failed');
          });
        }
      } else if (result.isError) {
        setState(() {
          _errorMessage = result.errorMessage ?? 'Sign in with $provider failed.';
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _errorMessage = 'Sign-in error: $e';
        });
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
          _activeProvider = null;
          _loadingStatus = '';
        });
      }
    }
  }

  /*
   * Phone auth send OTP handler (commented out for now):
   * void _handleSendOtp() { ... }
   */

  @override
  Widget build(BuildContext context) {
    final isAr = context.isArabic;

    return Container(
      decoration: const BoxDecoration(
        color: AppTheme.surfaceWhite,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      padding: EdgeInsets.only(
        left: 22,
        right: 22,
        top: 14,
        bottom: MediaQuery.of(context).viewInsets.bottom + 18,
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Drag handle
            Container(
              width: 44,
              height: 4,
              decoration: BoxDecoration(
                color: const Color(0xFFE2E8F0),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 14),

            // Header: KuwaitSouq Logo
            const KuwaitSouqLogo(
              fontSize: 24.0,
              isWhite: false,
              showTagline: false,
            ),
            const SizedBox(height: 12),

            // Mode Tabs (Sign In / Create Account)
            Container(
              height: 42,
              padding: const EdgeInsets.all(3),
              decoration: BoxDecoration(
                color: const Color(0xFFF1F5F9),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: InkWell(
                      onTap: _isLoading
                          ? null
                          : () {
                              setState(() {
                                _isSignUp = false;
                                _errorMessage = null;
                              });
                            },
                      borderRadius: BorderRadius.circular(9),
                      child: Container(
                        decoration: BoxDecoration(
                          color: !_isSignUp ? Colors.white : Colors.transparent,
                          borderRadius: BorderRadius.circular(9),
                          boxShadow: !_isSignUp
                              ? [
                                  BoxShadow(
                                    color: Colors.black.withValues(alpha: 0.05),
                                    blurRadius: 4,
                                    offset: const Offset(0, 1),
                                  ),
                                ]
                              : null,
                        ),
                        child: Center(
                          child: Text(
                            isAr ? 'تسجيل الدخول' : 'Sign In',
                            style: TextStyle(
                              fontSize: 12.5,
                              fontWeight: !_isSignUp ? FontWeight.w900 : FontWeight.w600,
                              color: !_isSignUp ? const Color(0xFF1E3A8A) : const Color(0xFF64748B),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: InkWell(
                      onTap: _isLoading
                          ? null
                          : () {
                              setState(() {
                                _isSignUp = true;
                                _errorMessage = null;
                              });
                            },
                      borderRadius: BorderRadius.circular(9),
                      child: Container(
                        decoration: BoxDecoration(
                          color: _isSignUp ? Colors.white : Colors.transparent,
                          borderRadius: BorderRadius.circular(9),
                          boxShadow: _isSignUp
                              ? [
                                  BoxShadow(
                                    color: Colors.black.withValues(alpha: 0.05),
                                    blurRadius: 4,
                                    offset: const Offset(0, 1),
                                  ),
                                ]
                              : null,
                        ),
                        child: Center(
                          child: Text(
                            isAr ? 'إنشاء حساب جديد' : 'Create Account',
                            style: TextStyle(
                              fontSize: 12.5,
                              fontWeight: _isSignUp ? FontWeight.w900 : FontWeight.w600,
                              color: _isSignUp ? const Color(0xFF1E3A8A) : const Color(0xFF64748B),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 14),

            // Error Message Banner
            if (_errorMessage != null) ...[
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: const Color(0xFFFEF2F2),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: const Color(0xFFFECACA)),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.error_outline, color: Color(0xFFDC2626), size: 16),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        _errorMessage!,
                        style: const TextStyle(color: Color(0xFFDC2626), fontSize: 11.5, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 10),
            ],

            // Input Fields
            if (_isSignUp) ...[
              // Full Name field for registration
              Container(
                decoration: BoxDecoration(
                  color: const Color(0xFFF8FAFC),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: const Color(0xFFE2E8F0)),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: TextField(
                  controller: _nameController,
                  enabled: !_isLoading,
                  textInputAction: TextInputAction.next,
                  style: const TextStyle(fontSize: 13.5, color: Color(0xFF0F172A)),
                  decoration: InputDecoration(
                    icon: const Icon(Icons.person_outline, size: 20, color: Color(0xFF2563EB)),
                    border: InputBorder.none,
                    hintText: isAr ? 'الاسم الكامل أو اسم النشاط' : 'Full Name or Business Name',
                    hintStyle: const TextStyle(fontSize: 12.5, color: Color(0xFF94A3B8)),
                  ),
                ),
              ),
              const SizedBox(height: 10),
            ],

            // Email Input Field
            Container(
              decoration: BoxDecoration(
                color: const Color(0xFFF8FAFC),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: const Color(0xFFE2E8F0)),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: TextField(
                controller: _emailController,
                enabled: !_isLoading,
                keyboardType: TextInputType.emailAddress,
                textInputAction: TextInputAction.next,
                style: const TextStyle(fontSize: 13.5, color: Color(0xFF0F172A)),
                decoration: InputDecoration(
                  icon: const Icon(Icons.mail_outline, size: 20, color: Color(0xFF2563EB)),
                  border: InputBorder.none,
                  hintText: isAr ? 'البريد الإلكتروني' : 'Email address',
                  hintStyle: const TextStyle(fontSize: 12.5, color: Color(0xFF94A3B8)),
                ),
              ),
            ),
            const SizedBox(height: 10),

            // Password Input Field
            Container(
              decoration: BoxDecoration(
                color: const Color(0xFFF8FAFC),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: const Color(0xFFE2E8F0)),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: TextField(
                controller: _passwordController,
                enabled: !_isLoading,
                obscureText: _obscurePassword,
                textInputAction: TextInputAction.done,
                onSubmitted: (_) => _handleEmailAuth(),
                style: const TextStyle(fontSize: 13.5, color: Color(0xFF0F172A)),
                decoration: InputDecoration(
                  icon: const Icon(Icons.lock_outline, size: 20, color: Color(0xFF2563EB)),
                  border: InputBorder.none,
                  hintText: isAr ? 'كلمة المرور' : 'Password (min. 6 characters)',
                  hintStyle: const TextStyle(fontSize: 12.5, color: Color(0xFF94A3B8)),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscurePassword ? Icons.visibility_off : Icons.visibility,
                      size: 18,
                      color: const Color(0xFF94A3B8),
                    ),
                    onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 14),

            /*
             * Phone Auth UI (commented out for now):
             * Container( ... phone input + Country Picker ... ),
             * SizedBox(height: 10),
             * SizedBox( ... Send OTP Button ... ),
             */

            // Submit Button
            SizedBox(
              width: double.infinity,
              height: 46,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF2563EB),
                  foregroundColor: Colors.white,
                  elevation: 1,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                onPressed: _isLoading ? null : _handleEmailAuth,
                child: _isLoading && _activeProvider == null
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(strokeWidth: 2.2, color: Colors.white),
                      )
                    : Text(
                        _isSignUp ? (isAr ? 'إنشاء الحساب' : 'Create Account') : (isAr ? 'تسجيل الدخول' : 'Sign In'),
                        style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                      ),
              ),
            ),
            const SizedBox(height: 16),

            // Social divider
            Row(
              children: [
                const Expanded(child: Divider(color: Color(0xFFE2E8F0))),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Text(
                    isAr ? 'أو المتابعة عبر' : 'Or continue with',
                    style: const TextStyle(color: Color(0xFF94A3B8), fontSize: 11),
                  ),
                ),
                const Expanded(child: Divider(color: Color(0xFFE2E8F0))),
              ],
            ),
            const SizedBox(height: 12),

            // Social Buttons: Google & Apple
            Row(
              children: [
                // Google Button
                Expanded(
                  child: _buildSocialButton(
                    label: 'Google',
                    icon: Container(
                      width: 22,
                      height: 22,
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                      ),
                      child: const Center(
                        child: Text(
                          'G',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w900,
                            color: Color(0xFF4285F4),
                          ),
                        ),
                      ),
                    ),
                    isLoading: _activeProvider == 'Google',
                    onTap: () => _handleSocialLogin('Google'),
                  ),
                ),
                const SizedBox(width: 10),

                // Apple Button
                Expanded(
                  child: _buildSocialButton(
                    label: 'Apple',
                    icon: const Icon(Icons.apple, color: Colors.black, size: 22),
                    isLoading: _activeProvider == 'Apple',
                    onTap: () => _handleSocialLogin('Apple'),
                  ),
                ),
              ],
            ),

            // Loading Status
            if (_isLoading && _loadingStatus.isNotEmpty) ...[
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
                decoration: BoxDecoration(
                  color: const Color(0xFFEFF6FF),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const SizedBox(
                      width: 14,
                      height: 14,
                      child: CircularProgressIndicator(strokeWidth: 2, color: Color(0xFF2563EB)),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      _loadingStatus,
                      style: const TextStyle(
                        color: Color(0xFF2563EB),
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ],

            const SizedBox(height: 12),
            const Text(
              'KuwaitSouq • سوق الكويت',
              style: TextStyle(
                fontSize: 10.5,
                fontWeight: FontWeight.bold,
                color: Color(0xFF94A3B8),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSocialButton({
    required String label,
    required Widget icon,
    required bool isLoading,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: _isLoading ? null : onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        height: 44,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: const Color(0xFFCBD5E1), width: 1.1),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.03),
              blurRadius: 4,
              offset: const Offset(0, 1),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (isLoading)
              const SizedBox(
                width: 16,
                height: 16,
                child: CircularProgressIndicator(strokeWidth: 2, color: Color(0xFF2563EB)),
              )
            else
              icon,
            const SizedBox(width: 8),
            Text(
              label,
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w700,
                color: Color(0xFF0F172A),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
