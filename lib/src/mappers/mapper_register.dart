class MapperRegister {
  static MapperRegister? _instance = MapperRegister._();

  static MapperRegister get i {
    _instance ??= MapperRegister._();
    return _instance!;
  }

  MapperRegister._();

  final Map<String, Function> _toEntityMappings = {};
  final Map<String, Function> _toDTOMappings = {};

  Map<String, Function> get toEntityMappings => _toEntityMappings;
  Map<String, Function> get toDTOMappings => _toDTOMappings;


  void toEntity<DTO, Entity>(Entity Function(DTO dto) mapping) {
    final key = getMappingKey<DTO, Entity>();

    if (_toEntityMappings.containsKey(key)) {
      throw Exception('Mapping already registered for $DTO to $Entity');
    }

    _toEntityMappings[key] = mapping;
  }

  void toDTO<Entity, DTO>(DTO Function(Entity entity) mapping) {
    final key = getMappingKey<Entity, DTO>();

    if (_toDTOMappings.containsKey(key)) {
      throw Exception('Mapping already registered for $Entity to $DTO');
    }

    _toDTOMappings[key] = mapping;
  }
  // ignore: unnecessary_brace_in_string_interps
  String getMappingKey<T, R>() => '${T}_${R}';
}



