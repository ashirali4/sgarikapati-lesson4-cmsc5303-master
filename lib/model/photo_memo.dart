enum PhotoSource { camera, gallery }

enum DocKeyPhotoMemo {
  createdBy,
  title,
  memo,
  photoFilename,
  photoURL,
  timestamp,
  imageLabels,
  sharedWith
}

class PhotoMemo {
  String? docId; // firestore auto- generated Id
  late String createdBy; //email = user ID
  late String title;
  late String memo;
  late String photoFilename; //image/photo file at Cloud Storage
  late String photoURL; //URL of image
  DateTime? timestamp;
  late List<dynamic> imageLabels; //ML generated image labels
  late List<dynamic> sharedWith; //list of emails

  PhotoMemo({
    this.docId,
    this.createdBy = '',
    this.title = '',
    this.memo = '',
    this.photoFilename = '',
    this.photoURL = '',
    this.timestamp,
    List<dynamic>? imageLabels,
    List<dynamic>? sharedWith,
  }) {
    this.imageLabels = imageLabels == null ? [] : [...imageLabels];
    this.sharedWith = sharedWith == null ? [] : [...sharedWith];
  }

  PhotoMemo.clone(PhotoMemo p) {
    docId = p.docId;
    createdBy = p.createdBy;
    title = p.title;
    memo = p.memo;
    photoFilename = p.photoFilename;
    photoURL = p.photoURL;
    timestamp = p.timestamp;
    sharedWith = [...p.sharedWith];
    imageLabels = [...p.imageLabels];
  }

  //a.copyFrom(b) ==> a==b
  void copyFrom(PhotoMemo p) {
    docId = p.docId;
    createdBy = p.createdBy;
    title = p.title;
    memo = p.memo;
    photoFilename = p.photoFilename;
    photoURL = p.photoURL;
    timestamp = p.timestamp;
    sharedWith.clear();
    sharedWith.addAll(p.sharedWith);
    imageLabels.clear();
    imageLabels.addAll(p.imageLabels);
  }

//serialization

  Map<String, dynamic> toFirestoreDoc() {
    return {
      DocKeyPhotoMemo.title.name: title,
      DocKeyPhotoMemo.createdBy.name: createdBy,
      DocKeyPhotoMemo.memo.name: memo,
      DocKeyPhotoMemo.photoFilename.name: photoFilename,
      DocKeyPhotoMemo.photoURL.name: photoURL,
      DocKeyPhotoMemo.timestamp.name: timestamp,
      DocKeyPhotoMemo.imageLabels.name: imageLabels,
      DocKeyPhotoMemo.sharedWith.name: sharedWith,
    };
  }

//desrialization

  static PhotoMemo? fromFirestoreDoc({
    required Map<String, dynamic> doc,
    required String docId,
  }) {
    return PhotoMemo(
      docId: docId,
      createdBy: doc[DocKeyPhotoMemo.createdBy.name] ??= 'N/A',
      title: doc[DocKeyPhotoMemo.title.name] ??= 'N/A',
      memo: doc[DocKeyPhotoMemo.memo.name] ??= 'N/A',
      photoFilename: doc[DocKeyPhotoMemo.photoFilename.name] ??= 'N/A',
      photoURL: doc[DocKeyPhotoMemo.photoURL.name] ??= 'N/A',
      sharedWith: doc[DocKeyPhotoMemo.sharedWith.name] ??= [],
      imageLabels: doc[DocKeyPhotoMemo.imageLabels.name] ??= [],
      timestamp: doc[DocKeyPhotoMemo.timestamp.name] != null
          ? DateTime.fromMillisecondsSinceEpoch(
              doc[DocKeyPhotoMemo.timestamp.name].millisecondsSinceEpoch,
            )
          : DateTime.now(),
    );
  }

  static String? validateTitle(String? value) {
    return (value == null || value.trim().length < 3)
        ? 'Title too short'
        : null;
  }

  static String? validateMemo(String? value) {
    return (value == null || value.trim().length < 5) ? 'Memo too short' : null;
  }

  static String? validateSharedWith(String? value) {
    if (value == null || value.trim().isEmpty) return null;

    List<String> emailList =
        value.trim().split(RegExp('(,|;| )+')).map((e) => e.trim()).toList();

    for (String e in emailList) {
      if (e.contains('@') && e.contains('.')) {
        continue;
      } else {
        return 'invalid Email Address found: comma, semicolumn, space seprated list is a vlaid one';
      }
    }
  }
}
