%{
#include <stdio.h>
#include <stdlib.h>
int yylex(void);
void yyerror(char* s);
extern int yylineno;
%}

%token NOT
%token LP
%token RP
%token LC
%token RC
%token LONG_COMMENT
%token LINE_COMMENT
%token DOT
%token COMMA
%token SEMICOLON
%token ASSIGN_OP
%token DIV_OP
%token MUL_OP
%token ADD_OP
%token SUB_OP
%token UNDERSCORE
%token EQUAL
%token NOT_EQUAL
%token QUOTE
%token POW_OP
%token GREATER
%token LESS
%token LESS_OR_EQUAL
%token GREATER_OR_EQUAL
%token AND
%token OR
%token INT_LITERAL
%token FLOAT_LITERAL 
%token BOOLEAN_LITERAL
%token STRING_LITERAL
%token URL_LITERAL
%token BEGIN_QUIRK 
%token END
%token INT
%token FLOAT
%token STRING 
%token BOOLEAN
%token URL
%token IF 
%token ELSE
%token FOR
%token WHILE
%token DECLARE
%token RETURN
%token TRUE
%token FALSE
%token SEND
%token RECEIVE
%token CONNECT
%token DISCONNECT
%token GET_TIME
%token GET_TEMPERATURE
%token GET_HUMIDITY
%token GET_AIR_PRESSURE
%token GET_AIR_QUALITY
%token GET_LIGHT
%token GET_SOUND_LEVEL
%token CONNECT_TO_INTERNET 
%token DISCONNECT_FROM_INTERNET
%token GET_SWITCH_STATE
%token CHANGE_SWITCH_STATE
%token IDENTIFIER

%start program

%%

//program
program:
        BEGIN_QUIRK statements END {printf("There were no errors.\n");};

    statements:
        statement
        |statement statements
        |comment
        |comment statements 
        |error SEMICOLON {yyerrok;}

    statement:
        matched_statement
        |unmatched_statement

    matched_statement:
        IF LP control_expression RP LC matched_statement RC ELSE LC matched_statement RC
        |non_if_statement

    unmatched_statement:
        IF LP control_expression RP LC matched_statement RC
        |IF LP control_expression RP LC unmatched_statement RC
        |IF LP control_expression RP LC matched_statement RC  ELSE LC unmatched_statement RC

    non_if_statement:
        expression SEMICOLON
        |loops
        |function_declaration

    expression:
        assignment
        |control_expression
        |declaration
        |declaration_and_initialization
        |connection_to_URL
        |send_value
        |empty

    control_expression:
        logical_expression
        |NOT logical_expression
        |string_logical_expression
        |NOT string_logical_expression

    logical_expression:
        logical_expression OR term1
        |term1

    term1:
        term1 AND term2
        |term2

    term2:
        term2 EQUAL term3
        |term2 NOT_EQUAL term3
        |term2 EQUAL STRING_LITERAL
        |term2 NOT_EQUAL STRING_LITERAL
        |term3

    term3:
        term3 GREATER term4
        |term3 LESS term4
        |term3 GREATER_OR_EQUAL term4
        |term3 LESS_OR_EQUAL term4
        |term4

    term4:
        term4 ADD_OP term5
        |term4 SUB_OP term5
        |term5

    term5:
        term5 MUL_OP term6
        |term5 DIV_OP term6
        |term6

    term6:
        term6 POW_OP term7
        |term7

    term7:
        arithmetic_element
        |LP logical_expression RP

    arithmetic_element:
        IDENTIFIER
        |INT_LITERAL
        |FLOAT_LITERAL
        |function_call
        |primitive_function_call
        |BOOLEAN_LITERAL
        

    string_logical_expression:
        STRING_LITERAL EQUAL STRING_LITERAL
        |STRING_LITERAL EQUAL IDENTIFIER
        |STRING_LITERAL NOT_EQUAL STRING_LITERAL
        |STRING_LITERAL NOT_EQUAL IDENTIFIER

    declaration:
        type IDENTIFIER

    assignment:
        IDENTIFIER ASSIGN_OP URL_LITERAL
        |IDENTIFIER ASSIGN_OP control_expression 
        |IDENTIFIER ASSIGN_OP receive_operation

    declaration_and_initialization:
        type IDENTIFIER ASSIGN_OP URL_LITERAL
        |type IDENTIFIER ASSIGN_OP control_expression
        |type IDENTIFIER ASSIGN_OP receive_operation

    connection_to_URL:
        CONNECT IDENTIFIER
        |CONNECT URL_LITERAL

    send_value:
        SEND IDENTIFIER IDENTIFIER
        |SEND INT_LITERAL IDENTIFIER
        |SEND function_call IDENTIFIER
        |SEND primitive_function_call IDENTIFIER
        |SEND IDENTIFIER URL
        |SEND INT_LITERAL URL
        |SEND function_call URL
        |SEND primitive_function_call URL

    receive_operation:
        RECEIVE IDENTIFIER
        |RECEIVE URL

    loops:
        while_loop
        |for_loop

    for_loop:
        FOR LP assignment SEMICOLON control_expression SEMICOLON expression RP LC statements RC
        |FOR LP declaration_and_initialization SEMICOLON control_expression SEMICOLON expression RP LC statements RC

    while_loop:
        WHILE LP control_expression RP LC statements RC

    function_declaration:
        DECLARE IDENTIFIER LP params RP LC statements return SEMICOLON RC
        |DECLARE IDENTIFIER LP params RP LC statements RC

    params:
        type IDENTIFIER COMMA params
        |type IDENTIFIER
        |empty

    function_call:
        IDENTIFIER LP call_params RP

    call_params:
        control_expression COMMA call_params
        |control_expression
        |empty

    return :
        RETURN STRING_LITERAL
        |RETURN control_expression


    primitive_function_call:
        time
        |temperature
        |humidity
        |air_pressure
        |air_quality
        |light
        |sound_level
        |get_switch_state
        |change_switch_state
        |connect_to_internet
	      |disconnect_from_internet

    time:
        GET_TIME LP RP

    temperature:
        GET_TEMPERATURE LP RP

    humidity:
        GET_HUMIDITY LP RP

    air_pressure :
        GET_AIR_PRESSURE LP RP

    air_quality :
        GET_AIR_QUALITY LP RP

    light:
        GET_LIGHT LP RP

    sound_level :
        GET_SOUND_LEVEL LP FLOAT RP 
        |GET_SOUND_LEVEL LP IDENTIFIER RP

    connect_to_internet:
        CONNECT_TO_INTERNET LP RP

    disconnect_from_internet:
        DISCONNECT_FROM_INTERNET LP RP

    get_switch_state:
        GET_SWITCH_STATE LP INT_LITERAL RP 
        |GET_SWITCH_STATE LP IDENTIFIER RP

    change_switch_state:
        CHANGE_SWITCH_STATE LP BOOLEAN_LITERAL COMMA INT_LITERAL RP 
        |CHANGE_SWITCH_STATE LP BOOLEAN_LITERAL COMMA IDENTIFIER RP 
        |CHANGE_SWITCH_STATE LP IDENTIFIER COMMA INT_LITERAL RP 
        |CHANGE_SWITCH_STATE LP IDENTIFIER COMMA IDENTIFIER RP

    comment:
        LONG_COMMENT 
        |LINE_COMMENT

    empty:  /* empty */ 
    type:
         INT| FLOAT | BOOLEAN | STRING| URL 




%%
void yyerror(char *s) {
	  printf("\n%s on line %d\n", s, yylineno);
}

int main(void){
     yyparse();
}
