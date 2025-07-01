import uuid
import cloudinary
from fastapi import APIRouter, Depends, File, Form, UploadFile
from sqlalchemy.orm import Session
from database import get_db
from middleware.auth_middleware import auth_middleware
import cloudinary.uploader
from sqlalchemy.orm import joinedload
from models.favorite import Favorite
from models.song import SongModel
from pydantic_schemas.favorite_song import FavoriteSong

router = APIRouter()

cloudinary.config( 
    cloud_name = "cloud_name", 
    api_key = "your_api_key", 
    api_secret = "your_api_secret", # Click 'View API Keys' above to copy your API secret
    secure=True
)

@router.post('/upload',status_code=201)
def uploadSong(song : UploadFile = File(...),
               thumbnail : UploadFile = File(...),
               artist : str = Form(...), 
               song_name : str = Form(...),
               hex_code : str = Form(...),
               db : Session = Depends(get_db),
               auth_dict = Depends(auth_middleware)
               ):
    song_id = str(uuid.uuid4())
    song_result = cloudinary.uploader.upload(song.file,resource_type = 'auto',folder = f'songs/{song_id}')
    thumbnail_result = cloudinary.uploader.upload(thumbnail.file,resource_type = 'image',folder = f'songs/{song_id}')

    #store the data in db
    new_song = SongModel(
        id=song_id,
        song_name=song_name,
        artist=artist,
        hex_code=hex_code,
        song_url=song_result['secure_url'],           # ✅ Use secure HTTPS URL
        thumbnail_url=thumbnail_result['secure_url']  # ✅ Use secure HTTPS URL
    )

    print(song_result['secure_url'])           # ✅ Use secure HTTPS URL

    db.add(new_song)
    db.commit()
    db.refresh(new_song)
    return new_song

import requests

@router.get('/list')
def list_songs(db: Session = Depends(get_db), auth_details = Depends(auth_middleware)):
    songs = db.query(SongModel).all()
    valid_songs = []

    for song in songs:
        try:
            response = requests.head(song.thumbnail_url, timeout=2)
            if response.status_code == 200:
                valid_songs.append(song)
        except Exception as e:
            print(f"Skipping invalid thumbnail for {song.song_name}: {e}")
    
    return valid_songs


@router.post('/favorite')
def favorite_song(song : FavoriteSong,db : Session = Depends(get_db),auth_details = Depends(auth_middleware)):

    # check the song is already favorited by the user
    user_id = auth_details['uid']
    fav_song = db.query(Favorite).filter(Favorite.song_id == song.song_id, Favorite.user_id == user_id).first()

    # if it is favorited, we need to unfavorite it
    if fav_song:
        db.delete(fav_song)
        db.commit()
        return {'message' : False}
    # if not then favorite it
    else:
        new_fav = Favorite(id = str(uuid.uuid4()),song_id = song.song_id,user_id = user_id)
        db.add(new_fav)
        db.commit()
        return {'message' : True}
    
    
@router.get('/list/favorite')
def list_fav_songs(db: Session = Depends(get_db), auth_details = Depends(auth_middleware)):
   
    user_id = auth_details['uid']
    fav_song = db.query(Favorite).filter(Favorite.user_id == user_id).options(
        joinedload(Favorite.song)
    ).all()
    
    return fav_song
