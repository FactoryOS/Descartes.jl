# http://en.wikipedia.org/wiki/Function_representation

# rvechev functions for smooth max and min
rmax(x,y) = (x+y+sqrt((x-y)^2))/2
rmax(x, y, z...) = rmax(x, rmax(y,z...))
rmin(x,y) = (x+y-sqrt((x-y)^2))/2
rmin(x, y, z...) = rmin(x, rmin(y,z...))

function _radius(a,b,r)
    if abs(a-b) >= r
        return rmin(a,b)
    else
        return b+r*sin(pi/4+asin((a-b)/(r*sqrt(2))))-r
    end
end

function FRep(p::Sphere, v)
    it = p.inv_transform
    x = v[1]*it[1,1]+v[2]*it[1,2]+v[3]*it[1,3]+it[1,4]
    y = v[1]*it[2,1]+v[2]*it[2,2]+v[3]*it[2,3]+it[2,4]
    z = v[1]*it[3,1]+v[2]*it[3,2]+v[3]*it[3,3]+it[3,4]
    sqrt(x*x + y*y + z*z) - p.radius
end

function FRep(p::Cylinder, v)
    it = p.inv_transform
    x = v[1]*it[1,1]+v[2]*it[1,2]+v[3]*it[1,3]+it[1,4]
    y = v[1]*it[2,1]+v[2]*it[2,2]+v[3]*it[2,3]+it[2,4]
    z = v[1]*it[3,1]+v[2]*it[3,2]+v[3]*it[3,3]+it[3,4]
    rmax(-z+p.bottom, z-p.height-p.bottom, sqrt(x*x + y*y) - p.radius)
end

function FRep(p::Cuboid, v)
    it = p.inv_transform
    x = v[1]*it[1,1]+v[2]*it[1,2]+v[3]*it[1,3]+it[1,4]
    y = v[1]*it[2,1]+v[2]*it[2,2]+v[3]*it[2,3]+it[2,4]
    z = v[1]*it[3,1]+v[2]*it[3,2]+v[3]*it[3,3]+it[3,4]
    dx, dy, dz = p.dimensions
    lbx, lby,lbz = p.lowercorner
    rmax(-x+lbx, x-dx-lbx,
        -y+lby, y-dy-lby,
        -z+lbz, z-dz-lbz)
end

function FRep(u::CSGUnion, v)
    rmin(FRep(u.left, v),FRep(u.right, v))
end

function FRep(u::CSGDiff, v)
    rmax(FRep(u.left, v), -FRep(u.right, v))
end

function FRep(u::CSGIntersect, v)
    rmax(FRep(u.left, v), FRep(u.right, v))
end

function FRep(s::Shell, v)
    r = FRep(s.primitive, v)
    rmax(r, -r-s.distance)
end

function FRep(u::RadiusedCSGUnion, v)
    a = FRep(u.left, v)
    b = FRep(u.right, v)
    r = u.radius
    _radius(a,b,r)
end

function FRep(p::Piping{T}, v) where {T}
    num_pts = length(p.points)
    pt = Point(v[1],v[2],v[3])

    val = typemax(T)

    for i = 1:num_pts-1
        e1 = p.points[i]
        e2 = p.points[i+1]
        v = e2 - e1
        w = pt - e1
        if dot(w,v) <= 0
            nv = norm(pt - e1)
        elseif dot(v,v) <= dot(w,v)
            nv = norm(pt - e2)
        else
            nv = norm(cross(pt-e1,pt-e2))/norm(e2-e1)
        end
        val = min(nv, val)
    end
    val - p.radius
end

function FRep(p::LinearExtrude, v)
    r = FRep(s.primitive, v)
    rmax(rmax(-z,z-p.height), r)
end
