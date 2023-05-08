#30k step:700  python: 11s  c++ serial: 0.085 c++ parallel:0.066
import matplotlib.pyplot as plt
plt.rcParams.update({'font.size': 14})
# Time measurements in seconds
# method_a_time = 653
method_b_time = 653
method_c_time = 55
# method_d_time = 15
cmap = plt.get_cmap('viridis')
colors = [cmap(i) for i in [0.2,0.6, 0.9, 1.2]]
# Create a bar chart with time on the x-axis and method on the y-axis
plt.bar([ "Python Serial", "C++ Serial"], [ method_b_time, method_c_time], color=colors)

# Set the title and axis labels
plt.title("Generation Of Network With 30k Agents")
plt.xlabel("Method")
plt.ylabel("Time (seconds)")

# Add labels to each bar
# plt.text(-0.1, method_a_time + 1, str(method_a_time))
plt.text(-0.1, method_b_time + 2, str(method_b_time))
plt.text(0.9, method_c_time + 3, str(method_c_time))
# plt.text(1.9, method_d_time + 1, str(method_d_time))
plt.ylim(0, 700)
# Display the plot
plt.savefig("Generation Of Network With 30k Agents.png", dpi=800)
plt.show()








