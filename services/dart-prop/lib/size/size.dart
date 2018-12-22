
String Size(int a) {
  String str = "";
  str = (a < 0) ? "negative" :
        (a == 0) ? "zero" :
        (a < 10) ? "small" :
        (a < 100) ? "big" :
        (a < 1000) ? "huge" :
        "enormous";
  return str;
}
