import 'package:abstrak/main.dart';
import 'package:flutter/material.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:universal_html/html.dart' as html;

class About extends StatelessWidget {
  const About({super.key});

  @override
  Widget build(BuildContext context) {
    String officerPath = 'assets/images/officer';
    final List<String> _officer = [
      'clairine',
      'exc',
      'imp',
      'lur',
      'mes',
      'zou',
      'violeta-vanesa',
      'voltron-bolt',
      'vpn',
    ];

    String shareHoderPath = 'assets/images/shareholder';
    final List<String> _shareHolder = [
      'ardhan',
      'yon',
      'eoda',
      'mercury',
      'nea',
      'oat',
      'radragon',
      'treant',
      'vennetrix',
      'doowmood',
      'ziword',
    ];

    return Padding(
      padding: ResponsiveBreakpoints.of(context).smallerThan(DESKTOP)
          ? const EdgeInsets.all(0)
          : EdgeInsets.symmetric(
              horizontal: MediaQuery.sizeOf(context).width * .2,
            ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            'Leader',
            style: customTextTheme.displayMedium,
          ),
          const SizedBox(height: 24),
          GestureDetector(
            onTap: () => html.window.open(
              'https://account.aq.com/CharPage?id=ves',
              'Charpage',
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Image.asset(
                  '$officerPath/ves.png',
                  height: MediaQuery.sizeOf(context).width * .1,
                  width: MediaQuery.sizeOf(context).width * .1,
                ),
                const SizedBox(height: 12),
                Text(
                  'VES',
                  style: customTextTheme.bodyMedium,
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
          const SizedBox(height: 32),
          Text(
            'Officer',
            style: customTextTheme.displayMedium,
          ),
          const SizedBox(height: 24),
          Wrap(
            spacing: MediaQuery.sizeOf(context).width * .05,
            runSpacing: MediaQuery.sizeOf(context).width * .05,
            alignment: WrapAlignment.center,
            children: _officer
                .map(
                  (name) => GestureDetector(
                    onTap: () => html.window.open(
                      'https://account.aq.com/CharPage?id=${name.replaceAll('-', ' ')}',
                      'Charpage',
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Image.asset(
                          '$officerPath/$name.png',
                          height: MediaQuery.sizeOf(context).width * .1,
                          width: MediaQuery.sizeOf(context).width * .1,
                        ),
                        const SizedBox(height: 12),
                        Text(
                          name.contains('violeta') &&
                                  ResponsiveBreakpoints.of(context).isMobile
                              ? name.replaceAll('-', '\n').toUpperCase()
                              : name.replaceAll('-', ' ').toUpperCase(),
                          style: customTextTheme.bodyMedium,
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                )
                .toList(),
          ),
          const SizedBox(height: 32),
          Text(
            'ShareHolder',
            style: customTextTheme.displayMedium,
          ),
          const SizedBox(height: 24),
          Wrap(
            spacing: MediaQuery.sizeOf(context).width * .05,
            runSpacing: MediaQuery.sizeOf(context).width * .05,
            alignment: WrapAlignment.center,
            children: _shareHolder
                .map(
                  (name) => GestureDetector(
                    onTap: () => html.window.open(
                      'https://account.aq.com/CharPage?id=${name.replaceAll('-', ' ')}',
                      'Charpage',
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Image.asset(
                          '$shareHoderPath/$name.png',
                          height: MediaQuery.sizeOf(context).width * .1,
                          width: MediaQuery.sizeOf(context).width * .1,
                        ),
                        const SizedBox(height: 12),
                        Text(
                          name.replaceAll('-', ' ').toUpperCase(),
                          style: customTextTheme.bodyMedium,
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                )
                .toList(),
          ),
        ],
      ),
    );
  }
}
