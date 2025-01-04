import 'mapper_register.dart';

class MapperService {
  final _register = MapperRegister.i;

  Entity toEntity<Entity, DTO>(DTO dto) {
    final key = _register.getMappingKey<DTO, Entity>();

    final mapping = _register.toEntityMappings[key] as Entity Function(DTO)?;

    if (mapping == null) {
      throw Exception('No mapping registered for $DTO to $Entity');
    }

    return mapping(dto);
  }

  DTO toDTO<DTO, Entity>(Entity entity) {
    final key = _register.getMappingKey<Entity, DTO>();

    final mapping = _register.toDTOMappings[key] as DTO Function(Entity)?;

    if (mapping == null) {
      throw Exception('No mapping registered for $Entity to $DTO');
    }

    return mapping(entity);
  }
  
}