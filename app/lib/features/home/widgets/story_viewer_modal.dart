import 'dart:async';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/localization/app_localizations.dart';

class StoryViewerModal extends StatefulWidget {
  final List<Map<String, dynamic>> stories;
  final int initialIndex;

  const StoryViewerModal({
    super.key,
    required this.stories,
    this.initialIndex = 0,
  });

  static Future<void> show(
    BuildContext context, {
    required List<Map<String, dynamic>> stories,
    int initialIndex = 0,
  }) {
    return Navigator.of(context).push(
      PageRouteBuilder(
        opaque: false,
        barrierDismissible: true,
        barrierColor: Colors.black.withOpacity(0.9),
        pageBuilder: (context, _, __) => StoryViewerModal(
          stories: stories,
          initialIndex: initialIndex,
        ),
        transitionsBuilder: (context, animation, _, child) {
          return FadeTransition(opacity: animation, child: child);
        },
      ),
    );
  }

  @override
  State<StoryViewerModal> createState() => _StoryViewerModalState();
}

class _StoryViewerModalState extends State<StoryViewerModal>
    with SingleTickerProviderStateMixin {
  late int _currentIndex;
  late AnimationController _animController;
  bool _isPaused = false;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex.clamp(0, widget.stories.length - 1);

    _animController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 5),
    );

    _animController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _nextStory();
      }
    });

    _animController.forward();
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  void _nextStory() {
    if (_currentIndex < widget.stories.length - 1) {
      setState(() {
        _currentIndex++;
        _animController.reset();
        _animController.forward();
      });
    } else {
      if (mounted) Navigator.of(context).pop();
    }
  }

  void _previousStory() {
    if (_currentIndex > 0) {
      setState(() {
        _currentIndex--;
        _animController.reset();
        _animController.forward();
      });
    } else {
      _animController.reset();
      _animController.forward();
    }
  }

  void _pause() {
    if (!_isPaused) {
      _isPaused = true;
      _animController.stop();
    }
  }

  void _resume() {
    if (_isPaused) {
      _isPaused = false;
      _animController.forward();
    }
  }

  @override
  Widget build(BuildContext context) {
    final story = widget.stories[_currentIndex];
    final isAr = context.isArabic;
    final sellerName = isAr
        ? (story['name'] as String? ?? 'المعلن')
        : (story['subtitle'] as String? ?? story['name'] as String? ?? 'Seller');
    final title = isAr
        ? (story['title'] as String? ?? story['name'] as String? ?? '')
        : (story['title_en'] as String? ?? story['subtitle'] as String? ?? '');
    final time = isAr
        ? (story['time'] as String? ?? 'منذ قليل')
        : (story['time_en'] as String? ?? 'Just now');
    final price = story['price'] as String? ?? '';
    final mediaImage = story['image'] as String? ?? story['avatar'] as String;
    final adId = story['ad_id'] as int? ?? 1;

    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: GestureDetector(
          onTapDown: (_) => _pause(),
          onTapUp: (details) {
            _resume();
            final width = MediaQuery.of(context).size.width;
            final dx = details.globalPosition.dx;
            if (isAr) {
              if (dx < width * 0.35) {
                _nextStory();
              } else if (dx > width * 0.65) {
                _previousStory();
              }
            } else {
              if (dx > width * 0.65) {
                _nextStory();
              } else if (dx < width * 0.35) {
                _previousStory();
              }
            }
          },
          onLongPressStart: (_) => _pause(),
          onLongPressEnd: (_) => _resume(),
          onVerticalDragEnd: (details) {
            if (details.primaryVelocity != null && details.primaryVelocity! > 300) {
              Navigator.of(context).pop();
            }
          },
          child: Stack(
            fit: StackFit.expand,
            children: [
              // Main Story Media
              Positioned.fill(
                child: Image.network(
                  mediaImage,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => Container(
                    color: const Color(0xFF1E293B),
                    child: const Center(
                      child: Icon(Icons.image_not_supported, color: Colors.white54, size: 48),
                    ),
                  ),
                  loadingBuilder: (context, child, progress) {
                    if (progress == null) return child;
                    return Container(
                      color: const Color(0xFF0F172A),
                      child: const Center(
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white70,
                        ),
                      ),
                    );
                  },
                ),
              ),

              // Top Gradient for header visibility
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                height: 140,
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.black.withOpacity(0.85),
                        Colors.transparent,
                      ],
                    ),
                  ),
                ),
              ),

              // Bottom Gradient for details visibility
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                height: 220,
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.bottomCenter,
                      end: Alignment.topCenter,
                      colors: [
                        Colors.black.withOpacity(0.95),
                        Colors.transparent,
                      ],
                    ),
                  ),
                ),
              ),

              // Segmented Progress Bar
              Positioned(
                top: 10,
                left: 12,
                right: 12,
                child: Row(
                  children: List.generate(widget.stories.length, (index) {
                    return Expanded(
                      child: Container(
                        height: 3,
                        margin: const EdgeInsets.symmetric(horizontal: 2),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.3),
                          borderRadius: BorderRadius.circular(2),
                        ),
                        child: AnimatedBuilder(
                          animation: _animController,
                          builder: (context, _) {
                            double progress = 0.0;
                            if (index < _currentIndex) {
                              progress = 1.0;
                            } else if (index == _currentIndex) {
                              progress = _animController.value;
                            }
                            return FractionallySizedBox(
                              alignment: isAr ? Alignment.centerRight : Alignment.centerLeft,
                              widthFactor: progress,
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(2),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    );
                  }),
                ),
              ),

              // Header: Seller Avatar, Name, Timestamp & Close Button
              Positioned(
                top: 22,
                left: 14,
                right: 14,
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 20,
                      backgroundColor: Colors.white,
                      child: CircleAvatar(
                        radius: 18,
                        backgroundImage: NetworkImage(story['avatar'] as String),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Row(
                            children: [
                              Text(
                                sellerName,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  shadows: [
                                    Shadow(color: Colors.black87, blurRadius: 4),
                                  ],
                                ),
                              ),
                              const SizedBox(width: 5),
                              const Icon(
                                Icons.verified,
                                color: Color(0xFF38BDF8),
                                size: 15,
                              ),
                            ],
                          ),
                          Text(
                            time,
                            style: TextStyle(
                              color: Colors.white.withOpacity(0.8),
                              fontSize: 11,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close, color: Colors.white, size: 24),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                  ],
                ),
              ),

              // Bottom Listing Card Overlay
              Positioned(
                bottom: 20,
                left: 14,
                right: 14,
                child: Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: Colors.white.withOpacity(0.25)),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.3),
                        blurRadius: 12,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (price.isNotEmpty)
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: const Color(0xFF10B981),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Text(
                            price,
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 13,
                            ),
                          ),
                        ),
                      if (price.isNotEmpty) const SizedBox(height: 6),
                      Text(
                        title,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          shadows: [
                            Shadow(color: Colors.black87, blurRadius: 6),
                          ],
                        ),
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Expanded(
                            child: ElevatedButton.icon(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF2563EB),
                                foregroundColor: Colors.white,
                                elevation: 0,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                padding: const EdgeInsets.symmetric(vertical: 11),
                              ),
                              onPressed: () {
                                Navigator.of(context).pop();
                                context.push('/ads/$adId');
                              },
                              icon: const Icon(Icons.open_in_new, size: 16),
                              label: Text(
                                isAr ? 'عرض الإعلان' : 'View Ad',
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 13,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          InkWell(
                            borderRadius: BorderRadius.circular(12),
                            onTap: () {
                              final phone = story['phone'] as String? ?? '+965 99001122';
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    isAr ? 'الاتصال: $phone' : 'Calling: $phone',
                                  ),
                                ),
                              );
                            },
                            child: Container(
                              padding: const EdgeInsets.all(11),
                              decoration: BoxDecoration(
                                color: const Color(0xFF10B981),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: const Icon(Icons.phone, color: Colors.white, size: 20),
                            ),
                          ),
                          const SizedBox(width: 6),
                          InkWell(
                            borderRadius: BorderRadius.circular(12),
                            onTap: () {
                              Navigator.of(context).pop();
                              context.push(
                                '/chat/$adId',
                                extra: {'userName': sellerName, 'adId': adId},
                              );
                            },
                            child: Container(
                              padding: const EdgeInsets.all(11),
                              decoration: BoxDecoration(
                                color: const Color(0xFF059669),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: const Icon(Icons.chat_bubble_outline, color: Colors.white, size: 20),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
