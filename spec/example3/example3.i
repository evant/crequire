%module example3
%include "cpointer.i"
%pointer_class(int, Intp)
%pointer_class(double, Doublep)
%{
extern int sum(int a, int b);
%}
extern int sum(int a, int b);
