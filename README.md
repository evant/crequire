# crequire

A simply way to require c code in ruby using SWIG.

## Dependencies

* ruby 1.9
* make
* SWIG

## A simple example

### example1.h

```c
// If you have a header file then the functions are detected automatically. You
// can either define the functions in the header file or define a header and
// implementation file separately.

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

Example1.fact(4) => 24

a = ptrcreate("int", 1)
b = ptrcreate("int", 2)

Example1.swap(a, b)

a => 2
b => 1

ptrfree(a)
ptrfree(b)
```

## A complex example

### example2.c

```c
// If you don't define a header file, you must pass in a block to define the
// method signatures.

int sum(int a, int b) {
  return a + b;
}

void add(int *x, int *y, int *r) {
  *r = *x + *y;
}
```

### test_example2.rb

```ruby
require "crequire"

# :force => true forces a compile on every run. Alternatively, you can delete
# the 'example2.o' file for a recompile.

crequire "example2", :force => true do
  # To define a method signature, call a function corresponding to the function
  # you are defining. Pass in the types of the arguments in order, followed by
  # what is returned. You don't have to specify a return if it is void.   

  sum(:int, :int, :return => :int)

  # To make working with pointers easer, you can define them as *INPUT or
  # *OUTPUT.

  add("int *INPUT", "int *INPUT", "int *OUTPUT")
end

Example2.sum(1, 2) => 3
Example2.add(3, 4) => 7
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

