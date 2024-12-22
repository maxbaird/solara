/// The interface all usecases must implement.
///
/// Ensures consistency among use cases. They each must return a particular
/// [Type], a [call] method and accept [Params].
abstract class UseCase<Type, Params> {
  Future<Type> call({required Params params});
}
