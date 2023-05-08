class Agent{
    public:
        int zipcode;
        float income;
        int number_of_neighbors_affected;
        int affected;
        Agent() {
            zipcode = 0;
            income = 0;
            number_of_neighbors_affected = 0;
            affected = 0;
        }
        Agent(int zip, float inc, int num_neigh) {
            zipcode = zip;
            income = inc;
            number_of_neighbors_affected = num_neigh;
            affected = 0;
        }
};