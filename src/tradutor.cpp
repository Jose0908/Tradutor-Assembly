#include "../headers/montador.h"

vector<string> translating (vector<string> translation) {
    vector<string> translate;
    vector<string> old_data_section, new_data_section;  // Old = assembly inventado, New = assembly x86
    vector<string> old_text_section, new_text_section;
    vector<string> old_bss_section, new_bss_section;

    bool section_data_founded = false;

    for (int i = 0; i < translation.size(); i++) {
        size_t found = translation[i].find("SECTION DATA"); //encontrou seção de dados
        if (found != string::npos) { 
            section_data_founded = true;
        }
        if (section_data_founded) {
            old_data_section.push_back(translation[i]);
        }
        else {
            old_text_section.push_back(translation[i]);
        }
    }

    // Separando seção de dados e bss
    for (int i = 0; i < old_data_section.size(); i++) {
        size_t found = old_data_section[i].find("SPACE");
        if (found != string::npos) {
            old_bss_section.push_back(old_data_section[i]);
            old_data_section.erase(old_data_section.begin()+i);
            i--;
        }
    }

    // Seção de dados
    new_data_section.push_back("section .data");
    for (int i = 1; i < old_data_section.size(); i++) {
        new_data_section.push_back(const_to_db(old_data_section[i]));
    }
    
    string out_message = "out_msg: db \" Quantidade de Bytes lidos/escritos: \",0";
    new_data_section.push_back(out_message);
    new_data_section.push_back("");         // Pula uma linha

    // Seção bss
    new_bss_section.push_back("section .bss");
    for (int i = 0; i < old_bss_section.size(); i++) {
        new_bss_section.push_back(space_to_dd(old_bss_section[i]));
    }
    new_bss_section.push_back("");          // Pula uma linha

    // Seção de texto
    new_text_section.push_back("section .text");
    new_text_section.push_back("global _start");
    new_text_section.push_back("_start:");

    for (int i = 1; i < old_text_section.size(); i++) {
        string command;
        string line_without_label = old_text_section[i];
        string out;
        string label;

        // Se não tem :, o que vem antes do primeiro espaço é command
        if (old_text_section[i].find(":") == string::npos) {
            command = old_text_section[i].substr(0, old_text_section[i].find(" "));
            label = "";
        }
        // Se tem :, o que vem depois do : e antes do segundo espaço é comando
        else {
            label = old_text_section[i].substr(0, old_text_section[i].find(":")+2);
            line_without_label = old_text_section[i].substr(old_text_section[i].find(":")+2);
            command = line_without_label.substr(0, line_without_label.find(" "));
        }
    

        if (command == "ADD") {
            string argument = line_without_label.substr(line_without_label.find(" ")+1);
            argument = offset_displacement(argument);
            stringstream ss;
            ss << label << "add dword eax, [" << argument << "]";
            out = ss.str();
            new_text_section.push_back(out);
        }
    
        else if (command == "SUB") {
            string argument = line_without_label.substr(line_without_label.find(" ")+1);
            argument = offset_displacement(argument);
            stringstream ss;
            ss << label << "sub dword eax, [" << argument << "]";
            out = ss.str();
            new_text_section.push_back(out);
        }
        else if (command == "MULT") {
            string argument = line_without_label.substr(line_without_label.find(" ")+1);
            argument = offset_displacement(argument);
            stringstream ss;
            ss << label << "imul dword [" << argument << "]";
            out = ss.str();
            new_text_section.push_back(out);
        }
    
        else if (command == "DIV") {
            string argument = line_without_label.substr(line_without_label.find(" ")+1);
            argument = offset_displacement(argument);
            stringstream ss;
            ss << label << "idiv dword [" << argument << "]";
            out = ss.str();
            new_text_section.push_back(out);
        }
        
        else if (command == "JMP") {
            string argument = line_without_label.substr(line_without_label.find(" ")+1);
            argument = offset_displacement(argument);
            stringstream ss;
            ss << label << "jmp " << argument;
            out = ss.str();
            new_text_section.push_back(out);
        }
        else if (command == "JMPN") {
            string argument = line_without_label.substr(line_without_label.find(" ")+1);
            argument = offset_displacement(argument);
            stringstream ss1;
            ss1 << label << "cmp EAX,0 ";
            out = ss1.str();
            new_text_section.push_back(out);
            stringstream ss;
            ss << "jl " << argument;
            out = ss.str();
            new_text_section.push_back(out);
        }
        else if (command == "JMPP") {
            string argument = line_without_label.substr(line_without_label.find(" ")+1);
            argument = offset_displacement(argument);
            stringstream ss1;
            ss1 << label << "cmp EAX,0 ";
            out = ss1.str();
            new_text_section.push_back(out);
            stringstream ss;
            ss << "jg " << argument;
            out = ss.str();
            new_text_section.push_back(out);
        }
        else if (command == "JMPZ") {
            string argument = line_without_label.substr(line_without_label.find(" ")+1);
            argument = offset_displacement(argument);
            stringstream ss1;
            ss1 << label << "cmp EAX,0 ";
            out = ss1.str();
            new_text_section.push_back(out);
            stringstream ss;
            ss  << "je " << argument;
            out = ss.str();
            new_text_section.push_back(out);
        }
        else if (command == "COPY") {
            // Argument 1 = antes da ,
            string argument1 = line_without_label.substr(line_without_label.find(' ')+1, line_without_label.find(',')-line_without_label.find(' ')-1);
            argument1 = offset_displacement(argument1); 
            // Argument 2 = depois da ,
            string argument2 = line_without_label.substr(line_without_label.find(',')+1, line_without_label.find(' ')-line_without_label.find(',')-1); 
            argument2 = offset_displacement(argument2);
            stringstream ss0;
            ss0 << label << "push ebx";
            out = ss0.str();
            new_text_section.push_back(out);
            stringstream ss;
            ss  << "mov ebx, [" << argument1 << "]";
            out = ss.str();
            new_text_section.push_back(out);
            stringstream ss2;
            ss2 << "mov dword [" << argument2 << "], ebx";
            out = ss2.str();
            new_text_section.push_back(out);
            new_text_section.push_back("pop ebx");
        }
        else if (command == "LOAD") {
            string argument = line_without_label.substr(line_without_label.find(" ")+1);
            argument = offset_displacement(argument);
            stringstream ss;
            ss << label << "mov eax, [" << argument << "]";
            out = ss.str();
            new_text_section.push_back(out);
        }
        else if (command == "STORE") {
            string argument = line_without_label.substr(line_without_label.find(" ")+1);
            argument = offset_displacement(argument);
            stringstream ss;
            ss << label << "mov dword [" << argument << "]" << ", eax";
            out = ss.str();
            new_text_section.push_back(out);
        }
        else if (command == "INPUT") {
            string argument = line_without_label.substr(line_without_label.find(" ")+1);
            argument = offset_displacement(argument);
            stringstream ss;
            ss << label << "push " << argument;
            out = ss.str();
            new_text_section.push_back(out);
            new_text_section.push_back("call read_int");
        }
        else if (command == "OUTPUT") {
            string argument = line_without_label.substr(line_without_label.find(" ")+1);
            argument = offset_displacement(argument);
            stringstream ss;
            ss << label << "push " << argument;
            out = ss.str();
            new_text_section.push_back(out);
            new_text_section.push_back("call write_int");
        }
        else if (command == "INPUT_C") {
            string argument = line_without_label.substr(line_without_label.find(" ")+1);
            argument = offset_displacement(argument);
            stringstream ss;
            ss << label << "push " << argument;
            out = ss.str();
            new_text_section.push_back(out);
            new_text_section.push_back("call read_char");
        }
        else if (command == "OUTPUT_C") {
            string argument = line_without_label.substr(line_without_label.find(" ")+1);
            argument = offset_displacement(argument);
            stringstream ss;
            ss << label << "push " << argument;
            out = ss.str();
            new_text_section.push_back(out);
            new_text_section.push_back("call write_char");
        }
        else if (command == "INPUT_S") {
            // Argument 1 = antes da ,
            string argument1 = line_without_label.substr(line_without_label.find(' ')+1, line_without_label.find(',')-line_without_label.find(' ')-1); 
            argument1 = offset_displacement(argument1);
            // Argument 2 = depois da ,
            string argument2 = line_without_label.substr(line_without_label.find(',')+1, line_without_label.find(' ')-line_without_label.find(',')-1); 
            argument2 = offset_displacement(argument2);
            stringstream ss0;
            ss0 << label << "push "<< argument2;
            out = ss0.str();
            new_text_section.push_back(out);
            stringstream ss;
            ss  << "push " << argument1;
            out = ss.str();
            new_text_section.push_back(out);
            new_text_section.push_back("call read_string");
        }
        else if (command == "OUTPUT_S") {
            // Argument 1 = antes da ,
            string argument1 = line_without_label.substr(line_without_label.find(' ')+1, line_without_label.find(',')-line_without_label.find(' ')-1);
            argument1 = offset_displacement(argument1); 
            // Argument 2 = depois da ,
            string argument2 = line_without_label.substr(line_without_label.find(',')+1, line_without_label.find(' ')-line_without_label.find(',')-1); 
            argument2 = offset_displacement(argument2);
            stringstream ss0;
            ss0 << label << "push "<< argument2;
            out = ss0.str();
            new_text_section.push_back(out);
            stringstream ss;
            ss << "push " << argument1;
            out = ss.str();
            new_text_section.push_back(out);
            new_text_section.push_back("call write_string");
        }
        else if (command == "STOP") {
            stringstream ss;
            ss << label << "mov eax, 1";
            out = ss.str();
            new_text_section.push_back(out);
            new_text_section.push_back("mov ebx, 0");
            new_text_section.push_back("int 80h");
        }
    }

    vector<string> functions_asm = read_file("funcoes.asm");
    translate = concat_vectors(new_data_section, new_bss_section, new_text_section);
    translate = concat_asm(translate, functions_asm);

    return translate;
}

