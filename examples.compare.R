
with(sleep, t.test(extra[group == 1], extra[group == 2]))

with(sleep, compare.2.vectors(extra[group == 1], extra[group == 2]))
