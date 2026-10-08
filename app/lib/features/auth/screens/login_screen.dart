import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/providers/auth_provider.dart';
import '../../../../core/providers/ads_provider.dart';
import '../../../../core/providers/country_provider.dart';
import '../../../../core/services/social_auth_service.dart';
import '../../../../core/services/phone_auth_service.dart';
import '../../../../core/constants/country_codes.dart';
import '../../../../shared/theme/app_theme.dart';
import '../../../../shared/widgets/kuwaitsouq_logo.dart';
import '../../../../shared/widgets/country_picker_bottom_sheet.dart';
import '../../../../core/localization/app_localizations.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _otpController = TextEditingController();

  bool _isPasswordMode = false;
  bool _isOtpSent = false;
  bool _obscurePassword = true;
  bool _isLocalLoading = false;
  String? _activeSocialProvider;
  String _socialLoadingStatus = '';
  String? _verificationId;
  int? _resendToken;
  CountryCode _selectedCountry = CountryCodes.defaultCountry;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      final auth = context.read<AuthProvider>();
      if (auth.isAuthenticated) {
        _navigateAfterAuth();
        return;
      }

      // Check if extra passed prefilled phone or country from guest bottom sheet
      final extra = GoRouterState.of(context).extra;
      bool countrySetFromExtra = false;
      if (extra is Map<String, dynamic>) {
        if (extra['phone'] is String && (extra['phone'] as String).isNotEmpty) {
          _phoneController.text = extra['phone'] as String;
        }
        if (extra['country'] is CountryCode) {
          countrySetFromExtra = true;
          setState(() {
            _selectedCountry = extra['country'] as CountryCode;
          });
        }
        if (extra['autoSend'] == true && _phoneController.text.isNotEmpty) {
          _handleSendOtp();
        }
      }
      if (!countrySetFromExtra) {
        final countryProv = context.read<CountryProvider>();
        setState(() {
          _selectedCountry = countryProv.currentCountryCode;
        });
      }
    });
  }

  void _navigateAfterAuth() {
    try {
      context.read<AdsProvider>().fetchAds();
    } catch (_) {}

    final from = GoRouterState.of(context).uri.queryParameters['from'];
    if (from != null && from.isNotEmpty) {
      context.go(from);
      return;
    }

    if (Navigator.of(context).canPop()) {
      Navigator.of(context).pop(true);
    } else {
      context.go('/');
    }
  }

  @override
  void dispose() {
    _phoneController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _otpController.dispose();
    super.dispose();
  }

  Future<void> _handleSendOtp({bool isResend = false}) async {
    final rawPhone = _phoneController.text.trim();
    if (rawPhone.isEmpty || rawPhone.length < 6) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          backgroundColor: Colors.redAccent,
          content: Text('Please enter a valid mobile number'),
        ),
      );
      return;
    }

    final fullPhoneNumber = '${_selectedCountry.dialCode}$rawPhone';
    setState(() => _isLocalLoading = true);

    try {
      await PhoneAuthService.verifyPhoneNumber(
        phoneNumber: fullPhoneNumber,
        forceResendingToken: isResend ? _resendToken : null,
        onCodeSent: (verificationId, resendToken) {
          if (!mounted) return;
          setState(() {
            _verificationId = verificationId;
            _resendToken = resendToken;
            _isOtpSent = true;
            _isLocalLoading = false;
          });
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              backgroundColor: AppTheme.primaryGreen,
              content: Text(
                isResend
                    ? 'OTP resent to $fullPhoneNumber'
                    : '6-digit OTP sent to $fullPhoneNumber',
              ),
            ),
          );
        },
        onAutoVerified: (credential) async {
          debugPrint('PhoneAuth: onAutoVerified triggered');
          if (!mounted) return;
          final auth = context.read<AuthProvider>();
          final ok = await auth.loginWithPhone(
            phoneNumber: fullPhoneNumber,
            uid: credential.user?.uid ?? rawPhone,
          );
          if (!mounted) return;
          if (ok) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                backgroundColor: AppTheme.primaryGreen,
                content: Text('Phone verified automatically! Welcome to KuwaitSouq.'),
              ),
            );
            _navigateAfterAuth();
          }
        },
        onFailed: (errorMessage) {
          if (!mounted) return;
          setState(() => _isLocalLoading = false);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              backgroundColor: Colors.redAccent,
              content: Text(errorMessage),
              duration: const Duration(seconds: 4),
            ),
          );
        },
      );
    } catch (e) {
      if (mounted) {
        setState(() => _isLocalLoading = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: Colors.redAccent,
            content: Text('Could not send verification code: $e'),
          ),
        );
      }
    }
  }

  Future<void> _handleVerifyOtp() async {
    final otp = _otpController.text.trim();
    if (otp.length < 6) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          backgroundColor: Colors.redAccent,
          content: Text('Please enter the 6-digit OTP received via SMS'),
        ),
      );
      return;
    }

    if (_verificationId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          backgroundColor: Colors.redAccent,
          content: Text('Verification session expired. Please request a new OTP.'),
        ),
      );
      return;
    }

    setState(() => _isLocalLoading = true);
    final rawPhone = _phoneController.text.trim();
    final fullPhoneNumber = '${_selectedCountry.dialCode}$rawPhone';

    try {
      final verifyResult = await PhoneAuthService.verifySmsCode(
        verificationId: _verificationId!,
        smsCode: otp,
      );

      if (!mounted) return;

      if (!verifyResult.isSuccess) {
        setState(() => _isLocalLoading = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: Colors.redAccent,
            content: Text(verifyResult.errorMessage ?? 'Invalid verification code.'),
          ),
        );
        return;
      }

      final auth = context.read<AuthProvider>();
      final ok = await auth.loginWithPhone(
        phoneNumber: fullPhoneNumber,
        uid: verifyResult.user?.uid ?? rawPhone,
      );

      if (!mounted) return;
      setState(() => _isLocalLoading = false);

      if (ok) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            backgroundColor: AppTheme.primaryGreen,
            content: Text('Mobile verified successfully! Welcome to KuwaitSouq.'),
          ),
        );
        _navigateAfterAuth();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: Colors.redAccent,
            content: Text(auth.error ?? 'Authentication sync failed. Please try again.'),
          ),
        );
      }
    } catch (err) {
      if (!mounted) return;
      setState(() => _isLocalLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.redAccent,
          content: Text('Verification error: $err'),
        ),
      );
    }
  }

  Future<void> _handleEmailLogin() async {
    final email = _emailController.text.trim();
    final pass = _passwordController.text;
    if (email.isEmpty || pass.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          backgroundColor: Colors.redAccent,
          content: Text('Please fill in both email and password'),
        ),
      );
      return;
    }

    debugPrint('📱 [LoginScreen] Email login attempt for: $email');
    final auth = context.read<AuthProvider>();
    final ok = await auth.login(email, pass);
    if (!mounted) return;
    if (ok) {
      _navigateAfterAuth();
    } else {
      final err = auth.error ?? 'Login failed';
      debugPrint('📱 [LoginScreen] Login failed with message: $err');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.redAccent,
          content: Text(err),
          duration: const Duration(seconds: 4),
        ),
      );
    }
  }

  Future<void> _handleSocialLogin(String provider) async {
    if (_isLocalLoading || context.read<AuthProvider>().loading) return;

    setState(() {
      _isLocalLoading = true;
      _activeSocialProvider = provider;
      _socialLoadingStatus = 'Connecting to $provider...';
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
        // User closed picker dialog without selecting
        return;
      }

      if (result.isSuccess && result.email != null) {
        setState(() {
          _socialLoadingStatus = 'Signing in to KuwaitSouq...';
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
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              backgroundColor: AppTheme.primaryGreen,
              content: Text('Welcome, ${result.displayName ?? 'KuwaitSouq Member'}!'),
            ),
          );
          _navigateAfterAuth();
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
            content: Text('Unexpected error: $e'),
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLocalLoading = false;
          _activeSocialProvider = null;
          _socialLoadingStatus = '';
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    final isLoading = auth.loading || _isLocalLoading;

    return Scaffold(
      backgroundColor: AppTheme.surfaceWhite,
      appBar: AppBar(
        backgroundColor: AppTheme.surfaceWhite,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: AppTheme.textDark, size: 20),
          onPressed: () {
            if (_isOtpSent) {
              setState(() => _isOtpSent = false);
            } else if (Navigator.of(context).canPop()) {
              Navigator.of(context).pop();
            } else {
              context.go('/');
            }
          },
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 26, vertical: 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Header: "Welcome to" + KuwaitSouq Logo
                    Text(
                      context.tr('welcome_to'),
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: AppTheme.textMuted,
                      ),
                    ),
                    const SizedBox(height: 6),
                    const KuwaitSouqLogo(
                      fontSize: 32.0,
                      isWhite: false,
                      showTagline: true,
                    ),
                    const SizedBox(height: 28),

                    // Section Heading
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        _isPasswordMode ? context.tr('sign_in_password') : context.tr('login_or_signup'),
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: AppTheme.textDark,
                          letterSpacing: -0.3,
                        ),
                      ),
                    ),
                    const SizedBox(height: 6),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        _isPasswordMode
                            ? context.tr('enter_password')
                            : _isOtpSent
                                ? '${context.tr('enter_otp')} (${_selectedCountry.dialCode} ${_phoneController.text})'
                                : context.tr('enter_mobile_hint'),
                        style: const TextStyle(
                          color: AppTheme.textMuted,
                          fontSize: 13,
                          height: 1.4,
                        ),
                      ),
                    ),
                    const SizedBox(height: 22),

                    // 1. Phone + OTP Flow OR 2. Password Flow
                    if (!_isPasswordMode) ...[
                      if (!_isOtpSent) ...[
                        // Mobile input with India country code
                        _buildPhoneInputField(),
                        const SizedBox(height: 20),

                        // Send OTP Button
                        SizedBox(
                          width: double.infinity,
                          height: 50,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppTheme.brandOrange,
                              foregroundColor: Colors.white,
                              elevation: 1,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(14),
                              ),
                            ),
                            onPressed: isLoading ? null : _handleSendOtp,
                            child: isLoading
                                ? const SizedBox(
                                    height: 22,
                                    width: 22,
                                    child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2.2),
                                  )
                                : Text(
                                    context.tr('send_otp'),
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      letterSpacing: 0.3,
                                    ),
                                  ),
                          ),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          context.tr('terms_agreement'),
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            color: AppTheme.textMuted,
                            fontSize: 11,
                            height: 1.3,
                          ),
                        ),
                      ] else ...[
                        // OTP Input Field
                        _buildOtpInputField(),
                        const SizedBox(height: 20),

                        // Verify & Continue Button
                        SizedBox(
                          width: double.infinity,
                          height: 50,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppTheme.brandOrange,
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(14),
                              ),
                            ),
                            onPressed: isLoading ? null : _handleVerifyOtp,
                            child: isLoading
                                ? const SizedBox(
                                    height: 22,
                                    width: 22,
                                    child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2.2),
                                  )
                                : Text(
                                    context.tr('verify_otp'),
                                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                                  ),
                          ),
                        ),
                        const SizedBox(height: 12),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            TextButton(
                              onPressed: () => setState(() => _isOtpSent = false),
                              child: Text(
                                context.tr('edit'),
                                style: const TextStyle(color: AppTheme.primaryBlue, fontSize: 13, fontWeight: FontWeight.w600),
                              ),
                            ),
                            TextButton(
                              onPressed: isLoading ? null : () => _handleSendOtp(isResend: true),
                              child: Text(
                                context.tr('resend_otp'),
                                style: const TextStyle(color: AppTheme.textDark, fontSize: 13, fontWeight: FontWeight.w600),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ] else ...[
                      // Email & Password Fields
                      _buildEmailPasswordFields(),
                      const SizedBox(height: 20),
                      SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppTheme.primaryBlue,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14),
                            ),
                          ),
                          onPressed: isLoading ? null : _handleEmailLogin,
                          child: isLoading
                              ? const SizedBox(
                                  height: 22,
                                  width: 22,
                                  child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2.2),
                                )
                              : Text(
                                  context.tr('login'),
                                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                                ),
                        ),
                      ),
                    ],

                    const SizedBox(height: 14),

                    // Toggle between Mobile and Password login
                    TextButton(
                      onPressed: () {
                        setState(() {
                          _isPasswordMode = !_isPasswordMode;
                          _isOtpSent = false;
                        });
                      },
                      child: Text(
                        _isPasswordMode ? '← ${context.tr('sign_in_otp')}' : context.tr('sign_in_password'),
                        style: const TextStyle(
                          color: AppTheme.primaryBlue,
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),

                    const SizedBox(height: 22),

                    // Social Sign-In Section
                    Row(
                      children: [
                        const Expanded(child: Divider(color: AppTheme.borderLight)),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 14),
                          child: Text(
                            context.tr('or_continue_with'),
                            style: const TextStyle(color: AppTheme.textMuted, fontSize: 12),
                          ),
                        ),
                        const Expanded(child: Divider(color: AppTheme.borderLight)),
                      ],
                    ),
                    const SizedBox(height: 20),

                    // 3 Social Buttons with Icon and Label underneath (Screen 2 design)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _buildSocialOption(
                          label: 'Google',
                          iconWidget: _buildGoogleIcon(),
                          isLoading: _activeSocialProvider == 'Google',
                          isAnyLoading: isLoading,
                          onTap: () => _handleSocialLogin('Google'),
                        ),
                        // Facebook option commented out for now as it is not implemented yet
                        // _buildSocialOption(
                        //   label: 'Facebook',
                        //   iconWidget: const Icon(Icons.facebook, color: Color(0xFF1877F2), size: 30),
                        //   isLoading: _activeSocialProvider == 'Facebook',
                        //   isAnyLoading: isLoading,
                        //   onTap: () => _handleSocialLogin('Facebook'),
                        // ),
                        _buildSocialOption(
                          label: 'Apple',
                          iconWidget: const Icon(Icons.apple, color: Colors.black, size: 32),
                          isLoading: _activeSocialProvider == 'Apple',
                          isAnyLoading: isLoading,
                          onTap: () => _handleSocialLogin('Apple'),
                        ),
                      ],
                    ),

                    if (isLoading && _activeSocialProvider != null) ...[
                      const SizedBox(height: 16),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                        decoration: BoxDecoration(
                          color: AppTheme.primaryBlue.withOpacity(0.08),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: AppTheme.primaryBlue.withOpacity(0.2)),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const SizedBox(
                              width: 16,
                              height: 16,
                              child: CircularProgressIndicator(strokeWidth: 2, color: AppTheme.primaryBlue),
                            ),
                            const SizedBox(width: 12),
                            Text(
                              _socialLoadingStatus.isNotEmpty
                                  ? _socialLoadingStatus
                                  : 'Signing in with $_activeSocialProvider...',
                              style: const TextStyle(
                                color: AppTheme.primaryBlue,
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],

                    const SizedBox(height: 18),

                    // Create Account text
                    TextButton(
                      onPressed: () => context.push('/register'),
                      child: Text(
                        context.tr('dont_have_account'),
                        style: const TextStyle(
                          color: AppTheme.primaryBlue,
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // KuwaitSouq Footer
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 14),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    'KuwaitSouq • سوق الكويت والخليج العربي',
                    style: TextStyle(
                      fontSize: 12.5,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF2563EB),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'سوق الإعلانات المبوبة الأول في الكويت',
                    style: TextStyle(
                      fontSize: 11,
                      color: Colors.grey.shade600,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPhoneInputField() {
    return Container(
      decoration: BoxDecoration(
        color: AppTheme.surfaceWhite,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppTheme.borderLight, width: 1.2),
      ),
      child: Row(
        children: [
          // Selectable Country Flag + Dial Code
          InkWell(
            onTap: () async {
              final selected = await CountryPickerBottomSheet.show(
                context,
                current: _selectedCountry,
              );
              if (selected != null) {
                setState(() => _selectedCountry = selected);
              }
            },
            borderRadius: const BorderRadius.horizontal(left: Radius.circular(14)),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(_selectedCountry.flag, style: const TextStyle(fontSize: 20)),
                  const SizedBox(width: 6),
                  Text(
                    _selectedCountry.dialCode,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: AppTheme.textDark,
                    ),
                  ),
                  const SizedBox(width: 4),
                  const Icon(Icons.arrow_drop_down, color: AppTheme.textMuted, size: 20),
                ],
              ),
            ),
          ),
          Container(
            height: 28,
            width: 1,
            color: AppTheme.borderLight,
          ),
          // Phone Input
          Expanded(
            child: TextFormField(
              controller: _phoneController,
              keyboardType: TextInputType.phone,
              maxLength: 15,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: AppTheme.textDark,
                letterSpacing: 1,
              ),
              decoration: InputDecoration(
                hintText: context.tr('mobile_number'),
                hintStyle: const TextStyle(
                  color: AppTheme.textMuted,
                  fontSize: 15,
                  fontWeight: FontWeight.normal,
                  letterSpacing: 0,
                ),
                counterText: '',
                border: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOtpInputField() {
    return Container(
      decoration: BoxDecoration(
        color: AppTheme.surfaceWhite,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppTheme.borderLight, width: 1.2),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: TextFormField(
        controller: _otpController,
        keyboardType: TextInputType.number,
        maxLength: 6,
        textAlign: TextAlign.center,
        style: const TextStyle(
          fontSize: 22,
          fontWeight: FontWeight.bold,
          letterSpacing: 10,
          color: AppTheme.primaryBlue,
        ),
        decoration: const InputDecoration(
          hintText: '• • • • • •',
          hintStyle: TextStyle(letterSpacing: 10, color: AppTheme.textMuted, fontSize: 24),
          counterText: '',
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(vertical: 14),
        ),
      ),
    );
  }

  Widget _buildEmailPasswordFields() {
    return Column(
      children: [
        TextFormField(
          controller: _emailController,
          keyboardType: TextInputType.emailAddress,
          decoration: InputDecoration(
            hintText: 'Email',
            prefixIcon: const Icon(Icons.email_outlined, color: AppTheme.textMuted, size: 20),
            filled: true,
            fillColor: AppTheme.surfaceWhite,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: const BorderSide(color: AppTheme.borderLight, width: 1.2),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: const BorderSide(color: AppTheme.borderLight, width: 1.2),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: const BorderSide(color: AppTheme.primaryBlue, width: 1.5),
            ),
          ),
        ),
        const SizedBox(height: 14),
        TextFormField(
          controller: _passwordController,
          obscureText: _obscurePassword,
          decoration: InputDecoration(
            hintText: context.tr('password'),
            prefixIcon: const Icon(Icons.lock_outline, color: AppTheme.textMuted, size: 20),
            suffixIcon: IconButton(
              icon: Icon(
                _obscurePassword ? Icons.visibility_outlined : Icons.visibility_off_outlined,
                color: AppTheme.textMuted,
                size: 20,
              ),
              onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
            ),
            filled: true,
            fillColor: AppTheme.surfaceWhite,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: const BorderSide(color: AppTheme.borderLight, width: 1.2),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: const BorderSide(color: AppTheme.borderLight, width: 1.2),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: const BorderSide(color: AppTheme.primaryGreen, width: 1.5),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSocialOption({
    required String label,
    required Widget iconWidget,
    required bool isLoading,
    required bool isAnyLoading,
    required VoidCallback onTap,
  }) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        InkWell(
          onTap: isAnyLoading ? null : onTap,
          borderRadius: BorderRadius.circular(16),
          child: AnimatedOpacity(
            opacity: isAnyLoading && !isLoading ? 0.45 : 1.0,
            duration: const Duration(milliseconds: 200),
            child: Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: isLoading ? AppTheme.primaryBlue : AppTheme.borderLight,
                  width: isLoading ? 1.5 : 1.2,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.04),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Center(
                child: isLoading
                    ? const SizedBox(
                        width: 22,
                        height: 22,
                        child: CircularProgressIndicator(strokeWidth: 2.5, color: AppTheme.primaryBlue),
                      )
                    : iconWidget,
              ),
            ),
          ),
        ),
        const SizedBox(height: 6),
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w500,
            color: AppTheme.textDark,
          ),
        ),
      ],
    );
  }

  Widget _buildGoogleIcon() {
    return Container(
      width: 28,
      height: 28,
      decoration: const BoxDecoration(shape: BoxShape.circle),
      child: Center(
        child: Text(
          'G',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w900,
            foreground: Paint()
              ..shader = const LinearGradient(
                colors: [Color(0xFF4285F4), Color(0xFFEA4335), Color(0xFFFBBC05), Color(0xFF34A853)],
              ).createShader(const Rect.fromLTWH(0, 0, 28, 28)),
          ),
        ),
      ),
    );
  }
}
