class Data {
  int intvlHour = 1;
  int intvlMin = 0;
  int startHour = 9;
  int startMin = 0;
  int endHour = 17;
  int endMin = 0;
  Map<String, int> map = {
    "intvlHour": 1,
    "intvlMin": 0,
    "startHour": 9,
    "startMin": 0,
    "endHour": 17,
    "endMin": 0
  };
  int getVal(String key) {
    return map[key];
  }
}
