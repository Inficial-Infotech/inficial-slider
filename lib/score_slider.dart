import 'package:flutter/material.dart';
import 'package:inficial_slider/step_progress_indicator.dart';

class ScoreSlider extends StatefulWidget {
  final double height;
  final int score;
  final int maxScore;
  final int minScore;

  final Color? backgroundColor;
  final Function(int value) onScoreChanged;

  ScoreSlider({
    required this.maxScore,
    this.minScore = 0,
    required this.score,
    required this.onScoreChanged,
    this.height = 30,
    this.backgroundColor,
  })  : assert(maxScore != null),
        assert(minScore < maxScore);

  @override
  State<StatefulWidget> createState() => ScoreSliderState();
}

class ScoreSliderState extends State<ScoreSlider> {
  int _currentScore = 1;

  @override
  void initState() {
    super.initState();
    _currentScore = widget.score;
  }

  List<Widget> _dots(BoxConstraints size) {
    List<Widget> dots = <Widget>[];

    // double width = size.maxWidth / (widget.maxScore - widget.minScore + 1.45);
    double width = (size.maxWidth / widget.maxScore) - 1.3;
    double selectedScoreRadius = (widget.height * 0.7) / 2;
    double dotRadius = (widget.height * 0.25) / 1;

    for (var i = widget.minScore; i <= widget.maxScore; i++) {
      double currentRadius =
          i == _currentScore ? selectedScoreRadius : dotRadius;
      dots.add(
        Stack(
          alignment: Alignment.center,
          children: [
            Row(
              children: [
                Container(
                  margin: const EdgeInsets.only(top: 0, bottom: 0),
                  height: 100,
                  width: width,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color:
                        i == _currentScore ? Colors.white : Colors.transparent,
                  ),
                ),
                if (i != widget.maxScore)
                  Container(
                    width: 1,
                    margin: const EdgeInsets.only(top: 5, bottom: 5),
                    color: const Color(0xff4F7F71),
                  ),
              ],
            ),
            AnimatedDefaultTextStyle(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeIn,
              style: i == _currentScore
                  ? const TextStyle(
                      color: Colors.black,
                      fontSize: 20,
                      fontWeight: FontWeight.bold)
                  : const TextStyle(color: Colors.black45),
              child: Text(
                i.toString(),
                // style: TextStyle(
                //     color: i == _currentScore ? Colors.black : Colors.black45),
              ),
            ),
          ],
        ),
      );
    }

    return dots;
  }

  void _handlePanGesture(BoxConstraints size, Offset localPosition) {
    double socreWidth = size.maxWidth / (widget.maxScore - widget.minScore + 1);
    double x = localPosition.dx;
    int calculatedScore = (x ~/ socreWidth) + widget.minScore;
    if (calculatedScore != _currentScore &&
        calculatedScore <= widget.maxScore &&
        calculatedScore >= 1) {
      setState(() => _currentScore = calculatedScore);
      if (widget.onScoreChanged != null) {
        widget.onScoreChanged(_currentScore);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 60,
      // width: 400,
      child: LayoutBuilder(
        builder: (context, size) {
          return GestureDetector(
            onPanDown: (details) {
              _handlePanGesture(size, details.localPosition);
            },
            onPanStart: (details) {
              _handlePanGesture(size, details.localPosition);
            },
            onPanUpdate: (details) {
              _handlePanGesture(size, details.localPosition);
            },
            child: Container(
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.all(Radius.circular(20)),
                border: Border.all(
                  color: Colors.grey,
                  width: 2,
                ),
                color: (widget.backgroundColor ??
                    Theme.of(context).backgroundColor),
              ),
              height: widget.height,
              child: Stack(
                fit: StackFit.expand,
                alignment: Alignment.topCenter,
                children: <Widget>[
                  ClipRRect(
                    borderRadius: BorderRadius.circular(15),
                    child: StepProgressIndicator(
                      // selectedSize: width,
                      // unselectedSize: width,
                      width: size.maxWidth,
                      totalSteps: 10,
                      currentStep: _currentScore,
                      size: 56,
                      padding: 0,

                      selectedColor: Colors.yellow,
                      unselectedColor: Colors.cyan,

                      roundedEdges: const Radius.circular(18),
                      selectedGradientColor: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          Color(0xff06B58C).withOpacity(0.5),
                          Color(0xffFF9800).withOpacity(0.5),
                          Color(0xffFF5722).withOpacity(0.5)
                        ],
                      ),
                      unselectedGradientColor: const LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          Colors.transparent,
                          Colors.transparent,
                        ],
                      ),
                    ),
                  ),
                  Row(
                    children: _dots(size),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
