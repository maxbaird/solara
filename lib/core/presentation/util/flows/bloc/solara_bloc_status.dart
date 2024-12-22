/// Represents the current state of a BLoc.
///
/// Commonly used to determine what should be displayed to the user.
enum SolaraBlocStatus {
  /// Bloc is in its initial state when widget is initially loaded.
  initial,

  /// Set if bloc successfully handled event.
  success,

  /// Set if bloc encountered errors when handling an event.
  failure,

  /// Set if bloc is currently handling event.
  inProgress,

  /// Set if bloc was expected to fetch data but the result was empty with no
  /// error.
  noData,
}
