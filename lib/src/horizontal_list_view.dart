import 'package:flutter/material.dart';
import 'package:horizontal_list_view/src/snap_scroll_physic.dart';

/// Custom Horizontal list view widget for flutter
class HorizontalListView extends StatelessWidget {
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
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        double snapSize = constraints.maxWidth + crossAxisSpacing;

        if (controller != null) {
          controller!.snapSize = snapSize;
        }

        double itemWidth =
            (constraints.maxWidth - ((crossAxisCount - 1) * crossAxisSpacing)) /
                crossAxisCount;
        return SingleChildScrollView(
          controller: controller,
          physics: SnapScrollSize(
            snapSize: snapSize,
          ),
          scrollDirection: Axis.horizontal,
          child: Row(
            children: List.generate(
              itemCount * 2 - 1,
              (index) {
                if (index.isEven) {
                  return SizedBox(
                    width: itemWidth,
                    child: itemBuilder.call(context, index ~/ 2),
                  );
                } else {
                  return SizedBox(width: crossAxisSpacing);
                }
              },
            ),
          ),
        );
      },
    );
  }
}

class PageChangeNotifier extends ChangeNotifier {}

/// Custom scroll controller for controlling the horizontal list view's behavior.
class HorizontalListViewController extends ScrollController {
  HorizontalListViewController() : super();

  /// Animates the scroll view to a specific page with [duration] and [curve].
  ///
  /// [page] is the target page number.
  Future<void> animateToPage(int page,
      {required Duration duration, required Curve curve}) {
    double offset = _snapSize * page;
    print('Requested page:$page\ncurrent page: $currentPage\n${pageLenght}');

    if (page <= 0) {
      page = 0;
      offset = position.minScrollExtent;
    }
    if (page > pageLenght) {
      page = pageLenght;
      offset = position.maxScrollExtent;
    }

    return super.animateTo(offset, duration: duration, curve: curve);
  }

  /// Gets the current visible page.
  int get currentPage => (position.pixels / _snapSize).abs().toInt();

  /// Gets the total number of pages in the list.
  int get pageLenght => position.maxScrollExtent ~/ _snapSize;

  double _snapSize = 0;

  /// Sets the snap size for scrolling.
  set snapSize(double value) => _snapSize = value;
}
