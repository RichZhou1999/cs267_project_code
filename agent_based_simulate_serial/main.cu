// #include <iostream>
// #include <fstream>
// #include <sstream>
// #include <vector>
// #include <numeric>
// #include <random>
// #include <cmath>
// #include <chrono>
// #include <vector>
// #include <unordered_map>
// #include <cuda.h>
// #include "common.h"

// #define TOTAL_AGENT 6897434
// #define coefficient1 0.00000928
// // #define coefficient1 0.00928
// #define coefficient2 0.00843


// void initialize_basic_variables(const char* agent_txt_name, const char* neighbor_txt_name, int*simulation_agents_number_pointer, float*scale_pointer, long* neighbors_number_pointer ){
//     std::ifstream file(agent_txt_name);
//     if (file.is_open()) {
//         file >> (*simulation_agents_number_pointer);
//         *scale_pointer = (*simulation_agents_number_pointer) / TOTAL_AGENT;
//         std::cout << "simulation_agents_number: "<< (*simulation_agents_number_pointer) <<  "\n";
//         file.close();
//     }
//     std::ifstream file2(neighbor_txt_name);
//     if (file2.is_open()) {
//         file2 >> (*neighbors_number_pointer);
//         std::cout << "neighbor_number: "<< (*neighbors_number_pointer) <<  "\n";
//         file2.close();
//     }

// }

// void initialize_agents(const char* txt_name , Agent* agents){
//     int simulation_agents_number;
//     std::ifstream file("agents.txt");
//     if (file.is_open()) {
//         file >> simulation_agents_number;
//         int zip,num_neigh;
//         float inc;
//         for ( int i =0; i < simulation_agents_number ; i++){
//             file >> zip >> inc >> num_neigh;
//             agents[i] = Agent(zip, inc, num_neigh);
//         }
//         file.close();
//     }
// }

// void initialize_neighbors(const char* txt_name, int* neighbors_array){
//     std::ifstream file(txt_name);
//     long neighbors_number;
//     if (file.is_open()) {
//         file >> neighbors_number;
//         int neighbor;
//         for ( int i =0; i < neighbors_number ; i++){
//             file >> neighbor;
//             neighbors_array[i] = neighbor;
//         }
//     }
// }

// void initialize_neighbor_prefix(const char* txt_name, int* neighbors_prefix_sum_pointer){
//     std::ifstream file(txt_name);
//     int simulation_agents_number;
//     if (file.is_open()) {
//         file >> simulation_agents_number;
//         int temp;
//         for ( int i =0; i < simulation_agents_number ; i++){
//             file >> temp;
//             neighbors_prefix_sum_pointer[i] = temp;
//         }
//     }
// }



// void initialize_number_neighbors_each_agent(const char* txt_name, int* number_neighbors_each_agent, int* agents_max_degree_pointer){
//     std::ifstream file(txt_name);
//     int simulation_agents_number;
//     if (file.is_open()) {
//         file >> simulation_agents_number;
//         int temp;
//         for ( int i =0; i < simulation_agents_number ; i++){
//             file >> temp;
//             number_neighbors_each_agent[i] = temp;
//             if (temp > (*agents_max_degree_pointer)){
//                 (*agents_max_degree_pointer) = temp;
//             }
//         }
//     }
// }


// int step(int current_step, int simulation_agents_number, Agent* agents, int agents_max_degree, 
//          int* neighbors_prefix_sum, int*neighbors_array,int* number_neighbors_each_agent,int current_number_adoption, float* random_number_array){
//     // std::mt19937 gen(seed); 
//     // std::uniform_real_distribution<> dis(0.0, 1.0);
//     agents[0].affected = 1;
//     // std::cout<< simulation_agents_number_s<<std::endl;
//     for (int j = 0 ; j < simulation_agents_number ; j++){
//         //float might not be proper
//         double random_num = random_number_array[current_step*simulation_agents_number + j];
//         double threshold;
//         if (agents[j].affected == 1){
//             continue;
//         }
//         int agent_current_num_neighbor = agents[j].number_of_neighbors_affected;
//         float agent_income = agents[j].income;
//         threshold = coefficient1 * agent_income + coefficient2 * agent_current_num_neighbor/agents_max_degree;
//         // std::cout << threshold << random_num << std::endl;
//         if (threshold > random_num){
//             // std::cout << "enter" << std::endl;
//             current_number_adoption += 1;
//             agents[j].affected = 1;
//             for(int k = neighbors_prefix_sum[j]; k < neighbors_prefix_sum[j] + number_neighbors_each_agent[j] ; k++){
//                 agents[neighbors_array[k]].number_of_neighbors_affected += 1;
//             }
//         }
//     }
//     // std::cout << current_number_adoption<<std::endl;
//     return current_number_adoption;
// }



// int step_later_update(int current_step, int simulation_agents_number, Agent* agents, int agents_max_degree, 
//          int* neighbors_prefix_sum, int*neighbors_array,int* number_neighbors_each_agent,int current_number_adoption, float* radom_number_array){
//     // std::mt19937 gen(seed); 
//     // std::uniform_real_distribution<> dis(0.0, 1.0);
//     std::vector<int> affected_this_step;
//     agents[0].affected = 1;
//     // std::cout<< simulation_agents_number_s<<std::endl;
//     for (int j = 0 ; j < simulation_agents_number ; j++){
//         //float might not be proper
//         double random_num = radom_number_array[current_step*simulation_agents_number + j];
//         double threshold;
//         if (agents[j].affected == 1){
//             continue;
//         }
//         int agent_current_num_neighbor = agents[j].number_of_neighbors_affected;
//         float agent_income = agents[j].income;
//         threshold = coefficient1 * agent_income + coefficient2 * agent_current_num_neighbor/agents_max_degree;
//         // std::cout << threshold << random_num << std::endl;
//         if (threshold > random_num){
//             // std::cout << "enter" << std::endl;
//             current_number_adoption += 1;
//             agents[j].affected = 1;
//             affected_this_step.push_back(j);
//             // for(int k = neighbors_prefix_sum[j]; k < neighbors_prefix_sum[j] + number_neighbors_each_agent[j] ; k++){
//             //     agents[neighbors_array[k]].number_of_neighbors_affected += 1;
//             // }
//         }
//     }

//     for (std::vector<int>::size_type j = 0 ; j < affected_this_step.size() ; j++){
//         int current_value = affected_this_step[j];
//         for(int k = neighbors_prefix_sum[current_value]; k < neighbors_prefix_sum[current_value] + number_neighbors_each_agent[current_value] ; k++){
//             agents[neighbors_array[k]].number_of_neighbors_affected += 1;
//         }
//     }

//     // std::cout << current_number_adoption<<std::endl;
//     return current_number_adoption;
// }


// // int step_all(int total_simulation_step, int simulation_agents_number, Agent* agents, int agents_max_degree, 
// //          int* number_adoption, int* neighbors_prefix_sum, int*neighbors_array,int* number_neighbors_each_agent,int current_number_adoption,int seed=12){
// //     std::mt19937 gen(seed); 
// //     std::uniform_real_distribution<> dis(0.0, 1.0);
// //     // std::cout<< simulation_agents_number_s<<std::endl;
// //     current_number_adoption = 0;
// //     for(int i =0; i <total_simulation_step;i++ ){

// //     for (int j = 0 ; j < simulation_agents_number ; j++){
// //         //float might not be proper
// //         double random_num = dis(gen);
// //         double threshold;
// //         if (agents[j].affected == 1){
// //             continue;
// //         }
// //         int agent_current_num_neighbor = agents[j].number_of_neighbors_affected;
// //         float agent_income = agents[j].income;
// //         threshold = coefficient1 * agent_income + coefficient2 * agent_current_num_neighbor/agents_max_degree;
// //         // std::cout << threshold << random_num << std::endl;
// //         if (threshold > random_num){
// //             current_number_adoption += 1;
// //             agents[j].affected = 1;
// //             for(int k = neighbors_prefix_sum[j]; k < neighbors_prefix_sum[j] + number_neighbors_each_agent[j] ; k++){
// //                 agents[neighbors_array[k]].number_of_neighbors_affected += 1;
// //             }
// //         }
// //     }
// //     std::cout << current_number_adoption<<std::endl;
// //     }
// //     return current_number_adoption;
// // }

// // void transition(int total_simulation_step, int simulation_agents_number, Agent* agents, int agents_max_degree, 
// //              int* number_adoption,int* neighbors_prefix_sum, int*neighbors_array,int* number_neighbors_each_agent,int seed=12){
// //     int current_number_adoption = 0;
// //     for(int i =0; i < total_simulation_step;i++){
// //         current_number_adoption = step(simulation_agents_number, agents,agents_max_degree, 
// //         neighbors_prefix_sum,neighbors_array,number_neighbors_each_agent,current_number_adoption,seed);
// //         number_adoption[i] = current_number_adoption;
// //         std::cout << number_adoption[i] << std::endl;
// //     }

// // }


// // int step(int simulation_agents_number, Agent* agents, int agents_max_degree, 
// //          int* number_adoption, int* neighbors_prefix_sum, int*neighbors_array,int* number_neighbors_each_agent,int current_number_adoption,int seed=12){
// //     std::mt19937 gen(seed); 
// //     std::uniform_real_distribution<> dis(0.0, 1.0);
// //     for (int j = 0 ; j < simulation_agents_number ; j++){
// //         //float might not be proper
// //         double random_num = dis(gen);
// //         double threshold;
// //         if (agents[j].affected == 1){
// //             continue;
// //         }
// //         int agent_current_num_neighbor = agents[j].number_of_neighbors_affected;
// //         float agent_income = agents[j].income;
// //         threshold = coefficient1 * agent_income + coefficient2 * agent_current_num_neighbor/agents_max_degree;
// //         if (threshold > random_num){
// //             // std::cout << "enter" << std::endl;
// //             current_number_adoption += 1;
// //             agents[j].affected = 1;
// //             for(int k = neighbors_prefix_sum[j]; k < neighbors_prefix_sum[j] + number_neighbors_each_agent[j] ; k++){
// //                 agents[neighbors_array[k]].number_of_neighbors_affected += 1;
// //             }
// //         }
// //     }
// //     return current_number_adoption;
// // }


// int main() {
//     int total_simulation_step = 700;
//     std::vector<int> number_adoption(total_simulation_step);



//     // Agent* agents = new Agent[];
//     // std::vector<Agent> agents;
//     int simulation_agents_number;

//     std::vector<int> neighbors_array;
//     long neighbors_number;
//     std::vector<int> neighbors_prefix_sum;
//     std::vector<int> number_neighbors_each_agent;
//     int agents_max_degree = 0;
//     float scale;
//     initialize_basic_variables("agents.txt", "neighbors.txt",&simulation_agents_number, &scale, &neighbors_number );
//     Agent* agents = new Agent[simulation_agents_number];
//     std::mt19937 gen(12); 
//     std::uniform_real_distribution<> dis(0.0, 1.0);
//     std::vector<float> random_number_array(total_simulation_step*simulation_agents_number);
//     for(int i =0; i < total_simulation_step*simulation_agents_number;i++){
//         random_number_array[i] = dis(gen);
//     }
//     std::cout<<"finish generate"<<std::endl;
//     // agents.resize(simulation_agents_number);
//     neighbors_prefix_sum.resize(simulation_agents_number);
//     number_neighbors_each_agent.resize(simulation_agents_number);
//     neighbors_array.resize(neighbors_number);

//     initialize_agents("agents.txt", agents);
//     initialize_neighbors("neighbors.txt", neighbors_array.data());
//     initialize_neighbor_prefix("neighbor_prefix.txt", neighbors_prefix_sum.data());

//     initialize_number_neighbors_each_agent("number_neighbors_each_agent.txt", number_neighbors_each_agent.data(), &agents_max_degree);

//     int current_number_adoption = 0;

//     // step_all(total_simulation_step,simulation_agents_number, agents,agents_max_degree, 
//     //      number_adoption.data(), neighbors_prefix_sum.data(),neighbors_array.data(),number_neighbors_each_agent.data(),current_number_adoption);

//     for(int i =0 ; i< total_simulation_step;i++){
//         current_number_adoption = step(i,simulation_agents_number, agents,agents_max_degree, 
//          neighbors_prefix_sum.data(),neighbors_array.data(),number_neighbors_each_agent.data(),current_number_adoption,random_number_array.data());
//         number_adoption[i] = current_number_adoption;
//         std::cout << number_adoption[i] << std::endl;
//     }

//     // transition(total_simulation_step,simulation_agents_number, agents,agents_max_degree, 
//     //      number_adoption.data(), neighbors_prefix_sum.data(),neighbors_array.data(),number_neighbors_each_agent.data());

//     // step( simulation_agents_number, agents.data(),agents_max_degree, 
//     //      number_adoption.data(), neighbors_prefix_sum.data(),neighbors_array.data(),number_neighbors_each_agent.data());
    
//     // for (int i=0; i < simulation_agents_number; i++){
//     //   if(agents[i].affected){
//     //     std::cout << agents[i].zipcode<<std::endl;
//     //   }
//     // }
//     return 0;
// }

















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
#define coefficient2 0.00843
#define NUM_THREADS 256

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
        // std::cout << "agent:" << current_value << "# neighbor" << number_neighbors_each_agent[current_value] << std::endl;
        for(int k = neighbors_prefix_sum[current_value]; k < neighbors_prefix_sum[current_value] + number_neighbors_each_agent[current_value] ; k++){
            agents[neighbors_array[k]].number_of_neighbors_affected += 1;
        }
    }

    // std::cout << current_number_adoption<<std::endl;
    return current_number_adoption;
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


    auto start = std::chrono::high_resolution_clock::now();
    for(int i =0 ; i< total_simulation_step;i++){
        current_number_adoption = step_later_update(i,simulation_agents_number, agents,agents_max_degree, 
         neighbors_prefix_sum,neighbors_array,number_neighbors_each_agent,current_number_adoption,random_number_array);
        number_adoption[i] = current_number_adoption;
        std::cout << number_adoption[i] << std::endl;
    }



    auto end = std::chrono::high_resolution_clock::now();
    auto duration = std::chrono::duration_cast<std::chrono::microseconds>(end - start);
  
    std::cout << "Time taken: " << duration.count() << " microseconds" << std::endl;

    delete[] agents;
    delete[] neighbors_prefix_sum;
    delete[] number_neighbors_each_agent;
    delete[] random_number_array;
    delete[] neighbors_array;
    return 0;
}

