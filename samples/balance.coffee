#! /usr/bin/env coffee

# Required modules

FS = require('fs')
YaMoney = require('..')

# Read token file pointed in CLI args

tokenPath = process.argv[2]
token = JSON.parse(FS.readFileSync(tokenPath, encoding: 'utf-8')).access_token

# Create client and invoke necessary methods

client = new YaMoney.Client(token)

client.accountInfo(callback: (error, data) ->
	unless error? then console.log(data) else console.log(error)

	undefined
)
