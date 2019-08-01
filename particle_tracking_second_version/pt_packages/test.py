import time
from test1 import test_xxx

time_start = time.time()
b = ["test_10000"] * 88888888
c = ["test_1"]
a = {"b": b,
     "c": c}
wall_time = time.time() - time_start
print(wall_time)
test_xxx(a)
print(len(b))
wall_time = time.time() - time_start
print(wall_time)
