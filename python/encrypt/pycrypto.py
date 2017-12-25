#!/usr/bin/env python
#for python2.6&2.7
#the decrypted files make have error in first line 
from Crypto.Hash import MD5
from Crypto.Cipher import AES
from Crypto import Random
from datetime import datetime
import os,sys
reload(sys)
sys.setdefaultencoding('utf-8')

def secret_do(files,key,secret):
    t=file(files)
    text=t.read()
    t.close()
    keys=MD5.new()
    keys.update(key)
    keys=keys.hexdigest()
    
    iv=Random.new().read(AES.block_size)
    cipher=AES.new(keys,AES.MODE_CFB,iv)
    
    if secret == 1:
        ciphertext=cipher.encrypt(text)
	f=file('secret.txt','w')
	f.write(ciphertext)
	f.close()
    if secret == 0:
        decipher=AES.new(keys,AES.MODE_CFB,iv)
        deciphertext=decipher.decrypt(text)
        f=file('config.txt','w')
        f.write(deciphertext)
        f.close()

#secret_do("config.py","ufddfe646ffd1c89",secret=1)
secret_do("secret.txt","ufddfe646ffd1c89",secret=0)
