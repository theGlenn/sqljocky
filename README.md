SQLJocky
========

This is a MySQL connector for the Dart programming language. It isn't finished, but should
work for most normal use. Expect this code to change though, possibly massively, 
in the near future.

News
----

* v0.6.1: Support for latest SDK
* v0.6.0: Change prepared statement syntax. Values must now be passed into the execute() method
in an array. This change was made because otherwise prepared statements couldn't be used
asynchronously correctly - if you used the same prepared query object for multiple queries 
'at the same time', the wrong values could get used.
* v0.5.8: Handle errors in the utils package properly. Pre-emptively fixed some errors, wrote more tests.
* v0.5.7: Fixed error with large fields.
* v0.5.6: Hopefully full unicode support, and fixed problem with null values in prepared queries.
* v0.5.5: Some initial changes for better unicode handling.
* v0.5.4: Blobs and Texts which are bigger than 250 characters now work.
* v0.5.3: Make ConnectionPool and Transaction implement QueriableConnection, and improved tests.
* v0.5.2: Fix for new SDK
* v0.5.1: Made an internal class private
* v0.5.0: Breaking change: Now uses streams to return results.
* v0.4.1: Major refactoring so that only the parts of sqljocky which are supposed to be exposed are.
* v0.4.0: Support for M4.
* v0.3.0: Support for M3. Bit fields are now numbers, not lists. Dates now use the DateTime class instead of the Date class. Use new IO classes.
* v0.2.0: Support for the new SDK. 
* v0.1.3: SQLJocky now uses a connection pooling model, so the API has changed somewhat.

Usage
-----

Create a connection pool:

	var pool = new ConnectionPool(host: 'localhost', port: 3306, user: 'bob', password: 'wibble', db: 'stuff', max: 5);

Execute a query:

	pool.query('select name, email from users').then((result) {...});

Use the results:

	results.stream.listen((row) {
		print('Name: ${row[0]}, email: ${row[1]}');
	}

Prepare a query:

	pool.prepare('insert into users (name, email, age) values (?, ?, ?)').then((query) {...});

Execute the query:

	query.execute(['Bob', 'bob@bob.com', 25]).then((result) {...});

An insert query's results will be empty, but will have an id if there was an auto-increment column in the table:

	print("New user's id: ${result.insertId}");

Execute a query with multiple sets of parameters:

	query.executeMulti([['Bob', 'bob@bob.com', 25],
			['Bill', 'bill@bill.com', 26],
			['Joe', 'joe@joe.com', 37]]).then((results) {...}); 
			
Use the list of results:

	for (result in results) {
		print("New user's id: ${result.insertId}");
	}

Use a transaction:

	pool.startTransaction().then((trans) {
		trans.query('...').then((result) {
			trans.commit().then(() {...});
		});
	});

Development
-----------

To run the examples and tests, you'll need to create a 'connection.options' file by
copying 'connection.options.example' and modifying the settings.

Licence
-------

It is released under the GPL, because it uses a modified part of mysql's include/mysql_com.h in constants.dart, 
which is licensed under the GPL. I would prefer to release it under the BSD Licence, but there you go.

The Name
--------

It is named after [Jocky Wilson](http://en.wikipedia.org/wiki/Jocky_Wilson), the late, great 
darts player. (Hence the lack of an 'e' in Jocky.)

Things to do
------------

* Compression
* SSL
* Larger than 16MB packets
* Handle character sets properly
* COM_SEND_LONG_DATA
* Better handling of various data types, especially BLOBs, which behave differently when using straight queries and prepared queries.
* Implement the rest of mysql's commands
* Improve performance where possible
* More unit testing
* More integration tests
* DartDoc
* More Example code
* Use idiomatic dart where possible
* Geometry type
* Decimal type should probably use a bigdecimal type of some sort
* MySQL 4 types (old decimal, anything else?)
* Test against multiple mysql versions

