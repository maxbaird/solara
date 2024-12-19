class FetchParams {
  const FetchParams({
    this.date,
  });

  final DateTime? date;

  FetchParams copyWith({DateTime? date}) => FetchParams(
        date: date ?? this.date,
      );
}
