import 'package:abstrak/main.dart';
import 'package:abstrak/widgets/footer.dart';
import 'package:abstrak/widgets/warp_indicator.dart';
import 'package:collection/collection.dart';
import 'package:custom_refresh_indicator/custom_refresh_indicator.dart';
import 'package:fab_circular_menu_plus/fab_circular_menu_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:universal_html/html.dart' as html;

class NavigationPage extends StatefulWidget {
  const NavigationPage({super.key, required this.navigationShell});
  final StatefulNavigationShell navigationShell;

  @override
  State<NavigationPage> createState() => _NavigationPageState();
}

class _NavigationPageState extends State<NavigationPage>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  late ScrollController _scrollController;
  late AnimationController _swordController;
  late Animation<double> _animation;
  final _refreshController = IndicatorController();

  @override
  void initState() {
    _scrollController = ScrollController();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 20), // Full rotation in 60 seconds
    )..repeat(); // This will loop the animation
    _swordController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 5),
      animationBehavior: AnimationBehavior.preserve,
    )..repeat(reverse: true);
    _animation = Tween<double>(begin: 0.0, end: 0.1).animate(
      CurvedAnimation(parent: _swordController, curve: Curves.easeInOut),
    );
    super.initState();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _controller.dispose();
    _swordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF1a1a1a),
      floatingActionButton:
          ResponsiveBreakpoints.of(context).smallerThan(DESKTOP)
              ? FabCircularMenuPlus(
                  fabColor: Colors.white,
                  ringColor: Colors.black,
                  ringDiameterLimitFactor: 1,
                  children: FooterSite()
                      .footers
                      .mapIndexed(
                        (index, element) => GestureDetector(
                          onTap: () {
                            context.goNamed(element.route);
                            _scrollController.jumpTo(0);
                          },
                          child: Text(
                            element.text,
                          ),
                        ),
                      )
                      .toList(),
                )
              : null,
      body: SafeArea(
        child: WarpIndicator(
          controller: _refreshController,
          skyColor: Color(0xFF1a1a1a),
          onRefresh: () async {
            Future.delayed(
              Duration(seconds: 1),
              () => html.window.location.reload(),
            );
          },
          child: Stack(
            children: [
              _buildBackground(),
              _buildCaptive(),
              _buildSword(context),
              ScrollbarTheme(
                data: ScrollbarThemeData(
                  thumbColor: WidgetStateProperty.resolveWith(
                    (states) => Colors.white,
                  ),
                  trackColor: WidgetStateProperty.resolveWith(
                    (states) => Colors.grey.withOpacity(.2),
                  ),
                  trackVisibility: WidgetStateProperty.resolveWith(
                    (states) => true,
                  ),
                ),
                child: Scrollbar(
                  controller: _scrollController,
                  child: CustomScrollView(
                    controller: _scrollController,
                    shrinkWrap: true,
                    physics: AlwaysScrollableScrollPhysics(
                      parent: ClampingWithOverscrollPhysics(
                        state: _refreshController,
                      ),
                    ),
                    slivers: [
                      SliverPersistentHeader(
                        pinned: true,
                        delegate: PinnedHeader(
                          widget: Container(
                            padding: const EdgeInsets.all(16),
                            height: 80,
                            child: _buildAppBar(context),
                          ),
                        ),
                      ),
                      SliverFillRemaining(
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                            vertical: 16,
                            horizontal: 32,
                          ),
                          child: widget.navigationShell,
                        ),
                        hasScrollBody: false,
                      ),
                    ],
                  ),
                ),
              ),
              Visibility(
                visible: ResponsiveBreakpoints.of(context).largerThan(TABLET),
                child: Align(
                  alignment: Alignment.centerRight,
                  child: RotatedBox(
                    quarterTurns: 3,
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.only(
                          topRight: Radius.circular(12),
                          topLeft: Radius.circular(12),
                        ),
                        color: Colors.black,
                      ),
                      padding: const EdgeInsets.all(16.0),
                      child: FooterSite(
                        onPressed: (route) {
                          context.goNamed(route);
                          _scrollController.jumpTo(0);
                        },
                      ),
                    ),
                  ),
                ),
              ),
              Builder(builder: (context) {
                var r = GoRouter.of(context).routeInformationProvider.value.uri;
                if (r.toString() == '/') {
                  return Positioned(
                    right: ResponsiveBreakpoints.of(context).largerThan(TABLET)
                        ? MediaQuery.sizeOf(context).width * .05
                        : null,
                    left: ResponsiveBreakpoints.of(context).smallerThan(DESKTOP)
                        ? MediaQuery.sizeOf(context).width * .05
                        : null,
                    bottom: MediaQuery.sizeOf(context).height * .02,
                    child: Text(
                      '© 2020 - ${DateTime.now().year} Captive, Inc',
                      style: customTextTheme.titleMedium,
                    ),
                  );
                }
                return Container();
              }),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSword(BuildContext context) {
    var route = GoRouter.of(context).routeInformationProvider.value.uri;
    return Visibility(
      visible: route.toString() == '/',
      child: AnimatedBuilder(
        animation: _animation,
        builder: (context, w) {
          return Align(
            alignment: Alignment(0, 1 - _animation.value),
            child: Padding(
              padding: EdgeInsets.only(
                bottom: ResponsiveBreakpoints.of(context).smallerThan(DESKTOP)
                    ? MediaQuery.sizeOf(context).height * .1
                    : MediaQuery.sizeOf(context).height * .05,
                left: ResponsiveBreakpoints.of(context).smallerThan(DESKTOP)
                    ? 0
                    : MediaQuery.sizeOf(context).width * .2,
              ),
              child: Image.asset(
                'assets/images/captive-sword.png',
                width: MediaQuery.sizeOf(context).width * .5,
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildAppBar(BuildContext context) {
    if (ResponsiveBreakpoints.of(context).largerThan(TABLET)) {
      return Row(
        children: [
          AnimatedBuilder(
            animation: _controller,
            builder: (context, child) {
              return Transform.rotate(
                angle: _controller.value * 2.0 * 3.1415926535897932,
                child: child,
              );
            },
            child: GestureDetector(
              onTap: () {
                context.goNamed('home');
              },
              child: SvgPicture.asset(
                'assets/images/logo.svg',
                width: 60,
                height: 60,
                color: Colors.white,
              ),
            ),
          ),
          const SizedBox(width: 80),
          Icon(
            Icons.cookie_outlined,
            color: Colors.white,
          ),
          const SizedBox(width: 12),
          Text.rich(
            TextSpan(
              children: [
                TextSpan(
                  text: 'Yes, this website uses f***ing ',
                ),
                TextSpan(
                  text: 'cookies',
                  style: TextStyle(
                    fontFamily: 'Kenzo',
                    decoration: TextDecoration.lineThrough,
                  ),
                ),
              ],
            ),
            overflow: TextOverflow.clip,
          ),
          const Spacer(),
          IconButton(
            onPressed: () => html.window.open(
              'https://discord.gg/g3wvaQHqMD',
              'Discord',
            ),
            iconSize: MediaQuery.sizeOf(context).width * .05,
            icon: Image.asset(
              'assets/images/ic_discord.png',
            ),
          ),
          const SizedBox(width: 12),
          IconButton(
            onPressed: () => html.window.open(
              'https://www.facebook.com/CaptiveG',
              'Facebook',
            ),
            iconSize: MediaQuery.sizeOf(context).width * .05,
            icon: Image.asset(
              'assets/images/ic_facebook.png',
            ),
          ),
        ],
      );
    } else {
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          AnimatedBuilder(
            animation: _controller,
            builder: (context, child) {
              return Transform.rotate(
                angle: _controller.value * 2.0 * 3.1415926535897932,
                child: child,
              );
            },
            child: GestureDetector(
              onTap: () {
                context.goNamed('home');
              },
              child: SvgPicture.asset(
                'assets/images/logo.svg',
                width: 60,
                height: 60,
                color: Colors.white,
              ),
            ),
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                onPressed: () => html.window.open(
                  'https://discord.gg/g3wvaQHqMD',
                  'Discord',
                ),
                iconSize: MediaQuery.sizeOf(context).width * .05,
                icon: Image.asset(
                  'assets/images/ic_discord.png',
                ),
              ),
              const SizedBox(width: 12),
              IconButton(
                onPressed: () => html.window.open(
                  'https://www.facebook.com/CaptiveG',
                  'Facebook',
                ),
                iconSize: MediaQuery.sizeOf(context).width * .05,
                icon: Image.asset(
                  'assets/images/ic_facebook.png',
                ),
              ),
            ],
          ),
        ],
      );
    }
  }

  Widget _buildCaptive() {
    return Center(
      child: Text(
        'CAPTIVE',
        style: TextStyle(
          fontFamily: 'Kenzo',
          fontSize: MediaQuery.of(context).size.width * 0.27,
          color: Color(0xFF2c2f32),
          letterSpacing: MediaQuery.of(context).size.width * 0.02,
        ),
      ),
    );
  }

  Widget _buildBackground() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: <Widget>[
        _buildVerticalDivider(),
        _buildVerticalDivider(),
        _buildVerticalDivider(),
        _buildVerticalDivider(),
        _buildVerticalDivider(),
      ],
    );
  }

  Widget _buildVerticalDivider() {
    return Container(
      width: 2,
      height: double.maxFinite,
      color: Colors.black26,
      child: VerticalDivider(
        color: Colors.black26,
      ),
    );
  }
}

class PinnedHeader extends SliverPersistentHeaderDelegate {
  final Widget? widget;
  PinnedHeader({this.widget});
  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    return Container(child: widget);
  }

  @override
  double get maxExtent => 80;

  @override
  double get minExtent => 80;

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) =>
      true;
}
