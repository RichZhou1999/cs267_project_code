import matplotlib.pyplot as plt
import numpy as np
plt.rcParams.update({'font.size': 14})
# Define the number of processes and the workload per process
num_processes = np.array([1, 2, 4, 8, 16])
workload_per_process = 100

# Define the execution times for each configuration
execution_times = np.array([9.4, 9.6, 9.8, 11.1, 17.9])

# Calculate the total workload and speedup
# total_workload = num_processes * workload_per_process
speedup = execution_times[0] / execution_times

# Plot the results
plt.plot(num_processes, speedup, '-o')
plt.xlabel('Number Of Threads')
plt.ylabel('Speedup')
plt.title('Weak Scaling Plot')
plt.ylim(0,1.2)
plt.show()