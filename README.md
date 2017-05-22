# dynamodb-local

Local DynamoDB server for development

## Usage

Simply run with no command params, then show help messages.

`docker run --rm sprocket/dynamodb-local`

You can set command params like below.

`docker run -d --name dynamodb-local -p 8000:8000 sprocket/dynamodb-local -sharedDb`
