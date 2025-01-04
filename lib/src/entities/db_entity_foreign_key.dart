enum OnDeleteAction {
  cascade('CASCADE'),
  restrict('RESTRICT'),
  setNull('SET NULL'),
  setDefault('SET DEFAULT'),
  noAction('NO ACTION');

  final String toText;
  const OnDeleteAction(this.toText);
}

class ForeignKey {
  final String referencedEntity;
  final String referencedColumn;
  final OnDeleteAction onDeleteAction;

  ForeignKey({
    required this.referencedEntity,
    required this.referencedColumn,
    this.onDeleteAction = OnDeleteAction.noAction,
  });
}
