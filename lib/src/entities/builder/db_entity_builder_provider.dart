import 'package:entify/src/entities/builder/db_entity_builder.dart';

class DbEntityBuilderProvider {
  DefaultDbEntityBuilder<T> getDefaultDbEntityBuilder<T>() {
    return DefaultDbEntityBuilder<T>();
  }

  SimpleEntityBuilder<T> getSimpleEntityBuilder<T>() {
    return SimpleEntityBuilder<T>();
  }
}
