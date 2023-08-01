using PandasLite
using Dates
using Test

df = pd.DataFrame(Dict(:name => ["a", "b"], :age => [27, 30]))
age = values(df.age)
age[2] = 31
@test df.loc[1, "age"] == 31

df = pd.read_csv(joinpath(dirname(@__FILE__), "test.csv"))
@test isa(df, PandasLite.DataFrame)

include("test_tabletraits.jl")

@test !isempty(df)
empty!(df)
@test isempty(df)

x = pd.Series([3, 5], index = [:a, :b])

@test x.a == 3
@test x["a"] == 3
@test x.loc["a"] == 3
@test x.b == 5
@test x.iloc[1] == 3
@test x.iloc[2] == 5
@test x.iloc[end] == 5
@test length(x) == 2
@test values(x + 1) == [4, 6]
@test x.sum() == 8
@test eltype(x) == Int
@test all(x.iloc[1:2] == x)

# rolling
roll = pd.Series([1,2,3,4,5]).rolling(3)
@test isequal(values(roll.mean()), [NaN, NaN, 2.0, 3.0, 4.0])

# groupy
group = pd.DataFrame(Dict("group" => ["a", "b", "a"], "value" => [1, 2, 3])).groupby("group")[["value"]]
@test isequal(values(group.sum()), [4; 2;;])

df = pd.DataFrame()
df["a"] = [1]
df["b"] = pd.to_datetime("2015-01-01")
df["c"] = pd.to_timedelta("0.5 hour")
df["d"] = "abcde"

@test Array(df["a"]) == values(df["a"]) == [1]
@test Array(df["b"]) == values(df["b"]) == [DateTime(2015, 1, 1)]
@test Array(df["c"]) == values(df["c"]) == [Millisecond(1800000)]
@test Array(df["d"]) == values(df["d"]) == ["abcde"]
@test Array(df["a"] / 2) == values(df["a"] / 2) == [0.5]
@test Array(2 / df["a"]) == values(2 / df["a"]) == [2]
