import 'dart:io';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import '../theme/app_theme.dart';

class AppVideoPlayer extends StatefulWidget {
  final String? videoUrl;
  final File? videoFile;
  final bool autoPlay;
  final double? height;

  const AppVideoPlayer({
    super.key,
    this.videoUrl,
    this.videoFile,
    this.autoPlay = false,
    this.height = 240,
  }) : assert(videoUrl != null || videoFile != null, 'Either videoUrl or videoFile must be provided');

  @override
  State<AppVideoPlayer> createState() => _AppVideoPlayerState();
}

class _AppVideoPlayerState extends State<AppVideoPlayer> {
  late VideoPlayerController _controller;
  bool _initialized = false;
  bool _hasError = false;
  bool _showControls = true;
  bool _isMuted = false;

  @override
  void initState() {
    super.initState();
    _initVideo();
  }

  Future<void> _initVideo() async {
    try {
      if (widget.videoFile != null) {
        _controller = VideoPlayerController.file(widget.videoFile!);
      } else {
        _controller = VideoPlayerController.networkUrl(Uri.parse(widget.videoUrl!));
      }

      await _controller.initialize();
      if (widget.autoPlay) {
        await _controller.play();
      }
      _controller.addListener(() {
        if (mounted) setState(() {});
      });

      if (mounted) {
        setState(() => _initialized = true);
      }
    } catch (e) {
      debugPrint('Error initializing video player: $e');
      if (mounted) {
        setState(() => _hasError = true);
      }
    }
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return '$minutes:$seconds';
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_hasError) {
      return Container(
        height: widget.height,
        width: double.infinity,
        decoration: BoxDecoration(
          color: const Color(0xFF1E2923),
          borderRadius: BorderRadius.circular(14),
        ),
        child: const Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, color: Colors.white70, size: 40),
            SizedBox(height: 8),
            Text(
              'Could not load video preview',
              style: TextStyle(color: Colors.white70, fontSize: 13),
            ),
          ],
        ),
      );
    }

    if (!_initialized) {
      return Container(
        height: widget.height,
        width: double.infinity,
        decoration: BoxDecoration(
          color: const Color(0xFF1E2923),
          borderRadius: BorderRadius.circular(14),
        ),
        child: const Center(
          child: CircularProgressIndicator(color: AppTheme.primaryGreen),
        ),
      );
    }

    final isPlaying = _controller.value.isPlaying;
    final position = _controller.value.position;
    final duration = _controller.value.duration;

    return ClipRRect(
      borderRadius: BorderRadius.circular(14),
      child: GestureDetector(
        onTap: () => setState(() => _showControls = !_showControls),
        child: Container(
          height: widget.height,
          width: double.infinity,
          color: Colors.black,
          child: Stack(
            alignment: Alignment.center,
            children: [
              // Video Content
              Center(
                child: AspectRatio(
                  aspectRatio: _controller.value.aspectRatio,
                  child: VideoPlayer(_controller),
                ),
              ),

              // Control Overlay
              if (_showControls || !isPlaying)
                Container(
                  color: Colors.black38,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Top Row (Mute button)
                      Align(
                        alignment: Alignment.topRight,
                        child: Padding(
                          padding: const EdgeInsets.all(8),
                          child: CircleAvatar(
                            radius: 18,
                            backgroundColor: Colors.black54,
                            child: IconButton(
                              padding: EdgeInsets.zero,
                              icon: Icon(
                                _isMuted ? Icons.volume_off : Icons.volume_up,
                                color: Colors.white,
                                size: 18,
                              ),
                              onPressed: () {
                                setState(() {
                                  _isMuted = !_isMuted;
                                  _controller.setVolume(_isMuted ? 0 : 1);
                                });
                              },
                            ),
                          ),
                        ),
                      ),

                      // Center Play/Pause Button
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            if (isPlaying) {
                              _controller.pause();
                            } else {
                              if (position >= duration) {
                                _controller.seekTo(Duration.zero);
                              }
                              _controller.play();
                            }
                          });
                        },
                        child: CircleAvatar(
                          radius: 28,
                          backgroundColor: Colors.black54,
                          child: Icon(
                            position >= duration
                                ? Icons.replay
                                : isPlaying
                                    ? Icons.pause
                                    : Icons.play_arrow,
                            color: Colors.white,
                            size: 34,
                          ),
                        ),
                      ),

                      // Bottom Row: Slider and Duration
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        child: Row(
                          children: [
                            Text(
                              _formatDuration(position),
                              style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.w600),
                            ),
                            Expanded(
                              child: SliderTheme(
                                data: SliderTheme.of(context).copyWith(
                                  trackHeight: 3,
                                  thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 6),
                                  activeTrackColor: AppTheme.primaryGreen,
                                  inactiveTrackColor: Colors.white30,
                                  thumbColor: AppTheme.primaryGreen,
                                ),
                                child: Slider(
                                  value: position.inMilliseconds.clamp(0, duration.inMilliseconds).toDouble(),
                                  min: 0,
                                  max: duration.inMilliseconds.toDouble(),
                                  onChanged: (val) {
                                    _controller.seekTo(Duration(milliseconds: val.toInt()));
                                  },
                                ),
                              ),
                            ),
                            Text(
                              _formatDuration(duration),
                              style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.w600),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
