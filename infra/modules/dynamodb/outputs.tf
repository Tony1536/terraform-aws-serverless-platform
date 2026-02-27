output "table_name" {
  value = aws_dynamodb_table.table_db.name
}
output "table_arn" {
  value = aws_dynamodb_table.table_db.arn
}