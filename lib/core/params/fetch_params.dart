class FetchParams {
  const FetchParams({
    this.finder,
  });

  final String? finder;

  FetchParams copyWith({String? finder}) => FetchParams(
        finder: finder ?? this.finder,
      );
}
