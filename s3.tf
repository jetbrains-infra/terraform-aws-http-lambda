resource "random_pet" "key" {
  length = 1
  prefix = "lambda_"
}

resource "aws_s3_bucket_object" "lambda" {
  key      = random_pet.key.id
  bucket   = local.bucket
  source   = local.lambda_archive
  etag     = filemd5(local.lambda_archive)
}
