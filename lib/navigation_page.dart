import 'package:abstrak/footer.dart';
import 'package:abstrak/x_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:responsive_framework/responsive_framework.dart';

class NavigationPage extends StatefulWidget {
  const NavigationPage({super.key, required this.navigationShell});
  final StatefulNavigationShell navigationShell;

  @override
  State<NavigationPage> createState() => _NavigationPageState();
}

class _NavigationPageState extends State<NavigationPage>
    with SingleTickerProviderStateMixin {
  List cart = [];
  late AnimationController _controller;
  late ScrollController _scrollController;
  var scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    _scrollController = ScrollController();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 20), // Full rotation in 60 seconds
    )..repeat(); // This will loop the animation
    super.initState();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      backgroundColor: Colors.black,
      persistentFooterButtons: [],
      endDrawer: Drawer(
        shape: const ContinuousRectangleBorder(),
        backgroundColor: Colors.black,
        width: ResponsiveBreakpoints.of(context).isDesktop
            ? MediaQuery.sizeOf(context).width * 0.4
            : null,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'CART (0 ITEMS)',
                    style: ResponsiveBreakpoints.of(context).isDesktop
                        ? Theme.of(context).textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.w400,
                            )
                        : Theme.of(context).textTheme.titleSmall?.copyWith(
                              fontWeight: FontWeight.w400,
                            ),
                  ),
                  XButton(
                    onPressed: () => scaffoldKey.currentState!.closeEndDrawer(),
                    borderColor: Colors.grey.withOpacity(.2),
                    text: 'CLOSE X',
                  ),
                ],
              ),
              Expanded(
                child: cart.isEmpty
                    ? const Center(
                        child: Text(
                          'YOUR CART IS EMPTY',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.normal,
                          ),
                        ),
                      )
                    : ListView(
                        children: cart
                            .map(
                              (e) => Container(),
                            )
                            .toList(),
                      ),
              ),
            ],
          ),
        ),
      ),
      body: SafeArea(
        child: CustomScrollView(
          controller: _scrollController,
          shrinkWrap: true,
          slivers: [
            SliverPersistentHeader(
              pinned: true,
              delegate: PinnedHeader(
                widget: Container(
                  height: 80,
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'CART 0',
                        style: ResponsiveBreakpoints.of(context).isDesktop
                            ? Theme.of(context).textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.w400,
                                  color: Colors.transparent,
                                )
                            : Theme.of(context).textTheme.titleSmall?.copyWith(
                                  fontWeight: FontWeight.w400,
                                  color: Colors.transparent,
                                ),
                      ),
                      AnimatedBuilder(
                        animation: _controller,
                        builder: (context, child) {
                          return Transform.rotate(
                            angle: _controller.value * 2.0 * 3.1415926535897932,
                            child: child,
                          );
                        },
                        child: GestureDetector(
                          onTap: () => context.goNamed('home'),
                          child: SvgPicture.asset(
                            'assets/images/logo.svg',
                            width: 60,
                            height: 60,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () => scaffoldKey.currentState!.openEndDrawer(),
                        child: Text(
                          'CART 0',
                          style: ResponsiveBreakpoints.of(context).isDesktop
                              ? Theme.of(context)
                                  .textTheme
                                  .titleMedium
                                  ?.copyWith(
                                    fontWeight: FontWeight.w400,
                                  )
                              : Theme.of(context)
                                  .textTheme
                                  .titleSmall
                                  ?.copyWith(
                                    fontWeight: FontWeight.w400,
                                  ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            SliverFillRemaining(
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 16, horizontal: 32),
                child: widget.navigationShell,
              ),
              hasScrollBody: false,
            ),
            SliverToBoxAdapter(
              child: FooterSite(),
            ),
          ],
        ),
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
