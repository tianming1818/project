#!/usr/bin/env python
#coding:utf8

import os,time
import MySQLdb,redis

from flask import Flask, request, session, g, redirect, url_for, abort, \
     render_template, flash

app = Flask(__name__)
app.config.update(dict(
    DATABASE='flasker',
    DEBUG=True,
    SECRET_KEY='development key',
    USERNAME='admin',
    PASSWORD='admin'
))


def connect_db():
	conn=MySQLdb.connect(host='127.0.0.1',user='root',passwd='nbs2o13',db=app.config['DATABASE'],port=3306)
        cur=conn.cursor()
	#a=cur.fetchall() 
	return cur

def init_db():
	cur=connect_db()
	#cur.execute('use flaskr;')
	del_table="drop table if exists blog;"
	cre_table="create table blog (   id int(5) not null primary key auto_increment,  title VARCHAR(10) not null, texts TEXT not null);"
	if not cur.execute('show tables;'):
		cur.execute(cre_table)
		#cur.commit()

def connect_redis():
	r = redis.Redis(host='192.168.2.130', port=6379, db=1)
	return r

def close_db():
	cur=connect_db()
	cur.close()


#@app.cli.command('initdb')
#def initdb_command():
#    """Creates the database tables."""
#    init_db()
#    print('Initialized the database.')


@app.route('/')
def hello_world():
        flash('hello jikexueyuan')
        return render_template("index.html")

@app.route('/show_blog')
def show_blog():
    db = connect_db()
    cur = db.execute('select title,texts from blog order by id desc')
    entries = db.fetchall()
    r=connect_redis()
    k=r.keys()
    v=[]
    for i in k:
        v.append(r.get(i))
    return render_template('show_blog.html', k=k, v=v, entries=entries)

@app.route('/login',methods=['POST'])
def login():
        form = request.form
        username = form.get('username')
        password = form.get('password')
        if not username:
                flash("please input username")
                return render_template('index.html')

        if not password:
                flash('please input password')
                return render_template('index.html')
        if username == app.config['USERNAME'] and password == app.config['PASSWORD']:
		session['logged_in'] = True
                flash('Login is success')
                return redirect(url_for('show_blog'))
        else:
                flash('Username or Password Error')
                return render_template('index.html')


@app.route('/add_redis', methods=['POST'])
def add_redis():
    form = request.form
    title = form.get('title')
    content = form.get('text')
    red=connect_redis()
    red.set(title,content)
    flash('Redis data was successfully posted')
    return redirect(url_for('show_blog'))

@app.route('/add', methods=['POST'])
def add_entry():
    form = request.form
    title = form.get('title')
    content = form.get('text')
    if not session.get('logged_in'):
        abort(401)
    db = connect_db()
    db.execute("insert into blog (title, texts) values ('{0}', '{1}')".format(title, content))
    #db.commit()
    flash('New entry was successfully posted')
    return redirect(url_for('show_blog'))

@app.route('/modify', methods=['POST'])
def modify():
	form = request.form
	title = form.get('title')
	content = form.get('text')
	db = connect_db()
	db.execute("update blog set texts='{0}' where title='{1}';".format(content,title))
	return redirect(url_for('show_blog'))


@app.route('/del', methods=['POST'])
def del_blog():
	form = request.form
	title = form.get('title')	
	db = connect_db()
	db.execute("delete from blog where title='{0}'".format(title))
	flash('Del blog was successfully posted')
	return redirect(url_for('show_blog'))

@app.route('/del_redis', methods=['POST'])
def del_redis():
        form = request.form
        title = form.get('title')
        r=connect_redis()
	r.delete(title)
        flash('Del redis was successfully posted')
        return redirect(url_for('show_blog'))

if __name__=='__main__':
        app.run(host='0.0.0.0')
