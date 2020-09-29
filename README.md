## About

Terraform module to run an HTTP application hosted by the AWS Lambda service. 

Features:
* DNS record (Route53)
* TLS certificate (ACM)
* HTTPS by the AWS CloudFront service 
* "Catch-all" configuration for the AWS API Gateway 
* Default role for the function to allow writing a log to the Cloudwatch service 

## Usage

```hcl
module "example_lambda_function" {
  source             = "github.com/jetbrains-infra/terraform-aws-http-lambda?ref=vX.X.X" // see https://github.com/jetbrains-infra/terraform-aws-http-lambda/releases
  name               = "ExampleFun"
  function_subdomain = "example-function"
  base_domain        = "example.com" // we are expecting this zone in the account
  runtime            = "java11"
  lambda_archive     = "build/example-function.jar"
  handler            = "com.example.app.Server::handleRequest"
  envvars = {
    MY_TOKEN="37087575-173c-4ce2-9381-90d398643ca8"
    SETTING_ONE="FOO"
    SETTING_TWO="bar"
  }
}
```

Default values:
```hcl
module "example_lambda_function" {
  source             = "github.com/jetbrains-infra/terraform-aws-http-lambda?ref=vX.X.X" // see https://github.com/jetbrains-infra/terraform-aws-http-lambda/releases
  name               = "ExampleFun"
  function_subdomain = "example-function"
  base_domain        = "example.com" // we are expecting this zone in the account
  runtime            = "java11"
  lambda_archive     = "../build/example-function.jar"
  handler            = "com.example.app.Server::handleRequest"
  envvars            = {}
  memory_size        = 1024
  timeout            = 60
}
```

## Outputs

* `url` - the application URL in form *https://example-function.example.com*