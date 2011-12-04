%module example1
%include "cpointer.i"
%pointer_class(int, Intp);
%pointer_class(double, DoublePointer);
%{
#include "example1.h"
%}
%include "example1.h"
