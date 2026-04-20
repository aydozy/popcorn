import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';

class DetailOverview extends StatefulWidget {
  final String overview;

  const DetailOverview({required this.overview, super.key});

  @override
  State<DetailOverview> createState() => _DetailOverviewState();
}

class _DetailOverviewState extends State<DetailOverview> {
  static const int _collapsedLines = 4;
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Overview', style: AppTextStyles.titleLarge),
          const SizedBox(height: 12),
          LayoutBuilder(
            builder: (BuildContext ctx, BoxConstraints constraints) {
              final TextSpan span = TextSpan(
                text: widget.overview,
                style: AppTextStyles.bodyLarge,
              );
              final TextPainter painter = TextPainter(
                text: span,
                maxLines: _collapsedLines,
                textDirection: TextDirection.ltr,
              )..layout(maxWidth: constraints.maxWidth);
              final bool overflows = painter.didExceedMaxLines;

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.overview,
                    style: AppTextStyles.bodyLarge,
                    maxLines: _expanded ? null : _collapsedLines,
                    overflow: _expanded
                        ? TextOverflow.visible
                        : TextOverflow.ellipsis,
                  ),
                  if (overflows) ...[
                    const SizedBox(height: 4),
                    GestureDetector(
                      onTap: () => setState(() => _expanded = !_expanded),
                      behavior: HitTestBehavior.opaque,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 10, horizontal: 4),
                        child: Text(
                          _expanded ? 'Show less' : 'Read more',
                          style: AppTextStyles.labelMedium.copyWith(
                            color: AppColors.primaryRose,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ),
                  ],
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}
