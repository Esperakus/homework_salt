output "external_ip_address_lb" {
  value = yandex_lb_network_load_balancer.lb01.listener.*
}

output "external_ip_address_salt-main" {
  value = yandex_compute_instance.salt-main.*.network_interface.0.nat_ip_address
}

output "internal_ip_address_nginx" {
  value = yandex_compute_instance.nginx.*.network_interface.0.ip_address
}

output "internal_ip_address_backend" {
  value = yandex_compute_instance.backend.*.network_interface.0.ip_address
}

output "internal_ip_address_db" {
  value = yandex_compute_instance.db.*.network_interface.0.ip_address
}

