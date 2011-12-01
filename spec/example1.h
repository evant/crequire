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
