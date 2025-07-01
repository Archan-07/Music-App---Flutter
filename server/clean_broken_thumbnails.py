import requests
from sqlalchemy.orm import Session
from models.song import SongModel
from database import get_db

def clean_broken_thumbnails(db: Session):
    songs = db.query(SongModel).all()
    for song in songs:
        response = requests.head(song.thumbnail_url)
        if response.status_code == 404:
            print(f"Deleting song with broken thumbnail: {song.song_name}")
            db.delete(song)
    db.commit()
