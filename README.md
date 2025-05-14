# 📱 Tarifeni Bul (Find Your Plan)

**Tarifeni Bul** is an AI-powered mobile application designed to help users find the most suitable mobile data plans based on their historical usage. The app leverages past usage patterns and intelligent predictions to recommend plans across various telecom operators in Turkey.

---

## 🚀 Overview

Choosing the right mobile plan can be overwhelming. Users often end up overpaying or facing data shortages due to a lack of insight into their actual needs. Tarifeni Bul solves this by analyzing the last **5 months of a user’s mobile data usage** and predicting the **6th month** using a custom AI model. Based on this prediction, it suggests the most appropriate tariffs available from different telecom operators.

---

## 🔍 Features

- 🔮 **AI-Based Recommendation**  
  Press the **"Suggest for me"** button to receive a personalized mobile plan suggestion.

- 🔎 **Search Functionality**  
  Manually browse tariffs using the integrated search bar.

- 🧰 **Smart Filtering & Sorting**  
  Filter plans by price, operator, or data, and sort by preference.

- ❤️ **Favorites**  
  Save and manage your preferred plans for easy access.

- 🏷️ **Multiple Operators**  
  Compare plans from major Turkish telecom providers such as Vodafone and Türk Telekom.

- 👤 **User Profile Integration**  
  Users can log in and view suggestions tailored to their historical usage data.

---

## 🧠 How It Works

1. We gathered **6 months of mobile data** from **1000 users**.
2. The first **5 months** were used to train a machine learning model.
3. The **6th month** served as ground truth to test the model’s prediction accuracy.
4. The app now allows new users to input 5 months of past usage to receive tailored plan suggestions.

---

## 🛠 Tech Stack

- **Frontend:** Flutter  
- **Backend:** Firebase Firestore & Firebase Auth  
- **Machine Learning:** Python (AI model training), Pandas, TensorFlow, NumPy, Scikit-Learn

---

## 🧪 AI Model

The AI model predicts next-month mobile data usage using time series analysis and regression techniques. It factors in:
- Monthly GB usage
- Time-of-day patterns
- Call/SMS minutes
- Plan switching history

---

## 📸 UI Preview
![app_UI](https://github.com/user-attachments/assets/01d2cbe5-d37e-4792-a86c-bb60785b8936)

---

## 📸 Poster Design
![poster](https://github.com/user-attachments/assets/1efc770f-3c31-4b64-8f29-9af4878996ae)

---

## 📦 Future Features

- 📊 Visual usage trends for users
- 📡 Real-time operator API integration
- 👥 Family plan suggestions
- 🌐 Multilingual support

---

## 👨‍💻 Team

Developed by students at Izmir University of Economics  
- **Koray** – AI Model Development & Flutter Integration: Designed and trained the machine learning model, implemented prediction logic in the app.
- **Hilal** – UI/UX Design & Firebase Services: Created the app’s user interface, handled screen navigation, and managed Firebase Authentication & Firestore integration.
- **Murat** - Data Collection & Model Evaluation: Coordinated the collection of usage data from 1000 users, prepared datasets for training/testing, and evaluated model performance.

---

## 📄 License

This project is for academic purposes. Feel free to fork and explore, but commercial use requires permission.

---

## 💬 Contact

For any inquiries or suggestions, feel free to contact us via hilalsinemsayar@gmail.com.

