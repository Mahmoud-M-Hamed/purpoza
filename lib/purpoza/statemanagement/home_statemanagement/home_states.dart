abstract class HomeStates {}

// ------------------------------<Home User Data>----------------------------------

class HomeInitialState extends HomeStates {}

class HomeLoadingState extends HomeStates {}

class HomeGetUserDataSuccessState extends HomeStates {}

class HomeGetUserDataErrorState extends HomeStates {}

class HomeChangeBottomNavBarState extends HomeStates {}

// ------------------------------<Update User Data>----------------------------------

class UpdateLoadingDataState extends HomeStates {}

class UpdateSuccessDataState extends HomeStates {}

class UpdateErrorDataState extends HomeStates {}

// ------------------------------<Pick Profile Image>----------------------------------

class PickProfileImageLoadingState extends HomeStates {}

class PickProfileImageSuccessState extends HomeStates {}

class PickProfileImageErrorState extends HomeStates {}

// ------------------------------<Pick Cover Image>----------------------------------

class PickCoverImageLoadingState extends HomeStates {}

class PickCoverImageSuccessState extends HomeStates {}

class PickCoverImageErrorState extends HomeStates {}

// ------------------------------<Upload Profile Image>----------------------------------

class UploadProfileImageLoadingState extends HomeStates {}

class UploadProfileImageSuccessState extends HomeStates {}

class UploadProfileImageErrorState extends HomeStates {}

// ------------------------------<Upload Cover Image>----------------------------------

class UploadCoverImageLoadingState extends HomeStates {}

class UploadCoverImageSuccessState extends HomeStates {}

class UploadCoverImageErrorState extends HomeStates {}

// --------------------<Posts>---------------------------------------------------

class HomeCreatePostPageState extends HomeStates {}

class PostInProgress extends HomeStates {}

// --------------------<Create Posts>---------------------------------------------------

class CreatePostLoadingState extends HomeStates {}

class CreatePostSuccessState extends HomeStates {}

class CreatePostErrorState extends HomeStates {}

// --------------------<Get Posts>---------------------------------------------------

class GetPostLoadingState extends HomeStates {}

class GetPostSuccessState extends HomeStates {}

class GetPostErrorState extends HomeStates {}

// --------------------<Pick Image Posts>---------------------------------------------------

class PickPostImageLoadingState extends HomeStates {}

class PickPostImageSuccessState extends HomeStates {}

class PickPostImageErrorState extends HomeStates {}

// --------------------<Upload Image Posts>---------------------------------------------------

class UploadPostImageLoadingState extends HomeStates {}

class UploadPostImageSuccessState extends HomeStates {}

class UploadPostImageErrorState extends HomeStates {}

// --------------------<Like Posts>---------------------------------------------------

class LikePostLoadingState extends HomeStates {}

class LikePostSuccessState extends HomeStates {}

class LikePostErrorState extends HomeStates {}

// --------------------<chats>---------------------------------------------------

class ChatGetUsersLoadingState extends HomeStates {}

class ChatGetUsersSuccessState extends HomeStates {}

class ChatGetUsersErrorState extends HomeStates {}

class ChatSendMessageSuccessState extends HomeStates {}

class ChatSendMessageErrorState extends HomeStates {}

class ChatReceiveSuccessState extends HomeStates {}

class ChatReceiveErrorState extends HomeStates {}
