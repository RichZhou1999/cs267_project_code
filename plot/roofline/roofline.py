import matplotlib.pyplot as plt
import numpy as np

# Define the maximum performance of the system (in FLOPS)
max_perf = 2.8e12   # obtained from a CPU benchmark like LINPACK

# Define the memory bandwidth of the system (in bytes/second)
mem_bw = 1.3e11     # obtained from a memory benchmark like STREAM

# Calculate the roofline peak (in FLOPS)
roofline_peak = max_perf

# Calculate the roofline slope (in FLOPS/byte)
roofline_slope = max_perf / mem_bw

# Print the roofline parameters
print('Roofline Peak:', roofline_peak, 'FLOPS')
print('Roofline Slope:', roofline_slope, 'FLOPS/byte')

# Define the operational intensity range
op_intensity = np.logspace(-2, 2, num=100)

# Define the performance for each operational intensity
performance = np.minimum(roofline_peak, op_intensity * roofline_slope)

# Create the figure and axis objects
fig, ax = plt.subplots()

# Plot the roofline
ax.plot(op_intensity, performance, 'r--')

# Set the axis labels and title
ax.set_xlabel('Operational Intensity (FLOPS/byte)')
ax.set_ylabel('Performance (FLOPS)')
ax.set_title('Roofline Model')

# Add the roofline peak to the plot
ax.axhline(y=roofline_peak, color='gray', linestyle='--', label='Roofline Peak')

# Add a legend
ax.legend()

# Show the plot
plt.show()
