characters [a-zA-Z]
space [ ]
numbers [0-9]
gt [>]
lt [<]
eq [==]
neq [!=]
gte [>=]
lte [<=]


%%
"summon"({space})+({characters})+".h"	 {printf("Header file included\n");}
"summon_majin()"   {printf("Main function found\n");}
({space})*"go_to"({space})+({characters})+"()"	 {printf("function found\n");}
({space})+"@Int"({space})+({characters})+ {printf("Integer type variable Declared\n");}
({space})+"@Float"({space})+({characters})+ {printf("Float type variable Declared\n");}
({space})+"@Char"({space})+({characters})+ {printf("Character type variable Declared\n");}
({space})+"@String"({space})+({characters})+ {printf("String type variable Declared\n");}
({space})+"@Array""["({numbers})+"]" {printf("Array Declared\n");}
({space})+({characters})+[=]({numbers})+[.]*({numbers})*|({space})+({characters})+[=][']({characters})[']"\n" {printf("variable assigned\n");}
({space})+({characters})+[=]({characters}|{numbers})+[+]({characters}|{numbers})+ {printf("Addition operation\n");}
({space})+({characters})+[=]({characters}|{numbers})+[-]({characters}|{numbers})+ {printf("Subtraction operation\n");}
({space})+({characters})+[=]({characters}|{numbers})+[*]({characters}|{numbers})+ {printf("Multiplication operation\n");}
({space})+({characters})+[=]({characters}|{numbers})+[/]({characters}|{numbers})+ {printf("Division operation\n");}
({space})+({characters})+[=]({characters}|{numbers})+[%]({characters}|{numbers})+ {printf("Mod operation\n");}
({space})+({characters})+[=]({characters})+ {printf("variable to variable assignment\n");}
({space})+({characters})+[=]["]({characters})+["] {printf("String assigned\n");}
({space})+"while"({space})+[|]({characters})+({gt}|{lt}|{gte}|{lte}|{eq}|{neq})+({characters}|{numbers})+[|]({space})+"holds" {printf("While loop\n");}
({space})+"keep_doing" {printf("do block of do while\n");}
({space})+"while"[(]({characters})+({gt}|{lt}|{gte}|{lte}|{eq}|{neq})+({characters}|{numbers})+[)] {printf("while of do\n");}
({space})+"for"({space})+({characters})+({space})+"in"({space})+"("({numbers})+"`"({numbers})+")"({space})+"keep_doing" {printf("For loop\n");}
({space})*"{_" {printf("Start of a block of code\n");}
({space})*"_}" {printf("End of a block of code\n");}
({space})+"if"({space})+({characters})+({gt}|{lt}|{gte}|{lte}|{eq}|{neq})+({characters}|{numbers})+({space})+"holds"  {printf("If statement\n");}
({space})+"or"({space})+({characters})+({gt}|{lt}|{gte}|{lte}|{eq}|{neq})+({characters}|{numbers})+({space})+"holds"  {printf("or(similar to else if) statement\n");}
({space})+"otherwise" {printf("otherwis(similar to else) statement\n");}
({space})*"-_".* {printf("single line comment\n");}
({space})*"$$"[a-zA-z0-9\n ]"$$" {printf("multiple line comment\n");}
.* {printf("Invalid syntax\n");}
%%

int yywrap()
{ 
    return 1;
}

int main()
{
	yyin = freopen("input.txt", "r",stdin);
	yyout = freopen("output.txt","w", stdout);
	yylex();
	fclose(yyin);
	fclose(yyout);
	return 0;	
}