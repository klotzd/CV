
def TO_step(dt, number):
    from particle import particle
    from numpy import linalg, dot, abs
    from itertools import combinations

    momentum = 0

    def move(dt, particle):
        particle.pos += particle.v * dt


    def wall_collision_check (p):       # maybe put this part into the loop without a function definition? avoid any np.any() issues
        momentum_exch = 0
        box = 10**-6                 # phys parameters

        if (p.x - p.radius) < 0:
            p.x = p.radius
            p.vx = -1 * p.vx
            momentum_exch = 2 * p.mass * p.vx

        elif (p.x + p.radius) > box:
            p.x = box - p.radius
            p.vx = -1 * p.vx
            momentum_exch = 2 * p.mass * p.vx

        elif (p.y - p.radius) < 0:
            p.y = p.radius
            p.vy = -1 * p.vy
            momentum_exch = 2 * p.mass * p.vy

        elif (p.y + p.radius) > box:
            p.y = box - p.radius
            p.vy = -1 * p.vy
            momentum_exch = 2 * p.mass * p.vy

        else:
            collision = 0

        return momentum_exch

    def change_velocities(p1 ,p2):
        m1, m2 = p1.mass, p2.mass
        M = m1 + m2
        r1 = p1.pos
        r2 = p2.pos
        d = linalg.norm(r1 -r2)**2
        v1 = p1.v
        v2 = p2.v

        u1 = v1 - 2* m2 / M * dot(v1 - v2, r1 - r2) / d * (r1 - r2)
        u2 = v2 - 2 * m1 / M * dot(v2 - v1, r2 - r1) / d * (r2 - r1)
        p1.v = u1
        p2.v = u2

    def get_pressure(momentum, dt):
        box = 10 ** -6
        return momentum / (dt * 4 * box)

    # move step, check and handle wall collisions

    for p in particle._registry:
        move(dt, p)
        momentum_exch = wall_collision_check(p)
        momentum += abs(momentum_exch)
        print('move')

    pressure = get_pressure(momentum, dt)

    # check and handle particle collision

    pairs = combinations(range(number), 2)

    for i, j in pairs:
        if particle._registry[i].collision_check(particle._registry[j]):
            change_velocities(particle._registry[i], particle._registry[j])

    if particle._registry[1].memory:
        for p in particle._registry:
            p.memorize()

    return pressure
