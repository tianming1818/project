# * coding: utf-8 *
from cryptography.fernet import Fernet
from cryptography.hazmat.backends import default_backend
from cryptography.hazmat.primitives import hashes
from cryptography.hazmat.primitives.kdf.pbkdf2 import PBKDF2HMAC
import base64,os
import pickle,hashlib



def secret_do(files, key, secret):
    password=bytes(key, encoding="utf-8")
    #16bit string
    salt = b"qwertyuioplkjhgf"
    kdf = PBKDF2HMAC(algorithm=hashes.SHA256(),length=32,salt=salt,iterations=100000,backend=default_backend())
    jey = base64.urlsafe_b64encode(kdf.derive(password))
    key = Fernet(jey)
    if secret == 1:
        t = open(files, 'r', encoding="utf-8")
        text = t.read()
        text = text.encode("utf-8")
        token = key.encrypt(text)
        print(token)
        f = open('secret.txt', 'wb')
        f.write(token)
        f.close()
    if secret == 0:
        text = open(files, 'rb').read()
        print(text)
        source_str = key.decrypt(text)
        source_str = source_str.decode("utf-8")
        f = open('config2.py', 'w', encoding="utf-8")
        f.write(source_str)
        f.close()


secret_do("config.py","wuioejdk483yindk",secret=1)
secret_do("secret.txt", "wuioejdk483yindk", secret=0)
