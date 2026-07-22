# How to connect to Garage via AWS cli and delete all the objects in a bucket

``` bash
export AWS_ACCESS_KEY_ID=$(pbpaste)
export AWS_SECRET_ACCESS_KEY=$(pbpaste)
export AWS_DEFAULT_REGION=us-east-1



aws --endpoint-url https://s3.blunders.me s3 ls s3://<bucket name>/

aws --endpoint-url https://s3.blunders.me s3 rm s3://<bucket name>/ --recursive

```
