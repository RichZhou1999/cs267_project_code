# cs267_project_code
# Five files
### agent_based_create_network 
Serial code to generate the social network
### agent_based_create_network_openmp
Code paralled with openMP to generate the social network
### agent_based_create_network_openmp_test
Code paralled with openMP to generate the social network, which is used to test corretness with the serial code
### agent_based_simulation_serial
Serial code for simulation
### agent_based_simulation_cuda_test
code accelerated with cuda for simulation
# Usage
First run the "create network" file, which will generate four files, "agents","neighbors", "neighbor prefix sum" and "number of neighbors each agent"
<br>
Put these four files into the simualtion file and run. The results will be the adoption history, showing the process of the adoption.
