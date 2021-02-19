class PageModel {
  String __titles;
  String __descriptions;
  String __images;

  PageModel(this.__titles, this.__descriptions, this.__images);

  String get image => __images;

  String get description => __descriptions;

  String get title => __titles;
}
