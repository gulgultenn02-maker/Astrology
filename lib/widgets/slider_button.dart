import 'package:flutter/material.dart';

class SwipeSliderButton extends StatefulWidget {
  final VoidCallback onFinish;
  const SwipeSliderButton({super.key, required this.onFinish});

  @override
  State<SwipeSliderButton> createState() => _SwipeSliderButtonState();
}

class _SwipeSliderButtonState extends State<SwipeSliderButton> {
  double _dragValue = 0.0;
  final double _buttonHeight = 70.0;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        double maxWidth = constraints.maxWidth;
        double maxDrag = maxWidth - _buttonHeight;

        return Container(
          width: maxWidth,
          height: _buttonHeight,
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.15),
            borderRadius: BorderRadius.circular(40),
            border: Border.all(color: Colors.white.withValues(alpha: 0.2)),
          ),
          child: Stack(
            children: [
              const Center(
                child: Text(
                  "Başla      > > >",
                  style: TextStyle(color: Colors.white70, fontSize: 16, fontWeight: FontWeight.w300),
                ),
              ),
              Positioned(
                left: _dragValue,
                child: GestureDetector(
                  onHorizontalDragUpdate: (details) {
                    setState(() {
                      _dragValue += details.delta.dx;
                      if (_dragValue < 0) _dragValue = 0;
                      if (_dragValue > maxDrag) _dragValue = maxDrag;
                    });
                  },
                  onHorizontalDragEnd: (details) {
                    if (_dragValue >= maxDrag * 0.8) {
                      setState(() => _dragValue = maxDrag);
                      widget.onFinish(); // Sona gelince çalışır
                    } else {
                      setState(() => _dragValue = 0); // Bırakınca başa döner
                    }
                  },
                  child: Container(
                    width: _buttonHeight,
                    height: _buttonHeight,
                    margin: const EdgeInsets.all(2),
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 10)],
                    ),
                    child: const Icon(Icons.arrow_forward, color: Colors.black),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}