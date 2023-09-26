import 'package:onenizam/headers.dart';

const String eUsername = '/username=<username|.+>';
const String eAccessUsername = '/access_username=<accessUsername|.+>';
const String eToken = '/token=<token|.+>';
const String eAccess = '$eAccessUsername$eToken';

const String eCount = '/count=<count|.+>';
const String eSkip = '/skip=<skip|.+>';
const String eLimit = '/limit=<limit|.+>';
const String ePagination = '$eLimit$eSkip';

const String eTotalBytes = '/total_bytes=<totalBytes|.+>';

// String ePost({required bool isPagination, required bool isAccess}) {
//   String path = '$eUsername$eSericeCaption$ePostCaption';
//   return addPaginationAndAccess(
//     path: path,
//     isPagination: isPagination,
//     isAccess: isAccess,
//   );
// }

// String ePosts({required bool isPagination, required bool isAccess}) =>
//     addPaginationAndAccess(
//       path: ePostCaption,
//       isPagination: isPagination,
//       isAccess: isAccess,
//     );

// String eService({required bool isPagination, required bool isAccess}) {
//   String path = '$eUsername$eSericeCaption';
//   return addPaginationAndAccess(
//     path: path,
//     isPagination: isPagination,
//     isAccess: isAccess,
//   );
// }

// String _addPagination({required String path, required bool isPagination}) {
//   if (isPagination) {
//     path += ePagination;
//   }
//   return path;
// }

// String _addAccess({required String path, required bool isAccess}) {
//   if (isAccess) {
//     path += eAccess;
//   }
//   return path;
// }

// String addPaginationAndAccess({
//   required String path,
//   required bool isPagination,
//   required bool isAccess,
// }) {
//   path = _addPagination(path: path, isPagination: isPagination);
//   path = _addAccess(path: path, isAccess: isAccess);
//   return path;
// }

// String eUser({required bool isPagination, required bool isAccess}) {
//   String path = eUsername;
//   return addPaginationAndAccess(
//     path: path,
//     isPagination: isPagination,
//     isAccess: isAccess,
//   );
// }

// String ePostLikes({required bool isPagination, required bool isAccess}) =>
//     ePost(
//       isPagination: isPagination,
//       isAccess: isAccess,
//     );

// String ePostComments({
//   required bool isPagination,
//   required bool isAccess,
// }) =>
//     ePost(
//       isPagination: isPagination,
//       isAccess: isAccess,
//     );
