import 'package:dart_class_mapper/dart_class_mapper.dart';

class GetDbEntityMap<T> {
  T from<R>(R value) => GetMapper<T, R>().value(value);
  List<T> fromList<R>(Iterable<R> value) =>
      GetMapper<T, R>().list(value.toList());
}
