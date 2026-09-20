// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
mixin _$WalletDaoMixin on DatabaseAccessor<AppDatabase> {
  $WalletsTable get wallets => attachedDatabase.wallets;
  $WalletMembersTable get walletMembers => attachedDatabase.walletMembers;
  $WalletInvitationsTable get walletInvitations =>
      attachedDatabase.walletInvitations;
  $WalletSettlementsTable get walletSettlements =>
      attachedDatabase.walletSettlements;
  $WalletExpenseSplitsTable get walletExpenseSplits =>
      attachedDatabase.walletExpenseSplits;
  $WalletExpenseSplitMembersTable get walletExpenseSplitMembers =>
      attachedDatabase.walletExpenseSplitMembers;
  $PeerDebtsTable get peerDebts => attachedDatabase.peerDebts;
  $TransactionsTable get transactions => attachedDatabase.transactions;
  $WalletActivitiesTable get walletActivities =>
      attachedDatabase.walletActivities;
  WalletDaoManager get managers => WalletDaoManager(this);
}

class WalletDaoManager {
  final _$WalletDaoMixin _db;
  WalletDaoManager(this._db);
  $$WalletsTableTableManager get wallets =>
      $$WalletsTableTableManager(_db.attachedDatabase, _db.wallets);
  $$WalletMembersTableTableManager get walletMembers =>
      $$WalletMembersTableTableManager(_db.attachedDatabase, _db.walletMembers);
  $$WalletInvitationsTableTableManager get walletInvitations =>
      $$WalletInvitationsTableTableManager(
        _db.attachedDatabase,
        _db.walletInvitations,
      );
  $$WalletSettlementsTableTableManager get walletSettlements =>
      $$WalletSettlementsTableTableManager(
        _db.attachedDatabase,
        _db.walletSettlements,
      );
  $$WalletExpenseSplitsTableTableManager get walletExpenseSplits =>
      $$WalletExpenseSplitsTableTableManager(
        _db.attachedDatabase,
        _db.walletExpenseSplits,
      );
  $$WalletExpenseSplitMembersTableTableManager get walletExpenseSplitMembers =>
      $$WalletExpenseSplitMembersTableTableManager(
        _db.attachedDatabase,
        _db.walletExpenseSplitMembers,
      );
  $$PeerDebtsTableTableManager get peerDebts =>
      $$PeerDebtsTableTableManager(_db.attachedDatabase, _db.peerDebts);
  $$TransactionsTableTableManager get transactions =>
      $$TransactionsTableTableManager(_db.attachedDatabase, _db.transactions);
  $$WalletActivitiesTableTableManager get walletActivities =>
      $$WalletActivitiesTableTableManager(
        _db.attachedDatabase,
        _db.walletActivities,
      );
}

mixin _$PayeeDaoMixin on DatabaseAccessor<AppDatabase> {
  $TagsTable get tags => attachedDatabase.tags;
  $TransactionsTable get transactions => attachedDatabase.transactions;
  PayeeDaoManager get managers => PayeeDaoManager(this);
}

class PayeeDaoManager {
  final _$PayeeDaoMixin _db;
  PayeeDaoManager(this._db);
  $$TagsTableTableManager get tags =>
      $$TagsTableTableManager(_db.attachedDatabase, _db.tags);
  $$TransactionsTableTableManager get transactions =>
      $$TransactionsTableTableManager(_db.attachedDatabase, _db.transactions);
}

mixin _$TransactionTagDaoMixin on DatabaseAccessor<AppDatabase> {
  $TagsTable get tags => attachedDatabase.tags;
  TransactionTagDaoManager get managers => TransactionTagDaoManager(this);
}

class TransactionTagDaoManager {
  final _$TransactionTagDaoMixin _db;
  TransactionTagDaoManager(this._db);
  $$TagsTableTableManager get tags =>
      $$TagsTableTableManager(_db.attachedDatabase, _db.tags);
}

mixin _$AttachmentDaoMixin on DatabaseAccessor<AppDatabase> {
  $AttachmentsTable get attachments => attachedDatabase.attachments;
  $TransactionsTable get transactions => attachedDatabase.transactions;
  AttachmentDaoManager get managers => AttachmentDaoManager(this);
}

class AttachmentDaoManager {
  final _$AttachmentDaoMixin _db;
  AttachmentDaoManager(this._db);
  $$AttachmentsTableTableManager get attachments =>
      $$AttachmentsTableTableManager(_db.attachedDatabase, _db.attachments);
  $$TransactionsTableTableManager get transactions =>
      $$TransactionsTableTableManager(_db.attachedDatabase, _db.transactions);
}

mixin _$UserDaoMixin on DatabaseAccessor<AppDatabase> {
  $UsersTable get users => attachedDatabase.users;
  UserDaoManager get managers => UserDaoManager(this);
}

class UserDaoManager {
  final _$UserDaoMixin _db;
  UserDaoManager(this._db);
  $$UsersTableTableManager get users =>
      $$UsersTableTableManager(_db.attachedDatabase, _db.users);
}

mixin _$AllowanceDaoMixin on DatabaseAccessor<AppDatabase> {
  $WalletAllowancesTable get walletAllowances =>
      attachedDatabase.walletAllowances;
  $WalletAllowancePaymentsTable get walletAllowancePayments =>
      attachedDatabase.walletAllowancePayments;
  AllowanceDaoManager get managers => AllowanceDaoManager(this);
}

class AllowanceDaoManager {
  final _$AllowanceDaoMixin _db;
  AllowanceDaoManager(this._db);
  $$WalletAllowancesTableTableManager get walletAllowances =>
      $$WalletAllowancesTableTableManager(
        _db.attachedDatabase,
        _db.walletAllowances,
      );
  $$WalletAllowancePaymentsTableTableManager get walletAllowancePayments =>
      $$WalletAllowancePaymentsTableTableManager(
        _db.attachedDatabase,
        _db.walletAllowancePayments,
      );
}

mixin _$BillDaoMixin on DatabaseAccessor<AppDatabase> {
  $WalletBillsTable get walletBills => attachedDatabase.walletBills;
  BillDaoManager get managers => BillDaoManager(this);
}

class BillDaoManager {
  final _$BillDaoMixin _db;
  BillDaoManager(this._db);
  $$WalletBillsTableTableManager get walletBills =>
      $$WalletBillsTableTableManager(_db.attachedDatabase, _db.walletBills);
}

mixin _$CategoryDaoMixin on DatabaseAccessor<AppDatabase> {
  $CategoriesTable get categories => attachedDatabase.categories;
  $AccountsTable get accounts => attachedDatabase.accounts;
  $TransactionsTable get transactions => attachedDatabase.transactions;
  $BudgetsTable get budgets => attachedDatabase.budgets;
  $RecurringTransactionsTable get recurringTransactions =>
      attachedDatabase.recurringTransactions;
  CategoryDaoManager get managers => CategoryDaoManager(this);
}

class CategoryDaoManager {
  final _$CategoryDaoMixin _db;
  CategoryDaoManager(this._db);
  $$CategoriesTableTableManager get categories =>
      $$CategoriesTableTableManager(_db.attachedDatabase, _db.categories);
  $$AccountsTableTableManager get accounts =>
      $$AccountsTableTableManager(_db.attachedDatabase, _db.accounts);
  $$TransactionsTableTableManager get transactions =>
      $$TransactionsTableTableManager(_db.attachedDatabase, _db.transactions);
  $$BudgetsTableTableManager get budgets =>
      $$BudgetsTableTableManager(_db.attachedDatabase, _db.budgets);
  $$RecurringTransactionsTableTableManager get recurringTransactions =>
      $$RecurringTransactionsTableTableManager(
        _db.attachedDatabase,
        _db.recurringTransactions,
      );
}

mixin _$AccountDaoMixin on DatabaseAccessor<AppDatabase> {
  $CategoriesTable get categories => attachedDatabase.categories;
  $AccountsTable get accounts => attachedDatabase.accounts;
  $TransactionsTable get transactions => attachedDatabase.transactions;
  $BudgetsTable get budgets => attachedDatabase.budgets;
  $RecurringTransactionsTable get recurringTransactions =>
      attachedDatabase.recurringTransactions;
  AccountDaoManager get managers => AccountDaoManager(this);
}

class AccountDaoManager {
  final _$AccountDaoMixin _db;
  AccountDaoManager(this._db);
  $$CategoriesTableTableManager get categories =>
      $$CategoriesTableTableManager(_db.attachedDatabase, _db.categories);
  $$AccountsTableTableManager get accounts =>
      $$AccountsTableTableManager(_db.attachedDatabase, _db.accounts);
  $$TransactionsTableTableManager get transactions =>
      $$TransactionsTableTableManager(_db.attachedDatabase, _db.transactions);
  $$BudgetsTableTableManager get budgets =>
      $$BudgetsTableTableManager(_db.attachedDatabase, _db.budgets);
  $$RecurringTransactionsTableTableManager get recurringTransactions =>
      $$RecurringTransactionsTableTableManager(
        _db.attachedDatabase,
        _db.recurringTransactions,
      );
}

mixin _$TransactionDaoMixin on DatabaseAccessor<AppDatabase> {
  $CategoriesTable get categories => attachedDatabase.categories;
  $AccountsTable get accounts => attachedDatabase.accounts;
  $TransactionsTable get transactions => attachedDatabase.transactions;
  $BudgetsTable get budgets => attachedDatabase.budgets;
  $RecurringTransactionsTable get recurringTransactions =>
      attachedDatabase.recurringTransactions;
  TransactionDaoManager get managers => TransactionDaoManager(this);
}

class TransactionDaoManager {
  final _$TransactionDaoMixin _db;
  TransactionDaoManager(this._db);
  $$CategoriesTableTableManager get categories =>
      $$CategoriesTableTableManager(_db.attachedDatabase, _db.categories);
  $$AccountsTableTableManager get accounts =>
      $$AccountsTableTableManager(_db.attachedDatabase, _db.accounts);
  $$TransactionsTableTableManager get transactions =>
      $$TransactionsTableTableManager(_db.attachedDatabase, _db.transactions);
  $$BudgetsTableTableManager get budgets =>
      $$BudgetsTableTableManager(_db.attachedDatabase, _db.budgets);
  $$RecurringTransactionsTableTableManager get recurringTransactions =>
      $$RecurringTransactionsTableTableManager(
        _db.attachedDatabase,
        _db.recurringTransactions,
      );
}

mixin _$BudgetDaoMixin on DatabaseAccessor<AppDatabase> {
  $CategoriesTable get categories => attachedDatabase.categories;
  $AccountsTable get accounts => attachedDatabase.accounts;
  $TransactionsTable get transactions => attachedDatabase.transactions;
  $BudgetsTable get budgets => attachedDatabase.budgets;
  $RecurringTransactionsTable get recurringTransactions =>
      attachedDatabase.recurringTransactions;
  BudgetDaoManager get managers => BudgetDaoManager(this);
}

class BudgetDaoManager {
  final _$BudgetDaoMixin _db;
  BudgetDaoManager(this._db);
  $$CategoriesTableTableManager get categories =>
      $$CategoriesTableTableManager(_db.attachedDatabase, _db.categories);
  $$AccountsTableTableManager get accounts =>
      $$AccountsTableTableManager(_db.attachedDatabase, _db.accounts);
  $$TransactionsTableTableManager get transactions =>
      $$TransactionsTableTableManager(_db.attachedDatabase, _db.transactions);
  $$BudgetsTableTableManager get budgets =>
      $$BudgetsTableTableManager(_db.attachedDatabase, _db.budgets);
  $$RecurringTransactionsTableTableManager get recurringTransactions =>
      $$RecurringTransactionsTableTableManager(
        _db.attachedDatabase,
        _db.recurringTransactions,
      );
}

mixin _$RecurringTransactionDaoMixin on DatabaseAccessor<AppDatabase> {
  $CategoriesTable get categories => attachedDatabase.categories;
  $AccountsTable get accounts => attachedDatabase.accounts;
  $TransactionsTable get transactions => attachedDatabase.transactions;
  $BudgetsTable get budgets => attachedDatabase.budgets;
  $RecurringTransactionsTable get recurringTransactions =>
      attachedDatabase.recurringTransactions;
  RecurringTransactionDaoManager get managers =>
      RecurringTransactionDaoManager(this);
}

class RecurringTransactionDaoManager {
  final _$RecurringTransactionDaoMixin _db;
  RecurringTransactionDaoManager(this._db);
  $$CategoriesTableTableManager get categories =>
      $$CategoriesTableTableManager(_db.attachedDatabase, _db.categories);
  $$AccountsTableTableManager get accounts =>
      $$AccountsTableTableManager(_db.attachedDatabase, _db.accounts);
  $$TransactionsTableTableManager get transactions =>
      $$TransactionsTableTableManager(_db.attachedDatabase, _db.transactions);
  $$BudgetsTableTableManager get budgets =>
      $$BudgetsTableTableManager(_db.attachedDatabase, _db.budgets);
  $$RecurringTransactionsTableTableManager get recurringTransactions =>
      $$RecurringTransactionsTableTableManager(
        _db.attachedDatabase,
        _db.recurringTransactions,
      );
}

class $AccountsTable extends Accounts with TableInfo<$AccountsTable, Account> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $AccountsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _walletIdMeta = const VerificationMeta(
    'walletId',
  );
  @override
  late final GeneratedColumn<int> walletId = GeneratedColumn<int>(
    'wallet_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(1),
  );
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _uuidMeta = const VerificationMeta('uuid');
  @override
  late final GeneratedColumn<String> uuid = GeneratedColumn<String>(
    'uuid',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    clientDefault: () => const Uuid().v4(),
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 1,
      maxTextLength: 50,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  late final GeneratedColumnWithTypeConverter<AccountType, String> type =
      GeneratedColumn<String>(
        'type',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      ).withConverter<AccountType>($AccountsTable.$convertertype);
  static const VerificationMeta _iconMeta = const VerificationMeta('icon');
  @override
  late final GeneratedColumn<int> icon = GeneratedColumn<int>(
    'icon',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _colorMeta = const VerificationMeta('color');
  @override
  late final GeneratedColumn<String> color = GeneratedColumn<String>(
    'color',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  late final GeneratedColumnWithTypeConverter<double, int> openingBalance =
      GeneratedColumn<int>(
        'opening_balance',
        aliasedName,
        false,
        type: DriftSqlType.int,
        requiredDuringInsert: false,
        defaultValue: const Constant(0),
      ).withConverter<double>($AccountsTable.$converteropeningBalance);
  static const VerificationMeta _isDefaultMeta = const VerificationMeta(
    'isDefault',
  );
  @override
  late final GeneratedColumn<bool> isDefault = GeneratedColumn<bool>(
    'is_default',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_default" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    clientDefault: () => DateTime.now(),
  );
  @override
  List<GeneratedColumn> get $columns => [
    walletId,
    id,
    uuid,
    name,
    type,
    icon,
    color,
    openingBalance,
    isDefault,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'accounts';
  @override
  VerificationContext validateIntegrity(
    Insertable<Account> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('wallet_id')) {
      context.handle(
        _walletIdMeta,
        walletId.isAcceptableOrUnknown(data['wallet_id']!, _walletIdMeta),
      );
    }
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('uuid')) {
      context.handle(
        _uuidMeta,
        uuid.isAcceptableOrUnknown(data['uuid']!, _uuidMeta),
      );
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('icon')) {
      context.handle(
        _iconMeta,
        icon.isAcceptableOrUnknown(data['icon']!, _iconMeta),
      );
    } else if (isInserting) {
      context.missing(_iconMeta);
    }
    if (data.containsKey('color')) {
      context.handle(
        _colorMeta,
        color.isAcceptableOrUnknown(data['color']!, _colorMeta),
      );
    } else if (isInserting) {
      context.missing(_colorMeta);
    }
    if (data.containsKey('is_default')) {
      context.handle(
        _isDefaultMeta,
        isDefault.isAcceptableOrUnknown(data['is_default']!, _isDefaultMeta),
      );
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Account map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Account(
      walletId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}wallet_id'],
      )!,
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      uuid: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}uuid'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      type: $AccountsTable.$convertertype.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}type'],
        )!,
      ),
      icon: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}icon'],
      )!,
      color: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}color'],
      )!,
      openingBalance: $AccountsTable.$converteropeningBalance.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.int,
          data['${effectivePrefix}opening_balance'],
        )!,
      ),
      isDefault: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_default'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $AccountsTable createAlias(String alias) {
    return $AccountsTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<AccountType, String, String> $convertertype =
      const EnumNameConverter(AccountType.values);
  static TypeConverter<double, int> $converteropeningBalance =
      const MoneyConverter();
}

class Account extends DataClass implements Insertable<Account> {
  final int walletId;
  final int id;
  final String uuid;
  final String name;
  final AccountType type;
  final int icon;
  final String color;
  final double openingBalance;
  final bool isDefault;
  final DateTime updatedAt;
  const Account({
    required this.walletId,
    required this.id,
    required this.uuid,
    required this.name,
    required this.type,
    required this.icon,
    required this.color,
    required this.openingBalance,
    required this.isDefault,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['wallet_id'] = Variable<int>(walletId);
    map['id'] = Variable<int>(id);
    map['uuid'] = Variable<String>(uuid);
    map['name'] = Variable<String>(name);
    {
      map['type'] = Variable<String>($AccountsTable.$convertertype.toSql(type));
    }
    map['icon'] = Variable<int>(icon);
    map['color'] = Variable<String>(color);
    {
      map['opening_balance'] = Variable<int>(
        $AccountsTable.$converteropeningBalance.toSql(openingBalance),
      );
    }
    map['is_default'] = Variable<bool>(isDefault);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  AccountsCompanion toCompanion(bool nullToAbsent) {
    return AccountsCompanion(
      walletId: Value(walletId),
      id: Value(id),
      uuid: Value(uuid),
      name: Value(name),
      type: Value(type),
      icon: Value(icon),
      color: Value(color),
      openingBalance: Value(openingBalance),
      isDefault: Value(isDefault),
      updatedAt: Value(updatedAt),
    );
  }

  factory Account.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Account(
      walletId: serializer.fromJson<int>(json['walletId']),
      id: serializer.fromJson<int>(json['id']),
      uuid: serializer.fromJson<String>(json['uuid']),
      name: serializer.fromJson<String>(json['name']),
      type: $AccountsTable.$convertertype.fromJson(
        serializer.fromJson<String>(json['type']),
      ),
      icon: serializer.fromJson<int>(json['icon']),
      color: serializer.fromJson<String>(json['color']),
      openingBalance: serializer.fromJson<double>(json['openingBalance']),
      isDefault: serializer.fromJson<bool>(json['isDefault']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'walletId': serializer.toJson<int>(walletId),
      'id': serializer.toJson<int>(id),
      'uuid': serializer.toJson<String>(uuid),
      'name': serializer.toJson<String>(name),
      'type': serializer.toJson<String>(
        $AccountsTable.$convertertype.toJson(type),
      ),
      'icon': serializer.toJson<int>(icon),
      'color': serializer.toJson<String>(color),
      'openingBalance': serializer.toJson<double>(openingBalance),
      'isDefault': serializer.toJson<bool>(isDefault),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  Account copyWith({
    int? walletId,
    int? id,
    String? uuid,
    String? name,
    AccountType? type,
    int? icon,
    String? color,
    double? openingBalance,
    bool? isDefault,
    DateTime? updatedAt,
  }) => Account(
    walletId: walletId ?? this.walletId,
    id: id ?? this.id,
    uuid: uuid ?? this.uuid,
    name: name ?? this.name,
    type: type ?? this.type,
    icon: icon ?? this.icon,
    color: color ?? this.color,
    openingBalance: openingBalance ?? this.openingBalance,
    isDefault: isDefault ?? this.isDefault,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  Account copyWithCompanion(AccountsCompanion data) {
    return Account(
      walletId: data.walletId.present ? data.walletId.value : this.walletId,
      id: data.id.present ? data.id.value : this.id,
      uuid: data.uuid.present ? data.uuid.value : this.uuid,
      name: data.name.present ? data.name.value : this.name,
      type: data.type.present ? data.type.value : this.type,
      icon: data.icon.present ? data.icon.value : this.icon,
      color: data.color.present ? data.color.value : this.color,
      openingBalance: data.openingBalance.present
          ? data.openingBalance.value
          : this.openingBalance,
      isDefault: data.isDefault.present ? data.isDefault.value : this.isDefault,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Account(')
          ..write('walletId: $walletId, ')
          ..write('id: $id, ')
          ..write('uuid: $uuid, ')
          ..write('name: $name, ')
          ..write('type: $type, ')
          ..write('icon: $icon, ')
          ..write('color: $color, ')
          ..write('openingBalance: $openingBalance, ')
          ..write('isDefault: $isDefault, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    walletId,
    id,
    uuid,
    name,
    type,
    icon,
    color,
    openingBalance,
    isDefault,
    updatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Account &&
          other.walletId == this.walletId &&
          other.id == this.id &&
          other.uuid == this.uuid &&
          other.name == this.name &&
          other.type == this.type &&
          other.icon == this.icon &&
          other.color == this.color &&
          other.openingBalance == this.openingBalance &&
          other.isDefault == this.isDefault &&
          other.updatedAt == this.updatedAt);
}

class AccountsCompanion extends UpdateCompanion<Account> {
  final Value<int> walletId;
  final Value<int> id;
  final Value<String> uuid;
  final Value<String> name;
  final Value<AccountType> type;
  final Value<int> icon;
  final Value<String> color;
  final Value<double> openingBalance;
  final Value<bool> isDefault;
  final Value<DateTime> updatedAt;
  const AccountsCompanion({
    this.walletId = const Value.absent(),
    this.id = const Value.absent(),
    this.uuid = const Value.absent(),
    this.name = const Value.absent(),
    this.type = const Value.absent(),
    this.icon = const Value.absent(),
    this.color = const Value.absent(),
    this.openingBalance = const Value.absent(),
    this.isDefault = const Value.absent(),
    this.updatedAt = const Value.absent(),
  });
  AccountsCompanion.insert({
    this.walletId = const Value.absent(),
    this.id = const Value.absent(),
    this.uuid = const Value.absent(),
    required String name,
    required AccountType type,
    required int icon,
    required String color,
    this.openingBalance = const Value.absent(),
    this.isDefault = const Value.absent(),
    this.updatedAt = const Value.absent(),
  }) : name = Value(name),
       type = Value(type),
       icon = Value(icon),
       color = Value(color);
  static Insertable<Account> custom({
    Expression<int>? walletId,
    Expression<int>? id,
    Expression<String>? uuid,
    Expression<String>? name,
    Expression<String>? type,
    Expression<int>? icon,
    Expression<String>? color,
    Expression<int>? openingBalance,
    Expression<bool>? isDefault,
    Expression<DateTime>? updatedAt,
  }) {
    return RawValuesInsertable({
      if (walletId != null) 'wallet_id': walletId,
      if (id != null) 'id': id,
      if (uuid != null) 'uuid': uuid,
      if (name != null) 'name': name,
      if (type != null) 'type': type,
      if (icon != null) 'icon': icon,
      if (color != null) 'color': color,
      if (openingBalance != null) 'opening_balance': openingBalance,
      if (isDefault != null) 'is_default': isDefault,
      if (updatedAt != null) 'updated_at': updatedAt,
    });
  }

  AccountsCompanion copyWith({
    Value<int>? walletId,
    Value<int>? id,
    Value<String>? uuid,
    Value<String>? name,
    Value<AccountType>? type,
    Value<int>? icon,
    Value<String>? color,
    Value<double>? openingBalance,
    Value<bool>? isDefault,
    Value<DateTime>? updatedAt,
  }) {
    return AccountsCompanion(
      walletId: walletId ?? this.walletId,
      id: id ?? this.id,
      uuid: uuid ?? this.uuid,
      name: name ?? this.name,
      type: type ?? this.type,
      icon: icon ?? this.icon,
      color: color ?? this.color,
      openingBalance: openingBalance ?? this.openingBalance,
      isDefault: isDefault ?? this.isDefault,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (walletId.present) {
      map['wallet_id'] = Variable<int>(walletId.value);
    }
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (uuid.present) {
      map['uuid'] = Variable<String>(uuid.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (type.present) {
      map['type'] = Variable<String>(
        $AccountsTable.$convertertype.toSql(type.value),
      );
    }
    if (icon.present) {
      map['icon'] = Variable<int>(icon.value);
    }
    if (color.present) {
      map['color'] = Variable<String>(color.value);
    }
    if (openingBalance.present) {
      map['opening_balance'] = Variable<int>(
        $AccountsTable.$converteropeningBalance.toSql(openingBalance.value),
      );
    }
    if (isDefault.present) {
      map['is_default'] = Variable<bool>(isDefault.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('AccountsCompanion(')
          ..write('walletId: $walletId, ')
          ..write('id: $id, ')
          ..write('uuid: $uuid, ')
          ..write('name: $name, ')
          ..write('type: $type, ')
          ..write('icon: $icon, ')
          ..write('color: $color, ')
          ..write('openingBalance: $openingBalance, ')
          ..write('isDefault: $isDefault, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }
}

class $WalletBillsTable extends WalletBills
    with TableInfo<$WalletBillsTable, WalletBill> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $WalletBillsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _walletIdMeta = const VerificationMeta(
    'walletId',
  );
  @override
  late final GeneratedColumn<int> walletId = GeneratedColumn<int>(
    'wallet_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 1,
      maxTextLength: 100,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  late final GeneratedColumnWithTypeConverter<double, int> amount =
      GeneratedColumn<int>(
        'amount',
        aliasedName,
        false,
        type: DriftSqlType.int,
        requiredDuringInsert: true,
      ).withConverter<double>($WalletBillsTable.$converteramount);
  static const VerificationMeta _dueDateMeta = const VerificationMeta(
    'dueDate',
  );
  @override
  late final GeneratedColumn<DateTime> dueDate = GeneratedColumn<DateTime>(
    'due_date',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  late final GeneratedColumnWithTypeConverter<WalletBillRecurrence, String>
  recurrence = GeneratedColumn<String>(
    'recurrence',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  ).withConverter<WalletBillRecurrence>($WalletBillsTable.$converterrecurrence);
  static const VerificationMeta _categoryMeta = const VerificationMeta(
    'category',
  );
  @override
  late final GeneratedColumn<String> category = GeneratedColumn<String>(
    'category',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 1,
      maxTextLength: 60,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _notesMeta = const VerificationMeta('notes');
  @override
  late final GeneratedColumn<String> notes = GeneratedColumn<String>(
    'notes',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  late final GeneratedColumnWithTypeConverter<WalletBillStatus, String> status =
      GeneratedColumn<String>(
        'status',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
        defaultValue: const Constant('unpaid'),
      ).withConverter<WalletBillStatus>($WalletBillsTable.$converterstatus);
  static const VerificationMeta _isActiveMeta = const VerificationMeta(
    'isActive',
  );
  @override
  late final GeneratedColumn<bool> isActive = GeneratedColumn<bool>(
    'is_active',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_active" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
  );
  static const VerificationMeta _createdByAccountIdMeta =
      const VerificationMeta('createdByAccountId');
  @override
  late final GeneratedColumn<int> createdByAccountId = GeneratedColumn<int>(
    'created_by_account_id',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _updatedByAccountIdMeta =
      const VerificationMeta('updatedByAccountId');
  @override
  late final GeneratedColumn<int> updatedByAccountId = GeneratedColumn<int>(
    'updated_by_account_id',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    clientDefault: () => DateTime.now(),
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    clientDefault: () => DateTime.now(),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    walletId,
    name,
    amount,
    dueDate,
    recurrence,
    category,
    notes,
    status,
    isActive,
    createdByAccountId,
    updatedByAccountId,
    createdAt,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'wallet_bills';
  @override
  VerificationContext validateIntegrity(
    Insertable<WalletBill> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('wallet_id')) {
      context.handle(
        _walletIdMeta,
        walletId.isAcceptableOrUnknown(data['wallet_id']!, _walletIdMeta),
      );
    } else if (isInserting) {
      context.missing(_walletIdMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('due_date')) {
      context.handle(
        _dueDateMeta,
        dueDate.isAcceptableOrUnknown(data['due_date']!, _dueDateMeta),
      );
    } else if (isInserting) {
      context.missing(_dueDateMeta);
    }
    if (data.containsKey('category')) {
      context.handle(
        _categoryMeta,
        category.isAcceptableOrUnknown(data['category']!, _categoryMeta),
      );
    } else if (isInserting) {
      context.missing(_categoryMeta);
    }
    if (data.containsKey('notes')) {
      context.handle(
        _notesMeta,
        notes.isAcceptableOrUnknown(data['notes']!, _notesMeta),
      );
    }
    if (data.containsKey('is_active')) {
      context.handle(
        _isActiveMeta,
        isActive.isAcceptableOrUnknown(data['is_active']!, _isActiveMeta),
      );
    }
    if (data.containsKey('created_by_account_id')) {
      context.handle(
        _createdByAccountIdMeta,
        createdByAccountId.isAcceptableOrUnknown(
          data['created_by_account_id']!,
          _createdByAccountIdMeta,
        ),
      );
    }
    if (data.containsKey('updated_by_account_id')) {
      context.handle(
        _updatedByAccountIdMeta,
        updatedByAccountId.isAcceptableOrUnknown(
          data['updated_by_account_id']!,
          _updatedByAccountIdMeta,
        ),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  WalletBill map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return WalletBill(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      walletId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}wallet_id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      amount: $WalletBillsTable.$converteramount.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.int,
          data['${effectivePrefix}amount'],
        )!,
      ),
      dueDate: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}due_date'],
      )!,
      recurrence: $WalletBillsTable.$converterrecurrence.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}recurrence'],
        )!,
      ),
      category: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}category'],
      )!,
      notes: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}notes'],
      ),
      status: $WalletBillsTable.$converterstatus.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}status'],
        )!,
      ),
      isActive: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_active'],
      )!,
      createdByAccountId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}created_by_account_id'],
      ),
      updatedByAccountId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}updated_by_account_id'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $WalletBillsTable createAlias(String alias) {
    return $WalletBillsTable(attachedDatabase, alias);
  }

  static TypeConverter<double, int> $converteramount = const MoneyConverter();
  static JsonTypeConverter2<WalletBillRecurrence, String, String>
  $converterrecurrence = const EnumNameConverter(WalletBillRecurrence.values);
  static JsonTypeConverter2<WalletBillStatus, String, String> $converterstatus =
      const EnumNameConverter(WalletBillStatus.values);
}

class WalletBill extends DataClass implements Insertable<WalletBill> {
  final int id;
  final int walletId;
  final String name;
  final double amount;
  final DateTime dueDate;
  final WalletBillRecurrence recurrence;
  final String category;
  final String? notes;
  final WalletBillStatus status;
  final bool isActive;
  final int? createdByAccountId;
  final int? updatedByAccountId;
  final DateTime createdAt;
  final DateTime updatedAt;
  const WalletBill({
    required this.id,
    required this.walletId,
    required this.name,
    required this.amount,
    required this.dueDate,
    required this.recurrence,
    required this.category,
    this.notes,
    required this.status,
    required this.isActive,
    this.createdByAccountId,
    this.updatedByAccountId,
    required this.createdAt,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['wallet_id'] = Variable<int>(walletId);
    map['name'] = Variable<String>(name);
    {
      map['amount'] = Variable<int>(
        $WalletBillsTable.$converteramount.toSql(amount),
      );
    }
    map['due_date'] = Variable<DateTime>(dueDate);
    {
      map['recurrence'] = Variable<String>(
        $WalletBillsTable.$converterrecurrence.toSql(recurrence),
      );
    }
    map['category'] = Variable<String>(category);
    if (!nullToAbsent || notes != null) {
      map['notes'] = Variable<String>(notes);
    }
    {
      map['status'] = Variable<String>(
        $WalletBillsTable.$converterstatus.toSql(status),
      );
    }
    map['is_active'] = Variable<bool>(isActive);
    if (!nullToAbsent || createdByAccountId != null) {
      map['created_by_account_id'] = Variable<int>(createdByAccountId);
    }
    if (!nullToAbsent || updatedByAccountId != null) {
      map['updated_by_account_id'] = Variable<int>(updatedByAccountId);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  WalletBillsCompanion toCompanion(bool nullToAbsent) {
    return WalletBillsCompanion(
      id: Value(id),
      walletId: Value(walletId),
      name: Value(name),
      amount: Value(amount),
      dueDate: Value(dueDate),
      recurrence: Value(recurrence),
      category: Value(category),
      notes: notes == null && nullToAbsent
          ? const Value.absent()
          : Value(notes),
      status: Value(status),
      isActive: Value(isActive),
      createdByAccountId: createdByAccountId == null && nullToAbsent
          ? const Value.absent()
          : Value(createdByAccountId),
      updatedByAccountId: updatedByAccountId == null && nullToAbsent
          ? const Value.absent()
          : Value(updatedByAccountId),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory WalletBill.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return WalletBill(
      id: serializer.fromJson<int>(json['id']),
      walletId: serializer.fromJson<int>(json['walletId']),
      name: serializer.fromJson<String>(json['name']),
      amount: serializer.fromJson<double>(json['amount']),
      dueDate: serializer.fromJson<DateTime>(json['dueDate']),
      recurrence: $WalletBillsTable.$converterrecurrence.fromJson(
        serializer.fromJson<String>(json['recurrence']),
      ),
      category: serializer.fromJson<String>(json['category']),
      notes: serializer.fromJson<String?>(json['notes']),
      status: $WalletBillsTable.$converterstatus.fromJson(
        serializer.fromJson<String>(json['status']),
      ),
      isActive: serializer.fromJson<bool>(json['isActive']),
      createdByAccountId: serializer.fromJson<int?>(json['createdByAccountId']),
      updatedByAccountId: serializer.fromJson<int?>(json['updatedByAccountId']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'walletId': serializer.toJson<int>(walletId),
      'name': serializer.toJson<String>(name),
      'amount': serializer.toJson<double>(amount),
      'dueDate': serializer.toJson<DateTime>(dueDate),
      'recurrence': serializer.toJson<String>(
        $WalletBillsTable.$converterrecurrence.toJson(recurrence),
      ),
      'category': serializer.toJson<String>(category),
      'notes': serializer.toJson<String?>(notes),
      'status': serializer.toJson<String>(
        $WalletBillsTable.$converterstatus.toJson(status),
      ),
      'isActive': serializer.toJson<bool>(isActive),
      'createdByAccountId': serializer.toJson<int?>(createdByAccountId),
      'updatedByAccountId': serializer.toJson<int?>(updatedByAccountId),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  WalletBill copyWith({
    int? id,
    int? walletId,
    String? name,
    double? amount,
    DateTime? dueDate,
    WalletBillRecurrence? recurrence,
    String? category,
    Value<String?> notes = const Value.absent(),
    WalletBillStatus? status,
    bool? isActive,
    Value<int?> createdByAccountId = const Value.absent(),
    Value<int?> updatedByAccountId = const Value.absent(),
    DateTime? createdAt,
    DateTime? updatedAt,
  }) => WalletBill(
    id: id ?? this.id,
    walletId: walletId ?? this.walletId,
    name: name ?? this.name,
    amount: amount ?? this.amount,
    dueDate: dueDate ?? this.dueDate,
    recurrence: recurrence ?? this.recurrence,
    category: category ?? this.category,
    notes: notes.present ? notes.value : this.notes,
    status: status ?? this.status,
    isActive: isActive ?? this.isActive,
    createdByAccountId: createdByAccountId.present
        ? createdByAccountId.value
        : this.createdByAccountId,
    updatedByAccountId: updatedByAccountId.present
        ? updatedByAccountId.value
        : this.updatedByAccountId,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  WalletBill copyWithCompanion(WalletBillsCompanion data) {
    return WalletBill(
      id: data.id.present ? data.id.value : this.id,
      walletId: data.walletId.present ? data.walletId.value : this.walletId,
      name: data.name.present ? data.name.value : this.name,
      amount: data.amount.present ? data.amount.value : this.amount,
      dueDate: data.dueDate.present ? data.dueDate.value : this.dueDate,
      recurrence: data.recurrence.present
          ? data.recurrence.value
          : this.recurrence,
      category: data.category.present ? data.category.value : this.category,
      notes: data.notes.present ? data.notes.value : this.notes,
      status: data.status.present ? data.status.value : this.status,
      isActive: data.isActive.present ? data.isActive.value : this.isActive,
      createdByAccountId: data.createdByAccountId.present
          ? data.createdByAccountId.value
          : this.createdByAccountId,
      updatedByAccountId: data.updatedByAccountId.present
          ? data.updatedByAccountId.value
          : this.updatedByAccountId,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('WalletBill(')
          ..write('id: $id, ')
          ..write('walletId: $walletId, ')
          ..write('name: $name, ')
          ..write('amount: $amount, ')
          ..write('dueDate: $dueDate, ')
          ..write('recurrence: $recurrence, ')
          ..write('category: $category, ')
          ..write('notes: $notes, ')
          ..write('status: $status, ')
          ..write('isActive: $isActive, ')
          ..write('createdByAccountId: $createdByAccountId, ')
          ..write('updatedByAccountId: $updatedByAccountId, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    walletId,
    name,
    amount,
    dueDate,
    recurrence,
    category,
    notes,
    status,
    isActive,
    createdByAccountId,
    updatedByAccountId,
    createdAt,
    updatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is WalletBill &&
          other.id == this.id &&
          other.walletId == this.walletId &&
          other.name == this.name &&
          other.amount == this.amount &&
          other.dueDate == this.dueDate &&
          other.recurrence == this.recurrence &&
          other.category == this.category &&
          other.notes == this.notes &&
          other.status == this.status &&
          other.isActive == this.isActive &&
          other.createdByAccountId == this.createdByAccountId &&
          other.updatedByAccountId == this.updatedByAccountId &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class WalletBillsCompanion extends UpdateCompanion<WalletBill> {
  final Value<int> id;
  final Value<int> walletId;
  final Value<String> name;
  final Value<double> amount;
  final Value<DateTime> dueDate;
  final Value<WalletBillRecurrence> recurrence;
  final Value<String> category;
  final Value<String?> notes;
  final Value<WalletBillStatus> status;
  final Value<bool> isActive;
  final Value<int?> createdByAccountId;
  final Value<int?> updatedByAccountId;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  const WalletBillsCompanion({
    this.id = const Value.absent(),
    this.walletId = const Value.absent(),
    this.name = const Value.absent(),
    this.amount = const Value.absent(),
    this.dueDate = const Value.absent(),
    this.recurrence = const Value.absent(),
    this.category = const Value.absent(),
    this.notes = const Value.absent(),
    this.status = const Value.absent(),
    this.isActive = const Value.absent(),
    this.createdByAccountId = const Value.absent(),
    this.updatedByAccountId = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  });
  WalletBillsCompanion.insert({
    this.id = const Value.absent(),
    required int walletId,
    required String name,
    required double amount,
    required DateTime dueDate,
    required WalletBillRecurrence recurrence,
    required String category,
    this.notes = const Value.absent(),
    this.status = const Value.absent(),
    this.isActive = const Value.absent(),
    this.createdByAccountId = const Value.absent(),
    this.updatedByAccountId = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  }) : walletId = Value(walletId),
       name = Value(name),
       amount = Value(amount),
       dueDate = Value(dueDate),
       recurrence = Value(recurrence),
       category = Value(category);
  static Insertable<WalletBill> custom({
    Expression<int>? id,
    Expression<int>? walletId,
    Expression<String>? name,
    Expression<int>? amount,
    Expression<DateTime>? dueDate,
    Expression<String>? recurrence,
    Expression<String>? category,
    Expression<String>? notes,
    Expression<String>? status,
    Expression<bool>? isActive,
    Expression<int>? createdByAccountId,
    Expression<int>? updatedByAccountId,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (walletId != null) 'wallet_id': walletId,
      if (name != null) 'name': name,
      if (amount != null) 'amount': amount,
      if (dueDate != null) 'due_date': dueDate,
      if (recurrence != null) 'recurrence': recurrence,
      if (category != null) 'category': category,
      if (notes != null) 'notes': notes,
      if (status != null) 'status': status,
      if (isActive != null) 'is_active': isActive,
      if (createdByAccountId != null)
        'created_by_account_id': createdByAccountId,
      if (updatedByAccountId != null)
        'updated_by_account_id': updatedByAccountId,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
    });
  }

  WalletBillsCompanion copyWith({
    Value<int>? id,
    Value<int>? walletId,
    Value<String>? name,
    Value<double>? amount,
    Value<DateTime>? dueDate,
    Value<WalletBillRecurrence>? recurrence,
    Value<String>? category,
    Value<String?>? notes,
    Value<WalletBillStatus>? status,
    Value<bool>? isActive,
    Value<int?>? createdByAccountId,
    Value<int?>? updatedByAccountId,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
  }) {
    return WalletBillsCompanion(
      id: id ?? this.id,
      walletId: walletId ?? this.walletId,
      name: name ?? this.name,
      amount: amount ?? this.amount,
      dueDate: dueDate ?? this.dueDate,
      recurrence: recurrence ?? this.recurrence,
      category: category ?? this.category,
      notes: notes ?? this.notes,
      status: status ?? this.status,
      isActive: isActive ?? this.isActive,
      createdByAccountId: createdByAccountId ?? this.createdByAccountId,
      updatedByAccountId: updatedByAccountId ?? this.updatedByAccountId,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (walletId.present) {
      map['wallet_id'] = Variable<int>(walletId.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (amount.present) {
      map['amount'] = Variable<int>(
        $WalletBillsTable.$converteramount.toSql(amount.value),
      );
    }
    if (dueDate.present) {
      map['due_date'] = Variable<DateTime>(dueDate.value);
    }
    if (recurrence.present) {
      map['recurrence'] = Variable<String>(
        $WalletBillsTable.$converterrecurrence.toSql(recurrence.value),
      );
    }
    if (category.present) {
      map['category'] = Variable<String>(category.value);
    }
    if (notes.present) {
      map['notes'] = Variable<String>(notes.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(
        $WalletBillsTable.$converterstatus.toSql(status.value),
      );
    }
    if (isActive.present) {
      map['is_active'] = Variable<bool>(isActive.value);
    }
    if (createdByAccountId.present) {
      map['created_by_account_id'] = Variable<int>(createdByAccountId.value);
    }
    if (updatedByAccountId.present) {
      map['updated_by_account_id'] = Variable<int>(updatedByAccountId.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('WalletBillsCompanion(')
          ..write('id: $id, ')
          ..write('walletId: $walletId, ')
          ..write('name: $name, ')
          ..write('amount: $amount, ')
          ..write('dueDate: $dueDate, ')
          ..write('recurrence: $recurrence, ')
          ..write('category: $category, ')
          ..write('notes: $notes, ')
          ..write('status: $status, ')
          ..write('isActive: $isActive, ')
          ..write('createdByAccountId: $createdByAccountId, ')
          ..write('updatedByAccountId: $updatedByAccountId, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }
}

class $BudgetsTable extends Budgets with TableInfo<$BudgetsTable, Budget> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $BudgetsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _walletIdMeta = const VerificationMeta(
    'walletId',
  );
  @override
  late final GeneratedColumn<int> walletId = GeneratedColumn<int>(
    'wallet_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(1),
  );
  static const VerificationMeta _uuidMeta = const VerificationMeta('uuid');
  @override
  late final GeneratedColumn<String> uuid = GeneratedColumn<String>(
    'uuid',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    clientDefault: () => const Uuid().v4(),
  );
  @override
  late final GeneratedColumnWithTypeConverter<double, int> amount =
      GeneratedColumn<int>(
        'amount',
        aliasedName,
        false,
        type: DriftSqlType.int,
        requiredDuringInsert: true,
      ).withConverter<double>($BudgetsTable.$converteramount);
  static const VerificationMeta _periodMeta = const VerificationMeta('period');
  @override
  late final GeneratedColumn<String> period = GeneratedColumn<String>(
    'period',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _categoryIdMeta = const VerificationMeta(
    'categoryId',
  );
  @override
  late final GeneratedColumn<int> categoryId = GeneratedColumn<int>(
    'category_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    clientDefault: () => DateTime.now(),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    walletId,
    uuid,
    amount,
    period,
    categoryId,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'budgets';
  @override
  VerificationContext validateIntegrity(
    Insertable<Budget> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('wallet_id')) {
      context.handle(
        _walletIdMeta,
        walletId.isAcceptableOrUnknown(data['wallet_id']!, _walletIdMeta),
      );
    }
    if (data.containsKey('uuid')) {
      context.handle(
        _uuidMeta,
        uuid.isAcceptableOrUnknown(data['uuid']!, _uuidMeta),
      );
    }
    if (data.containsKey('period')) {
      context.handle(
        _periodMeta,
        period.isAcceptableOrUnknown(data['period']!, _periodMeta),
      );
    } else if (isInserting) {
      context.missing(_periodMeta);
    }
    if (data.containsKey('category_id')) {
      context.handle(
        _categoryIdMeta,
        categoryId.isAcceptableOrUnknown(data['category_id']!, _categoryIdMeta),
      );
    } else if (isInserting) {
      context.missing(_categoryIdMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Budget map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Budget(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      walletId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}wallet_id'],
      )!,
      uuid: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}uuid'],
      )!,
      amount: $BudgetsTable.$converteramount.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.int,
          data['${effectivePrefix}amount'],
        )!,
      ),
      period: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}period'],
      )!,
      categoryId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}category_id'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $BudgetsTable createAlias(String alias) {
    return $BudgetsTable(attachedDatabase, alias);
  }

  static TypeConverter<double, int> $converteramount = const MoneyConverter();
}

class Budget extends DataClass implements Insertable<Budget> {
  final int id;
  final int walletId;
  final String uuid;
  final double amount;
  final String period;
  final int categoryId;
  final DateTime updatedAt;
  const Budget({
    required this.id,
    required this.walletId,
    required this.uuid,
    required this.amount,
    required this.period,
    required this.categoryId,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['wallet_id'] = Variable<int>(walletId);
    map['uuid'] = Variable<String>(uuid);
    {
      map['amount'] = Variable<int>(
        $BudgetsTable.$converteramount.toSql(amount),
      );
    }
    map['period'] = Variable<String>(period);
    map['category_id'] = Variable<int>(categoryId);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  BudgetsCompanion toCompanion(bool nullToAbsent) {
    return BudgetsCompanion(
      id: Value(id),
      walletId: Value(walletId),
      uuid: Value(uuid),
      amount: Value(amount),
      period: Value(period),
      categoryId: Value(categoryId),
      updatedAt: Value(updatedAt),
    );
  }

  factory Budget.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Budget(
      id: serializer.fromJson<int>(json['id']),
      walletId: serializer.fromJson<int>(json['walletId']),
      uuid: serializer.fromJson<String>(json['uuid']),
      amount: serializer.fromJson<double>(json['amount']),
      period: serializer.fromJson<String>(json['period']),
      categoryId: serializer.fromJson<int>(json['categoryId']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'walletId': serializer.toJson<int>(walletId),
      'uuid': serializer.toJson<String>(uuid),
      'amount': serializer.toJson<double>(amount),
      'period': serializer.toJson<String>(period),
      'categoryId': serializer.toJson<int>(categoryId),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  Budget copyWith({
    int? id,
    int? walletId,
    String? uuid,
    double? amount,
    String? period,
    int? categoryId,
    DateTime? updatedAt,
  }) => Budget(
    id: id ?? this.id,
    walletId: walletId ?? this.walletId,
    uuid: uuid ?? this.uuid,
    amount: amount ?? this.amount,
    period: period ?? this.period,
    categoryId: categoryId ?? this.categoryId,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  Budget copyWithCompanion(BudgetsCompanion data) {
    return Budget(
      id: data.id.present ? data.id.value : this.id,
      walletId: data.walletId.present ? data.walletId.value : this.walletId,
      uuid: data.uuid.present ? data.uuid.value : this.uuid,
      amount: data.amount.present ? data.amount.value : this.amount,
      period: data.period.present ? data.period.value : this.period,
      categoryId: data.categoryId.present
          ? data.categoryId.value
          : this.categoryId,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Budget(')
          ..write('id: $id, ')
          ..write('walletId: $walletId, ')
          ..write('uuid: $uuid, ')
          ..write('amount: $amount, ')
          ..write('period: $period, ')
          ..write('categoryId: $categoryId, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, walletId, uuid, amount, period, categoryId, updatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Budget &&
          other.id == this.id &&
          other.walletId == this.walletId &&
          other.uuid == this.uuid &&
          other.amount == this.amount &&
          other.period == this.period &&
          other.categoryId == this.categoryId &&
          other.updatedAt == this.updatedAt);
}

class BudgetsCompanion extends UpdateCompanion<Budget> {
  final Value<int> id;
  final Value<int> walletId;
  final Value<String> uuid;
  final Value<double> amount;
  final Value<String> period;
  final Value<int> categoryId;
  final Value<DateTime> updatedAt;
  const BudgetsCompanion({
    this.id = const Value.absent(),
    this.walletId = const Value.absent(),
    this.uuid = const Value.absent(),
    this.amount = const Value.absent(),
    this.period = const Value.absent(),
    this.categoryId = const Value.absent(),
    this.updatedAt = const Value.absent(),
  });
  BudgetsCompanion.insert({
    this.id = const Value.absent(),
    this.walletId = const Value.absent(),
    this.uuid = const Value.absent(),
    required double amount,
    required String period,
    required int categoryId,
    this.updatedAt = const Value.absent(),
  }) : amount = Value(amount),
       period = Value(period),
       categoryId = Value(categoryId);
  static Insertable<Budget> custom({
    Expression<int>? id,
    Expression<int>? walletId,
    Expression<String>? uuid,
    Expression<int>? amount,
    Expression<String>? period,
    Expression<int>? categoryId,
    Expression<DateTime>? updatedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (walletId != null) 'wallet_id': walletId,
      if (uuid != null) 'uuid': uuid,
      if (amount != null) 'amount': amount,
      if (period != null) 'period': period,
      if (categoryId != null) 'category_id': categoryId,
      if (updatedAt != null) 'updated_at': updatedAt,
    });
  }

  BudgetsCompanion copyWith({
    Value<int>? id,
    Value<int>? walletId,
    Value<String>? uuid,
    Value<double>? amount,
    Value<String>? period,
    Value<int>? categoryId,
    Value<DateTime>? updatedAt,
  }) {
    return BudgetsCompanion(
      id: id ?? this.id,
      walletId: walletId ?? this.walletId,
      uuid: uuid ?? this.uuid,
      amount: amount ?? this.amount,
      period: period ?? this.period,
      categoryId: categoryId ?? this.categoryId,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (walletId.present) {
      map['wallet_id'] = Variable<int>(walletId.value);
    }
    if (uuid.present) {
      map['uuid'] = Variable<String>(uuid.value);
    }
    if (amount.present) {
      map['amount'] = Variable<int>(
        $BudgetsTable.$converteramount.toSql(amount.value),
      );
    }
    if (period.present) {
      map['period'] = Variable<String>(period.value);
    }
    if (categoryId.present) {
      map['category_id'] = Variable<int>(categoryId.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('BudgetsCompanion(')
          ..write('id: $id, ')
          ..write('walletId: $walletId, ')
          ..write('uuid: $uuid, ')
          ..write('amount: $amount, ')
          ..write('period: $period, ')
          ..write('categoryId: $categoryId, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }
}

class $CategoriesTable extends Categories
    with TableInfo<$CategoriesTable, Category> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CategoriesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _uuidMeta = const VerificationMeta('uuid');
  @override
  late final GeneratedColumn<String> uuid = GeneratedColumn<String>(
    'uuid',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    clientDefault: () => const Uuid().v4(),
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 1,
      maxTextLength: 50,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _iconMeta = const VerificationMeta('icon');
  @override
  late final GeneratedColumn<int> icon = GeneratedColumn<int>(
    'icon',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _colorMeta = const VerificationMeta('color');
  @override
  late final GeneratedColumn<String> color = GeneratedColumn<String>(
    'color',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _isDefaultMeta = const VerificationMeta(
    'isDefault',
  );
  @override
  late final GeneratedColumn<bool> isDefault = GeneratedColumn<bool>(
    'is_default',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_default" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _parentIdMeta = const VerificationMeta(
    'parentId',
  );
  @override
  late final GeneratedColumn<int> parentId = GeneratedColumn<int>(
    'parent_id',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    clientDefault: () => DateTime.now(),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    uuid,
    name,
    icon,
    color,
    isDefault,
    parentId,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'categories';
  @override
  VerificationContext validateIntegrity(
    Insertable<Category> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('uuid')) {
      context.handle(
        _uuidMeta,
        uuid.isAcceptableOrUnknown(data['uuid']!, _uuidMeta),
      );
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('icon')) {
      context.handle(
        _iconMeta,
        icon.isAcceptableOrUnknown(data['icon']!, _iconMeta),
      );
    } else if (isInserting) {
      context.missing(_iconMeta);
    }
    if (data.containsKey('color')) {
      context.handle(
        _colorMeta,
        color.isAcceptableOrUnknown(data['color']!, _colorMeta),
      );
    } else if (isInserting) {
      context.missing(_colorMeta);
    }
    if (data.containsKey('is_default')) {
      context.handle(
        _isDefaultMeta,
        isDefault.isAcceptableOrUnknown(data['is_default']!, _isDefaultMeta),
      );
    }
    if (data.containsKey('parent_id')) {
      context.handle(
        _parentIdMeta,
        parentId.isAcceptableOrUnknown(data['parent_id']!, _parentIdMeta),
      );
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Category map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Category(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      uuid: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}uuid'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      icon: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}icon'],
      )!,
      color: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}color'],
      )!,
      isDefault: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_default'],
      )!,
      parentId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}parent_id'],
      ),
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $CategoriesTable createAlias(String alias) {
    return $CategoriesTable(attachedDatabase, alias);
  }
}

class Category extends DataClass implements Insertable<Category> {
  final int id;
  final String uuid;
  final String name;
  final int icon;
  final String color;
  final bool isDefault;
  final int? parentId;
  final DateTime updatedAt;
  const Category({
    required this.id,
    required this.uuid,
    required this.name,
    required this.icon,
    required this.color,
    required this.isDefault,
    this.parentId,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['uuid'] = Variable<String>(uuid);
    map['name'] = Variable<String>(name);
    map['icon'] = Variable<int>(icon);
    map['color'] = Variable<String>(color);
    map['is_default'] = Variable<bool>(isDefault);
    if (!nullToAbsent || parentId != null) {
      map['parent_id'] = Variable<int>(parentId);
    }
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  CategoriesCompanion toCompanion(bool nullToAbsent) {
    return CategoriesCompanion(
      id: Value(id),
      uuid: Value(uuid),
      name: Value(name),
      icon: Value(icon),
      color: Value(color),
      isDefault: Value(isDefault),
      parentId: parentId == null && nullToAbsent
          ? const Value.absent()
          : Value(parentId),
      updatedAt: Value(updatedAt),
    );
  }

  factory Category.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Category(
      id: serializer.fromJson<int>(json['id']),
      uuid: serializer.fromJson<String>(json['uuid']),
      name: serializer.fromJson<String>(json['name']),
      icon: serializer.fromJson<int>(json['icon']),
      color: serializer.fromJson<String>(json['color']),
      isDefault: serializer.fromJson<bool>(json['isDefault']),
      parentId: serializer.fromJson<int?>(json['parentId']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'uuid': serializer.toJson<String>(uuid),
      'name': serializer.toJson<String>(name),
      'icon': serializer.toJson<int>(icon),
      'color': serializer.toJson<String>(color),
      'isDefault': serializer.toJson<bool>(isDefault),
      'parentId': serializer.toJson<int?>(parentId),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  Category copyWith({
    int? id,
    String? uuid,
    String? name,
    int? icon,
    String? color,
    bool? isDefault,
    Value<int?> parentId = const Value.absent(),
    DateTime? updatedAt,
  }) => Category(
    id: id ?? this.id,
    uuid: uuid ?? this.uuid,
    name: name ?? this.name,
    icon: icon ?? this.icon,
    color: color ?? this.color,
    isDefault: isDefault ?? this.isDefault,
    parentId: parentId.present ? parentId.value : this.parentId,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  Category copyWithCompanion(CategoriesCompanion data) {
    return Category(
      id: data.id.present ? data.id.value : this.id,
      uuid: data.uuid.present ? data.uuid.value : this.uuid,
      name: data.name.present ? data.name.value : this.name,
      icon: data.icon.present ? data.icon.value : this.icon,
      color: data.color.present ? data.color.value : this.color,
      isDefault: data.isDefault.present ? data.isDefault.value : this.isDefault,
      parentId: data.parentId.present ? data.parentId.value : this.parentId,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Category(')
          ..write('id: $id, ')
          ..write('uuid: $uuid, ')
          ..write('name: $name, ')
          ..write('icon: $icon, ')
          ..write('color: $color, ')
          ..write('isDefault: $isDefault, ')
          ..write('parentId: $parentId, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, uuid, name, icon, color, isDefault, parentId, updatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Category &&
          other.id == this.id &&
          other.uuid == this.uuid &&
          other.name == this.name &&
          other.icon == this.icon &&
          other.color == this.color &&
          other.isDefault == this.isDefault &&
          other.parentId == this.parentId &&
          other.updatedAt == this.updatedAt);
}

class CategoriesCompanion extends UpdateCompanion<Category> {
  final Value<int> id;
  final Value<String> uuid;
  final Value<String> name;
  final Value<int> icon;
  final Value<String> color;
  final Value<bool> isDefault;
  final Value<int?> parentId;
  final Value<DateTime> updatedAt;
  const CategoriesCompanion({
    this.id = const Value.absent(),
    this.uuid = const Value.absent(),
    this.name = const Value.absent(),
    this.icon = const Value.absent(),
    this.color = const Value.absent(),
    this.isDefault = const Value.absent(),
    this.parentId = const Value.absent(),
    this.updatedAt = const Value.absent(),
  });
  CategoriesCompanion.insert({
    this.id = const Value.absent(),
    this.uuid = const Value.absent(),
    required String name,
    required int icon,
    required String color,
    this.isDefault = const Value.absent(),
    this.parentId = const Value.absent(),
    this.updatedAt = const Value.absent(),
  }) : name = Value(name),
       icon = Value(icon),
       color = Value(color);
  static Insertable<Category> custom({
    Expression<int>? id,
    Expression<String>? uuid,
    Expression<String>? name,
    Expression<int>? icon,
    Expression<String>? color,
    Expression<bool>? isDefault,
    Expression<int>? parentId,
    Expression<DateTime>? updatedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (uuid != null) 'uuid': uuid,
      if (name != null) 'name': name,
      if (icon != null) 'icon': icon,
      if (color != null) 'color': color,
      if (isDefault != null) 'is_default': isDefault,
      if (parentId != null) 'parent_id': parentId,
      if (updatedAt != null) 'updated_at': updatedAt,
    });
  }

  CategoriesCompanion copyWith({
    Value<int>? id,
    Value<String>? uuid,
    Value<String>? name,
    Value<int>? icon,
    Value<String>? color,
    Value<bool>? isDefault,
    Value<int?>? parentId,
    Value<DateTime>? updatedAt,
  }) {
    return CategoriesCompanion(
      id: id ?? this.id,
      uuid: uuid ?? this.uuid,
      name: name ?? this.name,
      icon: icon ?? this.icon,
      color: color ?? this.color,
      isDefault: isDefault ?? this.isDefault,
      parentId: parentId ?? this.parentId,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (uuid.present) {
      map['uuid'] = Variable<String>(uuid.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (icon.present) {
      map['icon'] = Variable<int>(icon.value);
    }
    if (color.present) {
      map['color'] = Variable<String>(color.value);
    }
    if (isDefault.present) {
      map['is_default'] = Variable<bool>(isDefault.value);
    }
    if (parentId.present) {
      map['parent_id'] = Variable<int>(parentId.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CategoriesCompanion(')
          ..write('id: $id, ')
          ..write('uuid: $uuid, ')
          ..write('name: $name, ')
          ..write('icon: $icon, ')
          ..write('color: $color, ')
          ..write('isDefault: $isDefault, ')
          ..write('parentId: $parentId, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }
}

class $WalletNotificationsTable extends WalletNotifications
    with TableInfo<$WalletNotificationsTable, WalletNotification> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $WalletNotificationsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _walletIdMeta = const VerificationMeta(
    'walletId',
  );
  @override
  late final GeneratedColumn<int> walletId = GeneratedColumn<int>(
    'wallet_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _memberIdMeta = const VerificationMeta(
    'memberId',
  );
  @override
  late final GeneratedColumn<int> memberId = GeneratedColumn<int>(
    'member_id',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  @override
  late final GeneratedColumnWithTypeConverter<WalletNotificationType, String>
  type =
      GeneratedColumn<String>(
        'type',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      ).withConverter<WalletNotificationType>(
        $WalletNotificationsTable.$convertertype,
      );
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
    'title',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 1,
      maxTextLength: 120,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _messageMeta = const VerificationMeta(
    'message',
  );
  @override
  late final GeneratedColumn<String> message = GeneratedColumn<String>(
    'message',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 1,
      maxTextLength: 300,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _relatedEntityIdMeta = const VerificationMeta(
    'relatedEntityId',
  );
  @override
  late final GeneratedColumn<int> relatedEntityId = GeneratedColumn<int>(
    'related_entity_id',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    clientDefault: () => DateTime.now(),
  );
  static const VerificationMeta _readAtMeta = const VerificationMeta('readAt');
  @override
  late final GeneratedColumn<DateTime> readAt = GeneratedColumn<DateTime>(
    'read_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _dismissedAtMeta = const VerificationMeta(
    'dismissedAt',
  );
  @override
  late final GeneratedColumn<DateTime> dismissedAt = GeneratedColumn<DateTime>(
    'dismissed_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    walletId,
    memberId,
    type,
    title,
    message,
    relatedEntityId,
    createdAt,
    readAt,
    dismissedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'wallet_notifications';
  @override
  VerificationContext validateIntegrity(
    Insertable<WalletNotification> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('wallet_id')) {
      context.handle(
        _walletIdMeta,
        walletId.isAcceptableOrUnknown(data['wallet_id']!, _walletIdMeta),
      );
    } else if (isInserting) {
      context.missing(_walletIdMeta);
    }
    if (data.containsKey('member_id')) {
      context.handle(
        _memberIdMeta,
        memberId.isAcceptableOrUnknown(data['member_id']!, _memberIdMeta),
      );
    }
    if (data.containsKey('title')) {
      context.handle(
        _titleMeta,
        title.isAcceptableOrUnknown(data['title']!, _titleMeta),
      );
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    if (data.containsKey('message')) {
      context.handle(
        _messageMeta,
        message.isAcceptableOrUnknown(data['message']!, _messageMeta),
      );
    } else if (isInserting) {
      context.missing(_messageMeta);
    }
    if (data.containsKey('related_entity_id')) {
      context.handle(
        _relatedEntityIdMeta,
        relatedEntityId.isAcceptableOrUnknown(
          data['related_entity_id']!,
          _relatedEntityIdMeta,
        ),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    if (data.containsKey('read_at')) {
      context.handle(
        _readAtMeta,
        readAt.isAcceptableOrUnknown(data['read_at']!, _readAtMeta),
      );
    }
    if (data.containsKey('dismissed_at')) {
      context.handle(
        _dismissedAtMeta,
        dismissedAt.isAcceptableOrUnknown(
          data['dismissed_at']!,
          _dismissedAtMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  WalletNotification map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return WalletNotification(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      walletId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}wallet_id'],
      )!,
      memberId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}member_id'],
      ),
      type: $WalletNotificationsTable.$convertertype.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}type'],
        )!,
      ),
      title: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}title'],
      )!,
      message: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}message'],
      )!,
      relatedEntityId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}related_entity_id'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      readAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}read_at'],
      ),
      dismissedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}dismissed_at'],
      ),
    );
  }

  @override
  $WalletNotificationsTable createAlias(String alias) {
    return $WalletNotificationsTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<WalletNotificationType, String, String>
  $convertertype = const EnumNameConverter(WalletNotificationType.values);
}

class WalletNotification extends DataClass
    implements Insertable<WalletNotification> {
  final int id;
  final int walletId;
  final int? memberId;
  final WalletNotificationType type;
  final String title;
  final String message;
  final int? relatedEntityId;
  final DateTime createdAt;
  final DateTime? readAt;
  final DateTime? dismissedAt;
  const WalletNotification({
    required this.id,
    required this.walletId,
    this.memberId,
    required this.type,
    required this.title,
    required this.message,
    this.relatedEntityId,
    required this.createdAt,
    this.readAt,
    this.dismissedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['wallet_id'] = Variable<int>(walletId);
    if (!nullToAbsent || memberId != null) {
      map['member_id'] = Variable<int>(memberId);
    }
    {
      map['type'] = Variable<String>(
        $WalletNotificationsTable.$convertertype.toSql(type),
      );
    }
    map['title'] = Variable<String>(title);
    map['message'] = Variable<String>(message);
    if (!nullToAbsent || relatedEntityId != null) {
      map['related_entity_id'] = Variable<int>(relatedEntityId);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    if (!nullToAbsent || readAt != null) {
      map['read_at'] = Variable<DateTime>(readAt);
    }
    if (!nullToAbsent || dismissedAt != null) {
      map['dismissed_at'] = Variable<DateTime>(dismissedAt);
    }
    return map;
  }

  WalletNotificationsCompanion toCompanion(bool nullToAbsent) {
    return WalletNotificationsCompanion(
      id: Value(id),
      walletId: Value(walletId),
      memberId: memberId == null && nullToAbsent
          ? const Value.absent()
          : Value(memberId),
      type: Value(type),
      title: Value(title),
      message: Value(message),
      relatedEntityId: relatedEntityId == null && nullToAbsent
          ? const Value.absent()
          : Value(relatedEntityId),
      createdAt: Value(createdAt),
      readAt: readAt == null && nullToAbsent
          ? const Value.absent()
          : Value(readAt),
      dismissedAt: dismissedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(dismissedAt),
    );
  }

  factory WalletNotification.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return WalletNotification(
      id: serializer.fromJson<int>(json['id']),
      walletId: serializer.fromJson<int>(json['walletId']),
      memberId: serializer.fromJson<int?>(json['memberId']),
      type: $WalletNotificationsTable.$convertertype.fromJson(
        serializer.fromJson<String>(json['type']),
      ),
      title: serializer.fromJson<String>(json['title']),
      message: serializer.fromJson<String>(json['message']),
      relatedEntityId: serializer.fromJson<int?>(json['relatedEntityId']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      readAt: serializer.fromJson<DateTime?>(json['readAt']),
      dismissedAt: serializer.fromJson<DateTime?>(json['dismissedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'walletId': serializer.toJson<int>(walletId),
      'memberId': serializer.toJson<int?>(memberId),
      'type': serializer.toJson<String>(
        $WalletNotificationsTable.$convertertype.toJson(type),
      ),
      'title': serializer.toJson<String>(title),
      'message': serializer.toJson<String>(message),
      'relatedEntityId': serializer.toJson<int?>(relatedEntityId),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'readAt': serializer.toJson<DateTime?>(readAt),
      'dismissedAt': serializer.toJson<DateTime?>(dismissedAt),
    };
  }

  WalletNotification copyWith({
    int? id,
    int? walletId,
    Value<int?> memberId = const Value.absent(),
    WalletNotificationType? type,
    String? title,
    String? message,
    Value<int?> relatedEntityId = const Value.absent(),
    DateTime? createdAt,
    Value<DateTime?> readAt = const Value.absent(),
    Value<DateTime?> dismissedAt = const Value.absent(),
  }) => WalletNotification(
    id: id ?? this.id,
    walletId: walletId ?? this.walletId,
    memberId: memberId.present ? memberId.value : this.memberId,
    type: type ?? this.type,
    title: title ?? this.title,
    message: message ?? this.message,
    relatedEntityId: relatedEntityId.present
        ? relatedEntityId.value
        : this.relatedEntityId,
    createdAt: createdAt ?? this.createdAt,
    readAt: readAt.present ? readAt.value : this.readAt,
    dismissedAt: dismissedAt.present ? dismissedAt.value : this.dismissedAt,
  );
  WalletNotification copyWithCompanion(WalletNotificationsCompanion data) {
    return WalletNotification(
      id: data.id.present ? data.id.value : this.id,
      walletId: data.walletId.present ? data.walletId.value : this.walletId,
      memberId: data.memberId.present ? data.memberId.value : this.memberId,
      type: data.type.present ? data.type.value : this.type,
      title: data.title.present ? data.title.value : this.title,
      message: data.message.present ? data.message.value : this.message,
      relatedEntityId: data.relatedEntityId.present
          ? data.relatedEntityId.value
          : this.relatedEntityId,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      readAt: data.readAt.present ? data.readAt.value : this.readAt,
      dismissedAt: data.dismissedAt.present
          ? data.dismissedAt.value
          : this.dismissedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('WalletNotification(')
          ..write('id: $id, ')
          ..write('walletId: $walletId, ')
          ..write('memberId: $memberId, ')
          ..write('type: $type, ')
          ..write('title: $title, ')
          ..write('message: $message, ')
          ..write('relatedEntityId: $relatedEntityId, ')
          ..write('createdAt: $createdAt, ')
          ..write('readAt: $readAt, ')
          ..write('dismissedAt: $dismissedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    walletId,
    memberId,
    type,
    title,
    message,
    relatedEntityId,
    createdAt,
    readAt,
    dismissedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is WalletNotification &&
          other.id == this.id &&
          other.walletId == this.walletId &&
          other.memberId == this.memberId &&
          other.type == this.type &&
          other.title == this.title &&
          other.message == this.message &&
          other.relatedEntityId == this.relatedEntityId &&
          other.createdAt == this.createdAt &&
          other.readAt == this.readAt &&
          other.dismissedAt == this.dismissedAt);
}

class WalletNotificationsCompanion extends UpdateCompanion<WalletNotification> {
  final Value<int> id;
  final Value<int> walletId;
  final Value<int?> memberId;
  final Value<WalletNotificationType> type;
  final Value<String> title;
  final Value<String> message;
  final Value<int?> relatedEntityId;
  final Value<DateTime> createdAt;
  final Value<DateTime?> readAt;
  final Value<DateTime?> dismissedAt;
  const WalletNotificationsCompanion({
    this.id = const Value.absent(),
    this.walletId = const Value.absent(),
    this.memberId = const Value.absent(),
    this.type = const Value.absent(),
    this.title = const Value.absent(),
    this.message = const Value.absent(),
    this.relatedEntityId = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.readAt = const Value.absent(),
    this.dismissedAt = const Value.absent(),
  });
  WalletNotificationsCompanion.insert({
    this.id = const Value.absent(),
    required int walletId,
    this.memberId = const Value.absent(),
    required WalletNotificationType type,
    required String title,
    required String message,
    this.relatedEntityId = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.readAt = const Value.absent(),
    this.dismissedAt = const Value.absent(),
  }) : walletId = Value(walletId),
       type = Value(type),
       title = Value(title),
       message = Value(message);
  static Insertable<WalletNotification> custom({
    Expression<int>? id,
    Expression<int>? walletId,
    Expression<int>? memberId,
    Expression<String>? type,
    Expression<String>? title,
    Expression<String>? message,
    Expression<int>? relatedEntityId,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? readAt,
    Expression<DateTime>? dismissedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (walletId != null) 'wallet_id': walletId,
      if (memberId != null) 'member_id': memberId,
      if (type != null) 'type': type,
      if (title != null) 'title': title,
      if (message != null) 'message': message,
      if (relatedEntityId != null) 'related_entity_id': relatedEntityId,
      if (createdAt != null) 'created_at': createdAt,
      if (readAt != null) 'read_at': readAt,
      if (dismissedAt != null) 'dismissed_at': dismissedAt,
    });
  }

  WalletNotificationsCompanion copyWith({
    Value<int>? id,
    Value<int>? walletId,
    Value<int?>? memberId,
    Value<WalletNotificationType>? type,
    Value<String>? title,
    Value<String>? message,
    Value<int?>? relatedEntityId,
    Value<DateTime>? createdAt,
    Value<DateTime?>? readAt,
    Value<DateTime?>? dismissedAt,
  }) {
    return WalletNotificationsCompanion(
      id: id ?? this.id,
      walletId: walletId ?? this.walletId,
      memberId: memberId ?? this.memberId,
      type: type ?? this.type,
      title: title ?? this.title,
      message: message ?? this.message,
      relatedEntityId: relatedEntityId ?? this.relatedEntityId,
      createdAt: createdAt ?? this.createdAt,
      readAt: readAt ?? this.readAt,
      dismissedAt: dismissedAt ?? this.dismissedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (walletId.present) {
      map['wallet_id'] = Variable<int>(walletId.value);
    }
    if (memberId.present) {
      map['member_id'] = Variable<int>(memberId.value);
    }
    if (type.present) {
      map['type'] = Variable<String>(
        $WalletNotificationsTable.$convertertype.toSql(type.value),
      );
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (message.present) {
      map['message'] = Variable<String>(message.value);
    }
    if (relatedEntityId.present) {
      map['related_entity_id'] = Variable<int>(relatedEntityId.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (readAt.present) {
      map['read_at'] = Variable<DateTime>(readAt.value);
    }
    if (dismissedAt.present) {
      map['dismissed_at'] = Variable<DateTime>(dismissedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('WalletNotificationsCompanion(')
          ..write('id: $id, ')
          ..write('walletId: $walletId, ')
          ..write('memberId: $memberId, ')
          ..write('type: $type, ')
          ..write('title: $title, ')
          ..write('message: $message, ')
          ..write('relatedEntityId: $relatedEntityId, ')
          ..write('createdAt: $createdAt, ')
          ..write('readAt: $readAt, ')
          ..write('dismissedAt: $dismissedAt')
          ..write(')'))
        .toString();
  }
}

class $LoansTable extends Loans with TableInfo<$LoansTable, LoanDb> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $LoansTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _walletIdMeta = const VerificationMeta(
    'walletId',
  );
  @override
  late final GeneratedColumn<int> walletId = GeneratedColumn<int>(
    'wallet_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(1),
  );
  static const VerificationMeta _uuidMeta = const VerificationMeta('uuid');
  @override
  late final GeneratedColumn<String> uuid = GeneratedColumn<String>(
    'uuid',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    clientDefault: () => const Uuid().v4(),
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 1,
      maxTextLength: 100,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _accountIdMeta = const VerificationMeta(
    'accountId',
  );
  @override
  late final GeneratedColumn<int> accountId = GeneratedColumn<int>(
    'account_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  @override
  late final GeneratedColumnWithTypeConverter<double, int> principalAmount =
      GeneratedColumn<int>(
        'principal_amount',
        aliasedName,
        false,
        type: DriftSqlType.int,
        requiredDuringInsert: true,
      ).withConverter<double>($LoansTable.$converterprincipalAmount);
  static const VerificationMeta _interestRateMeta = const VerificationMeta(
    'interestRate',
  );
  @override
  late final GeneratedColumn<double> interestRate = GeneratedColumn<double>(
    'interest_rate',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _tenureMonthsMeta = const VerificationMeta(
    'tenureMonths',
  );
  @override
  late final GeneratedColumn<int> tenureMonths = GeneratedColumn<int>(
    'tenure_months',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _startDateMeta = const VerificationMeta(
    'startDate',
  );
  @override
  late final GeneratedColumn<DateTime> startDate = GeneratedColumn<DateTime>(
    'start_date',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _nextEmiDateMeta = const VerificationMeta(
    'nextEmiDate',
  );
  @override
  late final GeneratedColumn<DateTime> nextEmiDate = GeneratedColumn<DateTime>(
    'next_emi_date',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  @override
  late final GeneratedColumnWithTypeConverter<double, int> emiAmount =
      GeneratedColumn<int>(
        'emi_amount',
        aliasedName,
        false,
        type: DriftSqlType.int,
        requiredDuringInsert: true,
      ).withConverter<double>($LoansTable.$converteremiAmount);
  static const VerificationMeta _isActiveMeta = const VerificationMeta(
    'isActive',
  );
  @override
  late final GeneratedColumn<bool> isActive = GeneratedColumn<bool>(
    'is_active',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_active" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    clientDefault: () => DateTime.now(),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    walletId,
    uuid,
    name,
    accountId,
    principalAmount,
    interestRate,
    tenureMonths,
    startDate,
    nextEmiDate,
    emiAmount,
    isActive,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'loans';
  @override
  VerificationContext validateIntegrity(
    Insertable<LoanDb> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('wallet_id')) {
      context.handle(
        _walletIdMeta,
        walletId.isAcceptableOrUnknown(data['wallet_id']!, _walletIdMeta),
      );
    }
    if (data.containsKey('uuid')) {
      context.handle(
        _uuidMeta,
        uuid.isAcceptableOrUnknown(data['uuid']!, _uuidMeta),
      );
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('account_id')) {
      context.handle(
        _accountIdMeta,
        accountId.isAcceptableOrUnknown(data['account_id']!, _accountIdMeta),
      );
    } else if (isInserting) {
      context.missing(_accountIdMeta);
    }
    if (data.containsKey('interest_rate')) {
      context.handle(
        _interestRateMeta,
        interestRate.isAcceptableOrUnknown(
          data['interest_rate']!,
          _interestRateMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_interestRateMeta);
    }
    if (data.containsKey('tenure_months')) {
      context.handle(
        _tenureMonthsMeta,
        tenureMonths.isAcceptableOrUnknown(
          data['tenure_months']!,
          _tenureMonthsMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_tenureMonthsMeta);
    }
    if (data.containsKey('start_date')) {
      context.handle(
        _startDateMeta,
        startDate.isAcceptableOrUnknown(data['start_date']!, _startDateMeta),
      );
    } else if (isInserting) {
      context.missing(_startDateMeta);
    }
    if (data.containsKey('next_emi_date')) {
      context.handle(
        _nextEmiDateMeta,
        nextEmiDate.isAcceptableOrUnknown(
          data['next_emi_date']!,
          _nextEmiDateMeta,
        ),
      );
    }
    if (data.containsKey('is_active')) {
      context.handle(
        _isActiveMeta,
        isActive.isAcceptableOrUnknown(data['is_active']!, _isActiveMeta),
      );
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  LoanDb map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return LoanDb(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      walletId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}wallet_id'],
      )!,
      uuid: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}uuid'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      accountId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}account_id'],
      )!,
      principalAmount: $LoansTable.$converterprincipalAmount.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.int,
          data['${effectivePrefix}principal_amount'],
        )!,
      ),
      interestRate: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}interest_rate'],
      )!,
      tenureMonths: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}tenure_months'],
      )!,
      startDate: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}start_date'],
      )!,
      nextEmiDate: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}next_emi_date'],
      ),
      emiAmount: $LoansTable.$converteremiAmount.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.int,
          data['${effectivePrefix}emi_amount'],
        )!,
      ),
      isActive: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_active'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $LoansTable createAlias(String alias) {
    return $LoansTable(attachedDatabase, alias);
  }

  static TypeConverter<double, int> $converterprincipalAmount =
      const MoneyConverter();
  static TypeConverter<double, int> $converteremiAmount =
      const MoneyConverter();
}

class LoanDb extends DataClass implements Insertable<LoanDb> {
  final int id;
  final int walletId;
  final String uuid;
  final String name;
  final int accountId;
  final double principalAmount;
  final double interestRate;
  final int tenureMonths;
  final DateTime startDate;
  final DateTime? nextEmiDate;
  final double emiAmount;
  final bool isActive;
  final DateTime updatedAt;
  const LoanDb({
    required this.id,
    required this.walletId,
    required this.uuid,
    required this.name,
    required this.accountId,
    required this.principalAmount,
    required this.interestRate,
    required this.tenureMonths,
    required this.startDate,
    this.nextEmiDate,
    required this.emiAmount,
    required this.isActive,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['wallet_id'] = Variable<int>(walletId);
    map['uuid'] = Variable<String>(uuid);
    map['name'] = Variable<String>(name);
    map['account_id'] = Variable<int>(accountId);
    {
      map['principal_amount'] = Variable<int>(
        $LoansTable.$converterprincipalAmount.toSql(principalAmount),
      );
    }
    map['interest_rate'] = Variable<double>(interestRate);
    map['tenure_months'] = Variable<int>(tenureMonths);
    map['start_date'] = Variable<DateTime>(startDate);
    if (!nullToAbsent || nextEmiDate != null) {
      map['next_emi_date'] = Variable<DateTime>(nextEmiDate);
    }
    {
      map['emi_amount'] = Variable<int>(
        $LoansTable.$converteremiAmount.toSql(emiAmount),
      );
    }
    map['is_active'] = Variable<bool>(isActive);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  LoansCompanion toCompanion(bool nullToAbsent) {
    return LoansCompanion(
      id: Value(id),
      walletId: Value(walletId),
      uuid: Value(uuid),
      name: Value(name),
      accountId: Value(accountId),
      principalAmount: Value(principalAmount),
      interestRate: Value(interestRate),
      tenureMonths: Value(tenureMonths),
      startDate: Value(startDate),
      nextEmiDate: nextEmiDate == null && nullToAbsent
          ? const Value.absent()
          : Value(nextEmiDate),
      emiAmount: Value(emiAmount),
      isActive: Value(isActive),
      updatedAt: Value(updatedAt),
    );
  }

  factory LoanDb.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return LoanDb(
      id: serializer.fromJson<int>(json['id']),
      walletId: serializer.fromJson<int>(json['walletId']),
      uuid: serializer.fromJson<String>(json['uuid']),
      name: serializer.fromJson<String>(json['name']),
      accountId: serializer.fromJson<int>(json['accountId']),
      principalAmount: serializer.fromJson<double>(json['principalAmount']),
      interestRate: serializer.fromJson<double>(json['interestRate']),
      tenureMonths: serializer.fromJson<int>(json['tenureMonths']),
      startDate: serializer.fromJson<DateTime>(json['startDate']),
      nextEmiDate: serializer.fromJson<DateTime?>(json['nextEmiDate']),
      emiAmount: serializer.fromJson<double>(json['emiAmount']),
      isActive: serializer.fromJson<bool>(json['isActive']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'walletId': serializer.toJson<int>(walletId),
      'uuid': serializer.toJson<String>(uuid),
      'name': serializer.toJson<String>(name),
      'accountId': serializer.toJson<int>(accountId),
      'principalAmount': serializer.toJson<double>(principalAmount),
      'interestRate': serializer.toJson<double>(interestRate),
      'tenureMonths': serializer.toJson<int>(tenureMonths),
      'startDate': serializer.toJson<DateTime>(startDate),
      'nextEmiDate': serializer.toJson<DateTime?>(nextEmiDate),
      'emiAmount': serializer.toJson<double>(emiAmount),
      'isActive': serializer.toJson<bool>(isActive),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  LoanDb copyWith({
    int? id,
    int? walletId,
    String? uuid,
    String? name,
    int? accountId,
    double? principalAmount,
    double? interestRate,
    int? tenureMonths,
    DateTime? startDate,
    Value<DateTime?> nextEmiDate = const Value.absent(),
    double? emiAmount,
    bool? isActive,
    DateTime? updatedAt,
  }) => LoanDb(
    id: id ?? this.id,
    walletId: walletId ?? this.walletId,
    uuid: uuid ?? this.uuid,
    name: name ?? this.name,
    accountId: accountId ?? this.accountId,
    principalAmount: principalAmount ?? this.principalAmount,
    interestRate: interestRate ?? this.interestRate,
    tenureMonths: tenureMonths ?? this.tenureMonths,
    startDate: startDate ?? this.startDate,
    nextEmiDate: nextEmiDate.present ? nextEmiDate.value : this.nextEmiDate,
    emiAmount: emiAmount ?? this.emiAmount,
    isActive: isActive ?? this.isActive,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  LoanDb copyWithCompanion(LoansCompanion data) {
    return LoanDb(
      id: data.id.present ? data.id.value : this.id,
      walletId: data.walletId.present ? data.walletId.value : this.walletId,
      uuid: data.uuid.present ? data.uuid.value : this.uuid,
      name: data.name.present ? data.name.value : this.name,
      accountId: data.accountId.present ? data.accountId.value : this.accountId,
      principalAmount: data.principalAmount.present
          ? data.principalAmount.value
          : this.principalAmount,
      interestRate: data.interestRate.present
          ? data.interestRate.value
          : this.interestRate,
      tenureMonths: data.tenureMonths.present
          ? data.tenureMonths.value
          : this.tenureMonths,
      startDate: data.startDate.present ? data.startDate.value : this.startDate,
      nextEmiDate: data.nextEmiDate.present
          ? data.nextEmiDate.value
          : this.nextEmiDate,
      emiAmount: data.emiAmount.present ? data.emiAmount.value : this.emiAmount,
      isActive: data.isActive.present ? data.isActive.value : this.isActive,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('LoanDb(')
          ..write('id: $id, ')
          ..write('walletId: $walletId, ')
          ..write('uuid: $uuid, ')
          ..write('name: $name, ')
          ..write('accountId: $accountId, ')
          ..write('principalAmount: $principalAmount, ')
          ..write('interestRate: $interestRate, ')
          ..write('tenureMonths: $tenureMonths, ')
          ..write('startDate: $startDate, ')
          ..write('nextEmiDate: $nextEmiDate, ')
          ..write('emiAmount: $emiAmount, ')
          ..write('isActive: $isActive, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    walletId,
    uuid,
    name,
    accountId,
    principalAmount,
    interestRate,
    tenureMonths,
    startDate,
    nextEmiDate,
    emiAmount,
    isActive,
    updatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is LoanDb &&
          other.id == this.id &&
          other.walletId == this.walletId &&
          other.uuid == this.uuid &&
          other.name == this.name &&
          other.accountId == this.accountId &&
          other.principalAmount == this.principalAmount &&
          other.interestRate == this.interestRate &&
          other.tenureMonths == this.tenureMonths &&
          other.startDate == this.startDate &&
          other.nextEmiDate == this.nextEmiDate &&
          other.emiAmount == this.emiAmount &&
          other.isActive == this.isActive &&
          other.updatedAt == this.updatedAt);
}

class LoansCompanion extends UpdateCompanion<LoanDb> {
  final Value<int> id;
  final Value<int> walletId;
  final Value<String> uuid;
  final Value<String> name;
  final Value<int> accountId;
  final Value<double> principalAmount;
  final Value<double> interestRate;
  final Value<int> tenureMonths;
  final Value<DateTime> startDate;
  final Value<DateTime?> nextEmiDate;
  final Value<double> emiAmount;
  final Value<bool> isActive;
  final Value<DateTime> updatedAt;
  const LoansCompanion({
    this.id = const Value.absent(),
    this.walletId = const Value.absent(),
    this.uuid = const Value.absent(),
    this.name = const Value.absent(),
    this.accountId = const Value.absent(),
    this.principalAmount = const Value.absent(),
    this.interestRate = const Value.absent(),
    this.tenureMonths = const Value.absent(),
    this.startDate = const Value.absent(),
    this.nextEmiDate = const Value.absent(),
    this.emiAmount = const Value.absent(),
    this.isActive = const Value.absent(),
    this.updatedAt = const Value.absent(),
  });
  LoansCompanion.insert({
    this.id = const Value.absent(),
    this.walletId = const Value.absent(),
    this.uuid = const Value.absent(),
    required String name,
    required int accountId,
    required double principalAmount,
    required double interestRate,
    required int tenureMonths,
    required DateTime startDate,
    this.nextEmiDate = const Value.absent(),
    required double emiAmount,
    this.isActive = const Value.absent(),
    this.updatedAt = const Value.absent(),
  }) : name = Value(name),
       accountId = Value(accountId),
       principalAmount = Value(principalAmount),
       interestRate = Value(interestRate),
       tenureMonths = Value(tenureMonths),
       startDate = Value(startDate),
       emiAmount = Value(emiAmount);
  static Insertable<LoanDb> custom({
    Expression<int>? id,
    Expression<int>? walletId,
    Expression<String>? uuid,
    Expression<String>? name,
    Expression<int>? accountId,
    Expression<int>? principalAmount,
    Expression<double>? interestRate,
    Expression<int>? tenureMonths,
    Expression<DateTime>? startDate,
    Expression<DateTime>? nextEmiDate,
    Expression<int>? emiAmount,
    Expression<bool>? isActive,
    Expression<DateTime>? updatedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (walletId != null) 'wallet_id': walletId,
      if (uuid != null) 'uuid': uuid,
      if (name != null) 'name': name,
      if (accountId != null) 'account_id': accountId,
      if (principalAmount != null) 'principal_amount': principalAmount,
      if (interestRate != null) 'interest_rate': interestRate,
      if (tenureMonths != null) 'tenure_months': tenureMonths,
      if (startDate != null) 'start_date': startDate,
      if (nextEmiDate != null) 'next_emi_date': nextEmiDate,
      if (emiAmount != null) 'emi_amount': emiAmount,
      if (isActive != null) 'is_active': isActive,
      if (updatedAt != null) 'updated_at': updatedAt,
    });
  }

  LoansCompanion copyWith({
    Value<int>? id,
    Value<int>? walletId,
    Value<String>? uuid,
    Value<String>? name,
    Value<int>? accountId,
    Value<double>? principalAmount,
    Value<double>? interestRate,
    Value<int>? tenureMonths,
    Value<DateTime>? startDate,
    Value<DateTime?>? nextEmiDate,
    Value<double>? emiAmount,
    Value<bool>? isActive,
    Value<DateTime>? updatedAt,
  }) {
    return LoansCompanion(
      id: id ?? this.id,
      walletId: walletId ?? this.walletId,
      uuid: uuid ?? this.uuid,
      name: name ?? this.name,
      accountId: accountId ?? this.accountId,
      principalAmount: principalAmount ?? this.principalAmount,
      interestRate: interestRate ?? this.interestRate,
      tenureMonths: tenureMonths ?? this.tenureMonths,
      startDate: startDate ?? this.startDate,
      nextEmiDate: nextEmiDate ?? this.nextEmiDate,
      emiAmount: emiAmount ?? this.emiAmount,
      isActive: isActive ?? this.isActive,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (walletId.present) {
      map['wallet_id'] = Variable<int>(walletId.value);
    }
    if (uuid.present) {
      map['uuid'] = Variable<String>(uuid.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (accountId.present) {
      map['account_id'] = Variable<int>(accountId.value);
    }
    if (principalAmount.present) {
      map['principal_amount'] = Variable<int>(
        $LoansTable.$converterprincipalAmount.toSql(principalAmount.value),
      );
    }
    if (interestRate.present) {
      map['interest_rate'] = Variable<double>(interestRate.value);
    }
    if (tenureMonths.present) {
      map['tenure_months'] = Variable<int>(tenureMonths.value);
    }
    if (startDate.present) {
      map['start_date'] = Variable<DateTime>(startDate.value);
    }
    if (nextEmiDate.present) {
      map['next_emi_date'] = Variable<DateTime>(nextEmiDate.value);
    }
    if (emiAmount.present) {
      map['emi_amount'] = Variable<int>(
        $LoansTable.$converteremiAmount.toSql(emiAmount.value),
      );
    }
    if (isActive.present) {
      map['is_active'] = Variable<bool>(isActive.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('LoansCompanion(')
          ..write('id: $id, ')
          ..write('walletId: $walletId, ')
          ..write('uuid: $uuid, ')
          ..write('name: $name, ')
          ..write('accountId: $accountId, ')
          ..write('principalAmount: $principalAmount, ')
          ..write('interestRate: $interestRate, ')
          ..write('tenureMonths: $tenureMonths, ')
          ..write('startDate: $startDate, ')
          ..write('nextEmiDate: $nextEmiDate, ')
          ..write('emiAmount: $emiAmount, ')
          ..write('isActive: $isActive, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }
}

class $PeerDebtsTable extends PeerDebts
    with TableInfo<$PeerDebtsTable, PeerDebtDb> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PeerDebtsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _walletIdMeta = const VerificationMeta(
    'walletId',
  );
  @override
  late final GeneratedColumn<int> walletId = GeneratedColumn<int>(
    'wallet_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _uuidMeta = const VerificationMeta('uuid');
  @override
  late final GeneratedColumn<String> uuid = GeneratedColumn<String>(
    'uuid',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    clientDefault: () => const Uuid().v4(),
  );
  static const VerificationMeta _personNameMeta = const VerificationMeta(
    'personName',
  );
  @override
  late final GeneratedColumn<String> personName = GeneratedColumn<String>(
    'person_name',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 1,
      maxTextLength: 100,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  late final GeneratedColumnWithTypeConverter<PeerDebtType, int> type =
      GeneratedColumn<int>(
        'type',
        aliasedName,
        false,
        type: DriftSqlType.int,
        requiredDuringInsert: true,
      ).withConverter<PeerDebtType>($PeerDebtsTable.$convertertype);
  @override
  late final GeneratedColumnWithTypeConverter<double, int> amount =
      GeneratedColumn<int>(
        'amount',
        aliasedName,
        false,
        type: DriftSqlType.int,
        requiredDuringInsert: true,
      ).withConverter<double>($PeerDebtsTable.$converteramount);
  static const VerificationMeta _noteMeta = const VerificationMeta('note');
  @override
  late final GeneratedColumn<String> note = GeneratedColumn<String>(
    'note',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _dateMeta = const VerificationMeta('date');
  @override
  late final GeneratedColumn<DateTime> date = GeneratedColumn<DateTime>(
    'date',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _isSettledMeta = const VerificationMeta(
    'isSettled',
  );
  @override
  late final GeneratedColumn<bool> isSettled = GeneratedColumn<bool>(
    'is_settled',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_settled" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _transactionIdMeta = const VerificationMeta(
    'transactionId',
  );
  @override
  late final GeneratedColumn<int> transactionId = GeneratedColumn<int>(
    'transaction_id',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    clientDefault: () => DateTime.now(),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    walletId,
    uuid,
    personName,
    type,
    amount,
    note,
    date,
    isSettled,
    transactionId,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'peer_debts';
  @override
  VerificationContext validateIntegrity(
    Insertable<PeerDebtDb> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('wallet_id')) {
      context.handle(
        _walletIdMeta,
        walletId.isAcceptableOrUnknown(data['wallet_id']!, _walletIdMeta),
      );
    } else if (isInserting) {
      context.missing(_walletIdMeta);
    }
    if (data.containsKey('uuid')) {
      context.handle(
        _uuidMeta,
        uuid.isAcceptableOrUnknown(data['uuid']!, _uuidMeta),
      );
    }
    if (data.containsKey('person_name')) {
      context.handle(
        _personNameMeta,
        personName.isAcceptableOrUnknown(data['person_name']!, _personNameMeta),
      );
    } else if (isInserting) {
      context.missing(_personNameMeta);
    }
    if (data.containsKey('note')) {
      context.handle(
        _noteMeta,
        note.isAcceptableOrUnknown(data['note']!, _noteMeta),
      );
    }
    if (data.containsKey('date')) {
      context.handle(
        _dateMeta,
        date.isAcceptableOrUnknown(data['date']!, _dateMeta),
      );
    } else if (isInserting) {
      context.missing(_dateMeta);
    }
    if (data.containsKey('is_settled')) {
      context.handle(
        _isSettledMeta,
        isSettled.isAcceptableOrUnknown(data['is_settled']!, _isSettledMeta),
      );
    }
    if (data.containsKey('transaction_id')) {
      context.handle(
        _transactionIdMeta,
        transactionId.isAcceptableOrUnknown(
          data['transaction_id']!,
          _transactionIdMeta,
        ),
      );
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  PeerDebtDb map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return PeerDebtDb(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      walletId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}wallet_id'],
      )!,
      uuid: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}uuid'],
      )!,
      personName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}person_name'],
      )!,
      type: $PeerDebtsTable.$convertertype.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.int,
          data['${effectivePrefix}type'],
        )!,
      ),
      amount: $PeerDebtsTable.$converteramount.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.int,
          data['${effectivePrefix}amount'],
        )!,
      ),
      note: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}note'],
      ),
      date: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}date'],
      )!,
      isSettled: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_settled'],
      )!,
      transactionId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}transaction_id'],
      ),
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $PeerDebtsTable createAlias(String alias) {
    return $PeerDebtsTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<PeerDebtType, int, int> $convertertype =
      const EnumIndexConverter<PeerDebtType>(PeerDebtType.values);
  static TypeConverter<double, int> $converteramount = const MoneyConverter();
}

class PeerDebtDb extends DataClass implements Insertable<PeerDebtDb> {
  final int id;
  final int walletId;
  final String uuid;
  final String personName;
  final PeerDebtType type;
  final double amount;
  final String? note;
  final DateTime date;
  final bool isSettled;
  final int? transactionId;
  final DateTime updatedAt;
  const PeerDebtDb({
    required this.id,
    required this.walletId,
    required this.uuid,
    required this.personName,
    required this.type,
    required this.amount,
    this.note,
    required this.date,
    required this.isSettled,
    this.transactionId,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['wallet_id'] = Variable<int>(walletId);
    map['uuid'] = Variable<String>(uuid);
    map['person_name'] = Variable<String>(personName);
    {
      map['type'] = Variable<int>($PeerDebtsTable.$convertertype.toSql(type));
    }
    {
      map['amount'] = Variable<int>(
        $PeerDebtsTable.$converteramount.toSql(amount),
      );
    }
    if (!nullToAbsent || note != null) {
      map['note'] = Variable<String>(note);
    }
    map['date'] = Variable<DateTime>(date);
    map['is_settled'] = Variable<bool>(isSettled);
    if (!nullToAbsent || transactionId != null) {
      map['transaction_id'] = Variable<int>(transactionId);
    }
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  PeerDebtsCompanion toCompanion(bool nullToAbsent) {
    return PeerDebtsCompanion(
      id: Value(id),
      walletId: Value(walletId),
      uuid: Value(uuid),
      personName: Value(personName),
      type: Value(type),
      amount: Value(amount),
      note: note == null && nullToAbsent ? const Value.absent() : Value(note),
      date: Value(date),
      isSettled: Value(isSettled),
      transactionId: transactionId == null && nullToAbsent
          ? const Value.absent()
          : Value(transactionId),
      updatedAt: Value(updatedAt),
    );
  }

  factory PeerDebtDb.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return PeerDebtDb(
      id: serializer.fromJson<int>(json['id']),
      walletId: serializer.fromJson<int>(json['walletId']),
      uuid: serializer.fromJson<String>(json['uuid']),
      personName: serializer.fromJson<String>(json['personName']),
      type: $PeerDebtsTable.$convertertype.fromJson(
        serializer.fromJson<int>(json['type']),
      ),
      amount: serializer.fromJson<double>(json['amount']),
      note: serializer.fromJson<String?>(json['note']),
      date: serializer.fromJson<DateTime>(json['date']),
      isSettled: serializer.fromJson<bool>(json['isSettled']),
      transactionId: serializer.fromJson<int?>(json['transactionId']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'walletId': serializer.toJson<int>(walletId),
      'uuid': serializer.toJson<String>(uuid),
      'personName': serializer.toJson<String>(personName),
      'type': serializer.toJson<int>(
        $PeerDebtsTable.$convertertype.toJson(type),
      ),
      'amount': serializer.toJson<double>(amount),
      'note': serializer.toJson<String?>(note),
      'date': serializer.toJson<DateTime>(date),
      'isSettled': serializer.toJson<bool>(isSettled),
      'transactionId': serializer.toJson<int?>(transactionId),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  PeerDebtDb copyWith({
    int? id,
    int? walletId,
    String? uuid,
    String? personName,
    PeerDebtType? type,
    double? amount,
    Value<String?> note = const Value.absent(),
    DateTime? date,
    bool? isSettled,
    Value<int?> transactionId = const Value.absent(),
    DateTime? updatedAt,
  }) => PeerDebtDb(
    id: id ?? this.id,
    walletId: walletId ?? this.walletId,
    uuid: uuid ?? this.uuid,
    personName: personName ?? this.personName,
    type: type ?? this.type,
    amount: amount ?? this.amount,
    note: note.present ? note.value : this.note,
    date: date ?? this.date,
    isSettled: isSettled ?? this.isSettled,
    transactionId: transactionId.present
        ? transactionId.value
        : this.transactionId,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  PeerDebtDb copyWithCompanion(PeerDebtsCompanion data) {
    return PeerDebtDb(
      id: data.id.present ? data.id.value : this.id,
      walletId: data.walletId.present ? data.walletId.value : this.walletId,
      uuid: data.uuid.present ? data.uuid.value : this.uuid,
      personName: data.personName.present
          ? data.personName.value
          : this.personName,
      type: data.type.present ? data.type.value : this.type,
      amount: data.amount.present ? data.amount.value : this.amount,
      note: data.note.present ? data.note.value : this.note,
      date: data.date.present ? data.date.value : this.date,
      isSettled: data.isSettled.present ? data.isSettled.value : this.isSettled,
      transactionId: data.transactionId.present
          ? data.transactionId.value
          : this.transactionId,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('PeerDebtDb(')
          ..write('id: $id, ')
          ..write('walletId: $walletId, ')
          ..write('uuid: $uuid, ')
          ..write('personName: $personName, ')
          ..write('type: $type, ')
          ..write('amount: $amount, ')
          ..write('note: $note, ')
          ..write('date: $date, ')
          ..write('isSettled: $isSettled, ')
          ..write('transactionId: $transactionId, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    walletId,
    uuid,
    personName,
    type,
    amount,
    note,
    date,
    isSettled,
    transactionId,
    updatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is PeerDebtDb &&
          other.id == this.id &&
          other.walletId == this.walletId &&
          other.uuid == this.uuid &&
          other.personName == this.personName &&
          other.type == this.type &&
          other.amount == this.amount &&
          other.note == this.note &&
          other.date == this.date &&
          other.isSettled == this.isSettled &&
          other.transactionId == this.transactionId &&
          other.updatedAt == this.updatedAt);
}

class PeerDebtsCompanion extends UpdateCompanion<PeerDebtDb> {
  final Value<int> id;
  final Value<int> walletId;
  final Value<String> uuid;
  final Value<String> personName;
  final Value<PeerDebtType> type;
  final Value<double> amount;
  final Value<String?> note;
  final Value<DateTime> date;
  final Value<bool> isSettled;
  final Value<int?> transactionId;
  final Value<DateTime> updatedAt;
  const PeerDebtsCompanion({
    this.id = const Value.absent(),
    this.walletId = const Value.absent(),
    this.uuid = const Value.absent(),
    this.personName = const Value.absent(),
    this.type = const Value.absent(),
    this.amount = const Value.absent(),
    this.note = const Value.absent(),
    this.date = const Value.absent(),
    this.isSettled = const Value.absent(),
    this.transactionId = const Value.absent(),
    this.updatedAt = const Value.absent(),
  });
  PeerDebtsCompanion.insert({
    this.id = const Value.absent(),
    required int walletId,
    this.uuid = const Value.absent(),
    required String personName,
    required PeerDebtType type,
    required double amount,
    this.note = const Value.absent(),
    required DateTime date,
    this.isSettled = const Value.absent(),
    this.transactionId = const Value.absent(),
    this.updatedAt = const Value.absent(),
  }) : walletId = Value(walletId),
       personName = Value(personName),
       type = Value(type),
       amount = Value(amount),
       date = Value(date);
  static Insertable<PeerDebtDb> custom({
    Expression<int>? id,
    Expression<int>? walletId,
    Expression<String>? uuid,
    Expression<String>? personName,
    Expression<int>? type,
    Expression<int>? amount,
    Expression<String>? note,
    Expression<DateTime>? date,
    Expression<bool>? isSettled,
    Expression<int>? transactionId,
    Expression<DateTime>? updatedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (walletId != null) 'wallet_id': walletId,
      if (uuid != null) 'uuid': uuid,
      if (personName != null) 'person_name': personName,
      if (type != null) 'type': type,
      if (amount != null) 'amount': amount,
      if (note != null) 'note': note,
      if (date != null) 'date': date,
      if (isSettled != null) 'is_settled': isSettled,
      if (transactionId != null) 'transaction_id': transactionId,
      if (updatedAt != null) 'updated_at': updatedAt,
    });
  }

  PeerDebtsCompanion copyWith({
    Value<int>? id,
    Value<int>? walletId,
    Value<String>? uuid,
    Value<String>? personName,
    Value<PeerDebtType>? type,
    Value<double>? amount,
    Value<String?>? note,
    Value<DateTime>? date,
    Value<bool>? isSettled,
    Value<int?>? transactionId,
    Value<DateTime>? updatedAt,
  }) {
    return PeerDebtsCompanion(
      id: id ?? this.id,
      walletId: walletId ?? this.walletId,
      uuid: uuid ?? this.uuid,
      personName: personName ?? this.personName,
      type: type ?? this.type,
      amount: amount ?? this.amount,
      note: note ?? this.note,
      date: date ?? this.date,
      isSettled: isSettled ?? this.isSettled,
      transactionId: transactionId ?? this.transactionId,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (walletId.present) {
      map['wallet_id'] = Variable<int>(walletId.value);
    }
    if (uuid.present) {
      map['uuid'] = Variable<String>(uuid.value);
    }
    if (personName.present) {
      map['person_name'] = Variable<String>(personName.value);
    }
    if (type.present) {
      map['type'] = Variable<int>(
        $PeerDebtsTable.$convertertype.toSql(type.value),
      );
    }
    if (amount.present) {
      map['amount'] = Variable<int>(
        $PeerDebtsTable.$converteramount.toSql(amount.value),
      );
    }
    if (note.present) {
      map['note'] = Variable<String>(note.value);
    }
    if (date.present) {
      map['date'] = Variable<DateTime>(date.value);
    }
    if (isSettled.present) {
      map['is_settled'] = Variable<bool>(isSettled.value);
    }
    if (transactionId.present) {
      map['transaction_id'] = Variable<int>(transactionId.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PeerDebtsCompanion(')
          ..write('id: $id, ')
          ..write('walletId: $walletId, ')
          ..write('uuid: $uuid, ')
          ..write('personName: $personName, ')
          ..write('type: $type, ')
          ..write('amount: $amount, ')
          ..write('note: $note, ')
          ..write('date: $date, ')
          ..write('isSettled: $isSettled, ')
          ..write('transactionId: $transactionId, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }
}

class $WalletAllowancesTable extends WalletAllowances
    with TableInfo<$WalletAllowancesTable, WalletAllowance> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $WalletAllowancesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _walletIdMeta = const VerificationMeta(
    'walletId',
  );
  @override
  late final GeneratedColumn<int> walletId = GeneratedColumn<int>(
    'wallet_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _memberIdMeta = const VerificationMeta(
    'memberId',
  );
  @override
  late final GeneratedColumn<int> memberId = GeneratedColumn<int>(
    'member_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  @override
  late final GeneratedColumnWithTypeConverter<double, int> amount =
      GeneratedColumn<int>(
        'amount',
        aliasedName,
        false,
        type: DriftSqlType.int,
        requiredDuringInsert: true,
      ).withConverter<double>($WalletAllowancesTable.$converteramount);
  @override
  late final GeneratedColumnWithTypeConverter<WalletAllowanceFrequency, String>
  frequency =
      GeneratedColumn<String>(
        'frequency',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      ).withConverter<WalletAllowanceFrequency>(
        $WalletAllowancesTable.$converterfrequency,
      );
  static const VerificationMeta _startDateMeta = const VerificationMeta(
    'startDate',
  );
  @override
  late final GeneratedColumn<DateTime> startDate = GeneratedColumn<DateTime>(
    'start_date',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _endDateMeta = const VerificationMeta(
    'endDate',
  );
  @override
  late final GeneratedColumn<DateTime> endDate = GeneratedColumn<DateTime>(
    'end_date',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _isActiveMeta = const VerificationMeta(
    'isActive',
  );
  @override
  late final GeneratedColumn<bool> isActive = GeneratedColumn<bool>(
    'is_active',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_active" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
  );
  static const VerificationMeta _createdByAccountIdMeta =
      const VerificationMeta('createdByAccountId');
  @override
  late final GeneratedColumn<int> createdByAccountId = GeneratedColumn<int>(
    'created_by_account_id',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _updatedByAccountIdMeta =
      const VerificationMeta('updatedByAccountId');
  @override
  late final GeneratedColumn<int> updatedByAccountId = GeneratedColumn<int>(
    'updated_by_account_id',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    clientDefault: () => DateTime.now(),
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    clientDefault: () => DateTime.now(),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    walletId,
    memberId,
    amount,
    frequency,
    startDate,
    endDate,
    isActive,
    createdByAccountId,
    updatedByAccountId,
    createdAt,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'wallet_allowances';
  @override
  VerificationContext validateIntegrity(
    Insertable<WalletAllowance> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('wallet_id')) {
      context.handle(
        _walletIdMeta,
        walletId.isAcceptableOrUnknown(data['wallet_id']!, _walletIdMeta),
      );
    } else if (isInserting) {
      context.missing(_walletIdMeta);
    }
    if (data.containsKey('member_id')) {
      context.handle(
        _memberIdMeta,
        memberId.isAcceptableOrUnknown(data['member_id']!, _memberIdMeta),
      );
    } else if (isInserting) {
      context.missing(_memberIdMeta);
    }
    if (data.containsKey('start_date')) {
      context.handle(
        _startDateMeta,
        startDate.isAcceptableOrUnknown(data['start_date']!, _startDateMeta),
      );
    } else if (isInserting) {
      context.missing(_startDateMeta);
    }
    if (data.containsKey('end_date')) {
      context.handle(
        _endDateMeta,
        endDate.isAcceptableOrUnknown(data['end_date']!, _endDateMeta),
      );
    }
    if (data.containsKey('is_active')) {
      context.handle(
        _isActiveMeta,
        isActive.isAcceptableOrUnknown(data['is_active']!, _isActiveMeta),
      );
    }
    if (data.containsKey('created_by_account_id')) {
      context.handle(
        _createdByAccountIdMeta,
        createdByAccountId.isAcceptableOrUnknown(
          data['created_by_account_id']!,
          _createdByAccountIdMeta,
        ),
      );
    }
    if (data.containsKey('updated_by_account_id')) {
      context.handle(
        _updatedByAccountIdMeta,
        updatedByAccountId.isAcceptableOrUnknown(
          data['updated_by_account_id']!,
          _updatedByAccountIdMeta,
        ),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  WalletAllowance map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return WalletAllowance(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      walletId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}wallet_id'],
      )!,
      memberId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}member_id'],
      )!,
      amount: $WalletAllowancesTable.$converteramount.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.int,
          data['${effectivePrefix}amount'],
        )!,
      ),
      frequency: $WalletAllowancesTable.$converterfrequency.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}frequency'],
        )!,
      ),
      startDate: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}start_date'],
      )!,
      endDate: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}end_date'],
      ),
      isActive: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_active'],
      )!,
      createdByAccountId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}created_by_account_id'],
      ),
      updatedByAccountId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}updated_by_account_id'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $WalletAllowancesTable createAlias(String alias) {
    return $WalletAllowancesTable(attachedDatabase, alias);
  }

  static TypeConverter<double, int> $converteramount = const MoneyConverter();
  static JsonTypeConverter2<WalletAllowanceFrequency, String, String>
  $converterfrequency = const EnumNameConverter(
    WalletAllowanceFrequency.values,
  );
}

class WalletAllowance extends DataClass implements Insertable<WalletAllowance> {
  final int id;
  final int walletId;
  final int memberId;
  final double amount;
  final WalletAllowanceFrequency frequency;
  final DateTime startDate;
  final DateTime? endDate;
  final bool isActive;
  final int? createdByAccountId;
  final int? updatedByAccountId;
  final DateTime createdAt;
  final DateTime updatedAt;
  const WalletAllowance({
    required this.id,
    required this.walletId,
    required this.memberId,
    required this.amount,
    required this.frequency,
    required this.startDate,
    this.endDate,
    required this.isActive,
    this.createdByAccountId,
    this.updatedByAccountId,
    required this.createdAt,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['wallet_id'] = Variable<int>(walletId);
    map['member_id'] = Variable<int>(memberId);
    {
      map['amount'] = Variable<int>(
        $WalletAllowancesTable.$converteramount.toSql(amount),
      );
    }
    {
      map['frequency'] = Variable<String>(
        $WalletAllowancesTable.$converterfrequency.toSql(frequency),
      );
    }
    map['start_date'] = Variable<DateTime>(startDate);
    if (!nullToAbsent || endDate != null) {
      map['end_date'] = Variable<DateTime>(endDate);
    }
    map['is_active'] = Variable<bool>(isActive);
    if (!nullToAbsent || createdByAccountId != null) {
      map['created_by_account_id'] = Variable<int>(createdByAccountId);
    }
    if (!nullToAbsent || updatedByAccountId != null) {
      map['updated_by_account_id'] = Variable<int>(updatedByAccountId);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  WalletAllowancesCompanion toCompanion(bool nullToAbsent) {
    return WalletAllowancesCompanion(
      id: Value(id),
      walletId: Value(walletId),
      memberId: Value(memberId),
      amount: Value(amount),
      frequency: Value(frequency),
      startDate: Value(startDate),
      endDate: endDate == null && nullToAbsent
          ? const Value.absent()
          : Value(endDate),
      isActive: Value(isActive),
      createdByAccountId: createdByAccountId == null && nullToAbsent
          ? const Value.absent()
          : Value(createdByAccountId),
      updatedByAccountId: updatedByAccountId == null && nullToAbsent
          ? const Value.absent()
          : Value(updatedByAccountId),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory WalletAllowance.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return WalletAllowance(
      id: serializer.fromJson<int>(json['id']),
      walletId: serializer.fromJson<int>(json['walletId']),
      memberId: serializer.fromJson<int>(json['memberId']),
      amount: serializer.fromJson<double>(json['amount']),
      frequency: $WalletAllowancesTable.$converterfrequency.fromJson(
        serializer.fromJson<String>(json['frequency']),
      ),
      startDate: serializer.fromJson<DateTime>(json['startDate']),
      endDate: serializer.fromJson<DateTime?>(json['endDate']),
      isActive: serializer.fromJson<bool>(json['isActive']),
      createdByAccountId: serializer.fromJson<int?>(json['createdByAccountId']),
      updatedByAccountId: serializer.fromJson<int?>(json['updatedByAccountId']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'walletId': serializer.toJson<int>(walletId),
      'memberId': serializer.toJson<int>(memberId),
      'amount': serializer.toJson<double>(amount),
      'frequency': serializer.toJson<String>(
        $WalletAllowancesTable.$converterfrequency.toJson(frequency),
      ),
      'startDate': serializer.toJson<DateTime>(startDate),
      'endDate': serializer.toJson<DateTime?>(endDate),
      'isActive': serializer.toJson<bool>(isActive),
      'createdByAccountId': serializer.toJson<int?>(createdByAccountId),
      'updatedByAccountId': serializer.toJson<int?>(updatedByAccountId),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  WalletAllowance copyWith({
    int? id,
    int? walletId,
    int? memberId,
    double? amount,
    WalletAllowanceFrequency? frequency,
    DateTime? startDate,
    Value<DateTime?> endDate = const Value.absent(),
    bool? isActive,
    Value<int?> createdByAccountId = const Value.absent(),
    Value<int?> updatedByAccountId = const Value.absent(),
    DateTime? createdAt,
    DateTime? updatedAt,
  }) => WalletAllowance(
    id: id ?? this.id,
    walletId: walletId ?? this.walletId,
    memberId: memberId ?? this.memberId,
    amount: amount ?? this.amount,
    frequency: frequency ?? this.frequency,
    startDate: startDate ?? this.startDate,
    endDate: endDate.present ? endDate.value : this.endDate,
    isActive: isActive ?? this.isActive,
    createdByAccountId: createdByAccountId.present
        ? createdByAccountId.value
        : this.createdByAccountId,
    updatedByAccountId: updatedByAccountId.present
        ? updatedByAccountId.value
        : this.updatedByAccountId,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  WalletAllowance copyWithCompanion(WalletAllowancesCompanion data) {
    return WalletAllowance(
      id: data.id.present ? data.id.value : this.id,
      walletId: data.walletId.present ? data.walletId.value : this.walletId,
      memberId: data.memberId.present ? data.memberId.value : this.memberId,
      amount: data.amount.present ? data.amount.value : this.amount,
      frequency: data.frequency.present ? data.frequency.value : this.frequency,
      startDate: data.startDate.present ? data.startDate.value : this.startDate,
      endDate: data.endDate.present ? data.endDate.value : this.endDate,
      isActive: data.isActive.present ? data.isActive.value : this.isActive,
      createdByAccountId: data.createdByAccountId.present
          ? data.createdByAccountId.value
          : this.createdByAccountId,
      updatedByAccountId: data.updatedByAccountId.present
          ? data.updatedByAccountId.value
          : this.updatedByAccountId,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('WalletAllowance(')
          ..write('id: $id, ')
          ..write('walletId: $walletId, ')
          ..write('memberId: $memberId, ')
          ..write('amount: $amount, ')
          ..write('frequency: $frequency, ')
          ..write('startDate: $startDate, ')
          ..write('endDate: $endDate, ')
          ..write('isActive: $isActive, ')
          ..write('createdByAccountId: $createdByAccountId, ')
          ..write('updatedByAccountId: $updatedByAccountId, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    walletId,
    memberId,
    amount,
    frequency,
    startDate,
    endDate,
    isActive,
    createdByAccountId,
    updatedByAccountId,
    createdAt,
    updatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is WalletAllowance &&
          other.id == this.id &&
          other.walletId == this.walletId &&
          other.memberId == this.memberId &&
          other.amount == this.amount &&
          other.frequency == this.frequency &&
          other.startDate == this.startDate &&
          other.endDate == this.endDate &&
          other.isActive == this.isActive &&
          other.createdByAccountId == this.createdByAccountId &&
          other.updatedByAccountId == this.updatedByAccountId &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class WalletAllowancesCompanion extends UpdateCompanion<WalletAllowance> {
  final Value<int> id;
  final Value<int> walletId;
  final Value<int> memberId;
  final Value<double> amount;
  final Value<WalletAllowanceFrequency> frequency;
  final Value<DateTime> startDate;
  final Value<DateTime?> endDate;
  final Value<bool> isActive;
  final Value<int?> createdByAccountId;
  final Value<int?> updatedByAccountId;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  const WalletAllowancesCompanion({
    this.id = const Value.absent(),
    this.walletId = const Value.absent(),
    this.memberId = const Value.absent(),
    this.amount = const Value.absent(),
    this.frequency = const Value.absent(),
    this.startDate = const Value.absent(),
    this.endDate = const Value.absent(),
    this.isActive = const Value.absent(),
    this.createdByAccountId = const Value.absent(),
    this.updatedByAccountId = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  });
  WalletAllowancesCompanion.insert({
    this.id = const Value.absent(),
    required int walletId,
    required int memberId,
    required double amount,
    required WalletAllowanceFrequency frequency,
    required DateTime startDate,
    this.endDate = const Value.absent(),
    this.isActive = const Value.absent(),
    this.createdByAccountId = const Value.absent(),
    this.updatedByAccountId = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  }) : walletId = Value(walletId),
       memberId = Value(memberId),
       amount = Value(amount),
       frequency = Value(frequency),
       startDate = Value(startDate);
  static Insertable<WalletAllowance> custom({
    Expression<int>? id,
    Expression<int>? walletId,
    Expression<int>? memberId,
    Expression<int>? amount,
    Expression<String>? frequency,
    Expression<DateTime>? startDate,
    Expression<DateTime>? endDate,
    Expression<bool>? isActive,
    Expression<int>? createdByAccountId,
    Expression<int>? updatedByAccountId,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (walletId != null) 'wallet_id': walletId,
      if (memberId != null) 'member_id': memberId,
      if (amount != null) 'amount': amount,
      if (frequency != null) 'frequency': frequency,
      if (startDate != null) 'start_date': startDate,
      if (endDate != null) 'end_date': endDate,
      if (isActive != null) 'is_active': isActive,
      if (createdByAccountId != null)
        'created_by_account_id': createdByAccountId,
      if (updatedByAccountId != null)
        'updated_by_account_id': updatedByAccountId,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
    });
  }

  WalletAllowancesCompanion copyWith({
    Value<int>? id,
    Value<int>? walletId,
    Value<int>? memberId,
    Value<double>? amount,
    Value<WalletAllowanceFrequency>? frequency,
    Value<DateTime>? startDate,
    Value<DateTime?>? endDate,
    Value<bool>? isActive,
    Value<int?>? createdByAccountId,
    Value<int?>? updatedByAccountId,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
  }) {
    return WalletAllowancesCompanion(
      id: id ?? this.id,
      walletId: walletId ?? this.walletId,
      memberId: memberId ?? this.memberId,
      amount: amount ?? this.amount,
      frequency: frequency ?? this.frequency,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      isActive: isActive ?? this.isActive,
      createdByAccountId: createdByAccountId ?? this.createdByAccountId,
      updatedByAccountId: updatedByAccountId ?? this.updatedByAccountId,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (walletId.present) {
      map['wallet_id'] = Variable<int>(walletId.value);
    }
    if (memberId.present) {
      map['member_id'] = Variable<int>(memberId.value);
    }
    if (amount.present) {
      map['amount'] = Variable<int>(
        $WalletAllowancesTable.$converteramount.toSql(amount.value),
      );
    }
    if (frequency.present) {
      map['frequency'] = Variable<String>(
        $WalletAllowancesTable.$converterfrequency.toSql(frequency.value),
      );
    }
    if (startDate.present) {
      map['start_date'] = Variable<DateTime>(startDate.value);
    }
    if (endDate.present) {
      map['end_date'] = Variable<DateTime>(endDate.value);
    }
    if (isActive.present) {
      map['is_active'] = Variable<bool>(isActive.value);
    }
    if (createdByAccountId.present) {
      map['created_by_account_id'] = Variable<int>(createdByAccountId.value);
    }
    if (updatedByAccountId.present) {
      map['updated_by_account_id'] = Variable<int>(updatedByAccountId.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('WalletAllowancesCompanion(')
          ..write('id: $id, ')
          ..write('walletId: $walletId, ')
          ..write('memberId: $memberId, ')
          ..write('amount: $amount, ')
          ..write('frequency: $frequency, ')
          ..write('startDate: $startDate, ')
          ..write('endDate: $endDate, ')
          ..write('isActive: $isActive, ')
          ..write('createdByAccountId: $createdByAccountId, ')
          ..write('updatedByAccountId: $updatedByAccountId, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }
}

class $WalletAllowancePaymentsTable extends WalletAllowancePayments
    with TableInfo<$WalletAllowancePaymentsTable, WalletAllowancePayment> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $WalletAllowancePaymentsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _allowanceIdMeta = const VerificationMeta(
    'allowanceId',
  );
  @override
  late final GeneratedColumn<int> allowanceId = GeneratedColumn<int>(
    'allowance_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _memberIdMeta = const VerificationMeta(
    'memberId',
  );
  @override
  late final GeneratedColumn<int> memberId = GeneratedColumn<int>(
    'member_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  @override
  late final GeneratedColumnWithTypeConverter<double, int> amount =
      GeneratedColumn<int>(
        'amount',
        aliasedName,
        false,
        type: DriftSqlType.int,
        requiredDuringInsert: true,
      ).withConverter<double>($WalletAllowancePaymentsTable.$converteramount);
  static const VerificationMeta _paidDateMeta = const VerificationMeta(
    'paidDate',
  );
  @override
  late final GeneratedColumn<DateTime> paidDate = GeneratedColumn<DateTime>(
    'paid_date',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    clientDefault: () => DateTime.now(),
  );
  static const VerificationMeta _notesMeta = const VerificationMeta('notes');
  @override
  late final GeneratedColumn<String> notes = GeneratedColumn<String>(
    'notes',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    allowanceId,
    memberId,
    amount,
    paidDate,
    notes,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'wallet_allowance_payments';
  @override
  VerificationContext validateIntegrity(
    Insertable<WalletAllowancePayment> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('allowance_id')) {
      context.handle(
        _allowanceIdMeta,
        allowanceId.isAcceptableOrUnknown(
          data['allowance_id']!,
          _allowanceIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_allowanceIdMeta);
    }
    if (data.containsKey('member_id')) {
      context.handle(
        _memberIdMeta,
        memberId.isAcceptableOrUnknown(data['member_id']!, _memberIdMeta),
      );
    } else if (isInserting) {
      context.missing(_memberIdMeta);
    }
    if (data.containsKey('paid_date')) {
      context.handle(
        _paidDateMeta,
        paidDate.isAcceptableOrUnknown(data['paid_date']!, _paidDateMeta),
      );
    }
    if (data.containsKey('notes')) {
      context.handle(
        _notesMeta,
        notes.isAcceptableOrUnknown(data['notes']!, _notesMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  WalletAllowancePayment map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return WalletAllowancePayment(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      allowanceId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}allowance_id'],
      )!,
      memberId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}member_id'],
      )!,
      amount: $WalletAllowancePaymentsTable.$converteramount.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.int,
          data['${effectivePrefix}amount'],
        )!,
      ),
      paidDate: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}paid_date'],
      )!,
      notes: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}notes'],
      ),
    );
  }

  @override
  $WalletAllowancePaymentsTable createAlias(String alias) {
    return $WalletAllowancePaymentsTable(attachedDatabase, alias);
  }

  static TypeConverter<double, int> $converteramount = const MoneyConverter();
}

class WalletAllowancePayment extends DataClass
    implements Insertable<WalletAllowancePayment> {
  final int id;
  final int allowanceId;
  final int memberId;
  final double amount;
  final DateTime paidDate;
  final String? notes;
  const WalletAllowancePayment({
    required this.id,
    required this.allowanceId,
    required this.memberId,
    required this.amount,
    required this.paidDate,
    this.notes,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['allowance_id'] = Variable<int>(allowanceId);
    map['member_id'] = Variable<int>(memberId);
    {
      map['amount'] = Variable<int>(
        $WalletAllowancePaymentsTable.$converteramount.toSql(amount),
      );
    }
    map['paid_date'] = Variable<DateTime>(paidDate);
    if (!nullToAbsent || notes != null) {
      map['notes'] = Variable<String>(notes);
    }
    return map;
  }

  WalletAllowancePaymentsCompanion toCompanion(bool nullToAbsent) {
    return WalletAllowancePaymentsCompanion(
      id: Value(id),
      allowanceId: Value(allowanceId),
      memberId: Value(memberId),
      amount: Value(amount),
      paidDate: Value(paidDate),
      notes: notes == null && nullToAbsent
          ? const Value.absent()
          : Value(notes),
    );
  }

  factory WalletAllowancePayment.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return WalletAllowancePayment(
      id: serializer.fromJson<int>(json['id']),
      allowanceId: serializer.fromJson<int>(json['allowanceId']),
      memberId: serializer.fromJson<int>(json['memberId']),
      amount: serializer.fromJson<double>(json['amount']),
      paidDate: serializer.fromJson<DateTime>(json['paidDate']),
      notes: serializer.fromJson<String?>(json['notes']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'allowanceId': serializer.toJson<int>(allowanceId),
      'memberId': serializer.toJson<int>(memberId),
      'amount': serializer.toJson<double>(amount),
      'paidDate': serializer.toJson<DateTime>(paidDate),
      'notes': serializer.toJson<String?>(notes),
    };
  }

  WalletAllowancePayment copyWith({
    int? id,
    int? allowanceId,
    int? memberId,
    double? amount,
    DateTime? paidDate,
    Value<String?> notes = const Value.absent(),
  }) => WalletAllowancePayment(
    id: id ?? this.id,
    allowanceId: allowanceId ?? this.allowanceId,
    memberId: memberId ?? this.memberId,
    amount: amount ?? this.amount,
    paidDate: paidDate ?? this.paidDate,
    notes: notes.present ? notes.value : this.notes,
  );
  WalletAllowancePayment copyWithCompanion(
    WalletAllowancePaymentsCompanion data,
  ) {
    return WalletAllowancePayment(
      id: data.id.present ? data.id.value : this.id,
      allowanceId: data.allowanceId.present
          ? data.allowanceId.value
          : this.allowanceId,
      memberId: data.memberId.present ? data.memberId.value : this.memberId,
      amount: data.amount.present ? data.amount.value : this.amount,
      paidDate: data.paidDate.present ? data.paidDate.value : this.paidDate,
      notes: data.notes.present ? data.notes.value : this.notes,
    );
  }

  @override
  String toString() {
    return (StringBuffer('WalletAllowancePayment(')
          ..write('id: $id, ')
          ..write('allowanceId: $allowanceId, ')
          ..write('memberId: $memberId, ')
          ..write('amount: $amount, ')
          ..write('paidDate: $paidDate, ')
          ..write('notes: $notes')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, allowanceId, memberId, amount, paidDate, notes);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is WalletAllowancePayment &&
          other.id == this.id &&
          other.allowanceId == this.allowanceId &&
          other.memberId == this.memberId &&
          other.amount == this.amount &&
          other.paidDate == this.paidDate &&
          other.notes == this.notes);
}

class WalletAllowancePaymentsCompanion
    extends UpdateCompanion<WalletAllowancePayment> {
  final Value<int> id;
  final Value<int> allowanceId;
  final Value<int> memberId;
  final Value<double> amount;
  final Value<DateTime> paidDate;
  final Value<String?> notes;
  const WalletAllowancePaymentsCompanion({
    this.id = const Value.absent(),
    this.allowanceId = const Value.absent(),
    this.memberId = const Value.absent(),
    this.amount = const Value.absent(),
    this.paidDate = const Value.absent(),
    this.notes = const Value.absent(),
  });
  WalletAllowancePaymentsCompanion.insert({
    this.id = const Value.absent(),
    required int allowanceId,
    required int memberId,
    required double amount,
    this.paidDate = const Value.absent(),
    this.notes = const Value.absent(),
  }) : allowanceId = Value(allowanceId),
       memberId = Value(memberId),
       amount = Value(amount);
  static Insertable<WalletAllowancePayment> custom({
    Expression<int>? id,
    Expression<int>? allowanceId,
    Expression<int>? memberId,
    Expression<int>? amount,
    Expression<DateTime>? paidDate,
    Expression<String>? notes,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (allowanceId != null) 'allowance_id': allowanceId,
      if (memberId != null) 'member_id': memberId,
      if (amount != null) 'amount': amount,
      if (paidDate != null) 'paid_date': paidDate,
      if (notes != null) 'notes': notes,
    });
  }

  WalletAllowancePaymentsCompanion copyWith({
    Value<int>? id,
    Value<int>? allowanceId,
    Value<int>? memberId,
    Value<double>? amount,
    Value<DateTime>? paidDate,
    Value<String?>? notes,
  }) {
    return WalletAllowancePaymentsCompanion(
      id: id ?? this.id,
      allowanceId: allowanceId ?? this.allowanceId,
      memberId: memberId ?? this.memberId,
      amount: amount ?? this.amount,
      paidDate: paidDate ?? this.paidDate,
      notes: notes ?? this.notes,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (allowanceId.present) {
      map['allowance_id'] = Variable<int>(allowanceId.value);
    }
    if (memberId.present) {
      map['member_id'] = Variable<int>(memberId.value);
    }
    if (amount.present) {
      map['amount'] = Variable<int>(
        $WalletAllowancePaymentsTable.$converteramount.toSql(amount.value),
      );
    }
    if (paidDate.present) {
      map['paid_date'] = Variable<DateTime>(paidDate.value);
    }
    if (notes.present) {
      map['notes'] = Variable<String>(notes.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('WalletAllowancePaymentsCompanion(')
          ..write('id: $id, ')
          ..write('allowanceId: $allowanceId, ')
          ..write('memberId: $memberId, ')
          ..write('amount: $amount, ')
          ..write('paidDate: $paidDate, ')
          ..write('notes: $notes')
          ..write(')'))
        .toString();
  }
}

class $WalletSettlementsTable extends WalletSettlements
    with TableInfo<$WalletSettlementsTable, WalletSettlement> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $WalletSettlementsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _walletIdMeta = const VerificationMeta(
    'walletId',
  );
  @override
  late final GeneratedColumn<int> walletId = GeneratedColumn<int>(
    'wallet_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _uuidMeta = const VerificationMeta('uuid');
  @override
  late final GeneratedColumn<String> uuid = GeneratedColumn<String>(
    'uuid',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    clientDefault: () => const Uuid().v4(),
  );
  static const VerificationMeta _payerMemberIdMeta = const VerificationMeta(
    'payerMemberId',
  );
  @override
  late final GeneratedColumn<int> payerMemberId = GeneratedColumn<int>(
    'payer_member_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _receiverMemberIdMeta = const VerificationMeta(
    'receiverMemberId',
  );
  @override
  late final GeneratedColumn<int> receiverMemberId = GeneratedColumn<int>(
    'receiver_member_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  @override
  late final GeneratedColumnWithTypeConverter<double, int> amount =
      GeneratedColumn<int>(
        'amount',
        aliasedName,
        false,
        type: DriftSqlType.int,
        requiredDuringInsert: true,
      ).withConverter<double>($WalletSettlementsTable.$converteramount);
  static const VerificationMeta _settlementDateMeta = const VerificationMeta(
    'settlementDate',
  );
  @override
  late final GeneratedColumn<DateTime> settlementDate =
      GeneratedColumn<DateTime>(
        'settlement_date',
        aliasedName,
        false,
        type: DriftSqlType.dateTime,
        requiredDuringInsert: false,
        clientDefault: () => DateTime.now(),
      );
  static const VerificationMeta _notesMeta = const VerificationMeta('notes');
  @override
  late final GeneratedColumn<String> notes = GeneratedColumn<String>(
    'notes',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _createdByAccountIdMeta =
      const VerificationMeta('createdByAccountId');
  @override
  late final GeneratedColumn<int> createdByAccountId = GeneratedColumn<int>(
    'created_by_account_id',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    clientDefault: () => DateTime.now(),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    walletId,
    uuid,
    payerMemberId,
    receiverMemberId,
    amount,
    settlementDate,
    notes,
    createdByAccountId,
    createdAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'wallet_settlements';
  @override
  VerificationContext validateIntegrity(
    Insertable<WalletSettlement> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('wallet_id')) {
      context.handle(
        _walletIdMeta,
        walletId.isAcceptableOrUnknown(data['wallet_id']!, _walletIdMeta),
      );
    } else if (isInserting) {
      context.missing(_walletIdMeta);
    }
    if (data.containsKey('uuid')) {
      context.handle(
        _uuidMeta,
        uuid.isAcceptableOrUnknown(data['uuid']!, _uuidMeta),
      );
    }
    if (data.containsKey('payer_member_id')) {
      context.handle(
        _payerMemberIdMeta,
        payerMemberId.isAcceptableOrUnknown(
          data['payer_member_id']!,
          _payerMemberIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_payerMemberIdMeta);
    }
    if (data.containsKey('receiver_member_id')) {
      context.handle(
        _receiverMemberIdMeta,
        receiverMemberId.isAcceptableOrUnknown(
          data['receiver_member_id']!,
          _receiverMemberIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_receiverMemberIdMeta);
    }
    if (data.containsKey('settlement_date')) {
      context.handle(
        _settlementDateMeta,
        settlementDate.isAcceptableOrUnknown(
          data['settlement_date']!,
          _settlementDateMeta,
        ),
      );
    }
    if (data.containsKey('notes')) {
      context.handle(
        _notesMeta,
        notes.isAcceptableOrUnknown(data['notes']!, _notesMeta),
      );
    }
    if (data.containsKey('created_by_account_id')) {
      context.handle(
        _createdByAccountIdMeta,
        createdByAccountId.isAcceptableOrUnknown(
          data['created_by_account_id']!,
          _createdByAccountIdMeta,
        ),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  WalletSettlement map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return WalletSettlement(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      walletId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}wallet_id'],
      )!,
      uuid: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}uuid'],
      )!,
      payerMemberId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}payer_member_id'],
      )!,
      receiverMemberId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}receiver_member_id'],
      )!,
      amount: $WalletSettlementsTable.$converteramount.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.int,
          data['${effectivePrefix}amount'],
        )!,
      ),
      settlementDate: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}settlement_date'],
      )!,
      notes: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}notes'],
      ),
      createdByAccountId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}created_by_account_id'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $WalletSettlementsTable createAlias(String alias) {
    return $WalletSettlementsTable(attachedDatabase, alias);
  }

  static TypeConverter<double, int> $converteramount = const MoneyConverter();
}

class WalletSettlement extends DataClass
    implements Insertable<WalletSettlement> {
  final int id;
  final int walletId;
  final String uuid;
  final int payerMemberId;
  final int receiverMemberId;
  final double amount;
  final DateTime settlementDate;
  final String? notes;
  final int? createdByAccountId;
  final DateTime createdAt;
  const WalletSettlement({
    required this.id,
    required this.walletId,
    required this.uuid,
    required this.payerMemberId,
    required this.receiverMemberId,
    required this.amount,
    required this.settlementDate,
    this.notes,
    this.createdByAccountId,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['wallet_id'] = Variable<int>(walletId);
    map['uuid'] = Variable<String>(uuid);
    map['payer_member_id'] = Variable<int>(payerMemberId);
    map['receiver_member_id'] = Variable<int>(receiverMemberId);
    {
      map['amount'] = Variable<int>(
        $WalletSettlementsTable.$converteramount.toSql(amount),
      );
    }
    map['settlement_date'] = Variable<DateTime>(settlementDate);
    if (!nullToAbsent || notes != null) {
      map['notes'] = Variable<String>(notes);
    }
    if (!nullToAbsent || createdByAccountId != null) {
      map['created_by_account_id'] = Variable<int>(createdByAccountId);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  WalletSettlementsCompanion toCompanion(bool nullToAbsent) {
    return WalletSettlementsCompanion(
      id: Value(id),
      walletId: Value(walletId),
      uuid: Value(uuid),
      payerMemberId: Value(payerMemberId),
      receiverMemberId: Value(receiverMemberId),
      amount: Value(amount),
      settlementDate: Value(settlementDate),
      notes: notes == null && nullToAbsent
          ? const Value.absent()
          : Value(notes),
      createdByAccountId: createdByAccountId == null && nullToAbsent
          ? const Value.absent()
          : Value(createdByAccountId),
      createdAt: Value(createdAt),
    );
  }

  factory WalletSettlement.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return WalletSettlement(
      id: serializer.fromJson<int>(json['id']),
      walletId: serializer.fromJson<int>(json['walletId']),
      uuid: serializer.fromJson<String>(json['uuid']),
      payerMemberId: serializer.fromJson<int>(json['payerMemberId']),
      receiverMemberId: serializer.fromJson<int>(json['receiverMemberId']),
      amount: serializer.fromJson<double>(json['amount']),
      settlementDate: serializer.fromJson<DateTime>(json['settlementDate']),
      notes: serializer.fromJson<String?>(json['notes']),
      createdByAccountId: serializer.fromJson<int?>(json['createdByAccountId']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'walletId': serializer.toJson<int>(walletId),
      'uuid': serializer.toJson<String>(uuid),
      'payerMemberId': serializer.toJson<int>(payerMemberId),
      'receiverMemberId': serializer.toJson<int>(receiverMemberId),
      'amount': serializer.toJson<double>(amount),
      'settlementDate': serializer.toJson<DateTime>(settlementDate),
      'notes': serializer.toJson<String?>(notes),
      'createdByAccountId': serializer.toJson<int?>(createdByAccountId),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  WalletSettlement copyWith({
    int? id,
    int? walletId,
    String? uuid,
    int? payerMemberId,
    int? receiverMemberId,
    double? amount,
    DateTime? settlementDate,
    Value<String?> notes = const Value.absent(),
    Value<int?> createdByAccountId = const Value.absent(),
    DateTime? createdAt,
  }) => WalletSettlement(
    id: id ?? this.id,
    walletId: walletId ?? this.walletId,
    uuid: uuid ?? this.uuid,
    payerMemberId: payerMemberId ?? this.payerMemberId,
    receiverMemberId: receiverMemberId ?? this.receiverMemberId,
    amount: amount ?? this.amount,
    settlementDate: settlementDate ?? this.settlementDate,
    notes: notes.present ? notes.value : this.notes,
    createdByAccountId: createdByAccountId.present
        ? createdByAccountId.value
        : this.createdByAccountId,
    createdAt: createdAt ?? this.createdAt,
  );
  WalletSettlement copyWithCompanion(WalletSettlementsCompanion data) {
    return WalletSettlement(
      id: data.id.present ? data.id.value : this.id,
      walletId: data.walletId.present ? data.walletId.value : this.walletId,
      uuid: data.uuid.present ? data.uuid.value : this.uuid,
      payerMemberId: data.payerMemberId.present
          ? data.payerMemberId.value
          : this.payerMemberId,
      receiverMemberId: data.receiverMemberId.present
          ? data.receiverMemberId.value
          : this.receiverMemberId,
      amount: data.amount.present ? data.amount.value : this.amount,
      settlementDate: data.settlementDate.present
          ? data.settlementDate.value
          : this.settlementDate,
      notes: data.notes.present ? data.notes.value : this.notes,
      createdByAccountId: data.createdByAccountId.present
          ? data.createdByAccountId.value
          : this.createdByAccountId,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('WalletSettlement(')
          ..write('id: $id, ')
          ..write('walletId: $walletId, ')
          ..write('uuid: $uuid, ')
          ..write('payerMemberId: $payerMemberId, ')
          ..write('receiverMemberId: $receiverMemberId, ')
          ..write('amount: $amount, ')
          ..write('settlementDate: $settlementDate, ')
          ..write('notes: $notes, ')
          ..write('createdByAccountId: $createdByAccountId, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    walletId,
    uuid,
    payerMemberId,
    receiverMemberId,
    amount,
    settlementDate,
    notes,
    createdByAccountId,
    createdAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is WalletSettlement &&
          other.id == this.id &&
          other.walletId == this.walletId &&
          other.uuid == this.uuid &&
          other.payerMemberId == this.payerMemberId &&
          other.receiverMemberId == this.receiverMemberId &&
          other.amount == this.amount &&
          other.settlementDate == this.settlementDate &&
          other.notes == this.notes &&
          other.createdByAccountId == this.createdByAccountId &&
          other.createdAt == this.createdAt);
}

class WalletSettlementsCompanion extends UpdateCompanion<WalletSettlement> {
  final Value<int> id;
  final Value<int> walletId;
  final Value<String> uuid;
  final Value<int> payerMemberId;
  final Value<int> receiverMemberId;
  final Value<double> amount;
  final Value<DateTime> settlementDate;
  final Value<String?> notes;
  final Value<int?> createdByAccountId;
  final Value<DateTime> createdAt;
  const WalletSettlementsCompanion({
    this.id = const Value.absent(),
    this.walletId = const Value.absent(),
    this.uuid = const Value.absent(),
    this.payerMemberId = const Value.absent(),
    this.receiverMemberId = const Value.absent(),
    this.amount = const Value.absent(),
    this.settlementDate = const Value.absent(),
    this.notes = const Value.absent(),
    this.createdByAccountId = const Value.absent(),
    this.createdAt = const Value.absent(),
  });
  WalletSettlementsCompanion.insert({
    this.id = const Value.absent(),
    required int walletId,
    this.uuid = const Value.absent(),
    required int payerMemberId,
    required int receiverMemberId,
    required double amount,
    this.settlementDate = const Value.absent(),
    this.notes = const Value.absent(),
    this.createdByAccountId = const Value.absent(),
    this.createdAt = const Value.absent(),
  }) : walletId = Value(walletId),
       payerMemberId = Value(payerMemberId),
       receiverMemberId = Value(receiverMemberId),
       amount = Value(amount);
  static Insertable<WalletSettlement> custom({
    Expression<int>? id,
    Expression<int>? walletId,
    Expression<String>? uuid,
    Expression<int>? payerMemberId,
    Expression<int>? receiverMemberId,
    Expression<int>? amount,
    Expression<DateTime>? settlementDate,
    Expression<String>? notes,
    Expression<int>? createdByAccountId,
    Expression<DateTime>? createdAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (walletId != null) 'wallet_id': walletId,
      if (uuid != null) 'uuid': uuid,
      if (payerMemberId != null) 'payer_member_id': payerMemberId,
      if (receiverMemberId != null) 'receiver_member_id': receiverMemberId,
      if (amount != null) 'amount': amount,
      if (settlementDate != null) 'settlement_date': settlementDate,
      if (notes != null) 'notes': notes,
      if (createdByAccountId != null)
        'created_by_account_id': createdByAccountId,
      if (createdAt != null) 'created_at': createdAt,
    });
  }

  WalletSettlementsCompanion copyWith({
    Value<int>? id,
    Value<int>? walletId,
    Value<String>? uuid,
    Value<int>? payerMemberId,
    Value<int>? receiverMemberId,
    Value<double>? amount,
    Value<DateTime>? settlementDate,
    Value<String?>? notes,
    Value<int?>? createdByAccountId,
    Value<DateTime>? createdAt,
  }) {
    return WalletSettlementsCompanion(
      id: id ?? this.id,
      walletId: walletId ?? this.walletId,
      uuid: uuid ?? this.uuid,
      payerMemberId: payerMemberId ?? this.payerMemberId,
      receiverMemberId: receiverMemberId ?? this.receiverMemberId,
      amount: amount ?? this.amount,
      settlementDate: settlementDate ?? this.settlementDate,
      notes: notes ?? this.notes,
      createdByAccountId: createdByAccountId ?? this.createdByAccountId,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (walletId.present) {
      map['wallet_id'] = Variable<int>(walletId.value);
    }
    if (uuid.present) {
      map['uuid'] = Variable<String>(uuid.value);
    }
    if (payerMemberId.present) {
      map['payer_member_id'] = Variable<int>(payerMemberId.value);
    }
    if (receiverMemberId.present) {
      map['receiver_member_id'] = Variable<int>(receiverMemberId.value);
    }
    if (amount.present) {
      map['amount'] = Variable<int>(
        $WalletSettlementsTable.$converteramount.toSql(amount.value),
      );
    }
    if (settlementDate.present) {
      map['settlement_date'] = Variable<DateTime>(settlementDate.value);
    }
    if (notes.present) {
      map['notes'] = Variable<String>(notes.value);
    }
    if (createdByAccountId.present) {
      map['created_by_account_id'] = Variable<int>(createdByAccountId.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('WalletSettlementsCompanion(')
          ..write('id: $id, ')
          ..write('walletId: $walletId, ')
          ..write('uuid: $uuid, ')
          ..write('payerMemberId: $payerMemberId, ')
          ..write('receiverMemberId: $receiverMemberId, ')
          ..write('amount: $amount, ')
          ..write('settlementDate: $settlementDate, ')
          ..write('notes: $notes, ')
          ..write('createdByAccountId: $createdByAccountId, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }
}

class $WalletsTable extends Wallets with TableInfo<$WalletsTable, Wallet> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $WalletsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _uuidMeta = const VerificationMeta('uuid');
  @override
  late final GeneratedColumn<String> uuid = GeneratedColumn<String>(
    'uuid',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    clientDefault: () => const Uuid().v4(),
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 1,
      maxTextLength: 80,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _typeMeta = const VerificationMeta('type');
  @override
  late final GeneratedColumn<String> type = GeneratedColumn<String>(
    'type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('personal'),
  );
  static const VerificationMeta _createdByAccountIdMeta =
      const VerificationMeta('createdByAccountId');
  @override
  late final GeneratedColumn<int> createdByAccountId = GeneratedColumn<int>(
    'created_by_account_id',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    clientDefault: () => DateTime.now(),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    uuid,
    name,
    type,
    createdByAccountId,
    createdAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'wallets';
  @override
  VerificationContext validateIntegrity(
    Insertable<Wallet> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('uuid')) {
      context.handle(
        _uuidMeta,
        uuid.isAcceptableOrUnknown(data['uuid']!, _uuidMeta),
      );
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('type')) {
      context.handle(
        _typeMeta,
        type.isAcceptableOrUnknown(data['type']!, _typeMeta),
      );
    }
    if (data.containsKey('created_by_account_id')) {
      context.handle(
        _createdByAccountIdMeta,
        createdByAccountId.isAcceptableOrUnknown(
          data['created_by_account_id']!,
          _createdByAccountIdMeta,
        ),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Wallet map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Wallet(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      uuid: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}uuid'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      type: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}type'],
      )!,
      createdByAccountId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}created_by_account_id'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $WalletsTable createAlias(String alias) {
    return $WalletsTable(attachedDatabase, alias);
  }
}

class Wallet extends DataClass implements Insertable<Wallet> {
  final int id;
  final String uuid;
  final String name;
  final String type;
  final int? createdByAccountId;
  final DateTime createdAt;
  const Wallet({
    required this.id,
    required this.uuid,
    required this.name,
    required this.type,
    this.createdByAccountId,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['uuid'] = Variable<String>(uuid);
    map['name'] = Variable<String>(name);
    map['type'] = Variable<String>(type);
    if (!nullToAbsent || createdByAccountId != null) {
      map['created_by_account_id'] = Variable<int>(createdByAccountId);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  WalletsCompanion toCompanion(bool nullToAbsent) {
    return WalletsCompanion(
      id: Value(id),
      uuid: Value(uuid),
      name: Value(name),
      type: Value(type),
      createdByAccountId: createdByAccountId == null && nullToAbsent
          ? const Value.absent()
          : Value(createdByAccountId),
      createdAt: Value(createdAt),
    );
  }

  factory Wallet.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Wallet(
      id: serializer.fromJson<int>(json['id']),
      uuid: serializer.fromJson<String>(json['uuid']),
      name: serializer.fromJson<String>(json['name']),
      type: serializer.fromJson<String>(json['type']),
      createdByAccountId: serializer.fromJson<int?>(json['createdByAccountId']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'uuid': serializer.toJson<String>(uuid),
      'name': serializer.toJson<String>(name),
      'type': serializer.toJson<String>(type),
      'createdByAccountId': serializer.toJson<int?>(createdByAccountId),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  Wallet copyWith({
    int? id,
    String? uuid,
    String? name,
    String? type,
    Value<int?> createdByAccountId = const Value.absent(),
    DateTime? createdAt,
  }) => Wallet(
    id: id ?? this.id,
    uuid: uuid ?? this.uuid,
    name: name ?? this.name,
    type: type ?? this.type,
    createdByAccountId: createdByAccountId.present
        ? createdByAccountId.value
        : this.createdByAccountId,
    createdAt: createdAt ?? this.createdAt,
  );
  Wallet copyWithCompanion(WalletsCompanion data) {
    return Wallet(
      id: data.id.present ? data.id.value : this.id,
      uuid: data.uuid.present ? data.uuid.value : this.uuid,
      name: data.name.present ? data.name.value : this.name,
      type: data.type.present ? data.type.value : this.type,
      createdByAccountId: data.createdByAccountId.present
          ? data.createdByAccountId.value
          : this.createdByAccountId,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Wallet(')
          ..write('id: $id, ')
          ..write('uuid: $uuid, ')
          ..write('name: $name, ')
          ..write('type: $type, ')
          ..write('createdByAccountId: $createdByAccountId, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, uuid, name, type, createdByAccountId, createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Wallet &&
          other.id == this.id &&
          other.uuid == this.uuid &&
          other.name == this.name &&
          other.type == this.type &&
          other.createdByAccountId == this.createdByAccountId &&
          other.createdAt == this.createdAt);
}

class WalletsCompanion extends UpdateCompanion<Wallet> {
  final Value<int> id;
  final Value<String> uuid;
  final Value<String> name;
  final Value<String> type;
  final Value<int?> createdByAccountId;
  final Value<DateTime> createdAt;
  const WalletsCompanion({
    this.id = const Value.absent(),
    this.uuid = const Value.absent(),
    this.name = const Value.absent(),
    this.type = const Value.absent(),
    this.createdByAccountId = const Value.absent(),
    this.createdAt = const Value.absent(),
  });
  WalletsCompanion.insert({
    this.id = const Value.absent(),
    this.uuid = const Value.absent(),
    required String name,
    this.type = const Value.absent(),
    this.createdByAccountId = const Value.absent(),
    this.createdAt = const Value.absent(),
  }) : name = Value(name);
  static Insertable<Wallet> custom({
    Expression<int>? id,
    Expression<String>? uuid,
    Expression<String>? name,
    Expression<String>? type,
    Expression<int>? createdByAccountId,
    Expression<DateTime>? createdAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (uuid != null) 'uuid': uuid,
      if (name != null) 'name': name,
      if (type != null) 'type': type,
      if (createdByAccountId != null)
        'created_by_account_id': createdByAccountId,
      if (createdAt != null) 'created_at': createdAt,
    });
  }

  WalletsCompanion copyWith({
    Value<int>? id,
    Value<String>? uuid,
    Value<String>? name,
    Value<String>? type,
    Value<int?>? createdByAccountId,
    Value<DateTime>? createdAt,
  }) {
    return WalletsCompanion(
      id: id ?? this.id,
      uuid: uuid ?? this.uuid,
      name: name ?? this.name,
      type: type ?? this.type,
      createdByAccountId: createdByAccountId ?? this.createdByAccountId,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (uuid.present) {
      map['uuid'] = Variable<String>(uuid.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (type.present) {
      map['type'] = Variable<String>(type.value);
    }
    if (createdByAccountId.present) {
      map['created_by_account_id'] = Variable<int>(createdByAccountId.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('WalletsCompanion(')
          ..write('id: $id, ')
          ..write('uuid: $uuid, ')
          ..write('name: $name, ')
          ..write('type: $type, ')
          ..write('createdByAccountId: $createdByAccountId, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }
}

class $WalletInvitationsTable extends WalletInvitations
    with TableInfo<$WalletInvitationsTable, WalletInvitation> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $WalletInvitationsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _tokenMeta = const VerificationMeta('token');
  @override
  late final GeneratedColumn<String> token = GeneratedColumn<String>(
    'token',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways('UNIQUE'),
    clientDefault: () => const Uuid().v4(),
  );
  static const VerificationMeta _walletIdMeta = const VerificationMeta(
    'walletId',
  );
  @override
  late final GeneratedColumn<int> walletId = GeneratedColumn<int>(
    'wallet_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _invitedByAccountIdMeta =
      const VerificationMeta('invitedByAccountId');
  @override
  late final GeneratedColumn<int> invitedByAccountId = GeneratedColumn<int>(
    'invited_by_account_id',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _accountIdMeta = const VerificationMeta(
    'accountId',
  );
  @override
  late final GeneratedColumn<int> accountId = GeneratedColumn<int>(
    'account_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  @override
  late final GeneratedColumnWithTypeConverter<WalletInvitationStatus, String>
  status =
      GeneratedColumn<String>(
        'status',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      ).withConverter<WalletInvitationStatus>(
        $WalletInvitationsTable.$converterstatus,
      );
  @override
  late final GeneratedColumnWithTypeConverter<WalletRole, String> role =
      GeneratedColumn<String>(
        'role',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      ).withConverter<WalletRole>($WalletInvitationsTable.$converterrole);
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    clientDefault: () => DateTime.now(),
  );
  static const VerificationMeta _expiresAtMeta = const VerificationMeta(
    'expiresAt',
  );
  @override
  late final GeneratedColumn<DateTime> expiresAt = GeneratedColumn<DateTime>(
    'expires_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _respondedAtMeta = const VerificationMeta(
    'respondedAt',
  );
  @override
  late final GeneratedColumn<DateTime> respondedAt = GeneratedColumn<DateTime>(
    'responded_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    token,
    walletId,
    invitedByAccountId,
    accountId,
    status,
    role,
    createdAt,
    expiresAt,
    respondedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'wallet_invitations';
  @override
  VerificationContext validateIntegrity(
    Insertable<WalletInvitation> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('token')) {
      context.handle(
        _tokenMeta,
        token.isAcceptableOrUnknown(data['token']!, _tokenMeta),
      );
    }
    if (data.containsKey('wallet_id')) {
      context.handle(
        _walletIdMeta,
        walletId.isAcceptableOrUnknown(data['wallet_id']!, _walletIdMeta),
      );
    } else if (isInserting) {
      context.missing(_walletIdMeta);
    }
    if (data.containsKey('invited_by_account_id')) {
      context.handle(
        _invitedByAccountIdMeta,
        invitedByAccountId.isAcceptableOrUnknown(
          data['invited_by_account_id']!,
          _invitedByAccountIdMeta,
        ),
      );
    }
    if (data.containsKey('account_id')) {
      context.handle(
        _accountIdMeta,
        accountId.isAcceptableOrUnknown(data['account_id']!, _accountIdMeta),
      );
    } else if (isInserting) {
      context.missing(_accountIdMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    if (data.containsKey('expires_at')) {
      context.handle(
        _expiresAtMeta,
        expiresAt.isAcceptableOrUnknown(data['expires_at']!, _expiresAtMeta),
      );
    }
    if (data.containsKey('responded_at')) {
      context.handle(
        _respondedAtMeta,
        respondedAt.isAcceptableOrUnknown(
          data['responded_at']!,
          _respondedAtMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  WalletInvitation map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return WalletInvitation(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      token: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}token'],
      )!,
      walletId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}wallet_id'],
      )!,
      invitedByAccountId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}invited_by_account_id'],
      ),
      accountId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}account_id'],
      )!,
      status: $WalletInvitationsTable.$converterstatus.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}status'],
        )!,
      ),
      role: $WalletInvitationsTable.$converterrole.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}role'],
        )!,
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      expiresAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}expires_at'],
      ),
      respondedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}responded_at'],
      ),
    );
  }

  @override
  $WalletInvitationsTable createAlias(String alias) {
    return $WalletInvitationsTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<WalletInvitationStatus, String, String>
  $converterstatus = const EnumNameConverter(WalletInvitationStatus.values);
  static JsonTypeConverter2<WalletRole, String, String> $converterrole =
      const EnumNameConverter(WalletRole.values);
}

class WalletInvitation extends DataClass
    implements Insertable<WalletInvitation> {
  final int id;
  final String token;
  final int walletId;
  final int? invitedByAccountId;
  final int accountId;
  final WalletInvitationStatus status;
  final WalletRole role;
  final DateTime createdAt;
  final DateTime? expiresAt;
  final DateTime? respondedAt;
  const WalletInvitation({
    required this.id,
    required this.token,
    required this.walletId,
    this.invitedByAccountId,
    required this.accountId,
    required this.status,
    required this.role,
    required this.createdAt,
    this.expiresAt,
    this.respondedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['token'] = Variable<String>(token);
    map['wallet_id'] = Variable<int>(walletId);
    if (!nullToAbsent || invitedByAccountId != null) {
      map['invited_by_account_id'] = Variable<int>(invitedByAccountId);
    }
    map['account_id'] = Variable<int>(accountId);
    {
      map['status'] = Variable<String>(
        $WalletInvitationsTable.$converterstatus.toSql(status),
      );
    }
    {
      map['role'] = Variable<String>(
        $WalletInvitationsTable.$converterrole.toSql(role),
      );
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    if (!nullToAbsent || expiresAt != null) {
      map['expires_at'] = Variable<DateTime>(expiresAt);
    }
    if (!nullToAbsent || respondedAt != null) {
      map['responded_at'] = Variable<DateTime>(respondedAt);
    }
    return map;
  }

  WalletInvitationsCompanion toCompanion(bool nullToAbsent) {
    return WalletInvitationsCompanion(
      id: Value(id),
      token: Value(token),
      walletId: Value(walletId),
      invitedByAccountId: invitedByAccountId == null && nullToAbsent
          ? const Value.absent()
          : Value(invitedByAccountId),
      accountId: Value(accountId),
      status: Value(status),
      role: Value(role),
      createdAt: Value(createdAt),
      expiresAt: expiresAt == null && nullToAbsent
          ? const Value.absent()
          : Value(expiresAt),
      respondedAt: respondedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(respondedAt),
    );
  }

  factory WalletInvitation.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return WalletInvitation(
      id: serializer.fromJson<int>(json['id']),
      token: serializer.fromJson<String>(json['token']),
      walletId: serializer.fromJson<int>(json['walletId']),
      invitedByAccountId: serializer.fromJson<int?>(json['invitedByAccountId']),
      accountId: serializer.fromJson<int>(json['accountId']),
      status: $WalletInvitationsTable.$converterstatus.fromJson(
        serializer.fromJson<String>(json['status']),
      ),
      role: $WalletInvitationsTable.$converterrole.fromJson(
        serializer.fromJson<String>(json['role']),
      ),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      expiresAt: serializer.fromJson<DateTime?>(json['expiresAt']),
      respondedAt: serializer.fromJson<DateTime?>(json['respondedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'token': serializer.toJson<String>(token),
      'walletId': serializer.toJson<int>(walletId),
      'invitedByAccountId': serializer.toJson<int?>(invitedByAccountId),
      'accountId': serializer.toJson<int>(accountId),
      'status': serializer.toJson<String>(
        $WalletInvitationsTable.$converterstatus.toJson(status),
      ),
      'role': serializer.toJson<String>(
        $WalletInvitationsTable.$converterrole.toJson(role),
      ),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'expiresAt': serializer.toJson<DateTime?>(expiresAt),
      'respondedAt': serializer.toJson<DateTime?>(respondedAt),
    };
  }

  WalletInvitation copyWith({
    int? id,
    String? token,
    int? walletId,
    Value<int?> invitedByAccountId = const Value.absent(),
    int? accountId,
    WalletInvitationStatus? status,
    WalletRole? role,
    DateTime? createdAt,
    Value<DateTime?> expiresAt = const Value.absent(),
    Value<DateTime?> respondedAt = const Value.absent(),
  }) => WalletInvitation(
    id: id ?? this.id,
    token: token ?? this.token,
    walletId: walletId ?? this.walletId,
    invitedByAccountId: invitedByAccountId.present
        ? invitedByAccountId.value
        : this.invitedByAccountId,
    accountId: accountId ?? this.accountId,
    status: status ?? this.status,
    role: role ?? this.role,
    createdAt: createdAt ?? this.createdAt,
    expiresAt: expiresAt.present ? expiresAt.value : this.expiresAt,
    respondedAt: respondedAt.present ? respondedAt.value : this.respondedAt,
  );
  WalletInvitation copyWithCompanion(WalletInvitationsCompanion data) {
    return WalletInvitation(
      id: data.id.present ? data.id.value : this.id,
      token: data.token.present ? data.token.value : this.token,
      walletId: data.walletId.present ? data.walletId.value : this.walletId,
      invitedByAccountId: data.invitedByAccountId.present
          ? data.invitedByAccountId.value
          : this.invitedByAccountId,
      accountId: data.accountId.present ? data.accountId.value : this.accountId,
      status: data.status.present ? data.status.value : this.status,
      role: data.role.present ? data.role.value : this.role,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      expiresAt: data.expiresAt.present ? data.expiresAt.value : this.expiresAt,
      respondedAt: data.respondedAt.present
          ? data.respondedAt.value
          : this.respondedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('WalletInvitation(')
          ..write('id: $id, ')
          ..write('token: $token, ')
          ..write('walletId: $walletId, ')
          ..write('invitedByAccountId: $invitedByAccountId, ')
          ..write('accountId: $accountId, ')
          ..write('status: $status, ')
          ..write('role: $role, ')
          ..write('createdAt: $createdAt, ')
          ..write('expiresAt: $expiresAt, ')
          ..write('respondedAt: $respondedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    token,
    walletId,
    invitedByAccountId,
    accountId,
    status,
    role,
    createdAt,
    expiresAt,
    respondedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is WalletInvitation &&
          other.id == this.id &&
          other.token == this.token &&
          other.walletId == this.walletId &&
          other.invitedByAccountId == this.invitedByAccountId &&
          other.accountId == this.accountId &&
          other.status == this.status &&
          other.role == this.role &&
          other.createdAt == this.createdAt &&
          other.expiresAt == this.expiresAt &&
          other.respondedAt == this.respondedAt);
}

class WalletInvitationsCompanion extends UpdateCompanion<WalletInvitation> {
  final Value<int> id;
  final Value<String> token;
  final Value<int> walletId;
  final Value<int?> invitedByAccountId;
  final Value<int> accountId;
  final Value<WalletInvitationStatus> status;
  final Value<WalletRole> role;
  final Value<DateTime> createdAt;
  final Value<DateTime?> expiresAt;
  final Value<DateTime?> respondedAt;
  const WalletInvitationsCompanion({
    this.id = const Value.absent(),
    this.token = const Value.absent(),
    this.walletId = const Value.absent(),
    this.invitedByAccountId = const Value.absent(),
    this.accountId = const Value.absent(),
    this.status = const Value.absent(),
    this.role = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.expiresAt = const Value.absent(),
    this.respondedAt = const Value.absent(),
  });
  WalletInvitationsCompanion.insert({
    this.id = const Value.absent(),
    this.token = const Value.absent(),
    required int walletId,
    this.invitedByAccountId = const Value.absent(),
    required int accountId,
    required WalletInvitationStatus status,
    required WalletRole role,
    this.createdAt = const Value.absent(),
    this.expiresAt = const Value.absent(),
    this.respondedAt = const Value.absent(),
  }) : walletId = Value(walletId),
       accountId = Value(accountId),
       status = Value(status),
       role = Value(role);
  static Insertable<WalletInvitation> custom({
    Expression<int>? id,
    Expression<String>? token,
    Expression<int>? walletId,
    Expression<int>? invitedByAccountId,
    Expression<int>? accountId,
    Expression<String>? status,
    Expression<String>? role,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? expiresAt,
    Expression<DateTime>? respondedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (token != null) 'token': token,
      if (walletId != null) 'wallet_id': walletId,
      if (invitedByAccountId != null)
        'invited_by_account_id': invitedByAccountId,
      if (accountId != null) 'account_id': accountId,
      if (status != null) 'status': status,
      if (role != null) 'role': role,
      if (createdAt != null) 'created_at': createdAt,
      if (expiresAt != null) 'expires_at': expiresAt,
      if (respondedAt != null) 'responded_at': respondedAt,
    });
  }

  WalletInvitationsCompanion copyWith({
    Value<int>? id,
    Value<String>? token,
    Value<int>? walletId,
    Value<int?>? invitedByAccountId,
    Value<int>? accountId,
    Value<WalletInvitationStatus>? status,
    Value<WalletRole>? role,
    Value<DateTime>? createdAt,
    Value<DateTime?>? expiresAt,
    Value<DateTime?>? respondedAt,
  }) {
    return WalletInvitationsCompanion(
      id: id ?? this.id,
      token: token ?? this.token,
      walletId: walletId ?? this.walletId,
      invitedByAccountId: invitedByAccountId ?? this.invitedByAccountId,
      accountId: accountId ?? this.accountId,
      status: status ?? this.status,
      role: role ?? this.role,
      createdAt: createdAt ?? this.createdAt,
      expiresAt: expiresAt ?? this.expiresAt,
      respondedAt: respondedAt ?? this.respondedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (token.present) {
      map['token'] = Variable<String>(token.value);
    }
    if (walletId.present) {
      map['wallet_id'] = Variable<int>(walletId.value);
    }
    if (invitedByAccountId.present) {
      map['invited_by_account_id'] = Variable<int>(invitedByAccountId.value);
    }
    if (accountId.present) {
      map['account_id'] = Variable<int>(accountId.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(
        $WalletInvitationsTable.$converterstatus.toSql(status.value),
      );
    }
    if (role.present) {
      map['role'] = Variable<String>(
        $WalletInvitationsTable.$converterrole.toSql(role.value),
      );
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (expiresAt.present) {
      map['expires_at'] = Variable<DateTime>(expiresAt.value);
    }
    if (respondedAt.present) {
      map['responded_at'] = Variable<DateTime>(respondedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('WalletInvitationsCompanion(')
          ..write('id: $id, ')
          ..write('token: $token, ')
          ..write('walletId: $walletId, ')
          ..write('invitedByAccountId: $invitedByAccountId, ')
          ..write('accountId: $accountId, ')
          ..write('status: $status, ')
          ..write('role: $role, ')
          ..write('createdAt: $createdAt, ')
          ..write('expiresAt: $expiresAt, ')
          ..write('respondedAt: $respondedAt')
          ..write(')'))
        .toString();
  }
}

class $WalletMembersTable extends WalletMembers
    with TableInfo<$WalletMembersTable, WalletMember> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $WalletMembersTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _walletIdMeta = const VerificationMeta(
    'walletId',
  );
  @override
  late final GeneratedColumn<int> walletId = GeneratedColumn<int>(
    'wallet_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _accountIdMeta = const VerificationMeta(
    'accountId',
  );
  @override
  late final GeneratedColumn<int> accountId = GeneratedColumn<int>(
    'account_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  @override
  late final GeneratedColumnWithTypeConverter<WalletRole, String> role =
      GeneratedColumn<String>(
        'role',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      ).withConverter<WalletRole>($WalletMembersTable.$converterrole);
  static const VerificationMeta _joinedAtMeta = const VerificationMeta(
    'joinedAt',
  );
  @override
  late final GeneratedColumn<DateTime> joinedAt = GeneratedColumn<DateTime>(
    'joined_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    clientDefault: () => DateTime.now(),
  );
  static const VerificationMeta _isActiveMeta = const VerificationMeta(
    'isActive',
  );
  @override
  late final GeneratedColumn<bool> isActive = GeneratedColumn<bool>(
    'is_active',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_active" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    walletId,
    accountId,
    role,
    joinedAt,
    isActive,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'wallet_members';
  @override
  VerificationContext validateIntegrity(
    Insertable<WalletMember> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('wallet_id')) {
      context.handle(
        _walletIdMeta,
        walletId.isAcceptableOrUnknown(data['wallet_id']!, _walletIdMeta),
      );
    } else if (isInserting) {
      context.missing(_walletIdMeta);
    }
    if (data.containsKey('account_id')) {
      context.handle(
        _accountIdMeta,
        accountId.isAcceptableOrUnknown(data['account_id']!, _accountIdMeta),
      );
    } else if (isInserting) {
      context.missing(_accountIdMeta);
    }
    if (data.containsKey('joined_at')) {
      context.handle(
        _joinedAtMeta,
        joinedAt.isAcceptableOrUnknown(data['joined_at']!, _joinedAtMeta),
      );
    }
    if (data.containsKey('is_active')) {
      context.handle(
        _isActiveMeta,
        isActive.isAcceptableOrUnknown(data['is_active']!, _isActiveMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  WalletMember map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return WalletMember(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      walletId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}wallet_id'],
      )!,
      accountId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}account_id'],
      )!,
      role: $WalletMembersTable.$converterrole.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}role'],
        )!,
      ),
      joinedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}joined_at'],
      )!,
      isActive: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_active'],
      )!,
    );
  }

  @override
  $WalletMembersTable createAlias(String alias) {
    return $WalletMembersTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<WalletRole, String, String> $converterrole =
      const EnumNameConverter(WalletRole.values);
}

class WalletMember extends DataClass implements Insertable<WalletMember> {
  final int id;
  final int walletId;
  final int accountId;
  final WalletRole role;
  final DateTime joinedAt;
  final bool isActive;
  const WalletMember({
    required this.id,
    required this.walletId,
    required this.accountId,
    required this.role,
    required this.joinedAt,
    required this.isActive,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['wallet_id'] = Variable<int>(walletId);
    map['account_id'] = Variable<int>(accountId);
    {
      map['role'] = Variable<String>(
        $WalletMembersTable.$converterrole.toSql(role),
      );
    }
    map['joined_at'] = Variable<DateTime>(joinedAt);
    map['is_active'] = Variable<bool>(isActive);
    return map;
  }

  WalletMembersCompanion toCompanion(bool nullToAbsent) {
    return WalletMembersCompanion(
      id: Value(id),
      walletId: Value(walletId),
      accountId: Value(accountId),
      role: Value(role),
      joinedAt: Value(joinedAt),
      isActive: Value(isActive),
    );
  }

  factory WalletMember.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return WalletMember(
      id: serializer.fromJson<int>(json['id']),
      walletId: serializer.fromJson<int>(json['walletId']),
      accountId: serializer.fromJson<int>(json['accountId']),
      role: $WalletMembersTable.$converterrole.fromJson(
        serializer.fromJson<String>(json['role']),
      ),
      joinedAt: serializer.fromJson<DateTime>(json['joinedAt']),
      isActive: serializer.fromJson<bool>(json['isActive']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'walletId': serializer.toJson<int>(walletId),
      'accountId': serializer.toJson<int>(accountId),
      'role': serializer.toJson<String>(
        $WalletMembersTable.$converterrole.toJson(role),
      ),
      'joinedAt': serializer.toJson<DateTime>(joinedAt),
      'isActive': serializer.toJson<bool>(isActive),
    };
  }

  WalletMember copyWith({
    int? id,
    int? walletId,
    int? accountId,
    WalletRole? role,
    DateTime? joinedAt,
    bool? isActive,
  }) => WalletMember(
    id: id ?? this.id,
    walletId: walletId ?? this.walletId,
    accountId: accountId ?? this.accountId,
    role: role ?? this.role,
    joinedAt: joinedAt ?? this.joinedAt,
    isActive: isActive ?? this.isActive,
  );
  WalletMember copyWithCompanion(WalletMembersCompanion data) {
    return WalletMember(
      id: data.id.present ? data.id.value : this.id,
      walletId: data.walletId.present ? data.walletId.value : this.walletId,
      accountId: data.accountId.present ? data.accountId.value : this.accountId,
      role: data.role.present ? data.role.value : this.role,
      joinedAt: data.joinedAt.present ? data.joinedAt.value : this.joinedAt,
      isActive: data.isActive.present ? data.isActive.value : this.isActive,
    );
  }

  @override
  String toString() {
    return (StringBuffer('WalletMember(')
          ..write('id: $id, ')
          ..write('walletId: $walletId, ')
          ..write('accountId: $accountId, ')
          ..write('role: $role, ')
          ..write('joinedAt: $joinedAt, ')
          ..write('isActive: $isActive')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, walletId, accountId, role, joinedAt, isActive);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is WalletMember &&
          other.id == this.id &&
          other.walletId == this.walletId &&
          other.accountId == this.accountId &&
          other.role == this.role &&
          other.joinedAt == this.joinedAt &&
          other.isActive == this.isActive);
}

class WalletMembersCompanion extends UpdateCompanion<WalletMember> {
  final Value<int> id;
  final Value<int> walletId;
  final Value<int> accountId;
  final Value<WalletRole> role;
  final Value<DateTime> joinedAt;
  final Value<bool> isActive;
  const WalletMembersCompanion({
    this.id = const Value.absent(),
    this.walletId = const Value.absent(),
    this.accountId = const Value.absent(),
    this.role = const Value.absent(),
    this.joinedAt = const Value.absent(),
    this.isActive = const Value.absent(),
  });
  WalletMembersCompanion.insert({
    this.id = const Value.absent(),
    required int walletId,
    required int accountId,
    required WalletRole role,
    this.joinedAt = const Value.absent(),
    this.isActive = const Value.absent(),
  }) : walletId = Value(walletId),
       accountId = Value(accountId),
       role = Value(role);
  static Insertable<WalletMember> custom({
    Expression<int>? id,
    Expression<int>? walletId,
    Expression<int>? accountId,
    Expression<String>? role,
    Expression<DateTime>? joinedAt,
    Expression<bool>? isActive,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (walletId != null) 'wallet_id': walletId,
      if (accountId != null) 'account_id': accountId,
      if (role != null) 'role': role,
      if (joinedAt != null) 'joined_at': joinedAt,
      if (isActive != null) 'is_active': isActive,
    });
  }

  WalletMembersCompanion copyWith({
    Value<int>? id,
    Value<int>? walletId,
    Value<int>? accountId,
    Value<WalletRole>? role,
    Value<DateTime>? joinedAt,
    Value<bool>? isActive,
  }) {
    return WalletMembersCompanion(
      id: id ?? this.id,
      walletId: walletId ?? this.walletId,
      accountId: accountId ?? this.accountId,
      role: role ?? this.role,
      joinedAt: joinedAt ?? this.joinedAt,
      isActive: isActive ?? this.isActive,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (walletId.present) {
      map['wallet_id'] = Variable<int>(walletId.value);
    }
    if (accountId.present) {
      map['account_id'] = Variable<int>(accountId.value);
    }
    if (role.present) {
      map['role'] = Variable<String>(
        $WalletMembersTable.$converterrole.toSql(role.value),
      );
    }
    if (joinedAt.present) {
      map['joined_at'] = Variable<DateTime>(joinedAt.value);
    }
    if (isActive.present) {
      map['is_active'] = Variable<bool>(isActive.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('WalletMembersCompanion(')
          ..write('id: $id, ')
          ..write('walletId: $walletId, ')
          ..write('accountId: $accountId, ')
          ..write('role: $role, ')
          ..write('joinedAt: $joinedAt, ')
          ..write('isActive: $isActive')
          ..write(')'))
        .toString();
  }
}

class $WalletGoalsTable extends WalletGoals
    with TableInfo<$WalletGoalsTable, WalletGoal> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $WalletGoalsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _walletIdMeta = const VerificationMeta(
    'walletId',
  );
  @override
  late final GeneratedColumn<int> walletId = GeneratedColumn<int>(
    'wallet_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 1,
      maxTextLength: 100,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  late final GeneratedColumnWithTypeConverter<double, int> targetAmount =
      GeneratedColumn<int>(
        'target_amount',
        aliasedName,
        false,
        type: DriftSqlType.int,
        requiredDuringInsert: true,
      ).withConverter<double>($WalletGoalsTable.$convertertargetAmount);
  @override
  late final GeneratedColumnWithTypeConverter<double, int> currentAmount =
      GeneratedColumn<int>(
        'current_amount',
        aliasedName,
        false,
        type: DriftSqlType.int,
        requiredDuringInsert: false,
        defaultValue: const Constant(0),
      ).withConverter<double>($WalletGoalsTable.$convertercurrentAmount);
  static const VerificationMeta _targetDateMeta = const VerificationMeta(
    'targetDate',
  );
  @override
  late final GeneratedColumn<DateTime> targetDate = GeneratedColumn<DateTime>(
    'target_date',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _createdByAccountIdMeta =
      const VerificationMeta('createdByAccountId');
  @override
  late final GeneratedColumn<int> createdByAccountId = GeneratedColumn<int>(
    'created_by_account_id',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _updatedByAccountIdMeta =
      const VerificationMeta('updatedByAccountId');
  @override
  late final GeneratedColumn<int> updatedByAccountId = GeneratedColumn<int>(
    'updated_by_account_id',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    clientDefault: () => DateTime.now(),
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    clientDefault: () => DateTime.now(),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    walletId,
    name,
    targetAmount,
    currentAmount,
    targetDate,
    createdByAccountId,
    updatedByAccountId,
    createdAt,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'wallet_goals';
  @override
  VerificationContext validateIntegrity(
    Insertable<WalletGoal> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('wallet_id')) {
      context.handle(
        _walletIdMeta,
        walletId.isAcceptableOrUnknown(data['wallet_id']!, _walletIdMeta),
      );
    } else if (isInserting) {
      context.missing(_walletIdMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('target_date')) {
      context.handle(
        _targetDateMeta,
        targetDate.isAcceptableOrUnknown(data['target_date']!, _targetDateMeta),
      );
    }
    if (data.containsKey('created_by_account_id')) {
      context.handle(
        _createdByAccountIdMeta,
        createdByAccountId.isAcceptableOrUnknown(
          data['created_by_account_id']!,
          _createdByAccountIdMeta,
        ),
      );
    }
    if (data.containsKey('updated_by_account_id')) {
      context.handle(
        _updatedByAccountIdMeta,
        updatedByAccountId.isAcceptableOrUnknown(
          data['updated_by_account_id']!,
          _updatedByAccountIdMeta,
        ),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  WalletGoal map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return WalletGoal(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      walletId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}wallet_id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      targetAmount: $WalletGoalsTable.$convertertargetAmount.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.int,
          data['${effectivePrefix}target_amount'],
        )!,
      ),
      currentAmount: $WalletGoalsTable.$convertercurrentAmount.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.int,
          data['${effectivePrefix}current_amount'],
        )!,
      ),
      targetDate: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}target_date'],
      ),
      createdByAccountId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}created_by_account_id'],
      ),
      updatedByAccountId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}updated_by_account_id'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $WalletGoalsTable createAlias(String alias) {
    return $WalletGoalsTable(attachedDatabase, alias);
  }

  static TypeConverter<double, int> $convertertargetAmount =
      const MoneyConverter();
  static TypeConverter<double, int> $convertercurrentAmount =
      const MoneyConverter();
}

class WalletGoal extends DataClass implements Insertable<WalletGoal> {
  final int id;
  final int walletId;
  final String name;
  final double targetAmount;
  final double currentAmount;
  final DateTime? targetDate;
  final int? createdByAccountId;
  final int? updatedByAccountId;
  final DateTime createdAt;
  final DateTime updatedAt;
  const WalletGoal({
    required this.id,
    required this.walletId,
    required this.name,
    required this.targetAmount,
    required this.currentAmount,
    this.targetDate,
    this.createdByAccountId,
    this.updatedByAccountId,
    required this.createdAt,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['wallet_id'] = Variable<int>(walletId);
    map['name'] = Variable<String>(name);
    {
      map['target_amount'] = Variable<int>(
        $WalletGoalsTable.$convertertargetAmount.toSql(targetAmount),
      );
    }
    {
      map['current_amount'] = Variable<int>(
        $WalletGoalsTable.$convertercurrentAmount.toSql(currentAmount),
      );
    }
    if (!nullToAbsent || targetDate != null) {
      map['target_date'] = Variable<DateTime>(targetDate);
    }
    if (!nullToAbsent || createdByAccountId != null) {
      map['created_by_account_id'] = Variable<int>(createdByAccountId);
    }
    if (!nullToAbsent || updatedByAccountId != null) {
      map['updated_by_account_id'] = Variable<int>(updatedByAccountId);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  WalletGoalsCompanion toCompanion(bool nullToAbsent) {
    return WalletGoalsCompanion(
      id: Value(id),
      walletId: Value(walletId),
      name: Value(name),
      targetAmount: Value(targetAmount),
      currentAmount: Value(currentAmount),
      targetDate: targetDate == null && nullToAbsent
          ? const Value.absent()
          : Value(targetDate),
      createdByAccountId: createdByAccountId == null && nullToAbsent
          ? const Value.absent()
          : Value(createdByAccountId),
      updatedByAccountId: updatedByAccountId == null && nullToAbsent
          ? const Value.absent()
          : Value(updatedByAccountId),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory WalletGoal.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return WalletGoal(
      id: serializer.fromJson<int>(json['id']),
      walletId: serializer.fromJson<int>(json['walletId']),
      name: serializer.fromJson<String>(json['name']),
      targetAmount: serializer.fromJson<double>(json['targetAmount']),
      currentAmount: serializer.fromJson<double>(json['currentAmount']),
      targetDate: serializer.fromJson<DateTime?>(json['targetDate']),
      createdByAccountId: serializer.fromJson<int?>(json['createdByAccountId']),
      updatedByAccountId: serializer.fromJson<int?>(json['updatedByAccountId']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'walletId': serializer.toJson<int>(walletId),
      'name': serializer.toJson<String>(name),
      'targetAmount': serializer.toJson<double>(targetAmount),
      'currentAmount': serializer.toJson<double>(currentAmount),
      'targetDate': serializer.toJson<DateTime?>(targetDate),
      'createdByAccountId': serializer.toJson<int?>(createdByAccountId),
      'updatedByAccountId': serializer.toJson<int?>(updatedByAccountId),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  WalletGoal copyWith({
    int? id,
    int? walletId,
    String? name,
    double? targetAmount,
    double? currentAmount,
    Value<DateTime?> targetDate = const Value.absent(),
    Value<int?> createdByAccountId = const Value.absent(),
    Value<int?> updatedByAccountId = const Value.absent(),
    DateTime? createdAt,
    DateTime? updatedAt,
  }) => WalletGoal(
    id: id ?? this.id,
    walletId: walletId ?? this.walletId,
    name: name ?? this.name,
    targetAmount: targetAmount ?? this.targetAmount,
    currentAmount: currentAmount ?? this.currentAmount,
    targetDate: targetDate.present ? targetDate.value : this.targetDate,
    createdByAccountId: createdByAccountId.present
        ? createdByAccountId.value
        : this.createdByAccountId,
    updatedByAccountId: updatedByAccountId.present
        ? updatedByAccountId.value
        : this.updatedByAccountId,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  WalletGoal copyWithCompanion(WalletGoalsCompanion data) {
    return WalletGoal(
      id: data.id.present ? data.id.value : this.id,
      walletId: data.walletId.present ? data.walletId.value : this.walletId,
      name: data.name.present ? data.name.value : this.name,
      targetAmount: data.targetAmount.present
          ? data.targetAmount.value
          : this.targetAmount,
      currentAmount: data.currentAmount.present
          ? data.currentAmount.value
          : this.currentAmount,
      targetDate: data.targetDate.present
          ? data.targetDate.value
          : this.targetDate,
      createdByAccountId: data.createdByAccountId.present
          ? data.createdByAccountId.value
          : this.createdByAccountId,
      updatedByAccountId: data.updatedByAccountId.present
          ? data.updatedByAccountId.value
          : this.updatedByAccountId,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('WalletGoal(')
          ..write('id: $id, ')
          ..write('walletId: $walletId, ')
          ..write('name: $name, ')
          ..write('targetAmount: $targetAmount, ')
          ..write('currentAmount: $currentAmount, ')
          ..write('targetDate: $targetDate, ')
          ..write('createdByAccountId: $createdByAccountId, ')
          ..write('updatedByAccountId: $updatedByAccountId, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    walletId,
    name,
    targetAmount,
    currentAmount,
    targetDate,
    createdByAccountId,
    updatedByAccountId,
    createdAt,
    updatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is WalletGoal &&
          other.id == this.id &&
          other.walletId == this.walletId &&
          other.name == this.name &&
          other.targetAmount == this.targetAmount &&
          other.currentAmount == this.currentAmount &&
          other.targetDate == this.targetDate &&
          other.createdByAccountId == this.createdByAccountId &&
          other.updatedByAccountId == this.updatedByAccountId &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class WalletGoalsCompanion extends UpdateCompanion<WalletGoal> {
  final Value<int> id;
  final Value<int> walletId;
  final Value<String> name;
  final Value<double> targetAmount;
  final Value<double> currentAmount;
  final Value<DateTime?> targetDate;
  final Value<int?> createdByAccountId;
  final Value<int?> updatedByAccountId;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  const WalletGoalsCompanion({
    this.id = const Value.absent(),
    this.walletId = const Value.absent(),
    this.name = const Value.absent(),
    this.targetAmount = const Value.absent(),
    this.currentAmount = const Value.absent(),
    this.targetDate = const Value.absent(),
    this.createdByAccountId = const Value.absent(),
    this.updatedByAccountId = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  });
  WalletGoalsCompanion.insert({
    this.id = const Value.absent(),
    required int walletId,
    required String name,
    required double targetAmount,
    this.currentAmount = const Value.absent(),
    this.targetDate = const Value.absent(),
    this.createdByAccountId = const Value.absent(),
    this.updatedByAccountId = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  }) : walletId = Value(walletId),
       name = Value(name),
       targetAmount = Value(targetAmount);
  static Insertable<WalletGoal> custom({
    Expression<int>? id,
    Expression<int>? walletId,
    Expression<String>? name,
    Expression<int>? targetAmount,
    Expression<int>? currentAmount,
    Expression<DateTime>? targetDate,
    Expression<int>? createdByAccountId,
    Expression<int>? updatedByAccountId,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (walletId != null) 'wallet_id': walletId,
      if (name != null) 'name': name,
      if (targetAmount != null) 'target_amount': targetAmount,
      if (currentAmount != null) 'current_amount': currentAmount,
      if (targetDate != null) 'target_date': targetDate,
      if (createdByAccountId != null)
        'created_by_account_id': createdByAccountId,
      if (updatedByAccountId != null)
        'updated_by_account_id': updatedByAccountId,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
    });
  }

  WalletGoalsCompanion copyWith({
    Value<int>? id,
    Value<int>? walletId,
    Value<String>? name,
    Value<double>? targetAmount,
    Value<double>? currentAmount,
    Value<DateTime?>? targetDate,
    Value<int?>? createdByAccountId,
    Value<int?>? updatedByAccountId,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
  }) {
    return WalletGoalsCompanion(
      id: id ?? this.id,
      walletId: walletId ?? this.walletId,
      name: name ?? this.name,
      targetAmount: targetAmount ?? this.targetAmount,
      currentAmount: currentAmount ?? this.currentAmount,
      targetDate: targetDate ?? this.targetDate,
      createdByAccountId: createdByAccountId ?? this.createdByAccountId,
      updatedByAccountId: updatedByAccountId ?? this.updatedByAccountId,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (walletId.present) {
      map['wallet_id'] = Variable<int>(walletId.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (targetAmount.present) {
      map['target_amount'] = Variable<int>(
        $WalletGoalsTable.$convertertargetAmount.toSql(targetAmount.value),
      );
    }
    if (currentAmount.present) {
      map['current_amount'] = Variable<int>(
        $WalletGoalsTable.$convertercurrentAmount.toSql(currentAmount.value),
      );
    }
    if (targetDate.present) {
      map['target_date'] = Variable<DateTime>(targetDate.value);
    }
    if (createdByAccountId.present) {
      map['created_by_account_id'] = Variable<int>(createdByAccountId.value);
    }
    if (updatedByAccountId.present) {
      map['updated_by_account_id'] = Variable<int>(updatedByAccountId.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('WalletGoalsCompanion(')
          ..write('id: $id, ')
          ..write('walletId: $walletId, ')
          ..write('name: $name, ')
          ..write('targetAmount: $targetAmount, ')
          ..write('currentAmount: $currentAmount, ')
          ..write('targetDate: $targetDate, ')
          ..write('createdByAccountId: $createdByAccountId, ')
          ..write('updatedByAccountId: $updatedByAccountId, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }
}

class $WalletGoalContributionsTable extends WalletGoalContributions
    with TableInfo<$WalletGoalContributionsTable, WalletGoalContribution> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $WalletGoalContributionsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _walletIdMeta = const VerificationMeta(
    'walletId',
  );
  @override
  late final GeneratedColumn<int> walletId = GeneratedColumn<int>(
    'wallet_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _goalIdMeta = const VerificationMeta('goalId');
  @override
  late final GeneratedColumn<int> goalId = GeneratedColumn<int>(
    'goal_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _contributedByAccountIdMeta =
      const VerificationMeta('contributedByAccountId');
  @override
  late final GeneratedColumn<int> contributedByAccountId = GeneratedColumn<int>(
    'contributed_by_account_id',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  @override
  late final GeneratedColumnWithTypeConverter<double, int> amount =
      GeneratedColumn<int>(
        'amount',
        aliasedName,
        false,
        type: DriftSqlType.int,
        requiredDuringInsert: true,
      ).withConverter<double>($WalletGoalContributionsTable.$converteramount);
  static const VerificationMeta _contributedAtMeta = const VerificationMeta(
    'contributedAt',
  );
  @override
  late final GeneratedColumn<DateTime> contributedAt =
      GeneratedColumn<DateTime>(
        'contributed_at',
        aliasedName,
        false,
        type: DriftSqlType.dateTime,
        requiredDuringInsert: false,
        clientDefault: () => DateTime.now(),
      );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    walletId,
    goalId,
    contributedByAccountId,
    amount,
    contributedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'wallet_goal_contributions';
  @override
  VerificationContext validateIntegrity(
    Insertable<WalletGoalContribution> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('wallet_id')) {
      context.handle(
        _walletIdMeta,
        walletId.isAcceptableOrUnknown(data['wallet_id']!, _walletIdMeta),
      );
    } else if (isInserting) {
      context.missing(_walletIdMeta);
    }
    if (data.containsKey('goal_id')) {
      context.handle(
        _goalIdMeta,
        goalId.isAcceptableOrUnknown(data['goal_id']!, _goalIdMeta),
      );
    } else if (isInserting) {
      context.missing(_goalIdMeta);
    }
    if (data.containsKey('contributed_by_account_id')) {
      context.handle(
        _contributedByAccountIdMeta,
        contributedByAccountId.isAcceptableOrUnknown(
          data['contributed_by_account_id']!,
          _contributedByAccountIdMeta,
        ),
      );
    }
    if (data.containsKey('contributed_at')) {
      context.handle(
        _contributedAtMeta,
        contributedAt.isAcceptableOrUnknown(
          data['contributed_at']!,
          _contributedAtMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  WalletGoalContribution map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return WalletGoalContribution(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      walletId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}wallet_id'],
      )!,
      goalId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}goal_id'],
      )!,
      contributedByAccountId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}contributed_by_account_id'],
      ),
      amount: $WalletGoalContributionsTable.$converteramount.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.int,
          data['${effectivePrefix}amount'],
        )!,
      ),
      contributedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}contributed_at'],
      )!,
    );
  }

  @override
  $WalletGoalContributionsTable createAlias(String alias) {
    return $WalletGoalContributionsTable(attachedDatabase, alias);
  }

  static TypeConverter<double, int> $converteramount = const MoneyConverter();
}

class WalletGoalContribution extends DataClass
    implements Insertable<WalletGoalContribution> {
  final int id;
  final int walletId;
  final int goalId;
  final int? contributedByAccountId;
  final double amount;
  final DateTime contributedAt;
  const WalletGoalContribution({
    required this.id,
    required this.walletId,
    required this.goalId,
    this.contributedByAccountId,
    required this.amount,
    required this.contributedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['wallet_id'] = Variable<int>(walletId);
    map['goal_id'] = Variable<int>(goalId);
    if (!nullToAbsent || contributedByAccountId != null) {
      map['contributed_by_account_id'] = Variable<int>(contributedByAccountId);
    }
    {
      map['amount'] = Variable<int>(
        $WalletGoalContributionsTable.$converteramount.toSql(amount),
      );
    }
    map['contributed_at'] = Variable<DateTime>(contributedAt);
    return map;
  }

  WalletGoalContributionsCompanion toCompanion(bool nullToAbsent) {
    return WalletGoalContributionsCompanion(
      id: Value(id),
      walletId: Value(walletId),
      goalId: Value(goalId),
      contributedByAccountId: contributedByAccountId == null && nullToAbsent
          ? const Value.absent()
          : Value(contributedByAccountId),
      amount: Value(amount),
      contributedAt: Value(contributedAt),
    );
  }

  factory WalletGoalContribution.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return WalletGoalContribution(
      id: serializer.fromJson<int>(json['id']),
      walletId: serializer.fromJson<int>(json['walletId']),
      goalId: serializer.fromJson<int>(json['goalId']),
      contributedByAccountId: serializer.fromJson<int?>(
        json['contributedByAccountId'],
      ),
      amount: serializer.fromJson<double>(json['amount']),
      contributedAt: serializer.fromJson<DateTime>(json['contributedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'walletId': serializer.toJson<int>(walletId),
      'goalId': serializer.toJson<int>(goalId),
      'contributedByAccountId': serializer.toJson<int?>(contributedByAccountId),
      'amount': serializer.toJson<double>(amount),
      'contributedAt': serializer.toJson<DateTime>(contributedAt),
    };
  }

  WalletGoalContribution copyWith({
    int? id,
    int? walletId,
    int? goalId,
    Value<int?> contributedByAccountId = const Value.absent(),
    double? amount,
    DateTime? contributedAt,
  }) => WalletGoalContribution(
    id: id ?? this.id,
    walletId: walletId ?? this.walletId,
    goalId: goalId ?? this.goalId,
    contributedByAccountId: contributedByAccountId.present
        ? contributedByAccountId.value
        : this.contributedByAccountId,
    amount: amount ?? this.amount,
    contributedAt: contributedAt ?? this.contributedAt,
  );
  WalletGoalContribution copyWithCompanion(
    WalletGoalContributionsCompanion data,
  ) {
    return WalletGoalContribution(
      id: data.id.present ? data.id.value : this.id,
      walletId: data.walletId.present ? data.walletId.value : this.walletId,
      goalId: data.goalId.present ? data.goalId.value : this.goalId,
      contributedByAccountId: data.contributedByAccountId.present
          ? data.contributedByAccountId.value
          : this.contributedByAccountId,
      amount: data.amount.present ? data.amount.value : this.amount,
      contributedAt: data.contributedAt.present
          ? data.contributedAt.value
          : this.contributedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('WalletGoalContribution(')
          ..write('id: $id, ')
          ..write('walletId: $walletId, ')
          ..write('goalId: $goalId, ')
          ..write('contributedByAccountId: $contributedByAccountId, ')
          ..write('amount: $amount, ')
          ..write('contributedAt: $contributedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    walletId,
    goalId,
    contributedByAccountId,
    amount,
    contributedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is WalletGoalContribution &&
          other.id == this.id &&
          other.walletId == this.walletId &&
          other.goalId == this.goalId &&
          other.contributedByAccountId == this.contributedByAccountId &&
          other.amount == this.amount &&
          other.contributedAt == this.contributedAt);
}

class WalletGoalContributionsCompanion
    extends UpdateCompanion<WalletGoalContribution> {
  final Value<int> id;
  final Value<int> walletId;
  final Value<int> goalId;
  final Value<int?> contributedByAccountId;
  final Value<double> amount;
  final Value<DateTime> contributedAt;
  const WalletGoalContributionsCompanion({
    this.id = const Value.absent(),
    this.walletId = const Value.absent(),
    this.goalId = const Value.absent(),
    this.contributedByAccountId = const Value.absent(),
    this.amount = const Value.absent(),
    this.contributedAt = const Value.absent(),
  });
  WalletGoalContributionsCompanion.insert({
    this.id = const Value.absent(),
    required int walletId,
    required int goalId,
    this.contributedByAccountId = const Value.absent(),
    required double amount,
    this.contributedAt = const Value.absent(),
  }) : walletId = Value(walletId),
       goalId = Value(goalId),
       amount = Value(amount);
  static Insertable<WalletGoalContribution> custom({
    Expression<int>? id,
    Expression<int>? walletId,
    Expression<int>? goalId,
    Expression<int>? contributedByAccountId,
    Expression<int>? amount,
    Expression<DateTime>? contributedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (walletId != null) 'wallet_id': walletId,
      if (goalId != null) 'goal_id': goalId,
      if (contributedByAccountId != null)
        'contributed_by_account_id': contributedByAccountId,
      if (amount != null) 'amount': amount,
      if (contributedAt != null) 'contributed_at': contributedAt,
    });
  }

  WalletGoalContributionsCompanion copyWith({
    Value<int>? id,
    Value<int>? walletId,
    Value<int>? goalId,
    Value<int?>? contributedByAccountId,
    Value<double>? amount,
    Value<DateTime>? contributedAt,
  }) {
    return WalletGoalContributionsCompanion(
      id: id ?? this.id,
      walletId: walletId ?? this.walletId,
      goalId: goalId ?? this.goalId,
      contributedByAccountId:
          contributedByAccountId ?? this.contributedByAccountId,
      amount: amount ?? this.amount,
      contributedAt: contributedAt ?? this.contributedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (walletId.present) {
      map['wallet_id'] = Variable<int>(walletId.value);
    }
    if (goalId.present) {
      map['goal_id'] = Variable<int>(goalId.value);
    }
    if (contributedByAccountId.present) {
      map['contributed_by_account_id'] = Variable<int>(
        contributedByAccountId.value,
      );
    }
    if (amount.present) {
      map['amount'] = Variable<int>(
        $WalletGoalContributionsTable.$converteramount.toSql(amount.value),
      );
    }
    if (contributedAt.present) {
      map['contributed_at'] = Variable<DateTime>(contributedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('WalletGoalContributionsCompanion(')
          ..write('id: $id, ')
          ..write('walletId: $walletId, ')
          ..write('goalId: $goalId, ')
          ..write('contributedByAccountId: $contributedByAccountId, ')
          ..write('amount: $amount, ')
          ..write('contributedAt: $contributedAt')
          ..write(')'))
        .toString();
  }
}

class $WalletGoalSchedulesTable extends WalletGoalSchedules
    with TableInfo<$WalletGoalSchedulesTable, WalletGoalSchedule> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $WalletGoalSchedulesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _walletGoalIdMeta = const VerificationMeta(
    'walletGoalId',
  );
  @override
  late final GeneratedColumn<int> walletGoalId = GeneratedColumn<int>(
    'wallet_goal_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _memberIdMeta = const VerificationMeta(
    'memberId',
  );
  @override
  late final GeneratedColumn<int> memberId = GeneratedColumn<int>(
    'member_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  @override
  late final GeneratedColumnWithTypeConverter<double, int> amount =
      GeneratedColumn<int>(
        'amount',
        aliasedName,
        false,
        type: DriftSqlType.int,
        requiredDuringInsert: true,
      ).withConverter<double>($WalletGoalSchedulesTable.$converteramount);
  @override
  late final GeneratedColumnWithTypeConverter<
    WalletGoalScheduleFrequency,
    String
  >
  frequency =
      GeneratedColumn<String>(
        'frequency',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      ).withConverter<WalletGoalScheduleFrequency>(
        $WalletGoalSchedulesTable.$converterfrequency,
      );
  static const VerificationMeta _startDateMeta = const VerificationMeta(
    'startDate',
  );
  @override
  late final GeneratedColumn<DateTime> startDate = GeneratedColumn<DateTime>(
    'start_date',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _nextDueDateMeta = const VerificationMeta(
    'nextDueDate',
  );
  @override
  late final GeneratedColumn<DateTime> nextDueDate = GeneratedColumn<DateTime>(
    'next_due_date',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _isActiveMeta = const VerificationMeta(
    'isActive',
  );
  @override
  late final GeneratedColumn<bool> isActive = GeneratedColumn<bool>(
    'is_active',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_active" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
  );
  static const VerificationMeta _createdByAccountIdMeta =
      const VerificationMeta('createdByAccountId');
  @override
  late final GeneratedColumn<int> createdByAccountId = GeneratedColumn<int>(
    'created_by_account_id',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _updatedByAccountIdMeta =
      const VerificationMeta('updatedByAccountId');
  @override
  late final GeneratedColumn<int> updatedByAccountId = GeneratedColumn<int>(
    'updated_by_account_id',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    clientDefault: () => DateTime.now(),
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    clientDefault: () => DateTime.now(),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    walletGoalId,
    memberId,
    amount,
    frequency,
    startDate,
    nextDueDate,
    isActive,
    createdByAccountId,
    updatedByAccountId,
    createdAt,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'wallet_goal_schedules';
  @override
  VerificationContext validateIntegrity(
    Insertable<WalletGoalSchedule> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('wallet_goal_id')) {
      context.handle(
        _walletGoalIdMeta,
        walletGoalId.isAcceptableOrUnknown(
          data['wallet_goal_id']!,
          _walletGoalIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_walletGoalIdMeta);
    }
    if (data.containsKey('member_id')) {
      context.handle(
        _memberIdMeta,
        memberId.isAcceptableOrUnknown(data['member_id']!, _memberIdMeta),
      );
    } else if (isInserting) {
      context.missing(_memberIdMeta);
    }
    if (data.containsKey('start_date')) {
      context.handle(
        _startDateMeta,
        startDate.isAcceptableOrUnknown(data['start_date']!, _startDateMeta),
      );
    } else if (isInserting) {
      context.missing(_startDateMeta);
    }
    if (data.containsKey('next_due_date')) {
      context.handle(
        _nextDueDateMeta,
        nextDueDate.isAcceptableOrUnknown(
          data['next_due_date']!,
          _nextDueDateMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_nextDueDateMeta);
    }
    if (data.containsKey('is_active')) {
      context.handle(
        _isActiveMeta,
        isActive.isAcceptableOrUnknown(data['is_active']!, _isActiveMeta),
      );
    }
    if (data.containsKey('created_by_account_id')) {
      context.handle(
        _createdByAccountIdMeta,
        createdByAccountId.isAcceptableOrUnknown(
          data['created_by_account_id']!,
          _createdByAccountIdMeta,
        ),
      );
    }
    if (data.containsKey('updated_by_account_id')) {
      context.handle(
        _updatedByAccountIdMeta,
        updatedByAccountId.isAcceptableOrUnknown(
          data['updated_by_account_id']!,
          _updatedByAccountIdMeta,
        ),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  WalletGoalSchedule map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return WalletGoalSchedule(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      walletGoalId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}wallet_goal_id'],
      )!,
      memberId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}member_id'],
      )!,
      amount: $WalletGoalSchedulesTable.$converteramount.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.int,
          data['${effectivePrefix}amount'],
        )!,
      ),
      frequency: $WalletGoalSchedulesTable.$converterfrequency.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}frequency'],
        )!,
      ),
      startDate: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}start_date'],
      )!,
      nextDueDate: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}next_due_date'],
      )!,
      isActive: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_active'],
      )!,
      createdByAccountId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}created_by_account_id'],
      ),
      updatedByAccountId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}updated_by_account_id'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $WalletGoalSchedulesTable createAlias(String alias) {
    return $WalletGoalSchedulesTable(attachedDatabase, alias);
  }

  static TypeConverter<double, int> $converteramount = const MoneyConverter();
  static JsonTypeConverter2<WalletGoalScheduleFrequency, String, String>
  $converterfrequency = const EnumNameConverter(
    WalletGoalScheduleFrequency.values,
  );
}

class WalletGoalSchedule extends DataClass
    implements Insertable<WalletGoalSchedule> {
  final int id;
  final int walletGoalId;
  final int memberId;
  final double amount;
  final WalletGoalScheduleFrequency frequency;
  final DateTime startDate;
  final DateTime nextDueDate;
  final bool isActive;
  final int? createdByAccountId;
  final int? updatedByAccountId;
  final DateTime createdAt;
  final DateTime updatedAt;
  const WalletGoalSchedule({
    required this.id,
    required this.walletGoalId,
    required this.memberId,
    required this.amount,
    required this.frequency,
    required this.startDate,
    required this.nextDueDate,
    required this.isActive,
    this.createdByAccountId,
    this.updatedByAccountId,
    required this.createdAt,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['wallet_goal_id'] = Variable<int>(walletGoalId);
    map['member_id'] = Variable<int>(memberId);
    {
      map['amount'] = Variable<int>(
        $WalletGoalSchedulesTable.$converteramount.toSql(amount),
      );
    }
    {
      map['frequency'] = Variable<String>(
        $WalletGoalSchedulesTable.$converterfrequency.toSql(frequency),
      );
    }
    map['start_date'] = Variable<DateTime>(startDate);
    map['next_due_date'] = Variable<DateTime>(nextDueDate);
    map['is_active'] = Variable<bool>(isActive);
    if (!nullToAbsent || createdByAccountId != null) {
      map['created_by_account_id'] = Variable<int>(createdByAccountId);
    }
    if (!nullToAbsent || updatedByAccountId != null) {
      map['updated_by_account_id'] = Variable<int>(updatedByAccountId);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  WalletGoalSchedulesCompanion toCompanion(bool nullToAbsent) {
    return WalletGoalSchedulesCompanion(
      id: Value(id),
      walletGoalId: Value(walletGoalId),
      memberId: Value(memberId),
      amount: Value(amount),
      frequency: Value(frequency),
      startDate: Value(startDate),
      nextDueDate: Value(nextDueDate),
      isActive: Value(isActive),
      createdByAccountId: createdByAccountId == null && nullToAbsent
          ? const Value.absent()
          : Value(createdByAccountId),
      updatedByAccountId: updatedByAccountId == null && nullToAbsent
          ? const Value.absent()
          : Value(updatedByAccountId),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory WalletGoalSchedule.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return WalletGoalSchedule(
      id: serializer.fromJson<int>(json['id']),
      walletGoalId: serializer.fromJson<int>(json['walletGoalId']),
      memberId: serializer.fromJson<int>(json['memberId']),
      amount: serializer.fromJson<double>(json['amount']),
      frequency: $WalletGoalSchedulesTable.$converterfrequency.fromJson(
        serializer.fromJson<String>(json['frequency']),
      ),
      startDate: serializer.fromJson<DateTime>(json['startDate']),
      nextDueDate: serializer.fromJson<DateTime>(json['nextDueDate']),
      isActive: serializer.fromJson<bool>(json['isActive']),
      createdByAccountId: serializer.fromJson<int?>(json['createdByAccountId']),
      updatedByAccountId: serializer.fromJson<int?>(json['updatedByAccountId']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'walletGoalId': serializer.toJson<int>(walletGoalId),
      'memberId': serializer.toJson<int>(memberId),
      'amount': serializer.toJson<double>(amount),
      'frequency': serializer.toJson<String>(
        $WalletGoalSchedulesTable.$converterfrequency.toJson(frequency),
      ),
      'startDate': serializer.toJson<DateTime>(startDate),
      'nextDueDate': serializer.toJson<DateTime>(nextDueDate),
      'isActive': serializer.toJson<bool>(isActive),
      'createdByAccountId': serializer.toJson<int?>(createdByAccountId),
      'updatedByAccountId': serializer.toJson<int?>(updatedByAccountId),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  WalletGoalSchedule copyWith({
    int? id,
    int? walletGoalId,
    int? memberId,
    double? amount,
    WalletGoalScheduleFrequency? frequency,
    DateTime? startDate,
    DateTime? nextDueDate,
    bool? isActive,
    Value<int?> createdByAccountId = const Value.absent(),
    Value<int?> updatedByAccountId = const Value.absent(),
    DateTime? createdAt,
    DateTime? updatedAt,
  }) => WalletGoalSchedule(
    id: id ?? this.id,
    walletGoalId: walletGoalId ?? this.walletGoalId,
    memberId: memberId ?? this.memberId,
    amount: amount ?? this.amount,
    frequency: frequency ?? this.frequency,
    startDate: startDate ?? this.startDate,
    nextDueDate: nextDueDate ?? this.nextDueDate,
    isActive: isActive ?? this.isActive,
    createdByAccountId: createdByAccountId.present
        ? createdByAccountId.value
        : this.createdByAccountId,
    updatedByAccountId: updatedByAccountId.present
        ? updatedByAccountId.value
        : this.updatedByAccountId,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  WalletGoalSchedule copyWithCompanion(WalletGoalSchedulesCompanion data) {
    return WalletGoalSchedule(
      id: data.id.present ? data.id.value : this.id,
      walletGoalId: data.walletGoalId.present
          ? data.walletGoalId.value
          : this.walletGoalId,
      memberId: data.memberId.present ? data.memberId.value : this.memberId,
      amount: data.amount.present ? data.amount.value : this.amount,
      frequency: data.frequency.present ? data.frequency.value : this.frequency,
      startDate: data.startDate.present ? data.startDate.value : this.startDate,
      nextDueDate: data.nextDueDate.present
          ? data.nextDueDate.value
          : this.nextDueDate,
      isActive: data.isActive.present ? data.isActive.value : this.isActive,
      createdByAccountId: data.createdByAccountId.present
          ? data.createdByAccountId.value
          : this.createdByAccountId,
      updatedByAccountId: data.updatedByAccountId.present
          ? data.updatedByAccountId.value
          : this.updatedByAccountId,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('WalletGoalSchedule(')
          ..write('id: $id, ')
          ..write('walletGoalId: $walletGoalId, ')
          ..write('memberId: $memberId, ')
          ..write('amount: $amount, ')
          ..write('frequency: $frequency, ')
          ..write('startDate: $startDate, ')
          ..write('nextDueDate: $nextDueDate, ')
          ..write('isActive: $isActive, ')
          ..write('createdByAccountId: $createdByAccountId, ')
          ..write('updatedByAccountId: $updatedByAccountId, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    walletGoalId,
    memberId,
    amount,
    frequency,
    startDate,
    nextDueDate,
    isActive,
    createdByAccountId,
    updatedByAccountId,
    createdAt,
    updatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is WalletGoalSchedule &&
          other.id == this.id &&
          other.walletGoalId == this.walletGoalId &&
          other.memberId == this.memberId &&
          other.amount == this.amount &&
          other.frequency == this.frequency &&
          other.startDate == this.startDate &&
          other.nextDueDate == this.nextDueDate &&
          other.isActive == this.isActive &&
          other.createdByAccountId == this.createdByAccountId &&
          other.updatedByAccountId == this.updatedByAccountId &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class WalletGoalSchedulesCompanion extends UpdateCompanion<WalletGoalSchedule> {
  final Value<int> id;
  final Value<int> walletGoalId;
  final Value<int> memberId;
  final Value<double> amount;
  final Value<WalletGoalScheduleFrequency> frequency;
  final Value<DateTime> startDate;
  final Value<DateTime> nextDueDate;
  final Value<bool> isActive;
  final Value<int?> createdByAccountId;
  final Value<int?> updatedByAccountId;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  const WalletGoalSchedulesCompanion({
    this.id = const Value.absent(),
    this.walletGoalId = const Value.absent(),
    this.memberId = const Value.absent(),
    this.amount = const Value.absent(),
    this.frequency = const Value.absent(),
    this.startDate = const Value.absent(),
    this.nextDueDate = const Value.absent(),
    this.isActive = const Value.absent(),
    this.createdByAccountId = const Value.absent(),
    this.updatedByAccountId = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  });
  WalletGoalSchedulesCompanion.insert({
    this.id = const Value.absent(),
    required int walletGoalId,
    required int memberId,
    required double amount,
    required WalletGoalScheduleFrequency frequency,
    required DateTime startDate,
    required DateTime nextDueDate,
    this.isActive = const Value.absent(),
    this.createdByAccountId = const Value.absent(),
    this.updatedByAccountId = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  }) : walletGoalId = Value(walletGoalId),
       memberId = Value(memberId),
       amount = Value(amount),
       frequency = Value(frequency),
       startDate = Value(startDate),
       nextDueDate = Value(nextDueDate);
  static Insertable<WalletGoalSchedule> custom({
    Expression<int>? id,
    Expression<int>? walletGoalId,
    Expression<int>? memberId,
    Expression<int>? amount,
    Expression<String>? frequency,
    Expression<DateTime>? startDate,
    Expression<DateTime>? nextDueDate,
    Expression<bool>? isActive,
    Expression<int>? createdByAccountId,
    Expression<int>? updatedByAccountId,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (walletGoalId != null) 'wallet_goal_id': walletGoalId,
      if (memberId != null) 'member_id': memberId,
      if (amount != null) 'amount': amount,
      if (frequency != null) 'frequency': frequency,
      if (startDate != null) 'start_date': startDate,
      if (nextDueDate != null) 'next_due_date': nextDueDate,
      if (isActive != null) 'is_active': isActive,
      if (createdByAccountId != null)
        'created_by_account_id': createdByAccountId,
      if (updatedByAccountId != null)
        'updated_by_account_id': updatedByAccountId,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
    });
  }

  WalletGoalSchedulesCompanion copyWith({
    Value<int>? id,
    Value<int>? walletGoalId,
    Value<int>? memberId,
    Value<double>? amount,
    Value<WalletGoalScheduleFrequency>? frequency,
    Value<DateTime>? startDate,
    Value<DateTime>? nextDueDate,
    Value<bool>? isActive,
    Value<int?>? createdByAccountId,
    Value<int?>? updatedByAccountId,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
  }) {
    return WalletGoalSchedulesCompanion(
      id: id ?? this.id,
      walletGoalId: walletGoalId ?? this.walletGoalId,
      memberId: memberId ?? this.memberId,
      amount: amount ?? this.amount,
      frequency: frequency ?? this.frequency,
      startDate: startDate ?? this.startDate,
      nextDueDate: nextDueDate ?? this.nextDueDate,
      isActive: isActive ?? this.isActive,
      createdByAccountId: createdByAccountId ?? this.createdByAccountId,
      updatedByAccountId: updatedByAccountId ?? this.updatedByAccountId,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (walletGoalId.present) {
      map['wallet_goal_id'] = Variable<int>(walletGoalId.value);
    }
    if (memberId.present) {
      map['member_id'] = Variable<int>(memberId.value);
    }
    if (amount.present) {
      map['amount'] = Variable<int>(
        $WalletGoalSchedulesTable.$converteramount.toSql(amount.value),
      );
    }
    if (frequency.present) {
      map['frequency'] = Variable<String>(
        $WalletGoalSchedulesTable.$converterfrequency.toSql(frequency.value),
      );
    }
    if (startDate.present) {
      map['start_date'] = Variable<DateTime>(startDate.value);
    }
    if (nextDueDate.present) {
      map['next_due_date'] = Variable<DateTime>(nextDueDate.value);
    }
    if (isActive.present) {
      map['is_active'] = Variable<bool>(isActive.value);
    }
    if (createdByAccountId.present) {
      map['created_by_account_id'] = Variable<int>(createdByAccountId.value);
    }
    if (updatedByAccountId.present) {
      map['updated_by_account_id'] = Variable<int>(updatedByAccountId.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('WalletGoalSchedulesCompanion(')
          ..write('id: $id, ')
          ..write('walletGoalId: $walletGoalId, ')
          ..write('memberId: $memberId, ')
          ..write('amount: $amount, ')
          ..write('frequency: $frequency, ')
          ..write('startDate: $startDate, ')
          ..write('nextDueDate: $nextDueDate, ')
          ..write('isActive: $isActive, ')
          ..write('createdByAccountId: $createdByAccountId, ')
          ..write('updatedByAccountId: $updatedByAccountId, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }
}

class $FeedbackEntriesTable extends FeedbackEntries
    with TableInfo<$FeedbackEntriesTable, FeedbackEntry> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $FeedbackEntriesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _walletIdMeta = const VerificationMeta(
    'walletId',
  );
  @override
  late final GeneratedColumn<int> walletId = GeneratedColumn<int>(
    'wallet_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  @override
  late final GeneratedColumnWithTypeConverter<FeedbackCategory, String>
  category = GeneratedColumn<String>(
    'category',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  ).withConverter<FeedbackCategory>($FeedbackEntriesTable.$convertercategory);
  @override
  late final GeneratedColumnWithTypeConverter<FeedbackSeverity, String>
  severity = GeneratedColumn<String>(
    'severity',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  ).withConverter<FeedbackSeverity>($FeedbackEntriesTable.$converterseverity);
  static const VerificationMeta _workflowMeta = const VerificationMeta(
    'workflow',
  );
  @override
  late final GeneratedColumn<String> workflow = GeneratedColumn<String>(
    'workflow',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 1,
      maxTextLength: 80,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _descriptionMeta = const VerificationMeta(
    'description',
  );
  @override
  late final GeneratedColumn<String> description = GeneratedColumn<String>(
    'description',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 1,
      maxTextLength: 500,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  late final GeneratedColumnWithTypeConverter<FeedbackResolutionStatus, String>
  resolutionStatus =
      GeneratedColumn<String>(
        'resolution_status',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      ).withConverter<FeedbackResolutionStatus>(
        $FeedbackEntriesTable.$converterresolutionStatus,
      );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    clientDefault: () => DateTime.now(),
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    clientDefault: () => DateTime.now(),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    walletId,
    category,
    severity,
    workflow,
    description,
    resolutionStatus,
    createdAt,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'feedback_entries';
  @override
  VerificationContext validateIntegrity(
    Insertable<FeedbackEntry> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('wallet_id')) {
      context.handle(
        _walletIdMeta,
        walletId.isAcceptableOrUnknown(data['wallet_id']!, _walletIdMeta),
      );
    } else if (isInserting) {
      context.missing(_walletIdMeta);
    }
    if (data.containsKey('workflow')) {
      context.handle(
        _workflowMeta,
        workflow.isAcceptableOrUnknown(data['workflow']!, _workflowMeta),
      );
    } else if (isInserting) {
      context.missing(_workflowMeta);
    }
    if (data.containsKey('description')) {
      context.handle(
        _descriptionMeta,
        description.isAcceptableOrUnknown(
          data['description']!,
          _descriptionMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_descriptionMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  FeedbackEntry map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return FeedbackEntry(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      walletId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}wallet_id'],
      )!,
      category: $FeedbackEntriesTable.$convertercategory.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}category'],
        )!,
      ),
      severity: $FeedbackEntriesTable.$converterseverity.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}severity'],
        )!,
      ),
      workflow: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}workflow'],
      )!,
      description: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}description'],
      )!,
      resolutionStatus: $FeedbackEntriesTable.$converterresolutionStatus
          .fromSql(
            attachedDatabase.typeMapping.read(
              DriftSqlType.string,
              data['${effectivePrefix}resolution_status'],
            )!,
          ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $FeedbackEntriesTable createAlias(String alias) {
    return $FeedbackEntriesTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<FeedbackCategory, String, String>
  $convertercategory = const EnumNameConverter(FeedbackCategory.values);
  static JsonTypeConverter2<FeedbackSeverity, String, String>
  $converterseverity = const EnumNameConverter(FeedbackSeverity.values);
  static JsonTypeConverter2<FeedbackResolutionStatus, String, String>
  $converterresolutionStatus = const EnumNameConverter(
    FeedbackResolutionStatus.values,
  );
}

class FeedbackEntry extends DataClass implements Insertable<FeedbackEntry> {
  final int id;
  final int walletId;
  final FeedbackCategory category;
  final FeedbackSeverity severity;
  final String workflow;
  final String description;
  final FeedbackResolutionStatus resolutionStatus;
  final DateTime createdAt;
  final DateTime updatedAt;
  const FeedbackEntry({
    required this.id,
    required this.walletId,
    required this.category,
    required this.severity,
    required this.workflow,
    required this.description,
    required this.resolutionStatus,
    required this.createdAt,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['wallet_id'] = Variable<int>(walletId);
    {
      map['category'] = Variable<String>(
        $FeedbackEntriesTable.$convertercategory.toSql(category),
      );
    }
    {
      map['severity'] = Variable<String>(
        $FeedbackEntriesTable.$converterseverity.toSql(severity),
      );
    }
    map['workflow'] = Variable<String>(workflow);
    map['description'] = Variable<String>(description);
    {
      map['resolution_status'] = Variable<String>(
        $FeedbackEntriesTable.$converterresolutionStatus.toSql(
          resolutionStatus,
        ),
      );
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  FeedbackEntriesCompanion toCompanion(bool nullToAbsent) {
    return FeedbackEntriesCompanion(
      id: Value(id),
      walletId: Value(walletId),
      category: Value(category),
      severity: Value(severity),
      workflow: Value(workflow),
      description: Value(description),
      resolutionStatus: Value(resolutionStatus),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory FeedbackEntry.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return FeedbackEntry(
      id: serializer.fromJson<int>(json['id']),
      walletId: serializer.fromJson<int>(json['walletId']),
      category: $FeedbackEntriesTable.$convertercategory.fromJson(
        serializer.fromJson<String>(json['category']),
      ),
      severity: $FeedbackEntriesTable.$converterseverity.fromJson(
        serializer.fromJson<String>(json['severity']),
      ),
      workflow: serializer.fromJson<String>(json['workflow']),
      description: serializer.fromJson<String>(json['description']),
      resolutionStatus: $FeedbackEntriesTable.$converterresolutionStatus
          .fromJson(serializer.fromJson<String>(json['resolutionStatus'])),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'walletId': serializer.toJson<int>(walletId),
      'category': serializer.toJson<String>(
        $FeedbackEntriesTable.$convertercategory.toJson(category),
      ),
      'severity': serializer.toJson<String>(
        $FeedbackEntriesTable.$converterseverity.toJson(severity),
      ),
      'workflow': serializer.toJson<String>(workflow),
      'description': serializer.toJson<String>(description),
      'resolutionStatus': serializer.toJson<String>(
        $FeedbackEntriesTable.$converterresolutionStatus.toJson(
          resolutionStatus,
        ),
      ),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  FeedbackEntry copyWith({
    int? id,
    int? walletId,
    FeedbackCategory? category,
    FeedbackSeverity? severity,
    String? workflow,
    String? description,
    FeedbackResolutionStatus? resolutionStatus,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) => FeedbackEntry(
    id: id ?? this.id,
    walletId: walletId ?? this.walletId,
    category: category ?? this.category,
    severity: severity ?? this.severity,
    workflow: workflow ?? this.workflow,
    description: description ?? this.description,
    resolutionStatus: resolutionStatus ?? this.resolutionStatus,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  FeedbackEntry copyWithCompanion(FeedbackEntriesCompanion data) {
    return FeedbackEntry(
      id: data.id.present ? data.id.value : this.id,
      walletId: data.walletId.present ? data.walletId.value : this.walletId,
      category: data.category.present ? data.category.value : this.category,
      severity: data.severity.present ? data.severity.value : this.severity,
      workflow: data.workflow.present ? data.workflow.value : this.workflow,
      description: data.description.present
          ? data.description.value
          : this.description,
      resolutionStatus: data.resolutionStatus.present
          ? data.resolutionStatus.value
          : this.resolutionStatus,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('FeedbackEntry(')
          ..write('id: $id, ')
          ..write('walletId: $walletId, ')
          ..write('category: $category, ')
          ..write('severity: $severity, ')
          ..write('workflow: $workflow, ')
          ..write('description: $description, ')
          ..write('resolutionStatus: $resolutionStatus, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    walletId,
    category,
    severity,
    workflow,
    description,
    resolutionStatus,
    createdAt,
    updatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is FeedbackEntry &&
          other.id == this.id &&
          other.walletId == this.walletId &&
          other.category == this.category &&
          other.severity == this.severity &&
          other.workflow == this.workflow &&
          other.description == this.description &&
          other.resolutionStatus == this.resolutionStatus &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class FeedbackEntriesCompanion extends UpdateCompanion<FeedbackEntry> {
  final Value<int> id;
  final Value<int> walletId;
  final Value<FeedbackCategory> category;
  final Value<FeedbackSeverity> severity;
  final Value<String> workflow;
  final Value<String> description;
  final Value<FeedbackResolutionStatus> resolutionStatus;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  const FeedbackEntriesCompanion({
    this.id = const Value.absent(),
    this.walletId = const Value.absent(),
    this.category = const Value.absent(),
    this.severity = const Value.absent(),
    this.workflow = const Value.absent(),
    this.description = const Value.absent(),
    this.resolutionStatus = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  });
  FeedbackEntriesCompanion.insert({
    this.id = const Value.absent(),
    required int walletId,
    required FeedbackCategory category,
    required FeedbackSeverity severity,
    required String workflow,
    required String description,
    required FeedbackResolutionStatus resolutionStatus,
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  }) : walletId = Value(walletId),
       category = Value(category),
       severity = Value(severity),
       workflow = Value(workflow),
       description = Value(description),
       resolutionStatus = Value(resolutionStatus);
  static Insertable<FeedbackEntry> custom({
    Expression<int>? id,
    Expression<int>? walletId,
    Expression<String>? category,
    Expression<String>? severity,
    Expression<String>? workflow,
    Expression<String>? description,
    Expression<String>? resolutionStatus,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (walletId != null) 'wallet_id': walletId,
      if (category != null) 'category': category,
      if (severity != null) 'severity': severity,
      if (workflow != null) 'workflow': workflow,
      if (description != null) 'description': description,
      if (resolutionStatus != null) 'resolution_status': resolutionStatus,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
    });
  }

  FeedbackEntriesCompanion copyWith({
    Value<int>? id,
    Value<int>? walletId,
    Value<FeedbackCategory>? category,
    Value<FeedbackSeverity>? severity,
    Value<String>? workflow,
    Value<String>? description,
    Value<FeedbackResolutionStatus>? resolutionStatus,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
  }) {
    return FeedbackEntriesCompanion(
      id: id ?? this.id,
      walletId: walletId ?? this.walletId,
      category: category ?? this.category,
      severity: severity ?? this.severity,
      workflow: workflow ?? this.workflow,
      description: description ?? this.description,
      resolutionStatus: resolutionStatus ?? this.resolutionStatus,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (walletId.present) {
      map['wallet_id'] = Variable<int>(walletId.value);
    }
    if (category.present) {
      map['category'] = Variable<String>(
        $FeedbackEntriesTable.$convertercategory.toSql(category.value),
      );
    }
    if (severity.present) {
      map['severity'] = Variable<String>(
        $FeedbackEntriesTable.$converterseverity.toSql(severity.value),
      );
    }
    if (workflow.present) {
      map['workflow'] = Variable<String>(workflow.value);
    }
    if (description.present) {
      map['description'] = Variable<String>(description.value);
    }
    if (resolutionStatus.present) {
      map['resolution_status'] = Variable<String>(
        $FeedbackEntriesTable.$converterresolutionStatus.toSql(
          resolutionStatus.value,
        ),
      );
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('FeedbackEntriesCompanion(')
          ..write('id: $id, ')
          ..write('walletId: $walletId, ')
          ..write('category: $category, ')
          ..write('severity: $severity, ')
          ..write('workflow: $workflow, ')
          ..write('description: $description, ')
          ..write('resolutionStatus: $resolutionStatus, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }
}

class $WalletNotificationPreferencesTable extends WalletNotificationPreferences
    with
        TableInfo<
          $WalletNotificationPreferencesTable,
          WalletNotificationPreference
        > {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $WalletNotificationPreferencesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _walletIdMeta = const VerificationMeta(
    'walletId',
  );
  @override
  late final GeneratedColumn<int> walletId = GeneratedColumn<int>(
    'wallet_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _billRemindersMeta = const VerificationMeta(
    'billReminders',
  );
  @override
  late final GeneratedColumn<bool> billReminders = GeneratedColumn<bool>(
    'bill_reminders',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("bill_reminders" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
  );
  static const VerificationMeta _goalRemindersMeta = const VerificationMeta(
    'goalReminders',
  );
  @override
  late final GeneratedColumn<bool> goalReminders = GeneratedColumn<bool>(
    'goal_reminders',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("goal_reminders" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
  );
  static const VerificationMeta _allowanceRemindersMeta =
      const VerificationMeta('allowanceReminders');
  @override
  late final GeneratedColumn<bool> allowanceReminders = GeneratedColumn<bool>(
    'allowance_reminders',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("allowance_reminders" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
  );
  static const VerificationMeta _settlementRemindersMeta =
      const VerificationMeta('settlementReminders');
  @override
  late final GeneratedColumn<bool> settlementReminders = GeneratedColumn<bool>(
    'settlement_reminders',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("settlement_reminders" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    clientDefault: () => DateTime.now(),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    walletId,
    billReminders,
    goalReminders,
    allowanceReminders,
    settlementReminders,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'wallet_notification_preferences';
  @override
  VerificationContext validateIntegrity(
    Insertable<WalletNotificationPreference> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('wallet_id')) {
      context.handle(
        _walletIdMeta,
        walletId.isAcceptableOrUnknown(data['wallet_id']!, _walletIdMeta),
      );
    } else if (isInserting) {
      context.missing(_walletIdMeta);
    }
    if (data.containsKey('bill_reminders')) {
      context.handle(
        _billRemindersMeta,
        billReminders.isAcceptableOrUnknown(
          data['bill_reminders']!,
          _billRemindersMeta,
        ),
      );
    }
    if (data.containsKey('goal_reminders')) {
      context.handle(
        _goalRemindersMeta,
        goalReminders.isAcceptableOrUnknown(
          data['goal_reminders']!,
          _goalRemindersMeta,
        ),
      );
    }
    if (data.containsKey('allowance_reminders')) {
      context.handle(
        _allowanceRemindersMeta,
        allowanceReminders.isAcceptableOrUnknown(
          data['allowance_reminders']!,
          _allowanceRemindersMeta,
        ),
      );
    }
    if (data.containsKey('settlement_reminders')) {
      context.handle(
        _settlementRemindersMeta,
        settlementReminders.isAcceptableOrUnknown(
          data['settlement_reminders']!,
          _settlementRemindersMeta,
        ),
      );
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  WalletNotificationPreference map(
    Map<String, dynamic> data, {
    String? tablePrefix,
  }) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return WalletNotificationPreference(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      walletId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}wallet_id'],
      )!,
      billReminders: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}bill_reminders'],
      )!,
      goalReminders: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}goal_reminders'],
      )!,
      allowanceReminders: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}allowance_reminders'],
      )!,
      settlementReminders: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}settlement_reminders'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $WalletNotificationPreferencesTable createAlias(String alias) {
    return $WalletNotificationPreferencesTable(attachedDatabase, alias);
  }
}

class WalletNotificationPreference extends DataClass
    implements Insertable<WalletNotificationPreference> {
  final int id;
  final int walletId;
  final bool billReminders;
  final bool goalReminders;
  final bool allowanceReminders;
  final bool settlementReminders;
  final DateTime updatedAt;
  const WalletNotificationPreference({
    required this.id,
    required this.walletId,
    required this.billReminders,
    required this.goalReminders,
    required this.allowanceReminders,
    required this.settlementReminders,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['wallet_id'] = Variable<int>(walletId);
    map['bill_reminders'] = Variable<bool>(billReminders);
    map['goal_reminders'] = Variable<bool>(goalReminders);
    map['allowance_reminders'] = Variable<bool>(allowanceReminders);
    map['settlement_reminders'] = Variable<bool>(settlementReminders);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  WalletNotificationPreferencesCompanion toCompanion(bool nullToAbsent) {
    return WalletNotificationPreferencesCompanion(
      id: Value(id),
      walletId: Value(walletId),
      billReminders: Value(billReminders),
      goalReminders: Value(goalReminders),
      allowanceReminders: Value(allowanceReminders),
      settlementReminders: Value(settlementReminders),
      updatedAt: Value(updatedAt),
    );
  }

  factory WalletNotificationPreference.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return WalletNotificationPreference(
      id: serializer.fromJson<int>(json['id']),
      walletId: serializer.fromJson<int>(json['walletId']),
      billReminders: serializer.fromJson<bool>(json['billReminders']),
      goalReminders: serializer.fromJson<bool>(json['goalReminders']),
      allowanceReminders: serializer.fromJson<bool>(json['allowanceReminders']),
      settlementReminders: serializer.fromJson<bool>(
        json['settlementReminders'],
      ),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'walletId': serializer.toJson<int>(walletId),
      'billReminders': serializer.toJson<bool>(billReminders),
      'goalReminders': serializer.toJson<bool>(goalReminders),
      'allowanceReminders': serializer.toJson<bool>(allowanceReminders),
      'settlementReminders': serializer.toJson<bool>(settlementReminders),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  WalletNotificationPreference copyWith({
    int? id,
    int? walletId,
    bool? billReminders,
    bool? goalReminders,
    bool? allowanceReminders,
    bool? settlementReminders,
    DateTime? updatedAt,
  }) => WalletNotificationPreference(
    id: id ?? this.id,
    walletId: walletId ?? this.walletId,
    billReminders: billReminders ?? this.billReminders,
    goalReminders: goalReminders ?? this.goalReminders,
    allowanceReminders: allowanceReminders ?? this.allowanceReminders,
    settlementReminders: settlementReminders ?? this.settlementReminders,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  WalletNotificationPreference copyWithCompanion(
    WalletNotificationPreferencesCompanion data,
  ) {
    return WalletNotificationPreference(
      id: data.id.present ? data.id.value : this.id,
      walletId: data.walletId.present ? data.walletId.value : this.walletId,
      billReminders: data.billReminders.present
          ? data.billReminders.value
          : this.billReminders,
      goalReminders: data.goalReminders.present
          ? data.goalReminders.value
          : this.goalReminders,
      allowanceReminders: data.allowanceReminders.present
          ? data.allowanceReminders.value
          : this.allowanceReminders,
      settlementReminders: data.settlementReminders.present
          ? data.settlementReminders.value
          : this.settlementReminders,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('WalletNotificationPreference(')
          ..write('id: $id, ')
          ..write('walletId: $walletId, ')
          ..write('billReminders: $billReminders, ')
          ..write('goalReminders: $goalReminders, ')
          ..write('allowanceReminders: $allowanceReminders, ')
          ..write('settlementReminders: $settlementReminders, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    walletId,
    billReminders,
    goalReminders,
    allowanceReminders,
    settlementReminders,
    updatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is WalletNotificationPreference &&
          other.id == this.id &&
          other.walletId == this.walletId &&
          other.billReminders == this.billReminders &&
          other.goalReminders == this.goalReminders &&
          other.allowanceReminders == this.allowanceReminders &&
          other.settlementReminders == this.settlementReminders &&
          other.updatedAt == this.updatedAt);
}

class WalletNotificationPreferencesCompanion
    extends UpdateCompanion<WalletNotificationPreference> {
  final Value<int> id;
  final Value<int> walletId;
  final Value<bool> billReminders;
  final Value<bool> goalReminders;
  final Value<bool> allowanceReminders;
  final Value<bool> settlementReminders;
  final Value<DateTime> updatedAt;
  const WalletNotificationPreferencesCompanion({
    this.id = const Value.absent(),
    this.walletId = const Value.absent(),
    this.billReminders = const Value.absent(),
    this.goalReminders = const Value.absent(),
    this.allowanceReminders = const Value.absent(),
    this.settlementReminders = const Value.absent(),
    this.updatedAt = const Value.absent(),
  });
  WalletNotificationPreferencesCompanion.insert({
    this.id = const Value.absent(),
    required int walletId,
    this.billReminders = const Value.absent(),
    this.goalReminders = const Value.absent(),
    this.allowanceReminders = const Value.absent(),
    this.settlementReminders = const Value.absent(),
    this.updatedAt = const Value.absent(),
  }) : walletId = Value(walletId);
  static Insertable<WalletNotificationPreference> custom({
    Expression<int>? id,
    Expression<int>? walletId,
    Expression<bool>? billReminders,
    Expression<bool>? goalReminders,
    Expression<bool>? allowanceReminders,
    Expression<bool>? settlementReminders,
    Expression<DateTime>? updatedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (walletId != null) 'wallet_id': walletId,
      if (billReminders != null) 'bill_reminders': billReminders,
      if (goalReminders != null) 'goal_reminders': goalReminders,
      if (allowanceReminders != null) 'allowance_reminders': allowanceReminders,
      if (settlementReminders != null)
        'settlement_reminders': settlementReminders,
      if (updatedAt != null) 'updated_at': updatedAt,
    });
  }

  WalletNotificationPreferencesCompanion copyWith({
    Value<int>? id,
    Value<int>? walletId,
    Value<bool>? billReminders,
    Value<bool>? goalReminders,
    Value<bool>? allowanceReminders,
    Value<bool>? settlementReminders,
    Value<DateTime>? updatedAt,
  }) {
    return WalletNotificationPreferencesCompanion(
      id: id ?? this.id,
      walletId: walletId ?? this.walletId,
      billReminders: billReminders ?? this.billReminders,
      goalReminders: goalReminders ?? this.goalReminders,
      allowanceReminders: allowanceReminders ?? this.allowanceReminders,
      settlementReminders: settlementReminders ?? this.settlementReminders,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (walletId.present) {
      map['wallet_id'] = Variable<int>(walletId.value);
    }
    if (billReminders.present) {
      map['bill_reminders'] = Variable<bool>(billReminders.value);
    }
    if (goalReminders.present) {
      map['goal_reminders'] = Variable<bool>(goalReminders.value);
    }
    if (allowanceReminders.present) {
      map['allowance_reminders'] = Variable<bool>(allowanceReminders.value);
    }
    if (settlementReminders.present) {
      map['settlement_reminders'] = Variable<bool>(settlementReminders.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('WalletNotificationPreferencesCompanion(')
          ..write('id: $id, ')
          ..write('walletId: $walletId, ')
          ..write('billReminders: $billReminders, ')
          ..write('goalReminders: $goalReminders, ')
          ..write('allowanceReminders: $allowanceReminders, ')
          ..write('settlementReminders: $settlementReminders, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }
}

class $DeletedRecordsTable extends DeletedRecords
    with TableInfo<$DeletedRecordsTable, DeletedRecord> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $DeletedRecordsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _uuidMeta = const VerificationMeta('uuid');
  @override
  late final GeneratedColumn<String> uuid = GeneratedColumn<String>(
    'uuid',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _deletedTableMeta = const VerificationMeta(
    'deletedTable',
  );
  @override
  late final GeneratedColumn<String> deletedTable = GeneratedColumn<String>(
    'table_name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _deletedAtMeta = const VerificationMeta(
    'deletedAt',
  );
  @override
  late final GeneratedColumn<DateTime> deletedAt = GeneratedColumn<DateTime>(
    'deleted_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [id, uuid, deletedTable, deletedAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'deleted_records';
  @override
  VerificationContext validateIntegrity(
    Insertable<DeletedRecord> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('uuid')) {
      context.handle(
        _uuidMeta,
        uuid.isAcceptableOrUnknown(data['uuid']!, _uuidMeta),
      );
    } else if (isInserting) {
      context.missing(_uuidMeta);
    }
    if (data.containsKey('table_name')) {
      context.handle(
        _deletedTableMeta,
        deletedTable.isAcceptableOrUnknown(
          data['table_name']!,
          _deletedTableMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_deletedTableMeta);
    }
    if (data.containsKey('deleted_at')) {
      context.handle(
        _deletedAtMeta,
        deletedAt.isAcceptableOrUnknown(data['deleted_at']!, _deletedAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  DeletedRecord map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return DeletedRecord(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      uuid: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}uuid'],
      )!,
      deletedTable: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}table_name'],
      )!,
      deletedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}deleted_at'],
      )!,
    );
  }

  @override
  $DeletedRecordsTable createAlias(String alias) {
    return $DeletedRecordsTable(attachedDatabase, alias);
  }
}

class DeletedRecord extends DataClass implements Insertable<DeletedRecord> {
  final int id;
  final String uuid;
  final String deletedTable;
  final DateTime deletedAt;
  const DeletedRecord({
    required this.id,
    required this.uuid,
    required this.deletedTable,
    required this.deletedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['uuid'] = Variable<String>(uuid);
    map['table_name'] = Variable<String>(deletedTable);
    map['deleted_at'] = Variable<DateTime>(deletedAt);
    return map;
  }

  DeletedRecordsCompanion toCompanion(bool nullToAbsent) {
    return DeletedRecordsCompanion(
      id: Value(id),
      uuid: Value(uuid),
      deletedTable: Value(deletedTable),
      deletedAt: Value(deletedAt),
    );
  }

  factory DeletedRecord.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return DeletedRecord(
      id: serializer.fromJson<int>(json['id']),
      uuid: serializer.fromJson<String>(json['uuid']),
      deletedTable: serializer.fromJson<String>(json['deletedTable']),
      deletedAt: serializer.fromJson<DateTime>(json['deletedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'uuid': serializer.toJson<String>(uuid),
      'deletedTable': serializer.toJson<String>(deletedTable),
      'deletedAt': serializer.toJson<DateTime>(deletedAt),
    };
  }

  DeletedRecord copyWith({
    int? id,
    String? uuid,
    String? deletedTable,
    DateTime? deletedAt,
  }) => DeletedRecord(
    id: id ?? this.id,
    uuid: uuid ?? this.uuid,
    deletedTable: deletedTable ?? this.deletedTable,
    deletedAt: deletedAt ?? this.deletedAt,
  );
  DeletedRecord copyWithCompanion(DeletedRecordsCompanion data) {
    return DeletedRecord(
      id: data.id.present ? data.id.value : this.id,
      uuid: data.uuid.present ? data.uuid.value : this.uuid,
      deletedTable: data.deletedTable.present
          ? data.deletedTable.value
          : this.deletedTable,
      deletedAt: data.deletedAt.present ? data.deletedAt.value : this.deletedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('DeletedRecord(')
          ..write('id: $id, ')
          ..write('uuid: $uuid, ')
          ..write('deletedTable: $deletedTable, ')
          ..write('deletedAt: $deletedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, uuid, deletedTable, deletedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is DeletedRecord &&
          other.id == this.id &&
          other.uuid == this.uuid &&
          other.deletedTable == this.deletedTable &&
          other.deletedAt == this.deletedAt);
}

class DeletedRecordsCompanion extends UpdateCompanion<DeletedRecord> {
  final Value<int> id;
  final Value<String> uuid;
  final Value<String> deletedTable;
  final Value<DateTime> deletedAt;
  const DeletedRecordsCompanion({
    this.id = const Value.absent(),
    this.uuid = const Value.absent(),
    this.deletedTable = const Value.absent(),
    this.deletedAt = const Value.absent(),
  });
  DeletedRecordsCompanion.insert({
    this.id = const Value.absent(),
    required String uuid,
    required String deletedTable,
    this.deletedAt = const Value.absent(),
  }) : uuid = Value(uuid),
       deletedTable = Value(deletedTable);
  static Insertable<DeletedRecord> custom({
    Expression<int>? id,
    Expression<String>? uuid,
    Expression<String>? deletedTable,
    Expression<DateTime>? deletedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (uuid != null) 'uuid': uuid,
      if (deletedTable != null) 'table_name': deletedTable,
      if (deletedAt != null) 'deleted_at': deletedAt,
    });
  }

  DeletedRecordsCompanion copyWith({
    Value<int>? id,
    Value<String>? uuid,
    Value<String>? deletedTable,
    Value<DateTime>? deletedAt,
  }) {
    return DeletedRecordsCompanion(
      id: id ?? this.id,
      uuid: uuid ?? this.uuid,
      deletedTable: deletedTable ?? this.deletedTable,
      deletedAt: deletedAt ?? this.deletedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (uuid.present) {
      map['uuid'] = Variable<String>(uuid.value);
    }
    if (deletedTable.present) {
      map['table_name'] = Variable<String>(deletedTable.value);
    }
    if (deletedAt.present) {
      map['deleted_at'] = Variable<DateTime>(deletedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('DeletedRecordsCompanion(')
          ..write('id: $id, ')
          ..write('uuid: $uuid, ')
          ..write('deletedTable: $deletedTable, ')
          ..write('deletedAt: $deletedAt')
          ..write(')'))
        .toString();
  }
}

class $AttachmentsTable extends Attachments
    with TableInfo<$AttachmentsTable, Attachment> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $AttachmentsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _transactionIdMeta = const VerificationMeta(
    'transactionId',
  );
  @override
  late final GeneratedColumn<int> transactionId = GeneratedColumn<int>(
    'transaction_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _filePathMeta = const VerificationMeta(
    'filePath',
  );
  @override
  late final GeneratedColumn<String> filePath = GeneratedColumn<String>(
    'file_path',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _fileTypeMeta = const VerificationMeta(
    'fileType',
  );
  @override
  late final GeneratedColumn<String> fileType = GeneratedColumn<String>(
    'file_type',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    clientDefault: () => DateTime.now(),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    transactionId,
    filePath,
    fileType,
    createdAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'attachments';
  @override
  VerificationContext validateIntegrity(
    Insertable<Attachment> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('transaction_id')) {
      context.handle(
        _transactionIdMeta,
        transactionId.isAcceptableOrUnknown(
          data['transaction_id']!,
          _transactionIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_transactionIdMeta);
    }
    if (data.containsKey('file_path')) {
      context.handle(
        _filePathMeta,
        filePath.isAcceptableOrUnknown(data['file_path']!, _filePathMeta),
      );
    } else if (isInserting) {
      context.missing(_filePathMeta);
    }
    if (data.containsKey('file_type')) {
      context.handle(
        _fileTypeMeta,
        fileType.isAcceptableOrUnknown(data['file_type']!, _fileTypeMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Attachment map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Attachment(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      transactionId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}transaction_id'],
      )!,
      filePath: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}file_path'],
      )!,
      fileType: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}file_type'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $AttachmentsTable createAlias(String alias) {
    return $AttachmentsTable(attachedDatabase, alias);
  }
}

class Attachment extends DataClass implements Insertable<Attachment> {
  final int id;
  final int transactionId;
  final String filePath;
  final String? fileType;
  final DateTime createdAt;
  const Attachment({
    required this.id,
    required this.transactionId,
    required this.filePath,
    this.fileType,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['transaction_id'] = Variable<int>(transactionId);
    map['file_path'] = Variable<String>(filePath);
    if (!nullToAbsent || fileType != null) {
      map['file_type'] = Variable<String>(fileType);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  AttachmentsCompanion toCompanion(bool nullToAbsent) {
    return AttachmentsCompanion(
      id: Value(id),
      transactionId: Value(transactionId),
      filePath: Value(filePath),
      fileType: fileType == null && nullToAbsent
          ? const Value.absent()
          : Value(fileType),
      createdAt: Value(createdAt),
    );
  }

  factory Attachment.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Attachment(
      id: serializer.fromJson<int>(json['id']),
      transactionId: serializer.fromJson<int>(json['transactionId']),
      filePath: serializer.fromJson<String>(json['filePath']),
      fileType: serializer.fromJson<String?>(json['fileType']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'transactionId': serializer.toJson<int>(transactionId),
      'filePath': serializer.toJson<String>(filePath),
      'fileType': serializer.toJson<String?>(fileType),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  Attachment copyWith({
    int? id,
    int? transactionId,
    String? filePath,
    Value<String?> fileType = const Value.absent(),
    DateTime? createdAt,
  }) => Attachment(
    id: id ?? this.id,
    transactionId: transactionId ?? this.transactionId,
    filePath: filePath ?? this.filePath,
    fileType: fileType.present ? fileType.value : this.fileType,
    createdAt: createdAt ?? this.createdAt,
  );
  Attachment copyWithCompanion(AttachmentsCompanion data) {
    return Attachment(
      id: data.id.present ? data.id.value : this.id,
      transactionId: data.transactionId.present
          ? data.transactionId.value
          : this.transactionId,
      filePath: data.filePath.present ? data.filePath.value : this.filePath,
      fileType: data.fileType.present ? data.fileType.value : this.fileType,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Attachment(')
          ..write('id: $id, ')
          ..write('transactionId: $transactionId, ')
          ..write('filePath: $filePath, ')
          ..write('fileType: $fileType, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, transactionId, filePath, fileType, createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Attachment &&
          other.id == this.id &&
          other.transactionId == this.transactionId &&
          other.filePath == this.filePath &&
          other.fileType == this.fileType &&
          other.createdAt == this.createdAt);
}

class AttachmentsCompanion extends UpdateCompanion<Attachment> {
  final Value<int> id;
  final Value<int> transactionId;
  final Value<String> filePath;
  final Value<String?> fileType;
  final Value<DateTime> createdAt;
  const AttachmentsCompanion({
    this.id = const Value.absent(),
    this.transactionId = const Value.absent(),
    this.filePath = const Value.absent(),
    this.fileType = const Value.absent(),
    this.createdAt = const Value.absent(),
  });
  AttachmentsCompanion.insert({
    this.id = const Value.absent(),
    required int transactionId,
    required String filePath,
    this.fileType = const Value.absent(),
    this.createdAt = const Value.absent(),
  }) : transactionId = Value(transactionId),
       filePath = Value(filePath);
  static Insertable<Attachment> custom({
    Expression<int>? id,
    Expression<int>? transactionId,
    Expression<String>? filePath,
    Expression<String>? fileType,
    Expression<DateTime>? createdAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (transactionId != null) 'transaction_id': transactionId,
      if (filePath != null) 'file_path': filePath,
      if (fileType != null) 'file_type': fileType,
      if (createdAt != null) 'created_at': createdAt,
    });
  }

  AttachmentsCompanion copyWith({
    Value<int>? id,
    Value<int>? transactionId,
    Value<String>? filePath,
    Value<String?>? fileType,
    Value<DateTime>? createdAt,
  }) {
    return AttachmentsCompanion(
      id: id ?? this.id,
      transactionId: transactionId ?? this.transactionId,
      filePath: filePath ?? this.filePath,
      fileType: fileType ?? this.fileType,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (transactionId.present) {
      map['transaction_id'] = Variable<int>(transactionId.value);
    }
    if (filePath.present) {
      map['file_path'] = Variable<String>(filePath.value);
    }
    if (fileType.present) {
      map['file_type'] = Variable<String>(fileType.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('AttachmentsCompanion(')
          ..write('id: $id, ')
          ..write('transactionId: $transactionId, ')
          ..write('filePath: $filePath, ')
          ..write('fileType: $fileType, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }
}

class $WalletExpenseSplitsTable extends WalletExpenseSplits
    with TableInfo<$WalletExpenseSplitsTable, WalletExpenseSplit> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $WalletExpenseSplitsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _walletIdMeta = const VerificationMeta(
    'walletId',
  );
  @override
  late final GeneratedColumn<int> walletId = GeneratedColumn<int>(
    'wallet_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _uuidMeta = const VerificationMeta('uuid');
  @override
  late final GeneratedColumn<String> uuid = GeneratedColumn<String>(
    'uuid',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    clientDefault: () => const Uuid().v4(),
  );
  static const VerificationMeta _transactionIdMeta = const VerificationMeta(
    'transactionId',
  );
  @override
  late final GeneratedColumn<int> transactionId = GeneratedColumn<int>(
    'transaction_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _paidByMemberIdMeta = const VerificationMeta(
    'paidByMemberId',
  );
  @override
  late final GeneratedColumn<int> paidByMemberId = GeneratedColumn<int>(
    'paid_by_member_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  @override
  late final GeneratedColumnWithTypeConverter<WalletExpenseSplitMethod, String>
  splitMethod =
      GeneratedColumn<String>(
        'split_method',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      ).withConverter<WalletExpenseSplitMethod>(
        $WalletExpenseSplitsTable.$convertersplitMethod,
      );
  static const VerificationMeta _createdByAccountIdMeta =
      const VerificationMeta('createdByAccountId');
  @override
  late final GeneratedColumn<int> createdByAccountId = GeneratedColumn<int>(
    'created_by_account_id',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    clientDefault: () => DateTime.now(),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    walletId,
    uuid,
    transactionId,
    paidByMemberId,
    splitMethod,
    createdByAccountId,
    createdAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'wallet_expense_splits';
  @override
  VerificationContext validateIntegrity(
    Insertable<WalletExpenseSplit> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('wallet_id')) {
      context.handle(
        _walletIdMeta,
        walletId.isAcceptableOrUnknown(data['wallet_id']!, _walletIdMeta),
      );
    } else if (isInserting) {
      context.missing(_walletIdMeta);
    }
    if (data.containsKey('uuid')) {
      context.handle(
        _uuidMeta,
        uuid.isAcceptableOrUnknown(data['uuid']!, _uuidMeta),
      );
    }
    if (data.containsKey('transaction_id')) {
      context.handle(
        _transactionIdMeta,
        transactionId.isAcceptableOrUnknown(
          data['transaction_id']!,
          _transactionIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_transactionIdMeta);
    }
    if (data.containsKey('paid_by_member_id')) {
      context.handle(
        _paidByMemberIdMeta,
        paidByMemberId.isAcceptableOrUnknown(
          data['paid_by_member_id']!,
          _paidByMemberIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_paidByMemberIdMeta);
    }
    if (data.containsKey('created_by_account_id')) {
      context.handle(
        _createdByAccountIdMeta,
        createdByAccountId.isAcceptableOrUnknown(
          data['created_by_account_id']!,
          _createdByAccountIdMeta,
        ),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  WalletExpenseSplit map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return WalletExpenseSplit(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      walletId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}wallet_id'],
      )!,
      uuid: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}uuid'],
      )!,
      transactionId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}transaction_id'],
      )!,
      paidByMemberId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}paid_by_member_id'],
      )!,
      splitMethod: $WalletExpenseSplitsTable.$convertersplitMethod.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}split_method'],
        )!,
      ),
      createdByAccountId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}created_by_account_id'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $WalletExpenseSplitsTable createAlias(String alias) {
    return $WalletExpenseSplitsTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<WalletExpenseSplitMethod, String, String>
  $convertersplitMethod = const EnumNameConverter(
    WalletExpenseSplitMethod.values,
  );
}

class WalletExpenseSplit extends DataClass
    implements Insertable<WalletExpenseSplit> {
  final int id;
  final int walletId;
  final String uuid;
  final int transactionId;
  final int paidByMemberId;
  final WalletExpenseSplitMethod splitMethod;
  final int? createdByAccountId;
  final DateTime createdAt;
  const WalletExpenseSplit({
    required this.id,
    required this.walletId,
    required this.uuid,
    required this.transactionId,
    required this.paidByMemberId,
    required this.splitMethod,
    this.createdByAccountId,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['wallet_id'] = Variable<int>(walletId);
    map['uuid'] = Variable<String>(uuid);
    map['transaction_id'] = Variable<int>(transactionId);
    map['paid_by_member_id'] = Variable<int>(paidByMemberId);
    {
      map['split_method'] = Variable<String>(
        $WalletExpenseSplitsTable.$convertersplitMethod.toSql(splitMethod),
      );
    }
    if (!nullToAbsent || createdByAccountId != null) {
      map['created_by_account_id'] = Variable<int>(createdByAccountId);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  WalletExpenseSplitsCompanion toCompanion(bool nullToAbsent) {
    return WalletExpenseSplitsCompanion(
      id: Value(id),
      walletId: Value(walletId),
      uuid: Value(uuid),
      transactionId: Value(transactionId),
      paidByMemberId: Value(paidByMemberId),
      splitMethod: Value(splitMethod),
      createdByAccountId: createdByAccountId == null && nullToAbsent
          ? const Value.absent()
          : Value(createdByAccountId),
      createdAt: Value(createdAt),
    );
  }

  factory WalletExpenseSplit.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return WalletExpenseSplit(
      id: serializer.fromJson<int>(json['id']),
      walletId: serializer.fromJson<int>(json['walletId']),
      uuid: serializer.fromJson<String>(json['uuid']),
      transactionId: serializer.fromJson<int>(json['transactionId']),
      paidByMemberId: serializer.fromJson<int>(json['paidByMemberId']),
      splitMethod: $WalletExpenseSplitsTable.$convertersplitMethod.fromJson(
        serializer.fromJson<String>(json['splitMethod']),
      ),
      createdByAccountId: serializer.fromJson<int?>(json['createdByAccountId']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'walletId': serializer.toJson<int>(walletId),
      'uuid': serializer.toJson<String>(uuid),
      'transactionId': serializer.toJson<int>(transactionId),
      'paidByMemberId': serializer.toJson<int>(paidByMemberId),
      'splitMethod': serializer.toJson<String>(
        $WalletExpenseSplitsTable.$convertersplitMethod.toJson(splitMethod),
      ),
      'createdByAccountId': serializer.toJson<int?>(createdByAccountId),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  WalletExpenseSplit copyWith({
    int? id,
    int? walletId,
    String? uuid,
    int? transactionId,
    int? paidByMemberId,
    WalletExpenseSplitMethod? splitMethod,
    Value<int?> createdByAccountId = const Value.absent(),
    DateTime? createdAt,
  }) => WalletExpenseSplit(
    id: id ?? this.id,
    walletId: walletId ?? this.walletId,
    uuid: uuid ?? this.uuid,
    transactionId: transactionId ?? this.transactionId,
    paidByMemberId: paidByMemberId ?? this.paidByMemberId,
    splitMethod: splitMethod ?? this.splitMethod,
    createdByAccountId: createdByAccountId.present
        ? createdByAccountId.value
        : this.createdByAccountId,
    createdAt: createdAt ?? this.createdAt,
  );
  WalletExpenseSplit copyWithCompanion(WalletExpenseSplitsCompanion data) {
    return WalletExpenseSplit(
      id: data.id.present ? data.id.value : this.id,
      walletId: data.walletId.present ? data.walletId.value : this.walletId,
      uuid: data.uuid.present ? data.uuid.value : this.uuid,
      transactionId: data.transactionId.present
          ? data.transactionId.value
          : this.transactionId,
      paidByMemberId: data.paidByMemberId.present
          ? data.paidByMemberId.value
          : this.paidByMemberId,
      splitMethod: data.splitMethod.present
          ? data.splitMethod.value
          : this.splitMethod,
      createdByAccountId: data.createdByAccountId.present
          ? data.createdByAccountId.value
          : this.createdByAccountId,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('WalletExpenseSplit(')
          ..write('id: $id, ')
          ..write('walletId: $walletId, ')
          ..write('uuid: $uuid, ')
          ..write('transactionId: $transactionId, ')
          ..write('paidByMemberId: $paidByMemberId, ')
          ..write('splitMethod: $splitMethod, ')
          ..write('createdByAccountId: $createdByAccountId, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    walletId,
    uuid,
    transactionId,
    paidByMemberId,
    splitMethod,
    createdByAccountId,
    createdAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is WalletExpenseSplit &&
          other.id == this.id &&
          other.walletId == this.walletId &&
          other.uuid == this.uuid &&
          other.transactionId == this.transactionId &&
          other.paidByMemberId == this.paidByMemberId &&
          other.splitMethod == this.splitMethod &&
          other.createdByAccountId == this.createdByAccountId &&
          other.createdAt == this.createdAt);
}

class WalletExpenseSplitsCompanion extends UpdateCompanion<WalletExpenseSplit> {
  final Value<int> id;
  final Value<int> walletId;
  final Value<String> uuid;
  final Value<int> transactionId;
  final Value<int> paidByMemberId;
  final Value<WalletExpenseSplitMethod> splitMethod;
  final Value<int?> createdByAccountId;
  final Value<DateTime> createdAt;
  const WalletExpenseSplitsCompanion({
    this.id = const Value.absent(),
    this.walletId = const Value.absent(),
    this.uuid = const Value.absent(),
    this.transactionId = const Value.absent(),
    this.paidByMemberId = const Value.absent(),
    this.splitMethod = const Value.absent(),
    this.createdByAccountId = const Value.absent(),
    this.createdAt = const Value.absent(),
  });
  WalletExpenseSplitsCompanion.insert({
    this.id = const Value.absent(),
    required int walletId,
    this.uuid = const Value.absent(),
    required int transactionId,
    required int paidByMemberId,
    required WalletExpenseSplitMethod splitMethod,
    this.createdByAccountId = const Value.absent(),
    this.createdAt = const Value.absent(),
  }) : walletId = Value(walletId),
       transactionId = Value(transactionId),
       paidByMemberId = Value(paidByMemberId),
       splitMethod = Value(splitMethod);
  static Insertable<WalletExpenseSplit> custom({
    Expression<int>? id,
    Expression<int>? walletId,
    Expression<String>? uuid,
    Expression<int>? transactionId,
    Expression<int>? paidByMemberId,
    Expression<String>? splitMethod,
    Expression<int>? createdByAccountId,
    Expression<DateTime>? createdAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (walletId != null) 'wallet_id': walletId,
      if (uuid != null) 'uuid': uuid,
      if (transactionId != null) 'transaction_id': transactionId,
      if (paidByMemberId != null) 'paid_by_member_id': paidByMemberId,
      if (splitMethod != null) 'split_method': splitMethod,
      if (createdByAccountId != null)
        'created_by_account_id': createdByAccountId,
      if (createdAt != null) 'created_at': createdAt,
    });
  }

  WalletExpenseSplitsCompanion copyWith({
    Value<int>? id,
    Value<int>? walletId,
    Value<String>? uuid,
    Value<int>? transactionId,
    Value<int>? paidByMemberId,
    Value<WalletExpenseSplitMethod>? splitMethod,
    Value<int?>? createdByAccountId,
    Value<DateTime>? createdAt,
  }) {
    return WalletExpenseSplitsCompanion(
      id: id ?? this.id,
      walletId: walletId ?? this.walletId,
      uuid: uuid ?? this.uuid,
      transactionId: transactionId ?? this.transactionId,
      paidByMemberId: paidByMemberId ?? this.paidByMemberId,
      splitMethod: splitMethod ?? this.splitMethod,
      createdByAccountId: createdByAccountId ?? this.createdByAccountId,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (walletId.present) {
      map['wallet_id'] = Variable<int>(walletId.value);
    }
    if (uuid.present) {
      map['uuid'] = Variable<String>(uuid.value);
    }
    if (transactionId.present) {
      map['transaction_id'] = Variable<int>(transactionId.value);
    }
    if (paidByMemberId.present) {
      map['paid_by_member_id'] = Variable<int>(paidByMemberId.value);
    }
    if (splitMethod.present) {
      map['split_method'] = Variable<String>(
        $WalletExpenseSplitsTable.$convertersplitMethod.toSql(
          splitMethod.value,
        ),
      );
    }
    if (createdByAccountId.present) {
      map['created_by_account_id'] = Variable<int>(createdByAccountId.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('WalletExpenseSplitsCompanion(')
          ..write('id: $id, ')
          ..write('walletId: $walletId, ')
          ..write('uuid: $uuid, ')
          ..write('transactionId: $transactionId, ')
          ..write('paidByMemberId: $paidByMemberId, ')
          ..write('splitMethod: $splitMethod, ')
          ..write('createdByAccountId: $createdByAccountId, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }
}

class $WalletExpenseSplitMembersTable extends WalletExpenseSplitMembers
    with TableInfo<$WalletExpenseSplitMembersTable, WalletExpenseSplitMember> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $WalletExpenseSplitMembersTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _splitIdMeta = const VerificationMeta(
    'splitId',
  );
  @override
  late final GeneratedColumn<int> splitId = GeneratedColumn<int>(
    'split_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _memberIdMeta = const VerificationMeta(
    'memberId',
  );
  @override
  late final GeneratedColumn<int> memberId = GeneratedColumn<int>(
    'member_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  @override
  late final GeneratedColumnWithTypeConverter<double, int> amountOwed =
      GeneratedColumn<int>(
        'amount_owed',
        aliasedName,
        false,
        type: DriftSqlType.int,
        requiredDuringInsert: true,
      ).withConverter<double>(
        $WalletExpenseSplitMembersTable.$converteramountOwed,
      );
  static const VerificationMeta _percentageMeta = const VerificationMeta(
    'percentage',
  );
  @override
  late final GeneratedColumn<double> percentage = GeneratedColumn<double>(
    'percentage',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  @override
  late final GeneratedColumnWithTypeConverter<double, int> settledAmount =
      GeneratedColumn<int>(
        'settled_amount',
        aliasedName,
        false,
        type: DriftSqlType.int,
        requiredDuringInsert: false,
        defaultValue: const Constant(0),
      ).withConverter<double>(
        $WalletExpenseSplitMembersTable.$convertersettledAmount,
      );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    splitId,
    memberId,
    amountOwed,
    percentage,
    settledAmount,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'wallet_expense_split_members';
  @override
  VerificationContext validateIntegrity(
    Insertable<WalletExpenseSplitMember> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('split_id')) {
      context.handle(
        _splitIdMeta,
        splitId.isAcceptableOrUnknown(data['split_id']!, _splitIdMeta),
      );
    } else if (isInserting) {
      context.missing(_splitIdMeta);
    }
    if (data.containsKey('member_id')) {
      context.handle(
        _memberIdMeta,
        memberId.isAcceptableOrUnknown(data['member_id']!, _memberIdMeta),
      );
    } else if (isInserting) {
      context.missing(_memberIdMeta);
    }
    if (data.containsKey('percentage')) {
      context.handle(
        _percentageMeta,
        percentage.isAcceptableOrUnknown(data['percentage']!, _percentageMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  WalletExpenseSplitMember map(
    Map<String, dynamic> data, {
    String? tablePrefix,
  }) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return WalletExpenseSplitMember(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      splitId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}split_id'],
      )!,
      memberId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}member_id'],
      )!,
      amountOwed: $WalletExpenseSplitMembersTable.$converteramountOwed.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.int,
          data['${effectivePrefix}amount_owed'],
        )!,
      ),
      percentage: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}percentage'],
      )!,
      settledAmount: $WalletExpenseSplitMembersTable.$convertersettledAmount
          .fromSql(
            attachedDatabase.typeMapping.read(
              DriftSqlType.int,
              data['${effectivePrefix}settled_amount'],
            )!,
          ),
    );
  }

  @override
  $WalletExpenseSplitMembersTable createAlias(String alias) {
    return $WalletExpenseSplitMembersTable(attachedDatabase, alias);
  }

  static TypeConverter<double, int> $converteramountOwed =
      const MoneyConverter();
  static TypeConverter<double, int> $convertersettledAmount =
      const MoneyConverter();
}

class WalletExpenseSplitMember extends DataClass
    implements Insertable<WalletExpenseSplitMember> {
  final int id;
  final int splitId;
  final int memberId;
  final double amountOwed;
  final double percentage;
  final double settledAmount;
  const WalletExpenseSplitMember({
    required this.id,
    required this.splitId,
    required this.memberId,
    required this.amountOwed,
    required this.percentage,
    required this.settledAmount,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['split_id'] = Variable<int>(splitId);
    map['member_id'] = Variable<int>(memberId);
    {
      map['amount_owed'] = Variable<int>(
        $WalletExpenseSplitMembersTable.$converteramountOwed.toSql(amountOwed),
      );
    }
    map['percentage'] = Variable<double>(percentage);
    {
      map['settled_amount'] = Variable<int>(
        $WalletExpenseSplitMembersTable.$convertersettledAmount.toSql(
          settledAmount,
        ),
      );
    }
    return map;
  }

  WalletExpenseSplitMembersCompanion toCompanion(bool nullToAbsent) {
    return WalletExpenseSplitMembersCompanion(
      id: Value(id),
      splitId: Value(splitId),
      memberId: Value(memberId),
      amountOwed: Value(amountOwed),
      percentage: Value(percentage),
      settledAmount: Value(settledAmount),
    );
  }

  factory WalletExpenseSplitMember.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return WalletExpenseSplitMember(
      id: serializer.fromJson<int>(json['id']),
      splitId: serializer.fromJson<int>(json['splitId']),
      memberId: serializer.fromJson<int>(json['memberId']),
      amountOwed: serializer.fromJson<double>(json['amountOwed']),
      percentage: serializer.fromJson<double>(json['percentage']),
      settledAmount: serializer.fromJson<double>(json['settledAmount']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'splitId': serializer.toJson<int>(splitId),
      'memberId': serializer.toJson<int>(memberId),
      'amountOwed': serializer.toJson<double>(amountOwed),
      'percentage': serializer.toJson<double>(percentage),
      'settledAmount': serializer.toJson<double>(settledAmount),
    };
  }

  WalletExpenseSplitMember copyWith({
    int? id,
    int? splitId,
    int? memberId,
    double? amountOwed,
    double? percentage,
    double? settledAmount,
  }) => WalletExpenseSplitMember(
    id: id ?? this.id,
    splitId: splitId ?? this.splitId,
    memberId: memberId ?? this.memberId,
    amountOwed: amountOwed ?? this.amountOwed,
    percentage: percentage ?? this.percentage,
    settledAmount: settledAmount ?? this.settledAmount,
  );
  WalletExpenseSplitMember copyWithCompanion(
    WalletExpenseSplitMembersCompanion data,
  ) {
    return WalletExpenseSplitMember(
      id: data.id.present ? data.id.value : this.id,
      splitId: data.splitId.present ? data.splitId.value : this.splitId,
      memberId: data.memberId.present ? data.memberId.value : this.memberId,
      amountOwed: data.amountOwed.present
          ? data.amountOwed.value
          : this.amountOwed,
      percentage: data.percentage.present
          ? data.percentage.value
          : this.percentage,
      settledAmount: data.settledAmount.present
          ? data.settledAmount.value
          : this.settledAmount,
    );
  }

  @override
  String toString() {
    return (StringBuffer('WalletExpenseSplitMember(')
          ..write('id: $id, ')
          ..write('splitId: $splitId, ')
          ..write('memberId: $memberId, ')
          ..write('amountOwed: $amountOwed, ')
          ..write('percentage: $percentage, ')
          ..write('settledAmount: $settledAmount')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, splitId, memberId, amountOwed, percentage, settledAmount);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is WalletExpenseSplitMember &&
          other.id == this.id &&
          other.splitId == this.splitId &&
          other.memberId == this.memberId &&
          other.amountOwed == this.amountOwed &&
          other.percentage == this.percentage &&
          other.settledAmount == this.settledAmount);
}

class WalletExpenseSplitMembersCompanion
    extends UpdateCompanion<WalletExpenseSplitMember> {
  final Value<int> id;
  final Value<int> splitId;
  final Value<int> memberId;
  final Value<double> amountOwed;
  final Value<double> percentage;
  final Value<double> settledAmount;
  const WalletExpenseSplitMembersCompanion({
    this.id = const Value.absent(),
    this.splitId = const Value.absent(),
    this.memberId = const Value.absent(),
    this.amountOwed = const Value.absent(),
    this.percentage = const Value.absent(),
    this.settledAmount = const Value.absent(),
  });
  WalletExpenseSplitMembersCompanion.insert({
    this.id = const Value.absent(),
    required int splitId,
    required int memberId,
    required double amountOwed,
    this.percentage = const Value.absent(),
    this.settledAmount = const Value.absent(),
  }) : splitId = Value(splitId),
       memberId = Value(memberId),
       amountOwed = Value(amountOwed);
  static Insertable<WalletExpenseSplitMember> custom({
    Expression<int>? id,
    Expression<int>? splitId,
    Expression<int>? memberId,
    Expression<int>? amountOwed,
    Expression<double>? percentage,
    Expression<int>? settledAmount,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (splitId != null) 'split_id': splitId,
      if (memberId != null) 'member_id': memberId,
      if (amountOwed != null) 'amount_owed': amountOwed,
      if (percentage != null) 'percentage': percentage,
      if (settledAmount != null) 'settled_amount': settledAmount,
    });
  }

  WalletExpenseSplitMembersCompanion copyWith({
    Value<int>? id,
    Value<int>? splitId,
    Value<int>? memberId,
    Value<double>? amountOwed,
    Value<double>? percentage,
    Value<double>? settledAmount,
  }) {
    return WalletExpenseSplitMembersCompanion(
      id: id ?? this.id,
      splitId: splitId ?? this.splitId,
      memberId: memberId ?? this.memberId,
      amountOwed: amountOwed ?? this.amountOwed,
      percentage: percentage ?? this.percentage,
      settledAmount: settledAmount ?? this.settledAmount,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (splitId.present) {
      map['split_id'] = Variable<int>(splitId.value);
    }
    if (memberId.present) {
      map['member_id'] = Variable<int>(memberId.value);
    }
    if (amountOwed.present) {
      map['amount_owed'] = Variable<int>(
        $WalletExpenseSplitMembersTable.$converteramountOwed.toSql(
          amountOwed.value,
        ),
      );
    }
    if (percentage.present) {
      map['percentage'] = Variable<double>(percentage.value);
    }
    if (settledAmount.present) {
      map['settled_amount'] = Variable<int>(
        $WalletExpenseSplitMembersTable.$convertersettledAmount.toSql(
          settledAmount.value,
        ),
      );
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('WalletExpenseSplitMembersCompanion(')
          ..write('id: $id, ')
          ..write('splitId: $splitId, ')
          ..write('memberId: $memberId, ')
          ..write('amountOwed: $amountOwed, ')
          ..write('percentage: $percentage, ')
          ..write('settledAmount: $settledAmount')
          ..write(')'))
        .toString();
  }
}

class $MerchantMappingsTable extends MerchantMappings
    with TableInfo<$MerchantMappingsTable, MerchantMapping> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $MerchantMappingsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _walletIdMeta = const VerificationMeta(
    'walletId',
  );
  @override
  late final GeneratedColumn<int> walletId = GeneratedColumn<int>(
    'wallet_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _originalPatternMeta = const VerificationMeta(
    'originalPattern',
  );
  @override
  late final GeneratedColumn<String> originalPattern = GeneratedColumn<String>(
    'original_pattern',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _cleanNameMeta = const VerificationMeta(
    'cleanName',
  );
  @override
  late final GeneratedColumn<String> cleanName = GeneratedColumn<String>(
    'clean_name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _defaultCategoryIdMeta = const VerificationMeta(
    'defaultCategoryId',
  );
  @override
  late final GeneratedColumn<int> defaultCategoryId = GeneratedColumn<int>(
    'default_category_id',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    clientDefault: () => DateTime.now(),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    walletId,
    originalPattern,
    cleanName,
    defaultCategoryId,
    createdAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'merchant_mappings';
  @override
  VerificationContext validateIntegrity(
    Insertable<MerchantMapping> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('wallet_id')) {
      context.handle(
        _walletIdMeta,
        walletId.isAcceptableOrUnknown(data['wallet_id']!, _walletIdMeta),
      );
    } else if (isInserting) {
      context.missing(_walletIdMeta);
    }
    if (data.containsKey('original_pattern')) {
      context.handle(
        _originalPatternMeta,
        originalPattern.isAcceptableOrUnknown(
          data['original_pattern']!,
          _originalPatternMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_originalPatternMeta);
    }
    if (data.containsKey('clean_name')) {
      context.handle(
        _cleanNameMeta,
        cleanName.isAcceptableOrUnknown(data['clean_name']!, _cleanNameMeta),
      );
    } else if (isInserting) {
      context.missing(_cleanNameMeta);
    }
    if (data.containsKey('default_category_id')) {
      context.handle(
        _defaultCategoryIdMeta,
        defaultCategoryId.isAcceptableOrUnknown(
          data['default_category_id']!,
          _defaultCategoryIdMeta,
        ),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  MerchantMapping map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return MerchantMapping(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      walletId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}wallet_id'],
      )!,
      originalPattern: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}original_pattern'],
      )!,
      cleanName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}clean_name'],
      )!,
      defaultCategoryId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}default_category_id'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $MerchantMappingsTable createAlias(String alias) {
    return $MerchantMappingsTable(attachedDatabase, alias);
  }
}

class MerchantMapping extends DataClass implements Insertable<MerchantMapping> {
  final int id;
  final int walletId;
  final String originalPattern;
  final String cleanName;
  final int? defaultCategoryId;
  final DateTime createdAt;
  const MerchantMapping({
    required this.id,
    required this.walletId,
    required this.originalPattern,
    required this.cleanName,
    this.defaultCategoryId,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['wallet_id'] = Variable<int>(walletId);
    map['original_pattern'] = Variable<String>(originalPattern);
    map['clean_name'] = Variable<String>(cleanName);
    if (!nullToAbsent || defaultCategoryId != null) {
      map['default_category_id'] = Variable<int>(defaultCategoryId);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  MerchantMappingsCompanion toCompanion(bool nullToAbsent) {
    return MerchantMappingsCompanion(
      id: Value(id),
      walletId: Value(walletId),
      originalPattern: Value(originalPattern),
      cleanName: Value(cleanName),
      defaultCategoryId: defaultCategoryId == null && nullToAbsent
          ? const Value.absent()
          : Value(defaultCategoryId),
      createdAt: Value(createdAt),
    );
  }

  factory MerchantMapping.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return MerchantMapping(
      id: serializer.fromJson<int>(json['id']),
      walletId: serializer.fromJson<int>(json['walletId']),
      originalPattern: serializer.fromJson<String>(json['originalPattern']),
      cleanName: serializer.fromJson<String>(json['cleanName']),
      defaultCategoryId: serializer.fromJson<int?>(json['defaultCategoryId']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'walletId': serializer.toJson<int>(walletId),
      'originalPattern': serializer.toJson<String>(originalPattern),
      'cleanName': serializer.toJson<String>(cleanName),
      'defaultCategoryId': serializer.toJson<int?>(defaultCategoryId),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  MerchantMapping copyWith({
    int? id,
    int? walletId,
    String? originalPattern,
    String? cleanName,
    Value<int?> defaultCategoryId = const Value.absent(),
    DateTime? createdAt,
  }) => MerchantMapping(
    id: id ?? this.id,
    walletId: walletId ?? this.walletId,
    originalPattern: originalPattern ?? this.originalPattern,
    cleanName: cleanName ?? this.cleanName,
    defaultCategoryId: defaultCategoryId.present
        ? defaultCategoryId.value
        : this.defaultCategoryId,
    createdAt: createdAt ?? this.createdAt,
  );
  MerchantMapping copyWithCompanion(MerchantMappingsCompanion data) {
    return MerchantMapping(
      id: data.id.present ? data.id.value : this.id,
      walletId: data.walletId.present ? data.walletId.value : this.walletId,
      originalPattern: data.originalPattern.present
          ? data.originalPattern.value
          : this.originalPattern,
      cleanName: data.cleanName.present ? data.cleanName.value : this.cleanName,
      defaultCategoryId: data.defaultCategoryId.present
          ? data.defaultCategoryId.value
          : this.defaultCategoryId,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('MerchantMapping(')
          ..write('id: $id, ')
          ..write('walletId: $walletId, ')
          ..write('originalPattern: $originalPattern, ')
          ..write('cleanName: $cleanName, ')
          ..write('defaultCategoryId: $defaultCategoryId, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    walletId,
    originalPattern,
    cleanName,
    defaultCategoryId,
    createdAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is MerchantMapping &&
          other.id == this.id &&
          other.walletId == this.walletId &&
          other.originalPattern == this.originalPattern &&
          other.cleanName == this.cleanName &&
          other.defaultCategoryId == this.defaultCategoryId &&
          other.createdAt == this.createdAt);
}

class MerchantMappingsCompanion extends UpdateCompanion<MerchantMapping> {
  final Value<int> id;
  final Value<int> walletId;
  final Value<String> originalPattern;
  final Value<String> cleanName;
  final Value<int?> defaultCategoryId;
  final Value<DateTime> createdAt;
  const MerchantMappingsCompanion({
    this.id = const Value.absent(),
    this.walletId = const Value.absent(),
    this.originalPattern = const Value.absent(),
    this.cleanName = const Value.absent(),
    this.defaultCategoryId = const Value.absent(),
    this.createdAt = const Value.absent(),
  });
  MerchantMappingsCompanion.insert({
    this.id = const Value.absent(),
    required int walletId,
    required String originalPattern,
    required String cleanName,
    this.defaultCategoryId = const Value.absent(),
    this.createdAt = const Value.absent(),
  }) : walletId = Value(walletId),
       originalPattern = Value(originalPattern),
       cleanName = Value(cleanName);
  static Insertable<MerchantMapping> custom({
    Expression<int>? id,
    Expression<int>? walletId,
    Expression<String>? originalPattern,
    Expression<String>? cleanName,
    Expression<int>? defaultCategoryId,
    Expression<DateTime>? createdAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (walletId != null) 'wallet_id': walletId,
      if (originalPattern != null) 'original_pattern': originalPattern,
      if (cleanName != null) 'clean_name': cleanName,
      if (defaultCategoryId != null) 'default_category_id': defaultCategoryId,
      if (createdAt != null) 'created_at': createdAt,
    });
  }

  MerchantMappingsCompanion copyWith({
    Value<int>? id,
    Value<int>? walletId,
    Value<String>? originalPattern,
    Value<String>? cleanName,
    Value<int?>? defaultCategoryId,
    Value<DateTime>? createdAt,
  }) {
    return MerchantMappingsCompanion(
      id: id ?? this.id,
      walletId: walletId ?? this.walletId,
      originalPattern: originalPattern ?? this.originalPattern,
      cleanName: cleanName ?? this.cleanName,
      defaultCategoryId: defaultCategoryId ?? this.defaultCategoryId,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (walletId.present) {
      map['wallet_id'] = Variable<int>(walletId.value);
    }
    if (originalPattern.present) {
      map['original_pattern'] = Variable<String>(originalPattern.value);
    }
    if (cleanName.present) {
      map['clean_name'] = Variable<String>(cleanName.value);
    }
    if (defaultCategoryId.present) {
      map['default_category_id'] = Variable<int>(defaultCategoryId.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('MerchantMappingsCompanion(')
          ..write('id: $id, ')
          ..write('walletId: $walletId, ')
          ..write('originalPattern: $originalPattern, ')
          ..write('cleanName: $cleanName, ')
          ..write('defaultCategoryId: $defaultCategoryId, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }
}

class $PayeesTable extends Payees with TableInfo<$PayeesTable, Payee> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PayeesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _walletIdMeta = const VerificationMeta(
    'walletId',
  );
  @override
  late final GeneratedColumn<int> walletId = GeneratedColumn<int>(
    'wallet_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(1),
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 1,
      maxTextLength: 100,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [id, walletId, name];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'payees';
  @override
  VerificationContext validateIntegrity(
    Insertable<Payee> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('wallet_id')) {
      context.handle(
        _walletIdMeta,
        walletId.isAcceptableOrUnknown(data['wallet_id']!, _walletIdMeta),
      );
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Payee map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Payee(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      walletId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}wallet_id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
    );
  }

  @override
  $PayeesTable createAlias(String alias) {
    return $PayeesTable(attachedDatabase, alias);
  }
}

class Payee extends DataClass implements Insertable<Payee> {
  final int id;
  final int walletId;
  final String name;
  const Payee({required this.id, required this.walletId, required this.name});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['wallet_id'] = Variable<int>(walletId);
    map['name'] = Variable<String>(name);
    return map;
  }

  PayeesCompanion toCompanion(bool nullToAbsent) {
    return PayeesCompanion(
      id: Value(id),
      walletId: Value(walletId),
      name: Value(name),
    );
  }

  factory Payee.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Payee(
      id: serializer.fromJson<int>(json['id']),
      walletId: serializer.fromJson<int>(json['walletId']),
      name: serializer.fromJson<String>(json['name']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'walletId': serializer.toJson<int>(walletId),
      'name': serializer.toJson<String>(name),
    };
  }

  Payee copyWith({int? id, int? walletId, String? name}) => Payee(
    id: id ?? this.id,
    walletId: walletId ?? this.walletId,
    name: name ?? this.name,
  );
  Payee copyWithCompanion(PayeesCompanion data) {
    return Payee(
      id: data.id.present ? data.id.value : this.id,
      walletId: data.walletId.present ? data.walletId.value : this.walletId,
      name: data.name.present ? data.name.value : this.name,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Payee(')
          ..write('id: $id, ')
          ..write('walletId: $walletId, ')
          ..write('name: $name')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, walletId, name);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Payee &&
          other.id == this.id &&
          other.walletId == this.walletId &&
          other.name == this.name);
}

class PayeesCompanion extends UpdateCompanion<Payee> {
  final Value<int> id;
  final Value<int> walletId;
  final Value<String> name;
  const PayeesCompanion({
    this.id = const Value.absent(),
    this.walletId = const Value.absent(),
    this.name = const Value.absent(),
  });
  PayeesCompanion.insert({
    this.id = const Value.absent(),
    this.walletId = const Value.absent(),
    required String name,
  }) : name = Value(name);
  static Insertable<Payee> custom({
    Expression<int>? id,
    Expression<int>? walletId,
    Expression<String>? name,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (walletId != null) 'wallet_id': walletId,
      if (name != null) 'name': name,
    });
  }

  PayeesCompanion copyWith({
    Value<int>? id,
    Value<int>? walletId,
    Value<String>? name,
  }) {
    return PayeesCompanion(
      id: id ?? this.id,
      walletId: walletId ?? this.walletId,
      name: name ?? this.name,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (walletId.present) {
      map['wallet_id'] = Variable<int>(walletId.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PayeesCompanion(')
          ..write('id: $id, ')
          ..write('walletId: $walletId, ')
          ..write('name: $name')
          ..write(')'))
        .toString();
  }
}

class $RecurringTransactionsTable extends RecurringTransactions
    with TableInfo<$RecurringTransactionsTable, RecurringTransactionDb> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $RecurringTransactionsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _walletIdMeta = const VerificationMeta(
    'walletId',
  );
  @override
  late final GeneratedColumn<int> walletId = GeneratedColumn<int>(
    'wallet_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(1),
  );
  static const VerificationMeta _uuidMeta = const VerificationMeta('uuid');
  @override
  late final GeneratedColumn<String> uuid = GeneratedColumn<String>(
    'uuid',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    clientDefault: () => const Uuid().v4(),
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 1,
      maxTextLength: 100,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  late final GeneratedColumnWithTypeConverter<double, int> amount =
      GeneratedColumn<int>(
        'amount',
        aliasedName,
        false,
        type: DriftSqlType.int,
        requiredDuringInsert: true,
      ).withConverter<double>($RecurringTransactionsTable.$converteramount);
  @override
  late final GeneratedColumnWithTypeConverter<TransactionType, String> type =
      GeneratedColumn<String>(
        'type',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      ).withConverter<TransactionType>(
        $RecurringTransactionsTable.$convertertype,
      );
  static const VerificationMeta _categoryIdMeta = const VerificationMeta(
    'categoryId',
  );
  @override
  late final GeneratedColumn<int> categoryId = GeneratedColumn<int>(
    'category_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _accountIdMeta = const VerificationMeta(
    'accountId',
  );
  @override
  late final GeneratedColumn<int> accountId = GeneratedColumn<int>(
    'account_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _intervalMeta = const VerificationMeta(
    'interval',
  );
  @override
  late final GeneratedColumn<String> interval = GeneratedColumn<String>(
    'interval',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _startDateMeta = const VerificationMeta(
    'startDate',
  );
  @override
  late final GeneratedColumn<DateTime> startDate = GeneratedColumn<DateTime>(
    'start_date',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _nextDueDateMeta = const VerificationMeta(
    'nextDueDate',
  );
  @override
  late final GeneratedColumn<DateTime> nextDueDate = GeneratedColumn<DateTime>(
    'next_due_date',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _lastGeneratedDateMeta = const VerificationMeta(
    'lastGeneratedDate',
  );
  @override
  late final GeneratedColumn<DateTime> lastGeneratedDate =
      GeneratedColumn<DateTime>(
        'last_generated_date',
        aliasedName,
        true,
        type: DriftSqlType.dateTime,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _isActiveMeta = const VerificationMeta(
    'isActive',
  );
  @override
  late final GeneratedColumn<bool> isActive = GeneratedColumn<bool>(
    'is_active',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_active" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    clientDefault: () => DateTime.now(),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    walletId,
    uuid,
    name,
    amount,
    type,
    categoryId,
    accountId,
    interval,
    startDate,
    nextDueDate,
    lastGeneratedDate,
    isActive,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'recurring_transactions';
  @override
  VerificationContext validateIntegrity(
    Insertable<RecurringTransactionDb> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('wallet_id')) {
      context.handle(
        _walletIdMeta,
        walletId.isAcceptableOrUnknown(data['wallet_id']!, _walletIdMeta),
      );
    }
    if (data.containsKey('uuid')) {
      context.handle(
        _uuidMeta,
        uuid.isAcceptableOrUnknown(data['uuid']!, _uuidMeta),
      );
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('category_id')) {
      context.handle(
        _categoryIdMeta,
        categoryId.isAcceptableOrUnknown(data['category_id']!, _categoryIdMeta),
      );
    } else if (isInserting) {
      context.missing(_categoryIdMeta);
    }
    if (data.containsKey('account_id')) {
      context.handle(
        _accountIdMeta,
        accountId.isAcceptableOrUnknown(data['account_id']!, _accountIdMeta),
      );
    } else if (isInserting) {
      context.missing(_accountIdMeta);
    }
    if (data.containsKey('interval')) {
      context.handle(
        _intervalMeta,
        interval.isAcceptableOrUnknown(data['interval']!, _intervalMeta),
      );
    } else if (isInserting) {
      context.missing(_intervalMeta);
    }
    if (data.containsKey('start_date')) {
      context.handle(
        _startDateMeta,
        startDate.isAcceptableOrUnknown(data['start_date']!, _startDateMeta),
      );
    } else if (isInserting) {
      context.missing(_startDateMeta);
    }
    if (data.containsKey('next_due_date')) {
      context.handle(
        _nextDueDateMeta,
        nextDueDate.isAcceptableOrUnknown(
          data['next_due_date']!,
          _nextDueDateMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_nextDueDateMeta);
    }
    if (data.containsKey('last_generated_date')) {
      context.handle(
        _lastGeneratedDateMeta,
        lastGeneratedDate.isAcceptableOrUnknown(
          data['last_generated_date']!,
          _lastGeneratedDateMeta,
        ),
      );
    }
    if (data.containsKey('is_active')) {
      context.handle(
        _isActiveMeta,
        isActive.isAcceptableOrUnknown(data['is_active']!, _isActiveMeta),
      );
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  RecurringTransactionDb map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return RecurringTransactionDb(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      walletId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}wallet_id'],
      )!,
      uuid: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}uuid'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      amount: $RecurringTransactionsTable.$converteramount.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.int,
          data['${effectivePrefix}amount'],
        )!,
      ),
      type: $RecurringTransactionsTable.$convertertype.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}type'],
        )!,
      ),
      categoryId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}category_id'],
      )!,
      accountId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}account_id'],
      )!,
      interval: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}interval'],
      )!,
      startDate: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}start_date'],
      )!,
      nextDueDate: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}next_due_date'],
      )!,
      lastGeneratedDate: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}last_generated_date'],
      ),
      isActive: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_active'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $RecurringTransactionsTable createAlias(String alias) {
    return $RecurringTransactionsTable(attachedDatabase, alias);
  }

  static TypeConverter<double, int> $converteramount = const MoneyConverter();
  static JsonTypeConverter2<TransactionType, String, String> $convertertype =
      const EnumNameConverter(TransactionType.values);
}

class RecurringTransactionDb extends DataClass
    implements Insertable<RecurringTransactionDb> {
  final int id;
  final int walletId;
  final String uuid;
  final String name;
  final double amount;
  final TransactionType type;
  final int categoryId;
  final int accountId;
  final String interval;
  final DateTime startDate;
  final DateTime nextDueDate;
  final DateTime? lastGeneratedDate;
  final bool isActive;
  final DateTime updatedAt;
  const RecurringTransactionDb({
    required this.id,
    required this.walletId,
    required this.uuid,
    required this.name,
    required this.amount,
    required this.type,
    required this.categoryId,
    required this.accountId,
    required this.interval,
    required this.startDate,
    required this.nextDueDate,
    this.lastGeneratedDate,
    required this.isActive,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['wallet_id'] = Variable<int>(walletId);
    map['uuid'] = Variable<String>(uuid);
    map['name'] = Variable<String>(name);
    {
      map['amount'] = Variable<int>(
        $RecurringTransactionsTable.$converteramount.toSql(amount),
      );
    }
    {
      map['type'] = Variable<String>(
        $RecurringTransactionsTable.$convertertype.toSql(type),
      );
    }
    map['category_id'] = Variable<int>(categoryId);
    map['account_id'] = Variable<int>(accountId);
    map['interval'] = Variable<String>(interval);
    map['start_date'] = Variable<DateTime>(startDate);
    map['next_due_date'] = Variable<DateTime>(nextDueDate);
    if (!nullToAbsent || lastGeneratedDate != null) {
      map['last_generated_date'] = Variable<DateTime>(lastGeneratedDate);
    }
    map['is_active'] = Variable<bool>(isActive);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  RecurringTransactionsCompanion toCompanion(bool nullToAbsent) {
    return RecurringTransactionsCompanion(
      id: Value(id),
      walletId: Value(walletId),
      uuid: Value(uuid),
      name: Value(name),
      amount: Value(amount),
      type: Value(type),
      categoryId: Value(categoryId),
      accountId: Value(accountId),
      interval: Value(interval),
      startDate: Value(startDate),
      nextDueDate: Value(nextDueDate),
      lastGeneratedDate: lastGeneratedDate == null && nullToAbsent
          ? const Value.absent()
          : Value(lastGeneratedDate),
      isActive: Value(isActive),
      updatedAt: Value(updatedAt),
    );
  }

  factory RecurringTransactionDb.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return RecurringTransactionDb(
      id: serializer.fromJson<int>(json['id']),
      walletId: serializer.fromJson<int>(json['walletId']),
      uuid: serializer.fromJson<String>(json['uuid']),
      name: serializer.fromJson<String>(json['name']),
      amount: serializer.fromJson<double>(json['amount']),
      type: $RecurringTransactionsTable.$convertertype.fromJson(
        serializer.fromJson<String>(json['type']),
      ),
      categoryId: serializer.fromJson<int>(json['categoryId']),
      accountId: serializer.fromJson<int>(json['accountId']),
      interval: serializer.fromJson<String>(json['interval']),
      startDate: serializer.fromJson<DateTime>(json['startDate']),
      nextDueDate: serializer.fromJson<DateTime>(json['nextDueDate']),
      lastGeneratedDate: serializer.fromJson<DateTime?>(
        json['lastGeneratedDate'],
      ),
      isActive: serializer.fromJson<bool>(json['isActive']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'walletId': serializer.toJson<int>(walletId),
      'uuid': serializer.toJson<String>(uuid),
      'name': serializer.toJson<String>(name),
      'amount': serializer.toJson<double>(amount),
      'type': serializer.toJson<String>(
        $RecurringTransactionsTable.$convertertype.toJson(type),
      ),
      'categoryId': serializer.toJson<int>(categoryId),
      'accountId': serializer.toJson<int>(accountId),
      'interval': serializer.toJson<String>(interval),
      'startDate': serializer.toJson<DateTime>(startDate),
      'nextDueDate': serializer.toJson<DateTime>(nextDueDate),
      'lastGeneratedDate': serializer.toJson<DateTime?>(lastGeneratedDate),
      'isActive': serializer.toJson<bool>(isActive),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  RecurringTransactionDb copyWith({
    int? id,
    int? walletId,
    String? uuid,
    String? name,
    double? amount,
    TransactionType? type,
    int? categoryId,
    int? accountId,
    String? interval,
    DateTime? startDate,
    DateTime? nextDueDate,
    Value<DateTime?> lastGeneratedDate = const Value.absent(),
    bool? isActive,
    DateTime? updatedAt,
  }) => RecurringTransactionDb(
    id: id ?? this.id,
    walletId: walletId ?? this.walletId,
    uuid: uuid ?? this.uuid,
    name: name ?? this.name,
    amount: amount ?? this.amount,
    type: type ?? this.type,
    categoryId: categoryId ?? this.categoryId,
    accountId: accountId ?? this.accountId,
    interval: interval ?? this.interval,
    startDate: startDate ?? this.startDate,
    nextDueDate: nextDueDate ?? this.nextDueDate,
    lastGeneratedDate: lastGeneratedDate.present
        ? lastGeneratedDate.value
        : this.lastGeneratedDate,
    isActive: isActive ?? this.isActive,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  RecurringTransactionDb copyWithCompanion(
    RecurringTransactionsCompanion data,
  ) {
    return RecurringTransactionDb(
      id: data.id.present ? data.id.value : this.id,
      walletId: data.walletId.present ? data.walletId.value : this.walletId,
      uuid: data.uuid.present ? data.uuid.value : this.uuid,
      name: data.name.present ? data.name.value : this.name,
      amount: data.amount.present ? data.amount.value : this.amount,
      type: data.type.present ? data.type.value : this.type,
      categoryId: data.categoryId.present
          ? data.categoryId.value
          : this.categoryId,
      accountId: data.accountId.present ? data.accountId.value : this.accountId,
      interval: data.interval.present ? data.interval.value : this.interval,
      startDate: data.startDate.present ? data.startDate.value : this.startDate,
      nextDueDate: data.nextDueDate.present
          ? data.nextDueDate.value
          : this.nextDueDate,
      lastGeneratedDate: data.lastGeneratedDate.present
          ? data.lastGeneratedDate.value
          : this.lastGeneratedDate,
      isActive: data.isActive.present ? data.isActive.value : this.isActive,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('RecurringTransactionDb(')
          ..write('id: $id, ')
          ..write('walletId: $walletId, ')
          ..write('uuid: $uuid, ')
          ..write('name: $name, ')
          ..write('amount: $amount, ')
          ..write('type: $type, ')
          ..write('categoryId: $categoryId, ')
          ..write('accountId: $accountId, ')
          ..write('interval: $interval, ')
          ..write('startDate: $startDate, ')
          ..write('nextDueDate: $nextDueDate, ')
          ..write('lastGeneratedDate: $lastGeneratedDate, ')
          ..write('isActive: $isActive, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    walletId,
    uuid,
    name,
    amount,
    type,
    categoryId,
    accountId,
    interval,
    startDate,
    nextDueDate,
    lastGeneratedDate,
    isActive,
    updatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is RecurringTransactionDb &&
          other.id == this.id &&
          other.walletId == this.walletId &&
          other.uuid == this.uuid &&
          other.name == this.name &&
          other.amount == this.amount &&
          other.type == this.type &&
          other.categoryId == this.categoryId &&
          other.accountId == this.accountId &&
          other.interval == this.interval &&
          other.startDate == this.startDate &&
          other.nextDueDate == this.nextDueDate &&
          other.lastGeneratedDate == this.lastGeneratedDate &&
          other.isActive == this.isActive &&
          other.updatedAt == this.updatedAt);
}

class RecurringTransactionsCompanion
    extends UpdateCompanion<RecurringTransactionDb> {
  final Value<int> id;
  final Value<int> walletId;
  final Value<String> uuid;
  final Value<String> name;
  final Value<double> amount;
  final Value<TransactionType> type;
  final Value<int> categoryId;
  final Value<int> accountId;
  final Value<String> interval;
  final Value<DateTime> startDate;
  final Value<DateTime> nextDueDate;
  final Value<DateTime?> lastGeneratedDate;
  final Value<bool> isActive;
  final Value<DateTime> updatedAt;
  const RecurringTransactionsCompanion({
    this.id = const Value.absent(),
    this.walletId = const Value.absent(),
    this.uuid = const Value.absent(),
    this.name = const Value.absent(),
    this.amount = const Value.absent(),
    this.type = const Value.absent(),
    this.categoryId = const Value.absent(),
    this.accountId = const Value.absent(),
    this.interval = const Value.absent(),
    this.startDate = const Value.absent(),
    this.nextDueDate = const Value.absent(),
    this.lastGeneratedDate = const Value.absent(),
    this.isActive = const Value.absent(),
    this.updatedAt = const Value.absent(),
  });
  RecurringTransactionsCompanion.insert({
    this.id = const Value.absent(),
    this.walletId = const Value.absent(),
    this.uuid = const Value.absent(),
    required String name,
    required double amount,
    required TransactionType type,
    required int categoryId,
    required int accountId,
    required String interval,
    required DateTime startDate,
    required DateTime nextDueDate,
    this.lastGeneratedDate = const Value.absent(),
    this.isActive = const Value.absent(),
    this.updatedAt = const Value.absent(),
  }) : name = Value(name),
       amount = Value(amount),
       type = Value(type),
       categoryId = Value(categoryId),
       accountId = Value(accountId),
       interval = Value(interval),
       startDate = Value(startDate),
       nextDueDate = Value(nextDueDate);
  static Insertable<RecurringTransactionDb> custom({
    Expression<int>? id,
    Expression<int>? walletId,
    Expression<String>? uuid,
    Expression<String>? name,
    Expression<int>? amount,
    Expression<String>? type,
    Expression<int>? categoryId,
    Expression<int>? accountId,
    Expression<String>? interval,
    Expression<DateTime>? startDate,
    Expression<DateTime>? nextDueDate,
    Expression<DateTime>? lastGeneratedDate,
    Expression<bool>? isActive,
    Expression<DateTime>? updatedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (walletId != null) 'wallet_id': walletId,
      if (uuid != null) 'uuid': uuid,
      if (name != null) 'name': name,
      if (amount != null) 'amount': amount,
      if (type != null) 'type': type,
      if (categoryId != null) 'category_id': categoryId,
      if (accountId != null) 'account_id': accountId,
      if (interval != null) 'interval': interval,
      if (startDate != null) 'start_date': startDate,
      if (nextDueDate != null) 'next_due_date': nextDueDate,
      if (lastGeneratedDate != null) 'last_generated_date': lastGeneratedDate,
      if (isActive != null) 'is_active': isActive,
      if (updatedAt != null) 'updated_at': updatedAt,
    });
  }

  RecurringTransactionsCompanion copyWith({
    Value<int>? id,
    Value<int>? walletId,
    Value<String>? uuid,
    Value<String>? name,
    Value<double>? amount,
    Value<TransactionType>? type,
    Value<int>? categoryId,
    Value<int>? accountId,
    Value<String>? interval,
    Value<DateTime>? startDate,
    Value<DateTime>? nextDueDate,
    Value<DateTime?>? lastGeneratedDate,
    Value<bool>? isActive,
    Value<DateTime>? updatedAt,
  }) {
    return RecurringTransactionsCompanion(
      id: id ?? this.id,
      walletId: walletId ?? this.walletId,
      uuid: uuid ?? this.uuid,
      name: name ?? this.name,
      amount: amount ?? this.amount,
      type: type ?? this.type,
      categoryId: categoryId ?? this.categoryId,
      accountId: accountId ?? this.accountId,
      interval: interval ?? this.interval,
      startDate: startDate ?? this.startDate,
      nextDueDate: nextDueDate ?? this.nextDueDate,
      lastGeneratedDate: lastGeneratedDate ?? this.lastGeneratedDate,
      isActive: isActive ?? this.isActive,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (walletId.present) {
      map['wallet_id'] = Variable<int>(walletId.value);
    }
    if (uuid.present) {
      map['uuid'] = Variable<String>(uuid.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (amount.present) {
      map['amount'] = Variable<int>(
        $RecurringTransactionsTable.$converteramount.toSql(amount.value),
      );
    }
    if (type.present) {
      map['type'] = Variable<String>(
        $RecurringTransactionsTable.$convertertype.toSql(type.value),
      );
    }
    if (categoryId.present) {
      map['category_id'] = Variable<int>(categoryId.value);
    }
    if (accountId.present) {
      map['account_id'] = Variable<int>(accountId.value);
    }
    if (interval.present) {
      map['interval'] = Variable<String>(interval.value);
    }
    if (startDate.present) {
      map['start_date'] = Variable<DateTime>(startDate.value);
    }
    if (nextDueDate.present) {
      map['next_due_date'] = Variable<DateTime>(nextDueDate.value);
    }
    if (lastGeneratedDate.present) {
      map['last_generated_date'] = Variable<DateTime>(lastGeneratedDate.value);
    }
    if (isActive.present) {
      map['is_active'] = Variable<bool>(isActive.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('RecurringTransactionsCompanion(')
          ..write('id: $id, ')
          ..write('walletId: $walletId, ')
          ..write('uuid: $uuid, ')
          ..write('name: $name, ')
          ..write('amount: $amount, ')
          ..write('type: $type, ')
          ..write('categoryId: $categoryId, ')
          ..write('accountId: $accountId, ')
          ..write('interval: $interval, ')
          ..write('startDate: $startDate, ')
          ..write('nextDueDate: $nextDueDate, ')
          ..write('lastGeneratedDate: $lastGeneratedDate, ')
          ..write('isActive: $isActive, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }
}

class $SmsImportMetricsTable extends SmsImportMetrics
    with TableInfo<$SmsImportMetricsTable, SmsImportMetric> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SmsImportMetricsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _walletIdMeta = const VerificationMeta(
    'walletId',
  );
  @override
  late final GeneratedColumn<int> walletId = GeneratedColumn<int>(
    'wallet_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _acceptedImportsMeta = const VerificationMeta(
    'acceptedImports',
  );
  @override
  late final GeneratedColumn<int> acceptedImports = GeneratedColumn<int>(
    'accepted_imports',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _rejectedImportsMeta = const VerificationMeta(
    'rejectedImports',
  );
  @override
  late final GeneratedColumn<int> rejectedImports = GeneratedColumn<int>(
    'rejected_imports',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _duplicateDetectionsMeta =
      const VerificationMeta('duplicateDetections');
  @override
  late final GeneratedColumn<int> duplicateDetections = GeneratedColumn<int>(
    'duplicate_detections',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    clientDefault: () => DateTime.now(),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    walletId,
    acceptedImports,
    rejectedImports,
    duplicateDetections,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'sms_import_metrics';
  @override
  VerificationContext validateIntegrity(
    Insertable<SmsImportMetric> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('wallet_id')) {
      context.handle(
        _walletIdMeta,
        walletId.isAcceptableOrUnknown(data['wallet_id']!, _walletIdMeta),
      );
    } else if (isInserting) {
      context.missing(_walletIdMeta);
    }
    if (data.containsKey('accepted_imports')) {
      context.handle(
        _acceptedImportsMeta,
        acceptedImports.isAcceptableOrUnknown(
          data['accepted_imports']!,
          _acceptedImportsMeta,
        ),
      );
    }
    if (data.containsKey('rejected_imports')) {
      context.handle(
        _rejectedImportsMeta,
        rejectedImports.isAcceptableOrUnknown(
          data['rejected_imports']!,
          _rejectedImportsMeta,
        ),
      );
    }
    if (data.containsKey('duplicate_detections')) {
      context.handle(
        _duplicateDetectionsMeta,
        duplicateDetections.isAcceptableOrUnknown(
          data['duplicate_detections']!,
          _duplicateDetectionsMeta,
        ),
      );
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  SmsImportMetric map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SmsImportMetric(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      walletId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}wallet_id'],
      )!,
      acceptedImports: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}accepted_imports'],
      )!,
      rejectedImports: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}rejected_imports'],
      )!,
      duplicateDetections: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}duplicate_detections'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $SmsImportMetricsTable createAlias(String alias) {
    return $SmsImportMetricsTable(attachedDatabase, alias);
  }
}

class SmsImportMetric extends DataClass implements Insertable<SmsImportMetric> {
  final int id;
  final int walletId;
  final int acceptedImports;
  final int rejectedImports;
  final int duplicateDetections;
  final DateTime updatedAt;
  const SmsImportMetric({
    required this.id,
    required this.walletId,
    required this.acceptedImports,
    required this.rejectedImports,
    required this.duplicateDetections,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['wallet_id'] = Variable<int>(walletId);
    map['accepted_imports'] = Variable<int>(acceptedImports);
    map['rejected_imports'] = Variable<int>(rejectedImports);
    map['duplicate_detections'] = Variable<int>(duplicateDetections);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  SmsImportMetricsCompanion toCompanion(bool nullToAbsent) {
    return SmsImportMetricsCompanion(
      id: Value(id),
      walletId: Value(walletId),
      acceptedImports: Value(acceptedImports),
      rejectedImports: Value(rejectedImports),
      duplicateDetections: Value(duplicateDetections),
      updatedAt: Value(updatedAt),
    );
  }

  factory SmsImportMetric.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SmsImportMetric(
      id: serializer.fromJson<int>(json['id']),
      walletId: serializer.fromJson<int>(json['walletId']),
      acceptedImports: serializer.fromJson<int>(json['acceptedImports']),
      rejectedImports: serializer.fromJson<int>(json['rejectedImports']),
      duplicateDetections: serializer.fromJson<int>(
        json['duplicateDetections'],
      ),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'walletId': serializer.toJson<int>(walletId),
      'acceptedImports': serializer.toJson<int>(acceptedImports),
      'rejectedImports': serializer.toJson<int>(rejectedImports),
      'duplicateDetections': serializer.toJson<int>(duplicateDetections),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  SmsImportMetric copyWith({
    int? id,
    int? walletId,
    int? acceptedImports,
    int? rejectedImports,
    int? duplicateDetections,
    DateTime? updatedAt,
  }) => SmsImportMetric(
    id: id ?? this.id,
    walletId: walletId ?? this.walletId,
    acceptedImports: acceptedImports ?? this.acceptedImports,
    rejectedImports: rejectedImports ?? this.rejectedImports,
    duplicateDetections: duplicateDetections ?? this.duplicateDetections,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  SmsImportMetric copyWithCompanion(SmsImportMetricsCompanion data) {
    return SmsImportMetric(
      id: data.id.present ? data.id.value : this.id,
      walletId: data.walletId.present ? data.walletId.value : this.walletId,
      acceptedImports: data.acceptedImports.present
          ? data.acceptedImports.value
          : this.acceptedImports,
      rejectedImports: data.rejectedImports.present
          ? data.rejectedImports.value
          : this.rejectedImports,
      duplicateDetections: data.duplicateDetections.present
          ? data.duplicateDetections.value
          : this.duplicateDetections,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('SmsImportMetric(')
          ..write('id: $id, ')
          ..write('walletId: $walletId, ')
          ..write('acceptedImports: $acceptedImports, ')
          ..write('rejectedImports: $rejectedImports, ')
          ..write('duplicateDetections: $duplicateDetections, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    walletId,
    acceptedImports,
    rejectedImports,
    duplicateDetections,
    updatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SmsImportMetric &&
          other.id == this.id &&
          other.walletId == this.walletId &&
          other.acceptedImports == this.acceptedImports &&
          other.rejectedImports == this.rejectedImports &&
          other.duplicateDetections == this.duplicateDetections &&
          other.updatedAt == this.updatedAt);
}

class SmsImportMetricsCompanion extends UpdateCompanion<SmsImportMetric> {
  final Value<int> id;
  final Value<int> walletId;
  final Value<int> acceptedImports;
  final Value<int> rejectedImports;
  final Value<int> duplicateDetections;
  final Value<DateTime> updatedAt;
  const SmsImportMetricsCompanion({
    this.id = const Value.absent(),
    this.walletId = const Value.absent(),
    this.acceptedImports = const Value.absent(),
    this.rejectedImports = const Value.absent(),
    this.duplicateDetections = const Value.absent(),
    this.updatedAt = const Value.absent(),
  });
  SmsImportMetricsCompanion.insert({
    this.id = const Value.absent(),
    required int walletId,
    this.acceptedImports = const Value.absent(),
    this.rejectedImports = const Value.absent(),
    this.duplicateDetections = const Value.absent(),
    this.updatedAt = const Value.absent(),
  }) : walletId = Value(walletId);
  static Insertable<SmsImportMetric> custom({
    Expression<int>? id,
    Expression<int>? walletId,
    Expression<int>? acceptedImports,
    Expression<int>? rejectedImports,
    Expression<int>? duplicateDetections,
    Expression<DateTime>? updatedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (walletId != null) 'wallet_id': walletId,
      if (acceptedImports != null) 'accepted_imports': acceptedImports,
      if (rejectedImports != null) 'rejected_imports': rejectedImports,
      if (duplicateDetections != null)
        'duplicate_detections': duplicateDetections,
      if (updatedAt != null) 'updated_at': updatedAt,
    });
  }

  SmsImportMetricsCompanion copyWith({
    Value<int>? id,
    Value<int>? walletId,
    Value<int>? acceptedImports,
    Value<int>? rejectedImports,
    Value<int>? duplicateDetections,
    Value<DateTime>? updatedAt,
  }) {
    return SmsImportMetricsCompanion(
      id: id ?? this.id,
      walletId: walletId ?? this.walletId,
      acceptedImports: acceptedImports ?? this.acceptedImports,
      rejectedImports: rejectedImports ?? this.rejectedImports,
      duplicateDetections: duplicateDetections ?? this.duplicateDetections,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (walletId.present) {
      map['wallet_id'] = Variable<int>(walletId.value);
    }
    if (acceptedImports.present) {
      map['accepted_imports'] = Variable<int>(acceptedImports.value);
    }
    if (rejectedImports.present) {
      map['rejected_imports'] = Variable<int>(rejectedImports.value);
    }
    if (duplicateDetections.present) {
      map['duplicate_detections'] = Variable<int>(duplicateDetections.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SmsImportMetricsCompanion(')
          ..write('id: $id, ')
          ..write('walletId: $walletId, ')
          ..write('acceptedImports: $acceptedImports, ')
          ..write('rejectedImports: $rejectedImports, ')
          ..write('duplicateDetections: $duplicateDetections, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }
}

class $TagsTable extends Tags with TableInfo<$TagsTable, Tag> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $TagsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _walletIdMeta = const VerificationMeta(
    'walletId',
  );
  @override
  late final GeneratedColumn<int> walletId = GeneratedColumn<int>(
    'wallet_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(1),
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 1,
      maxTextLength: 50,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _colorMeta = const VerificationMeta('color');
  @override
  late final GeneratedColumn<String> color = GeneratedColumn<String>(
    'color',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [id, walletId, name, color];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'tags';
  @override
  VerificationContext validateIntegrity(
    Insertable<Tag> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('wallet_id')) {
      context.handle(
        _walletIdMeta,
        walletId.isAcceptableOrUnknown(data['wallet_id']!, _walletIdMeta),
      );
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('color')) {
      context.handle(
        _colorMeta,
        color.isAcceptableOrUnknown(data['color']!, _colorMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Tag map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Tag(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      walletId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}wallet_id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      color: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}color'],
      ),
    );
  }

  @override
  $TagsTable createAlias(String alias) {
    return $TagsTable(attachedDatabase, alias);
  }
}

class Tag extends DataClass implements Insertable<Tag> {
  final int id;
  final int walletId;
  final String name;
  final String? color;
  const Tag({
    required this.id,
    required this.walletId,
    required this.name,
    this.color,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['wallet_id'] = Variable<int>(walletId);
    map['name'] = Variable<String>(name);
    if (!nullToAbsent || color != null) {
      map['color'] = Variable<String>(color);
    }
    return map;
  }

  TagsCompanion toCompanion(bool nullToAbsent) {
    return TagsCompanion(
      id: Value(id),
      walletId: Value(walletId),
      name: Value(name),
      color: color == null && nullToAbsent
          ? const Value.absent()
          : Value(color),
    );
  }

  factory Tag.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Tag(
      id: serializer.fromJson<int>(json['id']),
      walletId: serializer.fromJson<int>(json['walletId']),
      name: serializer.fromJson<String>(json['name']),
      color: serializer.fromJson<String?>(json['color']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'walletId': serializer.toJson<int>(walletId),
      'name': serializer.toJson<String>(name),
      'color': serializer.toJson<String?>(color),
    };
  }

  Tag copyWith({
    int? id,
    int? walletId,
    String? name,
    Value<String?> color = const Value.absent(),
  }) => Tag(
    id: id ?? this.id,
    walletId: walletId ?? this.walletId,
    name: name ?? this.name,
    color: color.present ? color.value : this.color,
  );
  Tag copyWithCompanion(TagsCompanion data) {
    return Tag(
      id: data.id.present ? data.id.value : this.id,
      walletId: data.walletId.present ? data.walletId.value : this.walletId,
      name: data.name.present ? data.name.value : this.name,
      color: data.color.present ? data.color.value : this.color,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Tag(')
          ..write('id: $id, ')
          ..write('walletId: $walletId, ')
          ..write('name: $name, ')
          ..write('color: $color')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, walletId, name, color);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Tag &&
          other.id == this.id &&
          other.walletId == this.walletId &&
          other.name == this.name &&
          other.color == this.color);
}

class TagsCompanion extends UpdateCompanion<Tag> {
  final Value<int> id;
  final Value<int> walletId;
  final Value<String> name;
  final Value<String?> color;
  const TagsCompanion({
    this.id = const Value.absent(),
    this.walletId = const Value.absent(),
    this.name = const Value.absent(),
    this.color = const Value.absent(),
  });
  TagsCompanion.insert({
    this.id = const Value.absent(),
    this.walletId = const Value.absent(),
    required String name,
    this.color = const Value.absent(),
  }) : name = Value(name);
  static Insertable<Tag> custom({
    Expression<int>? id,
    Expression<int>? walletId,
    Expression<String>? name,
    Expression<String>? color,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (walletId != null) 'wallet_id': walletId,
      if (name != null) 'name': name,
      if (color != null) 'color': color,
    });
  }

  TagsCompanion copyWith({
    Value<int>? id,
    Value<int>? walletId,
    Value<String>? name,
    Value<String?>? color,
  }) {
    return TagsCompanion(
      id: id ?? this.id,
      walletId: walletId ?? this.walletId,
      name: name ?? this.name,
      color: color ?? this.color,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (walletId.present) {
      map['wallet_id'] = Variable<int>(walletId.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (color.present) {
      map['color'] = Variable<String>(color.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('TagsCompanion(')
          ..write('id: $id, ')
          ..write('walletId: $walletId, ')
          ..write('name: $name, ')
          ..write('color: $color')
          ..write(')'))
        .toString();
  }
}

class $TransactionsTable extends Transactions
    with TableInfo<$TransactionsTable, Transaction> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $TransactionsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _walletIdMeta = const VerificationMeta(
    'walletId',
  );
  @override
  late final GeneratedColumn<int> walletId = GeneratedColumn<int>(
    'wallet_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(1),
  );
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _uuidMeta = const VerificationMeta('uuid');
  @override
  late final GeneratedColumn<String> uuid = GeneratedColumn<String>(
    'uuid',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    clientDefault: () => const Uuid().v4(),
  );
  @override
  late final GeneratedColumnWithTypeConverter<double, int> amount =
      GeneratedColumn<int>(
        'amount',
        aliasedName,
        false,
        type: DriftSqlType.int,
        requiredDuringInsert: true,
      ).withConverter<double>($TransactionsTable.$converteramount);
  static const VerificationMeta _dateMeta = const VerificationMeta('date');
  @override
  late final GeneratedColumn<DateTime> date = GeneratedColumn<DateTime>(
    'date',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _noteMeta = const VerificationMeta('note');
  @override
  late final GeneratedColumn<String> note = GeneratedColumn<String>(
    'note',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  late final GeneratedColumnWithTypeConverter<TransactionType, String> type =
      GeneratedColumn<String>(
        'type',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      ).withConverter<TransactionType>($TransactionsTable.$convertertype);
  static const VerificationMeta _categoryIdMeta = const VerificationMeta(
    'categoryId',
  );
  @override
  late final GeneratedColumn<int> categoryId = GeneratedColumn<int>(
    'category_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _accountIdMeta = const VerificationMeta(
    'accountId',
  );
  @override
  late final GeneratedColumn<int> accountId = GeneratedColumn<int>(
    'account_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _transferGroupIdMeta = const VerificationMeta(
    'transferGroupId',
  );
  @override
  late final GeneratedColumn<String> transferGroupId = GeneratedColumn<String>(
    'transfer_group_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [
    walletId,
    id,
    uuid,
    amount,
    date,
    note,
    type,
    categoryId,
    accountId,
    transferGroupId,
    createdAt,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'transactions';
  @override
  VerificationContext validateIntegrity(
    Insertable<Transaction> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('wallet_id')) {
      context.handle(
        _walletIdMeta,
        walletId.isAcceptableOrUnknown(data['wallet_id']!, _walletIdMeta),
      );
    }
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('uuid')) {
      context.handle(
        _uuidMeta,
        uuid.isAcceptableOrUnknown(data['uuid']!, _uuidMeta),
      );
    }
    if (data.containsKey('date')) {
      context.handle(
        _dateMeta,
        date.isAcceptableOrUnknown(data['date']!, _dateMeta),
      );
    } else if (isInserting) {
      context.missing(_dateMeta);
    }
    if (data.containsKey('note')) {
      context.handle(
        _noteMeta,
        note.isAcceptableOrUnknown(data['note']!, _noteMeta),
      );
    }
    if (data.containsKey('category_id')) {
      context.handle(
        _categoryIdMeta,
        categoryId.isAcceptableOrUnknown(data['category_id']!, _categoryIdMeta),
      );
    } else if (isInserting) {
      context.missing(_categoryIdMeta);
    }
    if (data.containsKey('account_id')) {
      context.handle(
        _accountIdMeta,
        accountId.isAcceptableOrUnknown(data['account_id']!, _accountIdMeta),
      );
    } else if (isInserting) {
      context.missing(_accountIdMeta);
    }
    if (data.containsKey('transfer_group_id')) {
      context.handle(
        _transferGroupIdMeta,
        transferGroupId.isAcceptableOrUnknown(
          data['transfer_group_id']!,
          _transferGroupIdMeta,
        ),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Transaction map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Transaction(
      walletId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}wallet_id'],
      )!,
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      uuid: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}uuid'],
      )!,
      amount: $TransactionsTable.$converteramount.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.int,
          data['${effectivePrefix}amount'],
        )!,
      ),
      date: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}date'],
      )!,
      note: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}note'],
      ),
      type: $TransactionsTable.$convertertype.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}type'],
        )!,
      ),
      categoryId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}category_id'],
      )!,
      accountId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}account_id'],
      )!,
      transferGroupId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}transfer_group_id'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $TransactionsTable createAlias(String alias) {
    return $TransactionsTable(attachedDatabase, alias);
  }

  static TypeConverter<double, int> $converteramount = const MoneyConverter();
  static JsonTypeConverter2<TransactionType, String, String> $convertertype =
      const EnumNameConverter(TransactionType.values);
}

class Transaction extends DataClass implements Insertable<Transaction> {
  final int walletId;
  final int id;
  final String uuid;
  final double amount;
  final DateTime date;
  final String? note;
  final TransactionType type;
  final int categoryId;
  final int accountId;

  /// Groups the two legs of a transfer. Both rows share one value, which is
  /// what makes a transfer first-class: it can be excluded from income/expense
  /// reporting and edited or deleted as a unit. Null for ordinary entries.
  final String? transferGroupId;
  final DateTime createdAt;
  final DateTime updatedAt;
  const Transaction({
    required this.walletId,
    required this.id,
    required this.uuid,
    required this.amount,
    required this.date,
    this.note,
    required this.type,
    required this.categoryId,
    required this.accountId,
    this.transferGroupId,
    required this.createdAt,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['wallet_id'] = Variable<int>(walletId);
    map['id'] = Variable<int>(id);
    map['uuid'] = Variable<String>(uuid);
    {
      map['amount'] = Variable<int>(
        $TransactionsTable.$converteramount.toSql(amount),
      );
    }
    map['date'] = Variable<DateTime>(date);
    if (!nullToAbsent || note != null) {
      map['note'] = Variable<String>(note);
    }
    {
      map['type'] = Variable<String>(
        $TransactionsTable.$convertertype.toSql(type),
      );
    }
    map['category_id'] = Variable<int>(categoryId);
    map['account_id'] = Variable<int>(accountId);
    if (!nullToAbsent || transferGroupId != null) {
      map['transfer_group_id'] = Variable<String>(transferGroupId);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  TransactionsCompanion toCompanion(bool nullToAbsent) {
    return TransactionsCompanion(
      walletId: Value(walletId),
      id: Value(id),
      uuid: Value(uuid),
      amount: Value(amount),
      date: Value(date),
      note: note == null && nullToAbsent ? const Value.absent() : Value(note),
      type: Value(type),
      categoryId: Value(categoryId),
      accountId: Value(accountId),
      transferGroupId: transferGroupId == null && nullToAbsent
          ? const Value.absent()
          : Value(transferGroupId),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory Transaction.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Transaction(
      walletId: serializer.fromJson<int>(json['walletId']),
      id: serializer.fromJson<int>(json['id']),
      uuid: serializer.fromJson<String>(json['uuid']),
      amount: serializer.fromJson<double>(json['amount']),
      date: serializer.fromJson<DateTime>(json['date']),
      note: serializer.fromJson<String?>(json['note']),
      type: $TransactionsTable.$convertertype.fromJson(
        serializer.fromJson<String>(json['type']),
      ),
      categoryId: serializer.fromJson<int>(json['categoryId']),
      accountId: serializer.fromJson<int>(json['accountId']),
      transferGroupId: serializer.fromJson<String?>(json['transferGroupId']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'walletId': serializer.toJson<int>(walletId),
      'id': serializer.toJson<int>(id),
      'uuid': serializer.toJson<String>(uuid),
      'amount': serializer.toJson<double>(amount),
      'date': serializer.toJson<DateTime>(date),
      'note': serializer.toJson<String?>(note),
      'type': serializer.toJson<String>(
        $TransactionsTable.$convertertype.toJson(type),
      ),
      'categoryId': serializer.toJson<int>(categoryId),
      'accountId': serializer.toJson<int>(accountId),
      'transferGroupId': serializer.toJson<String?>(transferGroupId),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  Transaction copyWith({
    int? walletId,
    int? id,
    String? uuid,
    double? amount,
    DateTime? date,
    Value<String?> note = const Value.absent(),
    TransactionType? type,
    int? categoryId,
    int? accountId,
    Value<String?> transferGroupId = const Value.absent(),
    DateTime? createdAt,
    DateTime? updatedAt,
  }) => Transaction(
    walletId: walletId ?? this.walletId,
    id: id ?? this.id,
    uuid: uuid ?? this.uuid,
    amount: amount ?? this.amount,
    date: date ?? this.date,
    note: note.present ? note.value : this.note,
    type: type ?? this.type,
    categoryId: categoryId ?? this.categoryId,
    accountId: accountId ?? this.accountId,
    transferGroupId: transferGroupId.present
        ? transferGroupId.value
        : this.transferGroupId,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  Transaction copyWithCompanion(TransactionsCompanion data) {
    return Transaction(
      walletId: data.walletId.present ? data.walletId.value : this.walletId,
      id: data.id.present ? data.id.value : this.id,
      uuid: data.uuid.present ? data.uuid.value : this.uuid,
      amount: data.amount.present ? data.amount.value : this.amount,
      date: data.date.present ? data.date.value : this.date,
      note: data.note.present ? data.note.value : this.note,
      type: data.type.present ? data.type.value : this.type,
      categoryId: data.categoryId.present
          ? data.categoryId.value
          : this.categoryId,
      accountId: data.accountId.present ? data.accountId.value : this.accountId,
      transferGroupId: data.transferGroupId.present
          ? data.transferGroupId.value
          : this.transferGroupId,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Transaction(')
          ..write('walletId: $walletId, ')
          ..write('id: $id, ')
          ..write('uuid: $uuid, ')
          ..write('amount: $amount, ')
          ..write('date: $date, ')
          ..write('note: $note, ')
          ..write('type: $type, ')
          ..write('categoryId: $categoryId, ')
          ..write('accountId: $accountId, ')
          ..write('transferGroupId: $transferGroupId, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    walletId,
    id,
    uuid,
    amount,
    date,
    note,
    type,
    categoryId,
    accountId,
    transferGroupId,
    createdAt,
    updatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Transaction &&
          other.walletId == this.walletId &&
          other.id == this.id &&
          other.uuid == this.uuid &&
          other.amount == this.amount &&
          other.date == this.date &&
          other.note == this.note &&
          other.type == this.type &&
          other.categoryId == this.categoryId &&
          other.accountId == this.accountId &&
          other.transferGroupId == this.transferGroupId &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class TransactionsCompanion extends UpdateCompanion<Transaction> {
  final Value<int> walletId;
  final Value<int> id;
  final Value<String> uuid;
  final Value<double> amount;
  final Value<DateTime> date;
  final Value<String?> note;
  final Value<TransactionType> type;
  final Value<int> categoryId;
  final Value<int> accountId;
  final Value<String?> transferGroupId;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  const TransactionsCompanion({
    this.walletId = const Value.absent(),
    this.id = const Value.absent(),
    this.uuid = const Value.absent(),
    this.amount = const Value.absent(),
    this.date = const Value.absent(),
    this.note = const Value.absent(),
    this.type = const Value.absent(),
    this.categoryId = const Value.absent(),
    this.accountId = const Value.absent(),
    this.transferGroupId = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  });
  TransactionsCompanion.insert({
    this.walletId = const Value.absent(),
    this.id = const Value.absent(),
    this.uuid = const Value.absent(),
    required double amount,
    required DateTime date,
    this.note = const Value.absent(),
    required TransactionType type,
    required int categoryId,
    required int accountId,
    this.transferGroupId = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  }) : amount = Value(amount),
       date = Value(date),
       type = Value(type),
       categoryId = Value(categoryId),
       accountId = Value(accountId);
  static Insertable<Transaction> custom({
    Expression<int>? walletId,
    Expression<int>? id,
    Expression<String>? uuid,
    Expression<int>? amount,
    Expression<DateTime>? date,
    Expression<String>? note,
    Expression<String>? type,
    Expression<int>? categoryId,
    Expression<int>? accountId,
    Expression<String>? transferGroupId,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
  }) {
    return RawValuesInsertable({
      if (walletId != null) 'wallet_id': walletId,
      if (id != null) 'id': id,
      if (uuid != null) 'uuid': uuid,
      if (amount != null) 'amount': amount,
      if (date != null) 'date': date,
      if (note != null) 'note': note,
      if (type != null) 'type': type,
      if (categoryId != null) 'category_id': categoryId,
      if (accountId != null) 'account_id': accountId,
      if (transferGroupId != null) 'transfer_group_id': transferGroupId,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
    });
  }

  TransactionsCompanion copyWith({
    Value<int>? walletId,
    Value<int>? id,
    Value<String>? uuid,
    Value<double>? amount,
    Value<DateTime>? date,
    Value<String?>? note,
    Value<TransactionType>? type,
    Value<int>? categoryId,
    Value<int>? accountId,
    Value<String?>? transferGroupId,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
  }) {
    return TransactionsCompanion(
      walletId: walletId ?? this.walletId,
      id: id ?? this.id,
      uuid: uuid ?? this.uuid,
      amount: amount ?? this.amount,
      date: date ?? this.date,
      note: note ?? this.note,
      type: type ?? this.type,
      categoryId: categoryId ?? this.categoryId,
      accountId: accountId ?? this.accountId,
      transferGroupId: transferGroupId ?? this.transferGroupId,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (walletId.present) {
      map['wallet_id'] = Variable<int>(walletId.value);
    }
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (uuid.present) {
      map['uuid'] = Variable<String>(uuid.value);
    }
    if (amount.present) {
      map['amount'] = Variable<int>(
        $TransactionsTable.$converteramount.toSql(amount.value),
      );
    }
    if (date.present) {
      map['date'] = Variable<DateTime>(date.value);
    }
    if (note.present) {
      map['note'] = Variable<String>(note.value);
    }
    if (type.present) {
      map['type'] = Variable<String>(
        $TransactionsTable.$convertertype.toSql(type.value),
      );
    }
    if (categoryId.present) {
      map['category_id'] = Variable<int>(categoryId.value);
    }
    if (accountId.present) {
      map['account_id'] = Variable<int>(accountId.value);
    }
    if (transferGroupId.present) {
      map['transfer_group_id'] = Variable<String>(transferGroupId.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('TransactionsCompanion(')
          ..write('walletId: $walletId, ')
          ..write('id: $id, ')
          ..write('uuid: $uuid, ')
          ..write('amount: $amount, ')
          ..write('date: $date, ')
          ..write('note: $note, ')
          ..write('type: $type, ')
          ..write('categoryId: $categoryId, ')
          ..write('accountId: $accountId, ')
          ..write('transferGroupId: $transferGroupId, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }
}

class $UnrecognizedSmsEntriesTable extends UnrecognizedSmsEntries
    with TableInfo<$UnrecognizedSmsEntriesTable, UnrecognizedSms> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $UnrecognizedSmsEntriesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _walletIdMeta = const VerificationMeta(
    'walletId',
  );
  @override
  late final GeneratedColumn<int> walletId = GeneratedColumn<int>(
    'wallet_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _smsBodyMeta = const VerificationMeta(
    'smsBody',
  );
  @override
  late final GeneratedColumn<String> smsBody = GeneratedColumn<String>(
    'sms_body',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _senderMeta = const VerificationMeta('sender');
  @override
  late final GeneratedColumn<String> sender = GeneratedColumn<String>(
    'sender',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _receivedAtMeta = const VerificationMeta(
    'receivedAt',
  );
  @override
  late final GeneratedColumn<DateTime> receivedAt = GeneratedColumn<DateTime>(
    'received_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _isResolvedMeta = const VerificationMeta(
    'isResolved',
  );
  @override
  late final GeneratedColumn<bool> isResolved = GeneratedColumn<bool>(
    'is_resolved',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_resolved" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    clientDefault: () => DateTime.now(),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    walletId,
    smsBody,
    sender,
    receivedAt,
    isResolved,
    createdAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'unrecognized_sms_entries';
  @override
  VerificationContext validateIntegrity(
    Insertable<UnrecognizedSms> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('wallet_id')) {
      context.handle(
        _walletIdMeta,
        walletId.isAcceptableOrUnknown(data['wallet_id']!, _walletIdMeta),
      );
    } else if (isInserting) {
      context.missing(_walletIdMeta);
    }
    if (data.containsKey('sms_body')) {
      context.handle(
        _smsBodyMeta,
        smsBody.isAcceptableOrUnknown(data['sms_body']!, _smsBodyMeta),
      );
    } else if (isInserting) {
      context.missing(_smsBodyMeta);
    }
    if (data.containsKey('sender')) {
      context.handle(
        _senderMeta,
        sender.isAcceptableOrUnknown(data['sender']!, _senderMeta),
      );
    } else if (isInserting) {
      context.missing(_senderMeta);
    }
    if (data.containsKey('received_at')) {
      context.handle(
        _receivedAtMeta,
        receivedAt.isAcceptableOrUnknown(data['received_at']!, _receivedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_receivedAtMeta);
    }
    if (data.containsKey('is_resolved')) {
      context.handle(
        _isResolvedMeta,
        isResolved.isAcceptableOrUnknown(data['is_resolved']!, _isResolvedMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  UnrecognizedSms map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return UnrecognizedSms(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      walletId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}wallet_id'],
      )!,
      smsBody: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}sms_body'],
      )!,
      sender: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}sender'],
      )!,
      receivedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}received_at'],
      )!,
      isResolved: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_resolved'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $UnrecognizedSmsEntriesTable createAlias(String alias) {
    return $UnrecognizedSmsEntriesTable(attachedDatabase, alias);
  }
}

class UnrecognizedSms extends DataClass implements Insertable<UnrecognizedSms> {
  final int id;
  final int walletId;
  final String smsBody;
  final String sender;
  final DateTime receivedAt;
  final bool isResolved;
  final DateTime createdAt;
  const UnrecognizedSms({
    required this.id,
    required this.walletId,
    required this.smsBody,
    required this.sender,
    required this.receivedAt,
    required this.isResolved,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['wallet_id'] = Variable<int>(walletId);
    map['sms_body'] = Variable<String>(smsBody);
    map['sender'] = Variable<String>(sender);
    map['received_at'] = Variable<DateTime>(receivedAt);
    map['is_resolved'] = Variable<bool>(isResolved);
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  UnrecognizedSmsEntriesCompanion toCompanion(bool nullToAbsent) {
    return UnrecognizedSmsEntriesCompanion(
      id: Value(id),
      walletId: Value(walletId),
      smsBody: Value(smsBody),
      sender: Value(sender),
      receivedAt: Value(receivedAt),
      isResolved: Value(isResolved),
      createdAt: Value(createdAt),
    );
  }

  factory UnrecognizedSms.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return UnrecognizedSms(
      id: serializer.fromJson<int>(json['id']),
      walletId: serializer.fromJson<int>(json['walletId']),
      smsBody: serializer.fromJson<String>(json['smsBody']),
      sender: serializer.fromJson<String>(json['sender']),
      receivedAt: serializer.fromJson<DateTime>(json['receivedAt']),
      isResolved: serializer.fromJson<bool>(json['isResolved']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'walletId': serializer.toJson<int>(walletId),
      'smsBody': serializer.toJson<String>(smsBody),
      'sender': serializer.toJson<String>(sender),
      'receivedAt': serializer.toJson<DateTime>(receivedAt),
      'isResolved': serializer.toJson<bool>(isResolved),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  UnrecognizedSms copyWith({
    int? id,
    int? walletId,
    String? smsBody,
    String? sender,
    DateTime? receivedAt,
    bool? isResolved,
    DateTime? createdAt,
  }) => UnrecognizedSms(
    id: id ?? this.id,
    walletId: walletId ?? this.walletId,
    smsBody: smsBody ?? this.smsBody,
    sender: sender ?? this.sender,
    receivedAt: receivedAt ?? this.receivedAt,
    isResolved: isResolved ?? this.isResolved,
    createdAt: createdAt ?? this.createdAt,
  );
  UnrecognizedSms copyWithCompanion(UnrecognizedSmsEntriesCompanion data) {
    return UnrecognizedSms(
      id: data.id.present ? data.id.value : this.id,
      walletId: data.walletId.present ? data.walletId.value : this.walletId,
      smsBody: data.smsBody.present ? data.smsBody.value : this.smsBody,
      sender: data.sender.present ? data.sender.value : this.sender,
      receivedAt: data.receivedAt.present
          ? data.receivedAt.value
          : this.receivedAt,
      isResolved: data.isResolved.present
          ? data.isResolved.value
          : this.isResolved,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('UnrecognizedSms(')
          ..write('id: $id, ')
          ..write('walletId: $walletId, ')
          ..write('smsBody: $smsBody, ')
          ..write('sender: $sender, ')
          ..write('receivedAt: $receivedAt, ')
          ..write('isResolved: $isResolved, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    walletId,
    smsBody,
    sender,
    receivedAt,
    isResolved,
    createdAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is UnrecognizedSms &&
          other.id == this.id &&
          other.walletId == this.walletId &&
          other.smsBody == this.smsBody &&
          other.sender == this.sender &&
          other.receivedAt == this.receivedAt &&
          other.isResolved == this.isResolved &&
          other.createdAt == this.createdAt);
}

class UnrecognizedSmsEntriesCompanion extends UpdateCompanion<UnrecognizedSms> {
  final Value<int> id;
  final Value<int> walletId;
  final Value<String> smsBody;
  final Value<String> sender;
  final Value<DateTime> receivedAt;
  final Value<bool> isResolved;
  final Value<DateTime> createdAt;
  const UnrecognizedSmsEntriesCompanion({
    this.id = const Value.absent(),
    this.walletId = const Value.absent(),
    this.smsBody = const Value.absent(),
    this.sender = const Value.absent(),
    this.receivedAt = const Value.absent(),
    this.isResolved = const Value.absent(),
    this.createdAt = const Value.absent(),
  });
  UnrecognizedSmsEntriesCompanion.insert({
    this.id = const Value.absent(),
    required int walletId,
    required String smsBody,
    required String sender,
    required DateTime receivedAt,
    this.isResolved = const Value.absent(),
    this.createdAt = const Value.absent(),
  }) : walletId = Value(walletId),
       smsBody = Value(smsBody),
       sender = Value(sender),
       receivedAt = Value(receivedAt);
  static Insertable<UnrecognizedSms> custom({
    Expression<int>? id,
    Expression<int>? walletId,
    Expression<String>? smsBody,
    Expression<String>? sender,
    Expression<DateTime>? receivedAt,
    Expression<bool>? isResolved,
    Expression<DateTime>? createdAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (walletId != null) 'wallet_id': walletId,
      if (smsBody != null) 'sms_body': smsBody,
      if (sender != null) 'sender': sender,
      if (receivedAt != null) 'received_at': receivedAt,
      if (isResolved != null) 'is_resolved': isResolved,
      if (createdAt != null) 'created_at': createdAt,
    });
  }

  UnrecognizedSmsEntriesCompanion copyWith({
    Value<int>? id,
    Value<int>? walletId,
    Value<String>? smsBody,
    Value<String>? sender,
    Value<DateTime>? receivedAt,
    Value<bool>? isResolved,
    Value<DateTime>? createdAt,
  }) {
    return UnrecognizedSmsEntriesCompanion(
      id: id ?? this.id,
      walletId: walletId ?? this.walletId,
      smsBody: smsBody ?? this.smsBody,
      sender: sender ?? this.sender,
      receivedAt: receivedAt ?? this.receivedAt,
      isResolved: isResolved ?? this.isResolved,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (walletId.present) {
      map['wallet_id'] = Variable<int>(walletId.value);
    }
    if (smsBody.present) {
      map['sms_body'] = Variable<String>(smsBody.value);
    }
    if (sender.present) {
      map['sender'] = Variable<String>(sender.value);
    }
    if (receivedAt.present) {
      map['received_at'] = Variable<DateTime>(receivedAt.value);
    }
    if (isResolved.present) {
      map['is_resolved'] = Variable<bool>(isResolved.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('UnrecognizedSmsEntriesCompanion(')
          ..write('id: $id, ')
          ..write('walletId: $walletId, ')
          ..write('smsBody: $smsBody, ')
          ..write('sender: $sender, ')
          ..write('receivedAt: $receivedAt, ')
          ..write('isResolved: $isResolved, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }
}

class $WalletActivitiesTable extends WalletActivities
    with TableInfo<$WalletActivitiesTable, WalletActivity> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $WalletActivitiesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _walletIdMeta = const VerificationMeta(
    'walletId',
  );
  @override
  late final GeneratedColumn<int> walletId = GeneratedColumn<int>(
    'wallet_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _uuidMeta = const VerificationMeta('uuid');
  @override
  late final GeneratedColumn<String> uuid = GeneratedColumn<String>(
    'uuid',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    clientDefault: () => const Uuid().v4(),
  );
  static const VerificationMeta _actorAccountIdMeta = const VerificationMeta(
    'actorAccountId',
  );
  @override
  late final GeneratedColumn<int> actorAccountId = GeneratedColumn<int>(
    'actor_account_id',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _actorMemberIdMeta = const VerificationMeta(
    'actorMemberId',
  );
  @override
  late final GeneratedColumn<int> actorMemberId = GeneratedColumn<int>(
    'actor_member_id',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _actionMeta = const VerificationMeta('action');
  @override
  late final GeneratedColumn<String> action = GeneratedColumn<String>(
    'action',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 1,
      maxTextLength: 100,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _entityTypeMeta = const VerificationMeta(
    'entityType',
  );
  @override
  late final GeneratedColumn<String> entityType = GeneratedColumn<String>(
    'entity_type',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 1,
      maxTextLength: 100,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _entityIdMeta = const VerificationMeta(
    'entityId',
  );
  @override
  late final GeneratedColumn<int> entityId = GeneratedColumn<int>(
    'entity_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _entityUuidMeta = const VerificationMeta(
    'entityUuid',
  );
  @override
  late final GeneratedColumn<String> entityUuid = GeneratedColumn<String>(
    'entity_uuid',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _detailsMeta = const VerificationMeta(
    'details',
  );
  @override
  late final GeneratedColumn<String> details = GeneratedColumn<String>(
    'details',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _metadataMeta = const VerificationMeta(
    'metadata',
  );
  @override
  late final GeneratedColumn<String> metadata = GeneratedColumn<String>(
    'metadata',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _sourceMeta = const VerificationMeta('source');
  @override
  late final GeneratedColumn<String> source = GeneratedColumn<String>(
    'source',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 1,
      maxTextLength: 50,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    clientDefault: () => DateTime.now(),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    walletId,
    uuid,
    actorAccountId,
    actorMemberId,
    action,
    entityType,
    entityId,
    entityUuid,
    details,
    metadata,
    source,
    createdAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'wallet_activities';
  @override
  VerificationContext validateIntegrity(
    Insertable<WalletActivity> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('wallet_id')) {
      context.handle(
        _walletIdMeta,
        walletId.isAcceptableOrUnknown(data['wallet_id']!, _walletIdMeta),
      );
    } else if (isInserting) {
      context.missing(_walletIdMeta);
    }
    if (data.containsKey('uuid')) {
      context.handle(
        _uuidMeta,
        uuid.isAcceptableOrUnknown(data['uuid']!, _uuidMeta),
      );
    }
    if (data.containsKey('actor_account_id')) {
      context.handle(
        _actorAccountIdMeta,
        actorAccountId.isAcceptableOrUnknown(
          data['actor_account_id']!,
          _actorAccountIdMeta,
        ),
      );
    }
    if (data.containsKey('actor_member_id')) {
      context.handle(
        _actorMemberIdMeta,
        actorMemberId.isAcceptableOrUnknown(
          data['actor_member_id']!,
          _actorMemberIdMeta,
        ),
      );
    }
    if (data.containsKey('action')) {
      context.handle(
        _actionMeta,
        action.isAcceptableOrUnknown(data['action']!, _actionMeta),
      );
    } else if (isInserting) {
      context.missing(_actionMeta);
    }
    if (data.containsKey('entity_type')) {
      context.handle(
        _entityTypeMeta,
        entityType.isAcceptableOrUnknown(data['entity_type']!, _entityTypeMeta),
      );
    } else if (isInserting) {
      context.missing(_entityTypeMeta);
    }
    if (data.containsKey('entity_id')) {
      context.handle(
        _entityIdMeta,
        entityId.isAcceptableOrUnknown(data['entity_id']!, _entityIdMeta),
      );
    } else if (isInserting) {
      context.missing(_entityIdMeta);
    }
    if (data.containsKey('entity_uuid')) {
      context.handle(
        _entityUuidMeta,
        entityUuid.isAcceptableOrUnknown(data['entity_uuid']!, _entityUuidMeta),
      );
    }
    if (data.containsKey('details')) {
      context.handle(
        _detailsMeta,
        details.isAcceptableOrUnknown(data['details']!, _detailsMeta),
      );
    }
    if (data.containsKey('metadata')) {
      context.handle(
        _metadataMeta,
        metadata.isAcceptableOrUnknown(data['metadata']!, _metadataMeta),
      );
    }
    if (data.containsKey('source')) {
      context.handle(
        _sourceMeta,
        source.isAcceptableOrUnknown(data['source']!, _sourceMeta),
      );
    } else if (isInserting) {
      context.missing(_sourceMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  WalletActivity map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return WalletActivity(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      walletId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}wallet_id'],
      )!,
      uuid: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}uuid'],
      )!,
      actorAccountId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}actor_account_id'],
      ),
      actorMemberId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}actor_member_id'],
      ),
      action: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}action'],
      )!,
      entityType: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}entity_type'],
      )!,
      entityId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}entity_id'],
      )!,
      entityUuid: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}entity_uuid'],
      ),
      details: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}details'],
      ),
      metadata: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}metadata'],
      ),
      source: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}source'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $WalletActivitiesTable createAlias(String alias) {
    return $WalletActivitiesTable(attachedDatabase, alias);
  }
}

class WalletActivity extends DataClass implements Insertable<WalletActivity> {
  final int id;
  final int walletId;
  final String uuid;
  final int? actorAccountId;
  final int? actorMemberId;
  final String action;
  final String entityType;
  final int entityId;
  final String? entityUuid;
  final String? details;
  final String? metadata;
  final String source;
  final DateTime createdAt;
  const WalletActivity({
    required this.id,
    required this.walletId,
    required this.uuid,
    this.actorAccountId,
    this.actorMemberId,
    required this.action,
    required this.entityType,
    required this.entityId,
    this.entityUuid,
    this.details,
    this.metadata,
    required this.source,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['wallet_id'] = Variable<int>(walletId);
    map['uuid'] = Variable<String>(uuid);
    if (!nullToAbsent || actorAccountId != null) {
      map['actor_account_id'] = Variable<int>(actorAccountId);
    }
    if (!nullToAbsent || actorMemberId != null) {
      map['actor_member_id'] = Variable<int>(actorMemberId);
    }
    map['action'] = Variable<String>(action);
    map['entity_type'] = Variable<String>(entityType);
    map['entity_id'] = Variable<int>(entityId);
    if (!nullToAbsent || entityUuid != null) {
      map['entity_uuid'] = Variable<String>(entityUuid);
    }
    if (!nullToAbsent || details != null) {
      map['details'] = Variable<String>(details);
    }
    if (!nullToAbsent || metadata != null) {
      map['metadata'] = Variable<String>(metadata);
    }
    map['source'] = Variable<String>(source);
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  WalletActivitiesCompanion toCompanion(bool nullToAbsent) {
    return WalletActivitiesCompanion(
      id: Value(id),
      walletId: Value(walletId),
      uuid: Value(uuid),
      actorAccountId: actorAccountId == null && nullToAbsent
          ? const Value.absent()
          : Value(actorAccountId),
      actorMemberId: actorMemberId == null && nullToAbsent
          ? const Value.absent()
          : Value(actorMemberId),
      action: Value(action),
      entityType: Value(entityType),
      entityId: Value(entityId),
      entityUuid: entityUuid == null && nullToAbsent
          ? const Value.absent()
          : Value(entityUuid),
      details: details == null && nullToAbsent
          ? const Value.absent()
          : Value(details),
      metadata: metadata == null && nullToAbsent
          ? const Value.absent()
          : Value(metadata),
      source: Value(source),
      createdAt: Value(createdAt),
    );
  }

  factory WalletActivity.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return WalletActivity(
      id: serializer.fromJson<int>(json['id']),
      walletId: serializer.fromJson<int>(json['walletId']),
      uuid: serializer.fromJson<String>(json['uuid']),
      actorAccountId: serializer.fromJson<int?>(json['actorAccountId']),
      actorMemberId: serializer.fromJson<int?>(json['actorMemberId']),
      action: serializer.fromJson<String>(json['action']),
      entityType: serializer.fromJson<String>(json['entityType']),
      entityId: serializer.fromJson<int>(json['entityId']),
      entityUuid: serializer.fromJson<String?>(json['entityUuid']),
      details: serializer.fromJson<String?>(json['details']),
      metadata: serializer.fromJson<String?>(json['metadata']),
      source: serializer.fromJson<String>(json['source']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'walletId': serializer.toJson<int>(walletId),
      'uuid': serializer.toJson<String>(uuid),
      'actorAccountId': serializer.toJson<int?>(actorAccountId),
      'actorMemberId': serializer.toJson<int?>(actorMemberId),
      'action': serializer.toJson<String>(action),
      'entityType': serializer.toJson<String>(entityType),
      'entityId': serializer.toJson<int>(entityId),
      'entityUuid': serializer.toJson<String?>(entityUuid),
      'details': serializer.toJson<String?>(details),
      'metadata': serializer.toJson<String?>(metadata),
      'source': serializer.toJson<String>(source),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  WalletActivity copyWith({
    int? id,
    int? walletId,
    String? uuid,
    Value<int?> actorAccountId = const Value.absent(),
    Value<int?> actorMemberId = const Value.absent(),
    String? action,
    String? entityType,
    int? entityId,
    Value<String?> entityUuid = const Value.absent(),
    Value<String?> details = const Value.absent(),
    Value<String?> metadata = const Value.absent(),
    String? source,
    DateTime? createdAt,
  }) => WalletActivity(
    id: id ?? this.id,
    walletId: walletId ?? this.walletId,
    uuid: uuid ?? this.uuid,
    actorAccountId: actorAccountId.present
        ? actorAccountId.value
        : this.actorAccountId,
    actorMemberId: actorMemberId.present
        ? actorMemberId.value
        : this.actorMemberId,
    action: action ?? this.action,
    entityType: entityType ?? this.entityType,
    entityId: entityId ?? this.entityId,
    entityUuid: entityUuid.present ? entityUuid.value : this.entityUuid,
    details: details.present ? details.value : this.details,
    metadata: metadata.present ? metadata.value : this.metadata,
    source: source ?? this.source,
    createdAt: createdAt ?? this.createdAt,
  );
  WalletActivity copyWithCompanion(WalletActivitiesCompanion data) {
    return WalletActivity(
      id: data.id.present ? data.id.value : this.id,
      walletId: data.walletId.present ? data.walletId.value : this.walletId,
      uuid: data.uuid.present ? data.uuid.value : this.uuid,
      actorAccountId: data.actorAccountId.present
          ? data.actorAccountId.value
          : this.actorAccountId,
      actorMemberId: data.actorMemberId.present
          ? data.actorMemberId.value
          : this.actorMemberId,
      action: data.action.present ? data.action.value : this.action,
      entityType: data.entityType.present
          ? data.entityType.value
          : this.entityType,
      entityId: data.entityId.present ? data.entityId.value : this.entityId,
      entityUuid: data.entityUuid.present
          ? data.entityUuid.value
          : this.entityUuid,
      details: data.details.present ? data.details.value : this.details,
      metadata: data.metadata.present ? data.metadata.value : this.metadata,
      source: data.source.present ? data.source.value : this.source,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('WalletActivity(')
          ..write('id: $id, ')
          ..write('walletId: $walletId, ')
          ..write('uuid: $uuid, ')
          ..write('actorAccountId: $actorAccountId, ')
          ..write('actorMemberId: $actorMemberId, ')
          ..write('action: $action, ')
          ..write('entityType: $entityType, ')
          ..write('entityId: $entityId, ')
          ..write('entityUuid: $entityUuid, ')
          ..write('details: $details, ')
          ..write('metadata: $metadata, ')
          ..write('source: $source, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    walletId,
    uuid,
    actorAccountId,
    actorMemberId,
    action,
    entityType,
    entityId,
    entityUuid,
    details,
    metadata,
    source,
    createdAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is WalletActivity &&
          other.id == this.id &&
          other.walletId == this.walletId &&
          other.uuid == this.uuid &&
          other.actorAccountId == this.actorAccountId &&
          other.actorMemberId == this.actorMemberId &&
          other.action == this.action &&
          other.entityType == this.entityType &&
          other.entityId == this.entityId &&
          other.entityUuid == this.entityUuid &&
          other.details == this.details &&
          other.metadata == this.metadata &&
          other.source == this.source &&
          other.createdAt == this.createdAt);
}

class WalletActivitiesCompanion extends UpdateCompanion<WalletActivity> {
  final Value<int> id;
  final Value<int> walletId;
  final Value<String> uuid;
  final Value<int?> actorAccountId;
  final Value<int?> actorMemberId;
  final Value<String> action;
  final Value<String> entityType;
  final Value<int> entityId;
  final Value<String?> entityUuid;
  final Value<String?> details;
  final Value<String?> metadata;
  final Value<String> source;
  final Value<DateTime> createdAt;
  const WalletActivitiesCompanion({
    this.id = const Value.absent(),
    this.walletId = const Value.absent(),
    this.uuid = const Value.absent(),
    this.actorAccountId = const Value.absent(),
    this.actorMemberId = const Value.absent(),
    this.action = const Value.absent(),
    this.entityType = const Value.absent(),
    this.entityId = const Value.absent(),
    this.entityUuid = const Value.absent(),
    this.details = const Value.absent(),
    this.metadata = const Value.absent(),
    this.source = const Value.absent(),
    this.createdAt = const Value.absent(),
  });
  WalletActivitiesCompanion.insert({
    this.id = const Value.absent(),
    required int walletId,
    this.uuid = const Value.absent(),
    this.actorAccountId = const Value.absent(),
    this.actorMemberId = const Value.absent(),
    required String action,
    required String entityType,
    required int entityId,
    this.entityUuid = const Value.absent(),
    this.details = const Value.absent(),
    this.metadata = const Value.absent(),
    required String source,
    this.createdAt = const Value.absent(),
  }) : walletId = Value(walletId),
       action = Value(action),
       entityType = Value(entityType),
       entityId = Value(entityId),
       source = Value(source);
  static Insertable<WalletActivity> custom({
    Expression<int>? id,
    Expression<int>? walletId,
    Expression<String>? uuid,
    Expression<int>? actorAccountId,
    Expression<int>? actorMemberId,
    Expression<String>? action,
    Expression<String>? entityType,
    Expression<int>? entityId,
    Expression<String>? entityUuid,
    Expression<String>? details,
    Expression<String>? metadata,
    Expression<String>? source,
    Expression<DateTime>? createdAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (walletId != null) 'wallet_id': walletId,
      if (uuid != null) 'uuid': uuid,
      if (actorAccountId != null) 'actor_account_id': actorAccountId,
      if (actorMemberId != null) 'actor_member_id': actorMemberId,
      if (action != null) 'action': action,
      if (entityType != null) 'entity_type': entityType,
      if (entityId != null) 'entity_id': entityId,
      if (entityUuid != null) 'entity_uuid': entityUuid,
      if (details != null) 'details': details,
      if (metadata != null) 'metadata': metadata,
      if (source != null) 'source': source,
      if (createdAt != null) 'created_at': createdAt,
    });
  }

  WalletActivitiesCompanion copyWith({
    Value<int>? id,
    Value<int>? walletId,
    Value<String>? uuid,
    Value<int?>? actorAccountId,
    Value<int?>? actorMemberId,
    Value<String>? action,
    Value<String>? entityType,
    Value<int>? entityId,
    Value<String?>? entityUuid,
    Value<String?>? details,
    Value<String?>? metadata,
    Value<String>? source,
    Value<DateTime>? createdAt,
  }) {
    return WalletActivitiesCompanion(
      id: id ?? this.id,
      walletId: walletId ?? this.walletId,
      uuid: uuid ?? this.uuid,
      actorAccountId: actorAccountId ?? this.actorAccountId,
      actorMemberId: actorMemberId ?? this.actorMemberId,
      action: action ?? this.action,
      entityType: entityType ?? this.entityType,
      entityId: entityId ?? this.entityId,
      entityUuid: entityUuid ?? this.entityUuid,
      details: details ?? this.details,
      metadata: metadata ?? this.metadata,
      source: source ?? this.source,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (walletId.present) {
      map['wallet_id'] = Variable<int>(walletId.value);
    }
    if (uuid.present) {
      map['uuid'] = Variable<String>(uuid.value);
    }
    if (actorAccountId.present) {
      map['actor_account_id'] = Variable<int>(actorAccountId.value);
    }
    if (actorMemberId.present) {
      map['actor_member_id'] = Variable<int>(actorMemberId.value);
    }
    if (action.present) {
      map['action'] = Variable<String>(action.value);
    }
    if (entityType.present) {
      map['entity_type'] = Variable<String>(entityType.value);
    }
    if (entityId.present) {
      map['entity_id'] = Variable<int>(entityId.value);
    }
    if (entityUuid.present) {
      map['entity_uuid'] = Variable<String>(entityUuid.value);
    }
    if (details.present) {
      map['details'] = Variable<String>(details.value);
    }
    if (metadata.present) {
      map['metadata'] = Variable<String>(metadata.value);
    }
    if (source.present) {
      map['source'] = Variable<String>(source.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('WalletActivitiesCompanion(')
          ..write('id: $id, ')
          ..write('walletId: $walletId, ')
          ..write('uuid: $uuid, ')
          ..write('actorAccountId: $actorAccountId, ')
          ..write('actorMemberId: $actorMemberId, ')
          ..write('action: $action, ')
          ..write('entityType: $entityType, ')
          ..write('entityId: $entityId, ')
          ..write('entityUuid: $entityUuid, ')
          ..write('details: $details, ')
          ..write('metadata: $metadata, ')
          ..write('source: $source, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }
}

class $UsersTable extends Users with TableInfo<$UsersTable, User> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $UsersTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _uuidMeta = const VerificationMeta('uuid');
  @override
  late final GeneratedColumn<String> uuid = GeneratedColumn<String>(
    'uuid',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    clientDefault: () => const Uuid().v4(),
  );
  static const VerificationMeta _displayNameMeta = const VerificationMeta(
    'displayName',
  );
  @override
  late final GeneratedColumn<String> displayName = GeneratedColumn<String>(
    'display_name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _emailMeta = const VerificationMeta('email');
  @override
  late final GeneratedColumn<String> email = GeneratedColumn<String>(
    'email',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    uuid,
    displayName,
    email,
    createdAt,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'users';
  @override
  VerificationContext validateIntegrity(
    Insertable<User> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('uuid')) {
      context.handle(
        _uuidMeta,
        uuid.isAcceptableOrUnknown(data['uuid']!, _uuidMeta),
      );
    }
    if (data.containsKey('display_name')) {
      context.handle(
        _displayNameMeta,
        displayName.isAcceptableOrUnknown(
          data['display_name']!,
          _displayNameMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_displayNameMeta);
    }
    if (data.containsKey('email')) {
      context.handle(
        _emailMeta,
        email.isAcceptableOrUnknown(data['email']!, _emailMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  User map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return User(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      uuid: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}uuid'],
      )!,
      displayName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}display_name'],
      )!,
      email: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}email'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $UsersTable createAlias(String alias) {
    return $UsersTable(attachedDatabase, alias);
  }
}

class User extends DataClass implements Insertable<User> {
  final int id;
  final String uuid;

  /// Name shown in member lists, split sheets and audit entries.
  final String displayName;

  /// Optional contact detail for invitations. Null when the user was created
  /// locally without an address.
  final String? email;
  final DateTime createdAt;
  final DateTime updatedAt;
  const User({
    required this.id,
    required this.uuid,
    required this.displayName,
    this.email,
    required this.createdAt,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['uuid'] = Variable<String>(uuid);
    map['display_name'] = Variable<String>(displayName);
    if (!nullToAbsent || email != null) {
      map['email'] = Variable<String>(email);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  UsersCompanion toCompanion(bool nullToAbsent) {
    return UsersCompanion(
      id: Value(id),
      uuid: Value(uuid),
      displayName: Value(displayName),
      email: email == null && nullToAbsent
          ? const Value.absent()
          : Value(email),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory User.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return User(
      id: serializer.fromJson<int>(json['id']),
      uuid: serializer.fromJson<String>(json['uuid']),
      displayName: serializer.fromJson<String>(json['displayName']),
      email: serializer.fromJson<String?>(json['email']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'uuid': serializer.toJson<String>(uuid),
      'displayName': serializer.toJson<String>(displayName),
      'email': serializer.toJson<String?>(email),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  User copyWith({
    int? id,
    String? uuid,
    String? displayName,
    Value<String?> email = const Value.absent(),
    DateTime? createdAt,
    DateTime? updatedAt,
  }) => User(
    id: id ?? this.id,
    uuid: uuid ?? this.uuid,
    displayName: displayName ?? this.displayName,
    email: email.present ? email.value : this.email,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  User copyWithCompanion(UsersCompanion data) {
    return User(
      id: data.id.present ? data.id.value : this.id,
      uuid: data.uuid.present ? data.uuid.value : this.uuid,
      displayName: data.displayName.present
          ? data.displayName.value
          : this.displayName,
      email: data.email.present ? data.email.value : this.email,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('User(')
          ..write('id: $id, ')
          ..write('uuid: $uuid, ')
          ..write('displayName: $displayName, ')
          ..write('email: $email, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, uuid, displayName, email, createdAt, updatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is User &&
          other.id == this.id &&
          other.uuid == this.uuid &&
          other.displayName == this.displayName &&
          other.email == this.email &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class UsersCompanion extends UpdateCompanion<User> {
  final Value<int> id;
  final Value<String> uuid;
  final Value<String> displayName;
  final Value<String?> email;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  const UsersCompanion({
    this.id = const Value.absent(),
    this.uuid = const Value.absent(),
    this.displayName = const Value.absent(),
    this.email = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  });
  UsersCompanion.insert({
    this.id = const Value.absent(),
    this.uuid = const Value.absent(),
    required String displayName,
    this.email = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  }) : displayName = Value(displayName);
  static Insertable<User> custom({
    Expression<int>? id,
    Expression<String>? uuid,
    Expression<String>? displayName,
    Expression<String>? email,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (uuid != null) 'uuid': uuid,
      if (displayName != null) 'display_name': displayName,
      if (email != null) 'email': email,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
    });
  }

  UsersCompanion copyWith({
    Value<int>? id,
    Value<String>? uuid,
    Value<String>? displayName,
    Value<String?>? email,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
  }) {
    return UsersCompanion(
      id: id ?? this.id,
      uuid: uuid ?? this.uuid,
      displayName: displayName ?? this.displayName,
      email: email ?? this.email,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (uuid.present) {
      map['uuid'] = Variable<String>(uuid.value);
    }
    if (displayName.present) {
      map['display_name'] = Variable<String>(displayName.value);
    }
    if (email.present) {
      map['email'] = Variable<String>(email.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('UsersCompanion(')
          ..write('id: $id, ')
          ..write('uuid: $uuid, ')
          ..write('displayName: $displayName, ')
          ..write('email: $email, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $AccountsTable accounts = $AccountsTable(this);
  late final $WalletBillsTable walletBills = $WalletBillsTable(this);
  late final $BudgetsTable budgets = $BudgetsTable(this);
  late final $CategoriesTable categories = $CategoriesTable(this);
  late final $WalletNotificationsTable walletNotifications =
      $WalletNotificationsTable(this);
  late final $LoansTable loans = $LoansTable(this);
  late final $PeerDebtsTable peerDebts = $PeerDebtsTable(this);
  late final $WalletAllowancesTable walletAllowances = $WalletAllowancesTable(
    this,
  );
  late final $WalletAllowancePaymentsTable walletAllowancePayments =
      $WalletAllowancePaymentsTable(this);
  late final $WalletSettlementsTable walletSettlements =
      $WalletSettlementsTable(this);
  late final $WalletsTable wallets = $WalletsTable(this);
  late final $WalletInvitationsTable walletInvitations =
      $WalletInvitationsTable(this);
  late final $WalletMembersTable walletMembers = $WalletMembersTable(this);
  late final $WalletGoalsTable walletGoals = $WalletGoalsTable(this);
  late final $WalletGoalContributionsTable walletGoalContributions =
      $WalletGoalContributionsTable(this);
  late final $WalletGoalSchedulesTable walletGoalSchedules =
      $WalletGoalSchedulesTable(this);
  late final $FeedbackEntriesTable feedbackEntries = $FeedbackEntriesTable(
    this,
  );
  late final $WalletNotificationPreferencesTable walletNotificationPreferences =
      $WalletNotificationPreferencesTable(this);
  late final $DeletedRecordsTable deletedRecords = $DeletedRecordsTable(this);
  late final $AttachmentsTable attachments = $AttachmentsTable(this);
  late final $WalletExpenseSplitsTable walletExpenseSplits =
      $WalletExpenseSplitsTable(this);
  late final $WalletExpenseSplitMembersTable walletExpenseSplitMembers =
      $WalletExpenseSplitMembersTable(this);
  late final $MerchantMappingsTable merchantMappings = $MerchantMappingsTable(
    this,
  );
  late final $PayeesTable payees = $PayeesTable(this);
  late final $RecurringTransactionsTable recurringTransactions =
      $RecurringTransactionsTable(this);
  late final $SmsImportMetricsTable smsImportMetrics = $SmsImportMetricsTable(
    this,
  );
  late final $TagsTable tags = $TagsTable(this);
  late final $TransactionsTable transactions = $TransactionsTable(this);
  late final $UnrecognizedSmsEntriesTable unrecognizedSmsEntries =
      $UnrecognizedSmsEntriesTable(this);
  late final $WalletActivitiesTable walletActivities = $WalletActivitiesTable(
    this,
  );
  late final $UsersTable users = $UsersTable(this);
  late final CategoryDao categoryDao = CategoryDao(this as AppDatabase);
  late final AccountDao accountDao = AccountDao(this as AppDatabase);
  late final TransactionDao transactionDao = TransactionDao(
    this as AppDatabase,
  );
  late final BudgetDao budgetDao = BudgetDao(this as AppDatabase);
  late final RecurringTransactionDao recurringTransactionDao =
      RecurringTransactionDao(this as AppDatabase);
  late final DebtsDao debtsDao = DebtsDao(this as AppDatabase);
  late final WalletDao walletDao = WalletDao(this as AppDatabase);
  late final TransactionTagDao transactionTagDao = TransactionTagDao(
    this as AppDatabase,
  );
  late final AttachmentDao attachmentDao = AttachmentDao(this as AppDatabase);
  late final AllowanceDao allowanceDao = AllowanceDao(this as AppDatabase);
  late final GoalDao goalDao = GoalDao(this as AppDatabase);
  late final BillDao billDao = BillDao(this as AppDatabase);
  late final PayeeDao payeeDao = PayeeDao(this as AppDatabase);
  late final SmsParsingDao smsParsingDao = SmsParsingDao(this as AppDatabase);
  late final SmsImportMetricsDao smsImportMetricsDao = SmsImportMetricsDao(
    this as AppDatabase,
  );
  late final UserDao userDao = UserDao(this as AppDatabase);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    accounts,
    walletBills,
    budgets,
    categories,
    walletNotifications,
    loans,
    peerDebts,
    walletAllowances,
    walletAllowancePayments,
    walletSettlements,
    wallets,
    walletInvitations,
    walletMembers,
    walletGoals,
    walletGoalContributions,
    walletGoalSchedules,
    feedbackEntries,
    walletNotificationPreferences,
    deletedRecords,
    attachments,
    walletExpenseSplits,
    walletExpenseSplitMembers,
    merchantMappings,
    payees,
    recurringTransactions,
    smsImportMetrics,
    tags,
    transactions,
    unrecognizedSmsEntries,
    walletActivities,
    users,
  ];
}

typedef $$AccountsTableCreateCompanionBuilder =
    AccountsCompanion Function({
      Value<int> walletId,
      Value<int> id,
      Value<String> uuid,
      required String name,
      required AccountType type,
      required int icon,
      required String color,
      Value<double> openingBalance,
      Value<bool> isDefault,
      Value<DateTime> updatedAt,
    });
typedef $$AccountsTableUpdateCompanionBuilder =
    AccountsCompanion Function({
      Value<int> walletId,
      Value<int> id,
      Value<String> uuid,
      Value<String> name,
      Value<AccountType> type,
      Value<int> icon,
      Value<String> color,
      Value<double> openingBalance,
      Value<bool> isDefault,
      Value<DateTime> updatedAt,
    });

class $$AccountsTableFilterComposer
    extends Composer<_$AppDatabase, $AccountsTable> {
  $$AccountsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get walletId => $composableBuilder(
    column: $table.walletId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get uuid => $composableBuilder(
    column: $table.uuid,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<AccountType, AccountType, String> get type =>
      $composableBuilder(
        column: $table.type,
        builder: (column) => ColumnWithTypeConverterFilters(column),
      );

  ColumnFilters<int> get icon => $composableBuilder(
    column: $table.icon,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get color => $composableBuilder(
    column: $table.color,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<double, double, int> get openingBalance =>
      $composableBuilder(
        column: $table.openingBalance,
        builder: (column) => ColumnWithTypeConverterFilters(column),
      );

  ColumnFilters<bool> get isDefault => $composableBuilder(
    column: $table.isDefault,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$AccountsTableOrderingComposer
    extends Composer<_$AppDatabase, $AccountsTable> {
  $$AccountsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get walletId => $composableBuilder(
    column: $table.walletId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get uuid => $composableBuilder(
    column: $table.uuid,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get type => $composableBuilder(
    column: $table.type,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get icon => $composableBuilder(
    column: $table.icon,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get color => $composableBuilder(
    column: $table.color,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get openingBalance => $composableBuilder(
    column: $table.openingBalance,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isDefault => $composableBuilder(
    column: $table.isDefault,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$AccountsTableAnnotationComposer
    extends Composer<_$AppDatabase, $AccountsTable> {
  $$AccountsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get walletId =>
      $composableBuilder(column: $table.walletId, builder: (column) => column);

  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get uuid =>
      $composableBuilder(column: $table.uuid, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumnWithTypeConverter<AccountType, String> get type =>
      $composableBuilder(column: $table.type, builder: (column) => column);

  GeneratedColumn<int> get icon =>
      $composableBuilder(column: $table.icon, builder: (column) => column);

  GeneratedColumn<String> get color =>
      $composableBuilder(column: $table.color, builder: (column) => column);

  GeneratedColumnWithTypeConverter<double, int> get openingBalance =>
      $composableBuilder(
        column: $table.openingBalance,
        builder: (column) => column,
      );

  GeneratedColumn<bool> get isDefault =>
      $composableBuilder(column: $table.isDefault, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$AccountsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $AccountsTable,
          Account,
          $$AccountsTableFilterComposer,
          $$AccountsTableOrderingComposer,
          $$AccountsTableAnnotationComposer,
          $$AccountsTableCreateCompanionBuilder,
          $$AccountsTableUpdateCompanionBuilder,
          (Account, BaseReferences<_$AppDatabase, $AccountsTable, Account>),
          Account,
          PrefetchHooks Function()
        > {
  $$AccountsTableTableManager(_$AppDatabase db, $AccountsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$AccountsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$AccountsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$AccountsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> walletId = const Value.absent(),
                Value<int> id = const Value.absent(),
                Value<String> uuid = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<AccountType> type = const Value.absent(),
                Value<int> icon = const Value.absent(),
                Value<String> color = const Value.absent(),
                Value<double> openingBalance = const Value.absent(),
                Value<bool> isDefault = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
              }) => AccountsCompanion(
                walletId: walletId,
                id: id,
                uuid: uuid,
                name: name,
                type: type,
                icon: icon,
                color: color,
                openingBalance: openingBalance,
                isDefault: isDefault,
                updatedAt: updatedAt,
              ),
          createCompanionCallback:
              ({
                Value<int> walletId = const Value.absent(),
                Value<int> id = const Value.absent(),
                Value<String> uuid = const Value.absent(),
                required String name,
                required AccountType type,
                required int icon,
                required String color,
                Value<double> openingBalance = const Value.absent(),
                Value<bool> isDefault = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
              }) => AccountsCompanion.insert(
                walletId: walletId,
                id: id,
                uuid: uuid,
                name: name,
                type: type,
                icon: icon,
                color: color,
                openingBalance: openingBalance,
                isDefault: isDefault,
                updatedAt: updatedAt,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$AccountsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $AccountsTable,
      Account,
      $$AccountsTableFilterComposer,
      $$AccountsTableOrderingComposer,
      $$AccountsTableAnnotationComposer,
      $$AccountsTableCreateCompanionBuilder,
      $$AccountsTableUpdateCompanionBuilder,
      (Account, BaseReferences<_$AppDatabase, $AccountsTable, Account>),
      Account,
      PrefetchHooks Function()
    >;
typedef $$WalletBillsTableCreateCompanionBuilder =
    WalletBillsCompanion Function({
      Value<int> id,
      required int walletId,
      required String name,
      required double amount,
      required DateTime dueDate,
      required WalletBillRecurrence recurrence,
      required String category,
      Value<String?> notes,
      Value<WalletBillStatus> status,
      Value<bool> isActive,
      Value<int?> createdByAccountId,
      Value<int?> updatedByAccountId,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
    });
typedef $$WalletBillsTableUpdateCompanionBuilder =
    WalletBillsCompanion Function({
      Value<int> id,
      Value<int> walletId,
      Value<String> name,
      Value<double> amount,
      Value<DateTime> dueDate,
      Value<WalletBillRecurrence> recurrence,
      Value<String> category,
      Value<String?> notes,
      Value<WalletBillStatus> status,
      Value<bool> isActive,
      Value<int?> createdByAccountId,
      Value<int?> updatedByAccountId,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
    });

class $$WalletBillsTableFilterComposer
    extends Composer<_$AppDatabase, $WalletBillsTable> {
  $$WalletBillsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get walletId => $composableBuilder(
    column: $table.walletId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<double, double, int> get amount =>
      $composableBuilder(
        column: $table.amount,
        builder: (column) => ColumnWithTypeConverterFilters(column),
      );

  ColumnFilters<DateTime> get dueDate => $composableBuilder(
    column: $table.dueDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<
    WalletBillRecurrence,
    WalletBillRecurrence,
    String
  >
  get recurrence => $composableBuilder(
    column: $table.recurrence,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  ColumnFilters<String> get category => $composableBuilder(
    column: $table.category,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<WalletBillStatus, WalletBillStatus, String>
  get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  ColumnFilters<bool> get isActive => $composableBuilder(
    column: $table.isActive,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get createdByAccountId => $composableBuilder(
    column: $table.createdByAccountId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get updatedByAccountId => $composableBuilder(
    column: $table.updatedByAccountId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$WalletBillsTableOrderingComposer
    extends Composer<_$AppDatabase, $WalletBillsTable> {
  $$WalletBillsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get walletId => $composableBuilder(
    column: $table.walletId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get amount => $composableBuilder(
    column: $table.amount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get dueDate => $composableBuilder(
    column: $table.dueDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get recurrence => $composableBuilder(
    column: $table.recurrence,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get category => $composableBuilder(
    column: $table.category,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isActive => $composableBuilder(
    column: $table.isActive,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get createdByAccountId => $composableBuilder(
    column: $table.createdByAccountId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get updatedByAccountId => $composableBuilder(
    column: $table.updatedByAccountId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$WalletBillsTableAnnotationComposer
    extends Composer<_$AppDatabase, $WalletBillsTable> {
  $$WalletBillsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get walletId =>
      $composableBuilder(column: $table.walletId, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumnWithTypeConverter<double, int> get amount =>
      $composableBuilder(column: $table.amount, builder: (column) => column);

  GeneratedColumn<DateTime> get dueDate =>
      $composableBuilder(column: $table.dueDate, builder: (column) => column);

  GeneratedColumnWithTypeConverter<WalletBillRecurrence, String>
  get recurrence => $composableBuilder(
    column: $table.recurrence,
    builder: (column) => column,
  );

  GeneratedColumn<String> get category =>
      $composableBuilder(column: $table.category, builder: (column) => column);

  GeneratedColumn<String> get notes =>
      $composableBuilder(column: $table.notes, builder: (column) => column);

  GeneratedColumnWithTypeConverter<WalletBillStatus, String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<bool> get isActive =>
      $composableBuilder(column: $table.isActive, builder: (column) => column);

  GeneratedColumn<int> get createdByAccountId => $composableBuilder(
    column: $table.createdByAccountId,
    builder: (column) => column,
  );

  GeneratedColumn<int> get updatedByAccountId => $composableBuilder(
    column: $table.updatedByAccountId,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$WalletBillsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $WalletBillsTable,
          WalletBill,
          $$WalletBillsTableFilterComposer,
          $$WalletBillsTableOrderingComposer,
          $$WalletBillsTableAnnotationComposer,
          $$WalletBillsTableCreateCompanionBuilder,
          $$WalletBillsTableUpdateCompanionBuilder,
          (
            WalletBill,
            BaseReferences<_$AppDatabase, $WalletBillsTable, WalletBill>,
          ),
          WalletBill,
          PrefetchHooks Function()
        > {
  $$WalletBillsTableTableManager(_$AppDatabase db, $WalletBillsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$WalletBillsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$WalletBillsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$WalletBillsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> walletId = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<double> amount = const Value.absent(),
                Value<DateTime> dueDate = const Value.absent(),
                Value<WalletBillRecurrence> recurrence = const Value.absent(),
                Value<String> category = const Value.absent(),
                Value<String?> notes = const Value.absent(),
                Value<WalletBillStatus> status = const Value.absent(),
                Value<bool> isActive = const Value.absent(),
                Value<int?> createdByAccountId = const Value.absent(),
                Value<int?> updatedByAccountId = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
              }) => WalletBillsCompanion(
                id: id,
                walletId: walletId,
                name: name,
                amount: amount,
                dueDate: dueDate,
                recurrence: recurrence,
                category: category,
                notes: notes,
                status: status,
                isActive: isActive,
                createdByAccountId: createdByAccountId,
                updatedByAccountId: updatedByAccountId,
                createdAt: createdAt,
                updatedAt: updatedAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int walletId,
                required String name,
                required double amount,
                required DateTime dueDate,
                required WalletBillRecurrence recurrence,
                required String category,
                Value<String?> notes = const Value.absent(),
                Value<WalletBillStatus> status = const Value.absent(),
                Value<bool> isActive = const Value.absent(),
                Value<int?> createdByAccountId = const Value.absent(),
                Value<int?> updatedByAccountId = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
              }) => WalletBillsCompanion.insert(
                id: id,
                walletId: walletId,
                name: name,
                amount: amount,
                dueDate: dueDate,
                recurrence: recurrence,
                category: category,
                notes: notes,
                status: status,
                isActive: isActive,
                createdByAccountId: createdByAccountId,
                updatedByAccountId: updatedByAccountId,
                createdAt: createdAt,
                updatedAt: updatedAt,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$WalletBillsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $WalletBillsTable,
      WalletBill,
      $$WalletBillsTableFilterComposer,
      $$WalletBillsTableOrderingComposer,
      $$WalletBillsTableAnnotationComposer,
      $$WalletBillsTableCreateCompanionBuilder,
      $$WalletBillsTableUpdateCompanionBuilder,
      (
        WalletBill,
        BaseReferences<_$AppDatabase, $WalletBillsTable, WalletBill>,
      ),
      WalletBill,
      PrefetchHooks Function()
    >;
typedef $$BudgetsTableCreateCompanionBuilder =
    BudgetsCompanion Function({
      Value<int> id,
      Value<int> walletId,
      Value<String> uuid,
      required double amount,
      required String period,
      required int categoryId,
      Value<DateTime> updatedAt,
    });
typedef $$BudgetsTableUpdateCompanionBuilder =
    BudgetsCompanion Function({
      Value<int> id,
      Value<int> walletId,
      Value<String> uuid,
      Value<double> amount,
      Value<String> period,
      Value<int> categoryId,
      Value<DateTime> updatedAt,
    });

class $$BudgetsTableFilterComposer
    extends Composer<_$AppDatabase, $BudgetsTable> {
  $$BudgetsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get walletId => $composableBuilder(
    column: $table.walletId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get uuid => $composableBuilder(
    column: $table.uuid,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<double, double, int> get amount =>
      $composableBuilder(
        column: $table.amount,
        builder: (column) => ColumnWithTypeConverterFilters(column),
      );

  ColumnFilters<String> get period => $composableBuilder(
    column: $table.period,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get categoryId => $composableBuilder(
    column: $table.categoryId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$BudgetsTableOrderingComposer
    extends Composer<_$AppDatabase, $BudgetsTable> {
  $$BudgetsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get walletId => $composableBuilder(
    column: $table.walletId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get uuid => $composableBuilder(
    column: $table.uuid,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get amount => $composableBuilder(
    column: $table.amount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get period => $composableBuilder(
    column: $table.period,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get categoryId => $composableBuilder(
    column: $table.categoryId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$BudgetsTableAnnotationComposer
    extends Composer<_$AppDatabase, $BudgetsTable> {
  $$BudgetsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get walletId =>
      $composableBuilder(column: $table.walletId, builder: (column) => column);

  GeneratedColumn<String> get uuid =>
      $composableBuilder(column: $table.uuid, builder: (column) => column);

  GeneratedColumnWithTypeConverter<double, int> get amount =>
      $composableBuilder(column: $table.amount, builder: (column) => column);

  GeneratedColumn<String> get period =>
      $composableBuilder(column: $table.period, builder: (column) => column);

  GeneratedColumn<int> get categoryId => $composableBuilder(
    column: $table.categoryId,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$BudgetsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $BudgetsTable,
          Budget,
          $$BudgetsTableFilterComposer,
          $$BudgetsTableOrderingComposer,
          $$BudgetsTableAnnotationComposer,
          $$BudgetsTableCreateCompanionBuilder,
          $$BudgetsTableUpdateCompanionBuilder,
          (Budget, BaseReferences<_$AppDatabase, $BudgetsTable, Budget>),
          Budget,
          PrefetchHooks Function()
        > {
  $$BudgetsTableTableManager(_$AppDatabase db, $BudgetsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$BudgetsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$BudgetsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$BudgetsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> walletId = const Value.absent(),
                Value<String> uuid = const Value.absent(),
                Value<double> amount = const Value.absent(),
                Value<String> period = const Value.absent(),
                Value<int> categoryId = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
              }) => BudgetsCompanion(
                id: id,
                walletId: walletId,
                uuid: uuid,
                amount: amount,
                period: period,
                categoryId: categoryId,
                updatedAt: updatedAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> walletId = const Value.absent(),
                Value<String> uuid = const Value.absent(),
                required double amount,
                required String period,
                required int categoryId,
                Value<DateTime> updatedAt = const Value.absent(),
              }) => BudgetsCompanion.insert(
                id: id,
                walletId: walletId,
                uuid: uuid,
                amount: amount,
                period: period,
                categoryId: categoryId,
                updatedAt: updatedAt,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$BudgetsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $BudgetsTable,
      Budget,
      $$BudgetsTableFilterComposer,
      $$BudgetsTableOrderingComposer,
      $$BudgetsTableAnnotationComposer,
      $$BudgetsTableCreateCompanionBuilder,
      $$BudgetsTableUpdateCompanionBuilder,
      (Budget, BaseReferences<_$AppDatabase, $BudgetsTable, Budget>),
      Budget,
      PrefetchHooks Function()
    >;
typedef $$CategoriesTableCreateCompanionBuilder =
    CategoriesCompanion Function({
      Value<int> id,
      Value<String> uuid,
      required String name,
      required int icon,
      required String color,
      Value<bool> isDefault,
      Value<int?> parentId,
      Value<DateTime> updatedAt,
    });
typedef $$CategoriesTableUpdateCompanionBuilder =
    CategoriesCompanion Function({
      Value<int> id,
      Value<String> uuid,
      Value<String> name,
      Value<int> icon,
      Value<String> color,
      Value<bool> isDefault,
      Value<int?> parentId,
      Value<DateTime> updatedAt,
    });

class $$CategoriesTableFilterComposer
    extends Composer<_$AppDatabase, $CategoriesTable> {
  $$CategoriesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get uuid => $composableBuilder(
    column: $table.uuid,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get icon => $composableBuilder(
    column: $table.icon,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get color => $composableBuilder(
    column: $table.color,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isDefault => $composableBuilder(
    column: $table.isDefault,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get parentId => $composableBuilder(
    column: $table.parentId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$CategoriesTableOrderingComposer
    extends Composer<_$AppDatabase, $CategoriesTable> {
  $$CategoriesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get uuid => $composableBuilder(
    column: $table.uuid,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get icon => $composableBuilder(
    column: $table.icon,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get color => $composableBuilder(
    column: $table.color,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isDefault => $composableBuilder(
    column: $table.isDefault,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get parentId => $composableBuilder(
    column: $table.parentId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$CategoriesTableAnnotationComposer
    extends Composer<_$AppDatabase, $CategoriesTable> {
  $$CategoriesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get uuid =>
      $composableBuilder(column: $table.uuid, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<int> get icon =>
      $composableBuilder(column: $table.icon, builder: (column) => column);

  GeneratedColumn<String> get color =>
      $composableBuilder(column: $table.color, builder: (column) => column);

  GeneratedColumn<bool> get isDefault =>
      $composableBuilder(column: $table.isDefault, builder: (column) => column);

  GeneratedColumn<int> get parentId =>
      $composableBuilder(column: $table.parentId, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$CategoriesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $CategoriesTable,
          Category,
          $$CategoriesTableFilterComposer,
          $$CategoriesTableOrderingComposer,
          $$CategoriesTableAnnotationComposer,
          $$CategoriesTableCreateCompanionBuilder,
          $$CategoriesTableUpdateCompanionBuilder,
          (Category, BaseReferences<_$AppDatabase, $CategoriesTable, Category>),
          Category,
          PrefetchHooks Function()
        > {
  $$CategoriesTableTableManager(_$AppDatabase db, $CategoriesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CategoriesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$CategoriesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$CategoriesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> uuid = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<int> icon = const Value.absent(),
                Value<String> color = const Value.absent(),
                Value<bool> isDefault = const Value.absent(),
                Value<int?> parentId = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
              }) => CategoriesCompanion(
                id: id,
                uuid: uuid,
                name: name,
                icon: icon,
                color: color,
                isDefault: isDefault,
                parentId: parentId,
                updatedAt: updatedAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> uuid = const Value.absent(),
                required String name,
                required int icon,
                required String color,
                Value<bool> isDefault = const Value.absent(),
                Value<int?> parentId = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
              }) => CategoriesCompanion.insert(
                id: id,
                uuid: uuid,
                name: name,
                icon: icon,
                color: color,
                isDefault: isDefault,
                parentId: parentId,
                updatedAt: updatedAt,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$CategoriesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $CategoriesTable,
      Category,
      $$CategoriesTableFilterComposer,
      $$CategoriesTableOrderingComposer,
      $$CategoriesTableAnnotationComposer,
      $$CategoriesTableCreateCompanionBuilder,
      $$CategoriesTableUpdateCompanionBuilder,
      (Category, BaseReferences<_$AppDatabase, $CategoriesTable, Category>),
      Category,
      PrefetchHooks Function()
    >;
typedef $$WalletNotificationsTableCreateCompanionBuilder =
    WalletNotificationsCompanion Function({
      Value<int> id,
      required int walletId,
      Value<int?> memberId,
      required WalletNotificationType type,
      required String title,
      required String message,
      Value<int?> relatedEntityId,
      Value<DateTime> createdAt,
      Value<DateTime?> readAt,
      Value<DateTime?> dismissedAt,
    });
typedef $$WalletNotificationsTableUpdateCompanionBuilder =
    WalletNotificationsCompanion Function({
      Value<int> id,
      Value<int> walletId,
      Value<int?> memberId,
      Value<WalletNotificationType> type,
      Value<String> title,
      Value<String> message,
      Value<int?> relatedEntityId,
      Value<DateTime> createdAt,
      Value<DateTime?> readAt,
      Value<DateTime?> dismissedAt,
    });

class $$WalletNotificationsTableFilterComposer
    extends Composer<_$AppDatabase, $WalletNotificationsTable> {
  $$WalletNotificationsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get walletId => $composableBuilder(
    column: $table.walletId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get memberId => $composableBuilder(
    column: $table.memberId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<
    WalletNotificationType,
    WalletNotificationType,
    String
  >
  get type => $composableBuilder(
    column: $table.type,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  ColumnFilters<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get message => $composableBuilder(
    column: $table.message,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get relatedEntityId => $composableBuilder(
    column: $table.relatedEntityId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get readAt => $composableBuilder(
    column: $table.readAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get dismissedAt => $composableBuilder(
    column: $table.dismissedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$WalletNotificationsTableOrderingComposer
    extends Composer<_$AppDatabase, $WalletNotificationsTable> {
  $$WalletNotificationsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get walletId => $composableBuilder(
    column: $table.walletId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get memberId => $composableBuilder(
    column: $table.memberId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get type => $composableBuilder(
    column: $table.type,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get message => $composableBuilder(
    column: $table.message,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get relatedEntityId => $composableBuilder(
    column: $table.relatedEntityId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get readAt => $composableBuilder(
    column: $table.readAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get dismissedAt => $composableBuilder(
    column: $table.dismissedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$WalletNotificationsTableAnnotationComposer
    extends Composer<_$AppDatabase, $WalletNotificationsTable> {
  $$WalletNotificationsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get walletId =>
      $composableBuilder(column: $table.walletId, builder: (column) => column);

  GeneratedColumn<int> get memberId =>
      $composableBuilder(column: $table.memberId, builder: (column) => column);

  GeneratedColumnWithTypeConverter<WalletNotificationType, String> get type =>
      $composableBuilder(column: $table.type, builder: (column) => column);

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumn<String> get message =>
      $composableBuilder(column: $table.message, builder: (column) => column);

  GeneratedColumn<int> get relatedEntityId => $composableBuilder(
    column: $table.relatedEntityId,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get readAt =>
      $composableBuilder(column: $table.readAt, builder: (column) => column);

  GeneratedColumn<DateTime> get dismissedAt => $composableBuilder(
    column: $table.dismissedAt,
    builder: (column) => column,
  );
}

class $$WalletNotificationsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $WalletNotificationsTable,
          WalletNotification,
          $$WalletNotificationsTableFilterComposer,
          $$WalletNotificationsTableOrderingComposer,
          $$WalletNotificationsTableAnnotationComposer,
          $$WalletNotificationsTableCreateCompanionBuilder,
          $$WalletNotificationsTableUpdateCompanionBuilder,
          (
            WalletNotification,
            BaseReferences<
              _$AppDatabase,
              $WalletNotificationsTable,
              WalletNotification
            >,
          ),
          WalletNotification,
          PrefetchHooks Function()
        > {
  $$WalletNotificationsTableTableManager(
    _$AppDatabase db,
    $WalletNotificationsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$WalletNotificationsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$WalletNotificationsTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer: () =>
              $$WalletNotificationsTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> walletId = const Value.absent(),
                Value<int?> memberId = const Value.absent(),
                Value<WalletNotificationType> type = const Value.absent(),
                Value<String> title = const Value.absent(),
                Value<String> message = const Value.absent(),
                Value<int?> relatedEntityId = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime?> readAt = const Value.absent(),
                Value<DateTime?> dismissedAt = const Value.absent(),
              }) => WalletNotificationsCompanion(
                id: id,
                walletId: walletId,
                memberId: memberId,
                type: type,
                title: title,
                message: message,
                relatedEntityId: relatedEntityId,
                createdAt: createdAt,
                readAt: readAt,
                dismissedAt: dismissedAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int walletId,
                Value<int?> memberId = const Value.absent(),
                required WalletNotificationType type,
                required String title,
                required String message,
                Value<int?> relatedEntityId = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime?> readAt = const Value.absent(),
                Value<DateTime?> dismissedAt = const Value.absent(),
              }) => WalletNotificationsCompanion.insert(
                id: id,
                walletId: walletId,
                memberId: memberId,
                type: type,
                title: title,
                message: message,
                relatedEntityId: relatedEntityId,
                createdAt: createdAt,
                readAt: readAt,
                dismissedAt: dismissedAt,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$WalletNotificationsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $WalletNotificationsTable,
      WalletNotification,
      $$WalletNotificationsTableFilterComposer,
      $$WalletNotificationsTableOrderingComposer,
      $$WalletNotificationsTableAnnotationComposer,
      $$WalletNotificationsTableCreateCompanionBuilder,
      $$WalletNotificationsTableUpdateCompanionBuilder,
      (
        WalletNotification,
        BaseReferences<
          _$AppDatabase,
          $WalletNotificationsTable,
          WalletNotification
        >,
      ),
      WalletNotification,
      PrefetchHooks Function()
    >;
typedef $$LoansTableCreateCompanionBuilder =
    LoansCompanion Function({
      Value<int> id,
      Value<int> walletId,
      Value<String> uuid,
      required String name,
      required int accountId,
      required double principalAmount,
      required double interestRate,
      required int tenureMonths,
      required DateTime startDate,
      Value<DateTime?> nextEmiDate,
      required double emiAmount,
      Value<bool> isActive,
      Value<DateTime> updatedAt,
    });
typedef $$LoansTableUpdateCompanionBuilder =
    LoansCompanion Function({
      Value<int> id,
      Value<int> walletId,
      Value<String> uuid,
      Value<String> name,
      Value<int> accountId,
      Value<double> principalAmount,
      Value<double> interestRate,
      Value<int> tenureMonths,
      Value<DateTime> startDate,
      Value<DateTime?> nextEmiDate,
      Value<double> emiAmount,
      Value<bool> isActive,
      Value<DateTime> updatedAt,
    });

class $$LoansTableFilterComposer extends Composer<_$AppDatabase, $LoansTable> {
  $$LoansTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get walletId => $composableBuilder(
    column: $table.walletId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get uuid => $composableBuilder(
    column: $table.uuid,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get accountId => $composableBuilder(
    column: $table.accountId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<double, double, int> get principalAmount =>
      $composableBuilder(
        column: $table.principalAmount,
        builder: (column) => ColumnWithTypeConverterFilters(column),
      );

  ColumnFilters<double> get interestRate => $composableBuilder(
    column: $table.interestRate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get tenureMonths => $composableBuilder(
    column: $table.tenureMonths,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get startDate => $composableBuilder(
    column: $table.startDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get nextEmiDate => $composableBuilder(
    column: $table.nextEmiDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<double, double, int> get emiAmount =>
      $composableBuilder(
        column: $table.emiAmount,
        builder: (column) => ColumnWithTypeConverterFilters(column),
      );

  ColumnFilters<bool> get isActive => $composableBuilder(
    column: $table.isActive,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$LoansTableOrderingComposer
    extends Composer<_$AppDatabase, $LoansTable> {
  $$LoansTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get walletId => $composableBuilder(
    column: $table.walletId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get uuid => $composableBuilder(
    column: $table.uuid,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get accountId => $composableBuilder(
    column: $table.accountId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get principalAmount => $composableBuilder(
    column: $table.principalAmount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get interestRate => $composableBuilder(
    column: $table.interestRate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get tenureMonths => $composableBuilder(
    column: $table.tenureMonths,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get startDate => $composableBuilder(
    column: $table.startDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get nextEmiDate => $composableBuilder(
    column: $table.nextEmiDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get emiAmount => $composableBuilder(
    column: $table.emiAmount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isActive => $composableBuilder(
    column: $table.isActive,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$LoansTableAnnotationComposer
    extends Composer<_$AppDatabase, $LoansTable> {
  $$LoansTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get walletId =>
      $composableBuilder(column: $table.walletId, builder: (column) => column);

  GeneratedColumn<String> get uuid =>
      $composableBuilder(column: $table.uuid, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<int> get accountId =>
      $composableBuilder(column: $table.accountId, builder: (column) => column);

  GeneratedColumnWithTypeConverter<double, int> get principalAmount =>
      $composableBuilder(
        column: $table.principalAmount,
        builder: (column) => column,
      );

  GeneratedColumn<double> get interestRate => $composableBuilder(
    column: $table.interestRate,
    builder: (column) => column,
  );

  GeneratedColumn<int> get tenureMonths => $composableBuilder(
    column: $table.tenureMonths,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get startDate =>
      $composableBuilder(column: $table.startDate, builder: (column) => column);

  GeneratedColumn<DateTime> get nextEmiDate => $composableBuilder(
    column: $table.nextEmiDate,
    builder: (column) => column,
  );

  GeneratedColumnWithTypeConverter<double, int> get emiAmount =>
      $composableBuilder(column: $table.emiAmount, builder: (column) => column);

  GeneratedColumn<bool> get isActive =>
      $composableBuilder(column: $table.isActive, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$LoansTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $LoansTable,
          LoanDb,
          $$LoansTableFilterComposer,
          $$LoansTableOrderingComposer,
          $$LoansTableAnnotationComposer,
          $$LoansTableCreateCompanionBuilder,
          $$LoansTableUpdateCompanionBuilder,
          (LoanDb, BaseReferences<_$AppDatabase, $LoansTable, LoanDb>),
          LoanDb,
          PrefetchHooks Function()
        > {
  $$LoansTableTableManager(_$AppDatabase db, $LoansTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$LoansTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$LoansTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$LoansTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> walletId = const Value.absent(),
                Value<String> uuid = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<int> accountId = const Value.absent(),
                Value<double> principalAmount = const Value.absent(),
                Value<double> interestRate = const Value.absent(),
                Value<int> tenureMonths = const Value.absent(),
                Value<DateTime> startDate = const Value.absent(),
                Value<DateTime?> nextEmiDate = const Value.absent(),
                Value<double> emiAmount = const Value.absent(),
                Value<bool> isActive = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
              }) => LoansCompanion(
                id: id,
                walletId: walletId,
                uuid: uuid,
                name: name,
                accountId: accountId,
                principalAmount: principalAmount,
                interestRate: interestRate,
                tenureMonths: tenureMonths,
                startDate: startDate,
                nextEmiDate: nextEmiDate,
                emiAmount: emiAmount,
                isActive: isActive,
                updatedAt: updatedAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> walletId = const Value.absent(),
                Value<String> uuid = const Value.absent(),
                required String name,
                required int accountId,
                required double principalAmount,
                required double interestRate,
                required int tenureMonths,
                required DateTime startDate,
                Value<DateTime?> nextEmiDate = const Value.absent(),
                required double emiAmount,
                Value<bool> isActive = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
              }) => LoansCompanion.insert(
                id: id,
                walletId: walletId,
                uuid: uuid,
                name: name,
                accountId: accountId,
                principalAmount: principalAmount,
                interestRate: interestRate,
                tenureMonths: tenureMonths,
                startDate: startDate,
                nextEmiDate: nextEmiDate,
                emiAmount: emiAmount,
                isActive: isActive,
                updatedAt: updatedAt,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$LoansTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $LoansTable,
      LoanDb,
      $$LoansTableFilterComposer,
      $$LoansTableOrderingComposer,
      $$LoansTableAnnotationComposer,
      $$LoansTableCreateCompanionBuilder,
      $$LoansTableUpdateCompanionBuilder,
      (LoanDb, BaseReferences<_$AppDatabase, $LoansTable, LoanDb>),
      LoanDb,
      PrefetchHooks Function()
    >;
typedef $$PeerDebtsTableCreateCompanionBuilder =
    PeerDebtsCompanion Function({
      Value<int> id,
      required int walletId,
      Value<String> uuid,
      required String personName,
      required PeerDebtType type,
      required double amount,
      Value<String?> note,
      required DateTime date,
      Value<bool> isSettled,
      Value<int?> transactionId,
      Value<DateTime> updatedAt,
    });
typedef $$PeerDebtsTableUpdateCompanionBuilder =
    PeerDebtsCompanion Function({
      Value<int> id,
      Value<int> walletId,
      Value<String> uuid,
      Value<String> personName,
      Value<PeerDebtType> type,
      Value<double> amount,
      Value<String?> note,
      Value<DateTime> date,
      Value<bool> isSettled,
      Value<int?> transactionId,
      Value<DateTime> updatedAt,
    });

class $$PeerDebtsTableFilterComposer
    extends Composer<_$AppDatabase, $PeerDebtsTable> {
  $$PeerDebtsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get walletId => $composableBuilder(
    column: $table.walletId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get uuid => $composableBuilder(
    column: $table.uuid,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get personName => $composableBuilder(
    column: $table.personName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<PeerDebtType, PeerDebtType, int> get type =>
      $composableBuilder(
        column: $table.type,
        builder: (column) => ColumnWithTypeConverterFilters(column),
      );

  ColumnWithTypeConverterFilters<double, double, int> get amount =>
      $composableBuilder(
        column: $table.amount,
        builder: (column) => ColumnWithTypeConverterFilters(column),
      );

  ColumnFilters<String> get note => $composableBuilder(
    column: $table.note,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get date => $composableBuilder(
    column: $table.date,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isSettled => $composableBuilder(
    column: $table.isSettled,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get transactionId => $composableBuilder(
    column: $table.transactionId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$PeerDebtsTableOrderingComposer
    extends Composer<_$AppDatabase, $PeerDebtsTable> {
  $$PeerDebtsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get walletId => $composableBuilder(
    column: $table.walletId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get uuid => $composableBuilder(
    column: $table.uuid,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get personName => $composableBuilder(
    column: $table.personName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get type => $composableBuilder(
    column: $table.type,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get amount => $composableBuilder(
    column: $table.amount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get note => $composableBuilder(
    column: $table.note,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get date => $composableBuilder(
    column: $table.date,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isSettled => $composableBuilder(
    column: $table.isSettled,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get transactionId => $composableBuilder(
    column: $table.transactionId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$PeerDebtsTableAnnotationComposer
    extends Composer<_$AppDatabase, $PeerDebtsTable> {
  $$PeerDebtsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get walletId =>
      $composableBuilder(column: $table.walletId, builder: (column) => column);

  GeneratedColumn<String> get uuid =>
      $composableBuilder(column: $table.uuid, builder: (column) => column);

  GeneratedColumn<String> get personName => $composableBuilder(
    column: $table.personName,
    builder: (column) => column,
  );

  GeneratedColumnWithTypeConverter<PeerDebtType, int> get type =>
      $composableBuilder(column: $table.type, builder: (column) => column);

  GeneratedColumnWithTypeConverter<double, int> get amount =>
      $composableBuilder(column: $table.amount, builder: (column) => column);

  GeneratedColumn<String> get note =>
      $composableBuilder(column: $table.note, builder: (column) => column);

  GeneratedColumn<DateTime> get date =>
      $composableBuilder(column: $table.date, builder: (column) => column);

  GeneratedColumn<bool> get isSettled =>
      $composableBuilder(column: $table.isSettled, builder: (column) => column);

  GeneratedColumn<int> get transactionId => $composableBuilder(
    column: $table.transactionId,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$PeerDebtsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $PeerDebtsTable,
          PeerDebtDb,
          $$PeerDebtsTableFilterComposer,
          $$PeerDebtsTableOrderingComposer,
          $$PeerDebtsTableAnnotationComposer,
          $$PeerDebtsTableCreateCompanionBuilder,
          $$PeerDebtsTableUpdateCompanionBuilder,
          (
            PeerDebtDb,
            BaseReferences<_$AppDatabase, $PeerDebtsTable, PeerDebtDb>,
          ),
          PeerDebtDb,
          PrefetchHooks Function()
        > {
  $$PeerDebtsTableTableManager(_$AppDatabase db, $PeerDebtsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$PeerDebtsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$PeerDebtsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$PeerDebtsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> walletId = const Value.absent(),
                Value<String> uuid = const Value.absent(),
                Value<String> personName = const Value.absent(),
                Value<PeerDebtType> type = const Value.absent(),
                Value<double> amount = const Value.absent(),
                Value<String?> note = const Value.absent(),
                Value<DateTime> date = const Value.absent(),
                Value<bool> isSettled = const Value.absent(),
                Value<int?> transactionId = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
              }) => PeerDebtsCompanion(
                id: id,
                walletId: walletId,
                uuid: uuid,
                personName: personName,
                type: type,
                amount: amount,
                note: note,
                date: date,
                isSettled: isSettled,
                transactionId: transactionId,
                updatedAt: updatedAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int walletId,
                Value<String> uuid = const Value.absent(),
                required String personName,
                required PeerDebtType type,
                required double amount,
                Value<String?> note = const Value.absent(),
                required DateTime date,
                Value<bool> isSettled = const Value.absent(),
                Value<int?> transactionId = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
              }) => PeerDebtsCompanion.insert(
                id: id,
                walletId: walletId,
                uuid: uuid,
                personName: personName,
                type: type,
                amount: amount,
                note: note,
                date: date,
                isSettled: isSettled,
                transactionId: transactionId,
                updatedAt: updatedAt,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$PeerDebtsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $PeerDebtsTable,
      PeerDebtDb,
      $$PeerDebtsTableFilterComposer,
      $$PeerDebtsTableOrderingComposer,
      $$PeerDebtsTableAnnotationComposer,
      $$PeerDebtsTableCreateCompanionBuilder,
      $$PeerDebtsTableUpdateCompanionBuilder,
      (PeerDebtDb, BaseReferences<_$AppDatabase, $PeerDebtsTable, PeerDebtDb>),
      PeerDebtDb,
      PrefetchHooks Function()
    >;
typedef $$WalletAllowancesTableCreateCompanionBuilder =
    WalletAllowancesCompanion Function({
      Value<int> id,
      required int walletId,
      required int memberId,
      required double amount,
      required WalletAllowanceFrequency frequency,
      required DateTime startDate,
      Value<DateTime?> endDate,
      Value<bool> isActive,
      Value<int?> createdByAccountId,
      Value<int?> updatedByAccountId,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
    });
typedef $$WalletAllowancesTableUpdateCompanionBuilder =
    WalletAllowancesCompanion Function({
      Value<int> id,
      Value<int> walletId,
      Value<int> memberId,
      Value<double> amount,
      Value<WalletAllowanceFrequency> frequency,
      Value<DateTime> startDate,
      Value<DateTime?> endDate,
      Value<bool> isActive,
      Value<int?> createdByAccountId,
      Value<int?> updatedByAccountId,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
    });

class $$WalletAllowancesTableFilterComposer
    extends Composer<_$AppDatabase, $WalletAllowancesTable> {
  $$WalletAllowancesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get walletId => $composableBuilder(
    column: $table.walletId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get memberId => $composableBuilder(
    column: $table.memberId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<double, double, int> get amount =>
      $composableBuilder(
        column: $table.amount,
        builder: (column) => ColumnWithTypeConverterFilters(column),
      );

  ColumnWithTypeConverterFilters<
    WalletAllowanceFrequency,
    WalletAllowanceFrequency,
    String
  >
  get frequency => $composableBuilder(
    column: $table.frequency,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  ColumnFilters<DateTime> get startDate => $composableBuilder(
    column: $table.startDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get endDate => $composableBuilder(
    column: $table.endDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isActive => $composableBuilder(
    column: $table.isActive,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get createdByAccountId => $composableBuilder(
    column: $table.createdByAccountId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get updatedByAccountId => $composableBuilder(
    column: $table.updatedByAccountId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$WalletAllowancesTableOrderingComposer
    extends Composer<_$AppDatabase, $WalletAllowancesTable> {
  $$WalletAllowancesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get walletId => $composableBuilder(
    column: $table.walletId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get memberId => $composableBuilder(
    column: $table.memberId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get amount => $composableBuilder(
    column: $table.amount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get frequency => $composableBuilder(
    column: $table.frequency,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get startDate => $composableBuilder(
    column: $table.startDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get endDate => $composableBuilder(
    column: $table.endDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isActive => $composableBuilder(
    column: $table.isActive,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get createdByAccountId => $composableBuilder(
    column: $table.createdByAccountId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get updatedByAccountId => $composableBuilder(
    column: $table.updatedByAccountId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$WalletAllowancesTableAnnotationComposer
    extends Composer<_$AppDatabase, $WalletAllowancesTable> {
  $$WalletAllowancesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get walletId =>
      $composableBuilder(column: $table.walletId, builder: (column) => column);

  GeneratedColumn<int> get memberId =>
      $composableBuilder(column: $table.memberId, builder: (column) => column);

  GeneratedColumnWithTypeConverter<double, int> get amount =>
      $composableBuilder(column: $table.amount, builder: (column) => column);

  GeneratedColumnWithTypeConverter<WalletAllowanceFrequency, String>
  get frequency =>
      $composableBuilder(column: $table.frequency, builder: (column) => column);

  GeneratedColumn<DateTime> get startDate =>
      $composableBuilder(column: $table.startDate, builder: (column) => column);

  GeneratedColumn<DateTime> get endDate =>
      $composableBuilder(column: $table.endDate, builder: (column) => column);

  GeneratedColumn<bool> get isActive =>
      $composableBuilder(column: $table.isActive, builder: (column) => column);

  GeneratedColumn<int> get createdByAccountId => $composableBuilder(
    column: $table.createdByAccountId,
    builder: (column) => column,
  );

  GeneratedColumn<int> get updatedByAccountId => $composableBuilder(
    column: $table.updatedByAccountId,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$WalletAllowancesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $WalletAllowancesTable,
          WalletAllowance,
          $$WalletAllowancesTableFilterComposer,
          $$WalletAllowancesTableOrderingComposer,
          $$WalletAllowancesTableAnnotationComposer,
          $$WalletAllowancesTableCreateCompanionBuilder,
          $$WalletAllowancesTableUpdateCompanionBuilder,
          (
            WalletAllowance,
            BaseReferences<
              _$AppDatabase,
              $WalletAllowancesTable,
              WalletAllowance
            >,
          ),
          WalletAllowance,
          PrefetchHooks Function()
        > {
  $$WalletAllowancesTableTableManager(
    _$AppDatabase db,
    $WalletAllowancesTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$WalletAllowancesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$WalletAllowancesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$WalletAllowancesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> walletId = const Value.absent(),
                Value<int> memberId = const Value.absent(),
                Value<double> amount = const Value.absent(),
                Value<WalletAllowanceFrequency> frequency =
                    const Value.absent(),
                Value<DateTime> startDate = const Value.absent(),
                Value<DateTime?> endDate = const Value.absent(),
                Value<bool> isActive = const Value.absent(),
                Value<int?> createdByAccountId = const Value.absent(),
                Value<int?> updatedByAccountId = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
              }) => WalletAllowancesCompanion(
                id: id,
                walletId: walletId,
                memberId: memberId,
                amount: amount,
                frequency: frequency,
                startDate: startDate,
                endDate: endDate,
                isActive: isActive,
                createdByAccountId: createdByAccountId,
                updatedByAccountId: updatedByAccountId,
                createdAt: createdAt,
                updatedAt: updatedAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int walletId,
                required int memberId,
                required double amount,
                required WalletAllowanceFrequency frequency,
                required DateTime startDate,
                Value<DateTime?> endDate = const Value.absent(),
                Value<bool> isActive = const Value.absent(),
                Value<int?> createdByAccountId = const Value.absent(),
                Value<int?> updatedByAccountId = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
              }) => WalletAllowancesCompanion.insert(
                id: id,
                walletId: walletId,
                memberId: memberId,
                amount: amount,
                frequency: frequency,
                startDate: startDate,
                endDate: endDate,
                isActive: isActive,
                createdByAccountId: createdByAccountId,
                updatedByAccountId: updatedByAccountId,
                createdAt: createdAt,
                updatedAt: updatedAt,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$WalletAllowancesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $WalletAllowancesTable,
      WalletAllowance,
      $$WalletAllowancesTableFilterComposer,
      $$WalletAllowancesTableOrderingComposer,
      $$WalletAllowancesTableAnnotationComposer,
      $$WalletAllowancesTableCreateCompanionBuilder,
      $$WalletAllowancesTableUpdateCompanionBuilder,
      (
        WalletAllowance,
        BaseReferences<_$AppDatabase, $WalletAllowancesTable, WalletAllowance>,
      ),
      WalletAllowance,
      PrefetchHooks Function()
    >;
typedef $$WalletAllowancePaymentsTableCreateCompanionBuilder =
    WalletAllowancePaymentsCompanion Function({
      Value<int> id,
      required int allowanceId,
      required int memberId,
      required double amount,
      Value<DateTime> paidDate,
      Value<String?> notes,
    });
typedef $$WalletAllowancePaymentsTableUpdateCompanionBuilder =
    WalletAllowancePaymentsCompanion Function({
      Value<int> id,
      Value<int> allowanceId,
      Value<int> memberId,
      Value<double> amount,
      Value<DateTime> paidDate,
      Value<String?> notes,
    });

class $$WalletAllowancePaymentsTableFilterComposer
    extends Composer<_$AppDatabase, $WalletAllowancePaymentsTable> {
  $$WalletAllowancePaymentsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get allowanceId => $composableBuilder(
    column: $table.allowanceId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get memberId => $composableBuilder(
    column: $table.memberId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<double, double, int> get amount =>
      $composableBuilder(
        column: $table.amount,
        builder: (column) => ColumnWithTypeConverterFilters(column),
      );

  ColumnFilters<DateTime> get paidDate => $composableBuilder(
    column: $table.paidDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnFilters(column),
  );
}

class $$WalletAllowancePaymentsTableOrderingComposer
    extends Composer<_$AppDatabase, $WalletAllowancePaymentsTable> {
  $$WalletAllowancePaymentsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get allowanceId => $composableBuilder(
    column: $table.allowanceId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get memberId => $composableBuilder(
    column: $table.memberId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get amount => $composableBuilder(
    column: $table.amount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get paidDate => $composableBuilder(
    column: $table.paidDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$WalletAllowancePaymentsTableAnnotationComposer
    extends Composer<_$AppDatabase, $WalletAllowancePaymentsTable> {
  $$WalletAllowancePaymentsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get allowanceId => $composableBuilder(
    column: $table.allowanceId,
    builder: (column) => column,
  );

  GeneratedColumn<int> get memberId =>
      $composableBuilder(column: $table.memberId, builder: (column) => column);

  GeneratedColumnWithTypeConverter<double, int> get amount =>
      $composableBuilder(column: $table.amount, builder: (column) => column);

  GeneratedColumn<DateTime> get paidDate =>
      $composableBuilder(column: $table.paidDate, builder: (column) => column);

  GeneratedColumn<String> get notes =>
      $composableBuilder(column: $table.notes, builder: (column) => column);
}

class $$WalletAllowancePaymentsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $WalletAllowancePaymentsTable,
          WalletAllowancePayment,
          $$WalletAllowancePaymentsTableFilterComposer,
          $$WalletAllowancePaymentsTableOrderingComposer,
          $$WalletAllowancePaymentsTableAnnotationComposer,
          $$WalletAllowancePaymentsTableCreateCompanionBuilder,
          $$WalletAllowancePaymentsTableUpdateCompanionBuilder,
          (
            WalletAllowancePayment,
            BaseReferences<
              _$AppDatabase,
              $WalletAllowancePaymentsTable,
              WalletAllowancePayment
            >,
          ),
          WalletAllowancePayment,
          PrefetchHooks Function()
        > {
  $$WalletAllowancePaymentsTableTableManager(
    _$AppDatabase db,
    $WalletAllowancePaymentsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$WalletAllowancePaymentsTableFilterComposer(
                $db: db,
                $table: table,
              ),
          createOrderingComposer: () =>
              $$WalletAllowancePaymentsTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer: () =>
              $$WalletAllowancePaymentsTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> allowanceId = const Value.absent(),
                Value<int> memberId = const Value.absent(),
                Value<double> amount = const Value.absent(),
                Value<DateTime> paidDate = const Value.absent(),
                Value<String?> notes = const Value.absent(),
              }) => WalletAllowancePaymentsCompanion(
                id: id,
                allowanceId: allowanceId,
                memberId: memberId,
                amount: amount,
                paidDate: paidDate,
                notes: notes,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int allowanceId,
                required int memberId,
                required double amount,
                Value<DateTime> paidDate = const Value.absent(),
                Value<String?> notes = const Value.absent(),
              }) => WalletAllowancePaymentsCompanion.insert(
                id: id,
                allowanceId: allowanceId,
                memberId: memberId,
                amount: amount,
                paidDate: paidDate,
                notes: notes,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$WalletAllowancePaymentsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $WalletAllowancePaymentsTable,
      WalletAllowancePayment,
      $$WalletAllowancePaymentsTableFilterComposer,
      $$WalletAllowancePaymentsTableOrderingComposer,
      $$WalletAllowancePaymentsTableAnnotationComposer,
      $$WalletAllowancePaymentsTableCreateCompanionBuilder,
      $$WalletAllowancePaymentsTableUpdateCompanionBuilder,
      (
        WalletAllowancePayment,
        BaseReferences<
          _$AppDatabase,
          $WalletAllowancePaymentsTable,
          WalletAllowancePayment
        >,
      ),
      WalletAllowancePayment,
      PrefetchHooks Function()
    >;
typedef $$WalletSettlementsTableCreateCompanionBuilder =
    WalletSettlementsCompanion Function({
      Value<int> id,
      required int walletId,
      Value<String> uuid,
      required int payerMemberId,
      required int receiverMemberId,
      required double amount,
      Value<DateTime> settlementDate,
      Value<String?> notes,
      Value<int?> createdByAccountId,
      Value<DateTime> createdAt,
    });
typedef $$WalletSettlementsTableUpdateCompanionBuilder =
    WalletSettlementsCompanion Function({
      Value<int> id,
      Value<int> walletId,
      Value<String> uuid,
      Value<int> payerMemberId,
      Value<int> receiverMemberId,
      Value<double> amount,
      Value<DateTime> settlementDate,
      Value<String?> notes,
      Value<int?> createdByAccountId,
      Value<DateTime> createdAt,
    });

class $$WalletSettlementsTableFilterComposer
    extends Composer<_$AppDatabase, $WalletSettlementsTable> {
  $$WalletSettlementsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get walletId => $composableBuilder(
    column: $table.walletId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get uuid => $composableBuilder(
    column: $table.uuid,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get payerMemberId => $composableBuilder(
    column: $table.payerMemberId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get receiverMemberId => $composableBuilder(
    column: $table.receiverMemberId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<double, double, int> get amount =>
      $composableBuilder(
        column: $table.amount,
        builder: (column) => ColumnWithTypeConverterFilters(column),
      );

  ColumnFilters<DateTime> get settlementDate => $composableBuilder(
    column: $table.settlementDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get createdByAccountId => $composableBuilder(
    column: $table.createdByAccountId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$WalletSettlementsTableOrderingComposer
    extends Composer<_$AppDatabase, $WalletSettlementsTable> {
  $$WalletSettlementsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get walletId => $composableBuilder(
    column: $table.walletId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get uuid => $composableBuilder(
    column: $table.uuid,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get payerMemberId => $composableBuilder(
    column: $table.payerMemberId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get receiverMemberId => $composableBuilder(
    column: $table.receiverMemberId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get amount => $composableBuilder(
    column: $table.amount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get settlementDate => $composableBuilder(
    column: $table.settlementDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get createdByAccountId => $composableBuilder(
    column: $table.createdByAccountId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$WalletSettlementsTableAnnotationComposer
    extends Composer<_$AppDatabase, $WalletSettlementsTable> {
  $$WalletSettlementsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get walletId =>
      $composableBuilder(column: $table.walletId, builder: (column) => column);

  GeneratedColumn<String> get uuid =>
      $composableBuilder(column: $table.uuid, builder: (column) => column);

  GeneratedColumn<int> get payerMemberId => $composableBuilder(
    column: $table.payerMemberId,
    builder: (column) => column,
  );

  GeneratedColumn<int> get receiverMemberId => $composableBuilder(
    column: $table.receiverMemberId,
    builder: (column) => column,
  );

  GeneratedColumnWithTypeConverter<double, int> get amount =>
      $composableBuilder(column: $table.amount, builder: (column) => column);

  GeneratedColumn<DateTime> get settlementDate => $composableBuilder(
    column: $table.settlementDate,
    builder: (column) => column,
  );

  GeneratedColumn<String> get notes =>
      $composableBuilder(column: $table.notes, builder: (column) => column);

  GeneratedColumn<int> get createdByAccountId => $composableBuilder(
    column: $table.createdByAccountId,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);
}

class $$WalletSettlementsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $WalletSettlementsTable,
          WalletSettlement,
          $$WalletSettlementsTableFilterComposer,
          $$WalletSettlementsTableOrderingComposer,
          $$WalletSettlementsTableAnnotationComposer,
          $$WalletSettlementsTableCreateCompanionBuilder,
          $$WalletSettlementsTableUpdateCompanionBuilder,
          (
            WalletSettlement,
            BaseReferences<
              _$AppDatabase,
              $WalletSettlementsTable,
              WalletSettlement
            >,
          ),
          WalletSettlement,
          PrefetchHooks Function()
        > {
  $$WalletSettlementsTableTableManager(
    _$AppDatabase db,
    $WalletSettlementsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$WalletSettlementsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$WalletSettlementsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$WalletSettlementsTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> walletId = const Value.absent(),
                Value<String> uuid = const Value.absent(),
                Value<int> payerMemberId = const Value.absent(),
                Value<int> receiverMemberId = const Value.absent(),
                Value<double> amount = const Value.absent(),
                Value<DateTime> settlementDate = const Value.absent(),
                Value<String?> notes = const Value.absent(),
                Value<int?> createdByAccountId = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
              }) => WalletSettlementsCompanion(
                id: id,
                walletId: walletId,
                uuid: uuid,
                payerMemberId: payerMemberId,
                receiverMemberId: receiverMemberId,
                amount: amount,
                settlementDate: settlementDate,
                notes: notes,
                createdByAccountId: createdByAccountId,
                createdAt: createdAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int walletId,
                Value<String> uuid = const Value.absent(),
                required int payerMemberId,
                required int receiverMemberId,
                required double amount,
                Value<DateTime> settlementDate = const Value.absent(),
                Value<String?> notes = const Value.absent(),
                Value<int?> createdByAccountId = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
              }) => WalletSettlementsCompanion.insert(
                id: id,
                walletId: walletId,
                uuid: uuid,
                payerMemberId: payerMemberId,
                receiverMemberId: receiverMemberId,
                amount: amount,
                settlementDate: settlementDate,
                notes: notes,
                createdByAccountId: createdByAccountId,
                createdAt: createdAt,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$WalletSettlementsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $WalletSettlementsTable,
      WalletSettlement,
      $$WalletSettlementsTableFilterComposer,
      $$WalletSettlementsTableOrderingComposer,
      $$WalletSettlementsTableAnnotationComposer,
      $$WalletSettlementsTableCreateCompanionBuilder,
      $$WalletSettlementsTableUpdateCompanionBuilder,
      (
        WalletSettlement,
        BaseReferences<
          _$AppDatabase,
          $WalletSettlementsTable,
          WalletSettlement
        >,
      ),
      WalletSettlement,
      PrefetchHooks Function()
    >;
typedef $$WalletsTableCreateCompanionBuilder =
    WalletsCompanion Function({
      Value<int> id,
      Value<String> uuid,
      required String name,
      Value<String> type,
      Value<int?> createdByAccountId,
      Value<DateTime> createdAt,
    });
typedef $$WalletsTableUpdateCompanionBuilder =
    WalletsCompanion Function({
      Value<int> id,
      Value<String> uuid,
      Value<String> name,
      Value<String> type,
      Value<int?> createdByAccountId,
      Value<DateTime> createdAt,
    });

class $$WalletsTableFilterComposer
    extends Composer<_$AppDatabase, $WalletsTable> {
  $$WalletsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get uuid => $composableBuilder(
    column: $table.uuid,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get type => $composableBuilder(
    column: $table.type,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get createdByAccountId => $composableBuilder(
    column: $table.createdByAccountId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$WalletsTableOrderingComposer
    extends Composer<_$AppDatabase, $WalletsTable> {
  $$WalletsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get uuid => $composableBuilder(
    column: $table.uuid,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get type => $composableBuilder(
    column: $table.type,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get createdByAccountId => $composableBuilder(
    column: $table.createdByAccountId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$WalletsTableAnnotationComposer
    extends Composer<_$AppDatabase, $WalletsTable> {
  $$WalletsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get uuid =>
      $composableBuilder(column: $table.uuid, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get type =>
      $composableBuilder(column: $table.type, builder: (column) => column);

  GeneratedColumn<int> get createdByAccountId => $composableBuilder(
    column: $table.createdByAccountId,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);
}

class $$WalletsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $WalletsTable,
          Wallet,
          $$WalletsTableFilterComposer,
          $$WalletsTableOrderingComposer,
          $$WalletsTableAnnotationComposer,
          $$WalletsTableCreateCompanionBuilder,
          $$WalletsTableUpdateCompanionBuilder,
          (Wallet, BaseReferences<_$AppDatabase, $WalletsTable, Wallet>),
          Wallet,
          PrefetchHooks Function()
        > {
  $$WalletsTableTableManager(_$AppDatabase db, $WalletsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$WalletsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$WalletsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$WalletsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> uuid = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String> type = const Value.absent(),
                Value<int?> createdByAccountId = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
              }) => WalletsCompanion(
                id: id,
                uuid: uuid,
                name: name,
                type: type,
                createdByAccountId: createdByAccountId,
                createdAt: createdAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> uuid = const Value.absent(),
                required String name,
                Value<String> type = const Value.absent(),
                Value<int?> createdByAccountId = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
              }) => WalletsCompanion.insert(
                id: id,
                uuid: uuid,
                name: name,
                type: type,
                createdByAccountId: createdByAccountId,
                createdAt: createdAt,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$WalletsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $WalletsTable,
      Wallet,
      $$WalletsTableFilterComposer,
      $$WalletsTableOrderingComposer,
      $$WalletsTableAnnotationComposer,
      $$WalletsTableCreateCompanionBuilder,
      $$WalletsTableUpdateCompanionBuilder,
      (Wallet, BaseReferences<_$AppDatabase, $WalletsTable, Wallet>),
      Wallet,
      PrefetchHooks Function()
    >;
typedef $$WalletInvitationsTableCreateCompanionBuilder =
    WalletInvitationsCompanion Function({
      Value<int> id,
      Value<String> token,
      required int walletId,
      Value<int?> invitedByAccountId,
      required int accountId,
      required WalletInvitationStatus status,
      required WalletRole role,
      Value<DateTime> createdAt,
      Value<DateTime?> expiresAt,
      Value<DateTime?> respondedAt,
    });
typedef $$WalletInvitationsTableUpdateCompanionBuilder =
    WalletInvitationsCompanion Function({
      Value<int> id,
      Value<String> token,
      Value<int> walletId,
      Value<int?> invitedByAccountId,
      Value<int> accountId,
      Value<WalletInvitationStatus> status,
      Value<WalletRole> role,
      Value<DateTime> createdAt,
      Value<DateTime?> expiresAt,
      Value<DateTime?> respondedAt,
    });

class $$WalletInvitationsTableFilterComposer
    extends Composer<_$AppDatabase, $WalletInvitationsTable> {
  $$WalletInvitationsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get token => $composableBuilder(
    column: $table.token,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get walletId => $composableBuilder(
    column: $table.walletId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get invitedByAccountId => $composableBuilder(
    column: $table.invitedByAccountId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get accountId => $composableBuilder(
    column: $table.accountId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<
    WalletInvitationStatus,
    WalletInvitationStatus,
    String
  >
  get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  ColumnWithTypeConverterFilters<WalletRole, WalletRole, String> get role =>
      $composableBuilder(
        column: $table.role,
        builder: (column) => ColumnWithTypeConverterFilters(column),
      );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get expiresAt => $composableBuilder(
    column: $table.expiresAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get respondedAt => $composableBuilder(
    column: $table.respondedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$WalletInvitationsTableOrderingComposer
    extends Composer<_$AppDatabase, $WalletInvitationsTable> {
  $$WalletInvitationsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get token => $composableBuilder(
    column: $table.token,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get walletId => $composableBuilder(
    column: $table.walletId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get invitedByAccountId => $composableBuilder(
    column: $table.invitedByAccountId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get accountId => $composableBuilder(
    column: $table.accountId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get role => $composableBuilder(
    column: $table.role,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get expiresAt => $composableBuilder(
    column: $table.expiresAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get respondedAt => $composableBuilder(
    column: $table.respondedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$WalletInvitationsTableAnnotationComposer
    extends Composer<_$AppDatabase, $WalletInvitationsTable> {
  $$WalletInvitationsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get token =>
      $composableBuilder(column: $table.token, builder: (column) => column);

  GeneratedColumn<int> get walletId =>
      $composableBuilder(column: $table.walletId, builder: (column) => column);

  GeneratedColumn<int> get invitedByAccountId => $composableBuilder(
    column: $table.invitedByAccountId,
    builder: (column) => column,
  );

  GeneratedColumn<int> get accountId =>
      $composableBuilder(column: $table.accountId, builder: (column) => column);

  GeneratedColumnWithTypeConverter<WalletInvitationStatus, String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumnWithTypeConverter<WalletRole, String> get role =>
      $composableBuilder(column: $table.role, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get expiresAt =>
      $composableBuilder(column: $table.expiresAt, builder: (column) => column);

  GeneratedColumn<DateTime> get respondedAt => $composableBuilder(
    column: $table.respondedAt,
    builder: (column) => column,
  );
}

class $$WalletInvitationsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $WalletInvitationsTable,
          WalletInvitation,
          $$WalletInvitationsTableFilterComposer,
          $$WalletInvitationsTableOrderingComposer,
          $$WalletInvitationsTableAnnotationComposer,
          $$WalletInvitationsTableCreateCompanionBuilder,
          $$WalletInvitationsTableUpdateCompanionBuilder,
          (
            WalletInvitation,
            BaseReferences<
              _$AppDatabase,
              $WalletInvitationsTable,
              WalletInvitation
            >,
          ),
          WalletInvitation,
          PrefetchHooks Function()
        > {
  $$WalletInvitationsTableTableManager(
    _$AppDatabase db,
    $WalletInvitationsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$WalletInvitationsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$WalletInvitationsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$WalletInvitationsTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> token = const Value.absent(),
                Value<int> walletId = const Value.absent(),
                Value<int?> invitedByAccountId = const Value.absent(),
                Value<int> accountId = const Value.absent(),
                Value<WalletInvitationStatus> status = const Value.absent(),
                Value<WalletRole> role = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime?> expiresAt = const Value.absent(),
                Value<DateTime?> respondedAt = const Value.absent(),
              }) => WalletInvitationsCompanion(
                id: id,
                token: token,
                walletId: walletId,
                invitedByAccountId: invitedByAccountId,
                accountId: accountId,
                status: status,
                role: role,
                createdAt: createdAt,
                expiresAt: expiresAt,
                respondedAt: respondedAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> token = const Value.absent(),
                required int walletId,
                Value<int?> invitedByAccountId = const Value.absent(),
                required int accountId,
                required WalletInvitationStatus status,
                required WalletRole role,
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime?> expiresAt = const Value.absent(),
                Value<DateTime?> respondedAt = const Value.absent(),
              }) => WalletInvitationsCompanion.insert(
                id: id,
                token: token,
                walletId: walletId,
                invitedByAccountId: invitedByAccountId,
                accountId: accountId,
                status: status,
                role: role,
                createdAt: createdAt,
                expiresAt: expiresAt,
                respondedAt: respondedAt,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$WalletInvitationsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $WalletInvitationsTable,
      WalletInvitation,
      $$WalletInvitationsTableFilterComposer,
      $$WalletInvitationsTableOrderingComposer,
      $$WalletInvitationsTableAnnotationComposer,
      $$WalletInvitationsTableCreateCompanionBuilder,
      $$WalletInvitationsTableUpdateCompanionBuilder,
      (
        WalletInvitation,
        BaseReferences<
          _$AppDatabase,
          $WalletInvitationsTable,
          WalletInvitation
        >,
      ),
      WalletInvitation,
      PrefetchHooks Function()
    >;
typedef $$WalletMembersTableCreateCompanionBuilder =
    WalletMembersCompanion Function({
      Value<int> id,
      required int walletId,
      required int accountId,
      required WalletRole role,
      Value<DateTime> joinedAt,
      Value<bool> isActive,
    });
typedef $$WalletMembersTableUpdateCompanionBuilder =
    WalletMembersCompanion Function({
      Value<int> id,
      Value<int> walletId,
      Value<int> accountId,
      Value<WalletRole> role,
      Value<DateTime> joinedAt,
      Value<bool> isActive,
    });

class $$WalletMembersTableFilterComposer
    extends Composer<_$AppDatabase, $WalletMembersTable> {
  $$WalletMembersTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get walletId => $composableBuilder(
    column: $table.walletId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get accountId => $composableBuilder(
    column: $table.accountId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<WalletRole, WalletRole, String> get role =>
      $composableBuilder(
        column: $table.role,
        builder: (column) => ColumnWithTypeConverterFilters(column),
      );

  ColumnFilters<DateTime> get joinedAt => $composableBuilder(
    column: $table.joinedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isActive => $composableBuilder(
    column: $table.isActive,
    builder: (column) => ColumnFilters(column),
  );
}

class $$WalletMembersTableOrderingComposer
    extends Composer<_$AppDatabase, $WalletMembersTable> {
  $$WalletMembersTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get walletId => $composableBuilder(
    column: $table.walletId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get accountId => $composableBuilder(
    column: $table.accountId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get role => $composableBuilder(
    column: $table.role,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get joinedAt => $composableBuilder(
    column: $table.joinedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isActive => $composableBuilder(
    column: $table.isActive,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$WalletMembersTableAnnotationComposer
    extends Composer<_$AppDatabase, $WalletMembersTable> {
  $$WalletMembersTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get walletId =>
      $composableBuilder(column: $table.walletId, builder: (column) => column);

  GeneratedColumn<int> get accountId =>
      $composableBuilder(column: $table.accountId, builder: (column) => column);

  GeneratedColumnWithTypeConverter<WalletRole, String> get role =>
      $composableBuilder(column: $table.role, builder: (column) => column);

  GeneratedColumn<DateTime> get joinedAt =>
      $composableBuilder(column: $table.joinedAt, builder: (column) => column);

  GeneratedColumn<bool> get isActive =>
      $composableBuilder(column: $table.isActive, builder: (column) => column);
}

class $$WalletMembersTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $WalletMembersTable,
          WalletMember,
          $$WalletMembersTableFilterComposer,
          $$WalletMembersTableOrderingComposer,
          $$WalletMembersTableAnnotationComposer,
          $$WalletMembersTableCreateCompanionBuilder,
          $$WalletMembersTableUpdateCompanionBuilder,
          (
            WalletMember,
            BaseReferences<_$AppDatabase, $WalletMembersTable, WalletMember>,
          ),
          WalletMember,
          PrefetchHooks Function()
        > {
  $$WalletMembersTableTableManager(_$AppDatabase db, $WalletMembersTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$WalletMembersTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$WalletMembersTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$WalletMembersTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> walletId = const Value.absent(),
                Value<int> accountId = const Value.absent(),
                Value<WalletRole> role = const Value.absent(),
                Value<DateTime> joinedAt = const Value.absent(),
                Value<bool> isActive = const Value.absent(),
              }) => WalletMembersCompanion(
                id: id,
                walletId: walletId,
                accountId: accountId,
                role: role,
                joinedAt: joinedAt,
                isActive: isActive,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int walletId,
                required int accountId,
                required WalletRole role,
                Value<DateTime> joinedAt = const Value.absent(),
                Value<bool> isActive = const Value.absent(),
              }) => WalletMembersCompanion.insert(
                id: id,
                walletId: walletId,
                accountId: accountId,
                role: role,
                joinedAt: joinedAt,
                isActive: isActive,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$WalletMembersTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $WalletMembersTable,
      WalletMember,
      $$WalletMembersTableFilterComposer,
      $$WalletMembersTableOrderingComposer,
      $$WalletMembersTableAnnotationComposer,
      $$WalletMembersTableCreateCompanionBuilder,
      $$WalletMembersTableUpdateCompanionBuilder,
      (
        WalletMember,
        BaseReferences<_$AppDatabase, $WalletMembersTable, WalletMember>,
      ),
      WalletMember,
      PrefetchHooks Function()
    >;
typedef $$WalletGoalsTableCreateCompanionBuilder =
    WalletGoalsCompanion Function({
      Value<int> id,
      required int walletId,
      required String name,
      required double targetAmount,
      Value<double> currentAmount,
      Value<DateTime?> targetDate,
      Value<int?> createdByAccountId,
      Value<int?> updatedByAccountId,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
    });
typedef $$WalletGoalsTableUpdateCompanionBuilder =
    WalletGoalsCompanion Function({
      Value<int> id,
      Value<int> walletId,
      Value<String> name,
      Value<double> targetAmount,
      Value<double> currentAmount,
      Value<DateTime?> targetDate,
      Value<int?> createdByAccountId,
      Value<int?> updatedByAccountId,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
    });

class $$WalletGoalsTableFilterComposer
    extends Composer<_$AppDatabase, $WalletGoalsTable> {
  $$WalletGoalsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get walletId => $composableBuilder(
    column: $table.walletId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<double, double, int> get targetAmount =>
      $composableBuilder(
        column: $table.targetAmount,
        builder: (column) => ColumnWithTypeConverterFilters(column),
      );

  ColumnWithTypeConverterFilters<double, double, int> get currentAmount =>
      $composableBuilder(
        column: $table.currentAmount,
        builder: (column) => ColumnWithTypeConverterFilters(column),
      );

  ColumnFilters<DateTime> get targetDate => $composableBuilder(
    column: $table.targetDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get createdByAccountId => $composableBuilder(
    column: $table.createdByAccountId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get updatedByAccountId => $composableBuilder(
    column: $table.updatedByAccountId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$WalletGoalsTableOrderingComposer
    extends Composer<_$AppDatabase, $WalletGoalsTable> {
  $$WalletGoalsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get walletId => $composableBuilder(
    column: $table.walletId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get targetAmount => $composableBuilder(
    column: $table.targetAmount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get currentAmount => $composableBuilder(
    column: $table.currentAmount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get targetDate => $composableBuilder(
    column: $table.targetDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get createdByAccountId => $composableBuilder(
    column: $table.createdByAccountId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get updatedByAccountId => $composableBuilder(
    column: $table.updatedByAccountId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$WalletGoalsTableAnnotationComposer
    extends Composer<_$AppDatabase, $WalletGoalsTable> {
  $$WalletGoalsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get walletId =>
      $composableBuilder(column: $table.walletId, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumnWithTypeConverter<double, int> get targetAmount =>
      $composableBuilder(
        column: $table.targetAmount,
        builder: (column) => column,
      );

  GeneratedColumnWithTypeConverter<double, int> get currentAmount =>
      $composableBuilder(
        column: $table.currentAmount,
        builder: (column) => column,
      );

  GeneratedColumn<DateTime> get targetDate => $composableBuilder(
    column: $table.targetDate,
    builder: (column) => column,
  );

  GeneratedColumn<int> get createdByAccountId => $composableBuilder(
    column: $table.createdByAccountId,
    builder: (column) => column,
  );

  GeneratedColumn<int> get updatedByAccountId => $composableBuilder(
    column: $table.updatedByAccountId,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$WalletGoalsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $WalletGoalsTable,
          WalletGoal,
          $$WalletGoalsTableFilterComposer,
          $$WalletGoalsTableOrderingComposer,
          $$WalletGoalsTableAnnotationComposer,
          $$WalletGoalsTableCreateCompanionBuilder,
          $$WalletGoalsTableUpdateCompanionBuilder,
          (
            WalletGoal,
            BaseReferences<_$AppDatabase, $WalletGoalsTable, WalletGoal>,
          ),
          WalletGoal,
          PrefetchHooks Function()
        > {
  $$WalletGoalsTableTableManager(_$AppDatabase db, $WalletGoalsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$WalletGoalsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$WalletGoalsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$WalletGoalsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> walletId = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<double> targetAmount = const Value.absent(),
                Value<double> currentAmount = const Value.absent(),
                Value<DateTime?> targetDate = const Value.absent(),
                Value<int?> createdByAccountId = const Value.absent(),
                Value<int?> updatedByAccountId = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
              }) => WalletGoalsCompanion(
                id: id,
                walletId: walletId,
                name: name,
                targetAmount: targetAmount,
                currentAmount: currentAmount,
                targetDate: targetDate,
                createdByAccountId: createdByAccountId,
                updatedByAccountId: updatedByAccountId,
                createdAt: createdAt,
                updatedAt: updatedAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int walletId,
                required String name,
                required double targetAmount,
                Value<double> currentAmount = const Value.absent(),
                Value<DateTime?> targetDate = const Value.absent(),
                Value<int?> createdByAccountId = const Value.absent(),
                Value<int?> updatedByAccountId = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
              }) => WalletGoalsCompanion.insert(
                id: id,
                walletId: walletId,
                name: name,
                targetAmount: targetAmount,
                currentAmount: currentAmount,
                targetDate: targetDate,
                createdByAccountId: createdByAccountId,
                updatedByAccountId: updatedByAccountId,
                createdAt: createdAt,
                updatedAt: updatedAt,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$WalletGoalsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $WalletGoalsTable,
      WalletGoal,
      $$WalletGoalsTableFilterComposer,
      $$WalletGoalsTableOrderingComposer,
      $$WalletGoalsTableAnnotationComposer,
      $$WalletGoalsTableCreateCompanionBuilder,
      $$WalletGoalsTableUpdateCompanionBuilder,
      (
        WalletGoal,
        BaseReferences<_$AppDatabase, $WalletGoalsTable, WalletGoal>,
      ),
      WalletGoal,
      PrefetchHooks Function()
    >;
typedef $$WalletGoalContributionsTableCreateCompanionBuilder =
    WalletGoalContributionsCompanion Function({
      Value<int> id,
      required int walletId,
      required int goalId,
      Value<int?> contributedByAccountId,
      required double amount,
      Value<DateTime> contributedAt,
    });
typedef $$WalletGoalContributionsTableUpdateCompanionBuilder =
    WalletGoalContributionsCompanion Function({
      Value<int> id,
      Value<int> walletId,
      Value<int> goalId,
      Value<int?> contributedByAccountId,
      Value<double> amount,
      Value<DateTime> contributedAt,
    });

class $$WalletGoalContributionsTableFilterComposer
    extends Composer<_$AppDatabase, $WalletGoalContributionsTable> {
  $$WalletGoalContributionsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get walletId => $composableBuilder(
    column: $table.walletId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get goalId => $composableBuilder(
    column: $table.goalId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get contributedByAccountId => $composableBuilder(
    column: $table.contributedByAccountId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<double, double, int> get amount =>
      $composableBuilder(
        column: $table.amount,
        builder: (column) => ColumnWithTypeConverterFilters(column),
      );

  ColumnFilters<DateTime> get contributedAt => $composableBuilder(
    column: $table.contributedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$WalletGoalContributionsTableOrderingComposer
    extends Composer<_$AppDatabase, $WalletGoalContributionsTable> {
  $$WalletGoalContributionsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get walletId => $composableBuilder(
    column: $table.walletId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get goalId => $composableBuilder(
    column: $table.goalId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get contributedByAccountId => $composableBuilder(
    column: $table.contributedByAccountId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get amount => $composableBuilder(
    column: $table.amount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get contributedAt => $composableBuilder(
    column: $table.contributedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$WalletGoalContributionsTableAnnotationComposer
    extends Composer<_$AppDatabase, $WalletGoalContributionsTable> {
  $$WalletGoalContributionsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get walletId =>
      $composableBuilder(column: $table.walletId, builder: (column) => column);

  GeneratedColumn<int> get goalId =>
      $composableBuilder(column: $table.goalId, builder: (column) => column);

  GeneratedColumn<int> get contributedByAccountId => $composableBuilder(
    column: $table.contributedByAccountId,
    builder: (column) => column,
  );

  GeneratedColumnWithTypeConverter<double, int> get amount =>
      $composableBuilder(column: $table.amount, builder: (column) => column);

  GeneratedColumn<DateTime> get contributedAt => $composableBuilder(
    column: $table.contributedAt,
    builder: (column) => column,
  );
}

class $$WalletGoalContributionsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $WalletGoalContributionsTable,
          WalletGoalContribution,
          $$WalletGoalContributionsTableFilterComposer,
          $$WalletGoalContributionsTableOrderingComposer,
          $$WalletGoalContributionsTableAnnotationComposer,
          $$WalletGoalContributionsTableCreateCompanionBuilder,
          $$WalletGoalContributionsTableUpdateCompanionBuilder,
          (
            WalletGoalContribution,
            BaseReferences<
              _$AppDatabase,
              $WalletGoalContributionsTable,
              WalletGoalContribution
            >,
          ),
          WalletGoalContribution,
          PrefetchHooks Function()
        > {
  $$WalletGoalContributionsTableTableManager(
    _$AppDatabase db,
    $WalletGoalContributionsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$WalletGoalContributionsTableFilterComposer(
                $db: db,
                $table: table,
              ),
          createOrderingComposer: () =>
              $$WalletGoalContributionsTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer: () =>
              $$WalletGoalContributionsTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> walletId = const Value.absent(),
                Value<int> goalId = const Value.absent(),
                Value<int?> contributedByAccountId = const Value.absent(),
                Value<double> amount = const Value.absent(),
                Value<DateTime> contributedAt = const Value.absent(),
              }) => WalletGoalContributionsCompanion(
                id: id,
                walletId: walletId,
                goalId: goalId,
                contributedByAccountId: contributedByAccountId,
                amount: amount,
                contributedAt: contributedAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int walletId,
                required int goalId,
                Value<int?> contributedByAccountId = const Value.absent(),
                required double amount,
                Value<DateTime> contributedAt = const Value.absent(),
              }) => WalletGoalContributionsCompanion.insert(
                id: id,
                walletId: walletId,
                goalId: goalId,
                contributedByAccountId: contributedByAccountId,
                amount: amount,
                contributedAt: contributedAt,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$WalletGoalContributionsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $WalletGoalContributionsTable,
      WalletGoalContribution,
      $$WalletGoalContributionsTableFilterComposer,
      $$WalletGoalContributionsTableOrderingComposer,
      $$WalletGoalContributionsTableAnnotationComposer,
      $$WalletGoalContributionsTableCreateCompanionBuilder,
      $$WalletGoalContributionsTableUpdateCompanionBuilder,
      (
        WalletGoalContribution,
        BaseReferences<
          _$AppDatabase,
          $WalletGoalContributionsTable,
          WalletGoalContribution
        >,
      ),
      WalletGoalContribution,
      PrefetchHooks Function()
    >;
typedef $$WalletGoalSchedulesTableCreateCompanionBuilder =
    WalletGoalSchedulesCompanion Function({
      Value<int> id,
      required int walletGoalId,
      required int memberId,
      required double amount,
      required WalletGoalScheduleFrequency frequency,
      required DateTime startDate,
      required DateTime nextDueDate,
      Value<bool> isActive,
      Value<int?> createdByAccountId,
      Value<int?> updatedByAccountId,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
    });
typedef $$WalletGoalSchedulesTableUpdateCompanionBuilder =
    WalletGoalSchedulesCompanion Function({
      Value<int> id,
      Value<int> walletGoalId,
      Value<int> memberId,
      Value<double> amount,
      Value<WalletGoalScheduleFrequency> frequency,
      Value<DateTime> startDate,
      Value<DateTime> nextDueDate,
      Value<bool> isActive,
      Value<int?> createdByAccountId,
      Value<int?> updatedByAccountId,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
    });

class $$WalletGoalSchedulesTableFilterComposer
    extends Composer<_$AppDatabase, $WalletGoalSchedulesTable> {
  $$WalletGoalSchedulesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get walletGoalId => $composableBuilder(
    column: $table.walletGoalId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get memberId => $composableBuilder(
    column: $table.memberId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<double, double, int> get amount =>
      $composableBuilder(
        column: $table.amount,
        builder: (column) => ColumnWithTypeConverterFilters(column),
      );

  ColumnWithTypeConverterFilters<
    WalletGoalScheduleFrequency,
    WalletGoalScheduleFrequency,
    String
  >
  get frequency => $composableBuilder(
    column: $table.frequency,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  ColumnFilters<DateTime> get startDate => $composableBuilder(
    column: $table.startDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get nextDueDate => $composableBuilder(
    column: $table.nextDueDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isActive => $composableBuilder(
    column: $table.isActive,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get createdByAccountId => $composableBuilder(
    column: $table.createdByAccountId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get updatedByAccountId => $composableBuilder(
    column: $table.updatedByAccountId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$WalletGoalSchedulesTableOrderingComposer
    extends Composer<_$AppDatabase, $WalletGoalSchedulesTable> {
  $$WalletGoalSchedulesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get walletGoalId => $composableBuilder(
    column: $table.walletGoalId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get memberId => $composableBuilder(
    column: $table.memberId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get amount => $composableBuilder(
    column: $table.amount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get frequency => $composableBuilder(
    column: $table.frequency,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get startDate => $composableBuilder(
    column: $table.startDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get nextDueDate => $composableBuilder(
    column: $table.nextDueDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isActive => $composableBuilder(
    column: $table.isActive,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get createdByAccountId => $composableBuilder(
    column: $table.createdByAccountId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get updatedByAccountId => $composableBuilder(
    column: $table.updatedByAccountId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$WalletGoalSchedulesTableAnnotationComposer
    extends Composer<_$AppDatabase, $WalletGoalSchedulesTable> {
  $$WalletGoalSchedulesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get walletGoalId => $composableBuilder(
    column: $table.walletGoalId,
    builder: (column) => column,
  );

  GeneratedColumn<int> get memberId =>
      $composableBuilder(column: $table.memberId, builder: (column) => column);

  GeneratedColumnWithTypeConverter<double, int> get amount =>
      $composableBuilder(column: $table.amount, builder: (column) => column);

  GeneratedColumnWithTypeConverter<WalletGoalScheduleFrequency, String>
  get frequency =>
      $composableBuilder(column: $table.frequency, builder: (column) => column);

  GeneratedColumn<DateTime> get startDate =>
      $composableBuilder(column: $table.startDate, builder: (column) => column);

  GeneratedColumn<DateTime> get nextDueDate => $composableBuilder(
    column: $table.nextDueDate,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get isActive =>
      $composableBuilder(column: $table.isActive, builder: (column) => column);

  GeneratedColumn<int> get createdByAccountId => $composableBuilder(
    column: $table.createdByAccountId,
    builder: (column) => column,
  );

  GeneratedColumn<int> get updatedByAccountId => $composableBuilder(
    column: $table.updatedByAccountId,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$WalletGoalSchedulesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $WalletGoalSchedulesTable,
          WalletGoalSchedule,
          $$WalletGoalSchedulesTableFilterComposer,
          $$WalletGoalSchedulesTableOrderingComposer,
          $$WalletGoalSchedulesTableAnnotationComposer,
          $$WalletGoalSchedulesTableCreateCompanionBuilder,
          $$WalletGoalSchedulesTableUpdateCompanionBuilder,
          (
            WalletGoalSchedule,
            BaseReferences<
              _$AppDatabase,
              $WalletGoalSchedulesTable,
              WalletGoalSchedule
            >,
          ),
          WalletGoalSchedule,
          PrefetchHooks Function()
        > {
  $$WalletGoalSchedulesTableTableManager(
    _$AppDatabase db,
    $WalletGoalSchedulesTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$WalletGoalSchedulesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$WalletGoalSchedulesTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer: () =>
              $$WalletGoalSchedulesTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> walletGoalId = const Value.absent(),
                Value<int> memberId = const Value.absent(),
                Value<double> amount = const Value.absent(),
                Value<WalletGoalScheduleFrequency> frequency =
                    const Value.absent(),
                Value<DateTime> startDate = const Value.absent(),
                Value<DateTime> nextDueDate = const Value.absent(),
                Value<bool> isActive = const Value.absent(),
                Value<int?> createdByAccountId = const Value.absent(),
                Value<int?> updatedByAccountId = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
              }) => WalletGoalSchedulesCompanion(
                id: id,
                walletGoalId: walletGoalId,
                memberId: memberId,
                amount: amount,
                frequency: frequency,
                startDate: startDate,
                nextDueDate: nextDueDate,
                isActive: isActive,
                createdByAccountId: createdByAccountId,
                updatedByAccountId: updatedByAccountId,
                createdAt: createdAt,
                updatedAt: updatedAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int walletGoalId,
                required int memberId,
                required double amount,
                required WalletGoalScheduleFrequency frequency,
                required DateTime startDate,
                required DateTime nextDueDate,
                Value<bool> isActive = const Value.absent(),
                Value<int?> createdByAccountId = const Value.absent(),
                Value<int?> updatedByAccountId = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
              }) => WalletGoalSchedulesCompanion.insert(
                id: id,
                walletGoalId: walletGoalId,
                memberId: memberId,
                amount: amount,
                frequency: frequency,
                startDate: startDate,
                nextDueDate: nextDueDate,
                isActive: isActive,
                createdByAccountId: createdByAccountId,
                updatedByAccountId: updatedByAccountId,
                createdAt: createdAt,
                updatedAt: updatedAt,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$WalletGoalSchedulesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $WalletGoalSchedulesTable,
      WalletGoalSchedule,
      $$WalletGoalSchedulesTableFilterComposer,
      $$WalletGoalSchedulesTableOrderingComposer,
      $$WalletGoalSchedulesTableAnnotationComposer,
      $$WalletGoalSchedulesTableCreateCompanionBuilder,
      $$WalletGoalSchedulesTableUpdateCompanionBuilder,
      (
        WalletGoalSchedule,
        BaseReferences<
          _$AppDatabase,
          $WalletGoalSchedulesTable,
          WalletGoalSchedule
        >,
      ),
      WalletGoalSchedule,
      PrefetchHooks Function()
    >;
typedef $$FeedbackEntriesTableCreateCompanionBuilder =
    FeedbackEntriesCompanion Function({
      Value<int> id,
      required int walletId,
      required FeedbackCategory category,
      required FeedbackSeverity severity,
      required String workflow,
      required String description,
      required FeedbackResolutionStatus resolutionStatus,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
    });
typedef $$FeedbackEntriesTableUpdateCompanionBuilder =
    FeedbackEntriesCompanion Function({
      Value<int> id,
      Value<int> walletId,
      Value<FeedbackCategory> category,
      Value<FeedbackSeverity> severity,
      Value<String> workflow,
      Value<String> description,
      Value<FeedbackResolutionStatus> resolutionStatus,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
    });

class $$FeedbackEntriesTableFilterComposer
    extends Composer<_$AppDatabase, $FeedbackEntriesTable> {
  $$FeedbackEntriesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get walletId => $composableBuilder(
    column: $table.walletId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<FeedbackCategory, FeedbackCategory, String>
  get category => $composableBuilder(
    column: $table.category,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  ColumnWithTypeConverterFilters<FeedbackSeverity, FeedbackSeverity, String>
  get severity => $composableBuilder(
    column: $table.severity,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  ColumnFilters<String> get workflow => $composableBuilder(
    column: $table.workflow,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<
    FeedbackResolutionStatus,
    FeedbackResolutionStatus,
    String
  >
  get resolutionStatus => $composableBuilder(
    column: $table.resolutionStatus,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$FeedbackEntriesTableOrderingComposer
    extends Composer<_$AppDatabase, $FeedbackEntriesTable> {
  $$FeedbackEntriesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get walletId => $composableBuilder(
    column: $table.walletId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get category => $composableBuilder(
    column: $table.category,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get severity => $composableBuilder(
    column: $table.severity,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get workflow => $composableBuilder(
    column: $table.workflow,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get resolutionStatus => $composableBuilder(
    column: $table.resolutionStatus,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$FeedbackEntriesTableAnnotationComposer
    extends Composer<_$AppDatabase, $FeedbackEntriesTable> {
  $$FeedbackEntriesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get walletId =>
      $composableBuilder(column: $table.walletId, builder: (column) => column);

  GeneratedColumnWithTypeConverter<FeedbackCategory, String> get category =>
      $composableBuilder(column: $table.category, builder: (column) => column);

  GeneratedColumnWithTypeConverter<FeedbackSeverity, String> get severity =>
      $composableBuilder(column: $table.severity, builder: (column) => column);

  GeneratedColumn<String> get workflow =>
      $composableBuilder(column: $table.workflow, builder: (column) => column);

  GeneratedColumn<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => column,
  );

  GeneratedColumnWithTypeConverter<FeedbackResolutionStatus, String>
  get resolutionStatus => $composableBuilder(
    column: $table.resolutionStatus,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$FeedbackEntriesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $FeedbackEntriesTable,
          FeedbackEntry,
          $$FeedbackEntriesTableFilterComposer,
          $$FeedbackEntriesTableOrderingComposer,
          $$FeedbackEntriesTableAnnotationComposer,
          $$FeedbackEntriesTableCreateCompanionBuilder,
          $$FeedbackEntriesTableUpdateCompanionBuilder,
          (
            FeedbackEntry,
            BaseReferences<_$AppDatabase, $FeedbackEntriesTable, FeedbackEntry>,
          ),
          FeedbackEntry,
          PrefetchHooks Function()
        > {
  $$FeedbackEntriesTableTableManager(
    _$AppDatabase db,
    $FeedbackEntriesTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$FeedbackEntriesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$FeedbackEntriesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$FeedbackEntriesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> walletId = const Value.absent(),
                Value<FeedbackCategory> category = const Value.absent(),
                Value<FeedbackSeverity> severity = const Value.absent(),
                Value<String> workflow = const Value.absent(),
                Value<String> description = const Value.absent(),
                Value<FeedbackResolutionStatus> resolutionStatus =
                    const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
              }) => FeedbackEntriesCompanion(
                id: id,
                walletId: walletId,
                category: category,
                severity: severity,
                workflow: workflow,
                description: description,
                resolutionStatus: resolutionStatus,
                createdAt: createdAt,
                updatedAt: updatedAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int walletId,
                required FeedbackCategory category,
                required FeedbackSeverity severity,
                required String workflow,
                required String description,
                required FeedbackResolutionStatus resolutionStatus,
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
              }) => FeedbackEntriesCompanion.insert(
                id: id,
                walletId: walletId,
                category: category,
                severity: severity,
                workflow: workflow,
                description: description,
                resolutionStatus: resolutionStatus,
                createdAt: createdAt,
                updatedAt: updatedAt,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$FeedbackEntriesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $FeedbackEntriesTable,
      FeedbackEntry,
      $$FeedbackEntriesTableFilterComposer,
      $$FeedbackEntriesTableOrderingComposer,
      $$FeedbackEntriesTableAnnotationComposer,
      $$FeedbackEntriesTableCreateCompanionBuilder,
      $$FeedbackEntriesTableUpdateCompanionBuilder,
      (
        FeedbackEntry,
        BaseReferences<_$AppDatabase, $FeedbackEntriesTable, FeedbackEntry>,
      ),
      FeedbackEntry,
      PrefetchHooks Function()
    >;
typedef $$WalletNotificationPreferencesTableCreateCompanionBuilder =
    WalletNotificationPreferencesCompanion Function({
      Value<int> id,
      required int walletId,
      Value<bool> billReminders,
      Value<bool> goalReminders,
      Value<bool> allowanceReminders,
      Value<bool> settlementReminders,
      Value<DateTime> updatedAt,
    });
typedef $$WalletNotificationPreferencesTableUpdateCompanionBuilder =
    WalletNotificationPreferencesCompanion Function({
      Value<int> id,
      Value<int> walletId,
      Value<bool> billReminders,
      Value<bool> goalReminders,
      Value<bool> allowanceReminders,
      Value<bool> settlementReminders,
      Value<DateTime> updatedAt,
    });

class $$WalletNotificationPreferencesTableFilterComposer
    extends Composer<_$AppDatabase, $WalletNotificationPreferencesTable> {
  $$WalletNotificationPreferencesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get walletId => $composableBuilder(
    column: $table.walletId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get billReminders => $composableBuilder(
    column: $table.billReminders,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get goalReminders => $composableBuilder(
    column: $table.goalReminders,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get allowanceReminders => $composableBuilder(
    column: $table.allowanceReminders,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get settlementReminders => $composableBuilder(
    column: $table.settlementReminders,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$WalletNotificationPreferencesTableOrderingComposer
    extends Composer<_$AppDatabase, $WalletNotificationPreferencesTable> {
  $$WalletNotificationPreferencesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get walletId => $composableBuilder(
    column: $table.walletId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get billReminders => $composableBuilder(
    column: $table.billReminders,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get goalReminders => $composableBuilder(
    column: $table.goalReminders,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get allowanceReminders => $composableBuilder(
    column: $table.allowanceReminders,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get settlementReminders => $composableBuilder(
    column: $table.settlementReminders,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$WalletNotificationPreferencesTableAnnotationComposer
    extends Composer<_$AppDatabase, $WalletNotificationPreferencesTable> {
  $$WalletNotificationPreferencesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get walletId =>
      $composableBuilder(column: $table.walletId, builder: (column) => column);

  GeneratedColumn<bool> get billReminders => $composableBuilder(
    column: $table.billReminders,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get goalReminders => $composableBuilder(
    column: $table.goalReminders,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get allowanceReminders => $composableBuilder(
    column: $table.allowanceReminders,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get settlementReminders => $composableBuilder(
    column: $table.settlementReminders,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$WalletNotificationPreferencesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $WalletNotificationPreferencesTable,
          WalletNotificationPreference,
          $$WalletNotificationPreferencesTableFilterComposer,
          $$WalletNotificationPreferencesTableOrderingComposer,
          $$WalletNotificationPreferencesTableAnnotationComposer,
          $$WalletNotificationPreferencesTableCreateCompanionBuilder,
          $$WalletNotificationPreferencesTableUpdateCompanionBuilder,
          (
            WalletNotificationPreference,
            BaseReferences<
              _$AppDatabase,
              $WalletNotificationPreferencesTable,
              WalletNotificationPreference
            >,
          ),
          WalletNotificationPreference,
          PrefetchHooks Function()
        > {
  $$WalletNotificationPreferencesTableTableManager(
    _$AppDatabase db,
    $WalletNotificationPreferencesTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$WalletNotificationPreferencesTableFilterComposer(
                $db: db,
                $table: table,
              ),
          createOrderingComposer: () =>
              $$WalletNotificationPreferencesTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer: () =>
              $$WalletNotificationPreferencesTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> walletId = const Value.absent(),
                Value<bool> billReminders = const Value.absent(),
                Value<bool> goalReminders = const Value.absent(),
                Value<bool> allowanceReminders = const Value.absent(),
                Value<bool> settlementReminders = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
              }) => WalletNotificationPreferencesCompanion(
                id: id,
                walletId: walletId,
                billReminders: billReminders,
                goalReminders: goalReminders,
                allowanceReminders: allowanceReminders,
                settlementReminders: settlementReminders,
                updatedAt: updatedAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int walletId,
                Value<bool> billReminders = const Value.absent(),
                Value<bool> goalReminders = const Value.absent(),
                Value<bool> allowanceReminders = const Value.absent(),
                Value<bool> settlementReminders = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
              }) => WalletNotificationPreferencesCompanion.insert(
                id: id,
                walletId: walletId,
                billReminders: billReminders,
                goalReminders: goalReminders,
                allowanceReminders: allowanceReminders,
                settlementReminders: settlementReminders,
                updatedAt: updatedAt,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$WalletNotificationPreferencesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $WalletNotificationPreferencesTable,
      WalletNotificationPreference,
      $$WalletNotificationPreferencesTableFilterComposer,
      $$WalletNotificationPreferencesTableOrderingComposer,
      $$WalletNotificationPreferencesTableAnnotationComposer,
      $$WalletNotificationPreferencesTableCreateCompanionBuilder,
      $$WalletNotificationPreferencesTableUpdateCompanionBuilder,
      (
        WalletNotificationPreference,
        BaseReferences<
          _$AppDatabase,
          $WalletNotificationPreferencesTable,
          WalletNotificationPreference
        >,
      ),
      WalletNotificationPreference,
      PrefetchHooks Function()
    >;
typedef $$DeletedRecordsTableCreateCompanionBuilder =
    DeletedRecordsCompanion Function({
      Value<int> id,
      required String uuid,
      required String deletedTable,
      Value<DateTime> deletedAt,
    });
typedef $$DeletedRecordsTableUpdateCompanionBuilder =
    DeletedRecordsCompanion Function({
      Value<int> id,
      Value<String> uuid,
      Value<String> deletedTable,
      Value<DateTime> deletedAt,
    });

class $$DeletedRecordsTableFilterComposer
    extends Composer<_$AppDatabase, $DeletedRecordsTable> {
  $$DeletedRecordsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get uuid => $composableBuilder(
    column: $table.uuid,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get deletedTable => $composableBuilder(
    column: $table.deletedTable,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get deletedAt => $composableBuilder(
    column: $table.deletedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$DeletedRecordsTableOrderingComposer
    extends Composer<_$AppDatabase, $DeletedRecordsTable> {
  $$DeletedRecordsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get uuid => $composableBuilder(
    column: $table.uuid,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get deletedTable => $composableBuilder(
    column: $table.deletedTable,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get deletedAt => $composableBuilder(
    column: $table.deletedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$DeletedRecordsTableAnnotationComposer
    extends Composer<_$AppDatabase, $DeletedRecordsTable> {
  $$DeletedRecordsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get uuid =>
      $composableBuilder(column: $table.uuid, builder: (column) => column);

  GeneratedColumn<String> get deletedTable => $composableBuilder(
    column: $table.deletedTable,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get deletedAt =>
      $composableBuilder(column: $table.deletedAt, builder: (column) => column);
}

class $$DeletedRecordsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $DeletedRecordsTable,
          DeletedRecord,
          $$DeletedRecordsTableFilterComposer,
          $$DeletedRecordsTableOrderingComposer,
          $$DeletedRecordsTableAnnotationComposer,
          $$DeletedRecordsTableCreateCompanionBuilder,
          $$DeletedRecordsTableUpdateCompanionBuilder,
          (
            DeletedRecord,
            BaseReferences<_$AppDatabase, $DeletedRecordsTable, DeletedRecord>,
          ),
          DeletedRecord,
          PrefetchHooks Function()
        > {
  $$DeletedRecordsTableTableManager(
    _$AppDatabase db,
    $DeletedRecordsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$DeletedRecordsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$DeletedRecordsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$DeletedRecordsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> uuid = const Value.absent(),
                Value<String> deletedTable = const Value.absent(),
                Value<DateTime> deletedAt = const Value.absent(),
              }) => DeletedRecordsCompanion(
                id: id,
                uuid: uuid,
                deletedTable: deletedTable,
                deletedAt: deletedAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String uuid,
                required String deletedTable,
                Value<DateTime> deletedAt = const Value.absent(),
              }) => DeletedRecordsCompanion.insert(
                id: id,
                uuid: uuid,
                deletedTable: deletedTable,
                deletedAt: deletedAt,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$DeletedRecordsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $DeletedRecordsTable,
      DeletedRecord,
      $$DeletedRecordsTableFilterComposer,
      $$DeletedRecordsTableOrderingComposer,
      $$DeletedRecordsTableAnnotationComposer,
      $$DeletedRecordsTableCreateCompanionBuilder,
      $$DeletedRecordsTableUpdateCompanionBuilder,
      (
        DeletedRecord,
        BaseReferences<_$AppDatabase, $DeletedRecordsTable, DeletedRecord>,
      ),
      DeletedRecord,
      PrefetchHooks Function()
    >;
typedef $$AttachmentsTableCreateCompanionBuilder =
    AttachmentsCompanion Function({
      Value<int> id,
      required int transactionId,
      required String filePath,
      Value<String?> fileType,
      Value<DateTime> createdAt,
    });
typedef $$AttachmentsTableUpdateCompanionBuilder =
    AttachmentsCompanion Function({
      Value<int> id,
      Value<int> transactionId,
      Value<String> filePath,
      Value<String?> fileType,
      Value<DateTime> createdAt,
    });

class $$AttachmentsTableFilterComposer
    extends Composer<_$AppDatabase, $AttachmentsTable> {
  $$AttachmentsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get transactionId => $composableBuilder(
    column: $table.transactionId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get filePath => $composableBuilder(
    column: $table.filePath,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get fileType => $composableBuilder(
    column: $table.fileType,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$AttachmentsTableOrderingComposer
    extends Composer<_$AppDatabase, $AttachmentsTable> {
  $$AttachmentsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get transactionId => $composableBuilder(
    column: $table.transactionId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get filePath => $composableBuilder(
    column: $table.filePath,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get fileType => $composableBuilder(
    column: $table.fileType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$AttachmentsTableAnnotationComposer
    extends Composer<_$AppDatabase, $AttachmentsTable> {
  $$AttachmentsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get transactionId => $composableBuilder(
    column: $table.transactionId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get filePath =>
      $composableBuilder(column: $table.filePath, builder: (column) => column);

  GeneratedColumn<String> get fileType =>
      $composableBuilder(column: $table.fileType, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);
}

class $$AttachmentsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $AttachmentsTable,
          Attachment,
          $$AttachmentsTableFilterComposer,
          $$AttachmentsTableOrderingComposer,
          $$AttachmentsTableAnnotationComposer,
          $$AttachmentsTableCreateCompanionBuilder,
          $$AttachmentsTableUpdateCompanionBuilder,
          (
            Attachment,
            BaseReferences<_$AppDatabase, $AttachmentsTable, Attachment>,
          ),
          Attachment,
          PrefetchHooks Function()
        > {
  $$AttachmentsTableTableManager(_$AppDatabase db, $AttachmentsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$AttachmentsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$AttachmentsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$AttachmentsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> transactionId = const Value.absent(),
                Value<String> filePath = const Value.absent(),
                Value<String?> fileType = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
              }) => AttachmentsCompanion(
                id: id,
                transactionId: transactionId,
                filePath: filePath,
                fileType: fileType,
                createdAt: createdAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int transactionId,
                required String filePath,
                Value<String?> fileType = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
              }) => AttachmentsCompanion.insert(
                id: id,
                transactionId: transactionId,
                filePath: filePath,
                fileType: fileType,
                createdAt: createdAt,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$AttachmentsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $AttachmentsTable,
      Attachment,
      $$AttachmentsTableFilterComposer,
      $$AttachmentsTableOrderingComposer,
      $$AttachmentsTableAnnotationComposer,
      $$AttachmentsTableCreateCompanionBuilder,
      $$AttachmentsTableUpdateCompanionBuilder,
      (
        Attachment,
        BaseReferences<_$AppDatabase, $AttachmentsTable, Attachment>,
      ),
      Attachment,
      PrefetchHooks Function()
    >;
typedef $$WalletExpenseSplitsTableCreateCompanionBuilder =
    WalletExpenseSplitsCompanion Function({
      Value<int> id,
      required int walletId,
      Value<String> uuid,
      required int transactionId,
      required int paidByMemberId,
      required WalletExpenseSplitMethod splitMethod,
      Value<int?> createdByAccountId,
      Value<DateTime> createdAt,
    });
typedef $$WalletExpenseSplitsTableUpdateCompanionBuilder =
    WalletExpenseSplitsCompanion Function({
      Value<int> id,
      Value<int> walletId,
      Value<String> uuid,
      Value<int> transactionId,
      Value<int> paidByMemberId,
      Value<WalletExpenseSplitMethod> splitMethod,
      Value<int?> createdByAccountId,
      Value<DateTime> createdAt,
    });

class $$WalletExpenseSplitsTableFilterComposer
    extends Composer<_$AppDatabase, $WalletExpenseSplitsTable> {
  $$WalletExpenseSplitsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get walletId => $composableBuilder(
    column: $table.walletId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get uuid => $composableBuilder(
    column: $table.uuid,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get transactionId => $composableBuilder(
    column: $table.transactionId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get paidByMemberId => $composableBuilder(
    column: $table.paidByMemberId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<
    WalletExpenseSplitMethod,
    WalletExpenseSplitMethod,
    String
  >
  get splitMethod => $composableBuilder(
    column: $table.splitMethod,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  ColumnFilters<int> get createdByAccountId => $composableBuilder(
    column: $table.createdByAccountId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$WalletExpenseSplitsTableOrderingComposer
    extends Composer<_$AppDatabase, $WalletExpenseSplitsTable> {
  $$WalletExpenseSplitsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get walletId => $composableBuilder(
    column: $table.walletId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get uuid => $composableBuilder(
    column: $table.uuid,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get transactionId => $composableBuilder(
    column: $table.transactionId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get paidByMemberId => $composableBuilder(
    column: $table.paidByMemberId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get splitMethod => $composableBuilder(
    column: $table.splitMethod,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get createdByAccountId => $composableBuilder(
    column: $table.createdByAccountId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$WalletExpenseSplitsTableAnnotationComposer
    extends Composer<_$AppDatabase, $WalletExpenseSplitsTable> {
  $$WalletExpenseSplitsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get walletId =>
      $composableBuilder(column: $table.walletId, builder: (column) => column);

  GeneratedColumn<String> get uuid =>
      $composableBuilder(column: $table.uuid, builder: (column) => column);

  GeneratedColumn<int> get transactionId => $composableBuilder(
    column: $table.transactionId,
    builder: (column) => column,
  );

  GeneratedColumn<int> get paidByMemberId => $composableBuilder(
    column: $table.paidByMemberId,
    builder: (column) => column,
  );

  GeneratedColumnWithTypeConverter<WalletExpenseSplitMethod, String>
  get splitMethod => $composableBuilder(
    column: $table.splitMethod,
    builder: (column) => column,
  );

  GeneratedColumn<int> get createdByAccountId => $composableBuilder(
    column: $table.createdByAccountId,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);
}

class $$WalletExpenseSplitsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $WalletExpenseSplitsTable,
          WalletExpenseSplit,
          $$WalletExpenseSplitsTableFilterComposer,
          $$WalletExpenseSplitsTableOrderingComposer,
          $$WalletExpenseSplitsTableAnnotationComposer,
          $$WalletExpenseSplitsTableCreateCompanionBuilder,
          $$WalletExpenseSplitsTableUpdateCompanionBuilder,
          (
            WalletExpenseSplit,
            BaseReferences<
              _$AppDatabase,
              $WalletExpenseSplitsTable,
              WalletExpenseSplit
            >,
          ),
          WalletExpenseSplit,
          PrefetchHooks Function()
        > {
  $$WalletExpenseSplitsTableTableManager(
    _$AppDatabase db,
    $WalletExpenseSplitsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$WalletExpenseSplitsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$WalletExpenseSplitsTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer: () =>
              $$WalletExpenseSplitsTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> walletId = const Value.absent(),
                Value<String> uuid = const Value.absent(),
                Value<int> transactionId = const Value.absent(),
                Value<int> paidByMemberId = const Value.absent(),
                Value<WalletExpenseSplitMethod> splitMethod =
                    const Value.absent(),
                Value<int?> createdByAccountId = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
              }) => WalletExpenseSplitsCompanion(
                id: id,
                walletId: walletId,
                uuid: uuid,
                transactionId: transactionId,
                paidByMemberId: paidByMemberId,
                splitMethod: splitMethod,
                createdByAccountId: createdByAccountId,
                createdAt: createdAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int walletId,
                Value<String> uuid = const Value.absent(),
                required int transactionId,
                required int paidByMemberId,
                required WalletExpenseSplitMethod splitMethod,
                Value<int?> createdByAccountId = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
              }) => WalletExpenseSplitsCompanion.insert(
                id: id,
                walletId: walletId,
                uuid: uuid,
                transactionId: transactionId,
                paidByMemberId: paidByMemberId,
                splitMethod: splitMethod,
                createdByAccountId: createdByAccountId,
                createdAt: createdAt,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$WalletExpenseSplitsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $WalletExpenseSplitsTable,
      WalletExpenseSplit,
      $$WalletExpenseSplitsTableFilterComposer,
      $$WalletExpenseSplitsTableOrderingComposer,
      $$WalletExpenseSplitsTableAnnotationComposer,
      $$WalletExpenseSplitsTableCreateCompanionBuilder,
      $$WalletExpenseSplitsTableUpdateCompanionBuilder,
      (
        WalletExpenseSplit,
        BaseReferences<
          _$AppDatabase,
          $WalletExpenseSplitsTable,
          WalletExpenseSplit
        >,
      ),
      WalletExpenseSplit,
      PrefetchHooks Function()
    >;
typedef $$WalletExpenseSplitMembersTableCreateCompanionBuilder =
    WalletExpenseSplitMembersCompanion Function({
      Value<int> id,
      required int splitId,
      required int memberId,
      required double amountOwed,
      Value<double> percentage,
      Value<double> settledAmount,
    });
typedef $$WalletExpenseSplitMembersTableUpdateCompanionBuilder =
    WalletExpenseSplitMembersCompanion Function({
      Value<int> id,
      Value<int> splitId,
      Value<int> memberId,
      Value<double> amountOwed,
      Value<double> percentage,
      Value<double> settledAmount,
    });

class $$WalletExpenseSplitMembersTableFilterComposer
    extends Composer<_$AppDatabase, $WalletExpenseSplitMembersTable> {
  $$WalletExpenseSplitMembersTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get splitId => $composableBuilder(
    column: $table.splitId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get memberId => $composableBuilder(
    column: $table.memberId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<double, double, int> get amountOwed =>
      $composableBuilder(
        column: $table.amountOwed,
        builder: (column) => ColumnWithTypeConverterFilters(column),
      );

  ColumnFilters<double> get percentage => $composableBuilder(
    column: $table.percentage,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<double, double, int> get settledAmount =>
      $composableBuilder(
        column: $table.settledAmount,
        builder: (column) => ColumnWithTypeConverterFilters(column),
      );
}

class $$WalletExpenseSplitMembersTableOrderingComposer
    extends Composer<_$AppDatabase, $WalletExpenseSplitMembersTable> {
  $$WalletExpenseSplitMembersTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get splitId => $composableBuilder(
    column: $table.splitId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get memberId => $composableBuilder(
    column: $table.memberId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get amountOwed => $composableBuilder(
    column: $table.amountOwed,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get percentage => $composableBuilder(
    column: $table.percentage,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get settledAmount => $composableBuilder(
    column: $table.settledAmount,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$WalletExpenseSplitMembersTableAnnotationComposer
    extends Composer<_$AppDatabase, $WalletExpenseSplitMembersTable> {
  $$WalletExpenseSplitMembersTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get splitId =>
      $composableBuilder(column: $table.splitId, builder: (column) => column);

  GeneratedColumn<int> get memberId =>
      $composableBuilder(column: $table.memberId, builder: (column) => column);

  GeneratedColumnWithTypeConverter<double, int> get amountOwed =>
      $composableBuilder(
        column: $table.amountOwed,
        builder: (column) => column,
      );

  GeneratedColumn<double> get percentage => $composableBuilder(
    column: $table.percentage,
    builder: (column) => column,
  );

  GeneratedColumnWithTypeConverter<double, int> get settledAmount =>
      $composableBuilder(
        column: $table.settledAmount,
        builder: (column) => column,
      );
}

class $$WalletExpenseSplitMembersTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $WalletExpenseSplitMembersTable,
          WalletExpenseSplitMember,
          $$WalletExpenseSplitMembersTableFilterComposer,
          $$WalletExpenseSplitMembersTableOrderingComposer,
          $$WalletExpenseSplitMembersTableAnnotationComposer,
          $$WalletExpenseSplitMembersTableCreateCompanionBuilder,
          $$WalletExpenseSplitMembersTableUpdateCompanionBuilder,
          (
            WalletExpenseSplitMember,
            BaseReferences<
              _$AppDatabase,
              $WalletExpenseSplitMembersTable,
              WalletExpenseSplitMember
            >,
          ),
          WalletExpenseSplitMember,
          PrefetchHooks Function()
        > {
  $$WalletExpenseSplitMembersTableTableManager(
    _$AppDatabase db,
    $WalletExpenseSplitMembersTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$WalletExpenseSplitMembersTableFilterComposer(
                $db: db,
                $table: table,
              ),
          createOrderingComposer: () =>
              $$WalletExpenseSplitMembersTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer: () =>
              $$WalletExpenseSplitMembersTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> splitId = const Value.absent(),
                Value<int> memberId = const Value.absent(),
                Value<double> amountOwed = const Value.absent(),
                Value<double> percentage = const Value.absent(),
                Value<double> settledAmount = const Value.absent(),
              }) => WalletExpenseSplitMembersCompanion(
                id: id,
                splitId: splitId,
                memberId: memberId,
                amountOwed: amountOwed,
                percentage: percentage,
                settledAmount: settledAmount,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int splitId,
                required int memberId,
                required double amountOwed,
                Value<double> percentage = const Value.absent(),
                Value<double> settledAmount = const Value.absent(),
              }) => WalletExpenseSplitMembersCompanion.insert(
                id: id,
                splitId: splitId,
                memberId: memberId,
                amountOwed: amountOwed,
                percentage: percentage,
                settledAmount: settledAmount,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$WalletExpenseSplitMembersTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $WalletExpenseSplitMembersTable,
      WalletExpenseSplitMember,
      $$WalletExpenseSplitMembersTableFilterComposer,
      $$WalletExpenseSplitMembersTableOrderingComposer,
      $$WalletExpenseSplitMembersTableAnnotationComposer,
      $$WalletExpenseSplitMembersTableCreateCompanionBuilder,
      $$WalletExpenseSplitMembersTableUpdateCompanionBuilder,
      (
        WalletExpenseSplitMember,
        BaseReferences<
          _$AppDatabase,
          $WalletExpenseSplitMembersTable,
          WalletExpenseSplitMember
        >,
      ),
      WalletExpenseSplitMember,
      PrefetchHooks Function()
    >;
typedef $$MerchantMappingsTableCreateCompanionBuilder =
    MerchantMappingsCompanion Function({
      Value<int> id,
      required int walletId,
      required String originalPattern,
      required String cleanName,
      Value<int?> defaultCategoryId,
      Value<DateTime> createdAt,
    });
typedef $$MerchantMappingsTableUpdateCompanionBuilder =
    MerchantMappingsCompanion Function({
      Value<int> id,
      Value<int> walletId,
      Value<String> originalPattern,
      Value<String> cleanName,
      Value<int?> defaultCategoryId,
      Value<DateTime> createdAt,
    });

class $$MerchantMappingsTableFilterComposer
    extends Composer<_$AppDatabase, $MerchantMappingsTable> {
  $$MerchantMappingsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get walletId => $composableBuilder(
    column: $table.walletId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get originalPattern => $composableBuilder(
    column: $table.originalPattern,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get cleanName => $composableBuilder(
    column: $table.cleanName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get defaultCategoryId => $composableBuilder(
    column: $table.defaultCategoryId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$MerchantMappingsTableOrderingComposer
    extends Composer<_$AppDatabase, $MerchantMappingsTable> {
  $$MerchantMappingsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get walletId => $composableBuilder(
    column: $table.walletId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get originalPattern => $composableBuilder(
    column: $table.originalPattern,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get cleanName => $composableBuilder(
    column: $table.cleanName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get defaultCategoryId => $composableBuilder(
    column: $table.defaultCategoryId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$MerchantMappingsTableAnnotationComposer
    extends Composer<_$AppDatabase, $MerchantMappingsTable> {
  $$MerchantMappingsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get walletId =>
      $composableBuilder(column: $table.walletId, builder: (column) => column);

  GeneratedColumn<String> get originalPattern => $composableBuilder(
    column: $table.originalPattern,
    builder: (column) => column,
  );

  GeneratedColumn<String> get cleanName =>
      $composableBuilder(column: $table.cleanName, builder: (column) => column);

  GeneratedColumn<int> get defaultCategoryId => $composableBuilder(
    column: $table.defaultCategoryId,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);
}

class $$MerchantMappingsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $MerchantMappingsTable,
          MerchantMapping,
          $$MerchantMappingsTableFilterComposer,
          $$MerchantMappingsTableOrderingComposer,
          $$MerchantMappingsTableAnnotationComposer,
          $$MerchantMappingsTableCreateCompanionBuilder,
          $$MerchantMappingsTableUpdateCompanionBuilder,
          (
            MerchantMapping,
            BaseReferences<
              _$AppDatabase,
              $MerchantMappingsTable,
              MerchantMapping
            >,
          ),
          MerchantMapping,
          PrefetchHooks Function()
        > {
  $$MerchantMappingsTableTableManager(
    _$AppDatabase db,
    $MerchantMappingsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$MerchantMappingsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$MerchantMappingsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$MerchantMappingsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> walletId = const Value.absent(),
                Value<String> originalPattern = const Value.absent(),
                Value<String> cleanName = const Value.absent(),
                Value<int?> defaultCategoryId = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
              }) => MerchantMappingsCompanion(
                id: id,
                walletId: walletId,
                originalPattern: originalPattern,
                cleanName: cleanName,
                defaultCategoryId: defaultCategoryId,
                createdAt: createdAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int walletId,
                required String originalPattern,
                required String cleanName,
                Value<int?> defaultCategoryId = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
              }) => MerchantMappingsCompanion.insert(
                id: id,
                walletId: walletId,
                originalPattern: originalPattern,
                cleanName: cleanName,
                defaultCategoryId: defaultCategoryId,
                createdAt: createdAt,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$MerchantMappingsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $MerchantMappingsTable,
      MerchantMapping,
      $$MerchantMappingsTableFilterComposer,
      $$MerchantMappingsTableOrderingComposer,
      $$MerchantMappingsTableAnnotationComposer,
      $$MerchantMappingsTableCreateCompanionBuilder,
      $$MerchantMappingsTableUpdateCompanionBuilder,
      (
        MerchantMapping,
        BaseReferences<_$AppDatabase, $MerchantMappingsTable, MerchantMapping>,
      ),
      MerchantMapping,
      PrefetchHooks Function()
    >;
typedef $$PayeesTableCreateCompanionBuilder =
    PayeesCompanion Function({
      Value<int> id,
      Value<int> walletId,
      required String name,
    });
typedef $$PayeesTableUpdateCompanionBuilder =
    PayeesCompanion Function({
      Value<int> id,
      Value<int> walletId,
      Value<String> name,
    });

class $$PayeesTableFilterComposer
    extends Composer<_$AppDatabase, $PayeesTable> {
  $$PayeesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get walletId => $composableBuilder(
    column: $table.walletId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );
}

class $$PayeesTableOrderingComposer
    extends Composer<_$AppDatabase, $PayeesTable> {
  $$PayeesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get walletId => $composableBuilder(
    column: $table.walletId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$PayeesTableAnnotationComposer
    extends Composer<_$AppDatabase, $PayeesTable> {
  $$PayeesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get walletId =>
      $composableBuilder(column: $table.walletId, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);
}

class $$PayeesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $PayeesTable,
          Payee,
          $$PayeesTableFilterComposer,
          $$PayeesTableOrderingComposer,
          $$PayeesTableAnnotationComposer,
          $$PayeesTableCreateCompanionBuilder,
          $$PayeesTableUpdateCompanionBuilder,
          (Payee, BaseReferences<_$AppDatabase, $PayeesTable, Payee>),
          Payee,
          PrefetchHooks Function()
        > {
  $$PayeesTableTableManager(_$AppDatabase db, $PayeesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$PayeesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$PayeesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$PayeesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> walletId = const Value.absent(),
                Value<String> name = const Value.absent(),
              }) => PayeesCompanion(id: id, walletId: walletId, name: name),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> walletId = const Value.absent(),
                required String name,
              }) => PayeesCompanion.insert(
                id: id,
                walletId: walletId,
                name: name,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$PayeesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $PayeesTable,
      Payee,
      $$PayeesTableFilterComposer,
      $$PayeesTableOrderingComposer,
      $$PayeesTableAnnotationComposer,
      $$PayeesTableCreateCompanionBuilder,
      $$PayeesTableUpdateCompanionBuilder,
      (Payee, BaseReferences<_$AppDatabase, $PayeesTable, Payee>),
      Payee,
      PrefetchHooks Function()
    >;
typedef $$RecurringTransactionsTableCreateCompanionBuilder =
    RecurringTransactionsCompanion Function({
      Value<int> id,
      Value<int> walletId,
      Value<String> uuid,
      required String name,
      required double amount,
      required TransactionType type,
      required int categoryId,
      required int accountId,
      required String interval,
      required DateTime startDate,
      required DateTime nextDueDate,
      Value<DateTime?> lastGeneratedDate,
      Value<bool> isActive,
      Value<DateTime> updatedAt,
    });
typedef $$RecurringTransactionsTableUpdateCompanionBuilder =
    RecurringTransactionsCompanion Function({
      Value<int> id,
      Value<int> walletId,
      Value<String> uuid,
      Value<String> name,
      Value<double> amount,
      Value<TransactionType> type,
      Value<int> categoryId,
      Value<int> accountId,
      Value<String> interval,
      Value<DateTime> startDate,
      Value<DateTime> nextDueDate,
      Value<DateTime?> lastGeneratedDate,
      Value<bool> isActive,
      Value<DateTime> updatedAt,
    });

class $$RecurringTransactionsTableFilterComposer
    extends Composer<_$AppDatabase, $RecurringTransactionsTable> {
  $$RecurringTransactionsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get walletId => $composableBuilder(
    column: $table.walletId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get uuid => $composableBuilder(
    column: $table.uuid,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<double, double, int> get amount =>
      $composableBuilder(
        column: $table.amount,
        builder: (column) => ColumnWithTypeConverterFilters(column),
      );

  ColumnWithTypeConverterFilters<TransactionType, TransactionType, String>
  get type => $composableBuilder(
    column: $table.type,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  ColumnFilters<int> get categoryId => $composableBuilder(
    column: $table.categoryId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get accountId => $composableBuilder(
    column: $table.accountId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get interval => $composableBuilder(
    column: $table.interval,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get startDate => $composableBuilder(
    column: $table.startDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get nextDueDate => $composableBuilder(
    column: $table.nextDueDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get lastGeneratedDate => $composableBuilder(
    column: $table.lastGeneratedDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isActive => $composableBuilder(
    column: $table.isActive,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$RecurringTransactionsTableOrderingComposer
    extends Composer<_$AppDatabase, $RecurringTransactionsTable> {
  $$RecurringTransactionsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get walletId => $composableBuilder(
    column: $table.walletId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get uuid => $composableBuilder(
    column: $table.uuid,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get amount => $composableBuilder(
    column: $table.amount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get type => $composableBuilder(
    column: $table.type,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get categoryId => $composableBuilder(
    column: $table.categoryId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get accountId => $composableBuilder(
    column: $table.accountId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get interval => $composableBuilder(
    column: $table.interval,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get startDate => $composableBuilder(
    column: $table.startDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get nextDueDate => $composableBuilder(
    column: $table.nextDueDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get lastGeneratedDate => $composableBuilder(
    column: $table.lastGeneratedDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isActive => $composableBuilder(
    column: $table.isActive,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$RecurringTransactionsTableAnnotationComposer
    extends Composer<_$AppDatabase, $RecurringTransactionsTable> {
  $$RecurringTransactionsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get walletId =>
      $composableBuilder(column: $table.walletId, builder: (column) => column);

  GeneratedColumn<String> get uuid =>
      $composableBuilder(column: $table.uuid, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumnWithTypeConverter<double, int> get amount =>
      $composableBuilder(column: $table.amount, builder: (column) => column);

  GeneratedColumnWithTypeConverter<TransactionType, String> get type =>
      $composableBuilder(column: $table.type, builder: (column) => column);

  GeneratedColumn<int> get categoryId => $composableBuilder(
    column: $table.categoryId,
    builder: (column) => column,
  );

  GeneratedColumn<int> get accountId =>
      $composableBuilder(column: $table.accountId, builder: (column) => column);

  GeneratedColumn<String> get interval =>
      $composableBuilder(column: $table.interval, builder: (column) => column);

  GeneratedColumn<DateTime> get startDate =>
      $composableBuilder(column: $table.startDate, builder: (column) => column);

  GeneratedColumn<DateTime> get nextDueDate => $composableBuilder(
    column: $table.nextDueDate,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get lastGeneratedDate => $composableBuilder(
    column: $table.lastGeneratedDate,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get isActive =>
      $composableBuilder(column: $table.isActive, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$RecurringTransactionsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $RecurringTransactionsTable,
          RecurringTransactionDb,
          $$RecurringTransactionsTableFilterComposer,
          $$RecurringTransactionsTableOrderingComposer,
          $$RecurringTransactionsTableAnnotationComposer,
          $$RecurringTransactionsTableCreateCompanionBuilder,
          $$RecurringTransactionsTableUpdateCompanionBuilder,
          (
            RecurringTransactionDb,
            BaseReferences<
              _$AppDatabase,
              $RecurringTransactionsTable,
              RecurringTransactionDb
            >,
          ),
          RecurringTransactionDb,
          PrefetchHooks Function()
        > {
  $$RecurringTransactionsTableTableManager(
    _$AppDatabase db,
    $RecurringTransactionsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$RecurringTransactionsTableFilterComposer(
                $db: db,
                $table: table,
              ),
          createOrderingComposer: () =>
              $$RecurringTransactionsTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer: () =>
              $$RecurringTransactionsTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> walletId = const Value.absent(),
                Value<String> uuid = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<double> amount = const Value.absent(),
                Value<TransactionType> type = const Value.absent(),
                Value<int> categoryId = const Value.absent(),
                Value<int> accountId = const Value.absent(),
                Value<String> interval = const Value.absent(),
                Value<DateTime> startDate = const Value.absent(),
                Value<DateTime> nextDueDate = const Value.absent(),
                Value<DateTime?> lastGeneratedDate = const Value.absent(),
                Value<bool> isActive = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
              }) => RecurringTransactionsCompanion(
                id: id,
                walletId: walletId,
                uuid: uuid,
                name: name,
                amount: amount,
                type: type,
                categoryId: categoryId,
                accountId: accountId,
                interval: interval,
                startDate: startDate,
                nextDueDate: nextDueDate,
                lastGeneratedDate: lastGeneratedDate,
                isActive: isActive,
                updatedAt: updatedAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> walletId = const Value.absent(),
                Value<String> uuid = const Value.absent(),
                required String name,
                required double amount,
                required TransactionType type,
                required int categoryId,
                required int accountId,
                required String interval,
                required DateTime startDate,
                required DateTime nextDueDate,
                Value<DateTime?> lastGeneratedDate = const Value.absent(),
                Value<bool> isActive = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
              }) => RecurringTransactionsCompanion.insert(
                id: id,
                walletId: walletId,
                uuid: uuid,
                name: name,
                amount: amount,
                type: type,
                categoryId: categoryId,
                accountId: accountId,
                interval: interval,
                startDate: startDate,
                nextDueDate: nextDueDate,
                lastGeneratedDate: lastGeneratedDate,
                isActive: isActive,
                updatedAt: updatedAt,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$RecurringTransactionsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $RecurringTransactionsTable,
      RecurringTransactionDb,
      $$RecurringTransactionsTableFilterComposer,
      $$RecurringTransactionsTableOrderingComposer,
      $$RecurringTransactionsTableAnnotationComposer,
      $$RecurringTransactionsTableCreateCompanionBuilder,
      $$RecurringTransactionsTableUpdateCompanionBuilder,
      (
        RecurringTransactionDb,
        BaseReferences<
          _$AppDatabase,
          $RecurringTransactionsTable,
          RecurringTransactionDb
        >,
      ),
      RecurringTransactionDb,
      PrefetchHooks Function()
    >;
typedef $$SmsImportMetricsTableCreateCompanionBuilder =
    SmsImportMetricsCompanion Function({
      Value<int> id,
      required int walletId,
      Value<int> acceptedImports,
      Value<int> rejectedImports,
      Value<int> duplicateDetections,
      Value<DateTime> updatedAt,
    });
typedef $$SmsImportMetricsTableUpdateCompanionBuilder =
    SmsImportMetricsCompanion Function({
      Value<int> id,
      Value<int> walletId,
      Value<int> acceptedImports,
      Value<int> rejectedImports,
      Value<int> duplicateDetections,
      Value<DateTime> updatedAt,
    });

class $$SmsImportMetricsTableFilterComposer
    extends Composer<_$AppDatabase, $SmsImportMetricsTable> {
  $$SmsImportMetricsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get walletId => $composableBuilder(
    column: $table.walletId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get acceptedImports => $composableBuilder(
    column: $table.acceptedImports,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get rejectedImports => $composableBuilder(
    column: $table.rejectedImports,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get duplicateDetections => $composableBuilder(
    column: $table.duplicateDetections,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$SmsImportMetricsTableOrderingComposer
    extends Composer<_$AppDatabase, $SmsImportMetricsTable> {
  $$SmsImportMetricsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get walletId => $composableBuilder(
    column: $table.walletId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get acceptedImports => $composableBuilder(
    column: $table.acceptedImports,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get rejectedImports => $composableBuilder(
    column: $table.rejectedImports,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get duplicateDetections => $composableBuilder(
    column: $table.duplicateDetections,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$SmsImportMetricsTableAnnotationComposer
    extends Composer<_$AppDatabase, $SmsImportMetricsTable> {
  $$SmsImportMetricsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get walletId =>
      $composableBuilder(column: $table.walletId, builder: (column) => column);

  GeneratedColumn<int> get acceptedImports => $composableBuilder(
    column: $table.acceptedImports,
    builder: (column) => column,
  );

  GeneratedColumn<int> get rejectedImports => $composableBuilder(
    column: $table.rejectedImports,
    builder: (column) => column,
  );

  GeneratedColumn<int> get duplicateDetections => $composableBuilder(
    column: $table.duplicateDetections,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$SmsImportMetricsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $SmsImportMetricsTable,
          SmsImportMetric,
          $$SmsImportMetricsTableFilterComposer,
          $$SmsImportMetricsTableOrderingComposer,
          $$SmsImportMetricsTableAnnotationComposer,
          $$SmsImportMetricsTableCreateCompanionBuilder,
          $$SmsImportMetricsTableUpdateCompanionBuilder,
          (
            SmsImportMetric,
            BaseReferences<
              _$AppDatabase,
              $SmsImportMetricsTable,
              SmsImportMetric
            >,
          ),
          SmsImportMetric,
          PrefetchHooks Function()
        > {
  $$SmsImportMetricsTableTableManager(
    _$AppDatabase db,
    $SmsImportMetricsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SmsImportMetricsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SmsImportMetricsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SmsImportMetricsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> walletId = const Value.absent(),
                Value<int> acceptedImports = const Value.absent(),
                Value<int> rejectedImports = const Value.absent(),
                Value<int> duplicateDetections = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
              }) => SmsImportMetricsCompanion(
                id: id,
                walletId: walletId,
                acceptedImports: acceptedImports,
                rejectedImports: rejectedImports,
                duplicateDetections: duplicateDetections,
                updatedAt: updatedAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int walletId,
                Value<int> acceptedImports = const Value.absent(),
                Value<int> rejectedImports = const Value.absent(),
                Value<int> duplicateDetections = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
              }) => SmsImportMetricsCompanion.insert(
                id: id,
                walletId: walletId,
                acceptedImports: acceptedImports,
                rejectedImports: rejectedImports,
                duplicateDetections: duplicateDetections,
                updatedAt: updatedAt,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$SmsImportMetricsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $SmsImportMetricsTable,
      SmsImportMetric,
      $$SmsImportMetricsTableFilterComposer,
      $$SmsImportMetricsTableOrderingComposer,
      $$SmsImportMetricsTableAnnotationComposer,
      $$SmsImportMetricsTableCreateCompanionBuilder,
      $$SmsImportMetricsTableUpdateCompanionBuilder,
      (
        SmsImportMetric,
        BaseReferences<_$AppDatabase, $SmsImportMetricsTable, SmsImportMetric>,
      ),
      SmsImportMetric,
      PrefetchHooks Function()
    >;
typedef $$TagsTableCreateCompanionBuilder =
    TagsCompanion Function({
      Value<int> id,
      Value<int> walletId,
      required String name,
      Value<String?> color,
    });
typedef $$TagsTableUpdateCompanionBuilder =
    TagsCompanion Function({
      Value<int> id,
      Value<int> walletId,
      Value<String> name,
      Value<String?> color,
    });

class $$TagsTableFilterComposer extends Composer<_$AppDatabase, $TagsTable> {
  $$TagsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get walletId => $composableBuilder(
    column: $table.walletId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get color => $composableBuilder(
    column: $table.color,
    builder: (column) => ColumnFilters(column),
  );
}

class $$TagsTableOrderingComposer extends Composer<_$AppDatabase, $TagsTable> {
  $$TagsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get walletId => $composableBuilder(
    column: $table.walletId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get color => $composableBuilder(
    column: $table.color,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$TagsTableAnnotationComposer
    extends Composer<_$AppDatabase, $TagsTable> {
  $$TagsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get walletId =>
      $composableBuilder(column: $table.walletId, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get color =>
      $composableBuilder(column: $table.color, builder: (column) => column);
}

class $$TagsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $TagsTable,
          Tag,
          $$TagsTableFilterComposer,
          $$TagsTableOrderingComposer,
          $$TagsTableAnnotationComposer,
          $$TagsTableCreateCompanionBuilder,
          $$TagsTableUpdateCompanionBuilder,
          (Tag, BaseReferences<_$AppDatabase, $TagsTable, Tag>),
          Tag,
          PrefetchHooks Function()
        > {
  $$TagsTableTableManager(_$AppDatabase db, $TagsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$TagsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$TagsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$TagsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> walletId = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String?> color = const Value.absent(),
              }) => TagsCompanion(
                id: id,
                walletId: walletId,
                name: name,
                color: color,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> walletId = const Value.absent(),
                required String name,
                Value<String?> color = const Value.absent(),
              }) => TagsCompanion.insert(
                id: id,
                walletId: walletId,
                name: name,
                color: color,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$TagsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $TagsTable,
      Tag,
      $$TagsTableFilterComposer,
      $$TagsTableOrderingComposer,
      $$TagsTableAnnotationComposer,
      $$TagsTableCreateCompanionBuilder,
      $$TagsTableUpdateCompanionBuilder,
      (Tag, BaseReferences<_$AppDatabase, $TagsTable, Tag>),
      Tag,
      PrefetchHooks Function()
    >;
typedef $$TransactionsTableCreateCompanionBuilder =
    TransactionsCompanion Function({
      Value<int> walletId,
      Value<int> id,
      Value<String> uuid,
      required double amount,
      required DateTime date,
      Value<String?> note,
      required TransactionType type,
      required int categoryId,
      required int accountId,
      Value<String?> transferGroupId,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
    });
typedef $$TransactionsTableUpdateCompanionBuilder =
    TransactionsCompanion Function({
      Value<int> walletId,
      Value<int> id,
      Value<String> uuid,
      Value<double> amount,
      Value<DateTime> date,
      Value<String?> note,
      Value<TransactionType> type,
      Value<int> categoryId,
      Value<int> accountId,
      Value<String?> transferGroupId,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
    });

class $$TransactionsTableFilterComposer
    extends Composer<_$AppDatabase, $TransactionsTable> {
  $$TransactionsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get walletId => $composableBuilder(
    column: $table.walletId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get uuid => $composableBuilder(
    column: $table.uuid,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<double, double, int> get amount =>
      $composableBuilder(
        column: $table.amount,
        builder: (column) => ColumnWithTypeConverterFilters(column),
      );

  ColumnFilters<DateTime> get date => $composableBuilder(
    column: $table.date,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get note => $composableBuilder(
    column: $table.note,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<TransactionType, TransactionType, String>
  get type => $composableBuilder(
    column: $table.type,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  ColumnFilters<int> get categoryId => $composableBuilder(
    column: $table.categoryId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get accountId => $composableBuilder(
    column: $table.accountId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get transferGroupId => $composableBuilder(
    column: $table.transferGroupId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$TransactionsTableOrderingComposer
    extends Composer<_$AppDatabase, $TransactionsTable> {
  $$TransactionsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get walletId => $composableBuilder(
    column: $table.walletId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get uuid => $composableBuilder(
    column: $table.uuid,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get amount => $composableBuilder(
    column: $table.amount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get date => $composableBuilder(
    column: $table.date,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get note => $composableBuilder(
    column: $table.note,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get type => $composableBuilder(
    column: $table.type,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get categoryId => $composableBuilder(
    column: $table.categoryId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get accountId => $composableBuilder(
    column: $table.accountId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get transferGroupId => $composableBuilder(
    column: $table.transferGroupId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$TransactionsTableAnnotationComposer
    extends Composer<_$AppDatabase, $TransactionsTable> {
  $$TransactionsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get walletId =>
      $composableBuilder(column: $table.walletId, builder: (column) => column);

  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get uuid =>
      $composableBuilder(column: $table.uuid, builder: (column) => column);

  GeneratedColumnWithTypeConverter<double, int> get amount =>
      $composableBuilder(column: $table.amount, builder: (column) => column);

  GeneratedColumn<DateTime> get date =>
      $composableBuilder(column: $table.date, builder: (column) => column);

  GeneratedColumn<String> get note =>
      $composableBuilder(column: $table.note, builder: (column) => column);

  GeneratedColumnWithTypeConverter<TransactionType, String> get type =>
      $composableBuilder(column: $table.type, builder: (column) => column);

  GeneratedColumn<int> get categoryId => $composableBuilder(
    column: $table.categoryId,
    builder: (column) => column,
  );

  GeneratedColumn<int> get accountId =>
      $composableBuilder(column: $table.accountId, builder: (column) => column);

  GeneratedColumn<String> get transferGroupId => $composableBuilder(
    column: $table.transferGroupId,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$TransactionsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $TransactionsTable,
          Transaction,
          $$TransactionsTableFilterComposer,
          $$TransactionsTableOrderingComposer,
          $$TransactionsTableAnnotationComposer,
          $$TransactionsTableCreateCompanionBuilder,
          $$TransactionsTableUpdateCompanionBuilder,
          (
            Transaction,
            BaseReferences<_$AppDatabase, $TransactionsTable, Transaction>,
          ),
          Transaction,
          PrefetchHooks Function()
        > {
  $$TransactionsTableTableManager(_$AppDatabase db, $TransactionsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$TransactionsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$TransactionsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$TransactionsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> walletId = const Value.absent(),
                Value<int> id = const Value.absent(),
                Value<String> uuid = const Value.absent(),
                Value<double> amount = const Value.absent(),
                Value<DateTime> date = const Value.absent(),
                Value<String?> note = const Value.absent(),
                Value<TransactionType> type = const Value.absent(),
                Value<int> categoryId = const Value.absent(),
                Value<int> accountId = const Value.absent(),
                Value<String?> transferGroupId = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
              }) => TransactionsCompanion(
                walletId: walletId,
                id: id,
                uuid: uuid,
                amount: amount,
                date: date,
                note: note,
                type: type,
                categoryId: categoryId,
                accountId: accountId,
                transferGroupId: transferGroupId,
                createdAt: createdAt,
                updatedAt: updatedAt,
              ),
          createCompanionCallback:
              ({
                Value<int> walletId = const Value.absent(),
                Value<int> id = const Value.absent(),
                Value<String> uuid = const Value.absent(),
                required double amount,
                required DateTime date,
                Value<String?> note = const Value.absent(),
                required TransactionType type,
                required int categoryId,
                required int accountId,
                Value<String?> transferGroupId = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
              }) => TransactionsCompanion.insert(
                walletId: walletId,
                id: id,
                uuid: uuid,
                amount: amount,
                date: date,
                note: note,
                type: type,
                categoryId: categoryId,
                accountId: accountId,
                transferGroupId: transferGroupId,
                createdAt: createdAt,
                updatedAt: updatedAt,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$TransactionsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $TransactionsTable,
      Transaction,
      $$TransactionsTableFilterComposer,
      $$TransactionsTableOrderingComposer,
      $$TransactionsTableAnnotationComposer,
      $$TransactionsTableCreateCompanionBuilder,
      $$TransactionsTableUpdateCompanionBuilder,
      (
        Transaction,
        BaseReferences<_$AppDatabase, $TransactionsTable, Transaction>,
      ),
      Transaction,
      PrefetchHooks Function()
    >;
typedef $$UnrecognizedSmsEntriesTableCreateCompanionBuilder =
    UnrecognizedSmsEntriesCompanion Function({
      Value<int> id,
      required int walletId,
      required String smsBody,
      required String sender,
      required DateTime receivedAt,
      Value<bool> isResolved,
      Value<DateTime> createdAt,
    });
typedef $$UnrecognizedSmsEntriesTableUpdateCompanionBuilder =
    UnrecognizedSmsEntriesCompanion Function({
      Value<int> id,
      Value<int> walletId,
      Value<String> smsBody,
      Value<String> sender,
      Value<DateTime> receivedAt,
      Value<bool> isResolved,
      Value<DateTime> createdAt,
    });

class $$UnrecognizedSmsEntriesTableFilterComposer
    extends Composer<_$AppDatabase, $UnrecognizedSmsEntriesTable> {
  $$UnrecognizedSmsEntriesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get walletId => $composableBuilder(
    column: $table.walletId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get smsBody => $composableBuilder(
    column: $table.smsBody,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get sender => $composableBuilder(
    column: $table.sender,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get receivedAt => $composableBuilder(
    column: $table.receivedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isResolved => $composableBuilder(
    column: $table.isResolved,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$UnrecognizedSmsEntriesTableOrderingComposer
    extends Composer<_$AppDatabase, $UnrecognizedSmsEntriesTable> {
  $$UnrecognizedSmsEntriesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get walletId => $composableBuilder(
    column: $table.walletId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get smsBody => $composableBuilder(
    column: $table.smsBody,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get sender => $composableBuilder(
    column: $table.sender,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get receivedAt => $composableBuilder(
    column: $table.receivedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isResolved => $composableBuilder(
    column: $table.isResolved,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$UnrecognizedSmsEntriesTableAnnotationComposer
    extends Composer<_$AppDatabase, $UnrecognizedSmsEntriesTable> {
  $$UnrecognizedSmsEntriesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get walletId =>
      $composableBuilder(column: $table.walletId, builder: (column) => column);

  GeneratedColumn<String> get smsBody =>
      $composableBuilder(column: $table.smsBody, builder: (column) => column);

  GeneratedColumn<String> get sender =>
      $composableBuilder(column: $table.sender, builder: (column) => column);

  GeneratedColumn<DateTime> get receivedAt => $composableBuilder(
    column: $table.receivedAt,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get isResolved => $composableBuilder(
    column: $table.isResolved,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);
}

class $$UnrecognizedSmsEntriesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $UnrecognizedSmsEntriesTable,
          UnrecognizedSms,
          $$UnrecognizedSmsEntriesTableFilterComposer,
          $$UnrecognizedSmsEntriesTableOrderingComposer,
          $$UnrecognizedSmsEntriesTableAnnotationComposer,
          $$UnrecognizedSmsEntriesTableCreateCompanionBuilder,
          $$UnrecognizedSmsEntriesTableUpdateCompanionBuilder,
          (
            UnrecognizedSms,
            BaseReferences<
              _$AppDatabase,
              $UnrecognizedSmsEntriesTable,
              UnrecognizedSms
            >,
          ),
          UnrecognizedSms,
          PrefetchHooks Function()
        > {
  $$UnrecognizedSmsEntriesTableTableManager(
    _$AppDatabase db,
    $UnrecognizedSmsEntriesTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$UnrecognizedSmsEntriesTableFilterComposer(
                $db: db,
                $table: table,
              ),
          createOrderingComposer: () =>
              $$UnrecognizedSmsEntriesTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer: () =>
              $$UnrecognizedSmsEntriesTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> walletId = const Value.absent(),
                Value<String> smsBody = const Value.absent(),
                Value<String> sender = const Value.absent(),
                Value<DateTime> receivedAt = const Value.absent(),
                Value<bool> isResolved = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
              }) => UnrecognizedSmsEntriesCompanion(
                id: id,
                walletId: walletId,
                smsBody: smsBody,
                sender: sender,
                receivedAt: receivedAt,
                isResolved: isResolved,
                createdAt: createdAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int walletId,
                required String smsBody,
                required String sender,
                required DateTime receivedAt,
                Value<bool> isResolved = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
              }) => UnrecognizedSmsEntriesCompanion.insert(
                id: id,
                walletId: walletId,
                smsBody: smsBody,
                sender: sender,
                receivedAt: receivedAt,
                isResolved: isResolved,
                createdAt: createdAt,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$UnrecognizedSmsEntriesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $UnrecognizedSmsEntriesTable,
      UnrecognizedSms,
      $$UnrecognizedSmsEntriesTableFilterComposer,
      $$UnrecognizedSmsEntriesTableOrderingComposer,
      $$UnrecognizedSmsEntriesTableAnnotationComposer,
      $$UnrecognizedSmsEntriesTableCreateCompanionBuilder,
      $$UnrecognizedSmsEntriesTableUpdateCompanionBuilder,
      (
        UnrecognizedSms,
        BaseReferences<
          _$AppDatabase,
          $UnrecognizedSmsEntriesTable,
          UnrecognizedSms
        >,
      ),
      UnrecognizedSms,
      PrefetchHooks Function()
    >;
typedef $$WalletActivitiesTableCreateCompanionBuilder =
    WalletActivitiesCompanion Function({
      Value<int> id,
      required int walletId,
      Value<String> uuid,
      Value<int?> actorAccountId,
      Value<int?> actorMemberId,
      required String action,
      required String entityType,
      required int entityId,
      Value<String?> entityUuid,
      Value<String?> details,
      Value<String?> metadata,
      required String source,
      Value<DateTime> createdAt,
    });
typedef $$WalletActivitiesTableUpdateCompanionBuilder =
    WalletActivitiesCompanion Function({
      Value<int> id,
      Value<int> walletId,
      Value<String> uuid,
      Value<int?> actorAccountId,
      Value<int?> actorMemberId,
      Value<String> action,
      Value<String> entityType,
      Value<int> entityId,
      Value<String?> entityUuid,
      Value<String?> details,
      Value<String?> metadata,
      Value<String> source,
      Value<DateTime> createdAt,
    });

class $$WalletActivitiesTableFilterComposer
    extends Composer<_$AppDatabase, $WalletActivitiesTable> {
  $$WalletActivitiesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get walletId => $composableBuilder(
    column: $table.walletId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get uuid => $composableBuilder(
    column: $table.uuid,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get actorAccountId => $composableBuilder(
    column: $table.actorAccountId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get actorMemberId => $composableBuilder(
    column: $table.actorMemberId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get action => $composableBuilder(
    column: $table.action,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get entityType => $composableBuilder(
    column: $table.entityType,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get entityId => $composableBuilder(
    column: $table.entityId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get entityUuid => $composableBuilder(
    column: $table.entityUuid,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get details => $composableBuilder(
    column: $table.details,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get metadata => $composableBuilder(
    column: $table.metadata,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get source => $composableBuilder(
    column: $table.source,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$WalletActivitiesTableOrderingComposer
    extends Composer<_$AppDatabase, $WalletActivitiesTable> {
  $$WalletActivitiesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get walletId => $composableBuilder(
    column: $table.walletId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get uuid => $composableBuilder(
    column: $table.uuid,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get actorAccountId => $composableBuilder(
    column: $table.actorAccountId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get actorMemberId => $composableBuilder(
    column: $table.actorMemberId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get action => $composableBuilder(
    column: $table.action,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get entityType => $composableBuilder(
    column: $table.entityType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get entityId => $composableBuilder(
    column: $table.entityId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get entityUuid => $composableBuilder(
    column: $table.entityUuid,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get details => $composableBuilder(
    column: $table.details,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get metadata => $composableBuilder(
    column: $table.metadata,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get source => $composableBuilder(
    column: $table.source,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$WalletActivitiesTableAnnotationComposer
    extends Composer<_$AppDatabase, $WalletActivitiesTable> {
  $$WalletActivitiesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get walletId =>
      $composableBuilder(column: $table.walletId, builder: (column) => column);

  GeneratedColumn<String> get uuid =>
      $composableBuilder(column: $table.uuid, builder: (column) => column);

  GeneratedColumn<int> get actorAccountId => $composableBuilder(
    column: $table.actorAccountId,
    builder: (column) => column,
  );

  GeneratedColumn<int> get actorMemberId => $composableBuilder(
    column: $table.actorMemberId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get action =>
      $composableBuilder(column: $table.action, builder: (column) => column);

  GeneratedColumn<String> get entityType => $composableBuilder(
    column: $table.entityType,
    builder: (column) => column,
  );

  GeneratedColumn<int> get entityId =>
      $composableBuilder(column: $table.entityId, builder: (column) => column);

  GeneratedColumn<String> get entityUuid => $composableBuilder(
    column: $table.entityUuid,
    builder: (column) => column,
  );

  GeneratedColumn<String> get details =>
      $composableBuilder(column: $table.details, builder: (column) => column);

  GeneratedColumn<String> get metadata =>
      $composableBuilder(column: $table.metadata, builder: (column) => column);

  GeneratedColumn<String> get source =>
      $composableBuilder(column: $table.source, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);
}

class $$WalletActivitiesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $WalletActivitiesTable,
          WalletActivity,
          $$WalletActivitiesTableFilterComposer,
          $$WalletActivitiesTableOrderingComposer,
          $$WalletActivitiesTableAnnotationComposer,
          $$WalletActivitiesTableCreateCompanionBuilder,
          $$WalletActivitiesTableUpdateCompanionBuilder,
          (
            WalletActivity,
            BaseReferences<
              _$AppDatabase,
              $WalletActivitiesTable,
              WalletActivity
            >,
          ),
          WalletActivity,
          PrefetchHooks Function()
        > {
  $$WalletActivitiesTableTableManager(
    _$AppDatabase db,
    $WalletActivitiesTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$WalletActivitiesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$WalletActivitiesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$WalletActivitiesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> walletId = const Value.absent(),
                Value<String> uuid = const Value.absent(),
                Value<int?> actorAccountId = const Value.absent(),
                Value<int?> actorMemberId = const Value.absent(),
                Value<String> action = const Value.absent(),
                Value<String> entityType = const Value.absent(),
                Value<int> entityId = const Value.absent(),
                Value<String?> entityUuid = const Value.absent(),
                Value<String?> details = const Value.absent(),
                Value<String?> metadata = const Value.absent(),
                Value<String> source = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
              }) => WalletActivitiesCompanion(
                id: id,
                walletId: walletId,
                uuid: uuid,
                actorAccountId: actorAccountId,
                actorMemberId: actorMemberId,
                action: action,
                entityType: entityType,
                entityId: entityId,
                entityUuid: entityUuid,
                details: details,
                metadata: metadata,
                source: source,
                createdAt: createdAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int walletId,
                Value<String> uuid = const Value.absent(),
                Value<int?> actorAccountId = const Value.absent(),
                Value<int?> actorMemberId = const Value.absent(),
                required String action,
                required String entityType,
                required int entityId,
                Value<String?> entityUuid = const Value.absent(),
                Value<String?> details = const Value.absent(),
                Value<String?> metadata = const Value.absent(),
                required String source,
                Value<DateTime> createdAt = const Value.absent(),
              }) => WalletActivitiesCompanion.insert(
                id: id,
                walletId: walletId,
                uuid: uuid,
                actorAccountId: actorAccountId,
                actorMemberId: actorMemberId,
                action: action,
                entityType: entityType,
                entityId: entityId,
                entityUuid: entityUuid,
                details: details,
                metadata: metadata,
                source: source,
                createdAt: createdAt,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$WalletActivitiesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $WalletActivitiesTable,
      WalletActivity,
      $$WalletActivitiesTableFilterComposer,
      $$WalletActivitiesTableOrderingComposer,
      $$WalletActivitiesTableAnnotationComposer,
      $$WalletActivitiesTableCreateCompanionBuilder,
      $$WalletActivitiesTableUpdateCompanionBuilder,
      (
        WalletActivity,
        BaseReferences<_$AppDatabase, $WalletActivitiesTable, WalletActivity>,
      ),
      WalletActivity,
      PrefetchHooks Function()
    >;
typedef $$UsersTableCreateCompanionBuilder =
    UsersCompanion Function({
      Value<int> id,
      Value<String> uuid,
      required String displayName,
      Value<String?> email,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
    });
typedef $$UsersTableUpdateCompanionBuilder =
    UsersCompanion Function({
      Value<int> id,
      Value<String> uuid,
      Value<String> displayName,
      Value<String?> email,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
    });

class $$UsersTableFilterComposer extends Composer<_$AppDatabase, $UsersTable> {
  $$UsersTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get uuid => $composableBuilder(
    column: $table.uuid,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get displayName => $composableBuilder(
    column: $table.displayName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get email => $composableBuilder(
    column: $table.email,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$UsersTableOrderingComposer
    extends Composer<_$AppDatabase, $UsersTable> {
  $$UsersTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get uuid => $composableBuilder(
    column: $table.uuid,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get displayName => $composableBuilder(
    column: $table.displayName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get email => $composableBuilder(
    column: $table.email,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$UsersTableAnnotationComposer
    extends Composer<_$AppDatabase, $UsersTable> {
  $$UsersTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get uuid =>
      $composableBuilder(column: $table.uuid, builder: (column) => column);

  GeneratedColumn<String> get displayName => $composableBuilder(
    column: $table.displayName,
    builder: (column) => column,
  );

  GeneratedColumn<String> get email =>
      $composableBuilder(column: $table.email, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$UsersTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $UsersTable,
          User,
          $$UsersTableFilterComposer,
          $$UsersTableOrderingComposer,
          $$UsersTableAnnotationComposer,
          $$UsersTableCreateCompanionBuilder,
          $$UsersTableUpdateCompanionBuilder,
          (User, BaseReferences<_$AppDatabase, $UsersTable, User>),
          User,
          PrefetchHooks Function()
        > {
  $$UsersTableTableManager(_$AppDatabase db, $UsersTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$UsersTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$UsersTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$UsersTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> uuid = const Value.absent(),
                Value<String> displayName = const Value.absent(),
                Value<String?> email = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
              }) => UsersCompanion(
                id: id,
                uuid: uuid,
                displayName: displayName,
                email: email,
                createdAt: createdAt,
                updatedAt: updatedAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> uuid = const Value.absent(),
                required String displayName,
                Value<String?> email = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
              }) => UsersCompanion.insert(
                id: id,
                uuid: uuid,
                displayName: displayName,
                email: email,
                createdAt: createdAt,
                updatedAt: updatedAt,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$UsersTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $UsersTable,
      User,
      $$UsersTableFilterComposer,
      $$UsersTableOrderingComposer,
      $$UsersTableAnnotationComposer,
      $$UsersTableCreateCompanionBuilder,
      $$UsersTableUpdateCompanionBuilder,
      (User, BaseReferences<_$AppDatabase, $UsersTable, User>),
      User,
      PrefetchHooks Function()
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$AccountsTableTableManager get accounts =>
      $$AccountsTableTableManager(_db, _db.accounts);
  $$WalletBillsTableTableManager get walletBills =>
      $$WalletBillsTableTableManager(_db, _db.walletBills);
  $$BudgetsTableTableManager get budgets =>
      $$BudgetsTableTableManager(_db, _db.budgets);
  $$CategoriesTableTableManager get categories =>
      $$CategoriesTableTableManager(_db, _db.categories);
  $$WalletNotificationsTableTableManager get walletNotifications =>
      $$WalletNotificationsTableTableManager(_db, _db.walletNotifications);
  $$LoansTableTableManager get loans =>
      $$LoansTableTableManager(_db, _db.loans);
  $$PeerDebtsTableTableManager get peerDebts =>
      $$PeerDebtsTableTableManager(_db, _db.peerDebts);
  $$WalletAllowancesTableTableManager get walletAllowances =>
      $$WalletAllowancesTableTableManager(_db, _db.walletAllowances);
  $$WalletAllowancePaymentsTableTableManager get walletAllowancePayments =>
      $$WalletAllowancePaymentsTableTableManager(
        _db,
        _db.walletAllowancePayments,
      );
  $$WalletSettlementsTableTableManager get walletSettlements =>
      $$WalletSettlementsTableTableManager(_db, _db.walletSettlements);
  $$WalletsTableTableManager get wallets =>
      $$WalletsTableTableManager(_db, _db.wallets);
  $$WalletInvitationsTableTableManager get walletInvitations =>
      $$WalletInvitationsTableTableManager(_db, _db.walletInvitations);
  $$WalletMembersTableTableManager get walletMembers =>
      $$WalletMembersTableTableManager(_db, _db.walletMembers);
  $$WalletGoalsTableTableManager get walletGoals =>
      $$WalletGoalsTableTableManager(_db, _db.walletGoals);
  $$WalletGoalContributionsTableTableManager get walletGoalContributions =>
      $$WalletGoalContributionsTableTableManager(
        _db,
        _db.walletGoalContributions,
      );
  $$WalletGoalSchedulesTableTableManager get walletGoalSchedules =>
      $$WalletGoalSchedulesTableTableManager(_db, _db.walletGoalSchedules);
  $$FeedbackEntriesTableTableManager get feedbackEntries =>
      $$FeedbackEntriesTableTableManager(_db, _db.feedbackEntries);
  $$WalletNotificationPreferencesTableTableManager
  get walletNotificationPreferences =>
      $$WalletNotificationPreferencesTableTableManager(
        _db,
        _db.walletNotificationPreferences,
      );
  $$DeletedRecordsTableTableManager get deletedRecords =>
      $$DeletedRecordsTableTableManager(_db, _db.deletedRecords);
  $$AttachmentsTableTableManager get attachments =>
      $$AttachmentsTableTableManager(_db, _db.attachments);
  $$WalletExpenseSplitsTableTableManager get walletExpenseSplits =>
      $$WalletExpenseSplitsTableTableManager(_db, _db.walletExpenseSplits);
  $$WalletExpenseSplitMembersTableTableManager get walletExpenseSplitMembers =>
      $$WalletExpenseSplitMembersTableTableManager(
        _db,
        _db.walletExpenseSplitMembers,
      );
  $$MerchantMappingsTableTableManager get merchantMappings =>
      $$MerchantMappingsTableTableManager(_db, _db.merchantMappings);
  $$PayeesTableTableManager get payees =>
      $$PayeesTableTableManager(_db, _db.payees);
  $$RecurringTransactionsTableTableManager get recurringTransactions =>
      $$RecurringTransactionsTableTableManager(_db, _db.recurringTransactions);
  $$SmsImportMetricsTableTableManager get smsImportMetrics =>
      $$SmsImportMetricsTableTableManager(_db, _db.smsImportMetrics);
  $$TagsTableTableManager get tags => $$TagsTableTableManager(_db, _db.tags);
  $$TransactionsTableTableManager get transactions =>
      $$TransactionsTableTableManager(_db, _db.transactions);
  $$UnrecognizedSmsEntriesTableTableManager get unrecognizedSmsEntries =>
      $$UnrecognizedSmsEntriesTableTableManager(
        _db,
        _db.unrecognizedSmsEntries,
      );
  $$WalletActivitiesTableTableManager get walletActivities =>
      $$WalletActivitiesTableTableManager(_db, _db.walletActivities);
  $$UsersTableTableManager get users =>
      $$UsersTableTableManager(_db, _db.users);
}

mixin _$GoalDaoMixin on DatabaseAccessor<AppDatabase> {
  $WalletGoalsTable get walletGoals => attachedDatabase.walletGoals;
  $WalletGoalContributionsTable get walletGoalContributions =>
      attachedDatabase.walletGoalContributions;
  $WalletGoalSchedulesTable get walletGoalSchedules =>
      attachedDatabase.walletGoalSchedules;
  GoalDaoManager get managers => GoalDaoManager(this);
}

class GoalDaoManager {
  final _$GoalDaoMixin _db;
  GoalDaoManager(this._db);
  $$WalletGoalsTableTableManager get walletGoals =>
      $$WalletGoalsTableTableManager(_db.attachedDatabase, _db.walletGoals);
  $$WalletGoalContributionsTableTableManager get walletGoalContributions =>
      $$WalletGoalContributionsTableTableManager(
        _db.attachedDatabase,
        _db.walletGoalContributions,
      );
  $$WalletGoalSchedulesTableTableManager get walletGoalSchedules =>
      $$WalletGoalSchedulesTableTableManager(
        _db.attachedDatabase,
        _db.walletGoalSchedules,
      );
}
