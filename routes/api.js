var basicAuth = require('express-basic-auth')
var express = require('express')
var config = require('../config')
var app = express()

var username = config.auth.username
var password = config.auth.password
app.use(basicAuth({
    users: {
        [username]: password
    }
}))

app.get('/', function(req, res, next) {
	req.getConnection(function(error, conn) {
		conn.query('SELECT * FROM users ORDER BY id DESC',function(err, rows, fields) {
			//if(err) throw err
			if (err) {
				res.json({
					status: 500
				});
			} else {
                res.status(404)
                res.end()
			}
		})
	})
})

// RETURN LIST OF USERS JSON
app.get('/users', function(req, res, next) {
	req.getConnection(function(error, conn) {
		conn.query('SELECT * FROM users ORDER BY id DESC',function(err, rows, fields) {
			//if(err) throw err
			if (err) {
				res.json({
					status: 500
				});
			} else {
				res.json({
                    results: JSON.parse(JSON.stringify(rows))
				});
			}
		})
	})
})

module.exports = app