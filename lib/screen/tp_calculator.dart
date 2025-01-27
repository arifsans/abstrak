import 'package:abstrak/main.dart';
import 'package:abstrak/notifier/tp_calculator_notifier.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:typewritertext/typewritertext.dart';

class TpCalculator extends StatefulWidget {
  const TpCalculator({super.key});

  @override
  State<TpCalculator> createState() => _TpCalculatorState();
}

class _TpCalculatorState extends State<TpCalculator> {
  final TPCalculatorNotifier _tpData = TPCalculatorNotifier();
  TextEditingController? _usernameC;

  @override
  void initState() {
    _usernameC = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    if (_usernameC != null) {
      _usernameC?.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: ResponsiveBreakpoints.of(context).smallerThan(DESKTOP)
          ? const EdgeInsets.all(0)
          : EdgeInsets.symmetric(
              horizontal: MediaQuery.sizeOf(context).width * .3,
            ),
      child: Center(
        child: Column(
          children: [
            Text(
              'Input Your AQW Username',
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _usernameC,
              autovalidateMode: AutovalidateMode.always,
              validator: (val) {
                if (val!.isEmpty) {
                  return 'Please Insert Your AQW Username';
                }

                return null;
              },
              onFieldSubmitted: (value) {
                if (value.isNotEmpty) {
                  _tpData.calculateTp(username: value);
                }
              },
            ),
            const SizedBox(height: 24),
            ValueListenableBuilder(
              valueListenable: _tpData.isLoading,
              builder: (context, value, child) {
                if (value == false) {
                  return TextButton(
                    onPressed: () {
                      if (_usernameC?.text.isNotEmpty ?? false) {
                        _tpData.calculateTp(username: _usernameC?.text ?? '');
                      }
                    },
                    child: Text(
                      'Calculate Treasure Points',
                    ),
                  );
                } else {
                  return SizedBox(
                    height: 50,
                    width: 50,
                    child: CircularProgressIndicator(
                      color: Colors.white,
                    ),
                  );
                }
              },
            ),
            const SizedBox(height: 24),
            ValueListenableBuilder(
              valueListenable: _tpData.data,
              builder: (context, value, child) {
                final dFormatter = DateFormat('dd MMMM yyyy');
                var data = value?.data ?? [];
                if (value == null) {
                  return Container();
                }
                if (value.status == false) {
                  return Container(
                    height: MediaQuery.sizeOf(context).height * .6,
                    width: MediaQuery.sizeOf(context).width * .8,
                    padding: EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.white),
                      borderRadius: BorderRadius.circular(8),
                      color: Colors.black,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Builder(
                          builder: (context) {
                            final message = (value.message ?? '').toLowerCase();

                            if (message.contains('ccid')) {
                              return TypeWriter.text(
                                'Yang sabar ya, Akun yang lu cari ga ketemu, kayanya sih ke banned bang.',
                                style: courierText.bodyMedium,
                                duration: Duration(
                                  milliseconds: 30,
                                ),
                              );
                            } else if (message
                                .contains('not found in inventory')) {
                              return TypeWriter.text(
                                'Njir kok kaga ada TP nya, kayanya sih antara lu moderator atau lu belum spin.',
                                style: courierText.bodyMedium,
                                duration: Duration(
                                  milliseconds: 30,
                                ),
                              );
                            } else {
                              return TypeWriter.text(
                                value.message ?? '',
                                duration: Duration(
                                  milliseconds: 30,
                                ),
                              );
                            }
                          },
                        ),
                      ],
                    ),
                  );
                }

                return Container(
                  height: MediaQuery.sizeOf(context).height * .6,
                  width: MediaQuery.sizeOf(context).width * .8,
                  padding: EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.white),
                    borderRadius: BorderRadius.circular(8),
                    color: Colors.black,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TypeWriter.text(
                        (value.message ?? '').toString().toUpperCase(),
                        style: courierText.bodyMedium,
                        duration: Duration(
                          milliseconds: 30,
                        ),
                        overflow: TextOverflow.clip,
                        maintainSize: false,
                        softWrap: true,
                      ),
                      const SizedBox(height: 16),
                      value.additionalMessage != null
                          ? Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                TypeWriter.text(
                                  value.additionalMessage ?? '',
                                  style: courierText.bodyMedium,
                                  duration: Duration(
                                    milliseconds: 30,
                                  ),
                                  overflow: TextOverflow.clip,
                                  maintainSize: false,
                                  softWrap: true,
                                ),
                                const SizedBox(height: 16),
                              ],
                            )
                          : Container(),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: data.map(
                          (e) {
                            return Padding(
                              padding: const EdgeInsets.symmetric(vertical: 4),
                              child: TypeWriter.text(
                                '${e.dailyGain}X/Spin\nLegend = ${e.legend?.days} days (${dFormatter.format(DateTime.parse(e.legend?.date ?? ''))})\nNon-Legend = ${e.nonLegend?.days} days (${dFormatter.format(DateTime.parse(e.nonLegend?.date ?? ''))})',
                                style: courierText.bodyMedium,
                                duration: Duration(
                                  milliseconds: 30,
                                ),
                                overflow: TextOverflow.clip,
                                maintainSize: false,
                                softWrap: true,
                              ),
                            );
                          },
                        ).toList(),
                      ),
                      const SizedBox(height: 16),
                      TypeWriter.text(
                        'From Captive with ❤️, Credit by Zou',
                        style: courierText.bodyMedium,
                        duration: Duration(
                          milliseconds: 30,
                        ),
                        overflow: TextOverflow.clip,
                        maintainSize: false,
                        softWrap: true,
                      ),
                    ],
                  ),
                );
              },
            )
          ],
        ),
      ),
    );
  }
}
