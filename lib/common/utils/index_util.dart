// limit 만큼 sublist return
List<T> getPrevItems<T>(List<T> list, int endIndex, int count) {
  // startIndex부터 최대 count개 요소를 가져오되, 범위를 초과하지 않도록 처리
  int startIndex = (endIndex - count) >= 0 ? endIndex - count : 0;
  return list.sublist(startIndex, endIndex + 1);
}
