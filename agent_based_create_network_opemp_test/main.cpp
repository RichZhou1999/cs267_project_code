#include <iostream>
#include <fstream>
#include <sstream>
#include <vector>
#include <numeric>
#include <random>
#include <nlohmann/json.hpp>
#include <cmath>
#include <chrono>
#include <vector>
#include <unordered_map>
#include <omp.h>

using json = nlohmann::json;
using namespace std;
// Define a struct to hold the vertex properties
// struct VertexProperties {
//   int zipcode;
//   int income;
//   int number_of_neighbors_affected;
// };

class Agent{
    public:
        int zipcode;
        float income;
        int number_of_neighbors_affected;
};

#define Distance_Matrix_Size 742
#define Distance_Rule_Constant 0.000005
#define TOTAL_AGENT 6897434
#define MAX_INCOME 200000.0

int binary_search(const vector<float>& arr, float target){

    if (target <= arr[0]){
        return 0;
    }
    if (target >= arr[arr.size()-1]){
        return arr.size()-1;
    }
    int left = 0;
    int right = arr.size() - 1;
    while(left <= right){
        int mid = left + (right - left) / 2;

        if (arr[mid] == target) {
            return mid;
        } else if (arr[mid] < target) {
            left = mid + 1;
        } else {
            right = mid - 1;
        } 
    }
    return right;
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
    // Open the CSV file
    // ifstream file("BEV_data.csv");
    // auto start_time = std::chrono::high_resolution_clock::now();
    float scale = 0.000439;
    scale = find_float_arg(argc, argv,"-scale", 0.0001);
    int num_threads = 8;
    num_threads = find_int_arg(argc, argv,"-p", 8);
    

    std::ifstream file;
    file.open("../BEV_data.csv");

    // Check if the file was opened successfully
    if (!file.is_open()) {
        cout << "Failed to open file" << endl;
        return 1;
    }

    // Initialize variables for storing the CSV data
    vector<vector<string>> data;
    string line;
    getline(file, line);
    // Read the CSV file line by line
    while (getline(file, line)) {
        // Initialize a stringstream with the current line
        stringstream ss(line);

        // Initialize a vector to store the current row of data
        vector<string> row;

        // Split the line into individual values and store them in the row vector
        string value;
        getline(ss, value, ',');
        while (getline(ss, value, ',')) {
            row.push_back(value);
        }

        // Add the row vector to the data vector
        data.push_back(row);
    }

    // Close the file
    file.close();


    std::ifstream distance_file;
    distance_file.open("../distance_matrix.csv");

    // Check if the file was opened successfully
    if (!distance_file.is_open()) {
        cout << "Failed to open file" << endl;
        return 1;
    }

    // Initialize variables for storing the CSV data
    vector<vector<float>> distance_matrix;
    string distance_line;
    // Read the CSV file line by line
    while (getline(distance_file, distance_line)) {
        // Initialize a stringstream with the current line
        stringstream ss(distance_line);

        // Initialize a vector to store the current row of data
        vector<float> row;

        // Split the line into individual values and store them in the row vector
        string value;
        while (getline(ss, value, ',')) {
            row.push_back(stof(value));
        }

        // Add the row vector to the data vector
        distance_matrix.push_back(row);
    }

    distance_file.close();

    std::ifstream infile("../zipcode_index_dict.json");
    json zipcode_index_json;
    infile >> zipcode_index_json;

    std::unordered_map<int, int> zipcode_index_dict;
    for (auto& [key, value] : zipcode_index_json.items()) {
        zipcode_index_dict[std::stoi(key)] = value;
    }

    // std::unordered_map<int, std::vector<int>> neighbor_map;



    // auto start_time = std::chrono::high_resolution_clock::now();
    int simulation_agents_number = 0;
    for (std::vector<int>::size_type i = 0; i < data.size(); i++) {
        simulation_agents_number += stoi(data[i][2])* scale;
    }
    std::vector<int> simulation_agents_prefix_sum(data.size());
    int temp_simulation_agent_number = 0;
    std::vector<int> neighbor_map[simulation_agents_number];

    for (std::vector<int>::size_type i = 0; i < data.size(); i++) {
        simulation_agents_prefix_sum[i] = temp_simulation_agent_number;
        temp_simulation_agent_number += stoi(data[i][2])* scale;
    }

    std::vector<int> number_neighbors_each_agent(simulation_agents_number);
    // int number_neighbors_each_agent[simulation_agents_number]={0};
    for (int i = 0 ; i <simulation_agents_number; i++ ){
        number_neighbors_each_agent[i] =0;
    }

    std::vector<int> neighbors_prefix_sum(simulation_agents_number);

    int total_number_neighbors = 0;

    std::vector <omp_lock_t> neighbor_map_locks;
    neighbor_map_locks = std::vector<omp_lock_t> (simulation_agents_number);

    std::cout << simulation_agents_number << std::endl;
    Agent* agents = new Agent[simulation_agents_number];
    // int current_agent_index = 0;
    // int* current_agent_index_pointer = &current_agent_index;
    // std::random_device rd;
    std::mt19937 gen(1); 
    std::uniform_real_distribution<> dis(0.0, 1.0);
    std::vector<float> random_number_vertices (simulation_agents_number);
    std::vector<float> random_number_edges (simulation_agents_number*(simulation_agents_number-1)/2);
    for(int i =0; i < simulation_agents_number; i++){
        random_number_vertices[i] = dis(gen);
    }
    for(int i =0; i < simulation_agents_number*(simulation_agents_number-1)/2; i++){
        random_number_edges[i] = dis(gen);
    }
    std::vector<int> edges_prefix_sum(simulation_agents_number);
    int temp_edge_sum = 0;
    for(int i =0; i < simulation_agents_number; i++){
        edges_prefix_sum[i]= temp_edge_sum;
        temp_edge_sum += simulation_agents_number-1-i;
    }
    // int core_number = omp_get_num_procs();
    // std::cout << core_number << std::endl;
    std::vector<int> neighbors_array;
    // auto start_time = std::chrono::high_resolution_clock::now();
    // auto t1 = std::chrono::high_resolution_clock::now();
    // auto duration1 = std::chrono::duration_cast<std::chrono::microseconds>(t1 - start_time);
    // std::cout << "Time taken: " << duration1.count() << " microseconds" << std::endl;
    // std::vector<int> neighbor_map_sizes(simulation_agents_number);
    auto start_time = std::chrono::high_resolution_clock::now();
    omp_set_num_threads(num_threads);
    // auto start_time = std::chrono::high_resolution_clock::now();
    #pragma omp parallel default(shared)
    {
    #pragma omp for
    for (std::vector<int>::size_type i = 0; i < data.size(); i++) {
            int total_people;
            int zipcode;
            zipcode = stoi(data[i][0]);
            total_people = stoi(data[i][2]);
            std::vector<int> income_values = {5000, 12500, 20000, 30000, 42750, 67500,
                          87500, 125000, 175000, 200000};
            int num_income_values = sizeof(income_values) / sizeof(int);
            std::vector<float> probability_list(num_income_values);
            for (int k =0; k<num_income_values;k++){
                probability_list[k] = std::stof(data[i][k+4])/100;
            }
            std::vector<float> probability_prefix_sum(probability_list.size());
            std::partial_sum(probability_list.begin(), probability_list.end(), probability_prefix_sum.begin());
            int simulate_num_people = stoi(data[i][2]) * scale;

            for (int p=0;p<simulate_num_people;p++ ){
                // float random_num = dis(gen);
                float random_num = random_number_vertices[simulation_agents_prefix_sum[i] +p];
                int pos = binary_search(probability_prefix_sum, random_num);
                agents[simulation_agents_prefix_sum[i] +p].income = income_values[pos]/MAX_INCOME;
                agents[simulation_agents_prefix_sum[i] +p].zipcode = zipcode;
                agents[simulation_agents_prefix_sum[i] +p].number_of_neighbors_affected = 0;
                
            }
    }

    // int step = 0;
    #pragma omp for schedule(dynamic)
    for( int i = 0; i <simulation_agents_number; i++ ){
        // std::cout << step++ << "\n";
        int index1 = zipcode_index_dict[agents[i].zipcode];
        for (int j = i + 1; j < simulation_agents_number; j++){
            int index2 = zipcode_index_dict[agents[j].zipcode];
            float distance = distance_matrix[index1][index2];
            float random_num = random_number_edges[edges_prefix_sum[i] + j-i-1];
            float threshold;
            if (distance == 0){
                threshold = 1;
            }else{
                threshold = pow(distance, -1.2) + Distance_Rule_Constant;
            }
            if (threshold > random_num){
                #pragma omp atomic
                number_neighbors_each_agent[i] += 1;
                #pragma omp atomic
                number_neighbors_each_agent[j] += 1;

                // #pragma omp critical
                // {
                //     neighbor_map[i].push_back(j);
                //     neighbor_map[j].push_back(i);
                // }

                // std::cout<<i << " "<< j <<"\n" <<std::flush ;

                // #pragma omp atomic capture
                // int size_i = neighbor_map_sizes[i];
                // neighbor_map_sizes[i]++;
                // neighbor_map[i].resize(size_i + 1);
                // neighbor_map[i][size_i] = j;


                // #pragma omp atomic capture
                // int size_j = neighbor_map_sizes[j];
                // neighbor_map[j].resize(size_j + 1);
                // neighbor_map[j][size_j] = i;

                omp_set_lock(&neighbor_map_locks[i]);
                neighbor_map[i].push_back(j);
                omp_unset_lock(&neighbor_map_locks[i]);
                omp_set_lock(&neighbor_map_locks[j]);
                neighbor_map[j].push_back(i);
                omp_unset_lock(&neighbor_map_locks[j]);
            
                // if ( (j <= i + num_threads*3)){

                //     #pragma omp atomic
                //     number_neighbors_each_agent[i] += 1;
                //     #pragma omp atomic
                //     number_neighbors_each_agent[j] += 1;

                //     omp_set_lock(&neighbor_map_locks[i]);
                //     neighbor_map[i].push_back(j);
                //     omp_unset_lock(&neighbor_map_locks[i]);
                //     omp_set_lock(&neighbor_map_locks[j]);
                //     neighbor_map[j].push_back(i);
                //     omp_unset_lock(&neighbor_map_locks[j]);
                // }else{
                //     number_neighbors_each_agent[i] += 1;

                //     #pragma omp atomic
                //     number_neighbors_each_agent[j] += 1;


                //     // omp_set_lock(&neighbor_map_locks[i]);
                //     neighbor_map[i].push_back(j);
                //     // omp_unset_lock(&neighbor_map_locks[i]);
                //     omp_set_lock(&neighbor_map_locks[j]);
                //     neighbor_map[j].push_back(i);
                //     omp_unset_lock(&neighbor_map_locks[j]);
                // }
            
            
            }
        }   
    }
    



    #pragma omp single
    {
    for( int i =0 ; i < simulation_agents_number;i++ ){
        neighbors_prefix_sum[i] = total_number_neighbors;
        // std::cout <<total_number_neighbors<<std::endl;
        total_number_neighbors += number_neighbors_each_agent[i];
    }
    // for( int i =0 ; i < simulation_agents_number;i++ ){
    //     std::cout <<neighbors_prefix_sum[i]<<std::endl;
    // }
    neighbors_array.resize(total_number_neighbors);
    }
    #pragma omp for schedule(dynamic)
    for ( int i =0 ; i < simulation_agents_number;i++ ){
        for(std::vector<int>::size_type j =0; j < neighbor_map[i].size();j++){
            neighbors_array[neighbors_prefix_sum[i] + j] = neighbor_map[i][j];
        }
    }

    #pragma omp single
    {
    auto end_time = std::chrono::high_resolution_clock::now();
    auto duration = std::chrono::duration_cast<std::chrono::microseconds>(end_time - start_time);
    std::cout << "Time taken: " << duration.count() << " microseconds" << std::endl;
    ofstream myfile ("agents.txt");
    if (myfile.is_open())
    {
        myfile << simulation_agents_number << "\n";
        for (int i=0; i<simulation_agents_number; ++i)
        {
            myfile << agents[i].zipcode << " " << agents[i].income<< " " << agents[i].number_of_neighbors_affected << "\n";
        }
    myfile.close();
    }
    ofstream myfile2 ("neighbor_prefix.txt");

    if (myfile2.is_open())
    {
        myfile2 << simulation_agents_number << "\n";
        for (int i=0; i<simulation_agents_number; ++i)
        {
            myfile2 <<neighbors_prefix_sum[i] << "\n";
        }
    myfile2.close();
    }

    ofstream myfile3 ("neighbors.txt");

    if (myfile3.is_open())
    {
        myfile3 << total_number_neighbors << "\n";
        for (int i=0; i<total_number_neighbors; ++i)
        {
            myfile3 <<neighbors_array[i] << "\n";
        }
    myfile3.close();
    }
    ofstream myfile4 ("number_neighbors_each_agent.txt");
    if (myfile4.is_open())
    {
        myfile4 << simulation_agents_number << "\n";
        for (int i=0; i<simulation_agents_number; ++i)
        {
            myfile4 <<number_neighbors_each_agent[i] << "\n";
        }
    myfile4.close();
    }
      delete[] agents;

    }
    }
}