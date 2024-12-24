import '../../resources/solara_io_exception.dart';

/// The set of operations that must be adhered to for persistence on the device.
abstract interface class SolaraPersistenceInterface {
  /// {@template solara.core.data.datasources.SolaraPersistenceInterface.storageName}
  /// The name of the storage location.
  /// {@endtemplate}
  String get storageName;

  /// {@template solara.core.data.datasources.SolaraPersistenceInterface.init}
  /// Initialize the storage service.
  /// {@endtemplate}
  Future<(bool, SolaraIOException?)> init();

  /// {@template solara.core.data.datasources.SolaraPersistenceInterface.readAll}
  /// Read from the storage device.
  /// {@endtemplate}
  Future<(dynamic, SolaraIOException?)> readAll();

  /// {@template solara.core.data.datasources.SolaraPersistenceInterface.write}
  /// Write to the storage device.
  /// {@endtemplate}
  Future<(bool, SolaraIOException?)> write(String key, dynamic value);

  /// {@template solara.core.data.datasources.SolaraPersistenceInterface.clearAll}
  /// Clear all data from the storage device.
  /// {@endtemplate}
  Future<(bool, SolaraIOException?)> clearAll();
}
