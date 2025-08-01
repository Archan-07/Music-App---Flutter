from sqlalchemy import TEXT, Column, ForeignKey
from models.Base import Base
from sqlalchemy.orm import relationship

class Favorite(Base):
    __tablename__ = "favorites"
    id = Column(TEXT,primary_key= True)
    song_id = Column(TEXT, ForeignKey("songs.id"))
    user_id = Column(TEXT, ForeignKey("users.id"))
    song = relationship('SongModel')
    user = relationship('UserTable',back_populates='favorite')