var BASE_URL="https://thestute.com/wp-json/wp/v2";

String mildHtmlParse(String original) {
  return original.
  replaceAll('<span style="font-weight: 400;">', "").
  replaceAll("</span>", "").
  replaceAll("<p>", "").
  replaceAll("</p>", "").
  replaceAll("&#8217;", "'").
  replaceAll("&#8230;", "...").
  replaceAll("&#8220;", '"').
  replaceAll("&#8221;", '"').
  replaceAll("&#8211;", '-').
  replaceAll("<ul>", "").
  replaceAll("</ul>", "").
  replaceAll("<li>", "• ").
  replaceAll("</li>", "");
}
