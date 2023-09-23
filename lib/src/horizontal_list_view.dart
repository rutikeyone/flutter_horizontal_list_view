import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:horizontal_list_view/src/snap_scroll_physic.dart';

/// Custom Horizontal list view widget for flutter
class HorizontalListView extends StatefulWidget {
  const HorizontalListView({
    required this.crossAxisCount,
    this.crossAxisSpacing = 0,
    this.controller,
    required this.itemCount,
    required this.itemBuilder,
    super.key,
  });

  /// [crossAxisCount] specifies the number of items to display per row.
  final int crossAxisCount;

  /// [crossAxisSpacing] sets the spacing between items in the same row.
  final double crossAxisSpacing;

  /// [controller] is an optional scroll controller to control the scroll behavior.
  final HorizontalListViewController? controller;

  /// [itemCount] is the total number of items in the list.
  final int itemCount;

  /// [itemBuilder] is a callback function to build each item widget.
  final Widget Function(BuildContext context, int index) itemBuilder;

  @override
  State<HorizontalListView> createState() => _HorizontalListViewState();
}

class _HorizontalListViewState extends State<HorizontalListView> {
  void rebuildAllChildren(BuildContext context) {
    void rebuild(Element el) {
      el.markNeedsBuild();
      el.visitChildren(rebuild);
    }

    (context as Element).visitChildren(rebuild);
  }

  Key _key = UniqueKey();

  int _computeActualChildCount(int itemCount) {
    return math.max(0, itemCount * 2 - 1);
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      key: _key,
      builder: (context, constraints) {
        double snapSize = constraints.maxWidth + widget.crossAxisSpacing;

        SnapScrollSize scrollPhysics = SnapScrollSize(snapSize: snapSize);

        if (!_key.toString().contains(snapSize.toString())) {
          Future.delayed(Duration.zero, () {
            rebuildAllChildren(context);
            _key = new Key('snap-$snapSize');
            setState(() {});
          });
        }

        if (widget.controller != null) {
          widget.controller!.snapSize = snapSize;
        }

        double itemWidth = (constraints.maxWidth -
                ((widget.crossAxisCount - 1) * widget.crossAxisSpacing)) /
            widget.crossAxisCount;
        return SingleChildScrollView(
          controller: widget.controller,
          physics: scrollPhysics,
          scrollDirection: Axis.horizontal,
          child: Row(
            children: List.generate(
              _computeActualChildCount(widget.itemCount),
              (index) {
                if (index.isEven) {
                  return SizedBox(
                    width: itemWidth,
                    child: widget.itemBuilder.call(context, index ~/ 2),
                  );
                } else {
                  return SizedBox(width: widget.crossAxisSpacing);
                }
              },
            ),
          ),
        );
      },
    );
  }
}

/// Custom scroll controller for controlling the horizontal list view's behavior.
class HorizontalListViewController extends ScrollController {
  HorizontalListViewController() : super();

  /// Animates the scroll view to a specific page with [duration] and [curve].
  ///
  /// [page] is the target page number.
  Future<void> animateToPage(int page,
      {required Duration duration, required Curve curve}) {
    double offset = _snapSize * page;

    if (page <= 0) {
      page = 0;
      offset = position.minScrollExtent;
    }
    if (page >= pageLenght) {
      page = pageLenght;
      offset = position.maxScrollExtent;
    }

    return super.animateTo(offset, duration: duration, curve: curve);
  }

  /// Gets the current visible page.
  int get currentPage {
    String roundedPage = (position.pixels / _snapSize).toStringAsFixed(1);
    int parsedNumber = double.parse(roundedPage).ceil();
    return parsedNumber;
  }

  /// Gets the total number of pages in the list.
  int get pageLenght => (position.maxScrollExtent / _snapSize).ceil();

  double _snapSize = 0;

  /// Sets the snap size for scrolling.
  set snapSize(double value) => _snapSize = value;
}
