# Konesta-Terraform-Assessment
For statefile locking production best practices,I strongly recommend using an S3 to store the statefile with all necessary securities in place such as version, mfa delete etc. and the lockID should be locked using DynamoDB.
As a production grade VPC I will also recommend building the VPC in aModule so it can be useable  across different environments.
