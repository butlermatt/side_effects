library side_effects;

typedef void modify(var arg);

class SideEffect {
  int i = 1;
  double d = 1.0;
  num n = 1;
  bool b = false;
  List l = [1, 2, 3];
  Map m = { 'one' : 1, 'two' : 2, 'three' : 3 };
  
  String toString() => 'Values: $i, $d, $n, $b, $l, $m';
  
}

class PartialEffect {
  int i = 1;
  double d = 1.0;
  num n = 1;
  bool b = false;
  List l = [1, 2, 3];
  Map m = { 'one' : 1, 'two' : 2, 'three' : 3 };
  
  String toString() => 'Values: $i, $d, $n, $b, $l, $m';
}

void main() {
  int i = 1;
  double d = 1.0;
  num n = 1;
  bool b = false;
  List l = [1, 2, 3];
  Map m = { 'one' : 1, 'two' : 2, 'three' : 3 };
  SideEffect se = new SideEffect();
  PartialEffect pe = new PartialEffect();
  
  
  testFunction(i, addOne); // No Side Effects
  
  testFunction(d, addOne); // No Side effects
  
  testFunction(n, addOne); // No Side Effects
  
  testFunction(b, addOne); // No Side effects
  
  testFunction(l, addOne); // Side effect!
  testFunction(l, modifyOne); // Side effect!
  testFunction(l[1], addOne); // No side effect
  
  testFunction(m, addOne); // Side effect!
  testFunction(m, modifyOne); // Side effect!
  testFunction(m['one'], addOne); // No Side effect
  
  testFunction(se, addOne); // Side effect! (technically a modification)
  testFunction(se, modifyOne); // Side effect!
  
  testFunction(pe, addOne);
  testFunction(pe, modifyOne);
}

void addOne(var arg) {
  if(arg is num) arg += 1;
  if(arg is bool) arg = true;
  if(arg is List) arg.add(4);
  if(arg is Map) arg['four'] = 4;
  if(arg is SideEffect) {
    arg.i += 1;
    arg.d += 1;
    arg.n += 1;
    arg.b = true;
    arg.l.add(4);
    arg.m['four'] = 4;
  }
  if(arg is PartialEffect) {
    addOne(arg.i);
    addOne(arg.d);
    addOne(arg.n);
    addOne(arg.b);
    addOne(arg.l);
    addOne(arg.m);
  }
  
  print('In call: $arg');
}

void modifyOne(var arg) {
  if(arg is List) arg[0] = 100;
  if(arg is Map) arg['one'] = 100;
  if(arg is SideEffect) {
    arg.i += 1;
    arg.d += 1;
    arg.n += 1;
    arg.b = true;
    arg.l[0] = 100;
    arg.m['one'] = 100;
  }
  if(arg is PartialEffect) {
    modifyOne(arg.i);
    modifyOne(arg.d);
    modifyOne(arg.n);
    modifyOne(arg.b);
    modifyOne(arg.l);
    modifyOne(arg.m);
  }
  
  print('In call: $arg');
}

void testFunction(var arg, modify mod) {
  if(arg is num) print('Testing Num:');
  if(arg is bool) print('Testing bool:');
  if(arg is List) print('Testing List:');
  if(arg is Map) print('Testing Map:');
  if(arg is SideEffect) print('Testing class SideEffect');
  if(arg is PartialEffect) print('Testing class PartialEffect');
  
  print('Before call: $arg');
  mod(arg);
  print('After call: $arg\n');
}