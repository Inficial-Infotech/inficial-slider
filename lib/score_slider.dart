import 'package:flutter/material.dart';
import 'package:inficial_slider/step_progress_indicator.dart';

class ScoreSlider extends StatefulWidget {
  final double height;
  int currentScore;
  final int maxScore;
  final int minScore;
  final Color? backgroundColor;
  final Function(int value) onScoreChanged;
  final Function(DragEndDetails value)? onScoreChangeEnd;

  ScoreSlider({
    Key? key,
    required this.maxScore,
    this.minScore = 0,
    required this.currentScore,
    required this.onScoreChanged,
    this.height = 30,
    this.onScoreChangeEnd,
    this.backgroundColor,
  })  : assert(minScore < maxScore),
        super(key: key);

  @override
  State<StatefulWidget> createState() => ScoreSliderState();
}

class ScoreSliderState extends State<ScoreSlider> {
  List<Widget> _dots(BoxConstraints size) {
    List<Widget> dots = <Widget>[];

    double width = (size.maxWidth / widget.maxScore) - 1.3;

    for (var i = widget.minScore; i <= widget.maxScore; i++) {
      dots.add(
        Stack(
          alignment: Alignment.center,
          children: [
            Row(
              children: [
                (i == widget.currentScore)
                    ? Container(
                        margin: const EdgeInsets.only(top: 0, bottom: 0),
                        width: width,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color: Colors.white,
                            boxShadow: [
                              BoxShadow(
                                  offset: Offset(4, 4),
                                  blurRadius: 10,
                                  color: Color(0xff263238).withOpacity(0.2))
                            ]),
                      )
                    : Container(
                        margin: const EdgeInsets.only(top: 0, bottom: 0),
                        width: width,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: i == widget.currentScore
                              ? Colors.white
                              : Colors.transparent,
                        ),
                      ),
                if (i != widget.maxScore)
                  Container(
                    width: 1,
                    margin: const EdgeInsets.only(top: 5, bottom: 5),
                    decoration: BoxDecoration(
                      color: const Color(0xff4F7F71).withOpacity(0.4),
                      borderRadius: BorderRadius.circular(1),
                    ),
                  ),
              ],
            ),
            AnimatedDefaultTextStyle(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeIn,
              style: i == widget.currentScore
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
    if (calculatedScore != widget.currentScore &&
        calculatedScore <= widget.maxScore &&
        calculatedScore >= 1) {
      setState(() => widget.currentScore = calculatedScore);
      widget.onScoreChanged(widget.currentScore);
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
            onPanEnd: (details) {
              if (widget.onScoreChangeEnd != null) {
                widget.onScoreChangeEnd!(details);
              }
            },
            child: Container(
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.all(Radius.circular(20)),
                border: Border.all(
                  color: Colors.grey,
                  width: 2,
                ),
                boxShadow: [
                  BoxShadow(
                      offset: const Offset(5, 5),
                      blurRadius: 20,
                      // spreadRadius: 0,
                      color: const Color(0xff263238).withOpacity(0.04)),
                  BoxShadow(
                      offset: const Offset(-5, -5),
                      blurRadius: 20,
                      // spreadRadius: 0,
                      color: const Color(0xff263238).withOpacity(0.04))
                ],
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
                      width: size.maxWidth,
                      totalSteps: 10,
                      currentStep: widget.currentScore,
                      size: 56,
                      padding: 0,
                      selectedColor: Colors.yellow,
                      unselectedColor: Colors.cyan,
                      roundedEdges: const Radius.circular(18),
                      selectedGradientColor: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          const Color(0xff06B58C).withOpacity(0.5),
                          const Color(0xffFF9800).withOpacity(0.5),
                          const Color(0xffFF5722).withOpacity(0.5)
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
