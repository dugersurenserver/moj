<details open>
<summary>1. Үйлдлийн систем, тохиргоо</summary>


### Ubuntu server 22.04 суулгана.

<ins> Суулгахдаа нэршлийг дараах байдлаар өгнө. </ins>
```
Компьютерийн нэр: vm
Хэрэглэгчийн нэр: bd
```

### Шинээр суулгасан ubuntu сервер дээр дахаар тохиргоог хийнэ.

<ins> Сервер дээр хийгдэх тохиргоо </ins>
```
sudo apt update
sudo  apt install git gcc g++ make python3-dev python3-pip libxml2-dev libxslt1-dev zlib1g-dev gettext curl redis-server
sudo  curl -sL https://deb.nodesource.com/setup_18.x | sudo -E bash -
sudo apt install nodejs
sudo  npm install -g sass postcss-cli postcss autoprefixer
```

</details>

---
<details>
<summary> 2. Өгөгдлийн баазыг суулгах тохируулах</summary>


<ins>Баазыг дараах командын тусламжтайгаар суулгана </ins>
```
sudo apt update
sudo apt install mariadb-server libmysqlclient-dev
```

<ins>Баазыг шинээр үүсгэх </ins>

```
sudo mysql
CREATE DATABASE dmoj DEFAULT CHARACTER SET utf8mb4 DEFAULT COLLATE utf8mb4_general_ci;
GRANT ALL PRIVILEGES ON dmoj.* TO 'dmoj'@'localhost' IDENTIFIED BY 'db123';
exit
```


<ins>Баазыг unicode дэмждэг болгон тохируулах</ins>
```
sudo -i
mysql_tzinfo_to_sql /usr/share/zoneinfo | sed -e "s/Local time zone must be set--see zic manual page/local/" | mysql -u root mysql

exit
```

</details>

---



---
<details>
<summary> 3. virtual environment-ийг үүсгэх</summary>

```
sudo apt install python3.10-venv

python3 -m venv venv
. venv/bin/activate
```
</details>


---
<details>
<summary> 4. Сайт үүсгэх</summary>

<ins>Сайт үүсгэхдээ github-аас үүсгэж болно</ins>

```
(venv) $ git clone https://github.com/DMOJ/site.git
(venv) $ cd site
(venv) $ git checkout v4.0.0  //Үүнийг өгөхгүй байж болно
(venv) $ git submodule init
(venv) $ git submodule update
```


<ins>site -ийг шууд хуулж болно(FileZilla ашиглан)</ins>

```
(venv) $ sudo chmod 777 -R /home/bd/site/
(venv) $ sudo chmod 777 -R /tmp/
(venv) $ sudo mkdir /mnt/problems/
(venv) $ sudo chmod 777 -R /mnt/problems/
(venv) $ cd site/
```

<ins>Нэмэлт сангуудыг суулгах</ins>
```
(venv) $ pip3 install -r requirements.txt
(venv) $ pip3 install mysqlclient
(venv) $ pip3 install pymysql
(venv) $ python3 manage.py check
```

<ins>build хийж static файлуудыг үүсгэх</ins>

статик файл нь dmoj/local_settings.py файлын STATIC_ROOT хэсэгт заасан фолдер руу үүснэ.
```
(venv) $ ./make_style.sh
(venv) $ python3 manage.py collectstatic
(venv) $ python3 manage.py compilemessages
(venv) $ python3 manage.py compilejsi18n
```

<ins>Өгөгдлийн баазын хүснэгт үүсгэх, жишээ өгөгдөл оруулах</ins>
```
(venv) $ python3 manage.py migrate
(venv) $ python3 manage.py loaddata navbar
(venv) $ python3 manage.py loaddata language_small
(venv) $ python3 manage.py loaddata demo
(venv) $ python3 manage.py createsuperuser
```

<ins>redis сервер суулгах, тестлэх</ins>
```
(venv) $ sudo service redis-server start
(venv) $ python3 manage.py runserver 0.0.0.0:8000
(venv) $ python3 manage.py runbridged
(venv) $ pip3 install Redis

(venv) $ celery -A dmoj_celery worker

(venv) $ pip3 install uwsgi
(venv) $ uwsgi --ini uwsgi.ini
```

</details>




---
<details>
<summary> 5. nging, supervisor-ийг суулгах тохируулах</summary>

<ins>Суулгах, тохируулах</ins>
```
sudo apt install supervisor
sudo apt install nginx


sudo cp /home/bd/site/conf/site.conf /etc/supervisor/conf.d/site.conf
sudo cp /home/bd/site/conf/bridged.conf /etc/supervisor/conf.d/bridged.conf
sudo cp /home/bd/site/conf/celery.conf /etc/supervisor/conf.d/celery.conf
sudo cp /home/bd/site/conf/wsevent.conf /etc/supervisor/conf.d/wsevent.conf
sudo cp /home/bd/site/conf/default /etc/nginx/sites-available/default
sudo cp /home/bd/site/conf/judge.yml /mnt/problems/judge.yml
sudo nano /mnt/problems/judge.yml
sudo nano /home/bd/site/dmoj/local_settings.py

sudo supervisorctl update
sudo supervisorctl status
sudo supervisorctl restart all

sudo nginx -t
sudo service nginx reload
```

</details>


---
<details>
<summary> 6. websocket-ийг суулгах тохируулах</summary>

```
(dmojsite) $ npm install qu ws simplesets
(dmojsite) $ pip3 install websocket-client

sudo supervisorctl update
sudo supervisorctl restart bridged
sudo supervisorctl restart site
sudo supervisorctl restart all
sudo supervisorctl status
sudo service nginx restart

```
</details>



---
<details>
<summary> docker -ийг асаах тохируулах харах</summary>


<ins>Баазыг дараах командын тусламжтайгаар суулгана </ins>
```
sudo docker ps
sudo docker ps -a
sudo docker ps
sudo docker stop <container_name, ID>
sudo docker start <container_name, ID>
sudo docker restart <container_name, ID>
sudo docker exec -t judge bash

sudo docker container prune



sudo chmod u-x /home/bd/site/conf/moj.sh

```


</details>


---
<details>
<summary> ip, port -ийн ажиллаж байгааг хянах</summary>

<ins>Идэвхитэй ажиллаж байгаа портыг сонсох </ins>
```
sudo apt install net-tools
netstat -tulnp | grep LISTEN

```


</details>


---
<details>
<summary> ip, port -ийн ажиллаж байгааг хянах</summary>

<ins>Файлын нэрийг солих </ins>
```
rename -v  's/\)\.txt/\.in/' test_input*
rename -v  's/\)\.txt/\.out/' test_output*
rename -v  's/(test_input\ \(|test_output\ \()//' *

```
[Холбогдох сайт](https://phoenixnap.com/kb/rename-file-linux)

</details>





---
<details>
<summary> nginx серверийн зөвшөөрөх файлын хэмжээ</summary>

nginx нь defaul-аараа upload хийх файлын хэмжээг хязгаарласан байдаг. Үүнийг өөрчлөхийн тулд дараах камандыг гүйцэтгэх хэрэгэтэй
<ins>default файл дотор доорх кодыг оруулах </ins>
```
client_max_body_size 10000M;
```
default файлд дараах байдлаар харагдана. зөвхөн хэсгийг нь доор харууллаа
```
server {
    listen       80;
    listen       [::]:80;

    # Change port to 443 and do the nginx ssl stuff if you want it.

    # Change server name to the HTTP hostname you are using.
    # You may also make this the default server by listening with default_server,
    # if you disable the default nginx server declared.
    server_name 127.0.0.1;

    # -----------upload хийх файлын хэмжээг заах-----------
    client_max_body_size 100M;

    add_header X-UA-Compatible "IE=Edge,chrome=1";
    add_header X-Content-Type-Options nosniff;
    add_header X-XSS-Protection "1; mode=block";

    charset utf-8;
    try_files $uri @icons;
    error_page 502 504 /502.html;

    location ~ ^/502\.html$|^/logo\.png$|^/robots\.txt$ {
        root /home/bd/site;
    }


```
Энэхүү өөрчлөлтийг хийсний дараа дараах командыг гүйцэтгэж өөрчлөлийг баталгаажуулна


```
sudo service nginx restart
sudo service nginx reload
```


</details>
