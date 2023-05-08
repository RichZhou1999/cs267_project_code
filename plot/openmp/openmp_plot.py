import matplotlib.pyplot as plt
import numpy as np
p_threads = [1, 2, 4, 8, 16]
scales = [0.00365,0.0073, 0.015, 0.02905, 0.04355]
number_label = ["25k","50k","100k","200k","300k"]
plt.rcParams.update({'font.size': 14})
run_time = {}

plt.figure()
for i in range(len(scales)):
    scale = scales[i]
    temp_run_time = []
    for thread in p_threads:
        with open("scale_%s_pthreads_%s.txt"%(scale, thread), "r") as file:
            num_simulation = int(file.readline())
            threads = file.readline()
            temp_time = int(file.readline())*1e-6
            temp_run_time.append(temp_time)
    num_simulation = round((num_simulation-500) / 1000)

    x = np.log2(p_threads)
    y = np.log2(temp_run_time)
    # plt.figure()
    plt.plot(x,y, label=number_label[i])
plt.legend()
x_ticks = [1, 2, 4, 8, 16, 32,64]
y_ticks = [1, 2, 4, 8, 16, 32, 64, 128, 256, 512, 1024, 2048, 4096, 8192]
plt.xticks(np.log2(x_ticks), x_ticks)
plt.yticks(np.log2(y_ticks), y_ticks)
plt.xlabel("Threads Number")
plt.ylabel("Time (s)")
plt.title("Strong Scaling Of Network Generation")
plt.savefig("Strong_scaling_of_Network_Generation.png", dpi=800)
plt.show()


