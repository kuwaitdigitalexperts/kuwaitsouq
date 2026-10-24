class AppConstants {
  static const String appName = 'KuwaitSouq';
  static const String appNameAr = 'سوق الكويت';
  static const String appTagline = 'سوق الكويت الأول - بيع واشتري كل شي';
  static const String supportEmail = 'support@kuwaitsouq.com';
  static const String supportPhone = '+965 99001122';

  // Kuwait Country Definition
  static const Map<String, dynamic> kuwaitCountry = {
    'id': 1,
    'name': 'Kuwait',
    'name_ar': 'الكويت',
    'code': 'KW',
    'dial_code': '+965',
    'currency': 'KWD',
    'currency_symbol': 'د.ك',
    'flag': '🇰🇼',
  };

  // Active Countries list (Strictly Kuwait)
  static const List<Map<String, dynamic>> gccCountries = [
    kuwaitCountry,
  ];
}
