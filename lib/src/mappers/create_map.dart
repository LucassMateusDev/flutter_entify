import 'mapper_register.dart';

class CreateMap<E, D> {
  CreateMap.entityToDto(D Function(E) mapping) {
    MapperRegister.i.toDTO<E, D>(mapping);
  }

  CreateMap.dtoToEntity(E Function(D) mapping) {
    MapperRegister.i.toEntity<D, E>(mapping);
  }
}