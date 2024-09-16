import 'dart:convert';
import 'dart:developer';

import 'package:google_sign_in/google_sign_in.dart';
import 'package:googleapis/drive/v3.dart' as drive;

import '../models/contact_info_model.dart';
import '../pages/dashboard/home_page/bloc/home_bloc.dart';
import 'google_auth_client.dart';

class GoogleDriveSync {
  final HomeBloc bloc;

  GoogleDriveSync({required this.bloc});

  final GoogleSignIn _googleSignIn =
      GoogleSignIn(scopes: [drive.DriveApi.driveAppdataScope]);

  drive.DriveApi? _driveApi;

  Future<bool> signIn() async {
    try {
      final account = await _googleSignIn.signIn();
      if (account == null) return false;
      final googleAuth = await account.authentication;
      log('Access token: ${googleAuth.accessToken}');
      final authHeaders = await account.authHeaders;
      final authClient = GoogleAuthClient(authHeaders);
      _driveApi = drive.DriveApi(authClient);
      log('Sign-in successful: ${account.email}');
      return true;
    } catch (e, s) {
      log("Error signing in: $e", stackTrace: s);
      return false;
    }
  }

  Future<void> syncData() async {
    if (_driveApi == null) {
      log("Not signed in");
      return;
    }
    try {
      ///TODO
      // get local data
      final localData = await bloc.getContactInfoList();
      // get remote data
      final remoteData = await _getRemoteData();
      // merge data
      final mergedData = await _mergeData(localData, remoteData);
      // sync updated data
      await _saveRemoteData(mergedData);
      log("Sync completed successfully!");
    } catch (e, s) {
      log("Error syncing data: $e", stackTrace: s);
    }
  }

  Future<List<ContactInfoModel>> _getRemoteData() async {
    try {
      final fileList = await _driveApi?.files.list(
        spaces: 'appDataFolder',
        q: "name = 'backup.json'",
      );
      if (fileList?.files?.isEmpty ?? false) return [];
      final file = fileList!.files!.first;
      final response = await _driveApi!.files.get(file.id!,
          downloadOptions: drive.DownloadOptions.fullMedia) as drive.Media;
      final content = await response.stream.transform(utf8.decoder).join();
      final data = jsonDecode(content) as List;
      return data.map((item) => ContactInfoModel.fromMap(item)).toList();
    } catch (e) {
      throw Exception(e);
    }
  }

  Future<List<ContactInfoModel>> _mergeData(
    List<ContactInfoModel> local,
    List<ContactInfoModel> remote,
  ) async {
    try {
      final merged = <int, ContactInfoModel>{};
      for (var item in local + remote) {
        if (!merged.containsKey(item.id) ||
            merged[item.id]!.lastModified.isBefore(item.lastModified)) {
          merged[item.id] = item;
        }
      }
      return merged.values.toList();
    } catch (e) {
      throw Exception(e);
    }
  }

  Future<void> _saveRemoteData(List<ContactInfoModel> data) async {
    final jsonData = jsonEncode(data.map((e) => e.toJson()).toList());
    final fileList = await _driveApi?.files.list(
      spaces: 'appDataFolder',
      q: "name = 'backup.json'",
    );
    if ((fileList?.files ?? []).isEmpty) {
      final driveFile = drive.File()
        ..name = 'backup.json'
        ..parents = ['appDataFolder'];
      await _driveApi?.files.create(
        driveFile,
        uploadMedia: drive.Media(
            Stream.fromIterable([utf8.encode(jsonData)]), jsonData.length),
      );
    } else {
      final file = fileList?.files?.first;
      await _driveApi?.files.update(
        drive.File()..name = 'backup.json',
        file!.id!,
        uploadMedia: drive.Media(
            Stream.fromIterable([utf8.encode(jsonData)]), jsonData.length),
      );
    }
  }
}
