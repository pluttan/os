#import "@docs/bmstu:1.0.0":*
#import "@preview/tablex:0.0.8": tablex, rowspanx, colspanx, cellx
#show: student_work.with(
  caf_name: "Компьютерные системы и сети",
  faculty_name: "Информатика и системы управления",
  work_type: "лабораторной работе",  
  work_num: 6,
  study_field: "09.03.01 Информатика и вычислительная техника",
  discipline_name: "Операционные системы",
  theme: "Исследование методов защиты операционных систем и данных",
  author: (group: "ИУ6-52Б", nwa: "А. П. Плютто"),
  adviser: (nwa: "В.Ю. Мельников"),
  city: "Москва",
  table_of_contents: true,
)

= Введение
== Цель работы

Исследование методов защиты информации в Linux.

== Задание

Предположим, в вашей организации в нескольких подразделениях стоят
сканеры, пользователи сканируют на них документы и записывают на сервер.

На сервере работает программа, которая распознаёт файлы из одного
каталога и записывает файлы с распознанным текстом в другой каталог.

Пользователи загружают распознанные тексты документов в систему
документооборота, кроме документов «для служебного пользования»,
которые записывают в специальный каталог. К этому каталогу имеют доступ
только определённая группа пользователей.

Задача: С помощью команд:
- Создать несколько пользователей, включая пользователя от имени которого работает сервис распознавания.
- Для каждого пользователя создать каталоги:
  - in — для файлов, предназначенных для распознавания
  - out — для распознанных файлов\ #h(-13%)Пользователи не должны иметь доступ к файлам других пользователей.\ #h(-13%) Не забудьте дать права сервису распознавания.
- Создать каталог, в который выкладывают файлы пользователи группы «DSP». Только пользователи этой группы должны иметь к нему доступ.
- Создать файл протокола, в который записывает сообщения сервис распознавания. Все пользователи должны иметь права на чтение этого файла.

= Выполнение

== Создать несколько пользователей, включая пользователя от имени которого работает сервис распознавания.

При помощи комманды ```sh useradd``` добавим 4 пользователей:
- `user1`, `user2` -- пользователи группы «DSP»
- `user3` -- обычный пользователь
- `recognition_service` -- пользователь-сервер, который обрабатывает все запросы

#img(image("img/1.png", width:70%), [```sh useradd -m -s /bin/bash/ user1```])

После создания первого пользователя сразу же зададим его пароль при помощи утилиты ```sh passwd```.
#img(image("img/2.png", width:70%), [```sh passwd user1```])

#img(image("img/4.png", width:70%), [```sh useradd -m -s /bin/bash/ user2```])

#img(image("img/5.png", width:70%), [```sh useradd -m -s /bin/bash/ user3```])

#img(image("img/6.png", width:70%), [```sh useradd -m -s /bin/bash/ recognition_service```, ```sh passwd user2```, ```sh passwd user3```, ```sh passwd recognition_service```])

Сразу создадим группу пользователей, которые будут иметь доступ к каталогу «DSP». Добавим наших пользователей в группу.

#img(image("img/8.png", width:70%), [```sh groupadd DSP```, ```sh usermod -aG DSP user1```, ```sh usermod -aG DSP user1```])

== Для каждого пользователя создать каталоги in, out

С помощью утилиты ```sh mkdir``` создадим для каждого пользователя каталоги `in`, `out`.

```sh
mkdir -p /home/user1/in /home/user1/out
mkdir -p /home/user2/in /home/user2/out
mkdir -p /home/user3/in /home/user3/out
mkdir -p /home/recognition_service/in /home/recognition_service/out
```
#img(image("img/9.png", width:70%), [Добавляем каталоги])

С помощью утилит ```sh chown``` и ```sh chmod``` выдадим разрешение на чтение и запись разным пользователям.

```sh
chown user1:user1 /home/user1/in /home/user1/out
chmod 700 /home/user1/in /home/user1/out

chown user2:user2 /home/user2/in /home/user2/out
chmod 700 /home/user2/in /home/user2/out

chown user3:user3 /home/user3/in /home/user3/out
chmod 700 /home/user3/in /home/user3/out

chown recognition_service:recognition_service /home/recognition_service/in /home/recognition_service/out
chmod 700 /home/recognition_service/in /home/recognition_service/out
```

#img(image("img/11.png", width:70%), [```sh chown``` и ```sh chmod```])
#img(image("img/12.png", width:70%), [```sh chown``` и ```sh chmod```])


== Создать каталог, в который выкладывают файлы пользователи группы «DSP». Только пользователи этой группы должны иметь к нему доступ.

С помощью ```sh mkdir``` создадим данный каталог, с помощью ```sh chown``` и ```sh chmod``` зададим доступ только определенной группе пользовалетей на чтение и запись.

```sh 
mkdir /srv/dsp_files
chown :DSP /srv/dsp_files
chmod 770 /srv/dsp_files
```


#img(image("img/13.png", width:70%), [```sh mkdir```, ```sh chown``` и ```sh chmod```])

== Создать файл протокола, в который записывает сообщения сервис распознавания. Все пользователи должны иметь права на чтение этого файла.

При помощи ```sh touch``` создадим файл для сервиса, с помошью ```sh chmod``` зададим права на чтение файла для всех.

```sh
touch /var/log/logfile.log
chmod 644 /var/log/logfile.log
```

#img(image("img/14.png", width:70%), [Создаем файл])

== Проверка

Проверим все созданные каталоги и файл на права доступа:
```sh ls -ld /home/user1/in /home/user1/out /home/user2/in /home/user2/out /home/user3/in /home/user3/out /home/recognition_service/in /home/recognition_service/out /srv/dsp_files /var/log/logfile.log```

#img(image("img/16.png", width:65%), [```sh ls```])

Видим что все директории принадлежат правитьным пользователям.

При помощи комманды ```sh groups``` посмотрим все группы, в которых состоят созданные пользователи:

```sh groups user1
groups user2
groups user3
groups recognition_service
```

#img(image("img/17.png", width:65%), [```sh groups```])

Зайдем под разными пользователями и проверим их права:

#img(image("img/18.png", width:70%), [`user1`])
#img(image("img/19.png", width:70%), [`user2`])
#img(image("img/20.png", width:70%), [`user3`])




