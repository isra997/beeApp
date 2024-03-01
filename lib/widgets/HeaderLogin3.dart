import 'package:flutter/material.dart';

class HeaderLoginThree extends StatelessWidget {
  const HeaderLoginThree({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 270,
      width: double.infinity,
      // color: Colors.red,
      child: CustomPaint(
        painter: _HeaderLoginThree(),
      ),
    );
  }
}

class _HeaderLoginThree extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final Rect rect =
        Rect.fromCircle(center: const Offset(150.0, 50.0), radius: 180);

    const Gradient gradient = LinearGradient(
        begin: Alignment.centerRight,
        end: Alignment.centerLeft,
        colors:  [
          Color(0xffff8965),
          Color(0xffff9767),
        ]);

    final paint = Paint()..shader = gradient.createShader(rect);

    paint.style = PaintingStyle.fill;
    // paint.strokeWidth = 5;

    final path = Path();
    path.lineTo(0, size.height * 0.6);
    path.quadraticBezierTo(
        size.width * .45, size.height, size.width, size.height * 0.73);
    path.lineTo(size.width, 0);

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

class HeaderSignUpThree extends StatelessWidget {
  const HeaderSignUpThree({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200,
      width: double.infinity,
      color: const Color(0xff172437),
      child: CustomPaint(
        painter: _HeaderSignUpThreePainter(),
      ),
    );
  }
}

class _HeaderSignUpThreePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final Rect rect =
        Rect.fromCircle(center: const Offset(150.0, 50.0), radius: 180);

    const Gradient gradient =  LinearGradient(
        begin: Alignment.centerRight,
        end: Alignment.centerLeft,
        colors:  [
          Color(0xffff7463),
          Color(0xffff8465),
        ]);

    final paint = Paint()..shader = gradient.createShader(rect);

    paint.style = PaintingStyle.fill;

    final path = Path();
    path.lineTo(0, size.height);
    path.quadraticBezierTo(
        size.width * .6, size.height * .4, size.width, size.height * 0.65);
    path.lineTo(size.width, 0);

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

class HeaderVerificationThree extends StatelessWidget {
  const HeaderVerificationThree({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 300,
      width: double.infinity,
      // color: Colors.red,
      child: CustomPaint(
        painter: _HeaderVerificationThreePainter(),
      ),
    );
  }
}

class _HeaderVerificationThreePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final Rect rect =
        Rect.fromCircle(center: const Offset(150.0, 50.0), radius: 180);

    const Gradient gradient =  LinearGradient(
        begin: Alignment.centerRight,
        end: Alignment.centerLeft,
        colors:  [
          Color(0xffff6162),
          Color(0xffff7163),
        ]);

    final paint = Paint()..shader = gradient.createShader(rect);

    paint.style = PaintingStyle.fill;

    final path = Path();
    path.lineTo(0, size.height * .6);
    path.quadraticBezierTo(
        size.width * .3, size.height, size.width, size.height * .8);
    path.lineTo(size.width, 0);

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
