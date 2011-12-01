%module example2
%include "cpointer.i"
%pointer_class(int, Intp)
%pointer_class(double, Doublep)
%{
extern int sum(int arg0, int arg1);
extern void add(int *arg0, int *arg1, int *arg2);
extern char* echo(char* arg0);
%}
extern int sum(int arg0, int arg1);
extern void add(int *INPUT, int *INPUT, int *OUTPUT);
extern char* echo(char* arg0);
