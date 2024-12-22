/// The parameter(s) used when making requests to the backend.
class FetchParams {
  const FetchParams({
    this.date,
  });

  /// Date of requested data.
  final DateTime? date;

  /// Utility method to make copies of objects of this type.
  ///
  /// If further parameters are added there may be cases where it is useful to
  /// duplicate objects of this type to only update some of the parameters.
  FetchParams copyWith({DateTime? date}) => FetchParams(
        date: date ?? this.date,
      );
}
