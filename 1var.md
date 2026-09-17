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
  <img src="images\1var\1. Таблица IP-адресов.png" width="600" />
</p>

<p align="center">
  <img src="images\1var\2. Топология сети.png" width="600" />
</p>

<p align="center"><b>Чтобы зайти на стенд для 1 модуля.</b></p>
 
<p align="center"><b>User name: m1</b></p>
<p align="center"><b>Password: module1</b></p>

**ISP преднастроена, но включать ее надо**
 
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
  <img src="images/1var/1. Таблица IP-адресов.png" width="700" />
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

### <p align="center"><b>2. Настройка доступа к сети Интернет на ISP</b></p>

По заданию необходимо настроить маршрутизатор `ISP`:

- интерфейс в сторону магистрального провайдера должен получать адрес по DHCP;
- интерфейс в сторону `HQ-RTR` должен находиться в сети `172.16.1.0/28`;
- интерфейс в сторону `BR-RTR` должен находиться в сети `172.16.2.0/28`;
- необходимо разрешить маршрутизацию пакетов;
- настроить динамическую трансляцию адресов для выхода `HQ-RTR` и `BR-RTR` в Интернет.

<p align="center"><b>ISP</b></p>

Открываем файл конфигурации сетевых интерфейсов:

```bash
nano /etc/network/interfaces
```

Настраиваем интерфейсы следующим образом:

```text
auto ens18
iface ens18 inet dhcp

auto ens19
iface ens19 inet static
    address 172.16.1.1/28

auto ens20
iface ens20 inet static
    address 172.16.2.1/28
```

<p align="center">
  <img src="images/1var/network-int-isp.png" width="600" />
</p>

Где:

- `ens18` — интерфейс в сторону магистрального провайдера;
- `ens19` — интерфейс в сторону `HQ-RTR`;
- `ens20` — интерфейс в сторону `BR-RTR`.

После изменения конфигурации перезапускаем сеть:

```bash
systemctl restart networking
```

### <p align="center"><b>Включаем пересылку пакетов на ISP</b></p>

Чтобы `ISP` мог пересылать пакеты между своими интерфейсами, включаем IPv4 forwarding.

Открываем файл:

```bash
nano /etc/sysctl.conf
```

Раскомментируем или добавим строку:

```text
net.ipv4.ip_forward=1
```

<p align="center">
  <img src="images/1var/isp-sysctl.png" width="600" />
</p>

Применяем изменения:

```bash
sysctl -p
```

### <p align="center"><b>Настройка NAT на ISP</b></p>

Для выхода маршрутизаторов `HQ-RTR` и `BR-RTR` в Интернет настроим динамическую трансляцию адресов с помощью `nftables`.

Открываем файл:

```bash
nano /etc/nftables.conf
```

Настраиваем:

```nft
#!/usr/sbin/nft -f

flush ruleset

table inet filter {
    chain forward {
        type filter hook forward priority filter;
        policy accept;
    }
}

table inet nat {
    chain POSTROUTING {
        type nat hook postrouting priority srcnat;

        oifname "ens18" ip saddr { 172.16.1.0/28, 172.16.2.0/28 } masquerade
    }
}
```

<p align="center">
  <img src="images/1var/NAT-isp.png" width="600" />
</p>

Проверяем конфигурацию:

```bash
nft -c -f /etc/nftables.conf
```

Если ошибок нет, применяем:

```bash
nft -f /etc/nftables.conf
```

Добавляем службу в автозагрузку:

```bash
systemctl enable nftables
```

Перезапускаем:

```bash
systemctl restart nftables
```

Проверяем правила:

```bash
nft list ruleset
```

После этого `HQ-RTR` и `BR-RTR` должны иметь возможность выходить в Интернет через `ISP`.

### <p align="center"><b>4. Настройка коммутации в сегменте HQ</b></p>

По заданию необходимо:

- трафик `HQ-SRV` поместить в VLAN 100;
- трафик `HQ-CLI` поместить в VLAN 200;
- предусмотреть VLAN 999 для управления;
- маршрутизацию всех VLAN на `HQ-RTR` реализовать через один физический интерфейс.

<p align="center"><b>HQ-RTR</b></p>

Для связи с сегментом HQ используем один физический интерфейс `ens19`.

Открываем конфигурацию:

```bash
nano /etc/network/interfaces
```

Настраиваем VLAN-подинтерфейсы:

```text
auto ens19
iface ens19 inet manual

auto ens19.100
iface ens19.100 inet static
    address 192.168.100.1/27
    vlan-raw-device ens19

auto ens19.200
iface ens19.200 inet static
    address 192.168.20.1/28
    vlan-raw-device ens19

auto ens19.999
iface ens19.999 inet static
    address 192.168.99.1/29
    vlan-raw-device ens19
```

<p align="center">
  <img src="images/1var/vlan-hq-rtr.png" width="600" />
</p>

После изменения конфигурации перезапускаем сеть:

```bash
systemctl restart networking
```

Проверяем созданные VLAN-интерфейсы:

```bash
ip -br a
```

<p align="center">
  <img src="images/1var/vlan-check-hq-rtr.png" width="600" />
</p>

В результате должны быть доступны:

```text
ens19.100
ens19.200
ens19.999
```

> **Примечание:**
> Все VLAN маршрутизируются через один физический интерфейс `ens19`, как и требуется по заданию.

### <p align="center"><b>Настройка VLAN на виртуальном коммутаторе</b></p>

На виртуальном коммутаторе Proxmox распределяем устройства по VLAN.

Для `HQ-SRV` указываем VLAN 100:

<p align="center">
  <img src="images/1var/vswitch-hq-srv-vlan100.png" width="700" />
</p>

Для `HQ-CLI` указываем VLAN 200:

<p align="center">
  <img src="images/1var/vswitch-hq-cli-vlan200.png" width="700" />
</p>

Интерфейс `HQ-RTR`, подключённый к `vmbr4`, оставляем без VLAN Tag, так как через него должен проходить трафик VLAN 100, 200 и 999.

> **Примечание:**
> На `HQ-RTR` разделение трафика выполняется подинтерфейсами `ens19.100`, `ens19.200` и `ens19.999`.

### <p align="center"><b>6. Настройка GRE-туннеля между HQ и BR</b></p>

По заданию между маршрутизаторами `HQ-RTR` и `BR-RTR` необходимо настроить GRE-туннель.

Для туннеля используем сеть:

```text
10.10.10.0/30
```

Адреса:

```text
HQ-RTR -> 10.10.10.1/30
BR-RTR -> 10.10.10.2/30
```

<p align="center"><b>HQ-RTR</b></p>

Открываем файл сетевой конфигурации:

```bash
nano /etc/network/interfaces
```

Добавляем GRE-интерфейс:

```text
auto gre1
iface gre1 inet static
    address 10.10.10.1/30
    pre-up ip tunnel add gre1 mode gre local 172.16.1.2 remote 172.16.2.2 ttl 255
    post-down ip tunnel del gre1
```

<p align="center">
  <img src="images/1var/gre-hq-rtr.png" width="600" />
</p>

<p align="center"><b>BR-RTR</b></p>

Открываем:

```bash
nano /etc/network/interfaces
```

Добавляем:

```text
auto gre1
iface gre1 inet static
    address 10.10.10.2/30
    pre-up ip tunnel add gre1 mode gre local 172.16.2.2 remote 172.16.1.2 ttl 255
    post-down ip tunnel del gre1
```

<p align="center">
  <img src="images/1var/gre-br-rtr.png" width="600" />
</p>

После настройки перезапускаем сеть:

```bash
systemctl restart networking
```

Проверяем GRE-туннель с `HQ-RTR`:

```bash
ping 10.10.10.2
```

<p align="center">
  <img src="images/1var/gre-ping.png" width="600" />
</p>

При успешной настройке адрес `10.10.10.2` должен отвечать без потерь.

### <p align="center"><b>8. Настройка динамической трансляции адресов</b></p>

По заданию необходимо настроить динамическую трансляцию адресов на маршрутизаторах `HQ-RTR` и `BR-RTR`, чтобы устройства обоих офисов имели доступ к сети Интернет.

### <p align="center"><b>Включение пересылки IPv4</b></p>

Для маршрутизации трафика на `HQ-RTR`, `BR-RTR` и `BR-FW` необходимо разрешить пересылку IPv4-пакетов.

Открываем файл:

```bash
nano /etc/sysctl.conf
```

Добавляем или раскомментируем строку:

```text
net.ipv4.ip_forward=1
```

Применяем настройки:

```bash
sysctl -p
```

Проверяем:

```bash
sysctl net.ipv4.ip_forward
```

Ожидаемый результат:

```text
net.ipv4.ip_forward = 1
```

> **Примечание:**
> `BR-FW` является промежуточным маршрутизатором между `BR-RTR` и сетью `BR-SRV`, поэтому IPv4 forwarding на нём также должен быть включён.

---

<p align="center"><b>HQ-RTR</b></p>

Для выхода локальных сетей офиса HQ в Интернет настраиваем динамическую трансляцию адресов.

Открываем:

```bash
nano /etc/nftables.conf
```

Настраиваем:

```nft
#!/usr/sbin/nft -f

flush ruleset

table inet filter {
    chain input {
        type filter hook input priority filter;
    }

    chain forward {
        type filter hook forward priority filter;
    }

    chain output {
        type filter hook output priority filter;
    }
}

table inet nat {
    chain POSTROUTING {
        type nat hook postrouting priority srcnat;

        oifname "ens18" ip saddr { 192.168.100.0/27, 192.168.20.0/28, 192.168.99.0/29 } masquerade
    }
}
```

<p align="center">
  <img src="images/1var/nat-hq-rtr.png" width="600" />
</p>

---

<p align="center"><b>BR-RTR</b></p>

Для выхода сетей офиса BR в Интернет выполняем аналогичную настройку.

Открываем:

```bash
nano /etc/nftables.conf
```

Настраиваем:

```nft
#!/usr/sbin/nft -f

flush ruleset

table inet filter {
    chain input {
        type filter hook input priority filter;
    }

    chain forward {
        type filter hook forward priority filter;
    }

    chain output {
        type filter hook output priority filter;
    }
}

table inet nat {
    chain POSTROUTING {
        type nat hook postrouting priority srcnat;

        oifname "ens18" ip saddr { 192.168.30.0/30, 192.168.200.0/28 } masquerade
    }
}
```

<p align="center">
  <img src="images/1var/nat-br-rtr.png" width="600" />
</p>

---

### <p align="center"><b>BR-FW</b></p>

На `BR-FW` NAT не настраиваем.

`BR-FW` только маршрутизирует трафик между сетью `BR-SRV` и `BR-RTR`.

На интерфейсе в сторону `BR-RTR` ранее уже был настроен шлюз:

```text
gateway 192.168.30.1
```

Поэтому на `BR-FW` автоматически создаётся маршрут по умолчанию:

```text
default via 192.168.30.1
```

Проверить его можно командой:

```bash
ip r
```

> **Примечание:**
> Динамическая трансляция адресов выполняется на `BR-RTR`, а `BR-FW` выступает промежуточным маршрутизатором между `192.168.200.0/28` и `BR-RTR`.

---

После настройки `nftables` на `HQ-RTR` и `BR-RTR` проверяем конфигурацию:

```bash
nft -c -f /etc/nftables.conf
```

Если ошибок нет, применяем:

```bash
nft -f /etc/nftables.conf
```

Добавляем службу в автозагрузку:

```bash
systemctl enable nftables
```

Перезапускаем:

```bash
systemctl restart nftables
```

Проверяем правила:

```bash
nft list ruleset
```

### <p align="center"><b>Проверка доступа в Интернет</b></p>

Проверяем доступ в Интернет с `BR-FW`:

```bash
ping 77.88.8.8
```

<p align="center">
  <img src="images/1var/internet-br-fw.png" width="600" />
</p>

Ответы от `77.88.8.8` подтверждают, что `BR-FW` имеет доступ в Интернет через `BR-RTR`.

> **Примечание:**
> Полный доступ `BR-SRV` к сети Интернет будет проверен после настройки OSPF, когда `BR-RTR` получит маршрут к сети `192.168.200.0/28` через `BR-FW`.
