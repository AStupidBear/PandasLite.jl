Base.getindex(o::PyObject, s) = o.__getitem__(s)
Base.getindex(o::PyObject, is...) = getindex(o, is)
Base.setindex!(o::PyObject, v, s) = o.__setitem__(s, v)
Base.setindex!(o::PyObject, v, is...) = setindex!(o, v, is)

Base.getindex(o::PyObject, s::Symbol) = invoke(getindex, Tuple{PyObject, Any}, o, s)
Base.getindex(o::PyObject, s::AbstractString) = invoke(getindex, Tuple{PyObject, Any}, o, s)
Base.setindex!(o::PyObject, v, s::Symbol) = invoke(setindex!, Tuple{PyObject, Any, Any}, o, v, s)
Base.setindex!(o::PyObject, v, s::AbstractString) = invoke(setindex!, Tuple{PyObject, Any, Any}, o, v, s)

const IntType = Union{Signed, Unsigned}
Base.getindex(o::PyObject, i::IntType) = invoke(getindex, Tuple{PyObject, Any}, o, i)
Base.getindex(o::PyObject, i1::IntType, i2::IntType) = getindex(o, (i1, i2))
Base.getindex(o::PyObject, is::IntType...) = getindex(o, is)
Base.setindex!(o::PyObject, v, i::IntType) = invoke(setindex!, Tuple{PyObject, Any, Any}, o, v, i)
Base.setindex!(o::PyObject, v, i1::IntType, i2::IntType) = setindex!(o, (i1, i2), v)
Base.setindex!(o::PyObject, v, is::IntType...) = setindex!(o, is, v)
