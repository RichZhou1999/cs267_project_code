#30k step:700  python: 11s  c++ serial: 0.085 c++ parallel:0.066
import matplotlib.pyplot as plt
plt.rcParams.update({'font.size': 14})
# Time measurements in seconds
method_a_time = 11
method_b_time = 0.085
# method_c_time = 0.066
cmap = plt.get_cmap('viridis')
colors = [cmap(i) for i in [0.2, 0.6]]
# Create a bar chart with time on the x-axis and method on the y-axis
plt.bar(["python", "c++ serial"], [method_a_time, method_b_time], color=colors)

# Set the title and axis labels
plt.title("Simulation time with 30k agents and 700 steps")
plt.xlabel("Method")
plt.ylabel("Time (seconds)")

# Add labels to each bar
plt.text(-0.1, method_a_time + 0.1, str(method_a_time))
plt.text(0.9, method_b_time + 0.1, str(method_b_time))
# plt.text(1.9, method_c_time + 0.1, str(method_c_time))
plt.ylim(0,12)
# Display the plot
plt.savefig("Simulation_time_with_30k_agents(700steps).png", dpi=800)
plt.show()








