#include "../headers/montador.h"

int main(int argc, char *argv[]) {
    // Pega argumentos da linha de comando
    string input_file = argv[1];
    string input_file_name = input_file.substr(0, input_file.find_last_of("."));

    // Lê arquivo
    vector<string> program = read_file(input_file);
    // Faz o pré-processamento
    vector<string> pre_processed = pre_processing(program);
    // Faz a traducao
    vector<string> translate = translating(pre_processed);
    write_file(pre_processed, input_file_name, ".pre");           // APAGAR ISSO
    write_file(translate, input_file_name, ".s");
    return 0;
}
