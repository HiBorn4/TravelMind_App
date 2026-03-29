import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shimmer/shimmer.dart';
import 'package:vlad_ai/app/config/padding_extensions.dart';
import '../../config/app_colors.dart';

class CustomCachedImage extends StatelessWidget {
  final double height, width, borderRadius;
  final String imageUrl;
  final BoxFit? fit;
  final bool isProfile;
  final String? name;

  const CustomCachedImage({
    super.key,
    required this.height,
    required this.width,
    required this.imageUrl,
    required this.borderRadius,
    this.fit,
    this.isProfile = true,
    this.name,
  });

  /// Check if URL is valid and not empty
  bool _isValidUrl(String url) {
    if (url.isEmpty) return false;
    try {
      final uri = Uri.parse(url);
      return uri.hasScheme && uri.host.isNotEmpty;
    } catch (_) {
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    // Show error widget if URL is invalid or empty
    if (!_isValidUrl(imageUrl)) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(borderRadius),
        child: SizedBox(
          width: width,
          height: height,
          child: isProfile ? _InitialsFallback(name: name, size: height) : _NotFoundWidget(),
        ),
      );
    }

    return ClipRRect(
      borderRadius: BorderRadius.circular(borderRadius),
      child: CachedNetworkImage(
        imageUrl: imageUrl,
        width: width,
        height: height,
        fit: fit ?? BoxFit.cover,
        placeholder: (_, __) => _ShimmerEffect(height: height, width: width, borderRadius: borderRadius),
        errorWidget: (_, __, ___) => isProfile ? _InitialsFallback(name: name, size: height) : _NotFoundWidget(),
      ),
    );
  }
}

class _NotFoundWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        height: double.infinity,
        decoration: BoxDecoration(color: AppColors.textLightBlack.withOpacity(0.2)),
        child: Icon(Icons.info_outlined, size: 30.sp, color: Color(0xffE1FFCB)).paddingHorizontal(10.w),
      ),
    );
  }
}

class _ShimmerEffect extends StatelessWidget {
  final double height, width, borderRadius;

  const _ShimmerEffect({required this.height, required this.width, required this.borderRadius});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(borderRadius),
      child: Shimmer.fromColors(
        baseColor: Colors.grey[300]!,
        highlightColor: Colors.grey[100]!,
        child: Container(color: Colors.white, width: width, height: height),
      ),
    );
  }
}

class _InitialsFallback extends StatelessWidget {
  final String? name;
  final double size;

  const _InitialsFallback({this.name, required this.size});

  String _getInitials(String? fullName) {
    if (fullName == null || fullName.trim().isEmpty) return "?";
    List<String> names = fullName.trim().split(" ");
    if (names.length == 1) return names[0][0].toUpperCase();
    return (names[0][0] + names[1][0]).toUpperCase();
  }

  // Base color from name
  Color _getBaseColor(String? name) {
    final List<Color> colors = [
      Color(0xFF7E57C2), // Deep Lavender
      Color(0xFFEC407A), // Pink
      Color(0xFF26C6DA), // Cyan
      Color(0xFFEF5350), // Red
      Color(0xFF66BB6A), // Green
      Color(0xFF42A5F5), // Blue
      Color(0xFFAB47BC), // Purple
      Color(0xFFFFA726), // Orange
      Color(0xFF26A69A), // Teal
      Color(0xFF8D6E63), // Brown
      Color(0xFF5C6BC0), // Indigo
      Color(0xFF009688), // Dark Teal
      Color(0xFF795548), // Coffee
    ];

    if (name == null || name.isEmpty) return colors[0];
    final int hash = name.codeUnits.fold(0, (prev, elem) => prev + elem);
    return colors[hash % colors.length];
  }

  // Lighten a color (for background)
  Color _lighten(Color color, [double amount = .3]) {
    final hsl = HSLColor.fromColor(color);
    final lightHsl = hsl.withLightness((hsl.lightness + amount).clamp(0.0, 1.0));
    return lightHsl.toColor();
  }

  // Darken a color (for initials)
  Color _darken(Color color, [double amount = .2]) {
    final hsl = HSLColor.fromColor(color);
    final darkHsl = hsl.withLightness((hsl.lightness - amount).clamp(0.0, 1.0));
    return darkHsl.toColor();
  }

  @override
  Widget build(BuildContext context) {
    final baseColor = _getBaseColor(name);
    final bgColor = _lighten(baseColor);
    final textColor = _darken(baseColor);

    return Container(
      width: size,
      height: size,
      color: bgColor,
      child: Center(
        child: Text(
          _getInitials(name),
          style: TextStyle(fontSize: size * 0.4, fontWeight: FontWeight.bold, color: textColor),
        ),
      ),
    );
  }
}
