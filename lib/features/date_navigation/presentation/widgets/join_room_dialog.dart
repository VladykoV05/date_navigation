import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../../core/l10n/l10n_extensions.dart';

Future<void> showJoinRoomDialog({
  required BuildContext context,
  required void Function(String code) onJoinCode,
  String? initialCode,
}) async {
  await showDialog<void>(
    context: context,
    builder: (_) =>
        _JoinRoomDialog(onJoinCode: onJoinCode, initialCode: initialCode),
  );
}

class _JoinRoomDialog extends StatefulWidget {
  const _JoinRoomDialog({required this.onJoinCode, this.initialCode});

  final void Function(String code) onJoinCode;
  final String? initialCode;

  @override
  State<_JoinRoomDialog> createState() => _JoinRoomDialogState();
}

class _JoinRoomDialogState extends State<_JoinRoomDialog> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.initialCode ?? '');
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _submitCode() {
    final code = _controller.text.trim();
    if (code.length != 4) return;
    widget.onJoinCode(code);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return AlertDialog(
      title: Text(l10n.joinRoomTitle),
      content: TextField(
        controller: _controller,
        keyboardType: TextInputType.number,
        textInputAction: TextInputAction.done,
        maxLength: 4,
        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
        autofocus: true,
        decoration: InputDecoration(
          labelText: l10n.joinRoomCodeLabel,
          hintText: l10n.joinRoomCodeHint,
          helperText: l10n.joinRoomCodeHelper,
          counterText: '',
        ),
        onSubmitted: (_) => _submitCode(),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text(l10n.cancelLabel),
        ),
        ElevatedButton(
          onPressed: _submitCode,
          child: Text(l10n.joinRoomSubmit),
        ),
      ],
    );
  }
}
