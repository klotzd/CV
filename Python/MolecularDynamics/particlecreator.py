from scipy.stats import maxwell
from scipy.constants import Boltzmann
import numpy as np
from particle import particle
import matplotlib.pyplot as plt

def initializer(number, temp = 100, mass=1.6735575 * 10** -27, radius=0.5 * 10 ** -10, memory= False, species_type=None, vdistr='maxwell'):

    def velocity(temp, mass, distr):

        v_mean = np.sqrt(8 / np.pi * Boltzmann * temp / mass)             # calculate mean particle velocity

        if vdistr == 'maxwell':
            s = np.sqrt(Boltzmann * temp / mass)
            v = maxwell.rvs(loc=0, scale=s, random_state=None)
            dsplit = np.random.rand()
            vx = np.sqrt(v**2 * dsplit) * np.random.choice((1, -1), size=1)
            vy = np.sqrt(v**2 * (1-dsplit)) * np.random.choice((1, -1), size=1)

        elif vdistr == 'normal':
            vx, vy = np.random.normal(loc=v_mean * 0.5, scale=v_mean * 0.05) * np.random.choice((1, -1), size=2)

        elif vdistr == 'random':
            vx, vy = np.random.rand(2) * v_mean  * np.random.choice((1, -1), size=2)

        return vx, vy

    def position():

        box = 10 ** -6              # standard domain size
        x, y = radius + (box - 2 * radius) * np.random.rand(2)

        return x, y

    for i in range(number):
        vx, vy = velocity(temp, mass, vdistr)
        x, y = position()

        new_particle = particle(x, y, vx, vy, mass, radius, species_type, memory)

        for p in particle._registry:
            if new_particle.collision_check(p):
                new_particle.x, new_particle.y  = position()

    print('succesfully initiated', number, 'particles')
