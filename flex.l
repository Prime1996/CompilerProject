%{
	#include<stdio.h>
	#include<math.h>
	#include<stdlib.h>
	#include<string.h>
	#include "bison.tab.h"
%}

digit_ [0-9]
char_ [a-zA-Z]
spe_sym [_$~@]

data_type "T_int"|"T_float"|"T_char"|"T_void"
oprtr_ "mns_oprtr"|"equ_oprtr"|"plus_oprtr"|"div_oprtr"|"mult_oprtr"|"mod_oprtr"
rel_oprtr "le_oprtr"|"ge_oprtr"|"equequ_oprtr"|"l_oprtr"|"g_oprtr"|"nequ_oprtr"

%%
"-"?{digit_}+     {
	yylval.val=atoi(yytext);
	return num;
}

"fun_main" { return fun_main ;}

"let_"({char_}|{spe_sym}|{digit_})+ { strcpy(yylval.memo,yytext); return id; }
"fun_print" { return fun_print; }
"T_int" {return T_int;}

"con_elseif" {return con_elseif;}
"con_if" {return con_if;}
"con_else" {return con_else;}

"con_swi" {return con_swi;}
"::" {return con_swi_col ;}
"**" {return con_swi_def ;}

"lp_for" {return lp_for;}

"->".*"<-" {}
";" { return sem_col;}
"," { return com; }

"fbs" { return fbs;}
"fbe" {return fbe;}

"sbs" { return sbs;}
"sbe" {return sbe;}
"inc" {return inc;}


"equ_oprtr"  {return equ_oprtr;}
"plus_oprtr" {return plus_oprtr;}
"div_oprtr"  {return div_oprtr;}
"mult_oprtr" {return mult_oprtr;}
"mns_oprtr"  {return mns_oprtr;}


"le_oprtr"   {return le_oprtr;}
"ge_oprtr"   {return ge_oprtr;}
"equequ_oprtr" {return equequ_oprtr;}
"l_oprtr"    {return l_oprtr;}
"g_oprtr"    {return g_oprtr;}


"lp_lim" {return lp_lim;}



%%
  
int yywrap()
{
	return 1;
}


int main(){
	yyin = freopen("in.txt","r",stdin);
	freopen("out.txt","w",stdout);
	yyparse();
	return 0;
}
