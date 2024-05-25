import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:researchproject/models/chatpage.dart';
import 'package:researchproject/models/message.dart';

class APIs {
  //for authentication
  static FirebaseAuth auth = FirebaseAuth.instance;
  //for accessing cloud firestore database
  static FirebaseFirestore firestore = FirebaseFirestore.instance;

  //for accessing cloud firebase storage
  static FirebaseStorage storage = FirebaseStorage.instance;

  //for storing self information
  static late ChatUser me;

  //for returning current user
  static User get user => auth.currentUser!;

  //for checking if user exists or not?
  static Future<bool> userExists() async {
    return (await firestore.collection('users').doc(user.uid).get()).exists;
  }

  //for getting current user info
  static Future<void> getSelfInfo() async {
    await firestore.collection('users').doc(user.uid).get().then((user) {
      if (user.exists) {
        me = ChatUser.fromJson(user.data()!);
      } else {}
    });
  }

  //for updating user info
  static Future<void> updateUserInfo() async {
    await firestore.collection('users').doc(user.uid).update({
      'name': me.name,
      'about': me.about,
      //and so on
    });
  }

  //for creating new user
  static Future<void> createUser() async {
    final time = DateTime.now().millisecondsSinceEpoch.toString();

    final chatUser = ChatUser(
        image: user.photoURL.toString(),
        about: "Hey, i'm using GoTogether",
        name: user.displayName.toString(),
        createdAt: time,
        id: user.uid,
        isOnline: false,
        lastActive: time,
        pushToken: '',
        email: user.email.toString());

    return await firestore
        .collection('users')
        .doc(user.uid)
        .set(chatUser.toJson());
  }

  //for getting all user from firestore
  static Stream<QuerySnapshot<Map<String, dynamic>>> getAllUsers() {
    return firestore
        .collection("chat")
        .where('id', isNotEqualTo: user.uid)
        .snapshots();
  }
  //for update profile picture of user
  // static Future<void> updateProfilePicture(File file) async{
  //    final ext=file.path.split('.').last;
  //    log('Extention: $ext');
  //   final ref= storage.ref().child('user_profile_pictures/${user.uid}.$ext');
  //   await ref.putFile(file,SettableMetadata(contentType: 'image/$ext')).then((p0){
  //     log('Data Transferred: ${p0.bytesTransferred/1000}kb')
  //   });
  //   //updating image in firestore database
  //   me.image=await ref.getDownloadURL();
  //   await firestore.collection('users').doc(user.uid).update({
  //     'image':me.image
  //   });
  //  }
//also call it by using this line : APIs.updateProfilePicture(File(_image!));

  //************************chat screen reloted API **************
  //usful for getting conversation
  static String getConversationID(String id) => user.uid.hashCode <= id.hashCode
      ? '${user.uid}_$id'
      : '${id}_${user.uid}';
  //for getting all user from firestore
  static Stream<QuerySnapshot<Map<String, dynamic>>> getAllMessages(
      ChatUser user) {
    return firestore
        .collection("chat/${getConversationID(user.id)}/messages")
        .snapshots();
  }

  //for sending message
  static Future<void> sendMessage(ChatUser chatUser, String msg) async {
    //message sending time (also used as id)
    final time = DateTime.now().millisecondsSinceEpoch.toString();
    //message to send
    final Message message = Message(
        msg: msg,
        read: '',
        told: chatUser.id,
        type: Type.text,
        sent: time,
        fromId: user.uid);
    final ref = firestore
        .collection("chat/${getConversationID(chatUser.id)}/messages");
    await ref.doc(time).set(message.toJson());
  }
}
