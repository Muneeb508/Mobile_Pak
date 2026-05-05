import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../services/map_cluster_service.dart';

class MapPricePin extends StatelessWidget {
  final MapCluster cluster;
  final bool isSelected;
  final VoidCallback onTap;

  const MapPricePin({
    Key? key,
    required this.cluster,
    required this.isSelected,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (cluster.isSingle) {
      return _buildSinglePin();
    } else {
      return _buildClusterPin();
    }
  }

  Widget _buildSinglePin() {
    return GestureDetector(
      onTap: onTap,
      child: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            curve: Curves.easeInOut,
            transform: Matrix4.identity()..scale(isSelected ? 1.1 : 1.0),
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: isSelected ? AppColors.accent : Colors.white,
              border: Border.all(
                color: isSelected ? AppColors.accent : AppColors.accent,
                width: isSelected ? 0 : 1.5,
              ),
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.15),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.location_on,
                  size: 12,
                  color: isSelected ? Colors.white : AppColors.accent,
                ),
                const SizedBox(width: 4),
                Text(
                  cluster.priceLabel,
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                    color: isSelected ? Colors.white : AppColors.accent,
                  ),
                ),
              ],
            ),
          ),
          CustomPaint(
            size: const Size(8, 4),
            painter: _TrianglePainter(
              color: isSelected ? AppColors.accent : Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildClusterPin() {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 44,
        height: 44,
        decoration: BoxDecoration(
          color: AppColors.accent,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: AppColors.accent.withOpacity(0.3),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Center(
          child: Text(
            cluster.count.toString(),
            style: const TextStyle(
              color: Colors.white,
              fontSize: 14,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ),
    );
  }
}

class _TrianglePainter extends CustomPainter {
  final Color color;

  _TrianglePainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = color;
    final path = Path();
    path.moveTo(0, 0);
    path.lineTo(size.width, 0);
    path.lineTo(size.width / 2, size.height);
    path.close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
