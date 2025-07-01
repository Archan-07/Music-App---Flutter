from fastapi import HTTPException, Header
import jwt

def auth_middleware(x_auth_token = Header()):
    try:
            # get the user tokens from the headers
        if not x_auth_token:
            raise HTTPException(401,'No auth token, Access denied!')
        # decode the token  
        verified_token = jwt.decode(x_auth_token, 'password_key',algorithms=['HS256'])
        print(f"verified_token {verified_token}")
        if not verified_token:
            raise HTTPException(401, 'Token verification failed, Authorization denied')
        # get the id from the token
        uid = verified_token.get('id')
        return {'uid' : uid, 'token' : x_auth_token}
    except jwt.PyJWTError:
        raise HTTPException(401, "Token is not valid, Authorization failed")