from flask import Flask, render_template,request
from app import app


@app.route('/')
@app.route('/index')
def index():
	return render_template("index.html")

@app.route('/about')
def about():
	return render_template("about.html")

@app.route('/code')
def code():
	return render_template("code.html")

@app.route('/documentation')
def documentation():
	return render_template("documentation.html")

@app.route('/<string:page_name>/')
def render_static(page_name):
    return render_template('%s.html' % page_name)