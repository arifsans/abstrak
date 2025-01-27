import 'package:abstrak/notifier/artwerk_notifier.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:responsive_framework/responsive_framework.dart';

class ArtWerk extends StatefulWidget {
  const ArtWerk({super.key});

  @override
  State<ArtWerk> createState() => _ArtWerkState();
}

class _ArtWerkState extends State<ArtWerk> {
  final ArtwerkNotifier _artWerk = ArtwerkNotifier();

  @override
  void initState() {
    _artWerk.getArtwerk();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: ResponsiveBreakpoints.of(context).smallerThan(DESKTOP)
          ? const EdgeInsets.all(0)
          : EdgeInsets.symmetric(
              horizontal: MediaQuery.sizeOf(context).width * .3,
            ),
      child: ValueListenableBuilder(
        valueListenable: _artWerk.data,
        builder: (context, value, child) {
          var data = value?.data ?? [];
          final List<String> leftColumnImages = [];
          final List<String> rightColumnImages = [];

          for (int i = 0; i < data.length; i++) {
            if (i % 2 == 0) {
              leftColumnImages.add(data[i].image ?? '');
            } else {
              rightColumnImages.add(data[i].image ?? '');
            }
          }

          if (data.isEmpty) {
            return Container();
          }

          return Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Left column
              Expanded(
                child: Column(
                  children: leftColumnImages.map(
                    (url) {
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 8.0),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: CachedNetworkImage(
                            imageUrl: url,
                            fit: BoxFit.cover,
                            progressIndicatorBuilder: (context, url, progress) {
                              return SizedBox(
                                height: MediaQuery.sizeOf(context).height * .1,
                                width: MediaQuery.sizeOf(context).width * .2,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    SpinKitFoldingCube(
                                      color: Colors.white,
                                    ),
                                    SizedBox(height: 12),
                                    LinearProgressIndicator(
                                      value: 0.5,
                                      backgroundColor: Colors.grey.withOpacity(
                                        .2,
                                      ),
                                      color: Colors.white,
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                        ),
                      );
                    },
                  ).toList(),
                ),
              ),
              const SizedBox(width: 8), // Spacing between columns

              // Right column
              Expanded(
                child: Column(
                  children: rightColumnImages.map(
                    (url) {
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 8.0),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: CachedNetworkImage(
                            imageUrl: url,
                            fit: BoxFit.cover,
                            progressIndicatorBuilder: (context, url, progress) {
                              return SizedBox(
                                height: MediaQuery.sizeOf(context).height * .1,
                                width: MediaQuery.sizeOf(context).width * .2,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    SpinKitFoldingCube(
                                      color: Colors.white,
                                    ),
                                    SizedBox(height: 12),
                                    LinearProgressIndicator(
                                      value: 0.5,
                                      backgroundColor: Colors.grey.withOpacity(
                                        .2,
                                      ),
                                      color: Colors.white,
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                        ),
                      );
                    },
                  ).toList(),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
