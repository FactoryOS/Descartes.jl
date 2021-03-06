abstract type AbstractPrimitive{N, T} end # dimensionality, numeric type
abstract type AbstractCSGTree{N,T} <: AbstractPrimitive{N, T} end
abstract type AbstractOperation{N,T} <: AbstractPrimitive{N,T} end

# 2D Geometric Primitives

struct Square{T} <: AbstractPrimitive{2, T}
    dimensions::SVector{2,T}
    lowercorner::SVector{2,T}
end

struct Circle{T} <: AbstractPrimitive{2, T}
    radius::T
end

# 3D Geometric Primitives

struct Cuboid{T} <: AbstractPrimitive{3, T}
    dimensions::SVector{3,T}
    lowercorner::SVector{3,T}
end

struct Cylinder{T} <: AbstractPrimitive{3, T}
    radius::T
    height::T
    bottom::T
end

struct Sphere{T} <: AbstractPrimitive{3, T}
    radius::T
end

struct Piping{T} <: AbstractPrimitive{3, T}
    radius::T
    points::Vector{SVector{3,T}}
end

# transforms

struct MapContainer{N, T, M, P<:AbstractPrimitive{N,T}} <: AbstractPrimitive{N,T}
    map::M
    inv::M
    primitive::P
end


# CSG
# http://en.wikipedia.org/wiki/Constructive_solid_geometry

struct CSGUnion{N, T, L, R} <: AbstractCSGTree{N, T}
    left::L
    right::R
end

struct RadiusedCSGUnion{N, T, L, R} <: AbstractCSGTree{N, T}
    radius::T
    left::L
    right::R
end

struct CSGDiff{N, T, L, R} <: AbstractCSGTree{N, T}
    left::L
    right::R
end

struct CSGIntersect{N, T, L, R} <: AbstractCSGTree{N, T}
    left::L
    right::R
end

# Operations

struct Shell{T} <: AbstractPrimitive{3,T}
    primitive::T
    distance
end

struct LinearExtrude{N, T, P} <: AbstractPrimitive{3,T}
    primitive::P
    distance::T
end
