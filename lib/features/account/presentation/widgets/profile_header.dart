import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../core/error/result.dart';
import '../../../../core/l10n/l10n_extensions.dart';
import '../../../../core_ui/avatar/avatar_presets.dart';
import '../../../../core/profile/profile_providers.dart';
import '../../../../core/profile/avatar_codec.dart';
import '../../../../core_ui/avatar/public_avatar.dart';

/// Карточка профиля в аккаунте: аватар, имя и способы выбрать фото.
class ProfileHeader extends ConsumerStatefulWidget {
  const ProfileHeader({super.key, required this.uid, required this.emailOrId});

  final String uid;
  final String emailOrId;

  @override
  ConsumerState<ProfileHeader> createState() => _ProfileHeaderState();
}

class _ProfileHeaderState extends ConsumerState<ProfileHeader> {
  bool _busy = false;

  Future<void> _run(Future<Result<void>> Function() action) async {
    if (_busy) return;
    setState(() => _busy = true);
    final result = await action();
    if (!mounted) return;
    setState(() => _busy = false);
    if (result case Err()) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(context.l10n.profileSaveError)));
    }
  }

  Future<void> _rename(PublicProfileViewData? profile) async {
    final name = await showDialog<String>(
      context: context,
      builder: (_) => _RenameDialog(initial: profile?.shownName ?? ''),
    );
    if (name == null || name.isEmpty) return;
    await _run(
      () => ref
          .read(publicProfileRepositoryProvider)
          .rename(uid: widget.uid, name: name),
    );
  }

  Future<void> _pickFromGallery() async {
    final file = await ImagePicker().pickImage(
      source: ImageSource.gallery,
      maxWidth: 1024,
      imageQuality: 90,
    );
    if (file == null) return;
    final bytes = await file.readAsBytes();
    final encoded = await compute(AvatarCodec.encode, bytes);
    if (!mounted) return;
    if (encoded == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(context.l10n.profileAvatarTooLarge)),
      );
      return;
    }
    await _run(
      () => ref
          .read(publicProfileRepositoryProvider)
          .setAvatarBase64(uid: widget.uid, avatarBase64: encoded),
    );
  }

  Future<void> _pickPreset() async {
    final l10n = context.l10n;
    final index = await showModalBottomSheet<int>(
      context: context,
      showDragHandle: true,
      builder: (sheetContext) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 4, 16, 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                l10n.profileChooseAvatar,
                style: Theme.of(sheetContext).textTheme.titleMedium,
              ),
              const SizedBox(height: 12),
              GridView.count(
                crossAxisCount: 6,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                mainAxisSpacing: 12,
                crossAxisSpacing: 12,
                children: [
                  for (var i = 0; i < AvatarPresets.count; i++)
                    InkWell(
                      customBorder: const CircleBorder(),
                      onTap: () => Navigator.of(sheetContext).pop(i),
                      child: CircleAvatar(
                        backgroundColor: AvatarPresets.colorOf(i),
                        child: Icon(
                          AvatarPresets.iconOf(i),
                          color: Colors.white,
                        ),
                      ),
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
    if (index == null) return;
    await _run(
      () => ref
          .read(publicProfileRepositoryProvider)
          .setPreset(uid: widget.uid, preset: index),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final profile = ref.watch(publicProfileViewProvider(widget.uid)).value;
    final textTheme = Theme.of(context).textTheme;
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
      child: Column(
        children: [
          Row(
            children: [
              PublicAvatar(uid: widget.uid, radius: 32),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      profile?.shownName ?? l10n.accountUserFallback,
                      style: textTheme.titleMedium,
                    ),
                    Text(
                      widget.emailOrId,
                      style: textTheme.bodySmall,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              IconButton(
                tooltip: l10n.profileEditName,
                onPressed: _busy ? null : () => _rename(profile),
                icon: const Icon(Icons.edit_outlined),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            children: [
              OutlinedButton.icon(
                onPressed: _busy ? null : _pickFromGallery,
                icon: const Icon(Icons.photo_library_outlined),
                label: Text(l10n.profilePhotoGallery),
              ),
              OutlinedButton.icon(
                onPressed: _busy ? null : _pickPreset,
                icon: const Icon(Icons.emoji_emotions_outlined),
                label: Text(l10n.profilePhotoPreset),
              ),
              OutlinedButton.icon(
                onPressed: _busy
                    ? null
                    : () => _run(
                        () => ref
                            .read(publicProfileRepositoryProvider)
                            .resetAvatar(uid: widget.uid),
                      ),
                icon: const Icon(Icons.restore),
                label: Text(l10n.profilePhotoGoogle),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

/// Диалог переименования: контроллер живёт в State и уничтожается вместе с диалогом,
/// иначе поле использует уже удалённый контроллер во время анимации закрытия.
class _RenameDialog extends StatefulWidget {
  const _RenameDialog({required this.initial});

  final String initial;

  @override
  State<_RenameDialog> createState() => _RenameDialogState();
}

class _RenameDialogState extends State<_RenameDialog> {
  late final TextEditingController _controller = TextEditingController(
    text: widget.initial,
  );

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return AlertDialog(
      title: Text(l10n.profileEditName),
      content: TextField(
        controller: _controller,
        autofocus: true,
        maxLength: 40,
        decoration: InputDecoration(
          labelText: l10n.profileNameLabel,
          helperText: l10n.profileNameHint,
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(l10n.profileCancel),
        ),
        FilledButton(
          onPressed: () => Navigator.of(context).pop(_controller.text.trim()),
          child: Text(l10n.profileSave),
        ),
      ],
    );
  }
}
