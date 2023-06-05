var express = require('express');
var app = require('express')();
const path = require('path')
var server = require('http').Server(app);
var io = require('socket.io')(server);

var allUsers = [];



app.use(express.static(path.join(__dirname,'web')));

function emitUsers() {
    io.emit('users',allUsers);    
    console.log('users',allUsers);
}
function removeUser(user) {
    allUsers= allUsers.filter(function(ele){ 
        return ele != user; 
    });   
}


io.on('connection', function (socket) {
    var userName = socket.request._query.userName;
    allUsers.push(userName);
    emitUsers();
    var msg = `🔥👤 ${userName} juntou-se a nós! 😎`;
    console.log(msg)


    io.emit('message', {
        "message": msg
    }
    );
    socket.on('disconnect', () => {       
      
        var disMsg = `${userName} se desconectou! 😭`;
        console.log(disMsg);
        io.emit('message', {
            "message": disMsg,
        });
        removeUser(userName);
        emitUsers()
    });

    socket.on('message', (data) => {
        console.log(`👤 ${data.userName} : ${data.message}`)
        io.emit('message', data);
    });



});



const PORT = 8080;

server.listen(PORT,'0.0.0.0',()=>{
    console.log('Server up and running at',PORT);
});