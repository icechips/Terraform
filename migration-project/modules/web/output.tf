#output instance ids only for webservers
output "web_server_ids" {  
  value       = [ for x, y in aws_instance.Web_Server : y.id ]
  description = "instance id for created web servers"
}