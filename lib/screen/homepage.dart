import 'package:abstrak/main.dart';
import 'package:abstrak/widgets/circle_widget.dart';
import 'package:flutter/material.dart';
import 'package:responsive_framework/responsive_framework.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return ResponsiveBreakpoints.of(context).largerThan(TABLET)
        ? SizedBox(
            width: MediaQuery.sizeOf(context).width,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                RotatedBox(quarterTurns: 3, child: _buildMadeWith()),
                SizedBox(width: MediaQuery.sizeOf(context).width * .03),
                CircleWidget(
                  width: 60,
                  height: 60,
                  outerRadius: 25.0,
                  innerRadius: 8.0,
                  circleColor: Color(0xFF0098a6),
                ),
                const SizedBox(width: 8),
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: RotatedBox(
                    quarterTurns: 3,
                    child: const Text(
                      "//IT'S ONLY AFTER WE'VE LOST EVERYTHING\nTHAT WE'RE FREE TO DO ANYTHING//",
                      style: TextStyle(
                        fontFamily: 'Kenzo',
                        fontSize: 36,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
                SizedBox(width: MediaQuery.sizeOf(context).width * .05),
                Padding(
                  padding: EdgeInsets.only(
                    bottom: MediaQuery.sizeOf(context).height * .6,
                  ),
                  child: CircleWidget(
                    width: 40,
                    height: 40,
                    outerRadius: 15.0,
                    innerRadius: 4.0,
                    circleColor: Color(0xFF00bcd5),
                  ),
                ),
                SizedBox(width: MediaQuery.sizeOf(context).width * .05),
                Padding(
                  padding: EdgeInsets.only(
                    bottom: MediaQuery.sizeOf(context).height * .2,
                  ),
                  child: CircleWidget(
                    width: 50,
                    height: 50,
                    outerRadius: 20.0,
                    innerRadius: 4.0,
                    circleColor: Color(0xFFb2ebf2),
                  ),
                ),
                SizedBox(width: MediaQuery.sizeOf(context).width * .08),
                Padding(
                  padding: EdgeInsets.only(
                    bottom: MediaQuery.sizeOf(context).height * .1,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      CircleWidget(
                        width: 40,
                        height: 40,
                        outerRadius: 15.0,
                        innerRadius: 4.0,
                        circleColor: Color(0xFF00bcd5),
                      ),
                      const SizedBox(height: 20),
                      _buildHello(
                        context,
                        fontSize: MediaQuery.sizeOf(context).width * .1,
                      ),
                      const SizedBox(height: 20),
                      Badge(
                        offset: Offset(0, -20),
                        backgroundColor: Colors.transparent,
                        label: Transform.rotate(
                          angle: (22 / 7) / 12,
                          child: Image.asset(
                            'assets/images/crown.gif',
                            width: 42,
                            height: 42,
                          ),
                        ),
                        child: Text(
                          'Find us @YORUMI\nHACHIKO-6666',
                          style: customTextTheme.bodyLarge,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          )
        : SizedBox(
            width: MediaQuery.sizeOf(context).width,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: const Text(
                    "//IT'S ONLY AFTER WE'VE LOST EVERYTHING\nTHAT WE'RE FREE TO DO ANYTHING//",
                    style: TextStyle(
                      fontFamily: 'Kenzo',
                      fontSize: 36,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                SizedBox(height: MediaQuery.sizeOf(context).height * .08),
                _buildHello(
                  context,
                  fontSize: MediaQuery.sizeOf(context).width * .1,
                ),
                SizedBox(height: MediaQuery.sizeOf(context).height * .1),
                Badge(
                  offset: Offset(0, -20),
                  backgroundColor: Colors.transparent,
                  label: Transform.rotate(
                    angle: (22 / 7) / 12,
                    child: Image.asset(
                      'assets/images/crown.gif',
                      width: 42,
                      height: 42,
                    ),
                  ),
                  child: Text(
                    'Find us @YORUMI\nHACHIKO-6666',
                    style: customTextTheme.bodyLarge,
                  ),
                ),
                const Spacer(),
                Padding(
                  padding: EdgeInsets.only(
                    bottom: MediaQuery.sizeOf(context).height * .05,
                  ),
                  child: _buildMadeWith(),
                ),
              ],
            ),
          );
  }

  Widget _buildMadeWith() {
    return const Text.rich(
      TextSpan(
        children: [
          TextSpan(
            text: 'Made with',
            style: TextStyle(
              fontFamily: 'Kenzo',
              decoration: TextDecoration.lineThrough,
            ),
          ),
          TextSpan(text: ' ❤︎ '),
          TextSpan(
            text: 'by Zou',
            style: TextStyle(
              fontFamily: 'Kenzo',
              decoration: TextDecoration.lineThrough,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHello(BuildContext context, {required double fontSize}) {
    return RichText(
      text: TextSpan(
        text: 'WELCOME',
        style: TextStyle(
          fontFamily: 'Kenzo',
          fontSize: fontSize,
          color: Colors.white,
        ),
        children: <TextSpan>[
          TextSpan(
            text: '.\n',
            style: TextStyle(
              fontFamily: 'Kenzo',
              fontSize: fontSize,
              color: Color(0xFFff5353),
            ),
          ),
          TextSpan(
            text: 'TO\nCAPTIVE',
            style: TextStyle(
              fontFamily: 'Kenzo',
              fontSize: fontSize,
              color: Colors.white,
            ),
          )
        ],
      ),
      overflow: TextOverflow.clip,
    );
  }
}
