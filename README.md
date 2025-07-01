# 🎵 Music App - Flutter & FastAPI
A full-stack MVVM based music application built with Flutter for the frontend and FastAPI (Python) for the backend. This app provides a complete music streaming experience with user authentication, song management, and favorites functionality.
# 📱 Features
Client (Flutter App)

🎵 Music streaming and playback
🔐 User authentication (login/signup)
❤️ Favorite songs management
🏠 Home dashboard with music discovery
🎨 Modern UI with custom themes
📱 Cross-platform support (iOS, Android, Web, Desktop)

Server (FastAPI Backend)

🚀 High-performance FastAPI backend
🔒 JWT-based authentication middleware
🗄️ Database integration with Pydantic schemas
📊 User management and song data handling
☁️ Cloudinary integration for music file storage
🎵 Music streaming and metadata management
🔄 RESTful API endpoints

# 🏗️ Project Structure
Music-App--Flutter/
├── client/                 # Flutter Frontend
│   ├── lib/
│   │   ├── core/          # Core utilities and constants
│   │   ├── features/      # Feature-based architecture
│   │   │   ├── auth/      # Authentication feature
│   │   │   └── home/      # Home/Dashboard feature
│   │   ├── main.dart      # App entry point
│   │   └── ...
│   └── pubspec.yaml       # Flutter dependencies
│
└── server/                # Python FastAPI Backend
    ├── middleware/        # Custom middleware
    ├── models/           # Pydantic data models
    ├── pydantic_schemas/ # API schemas
    ├── routes/           # API route handlers
    ├── venv2/           # Python virtual environment
    ├── main.py          # FastAPI app entry point
    └── requirements.txt # Python dependencies
🚀 Getting Started
Prerequisites

Flutter SDK (>=3.0.0)
Python 3.8+
Git

Backend Setup (FastAPI Server)

Navigate to server directory:
bashcd server

Create and activate virtual environment:
bashpython -m venv venv2
# On Windows
venv2\Scripts\activate
# On macOS/Linux
source venv2/bin/activate

Install Python dependencies:
bashpip install -r requirements.txt
Key dependencies include:

FastAPI
Uvicorn
Cloudinary
Pydantic
JWT authentication libraries


Run the FastAPI server:
bashpython main.py
The server will start at http://localhost:8000

Frontend Setup (Flutter Client)

Navigate to client directory:
bashcd client

Install Flutter dependencies:
bashflutter pub get

Run the Flutter app:
bashflutter run


🛠️ Development
Backend Development

The FastAPI server includes automatic API documentation at /docs
JWT authentication middleware for secure endpoints
Cloudinary integration for media file storage and delivery
Pydantic schemas for data validation
Modular route structure for easy maintenance

Cloudinary Configuration (routes/song.py):
pythonimport cloudinary
import cloudinary.uploader

cloudinary.config( 
    cloud_name = "your_cloud_name", 
    api_key = "your_api_key", 
    api_secret = "your_api_secret",
    secure=True
)
Frontend Development

Feature-based architecture for scalability
Riverpod pattern for state management
Custom themes and widgets
Responsive design for multiple platforms

📖 API Documentation
Once the server is running, visit http://localhost:8000/docs for interactive API documentation powered by Swagger UI.
Key Endpoints

POST /auth/login - User authentication
POST /songs/upload - Upload songs to Cloudinary
GET /songs - Get all songs with Cloudinary URLs
POST /favorites - Add to favorites
GET /user/profile - Get user profile

🔧 Configuration
Environment Variables
Create a .env file in the server directory:
env# Server Configuration
SECRET_KEY=your-secret-key
DATABASE_URL=your-database-url
JWT_ALGORITHM=HS256
ACCESS_TOKEN_EXPIRE_MINUTES=30

# Cloudinary Configuration
CLOUDINARY_CLOUD_NAME=your-cloud-name
CLOUDINARY_API_KEY=your-api-key
CLOUDINARY_API_SECRET=your-api-secret
📱 Supported Platforms

✅ Android
✅ iOS
✅ Web
✅ Windows
✅ macOS
✅ Linux
