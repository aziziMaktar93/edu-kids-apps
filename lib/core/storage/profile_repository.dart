import 'package:hive/hive.dart';
import '../models/profile_state.dart';

class ProfileRepository {
  static const _boxName = 'profile_box';
  static const _key = 'profile';

  late Box _box;

  Future<void> init() async {
    _box = await Hive.openBox(_boxName);
  }

  ProfileState load() {
    final raw = _box.get(_key);
    if (raw == null) return ProfileState.initial();
    return ProfileState.fromMap(raw as Map);
  }

  Future<void> save(ProfileState state) => _box.put(_key, state.toMap());
}
