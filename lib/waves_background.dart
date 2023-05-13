import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_example/main.dart';

class WaveBackground extends ConsumerStatefulWidget {
  const WaveBackground({Key? key, required this.speed}) : super(key: key);

  final int speed;

  @override
  ConsumerState<WaveBackground> createState() => _WaveBackgroundState();
}

class _WaveBackgroundState extends ConsumerState<WaveBackground> with TickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration:  const Duration(milliseconds: 2200),
      vsync: this,
    );
    _controller.repeat();
    
  }


  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
    
  }

  Widget _buildAnimation(BuildContext context, Widget? widget) {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      child: CustomPaint(
        painter: WavePainter(
            controller: _controller,
            waves: 2,
            waveAmplitude: 25
        ),
      ),
    );
  }


  @override
  Widget build(BuildContext context) {

    ref.listen(counterProvider,(int? previous,int next){
    
    _controller = AnimationController(
      duration:  Duration(milliseconds: 2200 - next*200),
      vsync: this,
    );
    _controller.repeat();
    });
    
    return AnimatedBuilder(
      animation: _controller,
      builder: _buildAnimation,
    );
  }
}

class WavePainter extends CustomPainter {
  late final Animation<double> position;
  final Animation<double> controller;

  /// Number of waves to paint.
  final int waves;

  /// How high the wave should be.
  final double waveAmplitude;
  int get waveSegments => 2 * waves - 1;

  WavePainter({required this.controller, required this.waves, required this.waveAmplitude}) {
    position = Tween(begin: 0.0, end: 1.0)
        .chain(CurveTween(curve: Curves.linear))
        .animate(controller);
  }

  void drawWave(Path path, int wave, size) {
    double waveWidth = size.width / waveSegments;
    double waveMinHeight = size.height / 2;

    double x1 = wave * waveWidth + waveWidth/2;
    // Minimum and maximum height points of the waves.
    double y1 = waveMinHeight + (wave.isOdd ? waveAmplitude: -waveAmplitude);

    double x2 = x1 + waveWidth/2;
    double y2 = waveMinHeight;

    path.quadraticBezierTo(x1, y1, x2, y2);
    if (wave <= waveSegments) {
      drawWave(path, wave + 1, size);
    }
  }

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = Colors.lightBlueAccent[100]!
      ..style = PaintingStyle.fill;

    // Draw the waves
    Path path = Path()
      ..moveTo(0, size.height / 2);
    drawWave(path, 0, size);

    // Draw lines to the bottom corners of the size/screen with account for one extra wave.
    double waveWidth = (size.width / waveSegments) * 2;
    path..lineTo(size.width + waveWidth, size.height)
      ..lineTo(0, size.height)
      ..lineTo(0, size.height / 2)
      ..close();

    // Animate sideways one wave length, so it repeats cleanly.
    Path shiftedPath = path.shift(Offset(-position.value * waveWidth , 0));

    canvas.drawPath(shiftedPath, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}