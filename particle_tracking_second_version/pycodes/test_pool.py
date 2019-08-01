import multiprocessing as mp


def def_test_pool(inode):
    # for itemp in range(0, int(100000000 / inode ** 4)):
    for itemp in range(0, int(1000000)):
        itemp = itemp * itemp
# print(inode)
    return (inode)


ncore = 16

results = []
pool = mp.Pool(processes=ncore)
for x in range(1, 64):
    pool.apply_async(
        def_test_pool,
        args=(x,),
        callback=collect_results
    )
# results.append(result)
    #

pool.close()
pool.join()
print("finished")

print(results)
# for result in results:
#     print(result)
