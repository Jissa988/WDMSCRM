
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:customer_portal/config/themes.dart';
import 'package:customer_portal/profile/profile.dart';
import 'package:customer_portal/viewModels/profile_provider.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';


class ProfilePic extends StatefulWidget {
  final bool isEdit; // Define a boolean property
 final String token;
 final int? customerId;
 final String fileName;
  const ProfilePic({Key? key, required this.isEdit, required  this.token, required this.customerId,required this.fileName}) : super(key: key);

  @override
  _ProfilePicState createState() => _ProfilePicState();
}

class _ProfilePicState extends State<ProfilePic> {
  PickedFile? _imageFile;
  final ImagePicker _picker = ImagePicker();
  bool _isTakingPhoto = false; // Track whether photo is being taken

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 115,
      width: 115,
      child: Stack(
        fit: StackFit.expand,
        clipBehavior: Clip.none,
        children: [
          FutureBuilder<Uint8List?>(
            future: widget.fileName != '' ? getImage() : Future.value(null),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting ||  _isTakingPhoto) {
                return CircularProgressIndicator(color: AppColors.theme_color,);
              } else {
                if (snapshot.hasError) {
                  return CircleAvatar(
                    backgroundImage: _imageFile != null
                        ? FileImage(
                      File(_imageFile!.path),
                    ) as ImageProvider<Object> // Cast FileImage to ImageProvider<Object>
                        : AssetImage("assets/profile/Profile_Image.png"),
                  );
                } else {
                  Uint8List? imageData = snapshot.data;
                  return CircleAvatar(
                    backgroundImage: imageData != null
                        ? MemoryImage(imageData)
                        : (_imageFile != null
                        ? FileImage(
                      File(_imageFile!.path),
                    ) as ImageProvider<Object> // Cast FileImage to ImageProvider<Object>
                        : AssetImage("assets/profile/Profile_Image.png")),
                  );
                }
              }
            },
          ),
          if (widget.isEdit)
            Positioned(
              right: -16,
              bottom: 0,
              child: SizedBox(
                height: 46,
                width: 46,
                child: TextButton(
                  style: TextButton.styleFrom(
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(50),
                      side: const BorderSide(color: Colors.white),
                    ),
                    backgroundColor: const Color(0xFFF5F6F9),
                  ),
                  onPressed: () {
                    showModalBottomSheet(
                      context: context,
                      builder: ((builder) => bottomSheet(context, _picker)),
                    );
                  },
                  child: Icon(Icons.camera_alt,color: AppColors.theme_color.withOpacity(0.5)),
                ),
              ),
            )
        ],
      ),
    );
  }

  Widget bottomSheet(BuildContext context, ImagePicker picker) {
    return Container(
      height: 100.0,
      width: MediaQuery.of(context).size.width,
      margin: EdgeInsets.symmetric(
        horizontal: 20,
        vertical: 20,
      ),
      child: Column(
        children: <Widget>[
          Text(
            "Choose Profile photo",
            style: TextStyle(
              fontSize: 20.0,
            ),
          ),
          SizedBox(
            height: 20,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              TextButton.icon(
                icon: Icon(Icons.camera,color: AppColors.theme_color),
                onPressed: () {
                  takePhoto(ImageSource.camera,);
                },
                label: Text("Camera",style: TextStyle(color: AppColors.theme_color)),
              ),
              TextButton.icon(
                icon: Icon(Icons.image,color: AppColors.theme_color),
                onPressed: () {
                  takePhoto(ImageSource.gallery);
                },
                label: Text("Gallery",style: TextStyle(color: AppColors.theme_color)),
              ),
            ],
          ),
        ],
      ),
    );
  }
  void takePhoto(ImageSource source,) async {
    setState(() {
      _isTakingPhoto = true; // Set state to indicate photo is being taken
    });

    final pickedFile = await _picker.pickImage(source: source);
    if (pickedFile != null) {
print('pickedFile--${pickedFile.path}');
print('pickedFile--${pickedFile.name}');

ProfileProvider profileProvider = Provider.of<ProfileProvider>(context, listen: false);

if(widget.fileName.isNotEmpty) {
  profileProvider.deleteImage(widget.token, widget.fileName)
      .then((_) {
    print(profileProvider.stringstatus);
    print("message--" + profileProvider.msg);
    if (profileProvider.stringstatus == 'Success') {
      print("message--" + profileProvider.msg);

      profileProvider.uploadImage(widget.token, pickedFile, widget!.customerId)
          .then((_) {
        print(profileProvider.stringstatus);
        print("message--" + profileProvider.msg);
        if (profileProvider.stringstatus == 'Success') {
          print("message--" + profileProvider.msg);
          profileProvider.saveProfileimage(
              widget.token, widget!.customerId, profileProvider.filePath,
              profileProvider.fileName)
              .then((_) {
            print(profileProvider.status);
            print("message--" + profileProvider.msg);
            if (profileProvider.status == 1) {
              print("message--" + profileProvider.msg);
              setState(() {
                _isTakingPhoto = false;
                Navigator.pop(context);// Set state to indicate photo is being taken
              });
              Navigator.pop(context);
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      ProfileScreen(),

                ),
              );


            } else {
              // Show login failure message
              print("message--" + profileProvider.msg);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    "${profileProvider.msg}",
                    style: TextStyle(fontFamily: 'Metropolis'),
                  ),
                  duration: Duration(seconds: 2),
                  backgroundColor: Colors.red[700],
                ),
              );
            }
          });
        } else {
          // Show login failure message
          print("message--" + profileProvider.msg);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                "${profileProvider.msg}",
                style: TextStyle(fontFamily: 'Metropolis'),
              ),
              duration: Duration(seconds: 2),
              backgroundColor: Colors.red[700],
            ),
          );
        }
      });
    } else {
      // Show login failure message
      print("message--" + profileProvider.msg);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            "${profileProvider.msg}",
            style: TextStyle(fontFamily: 'Metropolis'),
          ),
          duration: Duration(seconds: 2),
          backgroundColor: Colors.red[700],
        ),
      );

    }
  });
}else{
  profileProvider.uploadImage(widget.token, pickedFile, widget!.customerId)
      .then((_) {
    print(profileProvider.stringstatus);
    print("message--" + profileProvider.msg);
    if (profileProvider.stringstatus == 'Success') {
      print("message--" + profileProvider.msg);
      profileProvider.saveProfileimage(
          widget.token, widget!.customerId, profileProvider.filePath,
          profileProvider.fileName)
          .then((_) {
        print(profileProvider.status);
        print("message--" + profileProvider.msg);
        if (profileProvider.status == 1) {
          print("message--" + profileProvider.msg);

          setState(() {
            _imageFile = PickedFile(pickedFile.path);
          });
        } else {
          // Show login failure message
          print("message--" + profileProvider.msg);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                "${profileProvider.msg}",
                style: TextStyle(fontFamily: 'Metropolis'),
              ),
              duration: Duration(seconds: 2),
              backgroundColor: Colors.red[700],
            ),
          );
        }
      });
    } else {
      // Show login failure message
      print("message--" + profileProvider.msg);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            "${profileProvider.msg}",
            style: TextStyle(fontFamily: 'Metropolis'),
          ),
          duration: Duration(seconds: 2),
          backgroundColor: Colors.red[700],
        ),
      );
    }
  });
}




    }
  }
  Future<Uint8List?> getImage() async {
    ProfileProvider profileProvider = Provider.of<ProfileProvider>(context, listen: false);

    try {
      await profileProvider.imageView( widget.fileName);
      print(profileProvider.stringstatus);
      print("message--" + profileProvider.msg);
      if (profileProvider.stringstatus == 'Success') {
        print("message--" + profileProvider.msg);
        String base64String = profileProvider.msg;
        Uint8List bytes = base64Decode(base64String);
        return bytes;
      } else {
        // Show login failure message
        print("message--" + profileProvider.msg);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              "${profileProvider.msg}",
              style: TextStyle(fontFamily: 'Metropolis'),
            ),
            duration: Duration(seconds: 2),
            backgroundColor: Colors.red[700],
          ),
        );
        return null;
      }
    } catch (e) {
      print('Error fetching image: $e');
      return null;
    }
  }


}


