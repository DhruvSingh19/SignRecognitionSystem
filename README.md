📱 Sign Language Word Recognition App
An offline Android application that recognizes words in real-time from live camera feed using Flutter and TensorFlow Lite. This app is designed to help users learn and practice sign language effectively using an interactive and engaging UI. Built with performance in mind, it eliminates the need for internet connectivity by leveraging on-device ML inference and integrates Text-to-Speech for audio feedback.

✨ Features
🔍 Real-time Word Detection
Uses your phone's camera to recognize hand signs and predict the corresponding word on the screen.

⚡ On-device Inference with TensorFlow Lite
Reduces latency and increases speed by running the trained model directly on the device without any external API or server.

🌐 Works Completely Offline
No internet connection is required for recognition — perfect for remote or low-connectivity environments.

🗣️ Text-to-Speech and Speech-to-Text Integration
Converts recognized words into speech, enhancing accessibility and learning experience.

📘 Learn Page
Visual guide to learn different sign language gestures mapped to their corresponding words.

🧠 Quiz Page
Engage in interactive quizzes to test your learning. A random image/gesture is shown and you need to select the correct word from multiple choices.

🚨 Emergency Support
  📍 Send Current Location to caregivers or emergency contacts.
  🚑 Call Ambulance with a single tap from the emergency section.


🧠 How It Works
The model is trained using Teachable Machine with labeled hand sign videos/images.

Exported as a .tflite file and integrated directly into the Flutter app using tflite_flutter.

Camera input is processed frame-by-frame and predictions are generated on-device.

Recognized word is spoken aloud using flutter_tts package.

📦 Dependencies
camera
tflite_flutter
flutter_tts
google_fonts
path_provider
image

🚀 Getting Started
Clone the Repository

git clone https://github.com/your-username/sign-language-word-recognition.git
cd sign-language-word-recognition

Install Dependencies
flutter pub get
Add Trained Model

Place your exported model.tflite file in the assets/models/ directory.

Run the App
flutter run
Make sure to use a real Android device (emulators typically don't support camera plugins well).

🛠️ To Do
 Add multiple levels to quizzes

 Improve UI with animations and transitions

 Add more gestures and words to the model

 User progress tracking

📸 Screenshots
![WhatsApp Image 2024-10-09 at 23 17 40_21f90273](https://github.com/user-attachments/assets/bdef0ab2-5419-41d0-86bf-5ede712a7c8a)

![WhatsApp Image 2024-10-09 at 23 17 40_d10bc6a0](https://github.com/user-attachments/assets/60b1129e-f810-410c-b74a-3ac1132828a8)

![WhatsApp Image 2024-10-09 at 23 17 35_95cad2a4](https://github.com/user-attachments/assets/8d49d723-3e1e-4ab1-a3a3-a432cfb47bd7

🙌 Contribution
Pull requests are welcome! If you’d like to add features or fix bugs, feel free to fork the repository and submit a PR.)
