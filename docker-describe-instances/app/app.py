# -*- coding: utf-8 -*-
"""
@author: thabile
"""
import datetime
import json
import boto3
from flask import Flask, render_template, jsonify
from flask_debugtoolbar import DebugToolbarExtension


aws_regions = ['eu-west-1', 'eu-central-1', 'eu-west-2', 'us-east-1', 'us-west-1']

region_used = aws_regions[0]

app = Flask(__name__)
running_instances = ""
app.debug = True
app.config['SECRET_KEY'] = '1234'
toolbar = DebugToolbarExtension(app)


# Have to put all functions at top of code because can't use main function with Flask?

def my_converter(json_object):
    '''
    Function to parse datetime field to allow converting of dictionary to JSON string
    '''
    if isinstance(json_object, datetime.datetime):
        return json_object.__str__()

def get_instances_list():
    '''
    Function to perform API call to get all instances and return subset info as 2-D array
    '''
    aws_regions = ['eu-west-1', 'eu-central-1', 'eu-west-2', 'us-east-1', 'us-west-1']

    region_used = aws_regions[0]

    try:
        client = boto3.client('ec2', region_used)
    except:
        print('Error Connecting to EC2 API endpoint, Please check your permissions')

    return list(map(
            lambda instance: [instance['Instances'][0]['InstanceId'],
                    instance['Instances'][0]['PublicIpAddress'],
                    instance['Instances'][0]['Placement']['AvailabilityZone']],
                     client.describe_instances(
                         Filters=[{'Name':'instance-state-name', 'Values':['running']}])['Reservations']))


# Routes for API

@app.route('/api/instance/<id>', methods=['GET'])
def get_instances_api(id):
    return jsonify(boto3.client('ec2', region_used).describe_instances(InstanceIds=[id]), default=my_converter)

@app.route('/api/all_instances', methods=['GET'])
def get_all_instances_api():
    return jsonify(get_instances_list())

# Routes for HTML

@app.route('/instance/<id>', methods=['GET'])
def get_instances(id):
    return render_template(
        'instance.html',
        instance_data=json.dumps(boto3.client('ec2', region_used).describe_instances(InstanceIds=[id]), default=my_converter)
    )

@app.route('/all_instances', methods=['GET'])
def get_all_instances():
    return render_template(
        'all-instances.html'
    )

@app.route('/', methods=['GET'])
def index():
    #print(json.dumps(running_instances, default = my_converter))

    return render_template(
        'index.html',
        title='Flask-Zappa',
        message='[Learning To Code]',
        region=region_used
    )

if __name__ == "__main__":
    #https://stackoverflow.com/questions/4041238/why-use-def-main

    app.run(debug=False, host='0.0.0.0', port=5000)
