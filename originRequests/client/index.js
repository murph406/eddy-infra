'use strict'

exports.handler = (event, context, callback) => {
  const request = event.Records[0].cf.request
  const headers = request.headers
  const origin = request.origin

  console.log('S3 Origin Header: ', JSON.stringify(headers['s3-origin']))

  // Set the host and origin S3 to the s3-origin header passed from the viewerRequest lambda.
  if (headers['s3-origin']) {
    headers['host'] = JSON.parse(JSON.stringify(headers['s3-origin'])) // Prevents reassignment of the s3-origin header.
    headers['host'][0].key = 'host'

    origin.s3.domainName = headers['s3-origin'][0].value
  }

  origin.s3.region = 'us-east-1'

  console.log('Request URI: ', request.uri)

  if (request.uri.indexOf('.') === -1) {
    request.uri = '/index.html'
  }

  console.log(headers, request)

  callback(null, request)
}