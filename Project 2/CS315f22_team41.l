%{
#include <stdio.h>
#include "y.tab.h"
void yyerror(char *);
%}

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

%option yylineno
%%

  /* comments */
{long_comment}  	return LONG_COMMENT;
{line_comment}	  return LINE_COMMENT;
  /* symbols */
\!			          return NOT;
\(            		return LP;
\)            		return RP;
\{            		return LC;
\}            		return RC;
\_                return UNDERSCORE;
\.            		return DOT;
\,            		return COMMA;
\;            		return SEMICOLON;
\=            		return ASSIGN_OP;
\=\=			        return EQUAL;
\!\=			        return NOT_EQUAL;
\"            		return QUOTE;
\+        		    return ADD_OP;
\-        			  return SUB_OP;
\*			          return MUL_OP;
\/                return DIV_OP;
\^                return POW_OP;
\>	          		return GREATER;
\<		           	return LESS;
\<\=		        	return LESS_OR_EQUAL;
\>\=		        	return GREATER_OR_EQUAL;
\&		           	return AND;
\|		           	return OR;
[\t\n]            ;
  /* literals */
{int_literal}     return INT_LITERAL;
{float_literal}   return FLOAT_LITERAL;
{string_literal}	return STRING_LITERAL;
{URL_literal}     return URL_LITERAL;
(true|false)      return BOOLEAN_LITERAL;
  /* reserved keywords */
begin             return BEGIN_QUIRK;
end 			        return END;
int 		        	return INT;
float 			      return FLOAT;
string			      return STRING;
boolean		        return BOOLEAN;
URL               return URL;
if		          	return IF;
else		        	return ELSE;
for		          	return FOR;
while		        	return WHILE;
declare	        	return DECLARE;
return	    	  	return RETURN;
send              return SEND;
receive           return RECEIVE;
connect           return CONNECT;
disconnect        return DISCONNECT;
get_time          return GET_TIME;
get_temperature   return GET_TEMPERATURE;
get_humidity      return GET_HUMIDITY;
get_air_pressure  return GET_AIR_PRESSURE;
get_air_quality   return GET_AIR_QUALITY;
get_light         return GET_LIGHT;
get_sound_level   return GET_SOUND_LEVEL;
connect_to_internet          return CONNECT_TO_INTERNET;
disconnect_from_internet     return DISCONNECT_FROM_INTERNET;
get_switch_state             return GET_SWITCH_STATE;
change_switch_state          return CHANGE_SWITCH_STATE;
  /* identifier */
{identifier}      return IDENTIFIER;

%%
int yywrap(void){
	return 1;
}