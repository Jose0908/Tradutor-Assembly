#include <iostream>
#include <fstream>
#include <string>
#include <vector>
#include <algorithm>
#include <map>

using namespace std;

vector<string> pre_processing(vector<string> program);
vector<string> macro_processing(vector<string> pre_processed);
string object_processing(vector<string> macro_processed);
vector<string> read_file(const string& file_name);
void write_file(vector<string> pre_processed, string file_name, string extension);
void write_string_to_file(string string_name, string file_name, string extension);
void print_vector(vector<string> vector);
void print_map(map<string, int> symbol_table);
void valid_arguments(string operand, int i);
void valid_symbol(string operand, int i, map <string, int> symbol_table);
void lexic_errors(map <string, int> symbol_table);
string object_constructor (string operand, map <string, int> symbol_table);
