def quorum(i):
    return (int(i) + 1) / 2


class FilterModule(object):
    def filters(self):
        return {
            'quorum': quorum
        }