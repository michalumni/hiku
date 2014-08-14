
import requests, datetime, hashlib, calendar, json, os, logging, urllib
from flask import Flask, session, render_template, request, redirect, url_for
from flask.ext.login import login_user , logout_user , current_user , login_required

app = Flask(__name__)
app.secret_key = '\xde\x81e\xf8D$o\xb5\x1e!\xafU\xdb\x1bf\xac\x9fn\xcf\xd5\xee\xe1\xd5\x02'
#salt = 'myrandomtestsalt2938492'


def getPayload():
	mydate = str(datetime.datetime.utcnow())
	appId = 'e2a01662323845bf5b289b90f4c67dbae982d65247f235'
	secret = '18f9d67455211c636e'

	hashObject = hashlib.sha256(appId + secret + mydate)
	payload = {'app_id':appId, 'time':mydate, 'sig': hashObject.hexdigest()}

	return payload


# @app.after_request
# def nocache(response):
# 	response.headers['Cache-Control'] = 'no-cache'
# 	response.headers['Pragma'] = 'no-cache'
# 	return response

@app.before_first_request
def setup_logging():
	logging.basicConfig(filename='error.log', level=logging.DEBUG)
	
@app.route('/')
def index():
	return render_template('index.html')


@app.route('/item/<mydata>', methods=['GET'])
def itemHandler(mydata):
	
	if 'token' not in session:
		return render_template('index.html', error='Not logged in')
	payload = getPayload()

	r = requests.get("https://hiku-staging.herokuapp.com/api/v1/list", params=payload, data={'token':session['token']})
	jsons = r.json()
	if jsons['response']['status'] == 'error':
		return render_template('list.html', error=jsons['response']['errMsg'])
	else:
		mydict = {}
		myList = jsons['response']['data']['list'] 
		for items in myList:    
			app.logger.error(items['product_id'])

			if mydata == str(items['product_id']):
				return render_template('dataList.html', myitems=items)

		myList = jsons['response']['data']['regulars']
		for items in myList:
			if mydata == str(items['product_id']):
				return render_template('dataList.html', myitems=items)


		return mydata







		





@app.route('/list', methods=['GET'])
def list():
	if 'token' not in session:
		return render_template('index.html', error='Not logged in')
	payload = getPayload()

	r = requests.get("https://hiku-staging.herokuapp.com/api/v1/list", params=payload, data={'token':session['token']})
	jsons = r.json()
	if jsons['response']['status'] == 'error':
		return render_template('list.html', error=jsons['response']['errMsg'])
	else:
		mydict = {}
		myList = jsons['response']['data']['list'] 
		
		for items in myList:

			mydict[items['name']] = items['product_id']

		
		myList = jsons['response']['data']['regulars']
		for items in myList:
			mydict[items['name']] = items['product_id']


		return render_template('list.html', items=mydict)




		#return str(finalList)

@app.route('/login', methods=['GET', 'POST'])
def login(): 
	if request.method == 'POST':
		payload = getPayload()
		myData = {'email':request.form['email']
		, 'password':request.form['password']}
		r = requests.post("https://hiku-staging.herokuapp.com/api/v1/login", params=payload, data=myData)
		if r.status_code != 200:
			return render_template('login.html' ,error='Request status ' + str(r.status_code))
		else:
			jsons = r.json()
			if jsons['response']['status'] == 'error':
				return render_template('login.html', error=jsons['response']['errMsg'])
			elif jsons['response']['status'] == 'ok':
				session['token'] = jsons['response']['data']['token']
				return redirect(url_for('index'))
			else:
				return render_template('login.html', error='Unknown status from server')

	else:
		return render_template('login.html')





@app.route('/logout')
def logout():
    # remove the username from the session if it's there
    if 'token' in session:
    	payload = getPayload()
    	r = requests.post("https://hiku-staging.herokuapp.com/api/v1/logout", params=payload, data={'token':session['token']})
    	session.pop('token', None)
    return redirect(url_for('index'))




if __name__ == '__main__':
    app.run()


#print r.text
