var config = {
	database: {
		host:	  'symbiosis-dev-rds.convcoagflye.ap-southeast-1.rds.amazonaws.com', 	// database host
		user: 	  'root', 		// your database username
		password: 'rootingforu', 		// your database password
		port: 	  3306, 		// default MySQL port
		db: 	  'app' 		// your database name
	},
	server: {
		host: '127.0.0.1',
		port: '3000'
	},
	auth: {
		username: 'test',
		password: 'test123'
	}
}

module.exports = config
