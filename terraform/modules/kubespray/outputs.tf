output "kubespray_inventory_file" {
  value       = local_file.kubespray_inventory.filename
  description = "Path to the generated kubespray inventory file"
}
