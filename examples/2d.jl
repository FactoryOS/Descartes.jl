using Descartes
using GeometryBasics: Mesh

function beam(beam_size = [50,10,10],
              hole_ct = 5,
              hole_d = 3)

    # computations
    hole_interval = beam_size[1]/(hole_ct + 1)

    c = Square(beam_size)

    for i = 1:hole_ct
        h = translate([hole_interval*i, beam_size[2]/2])Circle(hole_d/2)
        c = diff(c, h)
    end
    LinearExtrude(c, beam_size[3])
end

m = Mesh(beam())

#save("2d_beam.ply",m)
