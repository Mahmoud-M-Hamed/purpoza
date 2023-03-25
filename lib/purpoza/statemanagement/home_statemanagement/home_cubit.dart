import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import '../../models/chat_message_model/message_model.dart';
import '../../models/home_model/home_model.dart';
import '../../models/post_model/post_model.dart';
import '../../modules/home_activity/layouts/addpost/addpost_activity.dart';
import '../../modules/home_activity/layouts/chats/chat_activity.dart';
import '../../modules/home_activity/layouts/feeds/feeds_activity.dart';
import '../../modules/home_activity/layouts/profile/profile_activity.dart';
import '../../modules/home_activity/layouts/settings/settings_activity.dart';
import '../../styles/icons/broken_icons.dart';
import 'home_states.dart';

class HomeCubit extends Cubit<HomeStates> {
  HomeCubit() : super(HomeInitialState());

  static HomeCubit get(context) => BlocProvider.of(context);

  int currentIndex = 0;
  int chatIndex = 1;
  String uploadPI = "";

  File? profileImage;
  File? coverImage;
  File? postImage;

  HomeModel? homeModel;
  PostModel? postModel;

  List<String> profileNumbers = [
    '198',
    '1K',
    '5K',
    '100',
  ];

  List<String> profileDetails = ['posts', 'Likes', 'Followers', 'Following'];

  List<String> titles = [
    'home',
    'chat',
    'post',
    'profile',
    'settings',
  ];

  List<Widget> bodies = [
    FeedsActivity(),
    const ChatActivity(),
    AddPostActivity(),
    const ProfileActivity(),
    const SettingsActivity(),
  ];

  List<IconData> brokenIconsList = [
    BrokenIcons.home,
    BrokenIcons.chat,
    BrokenIcons.plus_rec,
    BrokenIcons.user_1,
    BrokenIcons.more,
  ];

  void changeCurrentIndexState(context, int index) {
    if (index == 2) {
      emit(HomeCreatePostPageState());
      Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => AddPostActivity()));
    } else {
      currentIndex = index;
      emit(HomeChangeBottomNavBarState());
    }
  }

  void changeChatIndexState(context, int index) {
    emit(HomeCreatePostPageState());
    chatIndex = index;
    emit(HomeChangeBottomNavBarState());
  }

  void navigateReplacement(context, Widget widget) {
    Navigator.of(context)
        .pushReplacement(MaterialPageRoute(builder: (context) => widget));
    emit(state);
  }

  // ------------------------------<get user data>--------------

  Future<void> getUserData() async {
    emit(HomeLoadingState());
    await FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .get()
        .then((event) {
      homeModel = HomeModel.fromJson(event.data()!);
      emit(HomeGetUserDataSuccessState());
    }).catchError((e) {
      emit(HomeGetUserDataErrorState());
    });
  }

  // ------------------------------<Chats>--------------

  List<HomeModel> chatUsersList = [];

  void getChatUsers() {
    emit(ChatGetUsersLoadingState());
    chatUsersList = [];
    FirebaseFirestore.instance.collection('users').get().then((value) {
      for (var element in value.docs) {
        if (element.data()['uId'] != homeModel!.uId) {
          chatUsersList.add(HomeModel.fromJson(element.data()));
        }
      }
      emit(ChatGetUsersSuccessState());
    }).catchError((e) {
      emit(ChatGetUsersErrorState());
    });
  }

  Future<void> sendMessage({
    required String dateTime,
    required String receiverId,
    required String text,
  }) async {
    MessageModel messageModel = MessageModel(
      dateTime: dateTime,
      receiverId: receiverId,
      text: text,
    );

    await FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection('chats')
        .doc(receiverId)
        .collection('messages')
        .add(messageModel.toMap())
        .then((value) {
      emit(ChatSendMessageSuccessState());
    });

    FirebaseFirestore.instance
        .collection('users')
        .doc(receiverId)
        .collection('chats')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection('messages')
        .add(messageModel.toMap())
        .then((value) {
      emit(ChatSendMessageSuccessState());
    });
  }

  List<MessageModel> receiveMessageList = [];
  MessageModel? messageModel;

  void receiveMessage({
    required String receiverId,
  }) {
    FirebaseFirestore.instance
        .collection('users')
        .doc(homeModel!.uId)
        .collection('chats')
        .doc(receiverId)
        .collection('messages')
        .orderBy('dateTime')
        .get()
        .then((event) {
      receiveMessageList = [];
      for (var element in event.docs) {
        messageModel = MessageModel.fromJson(element.data());
        receiveMessageList.add(messageModel!);
      }
    });
  }

  // ------------------------------<update user data>--------------

  Future<void> updateUserProfileData({
    required String bio,
    required String userName,
  }) async {
    emit(UpdateLoadingDataState());

    await FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .update({
      'bio': (bio == '') ? homeModel!.bio : bio,
      'userName': (userName == '') ? homeModel!.userName : userName,
      'profileImage': (profileImage != null)
          ? await uploadProfileImage().whenComplete(() {
              emit(UploadProfileImageSuccessState());
            }).catchError((e) {
              emit(UploadProfileImageErrorState());
            })
          : homeModel!.profileImage,
      'coverImage': (coverImage != null)
          ? await uploadCoverImage().whenComplete(() {
              emit(UploadCoverImageSuccessState());
            }).catchError((e) {
              emit(UploadCoverImageErrorState());
            })
          : homeModel!.coverImage,
    }).whenComplete(() async {
      emit(UpdateSuccessDataState());
    }).catchError((error) {
      emit(UpdateErrorDataState());
    });
  }

  // ------------------------------<pick & upload profile>--------------

  Future<void> pickProfileImage() async {
    emit(PickProfileImageLoadingState());
    ImagePicker picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      profileImage = File(pickedFile.path);
      emit(PickProfileImageSuccessState());
    } else {
      emit(PickProfileImageErrorState());
    }
  }

  Future<String> uploadProfileImage() async {
    emit(UploadProfileImageLoadingState());
    Reference reference = FirebaseStorage.instance.ref().child('users/profile/'
        '${FirebaseAuth.instance.currentUser!.uid}/${Uri.file(profileImage!.path).pathSegments.last}');
    (await reference.putFile(profileImage!));
    var url = await reference.getDownloadURL();
    return url;
  }

  // ------------------------------<pick & upload cover>--------------

  Future<void> pickCoverImage() async {
    emit(PickCoverImageLoadingState());
    ImagePicker coverPicker = ImagePicker();
    final pickedFile = await coverPicker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      coverImage = File(pickedFile.path);
      emit(PickCoverImageSuccessState());
    } else {
      emit(PickCoverImageErrorState());
    }
  }

  Future<String> uploadCoverImage() async {
    emit(UploadCoverImageLoadingState());
    Reference reference = FirebaseStorage.instance
        .ref()
        .child('users/cover/${FirebaseAuth.instance.currentUser!.uid}/'
            '${Uri.file(coverImage!.path).pathSegments.last}');
    await reference.putFile(coverImage!);
    var url = await reference.getDownloadURL();
    return url;
  }

  // -------------------------------<create & upload posts>------------------------------------------

  Future<void> createPost(
    context, {
    required String? dateTime,
    required String? postText,
  }) async {
    emit(CreatePostLoadingState());
    if (postImage != null) {
      await uploadPostImageWithStates().then((value) => uploadPI = value);
    }
    await FirebaseFirestore.instance.collection('posts').doc().set({
      'userName': homeModel!.userName,
      'email': homeModel!.email,
      'uId': homeModel!.uId,
      'userImage': homeModel!.profileImage,
      'postText': postText,
      'dateTime': dateTime,
      'postImage': (postImage != null) ? uploadPI : '',
    }).whenComplete(() {
      emit(CreatePostSuccessState());
    }).catchError((e) {
      emit(CreatePostErrorState());
    });
  }

  Future<void> pickPostImage() async {
    emit(PickPostImageLoadingState());
    ImagePicker picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      postImage = File(pickedFile.path);
      emit(PickPostImageSuccessState());
    } else {
      emit(PickPostImageErrorState());
    }
  }

  Future<String> uploadPostImage() async {
    emit(UploadPostImageLoadingState());
    Reference reference = FirebaseStorage.instance.ref().child(
        'posts/${Uri.file(postImage!.path.toString()).pathSegments.last}');
    (await reference.putFile(postImage!));
    uploadPI = await reference.getDownloadURL();
    return uploadPI;
  }

  Future<String> uploadPostImageWithStates() async =>
      await uploadPostImage().whenComplete(() {
        emit(UploadPostImageSuccessState());
      });

  List<PostModel> postsList = [];
  List likePostList = [];

  Future<void> getPosts() async {
    emit(GetPostLoadingState());
    await FirebaseFirestore.instance.collection('posts').get().then((event) {
      for (var element in event.docs) {
        postModel = PostModel.fromJson(element.data());
        getPostLikesNumber(element.id);
        likePostList.add(element.id);
        postsList.add(postModel!);
      }
      emit(GetPostSuccessState());
    });
  }

  // -------------------------------<like posts>------------------------------------------

  Future<void> likePost(String? postId) async {
    emit(LikePostLoadingState());
    await FirebaseFirestore.instance
        .collection('posts')
        .doc(postId)
        .collection('likes')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .set({'isLike': true}).whenComplete(() {
      emit(LikePostSuccessState());
    }).catchError((e) {
      emit(LikePostErrorState());
    });
  }

  List likesNumberList = [];

  void getPostLikesNumber(String postId) {
    FirebaseFirestore.instance
        .collection('posts')
        .doc(postId)
        .collection('likes')
        .snapshots()
        .listen((value) {
      likesNumberList.add(value.docs.length);
      for (var element in value.docs) {
        likeMap.addAll({postId: element.get('isLike')});
      }
    }).onDone(() {
      emit(LikePostSuccessState());
    });
  }

  bool likeStatus = false;
  Map<String, bool> likeMap = {};

  void addLike(String postId, int index) async {
    likeStatus = true;
    await likePost(postId);
    FirebaseFirestore.instance
        .collection('posts')
        .doc(postId)
        .collection('likes')
        .snapshots()
        .listen((value) {
      for (var element in value.docs) {
        likeMap.addAll({likePostList[index]: element.get('isLike')});
      }
    }).onDone(() {
      getPostLikesNumber(postId);
      emit(LikePostSuccessState());
    });
    emit(LikePostLoadingState());
  }

  Future<void> disLike(String postId) async {
    likeStatus = false;
    await FirebaseFirestore.instance
        .collection('posts')
        .doc(postId)
        .collection('likes')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .update({'isLike': false});
    getPostLikesNumber(postId);
    emit(LikePostSuccessState());
  }
}
