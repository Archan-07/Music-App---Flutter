from sqlalchemy import TEXT, VARCHAR, Column, LargeBinary
from models.Base import Base
from sqlalchemy.orm import relationship

class UserTable(Base):
    __tablename__ = 'users'

    id =  Column(TEXT, primary_key=True)
    name = Column(VARCHAR(100))
    email = Column(VARCHAR(100))
    password = Column(LargeBinary)

    favorite = relationship('Favorite',back_populates='user')
