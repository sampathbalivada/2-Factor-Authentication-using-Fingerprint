var email;
firebase.auth().onAuthStateChanged(function(user) {
  if (user) {
    // User is signed in.
    var db = firebase.firestore();
    var docRef = db.collection('auth').doc(user.email);
    docRef.onSnapshot(function(doc) {
      var currentState = doc.data().state;
      if(currentState === '0') {
        docRef.set({
          'state' : '1',
        });
      } else if (currentState === '1') {
        document.getElementById("user_div").style.display = "none";
        document.getElementById("login_div").style.display = "none";
        document.getElementById("auth_div").style.display = "block";
      } else if (currentState === '2') {
        document.getElementById("user_div").style.display = "block";
        document.getElementById("login_div").style.display = "none";
        document.getElementById("auth_div").style.display = "none";
      } else if (currentState === '-1') {
        alert("You are not authorised to access the website");
        docRef.set({
          'state' : '0',
        });
        logout();
      }
    });


    var user = firebase.auth().currentUser;

    if(user != null){

      var email_id = user.email;
      var email = email_id;
      document.getElementById("user_para").innerHTML = "Welcome User : " + email_id;

    }

  } else {
    // No user is signed in.

    document.getElementById("user_div").style.display = "none";
    document.getElementById("login_div").style.display = "block";
    document.getElementById("auth_div").style.display = "none";

  }
});

function login(){

  var userEmail = document.getElementById("email_field").value;
  var userPass = document.getElementById("password_field").value;

  firebase.auth().signInWithEmailAndPassword(userEmail, userPass).catch(function(error) {
    // Handle Errors here.
    var errorCode = error.code;
    var errorMessage = error.message;

    window.alert("Error : " + errorMessage);

    // ...
  });

}

function logout(){
  // var email = firebase.auth().currentUser.email;
  // var db = firebase.firestore();
  // var docRef = db.collection('auth').doc(email);
  // docRef.set({
  //   'state' : '0',
  // });
  firebase.auth().signOut();
}
