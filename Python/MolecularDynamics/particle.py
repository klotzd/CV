import numpy as np

class IterRegistry(type):
    def __iter__(cls):
        return iter(cls._registry)

class particle(object):
    __metaclass__ = IterRegistry
    _registry = []

    def __init__(self, x, y, vx, vy, mass, radius, species=None, memory=False):

        self._registry.append(self)

        self.pos = np.array((x, y))
        self.v = np.array([vx, vy]).ravel()
        self.radius = radius                                                   # H-Atom ~ 0.5 A
        self.mass = mass                                                     # H-Atom ~ 1 u
        self.kin = np.array((0.5 * (vx * vx + vy * vy) * self.mass))

        self.memory = memory
        self.species = species

        if memory:
            self.trajectory_p = np.array((x, y))
            self.trajectory_v = np.array((vx, vy))
            self.trajectory_kin = np.array((0.5 * (vx * vx + vy * vy) * self.mass))

        if species is not None:
            self.species = species

    @property
    def x(self):
        return self.pos[0]

    @x.setter
    def x(self, value):
        self.pos[0] = value

    @property
    def y(self):
        return self.pos[1]

    @y.setter
    def y(self, value):
        self.pos[1] = value

    @property
    def vx(self):
        return self.v[0]

    @vx.setter
    def vx(self, value):
        self.v[0] = value

    @property
    def vy(self):
        return self.v[1]

    @vy.setter
    def vy(self, value):
        self.v[1] = value

    def __repr__(self):
        return "Particle()"

    def __str__(self):
        return "pos is %s, \n vel is %s" % (self.pos, self.v)

    def collision_check(self, p2):
        return np.hypot(*(self.pos - p2.pos)) <= self.radius + p2.radius

    def memorize(self):
        self.trajectory_p = np.append(self.trajectory_p, self.pos)
        self.trajectory_v = np.append(self.trajectory_v, self.v)
        self.trajectory_kin = np.append(self.trajectory_kin, self.kin)