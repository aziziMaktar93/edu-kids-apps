/// The child's selected age band, chosen once on `/age-select` and then
/// persisted on [ProfileState] so the choice actually has an effect (see
/// `lib/core/router/app_router.dart`'s redirect) instead of being forgotten
/// on every cold start.
enum AgeGroup { prasekolah, tahapSatu, tahapDua }
