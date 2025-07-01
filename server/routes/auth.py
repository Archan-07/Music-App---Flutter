import uuid
import bcrypt
from fastapi import Depends, HTTPException, Header
from database import get_db
from middleware.auth_middleware import auth_middleware
from models.favorite import Favorite
from models.user import UserTable
from pydantic_schemas.user_create import UserCreate
from sqlalchemy.orm import joinedload
from fastapi import APIRouter
from sqlalchemy.orm import Session
from pydantic_schemas.user_login import UserLogin
import jwt

router = APIRouter()

@router.post('/signup' , status_code = 201)
def signup_user(user:UserCreate,db : Session = Depends(get_db)):

    #extract the data coming from database
    print(user.name)
    print(user.email)
    print(user.password)


    #check if the user already exists in db

    user_db = db.query(UserTable).filter(UserTable.email == user.email).first()

    if user_db:
        raise HTTPException(400,"User with the same email already exists!")
    import pdb;pdb.set_trace()
    hashed_pw = bcrypt.hashpw(user.password.encode(),bcrypt.gensalt())
    user_db = UserTable(id = str(uuid.uuid4()), email = user.email, name = user.name, password = hashed_pw)
    print(user_db.password)

    db.add(user_db)
    db.commit()
    db.refresh(user_db)


    return user_db


@router.post('/login')
def login_user(user : UserLogin, db : Session = Depends(get_db)):
    # check if the user with the same email already exists
    
    user_db = db.query(UserTable).filter(UserTable.email == user.email).first()
    if not user_db:
        raise HTTPException(400,"User with this email does not exists")

    # password matching
    # import pdb;pdb.set_trace()

    is_match = bcrypt.checkpw(user.password.encode(), user_db.password)

    if not is_match:
        raise HTTPException(400, "Incorrect Password")

    auth_token = jwt.encode({'id' : user_db.id,},'password_key',algorithm='HS256')
    
    return {'token' : auth_token,'user' : user_db}


@router.get('/')
def currentUserData(db : Session = Depends(get_db),user_dict = Depends(auth_middleware)):
    user = db.query(UserTable).filter(UserTable.id == user_dict['uid']).options(
        joinedload(UserTable.favorite)
        ).first()
    if not user:
        raise HTTPException(404,"User not found!")
    return user
    

