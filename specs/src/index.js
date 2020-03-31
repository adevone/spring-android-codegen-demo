import SwaggerUI from 'swagger-ui'
// import SwaggerUIBundle from 'swagger-ui'

function restoreHeaderIfNeeded (headerName, request) {
    if (request.headers.companyKey != null) {
        window.localStorage.setItem(headerName, request.headers.companyKey)
    } else {
        request.headers[headerName] = window.localStorage.getItem(headerName)
    }
}

// let json = require('../specs/client.json')
let json = require('../specs/panel.json')

console.log(json)

json.servers[0].variables.server.default = 'http://localhost:8080'

SwaggerUI({
    spec: json,
    // url: "/specs/client.json",
    // urls: [ { name: "client", url: "/specs/client.json"}, { name: "panel", url: "/specs/panel.json" } ],
    dom_id: '#app',
    displayOperationId: true,
    requestInterceptor: function (request) {
        if (request.url !== 'specs/client.json') {
            restoreHeaderIfNeeded('companyKey', request)
            restoreHeaderIfNeeded('device', request)
            restoreHeaderIfNeeded('deviceOs', request)
            restoreHeaderIfNeeded('apiVersion', request)
        }
        return request
    }
})

debugger