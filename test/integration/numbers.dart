part of integrationtests;

Future deleteInsertSelect(ConnectionPool pool, table, insert, select) {
  return pool.query('delete from $table').then((_) {
    return pool.query(insert);
  }).then((_) {
    return pool.query(select);
  });
}

void runNumberTests(String user, String password, String db, int port, String host) {
  ConnectionPool pool;
  group('number tests:', () {
    test('setup', () {
      pool = new ConnectionPool(user:user, password:password, db:db, port:port, host:host, max:1);
      return setup(pool, "nums", "create table nums ("
          "atinyint tinyint, asmallint smallint, amediumint mediumint, aint int, abigint bigint, "
          "utinyint tinyint unsigned, usmallint smallint unsigned, umediumint mediumint unsigned, uint int unsigned, ubigint bigint unsigned, "
          "adecimal decimal(20,10), afloat float, adouble double, areal real)",
        "insert into nums (atinyint, asmallint, amediumint, aint, abigint) values ("
        "-128, -32768, -8388608, -2147483648, -9223372036854775808)");
    });

    test('minimum values', () {
      var c = new Completer();
      pool.query('select atinyint, asmallint, amediumint, aint, abigint from nums').then(expectAsync1((Results results) {
        results.stream.listen((row) {
          expect(row[0], equals(-128));
          expect(row[1], equals(-32768));
          expect(row[2], equals(-8388608));
          expect(row[3], equals(-2147483648));
          expect(row[4], equals(-9223372036854775808));
        }, onDone: () {
          c.complete();
        });
      }));
      return c.future;
    });
    
    test('maximum values', () {
      var c = new Completer();
      deleteInsertSelect(pool, 'nums', 
          "insert into nums (atinyint, asmallint, amediumint, aint, abigint, "
          "adecimal, afloat, adouble, areal) values ("
          "127, 32767, 8388607, 2147483647, 9223372036854775807, "
          "0, 0, 0, 0)", 
          'select atinyint, asmallint, amediumint, aint, abigint from nums').then((results) {
        results.stream.listen((row) {
          expect(row[0], equals(127));
          expect(row[1], equals(32767));
          expect(row[2], equals(8388607));
          expect(row[3], equals(2147483647));
          expect(row[4], equals(9223372036854775807));
        }, onDone: () {
          c.complete();
        });
      });
    });

    test('maximum unsigned values', () {
      var c = new Completer();
      deleteInsertSelect(pool, 'nums',
          "insert into nums (utinyint, usmallint, umediumint, uint, ubigint) values ("
          "255, 65535, 12777215, 4294967295, 18446744073709551615)",
          'select atinyint, asmallint, amediumint, aint, abigint from nums').then((results) {
        results.stream.listen((row) {
          expect(row[0], equals(255));
          expect(row[1], equals(65535));
          expect(row[2], equals(12777215));
          expect(row[3], equals(4294967295));
          expect(row[4], equals(18446744073709551615));
        }, onDone: () {
          c.complete();
        });
      });
    });

    test('max decimal', () {
      var c = new Completer();
      deleteInsertSelect(pool, 'nums',
          "insert into nums (adecimal) values ("
          "99999999999999999999.9999999999)",
          'select adecimal from nums').then((results) {
        results.stream.listen((row) {
          expect(row[0], equals(99999999999999999999.9999999999));
        }, onDone: () {
          c.complete();
        });
      });
    });

    test('min decimal', () {
      var c = new Completer();
      deleteInsertSelect(pool, 'nums',
          "insert into nums (adecimal) values ("
          "-99999999999999999999.9999999999)",
          'select adecimal from nums').then((results) {
        results.stream.listen((row) {
          expect(row[0], equals(-99999999999999999999.9999999999));
        }, onDone: () {
          c.complete();
        });
      });
    });

    test('close connection', () {
      pool.close();
    });
  });
}
