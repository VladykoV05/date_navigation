import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

Future<void> showJoinRoomDialog({
  required BuildContext context,
  required void Function(String code) onJoinCode,
}) async {
  await showDialog<void>(
    context: context,
    builder: (_) => _JoinRoomDialog(onJoinCode: onJoinCode),
  );
}

class _JoinRoomDialog extends StatefulWidget {
  const _JoinRoomDialog({required this.onJoinCode});

  final void Function(String code) onJoinCode;

  @override
  State<_JoinRoomDialog> createState() => _JoinRoomDialogState();
}

class _JoinRoomDialogState extends State<_JoinRoomDialog> {
  final _controller = TextEditingController();

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
    return AlertDialog(
      title: const Text('Введите код'),
      content: TextField(
        controller: _controller,
        keyboardType: TextInputType.number,
        textInputAction: TextInputAction.done,
        maxLength: 4,
        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
        autofocus: true,
        decoration: const InputDecoration(
          labelText: 'Код комнаты',
          hintText: '4 цифры, например 1234',
          helperText: 'Введите код, который отправил партнер',
          counterText: '',
        ),
        onSubmitted: (_) => _submitCode(),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Отмена'),
        ),
        ElevatedButton(onPressed: _submitCode, child: const Text('Войти')),
      ],
    );
  }
}
