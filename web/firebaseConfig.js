// Import the functions you need from the SDKs you need
import { initializeApp } from "firebase/app";
import { getAnalytics } from "firebase/analytics";
// TODO: Add SDKs for Firebase products that you want to use
// https://firebase.google.com/docs/web/setup#available-libraries

// Your web app's Firebase configuration
// For Firebase JS SDK v7.20.0 and later, measurementId is optional
const firebaseConfig = {
  apiKey: "AIzaSyCiN5SXIkB4MJQK6k6qyh5j3CZSzhJKehI",
  authDomain: "sangmokchoipp.firebaseapp.com",
  projectId: "sangmokchoipp",
  storageBucket: "sangmokchoipp.appspot.com",
  messagingSenderId: "924504272719",
  appId: "1:924504272719:web:9ff71c7bf90e7c891b5f3a",
  measurementId: "G-6024109F9M"
};

// Initialize Firebase
const app = initializeApp(firebaseConfig);
const analytics = getAnalytics(app);