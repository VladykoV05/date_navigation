import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../domain/value_objects/geo_coordinate.dart';
import '../../../../core/services/navigation_service.dart';
import '../../../../core/theme/ui_tokens.dart';
import '../../../../core/utils/show_notification.dart';
import '../view_data/place_view_data.dart';
import './place_details_sheet.dart';

Future<void> showPlaceActionsSheet({
  required BuildContext context,
  required PlaceViewData place,
  required GeoCoordinate? myPoint,
  required GeoCoordinate? partnerPoint,
  required bool isFavorite,
  required NavigationService navigationService,
  required Future<void> Function() onToggleFavorite,
  required Future<void> Function() onProposePlace,
  required bool canProposePlace,
}) async {
  var isBusy = false;
  await showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (_) => StatefulBuilder(
      builder: (context, setModalState) {
        final colorScheme = Theme.of(context).colorScheme;
        return Container(
          decoration: BoxDecoration(
            color: colorScheme.surface,
            borderRadius: const BorderRadius.vertical(
              top: Radius.circular(UiRadius.lg),
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              PlaceDetailsSheet(
                place: place,
                startPoint: myPoint,
                partnerPoint: partnerPoint,
                navigationService: navigationService,
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(
                  UiSpace.lg,
                  0,
                  UiSpace.lg,
                  UiSpace.xxl,
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: FilledButton.tonalIcon(
                        icon: Icon(
                          isFavorite ? Icons.bookmark : Icons.bookmark_border,
                        ),
                        label: Text(
                          isFavorite ? 'Убрать из избранного' : 'В избранное',
                        ),
                        style: FilledButton.styleFrom(
                          minimumSize: const Size(double.infinity, 50),
                        ),
                        onPressed: isBusy
                            ? null
                            : () async {
                                setModalState(() => isBusy = true);
                                try {
                                  await onToggleFavorite();
                                  if (context.mounted) {
                                    HapticFeedback.selectionClick();
                                    ShowNotification.showSnackBar(
                                      context,
                                      isFavorite
                                          ? 'Удалено из избранного'
                                          : 'Добавлено в избранное',
                                    );
                                    Navigator.pop(context);
                                  }
                                } finally {
                                  if (context.mounted) {
                                    setModalState(() => isBusy = false);
                                  }
                                }
                              },
                      ),
                    ),
                    if (canProposePlace) const SizedBox(width: UiSpace.xs),
                    if (canProposePlace)
                      Expanded(
                        child: FilledButton.tonalIcon(
                          icon: const Icon(Icons.send),
                          label: const Text('Предложить'),
                          style: FilledButton.styleFrom(
                            minimumSize: const Size(double.infinity, 50),
                          ),
                          onPressed: isBusy
                              ? null
                              : () async {
                                  setModalState(() => isBusy = true);
                                  try {
                                    await onProposePlace();
                                    if (context.mounted) {
                                      HapticFeedback.lightImpact();
                                      ShowNotification.showSnackBar(
                                        context,
                                        'Место предложено партнеру',
                                      );
                                      Navigator.pop(context);
                                    }
                                  } finally {
                                    if (context.mounted) {
                                      setModalState(() => isBusy = false);
                                    }
                                  }
                                },
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    ),
  );
}
