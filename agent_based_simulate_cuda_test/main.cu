#include <iostream>
#include <fstream>
#include <sstream>
#include <vector>
#include <numeric>
#include <random>
#include <cmath>
#include <chrono>
#include <vector>
#include <unordered_map>
#include <cuda.h>
#include "common.h"

#define TOTAL_AGENT 6897434
#define coefficient1 0.00000928
// #define coefficient1 0.00928
#define coefficient2 0.00843
#define NUM_THREADS 256


Agent* d_agents;
int* d_neighbors_prefix_sum;
int* d_neighbors_array;
int* d_number_neighbors_each_agent;
float* d_random_number_array;
float* d_agent_threshold_array;
int* d_current_adoption_array;
int* d_adoption_history_array;

void initialize_basic_variables(const char* agent_txt_name, const char* neighbor_txt_name, int*simulation_agents_number_pointer, float*scale_pointer, long* neighbors_number_pointer ){
    std::ifstream file(agent_txt_name);
    if (file.is_open()) {
        file >> (*simulation_agents_number_pointer);
        *scale_pointer = (*simulation_agents_number_pointer) / TOTAL_AGENT;
        std::cout << "simulation_agents_number: "<< (*simulation_agents_number_pointer) <<  "\n";
        file.close();
    }
    std::ifstream file2(neighbor_txt_name);
    if (file2.is_open()) {
        file2 >> (*neighbors_number_pointer);
        std::cout << "neighbor_number: "<< (*neighbors_number_pointer) <<  "\n";
        file2.close();
    }

}

void initialize_agents(const char* txt_name , Agent* agents){
    int simulation_agents_number;
    std::ifstream file("agents.txt");
    if (file.is_open()) {
        file >> simulation_agents_number;
        int zip,num_neigh;
        float inc;
        for ( int i =0; i < simulation_agents_number ; i++){
            file >> zip >> inc >> num_neigh;
            agents[i] = Agent(zip, inc, num_neigh);
        }
        file.close();
    }
}

void initialize_neighbors(const char* txt_name, int* neighbors_array){
    std::ifstream file(txt_name);
    long neighbors_number;
    if (file.is_open()) {
        file >> neighbors_number;
        int neighbor;
        for ( int i =0; i < neighbors_number ; i++){
            file >> neighbor;
            neighbors_array[i] = neighbor;
        }
    }
}

void initialize_neighbor_prefix(const char* txt_name, int* neighbors_prefix_sum_pointer){
    std::ifstream file(txt_name);
    int simulation_agents_number;
    if (file.is_open()) {
        file >> simulation_agents_number;
        int temp;
        for ( int i =0; i < simulation_agents_number ; i++){
            file >> temp;
            neighbors_prefix_sum_pointer[i] = temp;
        }
    }
}



void initialize_number_neighbors_each_agent(const char* txt_name, int* number_neighbors_each_agent, int* agents_max_degree_pointer){
    std::ifstream file(txt_name);
    int simulation_agents_number;
    if (file.is_open()) {
        file >> simulation_agents_number;
        int temp;
        for ( int i =0; i < simulation_agents_number ; i++){
            file >> temp;
            number_neighbors_each_agent[i] = temp;
            if (temp > (*agents_max_degree_pointer)){
                (*agents_max_degree_pointer) = temp;
            }
        }
    }
}


int step(int current_step, int simulation_agents_number, Agent* agents, int agents_max_degree, 
         int* neighbors_prefix_sum, int*neighbors_array,int* number_neighbors_each_agent,int current_number_adoption, float* radom_number_array){
    // std::mt19937 gen(seed); 
    // std::uniform_real_distribution<> dis(0.0, 1.0);
    
    agents[0].affected = 1;
    // std::cout<< simulation_agents_number_s<<std::endl;
    for (int j = 0 ; j < simulation_agents_number ; j++){
        //float might not be proper
        double random_num = radom_number_array[current_step*simulation_agents_number + j];
        double threshold;
        if (agents[j].affected == 1){
            continue;
        }
        int agent_current_num_neighbor = agents[j].number_of_neighbors_affected;
        float agent_income = agents[j].income;
        threshold = coefficient1 * agent_income + coefficient2 * agent_current_num_neighbor/agents_max_degree;
        // std::cout << threshold << random_num << std::endl;
        if (threshold > random_num){
            // std::cout << "enter" << std::endl;
            current_number_adoption += 1;
            agents[j].affected = 1;
            for(int k = neighbors_prefix_sum[j]; k < neighbors_prefix_sum[j] + number_neighbors_each_agent[j] ; k++){
                agents[neighbors_array[k]].number_of_neighbors_affected += 1;
            }
        }
    }
    // std::cout << current_number_adoption<<std::endl;
    return current_number_adoption;
}


int step_later_update(int current_step, int simulation_agents_number, Agent* agents, int agents_max_degree, 
         int* neighbors_prefix_sum, int*neighbors_array,int* number_neighbors_each_agent,int current_number_adoption, float* radom_number_array){
    // std::mt19937 gen(seed); 
    // std::uniform_real_distribution<> dis(0.0, 1.0);
    std::vector<int> affected_this_step;
    agents[0].affected = 1;
    // std::cout<< simulation_agents_number_s<<std::endl;
    for (int j = 0 ; j < simulation_agents_number ; j++){
        //float might not be proper
        double random_num = radom_number_array[current_step*simulation_agents_number + j];
        double threshold;
        if (agents[j].affected == 1){
            continue;
        }
        int agent_current_num_neighbor = agents[j].number_of_neighbors_affected;
        float agent_income = agents[j].income;
        threshold = coefficient1 * agent_income + coefficient2 * agent_current_num_neighbor/agents_max_degree;
        // std::cout << threshold << random_num << std::endl;
        if (threshold > random_num){
            // std::cout << "enter" << std::endl;
            current_number_adoption += 1;
            agents[j].affected = 1;
            affected_this_step.push_back(j);
            // for(int k = neighbors_prefix_sum[j]; k < neighbors_prefix_sum[j] + number_neighbors_each_agent[j] ; k++){
            //     agents[neighbors_array[k]].number_of_neighbors_affected += 1;
            // }
        }
    }

    for (std::vector<int>::size_type j = 0 ; j < affected_this_step.size() ; j++){
        int current_value = affected_this_step[j];
        for(int k = neighbors_prefix_sum[current_value]; k < neighbors_prefix_sum[current_value] + number_neighbors_each_agent[current_value] ; k++){
            agents[neighbors_array[k]].number_of_neighbors_affected += 1;
        }
    }

    // std::cout << current_number_adoption<<std::endl;
    return current_number_adoption;
}


// int step_all(int total_simulation_step, int simulation_agents_number, Agent* agents, int agents_max_degree, 
//          int* number_adoption, int* neighbors_prefix_sum, int*neighbors_array,int* number_neighbors_each_agent,int current_number_adoption,int seed=12){
//     std::mt19937 gen(seed); 
//     std::uniform_real_distribution<> dis(0.0, 1.0);
//     // std::cout<< simulation_agents_number_s<<std::endl;
//     current_number_adoption = 0;
//     for(int i =0; i <total_simulation_step;i++ ){

//     for (int j = 0 ; j < simulation_agents_number ; j++){
//         //float might not be proper
//         double random_num = dis(gen);
//         double threshold;
//         if (agents[j].affected == 1){
//             continue;
//         }
//         int agent_current_num_neighbor = agents[j].number_of_neighbors_affected;
//         float agent_income = agents[j].income;
//         threshold = coefficient1 * agent_income + coefficient2 * agent_current_num_neighbor/agents_max_degree;
//         // std::cout << threshold << random_num << std::endl;
//         if (threshold > random_num){
//             current_number_adoption += 1;
//             agents[j].affected = 1;
//             for(int k = neighbors_prefix_sum[j]; k < neighbors_prefix_sum[j] + number_neighbors_each_agent[j] ; k++){
//                 agents[neighbors_array[k]].number_of_neighbors_affected += 1;
//             }
//         }
//     }
//     std::cout << current_number_adoption<<std::endl;
//     }
//     return current_number_adoption;
// }


// int step(int simulation_agents_number, Agent* agents, int agents_max_degree, 
//          int* number_adoption, int* neighbors_prefix_sum, int*neighbors_array,int* number_neighbors_each_agent,int current_number_adoption,int seed=12){
//     std::mt19937 gen(seed); 
//     std::uniform_real_distribution<> dis(0.0, 1.0);
//     for (int j = 0 ; j < simulation_agents_number ; j++){
//         //float might not be proper
//         double random_num = dis(gen);
//         double threshold;
//         if (agents[j].affected == 1){
//             continue;
//         }
//         int agent_current_num_neighbor = agents[j].number_of_neighbors_affected;
//         float agent_income = agents[j].income;
//         threshold = coefficient1 * agent_income + coefficient2 * agent_current_num_neighbor/agents_max_degree;
//         if (threshold > random_num){
//             // std::cout << "enter" << std::endl;
//             current_number_adoption += 1;
//             agents[j].affected = 1;
//             for(int k = neighbors_prefix_sum[j]; k < neighbors_prefix_sum[j] + number_neighbors_each_agent[j] ; k++){
//                 agents[neighbors_array[k]].number_of_neighbors_affected += 1;
//             }
//         }
//     }
//     return current_number_adoption;
// }

__global__ void copy_agent_objects(Agent* des, Agent* source, int num_items){
    int tid = threadIdx.x + blockIdx.x * blockDim.x;
    if (tid >= num_items){
        return;
    }

    des[tid] = source[tid];
}

__global__ void copy_int_objects(int* des, int* source, int num_items){
    int tid = threadIdx.x + blockIdx.x * blockDim.x;
    if (tid >= num_items){
        return;
    }

    des[tid] = source[tid];
}

__global__ void copy_float_objects(float* des, float* source, int num_items){
    int tid = threadIdx.x + blockIdx.x * blockDim.x;
    if (tid >= num_items){
        return;
    }

    des[tid] = source[tid];
}


// __global__ void calculate_threshold(int current_step,int simulation_agents_number, Agent* agents, int agents_max_degree,float* random_number_array,
//                                     float* agent_threshold_array)
//     {
//         int tid = threadIdx.x + blockIdx.x * blockDim.x;
//         if (tid >= simulation_agents_number)
//         {
//         return;
//         }
//         Agent* agent = &agents[tid];
//         float threshold;
//         // int agent_current_num_neighbor = agent->number_of_neighbors_affected;
//         float agent_income = agent->income;
//         // threshold = coefficient1 * agent_income + coefficient2 * agent_current_num_neighbor/agents_max_degree;
//         // agent_threshold_array[tid] = threshold;
//     }


__global__ void calculate_threshold(int current_step, int simulation_agents_number, Agent* agents, int agents_max_degree, 
    float* agent_threshold_array){
    int tid = threadIdx.x + blockIdx.x * blockDim.x;
    if (tid >= simulation_agents_number)
    {
    return;
    }
    Agent* agent = &agents[tid];
    if (agent->affected == 1){
        return;
    }
    float threshold;
    int agent_current_num_neighbor = agent->number_of_neighbors_affected;
    float agent_income = agent->income;
    threshold = coefficient1 * agent_income + coefficient2 * agent_current_num_neighbor/agents_max_degree;
    agent_threshold_array[tid] = threshold;
    }


__global__ void step_gpu(int current_step, int simulation_agents_number, Agent* agents, int agents_max_degree, 
    int* neighbors_prefix_sum, int*neighbors_array,int* number_neighbors_each_agent,int* current_number_adoption, float* random_number_array){
    int tid = threadIdx.x + blockIdx.x * blockDim.x;
    if (tid >= simulation_agents_number)
    {
    return;
    }
    Agent* agent = &agents[tid];
    if (agent->affected == 1){
        return;
    }
    float random_num = random_number_array[current_step*simulation_agents_number + tid];
    double threshold;
    int agent_current_num_neighbor = agent->number_of_neighbors_affected;
    float agent_income = agent->income;
    threshold = coefficient1 * agent_income + coefficient2 * agent_current_num_neighbor/agents_max_degree;
    // std::cout << threshold << random_num << std::endl;
    if (threshold > random_num){
        // std::cout << "enter" << std::endl;
        // printf("enter \n");
        // printf("threshold %f random_number:%f",threshold,random_num);
        // current_number_adoption += 1;
        agent->affected = 1;
        atomicAdd(current_number_adoption,1);
        for(int k = neighbors_prefix_sum[tid]; k < neighbors_prefix_sum[tid] + number_neighbors_each_agent[tid] ; k++){
            atomicAdd(&((&agents[neighbors_array[k]])->number_of_neighbors_affected),1);
            // agents[neighbors_array[k]].number_of_neighbors_affected += 1;
        }
    }
    }



__global__ void update_adoption(int current_step, int simulation_agents_number, Agent* agents, int agents_max_degree, 
    int* neighbors_prefix_sum, int*neighbors_array,int* number_neighbors_each_agent,int* current_number_adoption, float* random_number_array, float* agent_threshold_array, int* adoption_history_array){
    int tid = threadIdx.x + blockIdx.x * blockDim.x;
    if (tid >= simulation_agents_number)
    {
    return;
    }
    Agent* agent = &agents[tid];
    if (agent->affected == 1){
        return;
    }
    float random_num = random_number_array[current_step*simulation_agents_number + tid];
    float threshold = agent_threshold_array[tid];
    if (threshold > random_num){
        agent->affected = 1;
        int temp;
        temp = atomicAdd(current_number_adoption,1);
        adoption_history_array[temp] = tid;
        // for(int k = neighbors_prefix_sum[tid]; k < neighbors_prefix_sum[tid] + number_neighbors_each_agent[tid] ; k++){
        //     atomicAdd(&((&agents[neighbors_array[k]])->number_of_neighbors_affected),1);
        // }
    }
    }

__global__ void update_affection(int agent_index,int number,Agent* agents,int* neighbors_prefix_sum, int* neighbors_array){
    int tid = threadIdx.x + blockIdx.x * blockDim.x;
    if (tid >= number)
    {
    return;
    }
    // Agent* agent = &agents[agent_index];
    int start_position = neighbors_prefix_sum[agent_index];
    (&agents[neighbors_array[start_position+tid]])->number_of_neighbors_affected += 1;
}

__global__ void record_current_number_adoption(int* current_number_adoption, int* current_adoption_array, int step){
    
    current_adoption_array[step] = *current_number_adoption;
    printf("%d \n", *current_number_adoption);
}

__global__ void print_random_number_array(float* random_number_array,int number){
    for(int i =0; i <number;i++ ){
        printf("%f \n",random_number_array[i]);
    }
}
int find_arg_idx(int argc, char** argv, const char* option) {
    for (int i = 1; i < argc; ++i) {
        if (strcmp(argv[i], option) == 0) {
            return i;
        }
    }
    return -1;
}


int find_int_arg(int argc, char** argv, const char* option, int default_value) {
    int iplace = find_arg_idx(argc, argv, option);

    if (iplace >= 0 && iplace < argc - 1) {
        return std::stoi(argv[iplace + 1]);
    }

    return default_value;
}


float find_float_arg(int argc, char** argv, const char* option, float default_value) {
    int iplace = find_arg_idx(argc, argv, option);

    if (iplace >= 0 && iplace < argc - 1) {
        return std::stof(argv[iplace + 1]);
    }

    return default_value;
}

int main(int argc, char**argv) {
    int total_simulation_step = 700;
    total_simulation_step = find_int_arg(argc, argv,"-steps", 1000);
    std::vector<int> number_adoption(total_simulation_step);



    int simulation_agents_number;

    long neighbors_number;
    int agents_max_degree = 0;
    float scale;
    initialize_basic_variables("agents.txt", "neighbors.txt",&simulation_agents_number, &scale, &neighbors_number );
    Agent* agents = new Agent[simulation_agents_number];
    int* neighbors_array = new int[neighbors_number];
    int* neighbors_prefix_sum = new int[simulation_agents_number];
    int* number_neighbors_each_agent = new int[simulation_agents_number];
    int* adoption_history_array = new int[simulation_agents_number];
    std::mt19937 gen(12); 
    std::uniform_real_distribution<> dis(0.0, 1.0);
    // std::vector<float> random_number_array(total_simulation_step*simulation_agents_number);
    float* random_number_array = new float[total_simulation_step*simulation_agents_number];
    for(int i =0; i < total_simulation_step*simulation_agents_number;i++){
        random_number_array[i] = dis(gen);
    }
    int block_number_agents = ceil(simulation_agents_number/NUM_THREADS) + 1;
    int block_number_neighbors=ceil(neighbors_number/NUM_THREADS) + 1;
    
    int current_number_adoption = 0;
    int* d_current_number_adoption;
    float* agent_threshold_array = new float[simulation_agents_number];
    for(int i =0; i < simulation_agents_number;i++){
        agent_threshold_array[i] = 0;
    }


    int* current_adoption_array = new int[total_simulation_step];
    for(int i =0; i < total_simulation_step;i++){
        current_adoption_array[i] = 0;
    }
    std::cout<<"finish generate"<<std::endl;

    initialize_agents("agents.txt", agents);
    initialize_neighbors("neighbors.txt", neighbors_array);
    initialize_neighbor_prefix("neighbor_prefix.txt", neighbors_prefix_sum);

    initialize_number_neighbors_each_agent("number_neighbors_each_agent.txt", number_neighbors_each_agent, &agents_max_degree);



    cudaMalloc((void**)&d_random_number_array, simulation_agents_number*total_simulation_step* sizeof(float));
    cudaMemcpy(d_random_number_array, random_number_array,simulation_agents_number*total_simulation_step* sizeof(float),cudaMemcpyHostToDevice);
    auto start = std::chrono::high_resolution_clock::now();



    cudaMalloc((void**)&d_current_number_adoption, sizeof(int));
    cudaMemcpy(d_current_number_adoption, &current_number_adoption, sizeof(int), cudaMemcpyHostToDevice);

    cudaMalloc((void**)&d_agents, simulation_agents_number* sizeof(Agent));
    // copy_agent_objects<<<block_number_agents,NUM_THREADS >>>(d_agents,agents,simulation_agents_number);
    cudaMemcpy(d_agents, agents, simulation_agents_number* sizeof(Agent), cudaMemcpyHostToDevice);

    // cudaDeviceSynchronize();
    // cudaError_t cudaerr = cudaDeviceSynchronize();
    // if (cudaerr != cudaSuccess)
    //     printf("kernel launch failed with error \"%s\".\n",cudaGetErrorString(cudaerr));
    cudaMalloc((void**)&d_neighbors_prefix_sum, simulation_agents_number* sizeof(int));
    cudaMemcpy(d_neighbors_prefix_sum, neighbors_prefix_sum, simulation_agents_number* sizeof(int), cudaMemcpyHostToDevice);

    cudaMalloc((void**)&d_number_neighbors_each_agent, simulation_agents_number* sizeof(int));
    cudaMemcpy(d_number_neighbors_each_agent, number_neighbors_each_agent, simulation_agents_number* sizeof(int), cudaMemcpyHostToDevice);

    cudaMalloc((void**)&d_neighbors_array, neighbors_number* sizeof(int));
    cudaMemcpy(d_neighbors_array, neighbors_array, neighbors_number* sizeof(int), cudaMemcpyHostToDevice);

    // cudaMalloc((void**)&d_random_number_array, simulation_agents_number*total_simulation_step* sizeof(float));
    // cudaMemcpy(d_random_number_array, random_number_array,simulation_agents_number*total_simulation_step* sizeof(float),cudaMemcpyHostToDevice);
    
    cudaMalloc((void**)&d_current_adoption_array, total_simulation_step* sizeof(int));
    cudaMemcpy(d_current_adoption_array, current_adoption_array, total_simulation_step* sizeof(int), cudaMemcpyHostToDevice);


    
    cudaMalloc((void**)&d_agent_threshold_array, simulation_agents_number* sizeof(float));
    cudaMemcpy(d_agent_threshold_array, agent_threshold_array,simulation_agents_number* sizeof(float),cudaMemcpyHostToDevice);

    cudaMalloc((void**)&d_adoption_history_array, simulation_agents_number* sizeof(int));
    cudaDeviceSynchronize();
    // for(int i=0; i < simulation_agents_number;i++){
    //     std::cout <<  random_number_array[i] << std::endl;
    // }
    // print_random_number_array<<<1,1>>>(d_random_number_array,simulation_agents_number);
    // cudaError_t cudaerr = cudaDeviceSynchronize();
    // if (cudaerr != cudaSuccess)
    //     printf("kernel launch failed with error \"%s\".\n",cudaGetErrorString(cudaerr));


    // step_all(total_simulation_step,simulation_agents_number, agents,agents_max_degree, 
    //      number_adoption.data(), neighbors_prefix_sum.data(),neighbors_array.data(),number_neighbors_each_agent.data(),current_number_adoption);

    // auto start = std::chrono::high_resolution_clock::now();
    // for(int i =0 ; i< total_simulation_step;i++){
    //     current_number_adoption = step_later_update(i,simulation_agents_number, agents,agents_max_degree, 
    //     neighbors_prefix_sum,neighbors_array,number_neighbors_each_agent,current_number_adoption,random_number_array);
    //     number_adoption[i] = current_number_adoption;
    //     std::cout << number_adoption[i] << std::endl;
    // }


    int previous_number_adoption = 0;
    for(int i =0 ; i< total_simulation_step;i++){
        // calculate_threshold<<<block_number_agents,NUM_THREADS>>>(i,simulation_agents_number, agents, agents_max_degree,d_random_number_array,
        //                             d_agent_threshold_array);
        calculate_threshold<<<block_number_agents,NUM_THREADS>>>(i,simulation_agents_number, d_agents,agents_max_degree, 
         d_agent_threshold_array);
        // cudaDeviceSynchronize();
        update_adoption<<<block_number_agents,NUM_THREADS>>>(i,simulation_agents_number, d_agents,agents_max_degree, 
         d_neighbors_prefix_sum,d_neighbors_array,d_number_neighbors_each_agent,d_current_number_adoption,d_random_number_array,d_agent_threshold_array,d_adoption_history_array);
        record_current_number_adoption<<<1,1>>>(d_current_number_adoption,d_current_adoption_array,i);
        cudaMemcpy(&current_number_adoption, d_current_number_adoption, sizeof(int), cudaMemcpyDeviceToHost);
        cudaMemcpy(adoption_history_array + previous_number_adoption, d_adoption_history_array+previous_number_adoption, sizeof(int)*(current_number_adoption-previous_number_adoption), cudaMemcpyDeviceToHost);
        // cudaMemcpy(adoption_history_array, d_adoption_history_array, sizeof(int)*(simulation_agents_number), cudaMemcpyDeviceToHost);
        cudaDeviceSynchronize();
        current_adoption_array[i] = current_number_adoption;
        for(int j =previous_number_adoption; j < current_number_adoption;j++){
            int number_neighbors_one_agent = number_neighbors_each_agent[adoption_history_array[j]];
            int temp_block_num = ceil(number_neighbors_one_agent/NUM_THREADS) + 1;
            // std::cout <<"agent:" <<adoption_history_array[j] << "# neighbor"<< number_neighbors_one_agent<<std::endl;
            update_affection<<<temp_block_num,NUM_THREADS>>>(adoption_history_array[j],number_neighbors_one_agent,d_agents,d_neighbors_prefix_sum, d_neighbors_array);
        }
        cudaDeviceSynchronize();
        previous_number_adoption = current_number_adoption;
    }

    // cudaError_t cudaerr = cudaDeviceSynchronize();
    // if (cudaerr != cudaSuccess)
    //     printf("kernel launch failed with error \"%s\".\n",cudaGetErrorString(cudaerr));




    // for(int i =0 ; i< total_simulation_step;i++){
    //     step_gpu<<<block_number_agents,NUM_THREADS>>>(i,simulation_agents_number, d_agents,agents_max_degree, 
    //      d_neighbors_prefix_sum,d_neighbors_array,d_number_neighbors_each_agent,d_current_number_adoption,d_random_number_array);
    //     // step_gpu<<<block_number_agents,NUM_THREADS>>>(i,simulation_agents_number, d_agents,agents_max_degree, 
    //     //  d_neighbors_prefix_sum,d_neighbors_array,d_number_neighbors_each_agent,d_current_number_adoption,d_random_number_array);
    //     cudaDeviceSynchronize();
    //     record_current_number_adoption<<<1,1>>>(d_current_number_adoption,d_current_adoption_array,i);
    // }

    // transition(total_simulation_step,simulation_agents_number, agents,agents_max_degree, 
    //      number_adoption.data(), neighbors_prefix_sum.data(),neighbors_array.data(),number_neighbors_each_agent.data());

    // step( simulation_agents_number, agents.data(),agents_max_degree, 
    //      number_adoption.data(), neighbors_prefix_sum.data(),neighbors_array.data(),number_neighbors_each_agent.data());
    
    // for (int i=0; i < simulation_agents_number; i++){
    //   if(agents[i].affected){
    //     std::cout << agents[i].zipcode<<std::endl;
    //   }
    // }
    

    // for(int i =0 ; i< total_simulation_step;i++){
    //     current_number_adoption = step(i,simulation_agents_number, agents,agents_max_degree, 
    //      neighbors_prefix_sum,neighbors_array,number_neighbors_each_agent,current_number_adoption,random_number_array);
    //     number_adoption[i] = current_number_adoption;
    //     std::cout << number_adoption[i] << std::endl;
    // }


    // for(int i =0 ; i< total_simulation_step;i++){
    //     current_number_adoption = step(i,simulation_agents_number, agents,agents_max_degree, 
    //      neighbors_prefix_sum,neighbors_array,number_neighbors_each_agent,current_number_adoption,random_number_array);
    //     number_adoption[i] = current_number_adoption;
    //     std::cout << number_adoption[i] << std::endl;
    // }

    // cudaDeviceSynchronize();
    auto end = std::chrono::high_resolution_clock::now();
    auto duration = std::chrono::duration_cast<std::chrono::microseconds>(end - start);
  
    std::cout << "Time taken: " << duration.count() << " microseconds" << std::endl;


    delete[] agents;
    delete[] neighbors_prefix_sum;
    delete[] number_neighbors_each_agent;
    delete[] random_number_array;
    delete[] neighbors_array;
    cudaFree(d_neighbors_array);
    cudaFree(d_agents);
    cudaFree(d_neighbors_prefix_sum);
    cudaFree(d_number_neighbors_each_agent);
    cudaFree(d_random_number_array);
    return 0;
}

