const functions = require('firebase-functions');

// The Firebase Admin SDK to access the Firebase Realtime Database.
const admin = require('firebase-admin');
admin.initializeApp(functions.config().firebase);

// // Create and Deploy Your First Cloud Functions
// // https://firebase.google.com/docs/functions/write-firebase-functions
//
exports.helloWorld = functions.https.onRequest((request, response) => {
 response.send("Hello from Firebase LBTA!");
});


exports.observeFriendLike = functions.database.ref('/CRACC/LikesNoti/{uid}/{likingId}')
  .onCreate((snap,context) => {

    var likingId = context.params.uid;
    var uid = context.params.likingId

    // let's log out some messages

    console.log('User: ' + uid + ' is liking ' + likingId);


    // trying to figure out fcmToken to send a push message
    return admin.database().ref('/CRACC/fcmToken/' + likingId).once('value', snapshot => {

      var userWeAreLiking = snapshot.val();

      return admin.database().ref('/CRACC/fcmToken/' + uid).once('value', snapshot => {

        var userDoingTheLiking = snapshot.val();

        var payload = {
          notification: {
            title: "You have a new like",
            body: userDoingTheLiking.nickname + ' just likes your activity',
            badge : '1',
            sound: 'default',
          },
          data: {
            followerId: uid
          }
        }

        admin.messaging().sendToDevice(userWeAreLiking.fcmToken, payload)
          .then(response => {
            console.log("Successfully sent message:", response);
          }).catch(function(error) {
            console.log("Error sending message:", error);
          });

      })


    })


  })


  exports.observeFriendRequest = functions.database.ref('/CRACC/AddFrNoti/{uid}/{likingId}')
    .onCreate((snap,context) => {

      const likingId = context.params.uid
      const uid = context.params.likingId
      console.log('User: ' + uid + ' is asking to add ' + likingId);

      // let's log out some messages

      // trying to figure out fcmToken to send a push message
      return admin.database().ref('/CRACC/fcmToken/' + likingId).once('value', snapshot => {

        const userWeAreLiking = snapshot.val();

        return admin.database().ref('/CRACC/fcmToken/' + uid).once('value', snapshot => {

          const userDoingTheLiking = snapshot.val();

          const payload = {
            notification: {
              title: "You have a new friend request",
              body: userDoingTheLiking.nickname + ' just requests to add you',
              badge : '1',
              sound: 'default',
            },
            data: {
              followerId: uid
            }
          }

          admin.messaging().sendToDevice(userWeAreLiking.fcmToken, payload)
            .then(response => {
              console.log("Successfully sent message:", response);
            }).catch(function(error) {
              console.log("Error sending message:", error);
            });

        })


      })


    })

    exports.observeConfirmedFriendRequest = functions.database.ref('/CRACC/ConfirmedFrNoti/{uid}/{likingId}')
       .onCreate((snap,context) => {

        var likingId = context.params.uid
        var uid = context.params.likingId

        // let's log out some messages

        console.log('User: ' + uid + ' is asking to add ' + likingId);

        // trying to figure out fcmToken to send a push message
        return admin.database().ref('/CRACC/fcmToken/' + likingId).once('value', snapshot => {

          var userWeAreLiking = snapshot.val();

          return admin.database().ref('/CRACC/fcmToken/' + uid).once('value', snapshot => {

            var userDoingTheLiking = snapshot.val();

            var payload = {
              notification: {
                title: "You have a new friend request",
                body: userDoingTheLiking.nickname + ' just confirms your friend request',
                badge : '1',
                sound: 'default',
              },
              data: {
                followerId: uid
              }
            }

            admin.messaging().sendToDevice(userWeAreLiking.fcmToken, payload)
              .then(response => {
                console.log("Successfully sent message:", response);
              }).catch(function(error) {
                console.log("Error sending message:", error);
              });

          })


        })


      })

      exports.observePersonalChatNoti = functions.database.ref('/CRACC/NormalChatNoti/{uid}/{likingId}')
        .onCreate((snap,context) => {

          var likingId = context.params.uid
          var uid = context.params.likingId

          // let's log out some messages

          console.log('User: ' + uid + ' is asking to add ' + likingId);

          // trying to figure out fcmToken to send a push message
          return admin.database().ref('/CRACC/fcmToken/' + likingId).once('value', snapshot => {

            var userWeAreLiking = snapshot.val();

            return admin.database().ref('/CRACC/fcmToken/' + uid).once('value', snapshot => {

              var userDoingTheLiking = snapshot.val();

              var payload = {
                notification: {
                  title: "You have a new message",
                  body: userDoingTheLiking.nickname + ' just sends you a new message',
                  badge : '1',
                  sound: 'default',
                },
                data: {
                  followerId: uid
                }
              }

              admin.messaging().sendToDevice(userWeAreLiking.fcmToken, payload)
                .then(response => {
                  console.log("Successfully sent message:", response);
                }).catch(function(error) {
                  console.log("Error sending message:", error);
                });

            })


          })


        })



        exports.observeGameChatNoti = functions.database.ref('/CRACC/GroupChatNoti/{uid}/{likingId}')
          .onCreate((snap,context) => {

            var likingId = context.params.uid
            var uid = context.params.likingId

            // let's log out some messages

            console.log('User: ' + uid + ' is having a message ' + likingId);

            // trying to figure out fcmToken to send a push message
            return admin.database().ref('/CRACC/fcmToken/' + likingId).once('value', snapshot => {

              var userWeAreLiking = snapshot.val();

              return admin.database().ref('/CRACC/Game_Chat_Info/' + uid).once('value', snapshot => {

                var userDoingTheLiking = snapshot.val();

                var payload = {
                  notification: {
                    title: "You have a new message",
                    body: 'You have a new message in '+ userDoingTheLiking.type.toLowerCase() + ' group ' + userDoingTheLiking.name,
                    badge : '1',
                    sound: 'default',
                  },
                  data: {
                    followerId: uid
                  }
                }

                admin.messaging().sendToDevice(userWeAreLiking.fcmToken, payload)
                  .then(response => {
                    console.log("Successfully sent message:", response);
                  }).catch(function(error) {
                    console.log("Error sending message:", error);
                  });

              })


            })


          })



exports.sendPushNotifications = functions.https.onRequest((req, res) => {
  res.send("Attempting to send push notification...")
  console.log("LOGGER --- Trying to send push message...")


  var uid = '0lNEGWRpsIMvVNQkuO9sTAsXhwT2';

  return admin.database().ref().child("CRACC").child("fcmToken").child(uid).once('value', snapshot => {

    var user = snapshot.val();

    console.log("User username: " + user.Name + " fcmToken: " + user.fcmToken);

    var payload = {
      notification: {
        title: "Push notification TITLE HERE",
        body: "Body over here is our message body...",
        badge : '1',
        sound: 'default',
      }
    }

    admin.messaging().sendToDevice(user.fcmToken, payload)
      .then(function(response) {
        // See the MessagingDevicesResponse reference documentation for
        // the contents of response.
        console.log("Successfully sent message:", response);
      })
      .catch(function(error) {
        console.log("Error sending message:", error);
      });

  })



})
