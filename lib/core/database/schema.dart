import 'package:sqflite/sqflite.dart';

Future<void> createSchema(Database db) async {
  // cliente
  await db.execute('''
    CREATE TABLE IF NOT EXISTS cliente (
      id          INTEGER PRIMARY KEY,
      nome        TEXT NOT NULL,
      telefone    TEXT NOT NULL CHECK ( 
        telefone NOT GLOB '*[^0-9]*' AND length(telefone) BETWEEN 7 AND 15
      ),
      criado_em   TEXT NOT NULL DEFAULT (
        strftime('%Y-%m-%dT%H:%M:%fZ', 'now')
      ),
      ativo       INTEGER NOT NULL DEFAULT 1 CHECK (ativo IN (0, 1))
    )
  ''');

  // servico
  await db.execute('''
    CREATE TABLE IF NOT EXISTS servico (
      id      INTEGER PRIMARY KEY,
      nome    TEXT NOT NULL,
      preco   INTEGER NOT NULL CHECK (
        typeof(preco) = 'integer' AND preco >= 0
      ),
      ativo   INTEGER NOT NULL DEFAULT 1 CHECK (ativo IN (0, 1))
    )
  ''');

  // agendamento
  await db.execute('''
    CREATE TABLE IF NOT EXISTS agendamento (
      id          INTEGER PRIMARY KEY,
      cliente_id  INTEGER NOT NULL,
      servico_id  INTEGER NOT NULL,
      data_hora   TEXT NOT NULL CHECK (
        strftime('%Y-%m-%dT%H:%M:%fZ', data_hora) IS data_hora
      ),
      observacoes TEXT,
      criado_em   TEXT NOT NULL DEFAULT (
        strftime('%Y-%m-%dT%H:%M:%fZ', 'now')
      ),
      FOREIGN KEY (cliente_id) REFERENCES cliente(id)
          ON DELETE RESTRICT ON UPDATE CASCADE,
      FOREIGN KEY (servico_id) REFERENCES servico(id)
          ON DELETE RESTRICT ON UPDATE CASCADE
    )
  ''');

  // atendimento
  await db.execute('''
    CREATE TABLE IF NOT EXISTS atendimento (
      agendamento_id  INTEGER PRIMARY KEY,
      valor_cobrado   INTEGER NOT NULL CHECK (
        typeof(valor_cobrado) = 'integer' AND valor_cobrado >= 0
      ),
      realizado_em    TEXT NOT NULL CHECK (
        strftime('%Y-%m-%dT%H:%M:%fZ', realizado_em) IS realizado_em
      ),
      registrado_em   TEXT NOT NULL DEFAULT (
        strftime('%Y-%m-%dT%H:%M:%fZ', 'now')
      ),
      FOREIGN KEY (agendamento_id) REFERENCES agendamento(id)
          ON DELETE RESTRICT ON UPDATE CASCADE
    )
  ''');

  // índices
  await db.execute('''
    CREATE INDEX IF NOT EXISTS idx_agendamento_cliente
      ON agendamento (cliente_id)
  ''');

  await db.execute('''
    CREATE INDEX IF NOT EXISTS idx_agendamento_servico
      ON agendamento (servico_id)
  ''');

  await db.execute('''
    CREATE INDEX IF NOT EXISTS idx_agendamento_data_hora
      ON agendamento (data_hora)
  ''');
}