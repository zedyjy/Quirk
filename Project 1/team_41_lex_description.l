%{
#include <string.h> /* for the strlen function */
#include <ctype.h> /* for the toupper function */
%}
%option main
digit			        [0-9]
character		      [a-zA-Z]
int_literal		    [+-]?{digit}+
float_literal	  	[+-]?{digit}*(\.)?{digit}+
line_comment 	  	\%\%{sentence}[\n\r]
long_comment 	    \%\%\%({sentence}|\n|\r)+\%\%\%
symbol            (\.|,|;|:|-|\(|\)|\{|\}|\[|\]|\/|a|\\|=|<|>|\||&|“|‘|\+|-|\*|#|!|\?|_|£|\^|\%|\ |\$|@|~)
string_literal   	\"{sentence}\"
sentence          ({character}|{digit}|{symbol})*
identifier		    {character}({character}|{digit}|_)*
URL_literal       \'{scheme}:(\/\/)?{sentence}\'
scheme            http|https|ftp|mailto|data|file|irc 
primitive_func    get_time|get_temperature|get_humidity|get_air_pressure|get_air_quality|get_light|get_sound_level|connect_to_internet|disconnect_from_internet|get_switch_state|change_switch_state

%%

  /* comments */
{long_comment}  	printf("LONG_COMMENT ");
{line_comment}	  printf("LINE_COMMENT ");
  /* symbols */
\!			          printf("NOT ");
\(            		printf("LP ");
\)            		printf("RP ");
\{            		printf("LC ");
\}            		printf("RC ");
\_                printf("UNDERSCORE ");
\.            		printf("DOT ");
\,            		printf("COMMA ");
\;            		printf("SEMICOLON ");
\=            		printf("ASSIGN_OP ");
\=\=			        printf("EQUAL ");
\!\=			        printf("NOT_EQUAL");
\"            		printf("QUOTE ");
\+        		    printf("ADD_OP ");
\-        			  printf("SUB_OP ");
\*			          printf("MUL_OP ");
\/                printf("DIV_OP ");
\^                printf("POW_OP" );
\>	          		printf("GREATER ");
\<		           	printf("LESS ");
\<\=		        	printf("LESS_OR_EQUAL ");
\>\=		        	printf("GREATER_OR_EQUAL ");
\&		           	printf("AND ");
\|		           	printf("OR ");
\n       		    	printf("\n"); 
  /* literals */
{int_literal}     printf("INT_LITERAL ");
{float_literal}   printf("FLOAT_LITERAL ");
{string_literal}	printf("STRING_LITERAL ");
{URL_literal}     printf("URL_LITERAL ");
  /* reserved keywords */
begin		        	printf("BEGIN ");
end 			        printf("END ");
int 		        	printf("INT ");
float 			      printf("FLOAT ");
string			      printf("STRING ");
boolean		        printf("BOOLEAN ");
URL               printf("URL " );
if		          	printf("IF ");
else		        	printf("ELSE ");
for		          	printf("FOR ");
while		        	printf("WHILE ");
declare	        	printf("DECLARE ");
return	    	  	printf("RETURN ");
true		        	printf("TRUE ");
false		        	printf("FALSE ");
send              printf("SEND ");
receive           printf("RECEIVE ");
connect           printf("CONNECT ");
disconnect        printf("DISCONNECT ");
{primitive_func}  {
                    /* print the primitive function name as upper-case */ 
                    for(int i=0; i < strlen(yytext); i++){
                        printf("%c",toupper(yytext[i]));
                    }
                    printf(" ");
                  }
  /* identifier */
{identifier}      printf("IDENTIFIER ");
.                 ;
