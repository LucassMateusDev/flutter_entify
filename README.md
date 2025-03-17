<!--
This README describes the package. If you publish this package to pub.dev,
this README's contents appear on the landing page for your package.

For information about how to write a good package README, see the guide for
[writing package pages](https://dart.dev/tools/pub/writing-package-pages).

For general information about developing packages, see the Dart guide for
[creating packages](https://dart.dev/guides/libraries/create-packages)
and the Flutter guide for
[developing packages and plugins](https://flutter.dev/to/develop-packages).
-->
# Entify

Entify é um package baseado no .NET Entity Framework, com ele é possível de forma simplificada criar um banco de dados, mapear entidades para o banco de dados e executar queries. Além disso fornece suporte para transações e migrations e classes auxiliares para realizar operações de CRUD.

## 🚀 **Features**

- ### 🛠️ **Operações CRUD** simplificadas.
- ### 🔎 **Helpers para execução de queries** SQL.
- ### 🔄 **Criação de mapeamentos entre classes** e suas tabelas no banco.
- ### 🔁 **Suporte a transações** para garantir a integridade dos dados.
- ### 📜 **Migrations** para versionamento do banco de dados.
- ### ⚡ **AutoMigrations** para atualização automática do esquema do banco.

---

## 📌 **Instalação**

Adicione o **Entify** ao seu projeto usando o **pub.dev**:

```sh
flutter pub add flite_entity
```

ou no pubspec.yaml:

```sh
dependencies:
  flite_entity: ^1.0.0
```

---

## Getting started

Antes de usar o Entify, é necessário configurar as entidades e o DbContext, que será responsável pela comunicação com o banco de dados.

## 1️⃣ Criando uma Entidade

Primeiro, defina sua entidade de domínio:

```dart
class Example {
    int id;
    String name;

  Example({required this.id, required this.name});  
}
```
## 2️⃣ Criando a Definição da Entidade (DbEntity)


**✅ Opção 1: Criando um DbEntity manualmente**

**📌 Se você não for usar AutoMigrations, não precisa fornecer as Columns.**
```dart
class DataBaseEntities {
  static DbEntity<Example> get example => DbEntity<Example>(
        name: 'Example',
        mapToEntity: (map) => Example(id: map['id'] as int, name: map['name'] as String),
        toUpdateOrInsert: (e) => {'id': e.id, 'name': e.name},
        primaryKey: (e) => {'id': e.id},
        columns: [
          IntColumn(name: 'id', isPrimaryKey: true, isNullable: false),
          TextColumn(name: 'name', isNullable: false),
        ],
      );
}
```

**✅ Opção 2: Usando DbEntityProvider**
```dart
class ExampleDbEntity extends DbEntityProvider<Example> {
  @override
  DbEntity<Example> get entity => super
          .builder
          .name('Example')
          .mapToEntity((map) => Example(id: map['id'] as int, name: map['name'] as String))
          .toUpdateOrInsert((e) => {'id': e.id, 'name': e.name})
          .primaryKey((e) => {'id': e.id})
          .columns(
        [
          IntColumn(name: 'id', isPrimaryKey: true, isNullable: false),
          TextColumn(name: 'name', isNullable: false),
        ],
      ).build();
}

```


## 3️⃣ Criando o DbContext

Para configurar o banco de dados e gerenciar entidades, crie uma classe que estenda DbContext. Isso permitirá definir os DbSets e sobrescrever o método onConfiguring para configurar a conexão e o comportamento do banco.
```dart
class AppDbContext extends DbContext {
  final example = DbSet<Example>();


  @override
  List<DbSet> get dbSets => [example];


  @override
  void onConfiguring(DbContextOptionsBuilder optionsBuilder) {
    optionsBuilder
        .databaseName('example')
        .version(1)
        .entities([ExampleDbEntity().entity])
        //.migrations([MigrationV1()]); // Para usar migrations manuais, descomente esta linha
        .withAutoMigrations();
    super.onConfiguring(optionsBuilder);
  }
}
```

## 📝 Migrations

Se não quiser usar AutoMigrations, crie uma classe de migration para cada versão do banco.
```dart
class MigrationV1 implements IMigration {
  @override
  void create(Batch batch) {
    batch.execute('''
      CREATE TABLE Example (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL
      );
    ''');
  }

  @override
  void update(Batch batch) {}
}
```

## 📌 Uso (CRUD Básico)

**Antes de realizar operações no banco de dados, inicialize o DbContext:**

```dart
final dbContext = AppDbContext();
await dbContext.initialize();
```
### 📝 Criação (INSERT)
```dart
// Criação de um novo registro
final example = Example(id: -1, name: 'example');
final insertedId = await dbContext.example.insertAsync(example);
example.id = insertedId;
```
### ✏️ Atualização (UPDATE)

```dart
// Atualização
example.name = 'Updated name';
await dbContext.example.updateAsync(example);
```

### 🔍 Consulta (SELECT)
```dart
// Busca um registro específico pela entidade
await dbContext.example.selectAsync(example);

// Busca o primeiro registro que atenda à condição
await dbContext.roles.findFirstOrNull('id = ?', [insertedId]);

// Retorna todos os registros da tabela
await dbContext.roles.findAll();
```

### 🗑️ Remoção (DELETE)
```dart
//Remove a entidade do banco de dados
dbContext.example.deleteAsync(example);
```

**📌 Exemplos de uso com transações estão disponíveis na aba Example.**
