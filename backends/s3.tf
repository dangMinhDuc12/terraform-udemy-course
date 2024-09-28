//Create a random_id resource named "bucket_suffix" with a byte_length of 6. This ID will be used to create a unique name for the S3 bucket
resource "random_id" "bucket_suffix" {
  byte_length = 6
}

//Create an aws_s3_bucket resource named "example_bucket". Use interpolation to create a unique bucket name by appending the random ID to "example-bucket-"

resource "aws_s3_bucket" "example_bucket" {
  bucket = "example-bucket-${random_id.bucket_suffix.hex}"
}

//Create an aws_s3_bucket resource named "ap-southest-1-bucket". Use interpolation to create a unique bucket name by appending the random ID to "ap-southest-1-bucket-"
resource "aws_s3_bucket" "ap-southest-1-bucket" {
  bucket = "ap-southest-1-bucket-${random_id.bucket_suffix.hex}"
}

//Create an aws_s3_bucket resource named "ap-southest-2-bucket". Use interpolation to create a unique bucket name by appending the random ID to "ap-southest-2-bucket-"
resource "aws_s3_bucket" "ap-southest-2-bucket" {
  bucket   = "ap-southest-2-bucket-${random_id.bucket_suffix.hex}"
  provider = aws.another-region //Use the "another-region" provider alias to create the bucket in the "ap-southest-2" region
}


// Finally, use an output block to output the name of the created bucket.
output "bucket_name" {
  value = aws_s3_bucket.example_bucket.bucket
}
