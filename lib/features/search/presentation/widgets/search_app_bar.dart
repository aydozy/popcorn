import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../shared/widgets/glass_back_button.dart';
import '../bloc/search_bloc.dart';
import '../bloc/search_event.dart';
import '../bloc/search_state.dart';

class SearchAppBar extends StatefulWidget {
  const SearchAppBar({super.key});

  @override
  State<SearchAppBar> createState() => _SearchAppBarState();
}

class _SearchAppBarState extends State<SearchAppBar> {
  late final TextEditingController _controller;
  late final FocusNode _focusNode;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
    _focusNode = FocusNode();
    // Auto-focus once the frame settles — opens the keyboard and signals
    // the screen is ready for input.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) _focusNode.requestFocus();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      bottom: false,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
        child: Row(
          children: [
            GlassBackButton(onTap: () => context.pop()),
            const SizedBox(width: 12),
            Expanded(
              child: BlocListener<SearchBloc, SearchState>(
                // When the bloc resets to idle (e.g. X tap, genre cleared,
                // genre selected), keep the TextField's text in sync.
                listenWhen: (SearchState a, SearchState b) =>
                    a.query != b.query,
                listener: (BuildContext context, SearchState state) {
                  if (state.query != _controller.text) {
                    _controller.text = state.query;
                    _controller.selection = TextSelection.fromPosition(
                      TextPosition(offset: state.query.length),
                    );
                  }
                },
                child: TextField(
      controller: _controller,
      focusNode: _focusNode,
      style: AppTextStyles.bodyLarge,
      cursorColor: AppColors.primaryRose,
      textInputAction: TextInputAction.search,
      onChanged: (String value) =>
          context.read<SearchBloc>().add(SearchQueryChanged(value)),
      decoration: InputDecoration(
        hintText: 'Search movies, actors, genres…',
        hintStyle:
            AppTextStyles.bodyLarge.copyWith(color: AppColors.textTertiary),
        prefixIcon: const Icon(
          Icons.search_rounded,
          color: AppColors.textSecondary,
          size: 22,
        ),
        suffixIcon: ValueListenableBuilder<TextEditingValue>(
          valueListenable: _controller,
          builder: (BuildContext context, TextEditingValue value, _) {
            if (value.text.isEmpty) return const SizedBox.shrink();
            return IconButton(
              icon: const Icon(Icons.close_rounded,
                  color: AppColors.textSecondary, size: 20),
              onPressed: () {
                _controller.clear();
                context.read<SearchBloc>().add(const SearchCleared());
              },
            );
          },
        ),
        filled: true,
        fillColor: AppColors.surface,
        isDense: true,
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(
            color: AppColors.primaryRose,
            width: 1.5,
          ),
        ),
      ),
    )
              ),
            ),
          ],
        ),
      ),
    );
  }
}

