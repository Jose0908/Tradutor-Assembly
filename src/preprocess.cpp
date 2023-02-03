#include "../headers/montador.h"

vector<string> pre_processing(vector<string> program) {
	vector<string> pre_processed;
	size_t pos;
	vector<string> equ_label;
	vector<string> equ_values;
	char delimiter = ':';

    // Remove Comentários
	for (int i = 0; i < program.size(); i++) {								
		pos = program[i].find(';');
		if (pos != string::npos) {
			program[i].erase(pos);
		}
	}
	// Remove linhas em branco
	for (string &s : program) {																
		if (s[0] != ' ' && s.size() > 0) {
			pre_processed.push_back(s);
		}
	}
    // Armazena o nome do rótulo antes de EQU e seu valor
	for (string &line : pre_processed) {	
		size_t found = line.find("EQU ");															
		if (found != string::npos) {
			equ_label.push_back(line.substr(0,line.find(delimiter)));
			equ_values.push_back(line.substr(line.find("EQU ")+4));
		}
	}
	// Substitui os rótulos por seus valores
	for (string &line : pre_processed) {	
		for (int i = 0; i < equ_label.size(); i++) {
			size_t found = line.find(equ_label[i]);
			if (found != string::npos) {
				line.replace(found, equ_label[i].size(), equ_values[i]);
			}
		}
	}
	// Remove linhas com EQU
	for (int i = 0; i < pre_processed.size(); i++) {
		size_t found = pre_processed[i].find("EQU ");
		if (found != string::npos) {
			pre_processed.erase(pre_processed.begin()+i);
			i--; // Pula o próximo elemento
		}
	}
	// Remove rotulos em linha
    for (string &line : pre_processed) {
		size_t size = line.size();
		while (size > 0 && line[size - 1] == ' ') {
			line.erase(size - 1, 1);
			size--;
		}
    }
	// Tratar da diretiva 'IF'
	for (int i = 0; i < pre_processed.size(); i++) {
		size_t found = pre_processed[i].find("IF ");
		if (found != string::npos) {
			found = pre_processed[i].find("IF 0");
			if (found != string::npos) {
				pre_processed.erase(pre_processed.begin()+i+1);
				pre_processed.erase(pre_processed.begin()+i);
				i--;
			}
			else {
				pre_processed.erase(pre_processed.begin()+i);
				i--;
			}	
		}
	}
	// Remove espaços duplos
	for (string &s : pre_processed) {
		for (int i = 0; i < s.size(); i++) {
			if (s[i] == ' ' && s[i+1] == ' ') {
				s.erase(i,1);
				i--;
			}
		}
	}
	// Remove espaços antes de vírgulas (copy)e antes do + (space com argumentos)
	for (string &s : pre_processed) {
		for (int i = 0; i < s.size(); i++) {
			if (s[i] == ' ' && (s[i+1] == ',' || s[i+1] == '+')) {
				s.erase(i,1);
				i--;
			}
			if ((s[i] == ',' || s[i] == '+') && (s[i+1] == ' ' )) {
				s.erase(i+1,1);
				i--;
			}
		}
	}
	// Concatena linhas que terminam com ":"
	for (int i = 0; i < pre_processed.size(); i++) {
		size_t last_char = pre_processed[i].size() - 1;
		if (pre_processed[i][last_char] == ':') {
			string next_line = " " + pre_processed[i + 1];
			pre_processed[i] += next_line;							
			pre_processed.erase(pre_processed.begin() + i + 1);
			i--;
		}
	}
	// Caso depois de : não tenha espaço, põe espaço
	for (string &s : pre_processed) {
		size_t found = s.find(":");
		if (found != string::npos) {
			if (s[found+1] != ' ') {
				s.insert(found+1, " ");
			}
		}
	}


	return pre_processed;
}


