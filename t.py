


def fill(items, weights, capacity):
    weight = 0
    i = 0
    ret = []
    while (weight <= capacity) and (i < len(items)):
        weight += weights[i]
        ret.append(items[i])
        i += 1

    if weight > capacity:
        ret.pop()

    return ret







