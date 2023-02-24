#include "../headers/montador.h"

// Le arquivos
vector<string> read_file(const string &file_name) {
	vector<string> lines;
	string line;

	ifstream file(file_name); 																// abre o arquivo para leitura
	if (file.is_open()) {
		while (getline(file, line)) {
			lines.push_back(line);
		}
		file.close(); 																		// fecha o arquivo
	}
	return lines;
}
// Escreve arquivos .pre e .mcr
void write_file(vector<string> vector_name, string file_name, string extension) {
  ofstream file(file_name + extension); 													// Abre o arquivo para gravação
  if (!file.is_open()) 				 														// Verifica se o arquivo foi aberto com sucesso
    cerr << "Erro ao abrir o arquivo!" << endl;
  for (const string& s : vector_name) {   												// Escreve o vetor no arquivo, uma string por linha
    file << s << endl;
  }
  file.close(); 																			// Fecha o arquivo
}
// Escreve arquivo .obj
void write_string_to_file (string string_name, string file_name, string extension) {
	ofstream file(file_name + extension); 													// Abre o arquivo para gravação
	if (!file.is_open()) 				 														// Verifica se o arquivo foi aberto com sucesso
		cerr << "Erro ao abrir o arquivo!" << endl;
	file << string_name << endl; 															// Escreve a string no arquivo
	file.close(); 																			// Fecha o arquivo
}
void print_vector (vector<string> vector) {													// Usado principalmente na macro para fins de debug
	for (string line : vector) {
		cout << line << endl;
	}
}
void print_map(map<string, int> symbol_table) {
	for_each(symbol_table.begin(), symbol_table.end(), [](const auto& p) {
	cout << p.first << ": " << p.second << endl;
	});
}

string const_to_db(string line) {
    string output;
    string label;
    string num;

    for (int i = 0; i < line.size(); i++) {
        if (line[i] == ':') {
            label = line.substr(0, i+1);
            break;
        }
        size_t found = line.find("CONST ");
        if (found != string::npos) {
            num = line.substr(found+6);
        }
    }
    output = label + " dd " + num;

    return output;
}

	// RESULT: SPACE 5 -> result resd 5
string space_to_dd (string line) {
    string output;
    string label;
    string num;

    for (int i = 0; i < line.size(); i++) {
        if (line[i] == ':') {
            label = line.substr(0, i+1);
            break;
        }
	
        size_t found = line.find("SPACE");
        if (found != string::npos) {
			num = line.substr(found+5);
		}
	}
	if (num == "")
		num = " 1";
    output = label + " resd" + num;
    return output;
}

vector<string> concat_vectors(vector<string> vec1, vector<string> vec2, vector<string> vec3) {
	vector<string> result;
	for (const auto &str : vec1) {
		result.push_back(str);
	}
	for (const auto &str : vec2) {
		result.push_back(str);
	}
	for (const auto &str : vec3) {
		result.push_back(str);
	}
	return result;
}
vector<string> concat_asm(vector<string> vec1, vector<string> vec2) {
	vector<string> result;
	for (const auto &str : vec1) {
		result.push_back(str);
	}
	for (const auto &str : vec2) {
		result.push_back(str);
	}
	return result;
}

string offset_displacement(string argument) {
    int plus_ocurrence = argument.find('+');
	int minus_ocurrence = argument.find('-');
    if (plus_ocurrence != string::npos || minus_ocurrence != string::npos) {
		string num = argument.substr(plus_ocurrence+1);
		if (isdigit(num[0]))
			argument += "*4";
    }

    return argument;
}