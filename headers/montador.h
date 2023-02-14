#include <iostream>
#include <fstream>
#include <string>
#include <vector>
#include <algorithm>
#include <map>
#include <sstream>

using namespace std;

vector<string> pre_processing(vector<string> program);
vector<string> translating (vector<string> translation);

vector<string> read_file(const string& file_name);
void write_file(vector<string> pre_processed, string file_name, string extension);
void write_string_to_file(string string_name, string file_name, string extension);
void print_vector(vector<string> vector);
void print_map(map<string, int> symbol_table);

string const_to_db(string line);
string space_to_dd (string line);
vector<string> concat_vectors(vector<string> vec1, vector<string> vec2, vector<string> vec3);
vector<string> concat_asm(vector<string> vec1, vector<string> vec2);

string offset_displacement(string argument);

