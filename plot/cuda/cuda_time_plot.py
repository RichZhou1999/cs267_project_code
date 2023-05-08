# 300k = {step3000:{serial:7.96,cuda:2.24},step2000: {serial:7.19, cuda:1.99}, step1000: {serial:1.58, cuda:1.054}, step500:{serial:0.75, cuda:0.93}}

# 200k = {step3000: {serial:4.72, cuda: 1.51} step2000: {serial:3.36, cuda:1.20}, step1000: {serial:0.97, cuda:0.54}, step500:{serial:0.41, cuda:0.41}}


# 100k = {step3000: {serial:1.654, cuda: 0.73} step2000: {serial:1.26, cuda:0.55}, step1000: {serial:0.48, cuda:0.22}, step500:{serial:0.21, cuda:0.15}}

# 50k = {step3000: {serial:0.78, cuda: 0.5} step2000: {serial:0.59, cuda:0.35}, step1000: {serial:0.25, cuda:0.14}, step500:{serial:0.13, cuda:0.083}}

import matplotlib.pyplot as plt
plt.rcParams.update({'font.size': 14})
time_usage_dict = {}
time_usage_dict["300k"] ={"step3000": {"serial":7.96, "cuda": 2.24}, "step2000": {"serial":7.19, "cuda":1.99}, "step1000": {"serial":1.58, "cuda":1.054}, "step500":{"serial":0.75, "cuda":0.93}}
time_usage_dict["200k"] ={"step3000": {"serial":4.72, "cuda": 1.51}, "step2000": {"serial":3.36, "cuda":1.20}, "step1000": {"serial":0.97, "cuda":0.54}, "step500":{"serial":0.41, "cuda":0.41}}
time_usage_dict["100k"] ={"step3000": {"serial":1.65, "cuda": 0.73}, "step2000": {"serial":1.26, "cuda":0.55}, "step1000": {"serial":0.48, "cuda":0.22}, "step500":{"serial":0.21, "cuda":0.15}}
time_usage_dict["50k"] ={"step3000": {"serial":0.78, "cuda": 0.5}, "step2000": {"serial":0.59, "cuda":0.35}, "step1000": {"serial":0.25, "cuda":0.14}, "step500":{"serial":0.13, "cuda":0.083}}

agent_numbers = ["50k", "100k", "200k", "300k"]
step_for_plot = "5000"


cuda_data = []
serial_data = []
for agent_number in agent_numbers:
    cuda_data.append(time_usage_dict[agent_number]["step"+step_for_plot]['cuda'])
    serial_data.append(time_usage_dict[agent_number]["step"+step_for_plot]['serial'])

x_values = ['50k', '100k', '200k', '300k']


# Define the x-coordinates for each bar
x_positions = [1, 2, 3, 4]

# Create a figure and axis object
fig, ax = plt.subplots()

bar_width = 0.1
bar_color_cuda = "red"
bar_color_serial = "green"
# Create a bar chart using the data and positions
for i in range(len(cuda_data)):
    if i == 0:
        ax.bar(x_positions[i] + 0.5 * bar_width, cuda_data[i], width=bar_width, color=bar_color_cuda, label = "cuda")
        ax.bar(x_positions[i] - 0.5 * bar_width, serial_data[i], width=bar_width, color=bar_color_serial, label = "serial")
        continue
    ax.bar(x_positions[i]+0.5*bar_width, cuda_data[i], width=bar_width, color=bar_color_cuda)
    ax.bar(x_positions[i]-0.5*bar_width, serial_data[i], width=bar_width, color=bar_color_serial)

# ax.bar(x_positions, y_values)

# Set the tick locations and labels for the x-axis
ax.set_xticks(x_positions)
ax.set_xticklabels(x_values)
ax.legend()
# Add labels and a title to the chart
ax.set_xlabel('# Of Agents')
ax.set_ylabel('Simulation Time (s)')
ax.set_title('Comparsion Of Simulation Time With %s Steps'%step_for_plot)
ax.set_xlim(-0,5)
# Display the chart
plt.savefig("step%s.png"%step_for_plot, dpi=800)
plt.show()
