from flask import Flask, request

from twilio.rest import Client

app = Flask(__name__)
 
# put your own credentials here 
ACCOUNT_SID = 'ACa7f7b3027959be47d17aebc5c2c607ce' 
AUTH_TOKEN = 'f859d4609902e4f46334cb43c5b6853a' 
 
client = Client(ACCOUNT_SID, AUTH_TOKEN)
 
@app.route('/sms', methods=['POST'])
def send_sms():
    message = client.messages.create(
        to=request.form['To'],
        from_='+12819496761', 
        body=request.form['Body'],
    )

    return message.sid

if __name__ == '__main__':
        app.run()
