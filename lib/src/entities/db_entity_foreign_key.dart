enum OnDeleteAction {
  cascade('CASCADE'),
  restrict('RESTRICT'),
  setNull('SET NULL'),
  setDefault('SET DEFAULT'),
  noAction('NO ACTION');

  final String toText;
  const OnDeleteAction(this.toText);
}

class ForeignKey<T, F> {
  final String referencedEntity;
  final String referencedColumn;
  final Map<String, Object?> Function(dynamic entity)? updateReference;
  final OnDeleteAction onDeleteAction;

  ForeignKey({
    required this.referencedEntity,
    required this.referencedColumn,
    this.updateReference,
    this.onDeleteAction = OnDeleteAction.noAction,
  });

  String getReferencesQuery() =>
      'SELECT * FROM $referencedEntity WHERE $referencedColumn = ?';

  String get entityKey => T.toString();
  String get referencedEntityKey => F.toString();
}
