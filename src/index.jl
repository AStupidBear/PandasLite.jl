Base.getindex(o::PyObject, s) = o.__getitem__(s)
Base.getindex(o::PyObject, is...) = getindex(o, is)
Base.setindex!(o::PyObject, v, s) = o.__setitem__(s, v)
Base.setindex!(o::PyObject, v, is...) = setindex!(o, v, is)

Base.getindex(o::PyObject, s::Union{Symbol, AbstractString}) = invoke(getindex, Tuple{PyObject, Any}, o, s)
Base.setindex!(o::PyObject, v, s::Union{Symbol, AbstractString}) = invoke(setindex!, Tuple{PyObject, Any, Any}, o, v, s)

Base.getindex(o::PyObject, i::Integer) = invoke(getindex, Tuple{PyObject, Any}, o, i)
Base.getindex(o::PyObject, i1::Integer, i2::Integer) = getindex(o, (i1, i2))
Base.getindex(o::PyObject, is::Integer...) = getindex(o, is)
Base.setindex!(o::PyObject, v, i::Integer) = invoke(setindex!, Tuple{PyObject, Any, Any}, o, v, i)
Base.setindex!(o::PyObject, v, i1::Integer, i2::Integer) = setindex!(o, (i1, i2), v)
Base.setindex!(o::PyObject, v, is::Integer...) = setindex!(o, is, v)
