import 'address_memory_repository.dart';
import 'favorites_repository.dart';
import 'meeting_history_repository.dart';

abstract interface class UserProfileRepository
    implements
        FavoritesRepository,
        MeetingHistoryRepository,
        AddressMemoryRepository {}
