output "staging_instance_id" {
  description = "ID of the staging EC2 instance"
  value       = module.ec2_staging.instance_id
}