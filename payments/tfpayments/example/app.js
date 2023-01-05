var http = require('http'); 
var fs = require('fs');
var url = require('url');

// backend server
http.createServer(function (req, res) {

    post_data = JSON.stringify({
        success_url: 'localhost:8080/success',
        cancel_url: 'localhost:8080/cancel',
        twin_id: 414
    })

    var q = url.parse(req.url, true);
    // serve index.html
    console.log(q.pathname)
    if (q.pathname == '/') {
        fs.readFile('index.html', function(err, data) {
            res.writeHead(200, {'Content-Type': 'text/html'});
            res.write(data);
            return res.end();
        });
    }

    // mastadon checkout proxy
    else if (q.pathname == '/mastadon_checkout') {
        console.log('posting')

        // An object of options to indicate where to post to
        var post_options = {
            host: 'localhost',
            port: '4242',
            path: '/create_mastadon_session',
            method: 'POST',
            headers: {
                'Content-Type': 'application/x-www-form-urlencoded',
                'Content-Length': Buffer.byteLength(post_data)
            }
        };

        request = http.request(post_options, (response)=> {
            var str = '';
  
            //another chunk of data has been received, so append it to `str`
            response.on('data', function (chunk) {
            str += chunk;
            });
        
            //respond with redirect to mastadon checkout session url
            response.on('end', function () {
                res.writeHead(301, { Location: str });
                res.end();
            });

        })
        
        request.write(post_data);
        request.end();

    }

    else {
        res.writeHead(404, {'Content-Type': 'text/html'});
        return res.end("404 Not Found");
    }
    
}).listen(8080); 

// function for creating mastadon checkout session from tfpayment api
// and redirecting to checkout page
function createMastadonCheckout() {

    console.log('here')

    // request session creation from api
    var options = {
        host: 'http://localhost:4242',
        path: '/test'
    };

    const checkoutUrl = http.request(options, callback).end();
    console.log('Received mastadon checkout session url:', checkoutUrl);
    return checkoutUrl
}


callback = function(response) {
    
  }
  