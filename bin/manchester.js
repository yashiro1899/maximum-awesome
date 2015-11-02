/*property
    HOME, Server, connect, createReadStream, createServer, css,
    env, error, extname, filepath, headers, host, hostname, html,
    join, js, json, keys, length, listen, method, on, parse,
    path, pathname, pipe, port, request, size, stack, statSync,
    statusCode, url, write, writeHead
*/

'use strict';
const fs = require('fs');
const http = require('http');
const path = require('path');
const net = require('net');
const url = require('url');

const MIME = {
    css: 'text/css',
    html: 'text/html',
    js: 'application/javascript',
    json: 'application/json'
};

var server = http.createServer(function (req, res) {
    var parsedURL = url.parse(req.url);
    var configs = require(path.join(process.env.HOME, '.manchester.json'));
    var prefixes = Object.keys(configs);

    var i = 0,
        l = prefixes.length;
    var prefix, conf, stat, headers;
    while (i < l) {
        prefix = prefixes[i];
        if (parsedURL.hostname + parsedURL.pathname === prefix) {
            conf = configs[prefix];
            stat = fs.statSync(conf.filepath);

            headers = conf.headers || {};
            headers['Content-Length'] = stat.size;
            headers.Server = 'Manchester';
            if (headers['Content-Type'] === undefined) {
                headers['Content-Type'] = MIME[path.extname(conf.filepath)];
            }

            res.writeHead(200, headers);
            fs.createReadStream(conf.filepath)
                .pipe(res);
            return null;
        }

        i += 1;
    }

    var proxyReq = http.request({
        host    : parsedURL.hostname,
        port    : parsedURL.port,
        method  : req.method,
        path    : parsedURL.path,
        headers : req.headers
    });

    proxyReq.on('response', function (proxyRes) {
        res.writeHead(proxyRes.statusCode, proxyRes.headers);
        proxyRes.pipe(res);
    });
    proxyReq.on('error', function (err) {
        console.error('\x1b[31m[proxy]\x1b[0m\n%s', err.stack);
    });
    req.pipe(proxyReq);
});

server.listen(8122);
server.on('clientError', function (err) {
    console.error('\x1b[31m[client]\x1b[0m\n%s', err.stack);
});

// directly forward https request
server.on('connect', function (req, socket, head) {
    var parsedURL = url.parse('https://' + req.url);

    var proxySocket = net.connect(parsedURL.port, parsedURL.hostname, function () {
        socket.write('HTTP/1.1 200 Connection Established\r\n\r\n');

        this.write(head);
        this.pipe(socket);
        socket.pipe(this);
    });

    proxySocket.on('error', function (err) {
        console.error('\x1b[31m[https]\x1b[0m\n%s', err.stack);
    });
});

// directly forward websocket
server.on('upgrade', function (ignore, socket) {
    socket.write('HTTP/1.1 101 Web Socket Protocol Handshake\r\n' +
        'Upgrade: WebSocket\r\n' +
        'Connection: Upgrade\r\n\r\n');

    socket.pipe(socket);
});
