import 'package:flutter/material.dart';

// Custom ExpansionPanel
class CustomExpansionPanel {
  final Widget Function(BuildContext, bool) headerBuilder;
  final Widget body;
  final bool isExpanded;
  final bool canTapOnHeader;
  final bool hasIcon;
  final Color? backgroundColor;

  const CustomExpansionPanel({
    required this.headerBuilder,
    required this.body,
    this.isExpanded = false,
    this.canTapOnHeader = true,
    this.hasIcon = true,
    this.backgroundColor,
  });
}

class CustomExpansionPanelList extends StatefulWidget {
  const CustomExpansionPanelList({
    Key? key,
    this.children = const <CustomExpansionPanel>[],
    this.expansionCallback,
    this.animationDuration = kThemeAnimationDuration,
    this.expandedHeaderPadding = const EdgeInsets.symmetric(vertical: 64.0 - kMinInteractiveDimension),
    this.dividerColor,
    this.elevation = 2,
    this.expandIconColor,
    this.materialGapSize = 16.0,
  }) : super(key: key);

  final List<CustomExpansionPanel> children;
  final ExpansionPanelCallback? expansionCallback;
  final Duration animationDuration;
  final EdgeInsets expandedHeaderPadding;
  final Color? dividerColor;
  final double elevation;
  final Color? expandIconColor;
  final double materialGapSize;

  @override
  State<CustomExpansionPanelList> createState() => _CustomExpansionPanelListState();
}

class _CustomExpansionPanelListState extends State<CustomExpansionPanelList> {
  bool _isChildExpanded(int index) {
    return widget.children[index].isExpanded;
  }

  void _handlePressed(bool isExpanded, int index) {
    widget.expansionCallback?.call(index, !isExpanded);
  }

  @override
  Widget build(BuildContext context) {
    final List<MergeableMaterialItem> items = <MergeableMaterialItem>[];

    for (int index = 0; index < widget.children.length; index++) {
      if (_isChildExpanded(index) && index != 0 && !_isChildExpanded(index - 1)) {
        items.add(MaterialGap(
          key: ValueKey(index * 2 - 1),
          size: widget.materialGapSize,
        ));
      }

      final CustomExpansionPanel child = widget.children[index];
      final Widget headerWidget = child.headerBuilder(context, _isChildExpanded(index));

      Widget expandIconContainer = Container(
        margin: const EdgeInsetsDirectional.only(end: 8.0),
        child: ExpandIcon(
          color: widget.expandIconColor,
          isExpanded: _isChildExpanded(index),
          padding: const EdgeInsets.all(12.0),
          onPressed: !child.canTapOnHeader
              ? (bool isExpanded) => _handlePressed(isExpanded, index)
              : null,
        ),
      );

      if (!child.canTapOnHeader) {
        final MaterialLocalizations localizations = MaterialLocalizations.of(context);
        expandIconContainer = Semantics(
          label: _isChildExpanded(index) ? localizations.expandedIconTapHint : localizations.collapsedIconTapHint,
          container: true,
          child: expandIconContainer,
        );
      }

      Widget header = Row(
        children: <Widget>[
          Expanded(
            child: AnimatedContainer(
              duration: widget.animationDuration,
              curve: Curves.fastOutSlowIn,
              margin: _isChildExpanded(index) ? widget.expandedHeaderPadding : EdgeInsets.zero,
              child: ConstrainedBox(
                constraints: const BoxConstraints(minHeight: kMinInteractiveDimension),
                child: headerWidget,
              ),
            ),
          ),
          if (child.hasIcon) expandIconContainer,
        ],
      );

      if (child.canTapOnHeader) {
        header = MergeSemantics(
          child: InkWell(
            onTap: () => _handlePressed(_isChildExpanded(index), index),
            child: header,
          ),
        );
      }

      items.add(
        MaterialSlice(
          key: ValueKey(index * 2),
          child: Column(
            children: <Widget>[
              header,
              AnimatedCrossFade(
                firstChild: Container(height: 0.0),
                secondChild: child.body,
                firstCurve: const Interval(0.0, 0.6, curve: Curves.fastOutSlowIn),
                secondCurve: const Interval(0.4, 1.0, curve: Curves.fastOutSlowIn),
                sizeCurve: Curves.fastOutSlowIn,
                crossFadeState: _isChildExpanded(index)
                    ? CrossFadeState.showSecond
                    : CrossFadeState.showFirst,
                duration: widget.animationDuration,
              ),
            ],
          ),
        ),
      );

      if (_isChildExpanded(index) && index != widget.children.length - 1) {
        items.add(MaterialGap(
          key: ValueKey(index * 2 + 1),
          size: widget.materialGapSize,
        ));
      }
    }

    return MergeableMaterial(
      dividerColor: widget.dividerColor,
      elevation: widget.elevation,
      children: items,
    );
  }
}
