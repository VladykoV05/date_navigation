// Account controller provider lives in presentation (Notifier).
// Keep this file as a stable DI barrel entry without importing presentation.
export '../presentation/controllers/account_controller.dart'
    show accountControllerProvider, AccountController;
