%{
	#include<stdio.h>
	#include<stdlib.h>
	#include <string.h>

	int yyparse();
	int yylex();
	int yyerror();

	int switchdone = 0;
	int switchvar;

	int ifval[100];
	int ifptr = -1;
	int ifdone[100];

    int ptr = 0;
    int var_values[100];
    char store[100][100];

    int check(char str[]){
        int i;
        for(i = 0; i < ptr; i++){
            if(strcmp(store[i],str) == 0) return 1;
        }
        return 0;
    }

    int new_var(char str[],int val){
        if(check(str) == 1) return 0;
        strcpy(store[ptr],str);
        var_values[ptr] = val;
        ptr++;
        return 1;
    }

    int getval(char str[]){
        int index = -1;
        int i;
        for(i = 0; i < ptr; i++){
            if(strcmp(store[i],str) == 0) {
                index = i;
                break;
            }
        }
        return var_values[index];
    }
    int assignval(char str[], int val){
    	int index = -1;
        int i;
        for(i = 0; i < ptr; i++){
            if(strcmp(store[i],str) == 0) {
                index = i;
                break;
            }
        }
        var_values[index] = val;

    }


%}

%union {
  char memo[1000];
  int val;
}


%token <memo>  id
%token <val>  num

%type <val> expression


%left   g_oprtr  l_oprtr  ge_oprtr  le_oprtr
%left plus_oprtr mns_oprtr
%left  mult_oprtr_oprtr div_oprtr


%token T_int   fun_main fun_print fbs fbe sbs sbe sem_col com equ_oprtr  plus_oprtr mns_oprtr mult_oprtr div_oprtr  g_oprtr l_oprtr ge_oprtr le_oprtr con_if  con_else  con_elseif  lp_for inc lp_lim con_swi con_swi_def  con_swi_col  equequ_oprtr
%nonassoc IFX
%nonassoc con_else
%left SH


%%

program		: T_int  fun_main  fbs fbe sbs statement sbe { printf("\nCompilation Successful\n"); }
			;
statement	:
			| statement declaration
			| statement expression
			| statement ifelse
			| statement assign
			| statement forloop
			| statement switch
			;


declaration : type variables sem_col {}
			;
type		: T_int   {}
			;
variables	: variable com variables {}
			| variable {}
			;
variable   	: id
					{
						int tmp = new_var($1,0);
						if(tmp==0) {
							printf("\nError!! Variable %s is already declared\n",$1);
                            exit(-1);
						}

					}
			| id equ_oprtr expression
					{

						int tmp = new_var($1,$3);
						if(tmp==0) {
							printf("\nError!! Variable %s is already declared\n",$1);
                            exit(-1);
							}
					}

			;


assign : id equ_oprtr expression sem_col
					{
						if(check($1)==0) {
							printf("Error: Variable %s is not declared\n",$1);
							exit(-1);
						}
						else{
							assignval($1,$3);
						}
				    }




expression : num {$$ = $1;}
			| id
					{
						if(check($1)==0) {
							printf(" Error: Variable %s is not declared\n",$1);
							exit(-1);
						}
						else{
							$$ = getval($1);
						}
				 	}
			| expression plus_oprtr expression
					{$$ = $1 + $3;}
			| expression mns_oprtr expression
					{$$ = $1 - $3;}
			| expression mult_oprtr expression
					{$$ = $1 * $3;}
			| expression div_oprtr expression
					{
						if($3) {
 							$$ = $1 / $3;
							}
				  		else {
							$$ = 0;
							printf("\nRuntime Error: division by zero\t");
							exit(-1);
				  		}
					}
			| expression l_oprtr expression
					{ $$ = $1 < $3; }
			| expression g_oprtr expression
					{ $$ = $1 > $3; }
			| expression le_oprtr expression
					{ $$ = $1 <= $3; }
			| expression ge_oprtr expression
					{ $$ = $1 >= $3; }
			| expression equequ_oprtr expression
					{ $$ = $1 == $3; }
			| fbs expression fbe
					{$$ = $2;}
			;


ifelse 	: con_if  fbs ifexp fbe sbs statement sbe elseif
					{

						ifdone[ifptr] = 0;
						ifptr--;
					}
		;
ifexp	: expression
					{
						ifptr++;
						ifdone[ifptr] = 0;
						if($1){
							printf("\nIf executed\n");
							ifdone[ifptr] = 1;
						}
					}
		;
elseif 	:
		| elseif con_elseif  fbs expression fbe sbs statement sbe
					{
						if($4 && ifdone[ifptr] == 0){
							printf("\nElse if block expressin %d executed\n",$4);
							ifdone[ifptr] = 1;
						}
					}
		| elseif con_else  sbs statement sbe
					{
						if(ifdone[ifptr] == 0){
							printf("\nElse block executed\n");
							ifdone[ifptr] = 1;
						}
					}

		;

forloop	: lp_for fbs expression lp_lim expression inc expression fbe sbs statement sbe
					{

						printf("Loop executes  times\n");
					}



switch	: con_swi fbs expswitch fbe sbs switchcase sbe
		;

expswitch 	:  expression
					{
						switchdone = 0;
						switchvar = $1;
					}
			;


switchcase	:
				| switchcase expression con_swi_col  sbs statement sbe
					{
						if($2 == switchvar){
							printf("Executed %d\n",$2);
							switchdone = 1;
						}
					}
				| switchcase con_swi_def  con_swi_col  sbs statement sbe
					{
						if(switchdone == 0){
							switchdone = 1;
							printf("Default Block executed\n");
						}
					}
				;



%%


int yyerror(char *s){
	printf( "%s\n", s);
}
