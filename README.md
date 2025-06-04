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
<div align="center">
  <img src="example/assets/images/logo.png" alt="Logo" width="300"/>
</div>


flutter_entify é um package baseado no .NET Entity Framework, com ele é possível de forma simplificada criar um banco de dados, mapear entidades para o banco de dados e executar queries. Além disso fornece suporte para transações e migrations e classes auxiliares para realizar operações de CRUD.

## 🚀 **Features**

- ### 🛠️ **Operações CRUD** simplificadas.
- ### 🔎 **Helpers para execução de queries** SQL.
- ### 🔄 **Criação de mapeamentos entre classes** e suas tabelas no banco.
- ### 🔁 **Suporte a transações** para garantir a integridade dos dados.
- ### 📜 **Migrations** para versionamento do banco de dados.
- ### ⚡ **AutoMigrations** para atualização automática do esquema do banco.

---

## 📌 **Instalação**

Adicione o **flutter_entify** ao seu projeto usando o **pub.dev**:

```sh
flutter pub add flutter_entify
```

ou no pubspec.yaml:

```sh
dependencies:
  flutter_entify: ^0.0.1
```

---

## Getting started

Antes de usar o flutter_entify, é necessário configurar o DbContext, que será responsável pela comunicação com o banco de dados.

## 1️⃣ Criando uma Entidade

Primeiro, defina sua entidade de domínio:

```dart
class Example {
    int id;
    String name;

  Example({required this.id, required this.name});  
}
```

## 2️⃣ Criando o DbContext

Para configurar o banco de dados e gerenciar entidades, crie uma classe que estenda DbContext. Isso permitirá definir os DbSets e sobrescrever os métodos onConfiguring para configurar a conexão e o comportamento do banco e configureEntites para declarar as entidades do banco.
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
        //.migrations([MigrationV1()]); // Para usar migrations manuais, descomente esta linha
        .withAutoMigrations();
    super.onConfiguring(optionsBuilder);
  }

  @override
  List<DbEntity> configureEntites(DbEntityBuilderProvider provider) => [
        provider
            .getDefaultDbEntityBuilder<Example>()
            //Se você quiser alterar o nome da tabela, por padrão será o nome da entidade
            //.name('example_table')
            .mapToEntity((map) =>Example(id: map['id'] as int, name: map['name'] as String))
            .toUpdateOrInsert((e) => {'id': e.id, 'name': e.name})
            .primaryKey((e) => {'id': e.id})
            .columns(
          [
            IntColumn(name: 'id', isPrimaryKey: true, isNullable: false),
            TextColumn(name: 'name', isNullable: false),
          ],
        ).build()
      ];
}
```

## 📝 Migrations

Se não quiser usar AutoMigrations, crie uma classe de migration para cada versão do banco.
```dart
class MigrationV1 extends CreateMigration {
  @override
  void execute(BatchSchemaExecutor executor) {
    executor.execute('''
      CREATE TABLE Example (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL
      );
    ''');
  }
}

class MigrationV2 extends UpdateMigration {
  @override
  int get version => 2;

  @override
  void execute(BatchSchemaExecutor executor) {
    executor.execute('''
      CREATE TABLE Example2 (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        description TEXT NOT NULL
      );
    ''');
  }
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

### 📌 Exemplos de uso com transações estão disponíveis na aba Example.

### 🚀 Próximos Updates
- ### 🔗 Relacionamento entre entidades
- ### ✨ Geração automática das EntityDefinition do DbContext
- ### 🔍🛢️ Database inspector extension para visualização do banco de dados
