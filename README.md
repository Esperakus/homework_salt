# Домашняя работа "Salt"

Цель работы - настроить управление проектом из предыдущих ДЗ с помощью Salt.



Схема проекта:

![scheme](https://github.com/Esperakus/homework_salt/blob/main/pics/scheme.png)

Порядок разворачивания проекта:

1. С помощью манифестов terraform в облаке Яндекс создаются виртуальные машины:
   - 2 ВМ с nginx 
   - 2 ВМ c приложением бэкенда
   - 1 ВМ с postgresql
   - 1 ВМ с salt-master

2. С помощью Ansible на все ВМ устанавливается служба salt-minion. Больше Ansible в работе проекта не участвует.
3. Внутри манифеста salt-host.tf есть команды, с помощью которых производится настройка salt-master, импорт ключей миньонов и запуск state.apply.
4. После того, как все манифесты отработают получаем требуемую структуру проекта с установленными и настроенными ролями виртуальных машин.

Для разворачивания проекта необходимо:

1. Заполнить значение переменных cloud_id, folder_id и iam-token в файле **variables.tf**.

2. Инициализировать рабочую среду Terraform:

```
$ terraform init
```
В результате будет установлен провайдер для подключения к облаку Яндекс.

3. Запустить разворачивание:
```
$ terraform apply
```
По окончании разворачивания в выходных данных будут показаны все внешние и внутренни ip адреса. 

```
# Пример вывода terraform apply:

Apply complete! Resources: 16 added, 0 changed, 0 destroyed.

Outputs:

external_ip_address_lb = tolist([
  {
    "external_address_spec" = toset([
      {
        "address" = "158.160.132.140"
        "ip_version" = "ipv4"
      },
    ])
    "internal_address_spec" = toset([])
    "name" = "listener01"
    "port" = 80
    "protocol" = "tcp"
    "target_port" = 80
  },
])
external_ip_address_salt-main = [
  "158.160.58.194",
]
internal_ip_address_backend = [
  "192.168.100.4",
  "192.168.100.6",
]
internal_ip_address_db = [
  "192.168.100.25",
]
internal_ip_address_nginx = [
  "192.168.100.18",
  "192.168.100.8",
]
```

Для проверки результатов работы необходимо в браузере открыть внешний адрес балансировщика Яндекс облака (http://{{external_ip_address_lb}}, http://{{external_ip_address_lb}}/db, http://{{external_ip_address_lb}}/image)

Примеры того как выглядит запрос к проекту из браузера:
![salt_result1](https://github.com/Esperakus/homework_salt/blob/main/pics/pic1.png)
![salt_result2](https://github.com/Esperakus/homework_salt/blob/main/pics/pic2.png)
![salt_result3](https://github.com/Esperakus/homework_salt/blob/main/pics/pic3.png)

