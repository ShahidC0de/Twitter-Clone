class TweetParser {
  List<String> getHashTagsFromText(String text) {
    List<String> hashTags = [];
    List<String> wordsInSentence = text.split('');
    for (String word in wordsInSentence) {
      if (word.startsWith('#')) {
        hashTags.add(word);
      }
    }
    return hashTags;
  }

  String getLinkFromTheText(String text) {
    String link = '';
    List<String> wordsInSentence = text.split('');
    for (String word in wordsInSentence) {
      if (word.startsWith('http://') || word.startsWith('www.')) {
        link = word;
      }
    }
    return link;
  }
}
