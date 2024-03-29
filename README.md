PandasLite.jl
=============

[![Build Status](https://github.com/AStupidBear/PandasLite.jl/workflows/CI/badge.svg)](https://github.com/AStupidBear/PandasLite.jl/actions)
[![Coverage](https://codecov.io/gh/AStupidBear/PandasLite.jl/branch/master/graph/badge.svg)](https://codecov.io/gh/AStupidBear/PandasLite.jl)

A fork of Pandas.jl whose syntax is closer to native pandas.

This package provides a Julia interface to the excellent [pandas](http://pandas.pydata.org/pandas-docs/stable/) package. It sticks closely to the pandas API. One exception is that integer-based indexing is automatically converted from Python's 0-based indexing to Julia's 1-based indexing.

Installation
--------------

You must have pandas installed. Usually you can do that on the command line by typing

```
pip install pandas
```

It also comes with the Anaconda and Enthought Python distributions.

Then in Julia, type

```julia
Pkg.add("PandasLite")
using PandasLite
```

Usage
---------

```julia
>> using PandasLite
>> df = DataFrame(Dict(:age=>[27, 29, 27], :name=>["James", "Jill", "Jake"]))
   age   name
0   27  James
1   29   Jill
2   27   Jake

[3 rows x 2 columns]
>> df.describe()
             age
count   3.000000
mean   27.666667
std     1.154701
min    27.000000
25%    27.000000
50%    27.000000
75%    28.000000
max    29.000000

[8 rows x 1 columns]

df[:age]
0    27
1    29
2    27
Name: age, dtype: int64

>> df2 = DataFrame(Dict(:income=>[45, 101, 87]), index=["Jake", "James", "Jill"])
>> df3 = df.merge(df2, left_on="name", right_index=true)
   age   name  income
0   27  James     101
1   29   Jill      87
2   27   Jake      45

[3 rows x 3 columns]

>> df3.iloc[1:2, 2:3]
    name  income
0  James     101
1   Jill      87

[2 rows x 2 columns]

>> df3.groupby("age").mean()
     income
age
27       73
29       87

[2 rows x 1 columns]

>> df3.query("income>85")
   age   name  income
0   27  James     101
1   29   Jill      87

[2 rows x 3 columns]

>> Array(df3)
3x3 Array{Any,2}:
 27  "James"  101
 29  "Jill"    87
 27  "Jake"    45

 >> df3.plot()
```

Input/Output
-------------
Example:
```julia
df = pd.read_csv("my_csv_file.csv") # Read in a CSV file as a dataframe
df.to_json("my_json_file.json") # Save a dataframe to disk in JSON format
```

Performance
------------
Most PandasLite operations on medium to large dataframes are very fast, since the overhead of calling into the Python API is small compared to the time spent inside PandasLite' highly efficient C implementation.

Setting and getting individual elements of a dataframe or series is slow however, since it requires a round-trip of communication with Python for each operation. Instead, use the ``values`` method to get a version of a series or homogeneous dataframe that requires no copying and is as fast to access and write to as a Julia native array. Example:

```julia
>> x_series = Series(randn(10000))
>> @time x[1]
elapsed time: 0.000121945 seconds (2644 bytes allocated)
>> x_values = values(x_series)
>> @time x_values[1]
elapsed time: 2.041e-6 seconds (64 bytes allocated)
>> x_native = randn(10000)
>> @time x[1]
elapsed time: 2.689e-6 seconds (64 bytes allocated)
```

Changes to the values(...) array propogate back to the underlying series/dataframe:
```julia
>> x_series.iloc[1]
-0.38390854447454037
>> x_values[1] = 10
>> x_series.iloc[1]
10
```


Caveats
----------
Panels-related functions are still unwrapped, as well as a few other obscure functions. Note that even if a function is not wrapped explicitly, it can still be called using various methods from [PyCall](https://github.com/stevengj/PyCall.jl).
