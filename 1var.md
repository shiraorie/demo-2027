# laba/Вариант 1

## <p align="center"><b>МОДУЛЬ 1</b></p>

Задание:

Необходимо разработать и настроить инфраструктуру информационно-коммуникационной системы согласно предложенной топологии.

Задание включает базовую настройку устройств:

- присвоение имен устройствам;
- расчет IP-адресации;
- настройку коммутации и маршрутизации.

В ходе проектирования и настройки сетевой инфраструктуры следует вести отчет о своих действиях, включая таблицы и схемы, предусмотренные в задании.

По каждому пункту задания, требующего отчёт, необходимо составить текстовый документ. Название документа должно содержать индекс пункта и краткое описание.

Текстовый документ должен содержать текстовую информацию и может включать снимки экрана. Скриншоты необходимо кадрировать так, чтобы относящаяся к выполнению задания информация была читаемой.

Итоговый отчет по окончании работы следует сохранить на диске рабочего места и задать имя файла:

**ФамилияУчастникаЗадание1**

без учёта расширения.

SSH Для подключения к стендам, выполняется с HQ-CLI. !!! ВНИМАНИЕ если не умееете не трогайте

isp - ssh root@172.16.10.1
hq-srv - ssh sshuser@192.168.100.2 -p 2011
br-srv - ssh sshuser@192.168.200.2 -p 2011
hq-rtr - ssh root@192.168.100.1
br-rtr - ssh root@192.168.200.1

Порты смотретите по заданию они изменяются




# laba/Вариант 1

## <p align="center"><b>МОДУЛЬ 1</b></p>

Задание 1. Настройка сетевой инфраструктуры :
Необходимо разработать и настроить инфраструктуру информационно коммуникационной системы согласно предложенной топологии (см.  Рисунок 
1). 
Задание включает базовую настройку устройств: 
- присвоение имен устройствам; 
- расчет IP-адресации; 
- настройку коммутации и маршрутизации;

В ходе проектирования и настройки сетевой инфраструктуры следует вести отчет о своих действиях, включая таблицы и схемы, предусмотренные в задании.

По каждому пункту задания, требующего отчёт, составить текстовый документ, название которого должно содержать индекс пункта и краткое  описание.

Текстовый документ должен содержать текстовую информацию и может включать снимки экрана, кадрированные таким образом, чтобы относящаяся к выполнению задания информация на снимках была читаемой. 

Итоговый отчет по окончании работы следует сохранить на диске рабочего места и задать имя файла - ФамилияУчастникаЗадание1 без учёта расширения.

<p align="center">
  <img src="images/module1/2. топология сети.png" width="600" />
</p>

<p align="center">
  <img src="images/module1/1. Таблица IP-адресов.png" width="600" />
</p>

<p align="center"><b>Чтобы зайти на стенд для 1 модуля.</b></p>
 
<p align="center"><b>User name: m1</b></p>
<p align="center"><b>Password: module1</b></p>

 
### <p align="center"><b>Настройка имен устройств</b></p>

По заданию необходимо настроить имена устройств согласно топологии, используя полные доменные имена.

Для изменения имени устройства используем команду:

```bash
hostnamectl set-hostname <имя_устройства>.au-team.irpo; exec bash
```

Настраиваем имена на всех устройствах.

<p align="center"><b>ISP</b></p>

```bash
hostnamectl set-hostname isp.au-team.irpo; exec bash
```

<p align="center">
  <img src="images/1var/hostname-isp.png" width="600" />
</p>

<p align="center"><b>HQ-RTR</b></p>

```bash
hostnamectl set-hostname hq-rtr.au-team.irpo; exec bash
```

<p align="center">
  <img src="images/1var/hostname-hq-rtr.png" width="600" />
</p>

<p align="center"><b>BR-RTR</b></p>

```bash
hostnamectl set-hostname br-rtr.au-team.irpo; exec bash
```

<p align="center">
  <img src="images/1var/hostname-br-rtr.png" width="600" />
</p>

<p align="center"><b>HQ-SRV</b></p>

```bash
hostnamectl set-hostname hq-srv.au-team.irpo; exec bash
```

<p align="center">
  <img src="images/1var/hostname-hq-srv.png" width="600" />
</p>

<p align="center"><b>BR-SRV</b></p>

```bash
hostnamectl set-hostname br-srv.au-team.irpo; exec bash
```

<p align="center">
  <img src="images/1var/hostname-br-srv.png" width="600" />
</p>

<p align="center"><b>HQ-CLI</b></p>

На клиентской машине сначала переходим в root:

```bash
su -
```

После этого меняем имя устройства:

```bash
hostnamectl set-hostname hq-cli.au-team.irpo; exec bash
```

<p align="center">
  <img src="images/1var/hostname-hq-cli.png" width="600" />
</p>

<p align="center"><b>BR-FW</b></p>

```bash
hostnamectl set-hostname br-fw.au-team.irpo; exec bash
```

<p align="center">
  <img src="images/1var/hostname-br-fw.png" width="600" />
</p>

> **Примечание:**
> После выполнения команды имя устройства изменяется сразу благодаря `exec bash`.

> **Примечание:**
> Для устройств `HQ-RTR`, `BR-RTR`, `BR-FW`, `HQ-SRV`, `HQ-CLI` и `BR-SRV` используем домен `au-team.irpo` в соответствии с таблицей имен из задания.

### <p align="center"><b>Настройка IP-адресации</b></p>

Согласно заданию необходимо настроить IPv4-адресацию на устройствах.

Для варианта 1 будем использовать следующую таблицу адресации:

<p align="center">
  <img src="images/1var/table-ip.png" width="700" />
</p>

> **Примечание:**
> Для `HQ-CLI` адрес `192.168.20.2/28` указан в таблице как планируемый. Фактически адрес будет выдан позже по DHCP.

---

<p align="center"><b>HQ-RTR</b></p>

На данном этапе настраиваем только интерфейс в сторону ISP.

Интерфейс в сторону HQ оставляем без адресации, так как VLAN 100, 200 и 999 будут настроены позднее в отдельном пункте задания.

Открываем конфигурацию сети:

```bash
nano /etc/network/interfaces
```

Настраиваем:

```text
auto ens18
iface ens18 inet static
    address 172.16.1.2/28
    gateway 172.16.1.1

auto ens19
iface ens19 inet manual
```

<p align="center">
  <img src="images/1var/network-int-hq-rtr.png" width="600" />
</p>

---

<p align="center"><b>BR-RTR</b></p>

Открываем конфигурацию сети:

```bash
nano /etc/network/interfaces
```

Настраиваем интерфейс в сторону ISP и интерфейс в сторону `BR-FW`:

```text
auto ens18
iface ens18 inet static
    address 172.16.2.2/28
    gateway 172.16.2.1

auto ens19
iface ens19 inet static
    address 192.168.30.1/30
```

<p align="center">
  <img src="images/1var/network-int-br-rtr.png" width="600" />
</p>

---

<p align="center"><b>HQ-SRV</b></p>

Открываем конфигурацию сети:

```bash
nano /etc/network/interfaces
```

Настраиваем адрес сервера:

```text
auto ens18
iface ens18 inet static
    address 192.168.100.2/27
    gateway 192.168.100.1
```

<p align="center">
  <img src="images/1var/network-int-hq-srv.png" width="600" />
</p>

---

<p align="center"><b>BR-SRV</b></p>

Открываем конфигурацию сети:

```bash
nano /etc/network/interfaces
```

Настраиваем адрес сервера:

```text
auto ens18
iface ens18 inet static
    address 192.168.200.2/28
    gateway 192.168.200.1
```

<p align="center">
  <img src="images/1var/network-int-br-srv.png" width="600" />
</p>

---

<p align="center"><b>BR-FW</b></p>

Открываем конфигурацию сети:

```bash
nano /etc/network/interfaces
```

Настраиваем интерфейс в сторону `BR-RTR` и интерфейс в сторону `BR-SRV`:

```text
auto ens18
iface ens18 inet static
    address 192.168.30.2/30
    gateway 192.168.30.1

auto ens19
iface ens19 inet static
    address 192.168.200.1/28
```

<p align="center">
  <img src="images/1var/network-int-br-fw.png" width="600" />
</p>

---

<p align="center"><b>HQ-CLI</b></p>

На данном этапе вручную статический адрес на `HQ-CLI` не настраиваем.

Позднее по заданию на `HQ-RTR` будет настроен DHCP-сервер, который выдаст клиенту адрес из сети:

```text
192.168.20.0/28
```

Планируемый адрес клиента:

```text
192.168.20.2/28
```

Шлюз по умолчанию:

```text
192.168.20.1
```

---

После изменения конфигурации сети на устройствах перезапускаем службу:

```bash
systemctl restart networking
```

Проверить назначенные адреса можно командой:

```bash
ip -br a
```

Проверить таблицу маршрутизации:

```bash
ip r
```

> **Примечание:**
> Адреса для VLAN 100, VLAN 200 и VLAN 999 на `HQ-RTR` будут добавлены позднее при настройке коммутации.
