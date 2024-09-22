import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:responsive_framework/responsive_framework.dart';

class ArtWerk extends StatelessWidget {
  const ArtWerk({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: ResponsiveBreakpoints.of(context).smallerThan(DESKTOP)
          ? const EdgeInsets.all(0)
          : EdgeInsets.symmetric(
              horizontal: MediaQuery.sizeOf(context).width * .3,
            ),
      child: StaggeredGrid.count(
        crossAxisCount: 4,
        mainAxisSpacing: 4,
        crossAxisSpacing: 4,
        children: [
          StaggeredGridTile.count(
            crossAxisCellCount: 2,
            mainAxisCellCount: 2,
            child: CachedNetworkImage(
              imageUrl: 'https://arifsani.xyz/src/art-1.png',
              fit: BoxFit.cover,
              progressIndicatorBuilder: (context, url, progress) {
                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SpinKitFoldingCube(
                      color: Colors.white,
                    ),
                    SizedBox(height: 12),
                    LinearProgressIndicator(
                      value: progress.progress,
                      backgroundColor: Colors.grey.withOpacity(.2),
                      color: Colors.white,
                    ),
                  ],
                );
              },
            ),
          ),
          StaggeredGridTile.count(
            crossAxisCellCount: 2,
            mainAxisCellCount: 1,
            child: CachedNetworkImage(
              imageUrl: 'https://arifsani.xyz/src/art-2.png',
              fit: BoxFit.cover,
              progressIndicatorBuilder: (context, url, progress) {
                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SpinKitFoldingCube(
                      color: Colors.white,
                    ),
                    SizedBox(height: 12),
                    LinearProgressIndicator(
                      value: progress.progress,
                      backgroundColor: Colors.grey.withOpacity(.2),
                      color: Colors.white,
                    ),
                  ],
                );
              },
            ),
          ),
          StaggeredGridTile.count(
            crossAxisCellCount: 1,
            mainAxisCellCount: 1,
            child: CachedNetworkImage(
              imageUrl: 'https://arifsani.xyz/src/art-3.png',
              fit: BoxFit.cover,
              progressIndicatorBuilder: (context, url, progress) {
                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SpinKitFoldingCube(
                      color: Colors.white,
                    ),
                    SizedBox(height: 12),
                    LinearProgressIndicator(
                      value: progress.progress,
                      backgroundColor: Colors.grey.withOpacity(.2),
                      color: Colors.white,
                    ),
                  ],
                );
              },
            ),
          ),
          StaggeredGridTile.count(
            crossAxisCellCount: 1,
            mainAxisCellCount: 1,
            child: CachedNetworkImage(
              imageUrl: 'https://arifsani.xyz/src/art-4.png',
              fit: BoxFit.cover,
              progressIndicatorBuilder: (context, url, progress) {
                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SpinKitFoldingCube(
                      color: Colors.white,
                    ),
                    SizedBox(height: 12),
                    LinearProgressIndicator(
                      value: progress.progress,
                      backgroundColor: Colors.grey.withOpacity(.2),
                      color: Colors.white,
                    ),
                  ],
                );
              },
            ),
          ),
          StaggeredGridTile.count(
            crossAxisCellCount: 4,
            mainAxisCellCount: 2,
            child: CachedNetworkImage(
              imageUrl: 'https://arifsani.xyz/src/art-5.JPG',
              fit: BoxFit.cover,
              progressIndicatorBuilder: (context, url, progress) {
                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SpinKitFoldingCube(
                      color: Colors.white,
                    ),
                    SizedBox(height: 12),
                    LinearProgressIndicator(
                      value: progress.progress,
                      backgroundColor: Colors.grey.withOpacity(.2),
                      color: Colors.white,
                    ),
                  ],
                );
              },
            ),
          ),
          StaggeredGridTile.count(
            crossAxisCellCount: 2,
            mainAxisCellCount: 2,
            child: CachedNetworkImage(
              imageUrl: 'https://arifsani.xyz/src/art-6.JPG',
              fit: BoxFit.cover,
              progressIndicatorBuilder: (context, url, progress) {
                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SpinKitFoldingCube(
                      color: Colors.white,
                    ),
                    SizedBox(height: 12),
                    LinearProgressIndicator(
                      value: progress.progress,
                      backgroundColor: Colors.grey.withOpacity(.2),
                      color: Colors.white,
                    ),
                  ],
                );
              },
            ),
          ),
          StaggeredGridTile.count(
            crossAxisCellCount: 2,
            mainAxisCellCount: 2,
            child: CachedNetworkImage(
              imageUrl: 'https://arifsani.xyz/src/art-7.JPG',
              fit: BoxFit.cover,
              progressIndicatorBuilder: (context, url, progress) {
                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SpinKitFoldingCube(
                      color: Colors.white,
                    ),
                    SizedBox(height: 12),
                    LinearProgressIndicator(
                      value: progress.progress,
                      backgroundColor: Colors.grey.withOpacity(.2),
                      color: Colors.white,
                    ),
                  ],
                );
              },
            ),
          ),
          StaggeredGridTile.count(
            crossAxisCellCount: 4,
            mainAxisCellCount: 2,
            child: CachedNetworkImage(
              imageUrl: 'https://arifsani.xyz/src/art-8.png',
              fit: BoxFit.cover,
              progressIndicatorBuilder: (context, url, progress) {
                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SpinKitFoldingCube(
                      color: Colors.white,
                    ),
                    SizedBox(height: 12),
                    LinearProgressIndicator(
                      value: progress.progress,
                      backgroundColor: Colors.grey.withOpacity(.2),
                      color: Colors.white,
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
