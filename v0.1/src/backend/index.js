var md5 = require('md5')
var express = require('express')
app = express()
const port = 3000
app.listen(port)

console.log('Backend rest server starting...')

app.get('/', function(req, res) {
    res.send('Landing page for backend.')
})