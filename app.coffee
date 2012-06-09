http = require "http"
fs = require "fs"
qs = require "querystring"
config = JSON.parse fs.readFileSync "config.json"
exec = require( "child_process" ).exec


http.createServer ( req, res )->
	if req.method isnt "POST"
		res.writeHead 400
		res.write "Can't handle this request"
		return res.end()

	postData = ""
	req.on "data", ( data )->
		postData += data;

	req.on "end", ->
		data = qs.parse postData
		payload = null
		try
			payload = JSON.parse data.payload
		catch x
			console.error x, data
		
		unless payload
			return res.end "no payload"
	
		thisConfig = config[ payload.repository.name ]
		unless thisConfig
			return res.end "no config"

		command = ""

		command += "pushd #{thisConfig.directory}; git pull origin;"

		if thisConfig.postCommand
			command += "#{thisConfig.postCommand};"
		
		command += "popd"

		if thisConfig.user
                        command = "su - #{thisConfig.user} -c \"#{command}\""
		console.log "[command]", command

		exec command, ( err, stdout, stderr )->
			console.log "[command-finished]", err, stdout, stderr
			res.write "ok"
.listen config.server.port 
