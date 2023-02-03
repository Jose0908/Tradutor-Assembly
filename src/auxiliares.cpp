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
		file.close();
		for (int i = 0; i < lines.size(); i++) { 											// Transforma o programa todo para caixa alta
			transform(lines[i].begin(), lines[i].end(), lines[i].begin(), ::toupper);
		}
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
