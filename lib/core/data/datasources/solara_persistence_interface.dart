import '../../resources/solara_io_exception.dart';

abstract interface class SolaraPersistenceInterface {
  /// The name of the storage.
  String get storageName;

  /// Initialize the storage service.
  Future<(bool, SolaraIOException?)> init();

  /// Read from the storage device.
  Future<(dynamic, SolaraIOException?)> readAll();

  /// Write to the storage device.
  Future<(bool, SolaraIOException?)> write(String key, dynamic value);

  /// Clear all data from the storage device.
  Future<(bool, SolaraIOException?)> clearAll();
}
