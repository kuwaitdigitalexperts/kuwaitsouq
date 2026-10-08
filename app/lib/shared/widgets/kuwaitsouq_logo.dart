import 'package:flutter/material.dart';

class KuwaitSouqLogo extends StatelessWidget {
  final double fontSize;
  final bool isWhite;
  final bool showTagline;
  final bool useImageBanner;

  const KuwaitSouqLogo({
    super.key,
    this.fontSize = 26.0,
    this.isWhite = false,
    this.showTagline = true,
    this.useImageBanner = false,
  });

  @override
  Widget build(BuildContext context) {
    if (useImageBanner) {
      return Image.asset(
        isWhite ? 'assets/images/kuwaitsouq_logo_white.png' : 'assets/images/kuwaitsouq_logo.png',
        height: fontSize * 1.8,
        fit: BoxFit.contain,
        errorBuilder: (context, error, stackTrace) => _buildCustomEmblemLogo(),
      );
    }

    return _buildCustomEmblemLogo();
  }

  Widget _buildCustomEmblemLogo() {
    final iconSize = fontSize * 1.45;
    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // Official KuwaitSouq Towers & Bag Emblem
        Container(
          width: iconSize,
          height: iconSize,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(iconSize * 0.28),
            boxShadow: [
              BoxShadow(
                color: (isWhite ? Colors.black : const Color(0xFF1E40AF)).withOpacity(0.18),
                blurRadius: 6,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(iconSize * 0.28),
            child: Image.asset(
              'assets/images/kuwaitsouq_icon.png',
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Color(0xFF1E40AF), Color(0xFF059669)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    'KS',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w900,
                      fontSize: iconSize * 0.45,
                    ),
                  ),
                );
              },
            ),
          ),
        ),
        SizedBox(width: fontSize * 0.38),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                    text: 'Kuwait',
                    style: TextStyle(
                      color: isWhite ? Colors.white : const Color(0xFF0F172A),
                      fontWeight: FontWeight.w900,
                      fontSize: fontSize * 0.85,
                      letterSpacing: -0.5,
                      fontFamily: 'Roboto',
                    ),
                  ),
                  TextSpan(
                    text: 'Souq',
                    style: TextStyle(
                      color: isWhite ? const Color(0xFF60A5FA) : const Color(0xFF2563EB),
                      fontWeight: FontWeight.w900,
                      fontSize: fontSize * 0.85,
                      letterSpacing: -0.5,
                      fontFamily: 'Roboto',
                    ),
                  ),
                ],
              ),
            ),
            if (showTagline)
              Padding(
                padding: const EdgeInsets.only(top: 1.0),
                child: Text(
                  'سوق الكويت والخليج',
                  style: TextStyle(
                    color: isWhite ? const Color(0xFF34D399) : const Color(0xFF059669),
                    fontSize: fontSize * 0.44,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.2,
                  ),
                ),
              ),
          ],
        ),
      ],
    );
  }
}
