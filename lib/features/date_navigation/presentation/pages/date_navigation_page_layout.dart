part of 'date_navigation_page.dart';

extension _DateNavigationPageLayout on _DateNavigationPageState {
  Widget _buildPageBody(
    DateNavigationController controller,
    double sheetMaxChildSize,
  ) {
    return Stack(
      children: [
        DateNavigationMapConsumerSection(
          mapController: _mapController,
          onPlaceTap: _showPlaceDetails,
          loadingMessageBuilder: _loadingMessageFromFlags,
        ),
        DateNavigationMapOverlay(
          onFitAllPoints: _fitAllPoints,
          onResetMapOrientation: _resetMapOrientation,
          onFocusMyPoint: _focusOnMyPoint,
        ),
        _buildDraggableSheet(controller, sheetMaxChildSize),
        const Positioned(
          top: _DateNavigationPageState._accountMenuInset,
          right: _DateNavigationPageState._accountMenuInset,
          child: DateNavigationAccountMenu(),
        ),
      ],
    );
  }

  Widget _buildDraggableSheet(
    DateNavigationController controller,
    double sheetMaxChildSize,
  ) {
    return DraggableScrollableSheet(
      controller: _sheetController,
      initialChildSize: _DateNavigationPageState._sheetInitialChildSize,
      minChildSize: _DateNavigationPageState._sheetMinChildSize,
      maxChildSize: sheetMaxChildSize,
      snap: true,
      snapSizes: _buildSnapSizes(sheetMaxChildSize),
      builder: (context, scrollController) {
        final bottomInset = MediaQuery.viewInsetsOf(context).bottom;
        return _buildDraggableSheetContent(
          context: context,
          controller: controller,
          scrollController: scrollController,
          bottomInset: bottomInset,
        );
      },
    );
  }

  Widget _buildDraggableSheetContent({
    required BuildContext context,
    required DateNavigationController controller,
    required ScrollController scrollController,
    required double bottomInset,
  }) {
    return NotificationListener<DraggableScrollableNotification>(
      onNotification: (notification) {
        _lastSheetExtent = notification.extent;
        return false;
      },
      child: AnimatedPadding(
        duration: const Duration(
          milliseconds: _DateNavigationPageState._sheetAnimationMs,
        ),
        curve: Curves.easeOut,
        padding: EdgeInsets.only(bottom: bottomInset),
        child: Container(
          decoration: _sheetDecoration(context),
          child: CustomScrollView(
            controller: scrollController,
            keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
            slivers: [
              SliverToBoxAdapter(child: _buildHandle()),
              SliverToBoxAdapter(child: const DateNavigationStatusBanners()),
              SliverPadding(
                padding: UiInsets.pageHorizontal,
                sliver: SliverToBoxAdapter(
                  child: DateNavigationRoomBodyConsumerSection(
                    controller: controller,
                    addressController: _addressCtrl,
                    onSubmitAddress: () => _submitAddress(controller),
                    onAddressSuggestionSelected: (address) =>
                        _onAddressSuggestionSelected(
                          controller: controller,
                          address: address,
                        ),
                    onShowJoinDialog: _showJoinDialog,
                    onPlaceTap: _showPlaceDetails,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _handleBackNavigation() async {
    final roomId = ref.read(
      dateNavigationControllerProvider.select((s) => s.roomSession.roomId),
    );
    if (roomId == null) {
      if (mounted) Navigator.of(context).maybePop();
      return;
    }
    final shouldLeave = await ConfirmDialog.showBinary(
      context,
      title: 'Покинуть комнату?',
      message:
          'Вы выйдете из текущей комнаты на этом устройстве и вернетесь на стартовый экран.',
      cancelLabel: UiCopy.noLabel,
      confirmLabel: UiCopy.leaveRoomConfirm,
    );
    if (shouldLeave != true) return;
    ref.read(dateNavigationControllerProvider.notifier).leaveRoom();
    if (mounted) Navigator.of(context).maybePop();
  }

  BoxDecoration _sheetDecoration(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return BoxDecoration(
      color: colorScheme.surface,
      borderRadius: const BorderRadius.vertical(
        top: Radius.circular(_DateNavigationPageState._sheetCornerRadius),
      ),
      boxShadow: [
        BoxShadow(
          color: colorScheme.shadow.withValues(alpha: UiElevation.shadowAlpha),
          blurRadius: UiElevation.blur,
          spreadRadius: UiElevation.spread,
        ),
      ],
    );
  }

  Widget _buildHandle() => Center(
    child: Container(
      margin: const EdgeInsets.symmetric(
        vertical: _DateNavigationPageState._dragHandleVerticalMargin,
      ),
      width: _DateNavigationPageState._dragHandleWidth,
      height: _DateNavigationPageState._dragHandleHeight,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.outlineVariant,
        borderRadius: BorderRadius.circular(2),
      ),
    ),
  );

  List<double> _buildSnapSizes(double maxChildSize) {
    final sizes = <double>{
      _DateNavigationPageState._sheetMinChildSize,
      _DateNavigationPageState._sheetInitialChildSize,
      maxChildSize,
    }..removeWhere(
      (size) =>
          size < _DateNavigationPageState._sheetMinChildSize ||
          size > maxChildSize,
    );
    final sorted = sizes.toList()..sort();
    return sorted;
  }

  void _stabilizeSheetExtent(double nextMaxSize) {
    final prevMax = _lastSheetMaxSize;
    _lastSheetMaxSize = nextMaxSize;
    if (!_sheetController.isAttached) return;
    final shouldClampDown =
        nextMaxSize < prevMax &&
        _lastSheetExtent >
            nextMaxSize + _DateNavigationPageState._sheetClampEpsilon;
    if (!shouldClampDown) return;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted || !_sheetController.isAttached) return;
      final target = nextMaxSize.clamp(
        _DateNavigationPageState._sheetMinChildSize,
        _DateNavigationPageState._sheetClampUpperBound,
      );
      _sheetController.animateTo(
        target,
        duration: const Duration(
          milliseconds: _DateNavigationPageState._sheetAnimationMs,
        ),
        curve: Curves.easeOutCubic,
      );
    });
  }
}
