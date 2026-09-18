## <p align="center"><b>Задание 2. Организация сетевого администрирования</b></p>

### <p align="center"><b>1. Настройка контроллера домена Samba DC на BR-SRV</b></p>

По заданию контроллер домена `Samba DC` на сервере `BR-SRV` уже установлен и функционирует.

Необходимо:

- ввести `HQ-CLI` в домен;
- создать 5 пользователей `hquser1`–`hquser5`;
- настроить минимальную длину пароля 8 символов;
- настроить блокировку после 5 неудачных попыток входа;
- создать группу `hq` и добавить в неё созданных пользователей;
- обеспечить возможность аутентификации пользователей группы `hq` на `HQ-CLI`;
- разрешить пользователям группы `hq` повышение привилегий только для команд `cat`, `grep` и `id`.

---

### <p align="center"><b>Настройка парольной политики</b></p>

На `BR-SRV` задаём минимальную длину пароля:

```bash
samba-tool domain passwordsettings set --min-pwd-length=8
```

Настраиваем блокировку после 5 неудачных попыток:

```bash
samba-tool domain passwordsettings set --account-lockout-threshold=5
```

Устанавливаем длительность блокировки 5 минут:

```bash
samba-tool domain passwordsettings set --account-lockout-duration=5
```

Устанавливаем сброс счётчика неудачных попыток через 5 минут:

```bash
samba-tool domain passwordsettings set --reset-account-lockout-after=5
```

Проверяем настройки:

```bash
samba-tool domain passwordsettings show
```

<p align="center">
  <img src="images/2var/samba-password-policy.png" width="700" />
</p>

В результате:

```text
Minimum password length: 8
Account lockout threshold (attempts): 5
Account lockout duration (mins): 5
Reset Account lockout after (mins): 5
```

---

### <p align="center"><b>Создание пользователей и группы hq</b></p>

Создаём группу:

```bash
samba-tool group add hq
```

Создаём пользователей:

```bash
samba-tool user create hquser1 'P@ssw0rd1'
samba-tool user create hquser2 'P@ssw0rd2'
samba-tool user create hquser3 'P@ssw0rd3'
samba-tool user create hquser4 'P@ssw0rd4'
samba-tool user create hquser5 'P@ssw0rd5'
```

<p align="center">
  <img src="images/2var/samba-users.png" width="700" />
</p>

Добавляем пользователей в группу `hq`:

```bash
samba-tool group addmembers hq hquser1
samba-tool group addmembers hq hquser2
samba-tool group addmembers hq hquser3
samba-tool group addmembers hq hquser4
samba-tool group addmembers hq hquser5
```

Проверяем состав группы:

```bash
samba-tool group listmembers hq
```

<p align="center">
  <img src="images/2var/samba-hq-group.png" width="700" />
</p>

---

### <p align="center"><b>Ввод HQ-CLI в домен</b></p>

`HQ-CLI` работает под управлением `ALT Workstation 10.2`.

Перед установкой доменных пакетов удаляем пакет, который может мешать установке:

```bash
apt-get remove -y alterator-datetime
```

Устанавливаем необходимые компоненты:

```bash
apt-get update
apt-get install -y task-auth-ad-sssd
```

Вводим `HQ-CLI` в домен:

```bash
system-auth write ad au-team.irpo hq-cli AU-TEAM 'Administrator' 'P@ssw0rd'
```

<p align="center">
  <img src="images/2var/domain-join-hq-cli.png" width="700" />
</p>

После успешного присоединения проверяем состояние:

```bash
system-auth status
```

<p align="center">
  <img src="images/2var/domain-status-hq-cli.png" width="700" />
</p>

На `BR-SRV` проверяем создание учётной записи компьютера:

```bash
samba-tool computer list
```

<p align="center">
  <img src="images/2var/domain-computer-br-srv.png" width="700" />
</p>

В списке должна присутствовать машина:

```text
HQ-CLI$
```

---

### <p align="center"><b>Проверка доменного пользователя</b></p>

На `HQ-CLI` проверяем пользователя:

```bash
id 'hquser1@au-team.irpo'
```

<p align="center">
  <img src="images/2var/domain-user-hq-cli.png" width="800" />
</p>

В выводе должна присутствовать группа:

```text
hq
```

После первого полноценного входа в графическую оболочку домашний каталог пользователя создаётся автоматически.

Проверяем вход:

```bash
whoami
pwd
id
```

<p align="center">
  <img src="images/2var/domain-login-hq-cli.png" width="800" />
</p>

---

### <p align="center"><b>Настройка ограниченного sudo для группы hq</b></p>

На ALT Workstation пользователи группы `hq` должны иметь возможность выполнять с повышенными привилегиями только:

```text
cat
grep
id
```

Создаём файл:

```bash
nano /etc/sudoers.d/hq
```

Добавляем:

```sudoers
%hq ALL=(ALL) /usr/bin/cat, /bin/grep, /usr/bin/id
```

<p align="center">
  <img src="images/2var/sudo-hq-config.png" width="700" />
</p>

Для ALT Workstation устанавливаем требуемые права:

```bash
chmod 400 /etc/sudoers.d/hq
chmod 400 /etc/sudoers.d/99-sudopw
```

Также разрешаем пользователям запуск бинарного файла `sudo`:

```bash
chmod o+x /usr/bin/sudo
```

Проверяем конфигурацию:

```bash
visudo -c
```

<p align="center">
  <img src="images/2var/sudo-hq-visudo-check.png" width="700" />
</p>

---

### <p align="center"><b>Проверка разрешённых и запрещённых команд</b></p>

Под доменным пользователем `hquser1` проверяем разрешённые команды:

```bash
sudo /usr/bin/id
sudo /usr/bin/cat /etc/hostname
sudo /bin/grep root /etc/passwd
```

Проверяем запрещённую команду:

```bash
sudo /usr/bin/apt-get update
```

<p align="center">
  <img src="images/2var/sudo-hq-allowed.png" width="800" />
</p>

Команды `id`, `cat` и `grep` выполняются с повышенными привилегиями.

Команда `apt-get` должна быть запрещена:

```text
Sorry, user hquser1 is not allowed to execute ...
```

> **Примечание:**
> Пользователи группы `hq` могут аутентифицироваться на `HQ-CLI`, но повышать привилегии разрешено только для ограниченного набора команд: `cat`, `grep` и `id`.
