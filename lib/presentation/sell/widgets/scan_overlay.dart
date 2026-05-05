import 'package:flutter/material.dart';
import 'dart:ui' as ui;
import '../../../core/constants/app_colors.dart';

class ScanOverlay extends StatefulWidget {
  final bool isScanning;

  const ScanOverlay({
    Key? key,
    required this.isScanning,
  }) : super(key: key);

  @override
  State<ScanOverlay> createState() => _ScanOverlayState();
}

class _ScanOverlayState extends State<ScanOverlay>
    with TickerProviderStateMixin {
  late AnimationController _bracketController;
  late AnimationController _scanLineController;

  @override
  void initState() {
    super.initState();

    // Corner brackets scale pulse: 0.95 → 1.05 every 600ms
    _bracketController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    )..repeat(reverse: true);

    // Scan line sweep: top → bottom every 900ms
    _scanLineController = AnimationController(
      duration: const Duration(milliseconds: 900),
      vsync: this,
    )..repeat();
  }

  @override
  void dispose() {
    _bracketController.dispose();
    _scanLineController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const viewportSize = Size(260, 320);
    const viewportOffset = Offset(50, 140);

    return Stack(
      children: [
        // Dark overlay
        Container(
          color: Colors.black.withOpacity(0.6),
        ),
        // Viewport cutout with rounded corners
        CustomPaint(
          painter: _ViewportCutoutPainter(),
          size: Size.infinite,
        ),
        // Corner brackets
        AnimatedBuilder(
          animation: _bracketController,
          builder: (context, child) {
            final scale = 0.95 + (_bracketController.value * 0.1);
            return Positioned(
              left: viewportOffset.dx,
              top: viewportOffset.dy,
              width: viewportSize.width,
              height: viewportSize.height,
              child: Transform.scale(
                scale: scale,
                alignment: Alignment.center,
                child: CustomPaint(
                  painter: _CornerBracketsPainter(
                    color: AppColors.accent,
                  ),
                  size: viewportSize,
                ),
              ),
            );
          },
        ),
        // Scan line (only when isScanning)
        if (widget.isScanning)
          AnimatedBuilder(
            animation: _scanLineController,
            builder: (context, child) {
              final progress = _scanLineController.value;
              return Positioned(
                left: viewportOffset.dx,
                top: viewportOffset.dy + (viewportSize.height * progress),
                width: viewportSize.width,
                height: 2,
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        AppColors.accent.withOpacity(0),
                        AppColors.accent.withOpacity(0.8),
                        AppColors.accent.withOpacity(0),
                      ],
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.accent.withOpacity(0.6),
                        blurRadius: 8,
                        spreadRadius: 2,
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
      ],
    );
  }
}

class _ViewportCutoutPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    const viewportSize = Size(260, 320);
    const viewportOffset = Offset(50, 140);

    final outerPath = ui.Path()
      ..addRect(Rect.fromLTWH(0, 0, size.width, size.height));

    final innerPath = ui.Path()
      ..addRRect(
        RRect.fromRectAndRadius(
          Rect.fromLTWH(
            viewportOffset.dx,
            viewportOffset.dy,
            viewportSize.width,
            viewportSize.height,
          ),
          const Radius.circular(12),
        ),
      );

    final path = Path.combine(
      PathOperation.difference,
      outerPath,
      innerPath,
    );

    canvas.drawPath(
      path,
      Paint()
        ..color = Colors.black.withOpacity(0.6)
        ..style = PaintingStyle.fill,
    );
  }

  @override
  bool shouldRepaint(_ViewportCutoutPainter oldDelegate) => false;
}

class _CornerBracketsPainter extends CustomPainter {
  final Color color;
  final double strokeWidth = 3;

  _CornerBracketsPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    const bracketLength = 30.0;

    // Top-left
    canvas.drawPath(
      _createBracketPath(
        Offset(0, 0),
        bracketLength,
        bracketLength,
        false,
        false,
      ),
      paint,
    );

    // Top-right
    canvas.drawPath(
      _createBracketPath(
        Offset(size.width, 0),
        bracketLength,
        bracketLength,
        true,
        false,
      ),
      paint,
    );

    // Bottom-left
    canvas.drawPath(
      _createBracketPath(
        Offset(0, size.height),
        bracketLength,
        bracketLength,
        false,
        true,
      ),
      paint,
    );

    // Bottom-right
    canvas.drawPath(
      _createBracketPath(
        Offset(size.width, size.height),
        bracketLength,
        bracketLength,
        true,
        true,
      ),
      paint,
    );
  }

  Path _createBracketPath(
    Offset corner,
    double horizontalLength,
    double verticalLength,
    bool isRight,
    bool isBottom,
  ) {
    final path = Path();
    final hDir = isRight ? -1.0 : 1.0;
    final vDir = isBottom ? -1.0 : 1.0;

    path.moveTo(corner.dx + (hDir * horizontalLength), corner.dy);
    path.lineTo(corner.dx, corner.dy);
    path.lineTo(corner.dx, corner.dy + (vDir * verticalLength));

    return path;
  }

  @override
  bool shouldRepaint(_CornerBracketsPainter oldDelegate) => false;
}
