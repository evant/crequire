# crequire

A simply way to require c code in ruby using SWIG.

## Dependencies

* ruby 1.9
* make
* SWIG

## A simple example

If you have a header file then the functions are detected automatically. You
can either define the functions in the header file or define a header and
implementation file separately.

### example1.h

```c
int fact(int n) {
  if (n <= 1) return 1;
  else return n * fact(n-1);
}

void swap(int *a, int *b) {
  int tmp;
  tmp = *b;
  *b = *a;
  *a = tmp;
}
```

### test_example1.rb

```ruby
require "crequire"
crequire "example1"
include Example1

fact(4) => 24

a = Intp.new
a.assign 1
b = Intp.new
b.assign 2

swap(a, b)

a.value => 2
b.value => 1
```

## A complex example

If you don't define a header file, you must pass in a block to define the
method signatures.

### example2.c

```c
int sum(int a, int b) {
  return a + b;
}

void add(int *x, int *y, int *r) {
  *r = *x + *y;
}

char* echo(char* word) {
  return word;
}
```

### test_example2.rb

```ruby
require "crequire"

crequire "example2" do
  # To define a function signature, declare the type followed by the function
  # name, passing in the types as symbols or strings.

  int sum(:int, :int)

  # To make working with pointers easer, you can define them as *INPUT or
  # *OUTPUT.

  void add("int *INPUT", "int *INPUT", "int *OUTPUT")

  # char* is automatically converted to and from string
  char* echo("char*")
end

include Example2

sum(1, 2) => 3
add(3, 4) => 7
echo("hi") => "hi"
```

## Advanced Options

```:force => true``` Forces a compile on every run. Otherwise compile only
happens if compiled no file is found.

```:src => "string"``` Defines the contents of the interface file directly.

```:interface => "dir"``` Outputs the generated interface file to the given directory.

```:dump => "dir"``` Outputs all generated files to the given directory. 

```:cflags => "flags"``` Pass cflags to make.

### example2.c

```c
int sum(int a, int b, int times) {
  int result = a;
  for (int i = 0; i < times; i++) {
    result += b;
  }
  return result;
}
```

### test_example3.rb

```ruby
require 'crequire'

interface = "%module example3 
%{ 
extern int sum(int a, int b, int times);
%}
extern int sum(int a, int b, int times);" 

crequire "example3", :force => true, :cflags => "-std=c99", :interface => "example3", :src => interface

include Example3

sum(1, 2, 2) => 5
```

### example3/example3.i

```c
%module example3
%{
extern int sum(int a, int b);
%}
extern int sum(int a, int b);
```

## Contributing to crequire
 
* Check out the latest master to make sure the feature hasn't been implemented or the bug hasn't been fixed yet
* Check out the issue tracker to make sure someone already hasn't requested it and/or contributed it
* Fork the project
* Start a feature/bugfix branch
* Commit and push until you are happy with your contribution
* Make sure to add tests for it. This is important so I don't break it in a future version unintentionally.
* Please try not to mess with the Rakefile, version, or history. If you want to have your own version, or is otherwise necessary, that is fine, but please isolate to its own commit so I can cherry-pick around it.

## Copyright

Copyright (c) 2011 Evan Tatarka. See LICENSE.txt for
further details.

