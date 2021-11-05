import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:redditech/material/snackbar_error.dart';
import 'package:redditech/widgets/global_info.dart';
import 'package:redditech/widgets/request.dart';
import 'package:redditech/model/subreddit_model.dart';
import 'package:redditech/widgets/subreddit_widget.dart';

class ProfileLoggedOut extends StatelessWidget {
  final String messageLoggedOut;
  const ProfileLoggedOut({required this.messageLoggedOut, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
          const SizedBox(height: 24.0),
          Text(messageLoggedOut),
          ElevatedButton(
            onPressed: () => {Navigator.pushNamed(context, '/authwebview')},
            child: const Text('Login'),
            style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(Colors.blueGrey)),
          ),
        ]));
  }
}

class ProfilePictureWidget extends StatelessWidget {
  final double width;
  final double height;
  final double borderWidth;
  final String path;

  const ProfilePictureWidget(
      {required this.width,
      required this.height,
      required this.borderWidth,
      required this.path,
      Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        height: height,
        width: width,
        decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: Colors.white, width: borderWidth),
            image: DecorationImage(
                fit: BoxFit.fitHeight, image: NetworkImage(path))));
  }
}

class HeadProfile extends StatelessWidget {
  const HeadProfile({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Consumer<GlobalProvider>(
        builder: (BuildContext context, GlobalProvider info, Widget? child) {
      return Container(
          height: 150,
          decoration: BoxDecoration(
              image: DecorationImage(
                  fit: BoxFit.fitWidth,
                  image: NetworkImage(context
                      .read<GlobalProvider>()
                      .identity
                      .profileBannerPath))),
          child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: const Icon(Icons.arrow_back, color: Colors.white)),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    ShaderMask(
                      shaderCallback: (rect) {
                        return const LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [Colors.black, Colors.transparent],
                        ).createShader(Rect.fromLTRB(rect.width * 0.75,
                            rect.height * 0.75, rect.width, rect.height));
                      },
                      blendMode: BlendMode.dstIn,
                      child: ProfilePictureWidget(
                        width: 100,
                        height: 100,
                        borderWidth: 3,
                        path: context
                            .read<GlobalProvider>()
                            .identity
                            .profilePicturePath,
                      ),
                    ),
                  ],
                ),
                Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                  IconButton(
                      onPressed: () {
                        context.read<GlobalProvider>().logOut();
                      },
                      icon: const Icon(Icons.power_settings_new_sharp,
                          color: Colors.white)),
                  const Text("Log out",
                      style: TextStyle(color: Colors.white, fontSize: 10))
                ]),
              ]));
    });
  }
}

class ProfileLoggedIn extends StatelessWidget {
  const ProfileLoggedIn({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (context.read<GlobalProvider>().identity.profileName == "") {
      NewApiServices()
          .getMyIdentity(context.read<GlobalProvider>().token)
          .then((myIdentity) {
        context.read<GlobalProvider>().setIdentity(myIdentity);
      }).catchError((onError) {
        showSnackBarError(context, onError);
      });
    }
    NewApiServices()
        .searchSubRedditISubscribedTo(context.read<GlobalProvider>().token)
        .then((listSubReddit) {
      context.read<GlobalProvider>().setListSubRedditSubscribed(listSubReddit);
    }).catchError((onError) {
      showSnackBarError(context, onError);
    });
    return Consumer<GlobalProvider>(
        builder: (BuildContext context, GlobalProvider info, Widget? child) {
      return Center(
        child: Column(children: <Widget>[
          const HeadProfile(),
          Container(
              padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 0),
              child: Text(
                context.read<GlobalProvider>().identity.profileName,
                style: const TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.w600,
                  fontSize: 20,
                ),
              )),
          Container(
              padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 0),
              child: Text(
                  context.read<GlobalProvider>().identity.profileDescription,
                  style: const TextStyle(
                    fontStyle: FontStyle.italic,
                  ))),
          Row(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[
            Text(
                '${context.read<GlobalProvider>().identity.profileNumberFriends} followers'),
            IconButton(onPressed: () {}, icon: const Icon(Icons.people))
          ]),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
                  padding: const EdgeInsets.all(2),
                  decoration: BoxDecoration(
                      borderRadius: const BorderRadius.all(Radius.circular(5)),
                      border: Border.all(color: Colors.black54, width: 1)),
                  child: Text(
                      '${context.read<GlobalProvider>().listSubRedditSubscribed.length.toString()} subscriptions')),
              IconButton(
                  onPressed: () {
                    context.read<GlobalProvider>().isEditingSubReddit =
                        !context.read<GlobalProvider>().isEditingSubReddit;
                    context.read<GlobalProvider>().actualizeApplication();
                  },
                  icon: const Icon(Icons.edit)),
            ],
          ),
          Expanded(
            child: Container(
              padding: EdgeInsets.fromLTRB(0, 5, 0, 0),
              margin: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.black12,
                borderRadius: const BorderRadius.all(Radius.circular(20)),
              ),
              child: ListView(children: <Widget>[
                for (SubReddit subReddit
                    in context.read<GlobalProvider>().listSubRedditSubscribed)
                  SubRedditWidget(subReddit: subReddit)
              ]),
            ),
          )
        ]),
      );
    });
  }
}
