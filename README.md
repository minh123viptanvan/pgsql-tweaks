# [PostgreSQL](https://www.postgresql.org) Views and Functions

The functions and views published in this repository are some of those, which I
regularly need in my daily job.

As these procedures are sort of essential, at least to me, I install them in the
public schema. That way they are available for everyone without having to know
a schema name.

All functions and views are covered by tests. The tests are done in simple SQL
statements. Each test does raise division by zero if it fails.

# Table of content

1 [List of functions](#List-of-functions)

1.1 [Functions to check data types](#Functions-to-check-data-types)

1.1.1 [FUNCTION is_date](#FUNCTION-is_date)<br />
1.1.2 [FUNCTION is_time](#FUNCTION-is_time)<br />
1.1.3 [FUNCTION is_timestamp](#FUNCTION-is_timestamp)<br />
1.1.4 [FUNCTION is_numeric](#FUNCTION-is_numeric)<br />
1.1.5 [FUNCTION is_integer](#FUNCTION-is_integer)

1.2 [Functions about encryption](#Functions-about-encryption)

1.2.1 [FUNCTION sha256](#FUNCTION-sha256)

1.3 [Functions and views to get extended system information](#Functions-and-views-to-get-extended-system-information)

1.3.1 [FUNCTION pg_schema_size](#FUNCTION-pg_schema_size)

1.4 [Functions about encodings](#Functions-about-encodings)

1.4.1 [FUNCTION is_encoding](#FUNCTION-is_encoding)<br />
1.4.2 [FUNCTION is_latin1](#FUNCTION-is_latin1)<br />
1.4.3 [FUNCTION return_not_part_of_latin1](#FUNCTION-return_not_part_of_latin1)<br />
1.4.4 [FUNCTION replace_latin1](#FUNCTION-replace_latin1)<br />
1.4.4.1 [replace_latin1\(s VARCHAR\)](#replace_latin1-s-varchar-)<br />
1.4.4.2 [replace_latin1\(s VARCHAR, replacement VARCHAR\)](#replace_latin1-s-varchar-replacement-varchar-)<br />
1.4.4.3 [replace_latin1\(s VARCHAR, s_search VARCHAR\[\], s_replace VARCHAR\[\]\)](#replace_latin1-s-varchar-s_search-varchar-s_replace-varchar-)<br />
1.4.5 [FUNCTION return_not_part_of_encoding](#FUNCTION-return_not_part_of_encoding)<br />
1.4.6 [FUNCTION replace_encoding](#FUNCTION-replace_encoding)<br />
1.4.6.1 [replace_encoding\(s VARCHAR, e VARCHAR\)](#replace_encoding-s-varchar-e-varchar-)<br />
1.4.6.2 [replace_encoding\(s VARCHAR, e VARCHAR, replacement VARCHAR\)](#replace_encoding-s-varchar-e-varchar-replacement-varchar-)<br />
1.4.6.3 [replace_encoding\(s VARCHAR, s_search VARCHAR\[\], s_replace VARCHAR\[\]\)](#replace_encoding-s-varchar-s_search-varchar-s_replace-varchar-)

1.5 [User defined aggregates](#User-defined-aggregates)

1.5.1 [AGGREGATE gap_fil](#AGGREGATE-gap_fil)

# List of functions

## Functions to check data types

### FUNCTION is_date

The function checks strings for being a date.<br />
You might pass a second parameter to use a format string. Without the format,
the default format of PostgreSQL is used.

#### Examples

```sql
/**
 * Parameter is in PostgreSQL default format
 */
SELECT is_date('2018-01-01') AS res;
```

Result:

| res |
|:---:|
| t   |

```sql
SELECT is_date('2018-02-31') AS res;
```

Result:

| res |
|:---:|
| f   |

```sql
/**
 * Parameter is in PostgreSQL German format
 */
SELECT is_date('01.01.2018', 'DD.MM.YYYY') AS res;
```

Result:

| res |
|:---:|
| t   |


```sql
SELECT is_date('31.02.2018', 'DD.MM.YYYY') AS res;
```

Result:

| res |
|:---:|
| f   |

### FUNCTION is_time

The function checks strings for being a time.<br />
You might pass a second parameter to use a format string. Without the format,
the default format of PostgreSQL is used.

#### Examples

```sql
/**
 * Parameter is in PostgreSQL default format
 */
SELECT is_time('14:33:55.456574') AS res;
```

Result:

| res |
|:---:|
| t   |

```sql
SELECT is_time('25:33:55.456574') AS res;
```

Result:

| res |
|:---:|
| f   |

```sql
/**
 * Parameter is some time format
 */
SELECT is_time('14.33.55,456574', 'HH24.MI.SS,US') AS res;
```

Result:

| res |
|:---:|
| t   |


```sql
SELECT is_time('25.33.55,456574', 'HH24.MI.SS,US') AS res;
```

Result:

| res |
|:---:|
| f   |

### FUNCTION is_timestamp
The function checks strings for being a timestamp.<br />
You might pass a second parameter to use a format string. Without the format,
the default format of PostgreSQL is used.

#### Examples

```sql
/**
 * Parameter is in PostgreSQL default format
 */
SELECT is_timestamp('2018-01-01 00:00:00') AS res;
```

Result:

| res |
|:---:|
| t   |

```sql
SELECT is_timestamp('2018-01-01 25:00:00') AS res;
-- Result is false
```

Result:

| res |
|:---:|
| f   |

```sql
/**
 * Parameter is in PostgreSQL German format
 */
SELECT is_timestamp('01.01.2018 00:00:00', 'DD.MM.YYYY HH24.MI.SS') AS res;
```

Result:

| res |
|:---:|
| t   |

```sql
SELECT is_timestamp('01.01.2018 25:00:00', 'DD.MM.YYYY HH24.MI.SS') AS res;
```

Result:

| res |
|:---:|
| f   |

### FUNCTION is_numeric

The function checks strings for being numeric.

#### Examples

```sql
SELECT is_numeric('123') AS res;
```
Result:

| res |
|:---:|
| t   |

```sql
SELECT is_numeric('1 2') AS res;
-- Result is false
```

Result:

| res |
|:---:|
| f   |

### FUNCTION is_integer

The function checks strings for being an integer.

#### Examples

```sql
SELECT is_integer('123') AS res;
-- Result is true
```

Result:

| res |
|:---:|
| t   |

```sql
SELECT is_integer('123.456') AS res;
-- Result is false
```

Result:

| res |
|:---:|
| f   |


## Functions about encryption

### FUNCTION sha256

Creates a function which returns a SHA256 hash for the given string.<br />
The parameter has to be converted into a binary string of [bytea](https://www.postgresql.org/docs/current/static/datatype-binary.html).</br>
:heavy_exclamation_mark:<span style="color:red">The function needs the [pgcrypto](https://www.postgresql.org/docs/current/static/pgcrypto.html) package</span>:heavy_exclamation_mark:

#### Example

```sql
SELECT sha256('test-string'::bytea) AS res;
```

Result:

| res |
|:---:|
| ffe65f1d98fafedea3514adc956c8ada5980c6c5d2552fd61f48401aefd5c00e |


## Functions and views to get extended system information

### FUNCTION pg_schema_size

The function returns the size for schema given as parameter in bytes.

#### Examples

```sql
-- Returns the size of the schema public in bytes
SELECT pg_schema_size('public');
```

Result:

| pg_schema_size |
| --------------:|
|      348536832 |

```sql
-- Returns the size of the schema public formatted
SELECT pg_size_pretty(pg_schema_size('public'));
```

Result:

| pg_schema_size |
| --------------:|
|         332 MB |


## Functions about encodings

### FUNCTION is_encoding

The function checks if all characters are in included in a given encoding.
That is especially useful, if you have to deal with exports into other
encodings than the database encoding.

The function with two parameters uses UTF-8 as source encoding,<br />
The one with three parameters uses the third parameter as source encoding.

#### Examples

```sql
SELECT is_encoding('Some characters', 'LATIN1') AS res;
```

Result:

| res |
|:---:|
| f   |

```sql
SELECT is_encoding('Some characters, ğ is Turkish and not latin1', 'LATIN1') AS res;
-- Returns false: The Turkish character ğ is not part of latin1
```

Result:

| res |
|:---:|
| f   |

```sql
SELECT is_encoding('Some characters', 'LATIN1', 'UTF8') AS res;
```

Result:

| res |
|:---:|
| t   |

```sql
SELECT is_encoding('Some characters, ğ is Turkish and not latin1', 'UTF8', 'LATIN1') AS res;
-- Returns false: The Turkish character ğ is not part of latin1
```

Result:

| res |
|:---:|
| f   |

### FUNCTION is_latin1

The function is a shortcut for is_encoding('Some characters', 'LATIN1'), you
don't have to give the target encoding.

#### Examples

```sql
SELECT is_latin1('Some characters') AS res;
```

Result:

| res |
|:---:|
| t   |

```sql
SELECT is_latin1('Some characters, ğ is Turkish and not latin1') AS res;
-- Returns false: The Turkish character ğ is not part of latin1
```

Result:

| res |
|:---:|
| f   |


### FUNCTION return_not_part_of_latin1

The function returns a distinct array containing all characters, which are not defined in latin1.<br />
The function <span style="color:red">depends on is_latin1</span> which is part of this repository.

#### Example

```sql
-- Returns an array containing the characters ğ and Ƶ each one time
SELECT return_not_part_of_latin1('ağbƵcğeƵ') AS res;
```

Result:

| res   |
| ----- |
| {ğ,Ƶ} |

### FUNCTION replace_latin1

The function has three implementations. All implementations <span style="color:red">depend on the function is_latin1</span>, the function is included in this repository.

#### replace_latin1(s VARCHAR)

The function takes one parameter with characters to be checked and replaced with
an empty string, if they are not part of latin1.

##### Example

```sql
SELECT replace_latin1('Some characters, ğ is Turkish and not latin1') AS res;
```

Result:

| res                                         |
| ------------------------------------------- |
| Some characters,  is Turkish and not latin1 |

#### replace_latin1(s VARCHAR, replacement VARCHAR)
The function takes a second parameter which is used to replace _all_ characters,
which are not part of latin1.

##### Example

```sql
SELECT replace_latin1(
  'Some characters, ğ is Turkish and not latin1 and replaced with a g',
  'g'
) AS res;
```

Result:

| res                                                                |
| ------------------------------------------------------------------ |
| Some characters, g is Turkish and not latin1 and replaced with a g |

#### replace_latin1(s VARCHAR, s_search VARCHAR[], s_replace VARCHAR[])

The function takes as first parameter a string which may or may not have none
latin1 characters. The second parameter is an arrays containing all characters,
that should be replaced. The third parameter is an array, too. The characters
defined in s_search are replaced with the characters in s_replace, it takes the
position in the array to identify which character should be replaced by which
one.

##### Example

```sql
-- First identify the characters which should be replaced, which are {ğ,Ƶ}
SELECT return_not_part_of_latin1('ağbƵcğeƵ') AS res;

-- The ğ will be replaced whit a g and the Ƶ with a Z}
SELECT 'ağbƵcğeƵ' AS original
  , replace_latin1(
      'ağbƵcğeƵ',
      string_to_array('ğ,Ƶ', ','),
      string_to_array('g,Z', ',')
    ) AS res;
```
Result:

| original | res      |
| -------- | -------- |
| ağbƵcğeƵ | agbZcgeZ |

### FUNCTION return_not_part_of_encoding

The function returns a distinct array containing all characters, which are not defined in the second parameter as encoding.<br />
The function <span style="color:red">depends on is_encoding</span> which is part of this repository.

#### Example

```sql
-- Returns an array containing the characters ğ and Ƶ each one time
SELECT return_not_part_of_encoding('ağbƵcğeƵ', 'latin1') AS res;
```

Result:

| res   |
| ----- |
| {ğ,Ƶ} |


### FUNCTION replace_encoding

The function has three implementations. All implementations <span style="color:red">depend on the function is_encoding</span>, the function is included in this repository.

#### replace_encoding(s VARCHAR, e VARCHAR)

The function takes one parameter with characters to be checked and replaced with
an empty string, if they are not part of the encoding given in the second
parameter.

##### Example

```sql
SELECT replace_encoding(
  'Some characters, ğ is Turkish and not latin1',
  'latin1'
) AS res;
```

Result:

| res                                         |
| ------------------------------------------- |
| Some characters,  is Turkish and not latin1 |

#### replace_encoding(s VARCHAR, e VARCHAR, replacement VARCHAR)
The function takes a third parameter which is used to replace _all_ characters
which are not part of the encoding given in parameter 2.

##### Example

```sql
SELECT replace_encoding(
  'Some characters, ğ is Turkish and not latin1 and replaced with a g',
  'latin1',
  'g'
) AS res;
```

Result:

| res                                                                |
| ------------------------------------------------------------------ |
| Some characters, g is Turkish and not latin1 and replaced with a g |

#### replace_encoding(s VARCHAR, s_search VARCHAR[], s_replace VARCHAR[])

The function takes as first parameter a string which may or may not have none
latin1 characters. The second parameter is an arrays containing all characters,
that should be replaced. The third parameter is an array, too. The characters
defined in s_search are replaced with the characters in s_replace, it takes the
position in the array to identify which character should be replaced by which
one.

##### Example

```sql
-- First identify the characters which should be replaced, which are {ğ,Ƶ}
SELECT return_not_part_of_latin1('ağbƵcğeƵ') AS res;

-- The ğ will be replaced whit a g and the Ƶ with a Z}
SELECT 'ağbƵcğeƵ' AS original
  , replace_encoding(
      'ağbƵcğeƵ',
      string_to_array('ğ,Ƶ', ','),
      string_to_array('g,Z', ',')
  ) AS res;
```
Result:

| original | res      |
| -------- | -------- |
| ağbƵcğeƵ | agbZcgeZ |

## User defined aggregates

### AGGREGATE gap_fil

The aggregate is used in [Window Functions](https://www.postgresql.org/docs/current/static/tutorial-window.html)
to show the last value in case the current value is null.

#### Example
```sql
BEGIN;

CREATE TABLE test_gap_fill(id INTEGER, some_value VARCHAR);

INSERT INTO test_gap_fill(id, some_value) VALUES
  (1, 'value 1'),
  (1, NULL),
  (2, 'value 2'),
  (2, NULL),
  (2, NULL),
  (3, 'value 3')
;

SELECT id
  , some_value
FROM test_gap_fill
;

ROLLBACK;
```

Result:

| id | some_value |
| --:| ---------- |
|  1 | value 1    |
|  1 |            |
|  2 | value 2    |
|  2 |            |
|  2 |            |
|  3 | value 3    |


```sql
BEGIN;

CREATE TABLE test_gap_fill(id INTEGER, some_value VARCHAR);

INSERT INTO test_gap_fill(id, some_value) VALUES
  (1, 'value 1'),
  (1, NULL),
  (2, 'value 2'),
  (2, NULL),
  (2, NULL),
  (3, 'value 3')
;

-- Fill the empty rows with values
SELECT id
  , gap_fill(some_value) OVER (ORDER BY id) AS some_value
FROM test_gap_fill
;

ROLLBACK;
```

Result:

| id | some_value |
| --:| ---------- |
|  1 | value 1    |
|  1 | value 1    |
|  2 | value 2    |
|  2 | value 2    |
|  2 | value 2    |
|  3 | value 3    |
