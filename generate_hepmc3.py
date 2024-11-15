import sys
import os
import numpy as np
from pyHepMC3 import HepMC3

seed = 42
rng = np.random.default_rng(seed)

###skip = int(sys.argv[1]) * 1000
n_events = int(sys.argv[1])
p = float(sys.argv[2])
theta2_deg = float(sys.argv[3])
theta2 = (theta2_deg/180.)*np.pi

print("Generating", n_events, "events with p =", p, "GeV/c and theta =", theta2_deg, "degrees")

writer = HepMC3.WriterAscii("output_" + str(sys.argv[2]) + "_" + str(sys.argv[4]) + "_" + str(sys.argv[5]) + ".hepmc3")

for ix in range(n_events):

    theta1 = (150./180.)*np.pi
    phi = (1./4.) * np.pi
    ###if ix < skip:
    ###    continue

    pt = np.sin(theta1) * p
    px = pt * np.cos(phi)
    py = pt * np.sin(phi)
    pz = np.cos(theta1) * p
    mass = 0.93957 # neutron
    E = np.sqrt(mass**2 + p**2)
    particle_out1 = HepMC3.GenParticle(HepMC3.FourVector(px, py, pz, E))
    particle_out1.set_pdg_id(2112)
    particle_out1.set_status(1)



    
    phi = (1./4.) * np.pi
    ###if ix < skip:
    ###    continue

    pt = np.sin(theta2) * p
    px = pt * np.cos(phi)
    py = pt * np.sin(phi)
    pz = np.cos(theta2) * p
    mass = 0.13957 # pion
    ####mass = 0.93957
    E = np.sqrt(mass**2 + p**2)
    particle_out2 = HepMC3.GenParticle(HepMC3.FourVector(px, py, pz, E))
    particle_out2.set_pdg_id(-211)
    ####particle_out2.set_pdg_id(2112)
    particle_out2.set_status(1)

    particle_in1 = HepMC3.GenParticle(HepMC3.FourVector(0, 0, -18.0, 18.0))
    particle_in1.set_pdg_id(11) # electron
    particle_in1.set_status(4)
    particle_in2 = HepMC3.GenParticle(HepMC3.FourVector(0.0, 0.0, 275.0, 275.0))
    particle_in2.set_pdg_id(2212) # proton
    particle_in2.set_status(4)

    vertex = HepMC3.GenVertex(HepMC3.FourVector(0., 0., 0., 0.))
    vertex.add_particle_in(particle_in1)
    vertex.add_particle_in(particle_in2)
    vertex.add_particle_out(particle_out1)
    vertex.add_particle_out(particle_out2)

    event = HepMC3.GenEvent(HepMC3.Units.GEV, HepMC3.Units.MM)
    event.add_vertex(vertex)
    event.set_beam_particles(particle_in1, particle_in2)

    writer.write_event(event)
