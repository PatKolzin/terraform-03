# Домашнее задание к занятию «Управляющие конструкции в коде Terraform»

### ВАЖНО! Листинг работы находится в директории SRC. На скриншотах некоторые ресурсы ВМ захардкоржены, в SRC позже они были указаны через переменные. 

### Задание 1

1. Изучите проект.
2. Заполните файл personal.auto.tfvars.
3. Инициализируйте проект, выполните код. Он выполнится, даже если доступа к preview нет.

Примечание. Если у вас не активирован preview-доступ к функционалу «Группы безопасности» в Yandex Cloud, запросите доступ у поддержки облачного провайдера. Обычно его выдают в течение 24-х часов.

Приложите скриншот входящих правил «Группы безопасности» в ЛК Yandex Cloud или скриншот отказа в предоставлении доступа к preview-версии.

### Решение 1

1. Изучил проект

2. Заполнил переменные в personal.auto.tfvars

3. Инициализировал проект и выполнил код.

Создалась сеть и подсеть с именем Develop и группа безопасности с именем ***example_dynamic*** и правилами трафика:

![2 0](https://github.com/PatKolzin/terraform-03/assets/75835363/e5df7ebb-59ac-4866-bbee-ac37cd7a4c4e)


------

### Задание 2

1. Создайте файл count-vm.tf. Опишите в нём создание двух **одинаковых** ВМ  web-1 и web-2 (не web-0 и web-1) с минимальными параметрами, используя мета-аргумент **count loop**. Назначьте ВМ созданную в первом задании группу безопасности.(как это сделать узнайте в документации провайдера yandex/compute_instance )

![2 1](https://github.com/PatKolzin/terraform-03/assets/75835363/96efd27b-0e07-418f-ae4a-62389ce72890)
![2 2](https://github.com/PatKolzin/terraform-03/assets/75835363/0f254fde-a28e-4b05-b1fe-cc9a26aeacf1)


2. Создайте файл for_each-vm.tf. Опишите в нём создание двух ВМ с именами "main" и "replica" **разных** по cpu/ram/disk , используя мета-аргумент **for_each loop**. Используйте для обеих ВМ одну общую переменную типа list(object({ vm_name=string, cpu=number, ram=number, disk=number  })). При желании внесите в переменную все возможные параметры.

![for_each](https://github.com/PatKolzin/terraform-03/assets/75835363/1aac15e3-ec7c-4bf2-90e4-2d9d959e963a)


3. ВМ из пункта 2.2 должны создаваться после создания ВМ из пункта 2.1.

``` 
     depends_on = [yandex_compute_instance.web]
```

4. Используйте функцию file в local-переменной для считывания ключа ~/.ssh/id_rsa.pub и его последующего использования в блоке metadata, взятому из ДЗ 2.

```
locals {
  ssh-keys = file("~/.ssh/id_ed25519.pub")
}
```
![image](https://github.com/PatKolzin/terraform-03/assets/75835363/96b09ac0-ad28-4c0f-bacb-6b32bf6961bf)


5. Инициализируйте проект, выполните код.


### Задание 3

1. Создайте 3 одинаковых виртуальных диска размером 1 Гб с помощью ресурса yandex_compute_disk и мета-аргумента count в файле **disk_vm.tf** .

![image](https://github.com/PatKolzin/terraform-03/assets/75835363/0d5cd5bd-8d6f-48f7-bd3b-fed9ec3ca765)

2. Создайте в том же файле **одиночную**(использовать count или for_each запрещено из-за задания №4) ВМ c именем "storage"  . Используйте блок **dynamic secondary_disk{..}** и мета-аргумент for_each для подключения созданных вами дополнительных дисков.

![image](https://github.com/PatKolzin/terraform-03/assets/75835363/59687f12-12e3-4283-806e-1841b98fe855)

------

### Задание 4

1. В файле ansible.tf создайте inventory-файл для ansible.
Используйте функцию tepmplatefile и файл-шаблон для создания ansible inventory-файла из лекции.
Готовый код возьмите из демонстрации к лекции [**demonstration2**](https://github.com/netology-code/ter-homeworks/tree/main/03/demonstration2).
Передайте в него в качестве переменных группы виртуальных машин из задания 2.1, 2.2 и 3.2, т. е. 5 ВМ.

![image](https://github.com/PatKolzin/terraform-03/assets/75835363/0c796f33-f0d9-4d88-b28e-8af94e129248)


2. Инвентарь должен содержать 3 группы [webservers], [databases], [storage] и быть динамическим, т. е. обработать как группу из 2-х ВМ, так и 999 ВМ.
3. Выполните код. Приложите скриншот получившегося файла.

![hosts cfg](https://github.com/PatKolzin/terraform-03/assets/75835363/dcb79d75-05c7-4202-ba3e-1dd0d64bb2e2)

------

### Задание 5* (необязательное)
1. Напишите output, который отобразит все 5 созданных ВМ в виде списка словарей:
``` 
[
 {
  "name" = 'имя ВМ1'
  "id"   = 'идентификатор ВМ1'
  "fqdn" = 'Внутренний FQDN ВМ1'
 },
 {
  "name" = 'имя ВМ2'
  "id"   = 'идентификатор ВМ2'
  "fqdn" = 'Внутренний FQDN ВМ2'
 },
 ....
]
```
Приложите скриншот вывода команды ```terrafrom output```.

![outputs](https://github.com/PatKolzin/terraform-03/assets/75835363/f3362209-8748-4d2c-8812-f8a6087f0ef9)

------

### Задание 6* (необязательное)

1. Используя null_resource и local-exec, примените ansible-playbook к ВМ из ansible inventory-файла.
Готовый код возьмите из демонстрации к лекции [**demonstration2**](https://github.com/netology-code/ter-homeworks/tree/main/demonstration2).

![nginx](https://github.com/PatKolzin/terraform-03/assets/75835363/4c1ca870-aac6-4faf-8f99-561e6709bd5d)


2. Дополните файл шаблон hosts.tftpl. 
Формат готового файла:
```netology-develop-platform-web-0   ansible_host="<внешний IP-address или внутренний IP-address если у ВМ отсутвует внешний адрес>"```

![image](https://github.com/PatKolzin/terraform-03/assets/75835363/5c910583-bbe2-4119-b679-3a43498c6522)


Для проверки работы уберите у ВМ внешние адреса. Этот вариант используется при работе через bastion-сервер.
Для зачёта предоставьте код вместе с основной частью задания.

