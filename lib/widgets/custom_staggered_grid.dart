import 'package:flutter/material.dart';

class CustomStaggeredGrid extends StatelessWidget {
  final List<Widget> children;
  final int crossAxisCount;
  final double mainAxisSpacing;
  final double crossAxisSpacing;

  const CustomStaggeredGrid({
    super.key,
    required this.children,
    required this.crossAxisCount,
    this.mainAxisSpacing = 8.0,
    this.crossAxisSpacing = 8.0,
  });

  @override
  Widget build(BuildContext context) {
    if (children.isEmpty) {
      return const SizedBox.shrink();
    }

    // Create columns to distribute items
    List<List<Widget>> columns = List.generate(crossAxisCount, (index) => []);
    List<double> columnHeights = List.generate(crossAxisCount, (index) => 0.0);

    // Distribute children across columns
    for (int i = 0; i < children.length; i++) {
      // Find the column with minimum height
      int shortestColumnIndex = 0;
      for (int j = 1; j < columnHeights.length; j++) {
        if (columnHeights[j] < columnHeights[shortestColumnIndex]) {
          shortestColumnIndex = j;
        }
      }

      // Add child to the shortest column
      columns[shortestColumnIndex].add(children[i]);
      
      // Estimate height increase (you can adjust this based on your content)
      // For now, we'll use a simple estimation
      columnHeights[shortestColumnIndex] += 200 + mainAxisSpacing;
    }

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: columns.asMap().entries.map((entry) {
        int columnIndex = entry.key;
        List<Widget> columnChildren = entry.value;

        return Expanded(
          child: Padding(
            padding: EdgeInsets.only(
              left: columnIndex == 0 ? 0 : crossAxisSpacing / 2,
              right: columnIndex == columns.length - 1 ? 0 : crossAxisSpacing / 2,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: columnChildren.asMap().entries.map((childEntry) {
                int childIndex = childEntry.key;
                Widget child = childEntry.value;

                return Padding(
                  padding: EdgeInsets.only(
                    bottom: childIndex == columnChildren.length - 1 ? 0 : mainAxisSpacing,
                  ),
                  child: child,
                );
              }).toList(),
            ),
          ),
        );
      }).toList(),
    );
  }
}

class SmartStaggeredGrid extends StatefulWidget {
  final List<Widget> children;
  final int crossAxisCount;
  final double mainAxisSpacing;
  final double crossAxisSpacing;

  const SmartStaggeredGrid({
    super.key,
    required this.children,
    required this.crossAxisCount,
    this.mainAxisSpacing = 8.0,
    this.crossAxisSpacing = 8.0,
  });

  @override
  State<SmartStaggeredGrid> createState() => _SmartStaggeredGridState();
}

class _SmartStaggeredGridState extends State<SmartStaggeredGrid> {
  final List<GlobalKey> _keys = [];
  final List<double> _heights = [];
  bool _measured = false;

  @override
  void initState() {
    super.initState();
    _initializeKeys();
  }

  @override
  void didUpdateWidget(SmartStaggeredGrid oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.children.length != widget.children.length) {
      _initializeKeys();
    }
  }

  void _initializeKeys() {
    _keys.clear();
    _heights.clear();
    _measured = false;
    
    for (int i = 0; i < widget.children.length; i++) {
      _keys.add(GlobalKey());
      _heights.add(0.0);
    }
  }

  void _measureHeights() {
    if (_measured) return;
    
    WidgetsBinding.instance.addPostFrameCallback((_) {
      bool allMeasured = true;
      for (int i = 0; i < _keys.length; i++) {
        final RenderBox? renderBox = _keys[i].currentContext?.findRenderObject() as RenderBox?;
        if (renderBox != null) {
          _heights[i] = renderBox.size.height;
        } else {
          allMeasured = false;
        }
      }
      
      if (allMeasured && mounted) {
        setState(() {
          _measured = true;
        });
      }
    });
  }

  List<List<int>> _distributeItems() {
    List<List<int>> columns = List.generate(widget.crossAxisCount, (index) => []);
    List<double> columnHeights = List.generate(widget.crossAxisCount, (index) => 0.0);

    for (int i = 0; i < widget.children.length; i++) {
      // Find the column with minimum height
      int shortestColumnIndex = 0;
      for (int j = 1; j < columnHeights.length; j++) {
        if (columnHeights[j] < columnHeights[shortestColumnIndex]) {
          shortestColumnIndex = j;
        }
      }

      // Add item index to the shortest column
      columns[shortestColumnIndex].add(i);
      
      // Add height to column
      double itemHeight = _measured ? _heights[i] : 200; // fallback height
      columnHeights[shortestColumnIndex] += itemHeight + widget.mainAxisSpacing;
    }

    return columns;
  }

  @override
  Widget build(BuildContext context) {
    if (widget.children.isEmpty) {
      return const SizedBox.shrink();
    }

    if (!_measured) {
      _measureHeights();
      // First render: measure all items in a hidden layout
      return Opacity(
        opacity: 0.0,
        child: Column(
          children: widget.children.asMap().entries.map((entry) {
            return Container(
              key: _keys[entry.key],
              child: entry.value,
            );
          }).toList(),
        ),
      );
    }

    // Second render: use measured heights to create staggered layout
    final columns = _distributeItems();

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: columns.asMap().entries.map((entry) {
        int columnIndex = entry.key;
        List<int> itemIndices = entry.value;

        return Expanded(
          child: Padding(
            padding: EdgeInsets.only(
              left: columnIndex == 0 ? 0 : widget.crossAxisSpacing / 2,
              right: columnIndex == columns.length - 1 ? 0 : widget.crossAxisSpacing / 2,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: itemIndices.asMap().entries.map((itemEntry) {
                int positionInColumn = itemEntry.key;
                int itemIndex = itemEntry.value;

                return Padding(
                  padding: EdgeInsets.only(
                    bottom: positionInColumn == itemIndices.length - 1 ? 0 : widget.mainAxisSpacing,
                  ),
                  child: widget.children[itemIndex],
                );
              }).toList(),
            ),
          ),
        );
      }).toList(),
    );
  }
}