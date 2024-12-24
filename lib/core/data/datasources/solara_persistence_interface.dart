import 'package:solara/core/resources/solara_io_exception.dart';

abstract interface class SolaraPersistenceInterface {
  /// The name of the storage.
  String get storageName;

  /// Initialize the storage service.
  Future<(bool, SolaraIOException?)> init();

  /// Read from the storage device.
  Future<(dynamic, SolaraIOException?)> readAll();

  /// Write to the storage device.
  Future<(bool, SolaraIOException?)> write(String key, dynamic value);

  /// Delete from the storage device.
  Future<(bool, SolaraIOException?)> delete(String key);

  /// Clear storage device.
  Future<(bool, SolaraIOException?)> clear();
}
