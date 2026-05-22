#include <iostream>	
#include "node.hpp"
#include "tree.hpp"

using namespace strom;

const double Node::_smallest_edge_length = 1.0e-12;

int main(int argc, const char * argv[]) {
    std::cout << "Starting..." << std::endl;
    Tree tree;
    Node::Vector nodes = tree.nodes();
    for (int i = 0; i < nodes.size() ; i++) {

        std::cout << nodes[i].getName() << std::endl;
    }
    std::cout << "\nFinished!" << std::endl;

    return 0;
}  
