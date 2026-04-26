part of 'date_navigation_page.dart';

extension _DateNavigationPageMap on _DateNavigationPageState {
  void _focusOnAddressPoint(latlong.LatLng? point) {
    if (point == null) return;
    unawaited(
      _animateMapCamera(
        center: point,
        zoom: _DateNavigationPageState._addressFocusZoom,
      ),
    );
  }

  void _focusOnCenter(latlong.LatLng centerPoint) {
    unawaited(
      _animateMapCamera(
        center: centerPoint,
        zoom: _DateNavigationPageState._centerFocusZoom,
      ),
    );
  }

  void _focusOnChosenVenue(Place place) {
    unawaited(
      _animateMapCamera(
        center: latlong.LatLng(place.lat, place.lon),
        zoom: _DateNavigationPageState._finalVenueZoom,
        rotation: 0,
      ),
    );
  }

  void _focusOnMyPoint() {
    final state = ref.read(dateNavigationControllerProvider);
    final myPoint = state.myPoint(state.roomSession.isCreator);
    if (myPoint == null) {
      _showInfoSnackBar(UiCopy.focusPointMissing);
      return;
    }
    _focusOnAddressPoint(myPoint);
  }

  void _fitAllPoints() {
    final state = ref.read(dateNavigationControllerProvider);
    final points = _collectPointsForFit(state);
    if (_handleFitWithInsufficientPoints(points)) {
      return;
    }
    final fit = CameraFit.bounds(
      bounds: LatLngBounds.fromPoints(points),
      padding: _DateNavigationPageState._fitAllPointsPadding,
    );
    _applyCameraFit(fit);
  }

  List<latlong.LatLng> _collectPointsForFit(DateNavigationState state) {
    final points = <latlong.LatLng>[];
    if (state.roomSession.point1 != null) points.add(state.roomSession.point1!);
    if (state.roomSession.point2 != null) points.add(state.roomSession.point2!);
    final hasLockedFinalChoice =
        state.meeting.finalChoiceName != null &&
        state.meeting.finalChoiceName!.isNotEmpty;
    if (hasLockedFinalChoice && state.meeting.finalChoicePlace != null) {
      final selectedPlace = state.meeting.finalChoicePlace!;
      points.add(latlong.LatLng(selectedPlace.lat, selectedPlace.lon));
      return points;
    }
    if (state.meeting.centerPoint != null) {
      points.add(state.meeting.centerPoint!);
    }
    if (state.meeting.routePoints.isNotEmpty) {
      points.addAll(state.meeting.routePoints);
    }
    return points;
  }

  bool _handleFitWithInsufficientPoints(List<latlong.LatLng> points) {
    if (points.length >= 2) return false;
    if (points.isNotEmpty) {
      unawaited(
        _animateMapCamera(
          center: points.first,
          zoom: _DateNavigationPageState._addressFocusZoom,
        ),
      );
    } else {
      _showInfoSnackBar(UiCopy.notEnoughPoints);
    }
    return true;
  }

  void _applyCameraFit(CameraFit fit) {
    try {
      final fitted = fit.fit(_mapController.camera);
      unawaited(
        _animateMapCamera(
          center: fitted.center,
          zoom: fitted.zoom,
          rotation: 0,
        ),
      );
    } catch (_) {
      _mapController.fitCamera(fit);
    }
  }

  void _resetMapOrientation() {
    unawaited(
      _animateMapCamera(
        rotation: 0,
        duration: const Duration(milliseconds: 280),
      ),
    );
  }

  Future<void> _animateMapCamera({
    latlong.LatLng? center,
    double? zoom,
    double? rotation,
    Duration duration = const Duration(milliseconds: 420),
  }) async {
    if (!mounted) return;
    final cameraTweenData = _buildCameraTweenData(
      center: center,
      zoom: zoom,
      rotation: rotation,
    );
    if (_isNoCameraChange(cameraTweenData)) return;

    final controller = _mapAnimationController;
    controller
      ..stop()
      ..duration = duration
      ..reset();
    final curved = CurvedAnimation(
      parent: controller,
      curve: Curves.easeOutCubic,
    );
    final listener = _buildCameraAnimationListener(curved, cameraTweenData);

    controller.addListener(listener);
    try {
      if (!mounted) return;
      await controller.forward();
    } finally {
      controller.removeListener(listener);
    }
  }

  _CameraTweenData _buildCameraTweenData({
    latlong.LatLng? center,
    double? zoom,
    double? rotation,
  }) {
    final camera = _mapController.camera;
    final startCenter = camera.center;
    final startZoom = camera.zoom;
    final startRotation = camera.rotation;
    final endCenter = center ?? startCenter;
    final endZoom = zoom ?? startZoom;
    final endRotation = rotation ?? startRotation;
    return _CameraTweenData(
      startCenter: startCenter,
      startZoom: startZoom,
      startRotation: startRotation,
      endCenter: endCenter,
      endZoom: endZoom,
      endRotation: endRotation,
    );
  }

  bool _isNoCameraChange(_CameraTweenData data) {
    final noCenterChange =
        (data.startCenter.latitude - data.endCenter.latitude).abs() <
            _DateNavigationPageState._coordEpsilon &&
        (data.startCenter.longitude - data.endCenter.longitude).abs() <
            _DateNavigationPageState._coordEpsilon;
    final noZoomChange =
        (data.startZoom - data.endZoom).abs() <
        _DateNavigationPageState._zoomRotationEpsilon;
    final noRotationChange =
        (data.startRotation - data.endRotation).abs() <
        _DateNavigationPageState._zoomRotationEpsilon;
    return noCenterChange && noZoomChange && noRotationChange;
  }

  VoidCallback _buildCameraAnimationListener(
    CurvedAnimation curved,
    _CameraTweenData data,
  ) {
    final latTween = Tween<double>(
      begin: data.startCenter.latitude,
      end: data.endCenter.latitude,
    );
    final lonTween = Tween<double>(
      begin: data.startCenter.longitude,
      end: data.endCenter.longitude,
    );
    final zoomTween = Tween<double>(begin: data.startZoom, end: data.endZoom);
    final rotationTween = Tween<double>(
      begin: data.startRotation,
      end: data.endRotation,
    );
    return () {
      if (!mounted) return;
      final animationValue = curved.value;
      final frameCenter = latlong.LatLng(
        latTween.transform(animationValue),
        lonTween.transform(animationValue),
      );
      _mapController.move(frameCenter, zoomTween.transform(animationValue));
      _mapController.rotate(rotationTween.transform(animationValue));
    };
  }
}

class _CameraTweenData {
  const _CameraTweenData({
    required this.startCenter,
    required this.startZoom,
    required this.startRotation,
    required this.endCenter,
    required this.endZoom,
    required this.endRotation,
  });

  final latlong.LatLng startCenter;
  final double startZoom;
  final double startRotation;
  final latlong.LatLng endCenter;
  final double endZoom;
  final double endRotation;
}
