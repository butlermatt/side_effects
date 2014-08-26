library side_effects;

typedef void modify(var arg);

class SideEffect {
  int i = 1;
  double d = 1.0;
  num n = 1;
  bool b = false;
  String s = "Pretty String";
  List l = [1, 2, 3];
  Map m = { 'one' : 1, 'two' : 2, 'three' : 3 };
  final List fl = [1, 2, 3];
  final Map fm = { 'one' : 1, 'two' : 2, 'three' : 3 };
  
  String toString() => 'Values: $i, $d, $n, $b, $s, $l, $m, $fl, $fm';
  
}

class PartialEffect {
  int i = 1;
  double d = 1.0;
  num n = 1;
  bool b = false;
  String s = "Pretty String";
  List l = [1, 2, 3];
  Map m = { 'one' : 1, 'two' : 2, 'three' : 3 };
  final List fl = [1, 2, 3];
  final Map fm = { 'one' : 1, 'two' : 2, 'three' : 3 };
  
  String toString() => 'Values: $i, $d, $n, $b, $s, $l, $m, $fl, $fm';
}

void main() {
  int i = 1;
  double d = 1.0;
  num n = 1;
  bool b = false;
  String s = "Pretty String";
  List l = [1, 2, 3];
  Map m = { 'one' : 1, 'two' : 2, 'three' : 3 };
  final List fl = [1, 2, 3];
  final Map fm = { 'one' : 1, 'two' : 2, 'three' : 3 };
  SideEffect se = new SideEffect();
  PartialEffect pe = new PartialEffect();
  
  // int
  testFunction(i, addOne); // No Side Effects
  
  // double
  testFunction(d, addOne); // No Side effects
  
  // num
  testFunction(n, addOne); // No Side Effects
  
  // bool
  testFunction(b, addOne); // No Side effects
  
  // String
  testFunction(s, addOne); // No Side effects
  testFunction(s, modifyOne); // No Side effects
  
  // List
  testFunction(l, addOne); // Side effect!
  testFunction(l, modifyOne); // Side effect!
  testFunction(l[1], addOne); // No side effect
  
  // Map
  testFunction(m, addOne); // Side effect!
  testFunction(m, modifyOne); // Side effect!
  testFunction(m['one'], addOne); // No Side effect
  
  // final List
  testFunction(fl, addOne); // Side effect!
  testFunction(fl, modifyOne); // Side effect!
  testFunction(fl[1], addOne); // No side effect
  
  // final Map
  testFunction(fm, addOne); // Side effect!
  testFunction(fm, modifyOne); // Side effect!
  testFunction(fm['one'], addOne); // No Side effect
  
  // Class (directly modify properties)
  testFunction(se, addOne); // Side effect! (technically a modification)
  testFunction(se, modifyOne); // Side effect!
  
  // Class (passing properties rather than modifying)
  testFunction(pe, addOne); // Some side effects!
  testFunction(pe, modifyOne); // Some side effects!
}

void addOne(var arg) {
  if(arg is num) arg += 1; // Num captures int, double and num types
  if(arg is bool) arg = true;
  if(arg is String) arg = arg + " no more!";
  if(arg is List) arg.add(4);
  if(arg is Map) arg['four'] = 4;
  if(arg is SideEffect) {
    arg.i += 1;
    arg.d += 1;
    arg.n += 1;
    arg.b = true;
    arg.s = arg.s + " no more!";
    arg.l.add(4);
    arg.m['four'] = 4;
  }
  if(arg is PartialEffect) {
    addOne(arg.i);
    addOne(arg.d);
    addOne(arg.n);
    addOne(arg.b);
    addOne(arg.s);
    addOne(arg.l);
    addOne(arg.m);
  }
  
  print('In call: $arg');
}

void modifyOne(var arg) {
  if(arg is String) arg = "Completely Different";
  if(arg is List) arg[0] = 100;
  if(arg is Map) arg['one'] = 100;
  if(arg is SideEffect) {
    arg.i += 1;
    arg.d += 1;
    arg.n += 1;
    arg.b = true;
    arg.s = "Completely Different";
    arg.l[0] = 100;
    arg.m['one'] = 100;
  }
  if(arg is PartialEffect) {
    modifyOne(arg.i);
    modifyOne(arg.d);
    modifyOne(arg.n);
    modifyOne(arg.b);
    modifyOne(arg.s);
    modifyOne(arg.l);
    modifyOne(arg.m);
  }
  
  print('In call: $arg');
}

void testFunction(var arg, modify mod) {
  if(arg is num) print('Testing Num:'); // Num captures int, double and num types
  if(arg is bool) print('Testing bool:');
  if(arg is String) print('Testing String');
  if(arg is List) print('Testing List:');
  if(arg is Map) print('Testing Map:');
  if(arg is SideEffect) print('Testing class SideEffect');
  if(arg is PartialEffect) print('Testing class PartialEffect');
  
  print('Before call: $arg');
  mod(arg);
  print('After call: $arg\n');
}