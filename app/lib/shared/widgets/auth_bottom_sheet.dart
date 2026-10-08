import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../core/providers/auth_provider.dart';
import '../../core/providers/ads_provider.dart';
import '../../core/providers/country_provider.dart';
import '../../core/localization/app_localizations.dart';
import '../../core/services/social_auth_service.dart';
import '../../core/constants/country_codes.dart';
import '../theme/app_theme.dart';
import 'kuwaitsouq_logo.dart';
import 'country_picker_bottom_sheet.dart';

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
  CountryCode _selectedCountry = CountryCodes.defaultCountry;
  final TextEditingController _phoneController = TextEditingController();
  bool _isLoading = false;
  String? _activeProvider;
  String _loadingStatus = '';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        setState(() {
          _selectedCountry = context.read<CountryProvider>().currentCountryCode;
        });
      }
    });
  }

  @override
  void dispose() {
    _phoneController.dispose();
    super.dispose();
  }

  void _handleSendOtp() {
    if (_isLoading) return;
    final phone = _phoneController.text.trim();
    Navigator.of(context).pop();
    context.push(
      '/login',
      extra: {
        'phone': phone,
        'country': _selectedCountry,
        'autoSend': phone.isNotEmpty,
      },
    );
  }

  Future<void> _handleSocialLogin(String provider) async {
    if (_isLoading) return;

    setState(() {
      _isLoading = true;
      _activeProvider = provider;
      _loadingStatus = 'Connecting to $provider...';
    });

    try {
      SocialAuthResult result;
      if (provider == 'Google') {
        result = await SocialAuthService.signInWithGoogle();
      } else if (provider == 'Facebook') {
        result = await SocialAuthService.signInWithFacebook();
      } else {
        result = SocialAuthResult.error('Apple Sign-In is only available on iOS devices.', provider: provider);
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
          _loadingStatus = 'Signing in to KuwaitSouq...';
        });

        final auth = Provider.of<AuthProvider>(context, listen: false);
        final ok = await auth.loginWithSocial(
          email: result.email!,
          name: result.displayName ?? 'KuwaitSouq User',
          provider: provider,
          photoUrl: result.photoUrl,
        );

        if (!mounted) return;

        if (ok) {
          try {
            Provider.of<AdsProvider>(context, listen: false).fetchAds();
          } catch (_) {}

          Navigator.of(context).pop(true);

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              backgroundColor: AppTheme.primaryGreen,
              content: Text('Welcome, ${result.displayName ?? 'KuwaitSouq Member'}!'),
            ),
          );
          return;
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              backgroundColor: Colors.redAccent,
              content: Text(auth.error ?? 'Authentication failed. Please try again.'),
            ),
          );
        }
      } else if (result.isError) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: Colors.redAccent,
            content: Text(result.errorMessage ?? 'Sign in with $provider failed.'),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: Colors.redAccent,
            content: Text('Sign-in error: $e'),
          ),
        );
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

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: AppTheme.surfaceWhite,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      padding: EdgeInsets.only(
        left: 24,
        right: 24,
        top: 14,
        bottom: MediaQuery.of(context).viewInsets.bottom + 16,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Drag handle
          Container(
            width: 44,
            height: 4,
            decoration: BoxDecoration(
              color: AppTheme.borderLight,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 18),

          // Header: "Welcome to" + KuwaitSouq Logo
          Text(
            context.tr('welcome_to'),
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w500,
              color: AppTheme.textMuted,
            ),
          ),
          const SizedBox(height: 4),
          const KuwaitSouqLogo(
            fontSize: 26.0,
            isWhite: false,
            showTagline: false,
          ),
          const SizedBox(height: 16),

          Text(
            context.tr('login_or_signup'),
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: AppTheme.textDark,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            context.tr('enter_mobile_hint'),
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 13, color: AppTheme.textMuted, height: 1.3),
          ),
          const SizedBox(height: 20),

          // Quick Phone Number Input preview / CTA field
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: AppTheme.scaffoldBg,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: AppTheme.borderLight, width: 1.2),
            ),
            child: Row(
              children: [
                InkWell(
                  onTap: _isLoading
                      ? null
                      : () async {
                          final selected = await CountryPickerBottomSheet.show(
                            context,
                            current: _selectedCountry,
                          );
                          if (selected != null) {
                            setState(() => _selectedCountry = selected);
                          }
                        },
                  borderRadius: BorderRadius.circular(8),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 6),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(_selectedCountry.flag, style: const TextStyle(fontSize: 18)),
                        const SizedBox(width: 6),
                        Text(
                          _selectedCountry.dialCode,
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: AppTheme.textDark,
                          ),
                        ),
                        const Icon(Icons.arrow_drop_down, color: AppTheme.textMuted, size: 18),
                      ],
                    ),
                  ),
                ),
                Container(
                  height: 24,
                  width: 1,
                  margin: const EdgeInsets.symmetric(horizontal: 6),
                  color: AppTheme.borderLight,
                ),
                Expanded(
                  child: TextField(
                    controller: _phoneController,
                    keyboardType: TextInputType.phone,
                    enabled: !_isLoading,
                    onSubmitted: (_) => _handleSendOtp(),
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: AppTheme.textDark,
                    ),
                    decoration: InputDecoration(
                      hintText: context.tr('mobile_number'),
                      hintStyle: const TextStyle(color: AppTheme.textMuted, fontSize: 14),
                      border: InputBorder.none,
                      isDense: true,
                      contentPadding: const EdgeInsets.symmetric(vertical: 8),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 14),

          // Send OTP Button
          SizedBox(
            width: double.infinity,
            height: 48,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.brandOrange,
                foregroundColor: Colors.white,
                elevation: 1,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
              ),
              onPressed: _isLoading ? null : _handleSendOtp,
              child: Text(
                context.tr('send_otp'),
                style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
              ),
            ),
          ),
          const SizedBox(height: 18),

          // Social icons row
          Row(
            children: [
              const Expanded(child: Divider(color: AppTheme.borderLight)),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Text(context.tr('or_continue_with'), style: const TextStyle(color: AppTheme.textMuted, fontSize: 11)),
              ),
              const Expanded(child: Divider(color: AppTheme.borderLight)),
            ],
          ),
          const SizedBox(height: 14),

          // Social options with active loader
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildMiniSocial(
                label: 'Google',
                icon: const Text('G', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w900, color: Color(0xFF4285F4))),
                isLoading: _activeProvider == 'Google',
                isAnyLoading: _isLoading,
                onTap: () => _handleSocialLogin('Google'),
              ),
              // Facebook option commented out for now as it is not implemented yet
              // _buildMiniSocial(
              //   label: 'Facebook',
              //   icon: const Icon(Icons.facebook, color: Color(0xFF1877F2), size: 24),
              //   isLoading: _activeProvider == 'Facebook',
              //   isAnyLoading: _isLoading,
              //   onTap: () => _handleSocialLogin('Facebook'),
              // ),
              _buildMiniSocial(
                label: 'Apple',
                icon: const Icon(Icons.apple, color: Colors.black, size: 26),
                isLoading: _activeProvider == 'Apple',
                isAnyLoading: _isLoading,
                onTap: () => _handleSocialLogin('Apple'),
              ),
            ],
          ),

          // Dynamic loading status indicator
          if (_isLoading) ...[
            const SizedBox(height: 14),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 9),
              decoration: BoxDecoration(
                color: AppTheme.primaryBlue.withOpacity(0.08),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppTheme.primaryBlue.withOpacity(0.2)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(
                    width: 15,
                    height: 15,
                    child: CircularProgressIndicator(strokeWidth: 2, color: AppTheme.primaryBlue),
                  ),
                  const SizedBox(width: 10),
                  Text(
                    _loadingStatus,
                    style: const TextStyle(
                      color: AppTheme.primaryBlue,
                      fontSize: 12.5,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ],

          // KuwaitSouq Footer
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: const Text(
              'KuwaitSouq • سوق الكويت',
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.bold,
                color: Color(0xFF2563EB),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMiniSocial({
    required String label,
    required Widget icon,
    required bool isLoading,
    required bool isAnyLoading,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: isAnyLoading ? null : onTap,
      borderRadius: BorderRadius.circular(12),
      child: AnimatedOpacity(
        opacity: isAnyLoading && !isLoading ? 0.45 : 1.0,
        duration: const Duration(milliseconds: 200),
        child: Container(
          width: 82,
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isLoading ? AppTheme.primaryBlue : AppTheme.borderLight,
              width: isLoading ? 1.5 : 1.0,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.04),
                blurRadius: 6,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                height: 26,
                child: Center(
                  child: isLoading
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(strokeWidth: 2.2, color: AppTheme.primaryBlue),
                        )
                      : icon,
                ),
              ),
              const SizedBox(height: 3),
              Text(
                label,
                style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: AppTheme.textDark),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
