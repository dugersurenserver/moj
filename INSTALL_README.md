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
sudo  apt install nodejs
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
mariadb> CREATE DATABASE dmoj DEFAULT CHARACTER SET utf8mb4 DEFAULT COLLATE utf8mb4_general_ci;
GRANT ALL PRIVILEGES ON dmoj.* TO 'dmoj'@'localhost' IDENTIFIED BY 'db123';
exit
```


<ins>Баазыг unicode дэмждэг болгон тохируулах</ins>
```
sudo mysql_tzinfo_to_sql /usr/share/zoneinfo | sed -e "s/Local time zone must be set--see zic manual page/local/" | mysql -u root mysql
```

</details>

---



---
<details>
<summary> 3. virtual environment-ийг үүсгэх</summary>

```
pip3 install virtualenv

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

<ins>Нэмэлт сангуудыг суулгах</ins>
```
(venv) $ pip3 install -r requirements.txt
(venv) $ pip3 install mysqlclient
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
sudo su

apt install supervisor
apt install nginx

cd /home/bd/site/conf/

cp ./site.conf /etc/supervisor/conf.d/site.conf
cp ./bridged.conf /etc/supervisor/conf.d/bridged.conf
cp ./celery.conf /etc/supervisor/conf.d/celery.conf
cp ./wsevent.conf /etc/supervisor/conf.d/wsevent.conf
cp ./default /etc/nginx/sites-available/default

supervisorctl update
supervisorctl status

nginx -t
service nginx reload
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
sudo service nginx restart

```
</details>
















# Суурилуулалтын орчин

Ubuntu үйлдлийн систем

Ubuntu 22.04 серверийг суулгаж тохируулах ба дараах командын тусламжтай үндсэн программ хангамжийг суулгаж, орчинг бүрдүүлнэ.
суулгахдаа дараах нэр томъёог олгосон:
* Компьютерийн нэр: vm
* Хэрэглэгчийн нэр: bd
* Нууц үг:          123


 Үндсэн орчинг бэлдэхийн тулд дараах командуудыг өгч ажиллуулна:
```
sudo apt update
sudo apt install git gcc g++ make python3-dev python3-pip libxml2-dev libxslt1-dev zlib1g-dev gettext curl redis-server
sudo curl -sL https://deb.nodesource.com/setup_18.x | sudo -E bash -
sudo apt install nodejs
sudo npm install -g sass postcss-cli postcss autoprefixer

```




# Өгөгдлийн санг суулгаж тохируулна

  Энд Mariadb мэдээллийн санг ашигладаг бөгөөд Ubuntu дээр суулгах нь маш тохиромжтой. Одоогийн Mariadb мэдээллийн санд суулгасны дараа хэрэглэгчээс root нууц үг оруулах шаардлагагүй тул шууд дотоод нэвтрэх нууц үг анхдагчаар хоосон байна.

````
sudo apt update
sudo apt install mariadb-server libmysqlclient-dev -y

sudo mysql -u root -p
mariadb> CREATE DATABASE dmoj DEFAULT CHARACTER SET utf8mb4 DEFAULT COLLATE utf8mb4_general_ci;
mariadb> GRANT ALL PRIVILEGES ON dmoj.* to 'dmoj'@'localhost' IDENTIFIED BY 'db123';
mariadb> exit

````

DMOJ-н өгөгдлийг хадгалахад timezone нь зөрөөд байдаг тул дараах командыг бичих тохируулна. Тэгэхдээ root хэрэглэгчийн эрхээр орж ажиллуулах ёстой.


```
mysql_tzinfo_to_sql /usr/share/zoneinfo | sed -e "s/Local time zone must be set--see zic manual page/local/" | mysql -u root mysql
```



Төслийн үйл ажиллагааны орчин нь үйлдлийн систем дэх бусад Python төслийн орчинд саад учруулахаас урьдчилан сэргийлэхийн тулд venv хамгаалагдсан хязгаарлагдмал орчинд ашиглах хэрэгслийг ашигладаг. Энэ нь зөвхөн дибаг хийх ажилд ашиглагддаггүй, мөн үйлдвэрлэлд нэвтрүүлэх үед venv хамгаалагдсан хязгаарлагдмал орчны хэрэгслийг ашигладаг. Энд гурван командыг гүйцэтгэсний дараа хамгаалагдсан хязгаарлагдмал орчинд ажиллах горимд орох ба терминалын мөрийн дээд хэсэгт (venv) сануулга гарч ирнэ.

Бид уг системийг суулгахдаа /home/bd гэсэн фолдер дотор үүсгэж явахаар шийдсэн тул үндсэн хэрэглэгчийн фолдер дотор нь хөгжүүлэлт хийнэ.

```

sudo apt install -y python3-venv
python3 -m venv venv
. venv/bin/activate
```

# Миний өөрийн хөгжүүлэлт хийсэн site-ийг татаж аваад суулгаж ажиллуулах боломжтой.


# DMOJ суулгаж эхэл
Кодоо татаж аваад хамаарлыг суулгана уу

Энэ алхам нь DMOJ-ийн үндсэн төслийн кодыг Github-аас локал руу татаж аваад дэд төслийн git tracking, update кодыг нэмэх явдал юм. Хэрэв та шийдвэрийн серверийг Docker-ийн аргаар тохируулахаар шийдсэн бол салбараа солих шаардлагагүй гэдгийг энд тэмдэглэх нь зүйтэй. Үгүй бол та branch солих хэрэгтэй болно.

```
git clone https://github.com/DMOJ/site.git
cd site
git checkout v4.0.0  # Энэ алхамыг дараа нь шүүлтийн серверийг тохируулахын тулд pypi аргыг ашиглах үед л гүйцэтгэх шаардлагатай.
git submodule init
git submodule update
pip3 install -r requirements.txt
pip3 install mysqlclient

```

Тохиргооны local_settings.py файл:


```

#####################################
########## Django settings ##########
#####################################
# See <https://docs.djangoproject.com/en/1.11/ref/settings/>
# for more info and help. If you are stuck, you can try Googling about
# Django - many of these settings below have external documentation about them.
#
# The settings listed here are of special interest in configuring the site.

# SECURITY WARNING: keep the secret key used in production secret!
# You may use <http://www.miniwebtool.com/django-secret-key-generator/>
# to generate this key.
#  访问前两行的URL生成一个key
SECRET_KEY = 'anpsa4ko6^@b5u-)e9gm$vk(=lqb()-%0n@lr5c^=$feq45jdh'

# SECURITY WARNING: don't run with debug turned on in production!
# Үйлдвэрлэлийн орчинд үүнийг худал болгож өөрчлөх ёстой
DEBUG = False # Change to False once you are done with runserver testing.

# Uncomment and set to the domain names this site is intended to serve.
# You must do this once you set DEBUG to False.
ALLOWED_HOSTS = ['localhost','dmoj','*]  #Хандалтыг зөвшөөрдөг IP эсвэл домэйн нэрийг тохируулна уу

# Optional apps that DMOJ can make use of.
INSTALLED_APPS += (
)

# Caching. You can use memcached or redis instead.
# Documentation: <https://docs.djangoproject.com/en/1.11/topics/cache/>
CACHES = {
    'default': {
        'BACKEND': 'django.core.cache.backends.locmem.LocMemCache'
    }
}

# Your database credentials. Only MySQL is supported by DMOJ.
# Documentation: <https://docs.djangoproject.com/en/1.11/ref/databases/>
DATABASES = {
     'default': {
        'ENGINE': 'django.db.backends.mysql',
        'NAME': 'dmoj',
        'USER': 'dmoj',
        'PASSWORD': 'db123',  #Өөрийн тохиргоонд өөрчлөлт оруулах шаардлагатай
        'HOST': '127.0.0.1',
        'OPTIONS': {
            'charset': 'utf8mb4',
            'sql_mode': 'STRICT_TRANS_TABLES,NO_ENGINE_SUBSTITUTION',
        },
    }
}

# Sessions.
# Documentation: <https://docs.djangoproject.com/en/1.11/topics/http/sessions/>
#SESSION_ENGINE = 'django.contrib.sessions.backends.cached_db'

# Internationalization.
# Documentation: <https://docs.djangoproject.com/en/1.11/topics/i18n/>
LANGUAGE_CODE = 'zh-hans'  # Олон улсын жишигт нийцсэн хэлний кодчилол болгон өөрчлөх боломжтой
DEFAULT_USER_TIME_ZONE = 'Asia/Shanghai'  # цагийн бүсийг тохируулах
USE_I18N = True
USE_L10N = True
USE_TZ = True

## django-compressor settings, for speeding up page load times by minifying CSS and JavaScript files.
# Documentation: https://django-compressor.readthedocs.io/en/latest/
COMPRESS_OUTPUT_DIR = 'cache'
COMPRESS_CSS_FILTERS = [
    'compressor.filters.css_default.CssAbsoluteFilter',
    'compressor.filters.cssmin.CSSMinFilter',
]
COMPRESS_JS_FILTERS = ['compressor.filters.jsmin.JSMinFilter']
COMPRESS_STORAGE = 'compressor.storage.GzipCompressorFileStorage'
STATICFILES_FINDERS += ('compressor.finders.CompressorFinder',)


#########################################
########## Email configuration ##########
#########################################
# See <https://docs.djangoproject.com/en/1.11/topics/email/#email-backends>
# for more documentation. You should follow the information there to define
# your email settings.

# Use this if you are just testing.
#EMAIL_BACKEND = 'django.core.mail.backends.console.EmailBackend'

# The following block is included for your convenience, if you want
# to use Gmail.
#EMAIL_USE_TLS = True
#EMAIL_HOST = 'smtp.gmail.com'
#EMAIL_HOST_USER = '<your account>@gmail.com'
#EMAIL_HOST_PASSWORD = '<your password>'
#EMAIL_PORT = 587

# To use Mailgun, uncomment this block.
# You will need to run `pip install django-mailgun` for to get `MailgunBackend`.
#EMAIL_BACKEND = 'django_mailgun.MailgunBackend'
#MAILGUN_ACCESS_KEY = '<your Mailgun access key>'
#MAILGUN_SERVER_NAME = '<your Mailgun domain>'

# You can also use Sendgrid, with `pip install sendgrid-django`.
#EMAIL_BACKEND = 'sgbackend.SendGridBackend'
#SENDGRID_API_KEY = '<Your SendGrid API Key>'

# The DMOJ site is able to notify administrators of errors via email,
# if configured as shown below.

# A tuple of (name, email) pairs that specifies those who will be mailed
# when the server experiences an error when DEBUG = False.
ADMINS = (
    ('zhonger', 'zhonger@lep.ac.cn'),
)

# The sender for the aforementioned emails.
SERVER_EMAIL = 'LEPOJ: Modern Online Judge <zhonger@lep.ac.cn>'


##################################################
########### Static files configuration. ##########
##################################################
# See <https://docs.djangoproject.com/en/1.11/howto/static-files/>.

# Change this to somewhere more permanent., especially if you are using a
# webserver to serve the static files. This is the directory where all the
# static files DMOJ uses will be collected to.
# You must configure your webserver to serve this directory as /static/ in production.
# Энэ сан нь статик файлуудыг хадгалдаг газар юм
STATIC_ROOT = '/tmp/static/'

# URL to access static files.
#STATIC_URL = '/static/'

#STATICFILES_DIRS = (
#    os.path.join(BASE_DIR, "static"),
#)

# Uncomment to use hashed filenames with the cache framework.
#STATICFILES_STORAGE = 'django.contrib.staticfiles.storage.CachedStaticFilesStorage'

############################################
########## DMOJ-specific settings ##########
############################################

## DMOJ site display settings.
SITE_NAME = 'LEPOJ'
SITE_LONG_NAME = 'LEPOJ: Modern Online Judge'
SITE_ADMIN_EMAIL = 'zhonger@lep.ac.cn'
TERMS_OF_SERVICE_URL = '//oj.lep.ac.cn/tos' # Use a flatpage.

## Bridge controls.
# The judge connection address and port; where the judges will connect to the site.
# You should change this to something your judges can actually connect to
# (e.g., a port that is unused and unblocked by a firewall).
BRIDGED_JUDGE_ADDRESS = [('127.0.0.1', 9999)]  # Ажлын хуваарийн үйлчилгээний тохиргоо

# The bridged daemon bind address and port to communicate with the site.
#BRIDGED_DJANGO_ADDRESS = [('localhost', 9998)]

## DMOJ features.
# Set to True to enable full-text searching for problems.
ENABLE_FTS = True

# Set of email providers to ban when a user registers, e.g., {'throwawaymail.com'}.
BAD_MAIL_PROVIDERS = set()

# The number of submissions that a staff user can rejudge at once without
# requiring the permission 'Rejudge a lot of submissions'.
# Uncomment to change the submission limit.
#DMOJ_SUBMISSIONS_REJUDGE_LIMIT = 10

## Event server.
# Uncomment to enable live updating.
#EVENT_DAEMON_USE = True

# Uncomment this section to use websocket/daemon.js included in the site.
#EVENT_DAEMON_POST = '<ws:// URL to post to>'

# If you are using the defaults from the guide, it is this:
EVENT_DAEMON_POST = 'ws://127.0.0.1:15101/' # үйл явдал илгээх

# These are the publicly accessed interface configurations.
# They should match those used by the script.
#EVENT_DAEMON_GET = '<public ws:// URL for clients>'
#EVENT_DAEMON_GET_SSL = '<public wss:// URL for clients>'
#EVENT_DAEMON_POLL = '<public URL to access the HTTP long polling of event server>'
# i.e. the path to /channels/ exposed by the daemon, through whatever proxy setup you have.

# Using our standard nginx configuration, these should be.
EVENT_DAEMON_GET = 'ws://127.0.0.1:15100/event/' # Үйл явдал авах
#EVENT_DAEMON_GET_SSL = 'wss://<your domain>/event/' # Optional
EVENT_DAEMON_POLL = '/channels/' # сувгийн нэвтрүүлэг

# If you would like to use the AMQP-based event server from <https://github.com/DMOJ/event-server>,
# uncomment this section instead. This is more involved, and recommended to be done
# only after you have a working event server.
#EVENT_DAEMON_AMQP = '<amqp:// URL to connect to, including username and password>'
#EVENT_DAEMON_AMQP_EXCHANGE = '<AMQP exchange to use>'

## celery мессежийн дарааллын үйлчилгээ, тайлбарыг устгах шаардлагатай

CELERY_BROKER_URL = 'redis://127.0.0.1:6379' 
CELERY_RESULT_BACKEND = 'redis://127.0.0.1:6379'

## CDN control.
# Base URL for a copy of ace editor.
# Should contain ace.js, along with mode-*.js.
ACE_URL = '//cdnjs.cloudflare.com/ajax/libs/ace/1.2.3/'
JQUERY_JS = '//cdnjs.cloudflare.com/ajax/libs/jquery/2.2.4/jquery.min.js'
SELECT2_JS_URL = '//cdnjs.cloudflare.com/ajax/libs/select2/4.0.3/js/select2.min.js'
SELECT2_CSS_URL = '//cdnjs.cloudflare.com/ajax/libs/select2/4.0.3/css/select2.min.css'

# A map of Earth in Equirectangular projection, for timezone selection.
# Please try not to hotlink this poor site.
TIMEZONE_MAP = 'http://naturalearth.springercarto.com/ne3_data/8192/textures/3_no_ice_clouds_8k.jpg'

## Camo (https://github.com/atmos/camo) usage.
#DMOJ_CAMO_URL = "<URL to your camo install>"
#DMOJ_CAMO_KEY = "<The CAMO_KEY environmental variable you used>"

# Domains to exclude from being camo'd.
#DMOJ_CAMO_EXCLUDE = ("https://dmoj.ml", "https://dmoj.ca")

# Set to True to use https when dealing with protocol-relative URLs.
# See <http://www.paulirish.com/2010/the-protocol-relative-url/> for what they are.
#DMOJ_CAMO_HTTPS = False

# HTTPS level. Affects <link rel='canonical'> elements generated.
# Set to 0 to make http URLs canonical.
# Set to 1 to make the currently used protocol canonical.
# Set to 2 to make https URLs canonical.
#DMOJ_HTTPS = 0

## PDF rendering settings.
# Directory to cache the PDF.
#DMOJ_PDF_PROBLEM_CACHE = '/home/dmoj-uwsgi/pdfcache'

# Path to use for nginx's X-Accel-Redirect feature.
# Should be an internal location mapped to the above directory.
#DMOJ_PDF_PROBLEM_INTERNAL = '/pdfcache'

# Enable Selenium PDF generation
#USE_SELENIUM = True

## Data download settings.
# Uncomment to allow users to download their data
#DMOJ_USER_DATA_DOWNLOAD = True

# Directory to cache user data downloads.
# It is the administrator's responsibility to clean up old files.
#DMOJ_USER_DATA_CACHE = '/home/dmoj-uwsgi/datacache'

# Path to use for nginx's X-Accel-Redirect feature.
# Should be an internal location mapped to the above directory.
#DMOJ_USER_DATA_INTERNAL = '/datacache'
# How often a user can download their data.
#DMOJ_USER_DATA_DOWNLOAD_RATELIMIT = datetime.timedelta(days=1)


## ======== Logging Settings ========
# Documentation: https://docs.djangoproject.com/en/1.9/ref/settings/#logging
#                https://docs.python.org/2/library/logging.config.html#logging-config-dictschema
LOGGING = {
    'version': 1,
    'disable_existing_loggers': False,
    'formatters': {
        'file': {
            'format': '%(levelname)s %(asctime)s %(module)s %(message)s',
        },
        'simple': {
            'format': '%(levelname)s %(message)s',
        },
    },
    'handlers': {
        # You may use this handler as example for logging to other files..
        'bridge': {
            'level': 'INFO',
            'class': 'logging.handlers.RotatingFileHandler',
            'filename': '<desired bridge log path>',
            'maxBytes': 10 * 1024 * 1024,
            'backupCount': 10,
            'formatter': 'file',
        },
        'mail_admins': {
            'level': 'ERROR',
            'class': 'dmoj.throttle_mail.ThrottledEmailHandler',
        },
        'console': {
            'level': 'DEBUG',
            'class': 'logging.StreamHandler',
            'formatter': 'file',
        },
    },
    'loggers': {
        # Site 500 error mails.
        'django.request': {
            'handlers': ['mail_admins'],
            'level': 'ERROR',
            'propagate': False,
        },
        # Judging logs as received by bridged.
        'judge.bridge': {
            'handlers': ['bridge', 'mail_admins'],
            'level': 'INFO',
            'propagate': True,
        },
        # Catch all log to stderr.
        '': {
            'handlers': ['console'],
        },
        # Other loggers of interest. Configure at will.
        #  - judge.user: logs naughty user behaviours.
        #  - judge.problem.pdf: PDF generation log.
        #  - judge.html: HTML parsing errors when processing problem statements etc.
        #  - judge.mail.activate: logs for the reply to activate feature.
        #  - event_socket_server
    },
}

## ======== Integration Settings ========
## Python Social Auth
# Documentation: https://python-social-auth.readthedocs.io/en/latest/
# You can define these to enable authentication through the following services.
#SOCIAL_AUTH_GOOGLE_OAUTH2_KEY = ''
#SOCIAL_AUTH_GOOGLE_OAUTH2_SECRET = ''
#SOCIAL_AUTH_FACEBOOK_KEY = ''
#SOCIAL_AUTH_FACEBOOK_SECRET = ''
#SOCIAL_AUTH_GITHUB_SECURE_KEY = ''
#SOCIAL_AUTH_GITHUB_SECURE_SECRET = ''
#SOCIAL_AUTH_DROPBOX_OAUTH2_KEY = ''
#SOCIAL_AUTH_DROPBOX_OAUTH2_SECRET = ''

## ======== Custom Configuration ========
# You may add whatever django configuration you would like here.
# Do try to keep it separate so you can quickly patch in new settings.
```

Хэрвээ FileZilla -аар өгөгдөл дамжуулж байвал тухайн фолдер дотор мэдээлэл өөрчлөх эрхийг олгох ёстой. Олгохдоо root эрхээр орж олгох хэрэгэй

```
sudo su
chmod 777 -R site/
```

Энэ алхамд та зөвхөн програмын түлхүүр, өгөгдлийн сангийн нууц үг, хэл, цагийн бүс, сайтын үндсэн мэдээллийг өөрчлөх шаардлагатай бөгөөд бусад Хятад тэмдэглэсэн газруудыг дараагийн алхмуудад өөрчлөх боломжтой. Өөрчлөлт хийж дууссаны дараа баталгаажуулахын тулд дараах тушаалыг гүйцэтгэнэ.

```
python3 manage.py check

```

Статик файл үүсгэх

Энэ алхам нь /tmp/static/ сан дахь төсөлд шаардлагатай статик файлуудыг үүсгэж оновчтой болгоно.

```
./make_style.sh
python3 manage.py collectstatic
python3 manage.py compilemessages
python3 manage.py compilejsi18n

```
Өгөгдлийн сангийн хүснэгтийг импортлох


```
# Бүх хүснэгтийг шилжүүлэх
python3 manage.py migrate

# Туршилтын өгөгдөл болон тохиргоог импортлох
python3 manage.py loaddata navbar
python3 manage.py loaddata language_small
python3 manage.py loaddata demo

# Администратор хэрэглэгч үүсгэх, та хэрэглэгчийн нэр, имэйл, нууц үг оруулах шаардлагатай
python3 manage.py createsuperuser

```

Celery
```
# redis ийг эхлүүлэх
sudo service redis-server start

# Төслийн тохиргооны файл дахь Celery тохиргооноос тайлбарыг устгаж үр дүнтэй болгох

# Төслийн үндсэн кодыг турших
python3 manage.py runserver 0.0.0.0:8000

# Өмнөх алхмыг амжилттай гүйцэтгэсний дараа төлөвлөгчийг ажиллуул, хэрэв арван секундын дотор цуурай гарахгүй бол ctrl+c зогсоно.
python3 manage.py runbridged

# Celery даалгаврын дарааллыг ажиллуул, ямар ч алдаа байхгүй
pip3 install redis
celery -A dmoj_celery worker

```

# uwsgi-г тохируулах

Бидний мэдэж байгаагаар uwsgi бол Python вэб төслүүдийн урт хугацааны туршид хэрэгжих хэрэгсэл юм. Энд байгаа тохиргооны файлыг сайтын лавлахад байрлуулсан бөгөөд албан ёсны татаж авах хаяг бөгөөд миний өгсөн тохиргооны файлыг бас ашиглаж болно.

```
[uwsgi]
# Socket and pid file location/permission.
uwsgi-socket = /tmp/dmoj-site.sock
chmod-socket = 666
pidfile = /tmp/dmoj-site.pid

# You should create an account dedicated to running dmoj under uwsgi.
#uid = dmoj-uwsgi
#gid = dmoj-uwsgi

# Paths.
chdir = /home/bd/site
pythonpath = /home/bd/site
virtualenv = /home/bd/venv

# Details regarding DMOJ application.
protocol = uwsgi
master = true
env = DJANGO_SETTINGS_MODULE=dmoj.settings
module = dmoj.wsgi:application
optimize = 2

# Scaling settings. Tune as you like.
memory-report = true
cheaper-algo = backlog
cheaper = 3
cheaper-initial = 5
cheaper-step = 1
cheaper-rss-limit-soft = 201326592
cheaper-rss-limit-hard = 234881024
workers = 7

```


```
# хамаарлыг суулгах
pip3 install uwsgi

# Тохиргооны файл хүчинтэй эсэхийг шалгана уу
uwsgi --ini uwsgi.ini

```

Гүйцэтгэсэн командын цуурайг эндээс шалгана уу, ямар ч алдаа мэдээлээгүй бөгөөд ажилчдыг хэвийн ажиллуулж болно. Энэ нь бүрэн үр дүнтэй эсэхийг шалгахын тулд nginx-ийн дараагийн тохиргоог хүлээх хэрэгтэй.


Үнэн хэрэгтээ дээрх алхмууд нь Mysql мэдээллийн сан, uwsgi ажиллаж байгаа төслийн үндсэн код, ажлын дараалал Celery, Bridged ажлын хуваарь зэрэг DMOJ-ийн маш чухал хэд хэдэн хэсгүүдийг суулгаж дуусгасан. Гэхдээ мэдээллийн сан нь үргэлж ар талд хадгалагддагаас бусад гурван зүйл нь урд талд ажилладаг тул та тэдгээрийг арын дэвсгэр дээр удирдахын тулд супервайзер ашиглах хэрэгтэй.


```
# supervisord суулгах
sudo apt install supervisor -y

```


Суулгаж дууссаны дараа дараах гурван тохиргооны файлыг /etc/supervisor/conf.d/ файлын санд байрлуулна. Хэрэглэгчийн зөвшөөрөл болон фолдерын зөвшөөрлөөс шалтгаалж ажиллахад алдаа гарахаас зайлсхийхийн тулд програмыг энд ажиллуулах анхны хэрэглэгчээр тохируулсан.


Тохиргооны хэсгийг root эрхээр орж тохируулна.



```sudo nano /etc/supervisor/conf.d/site.conf```

```
[program:site]
command=/home/bd/venv/bin/uwsgi --ini uwsgi.ini
directory=/home/bd/site
stopsignal=QUIT
stdout_logfile=/tmp/site.stdout.log
stderr_logfile=/tmp/site.stderr.log

```

---
bridged.conf -ийн тохиргоо
---
```sudo nano /etc/supervisor/conf.d/bridged.conf```

```
[program:bridged]
command=/home/bd/venv/bin/python manage.py runbridged
directory=/home/bd/site
stopsignal=INT
# You should create a dedicated user for the bridged to run under.
user=bd
group=root
stdout_logfile=/tmp/bridge.stdout.log
stderr_logfile=/tmp/bridge.stderr.log

```

Celery.conf

```sudo nano /etc/supervisor/conf.d/celery.conf```

---

```
[program:celery]
command=/home/bd/venv/bin/celery -A dmoj_celery worker
directory=/home/bd/site
# You should create a dedicated user for celery to run under.
user=bd
group=root
stdout_logfile=/tmp/celery.stdout.log
stderr_logfile=/tmp/celery.stderr.log

```

### Удирдах ажилтны хяналтын жагсаалтыг шинэчилж, статусыг асуугаарай, гэхдээ бүх ажил хэвийн байна
```

sudo supervisorctl update
sudo supervisorctl status

```
### nginx  -ийг суулгаж тохируулах

```
# nginx суулгах
sudo apt install nginx -y

```

/etc/nginx/sites-available/default-г устгаад ижил нэртэй шинэ файл үүсгээд дараах агуулгыг бөглөнө үү.

```sudo nano /etc/nginx/sites-available/default```

```
server {
    listen       80;
    listen       [::]:80;

    # Change port to 443 and do the nginx ssl stuff if you want it.

    # Change server name to the HTTP hostname you are using.
    # You may also make this the default server by listening with default_server,
    # if you disable the default nginx server declared.
    server_name 127.0.0.1;

    add_header X-UA-Compatible "IE=Edge,chrome=1";
    add_header X-Content-Type-Options nosniff;
    add_header X-XSS-Protection "1; mode=block";

    charset utf-8;
    try_files $uri @icons;
    error_page 502 504 /502.html;

    location ~ ^/502\.html$|^/logo\.png$|^/robots\.txt$ {
        root /home/bd/site;
    }

    location @icons {
        root /home/bd/site/resources/icons;
        error_page 403 = @uwsgi;
        error_page 404 = @uwsgi;
    }

    location @uwsgi {
        uwsgi_read_timeout 600;
        # Change this path if you did so in uwsgi.ini
        uwsgi_pass unix:///tmp/dmoj-site.sock;
        include uwsgi_params;
        uwsgi_param SERVER_SOFTWARE nginx/$nginx_version;
    }

    location /static {
        gzip_static on;
        expires max;
        #root <django setting STATIC_ROOT, without the final /static>;
        # Comment out root, and use the following if it doesn't end in /static.
        alias /tmp/static/; 
    }

    # Uncomment if you are using PDFs and want to serve it faster.
    # This location name should be set to DMOJ_PDF_PROBLEM_INTERNAL.
    #location /pdfcache {
    #    internal;
    #    root <the value of DMOJ_PDF_PROBLEM_CACHE in local_settings.py>;
    #    # Default from docs:
    #    #root /home/dmoj-uwsgi/;
    #}

    # Uncomment if you are allowing user data downloads and want to serve it faster.
    # This location name should be set to DMOJ_USER_DATA_INTERNAL.
    #location /datacache {
    #    internal;
    #    root <path to data cache directory, without the final /datacache>;
    #    # Default from docs:
    #    #root /home/dmoj-uwsgi/;
    #}

    # Uncomment these sections if you are using the event server.
    location /event/ {
        proxy_pass http://127.0.0.1:15100/;
        proxy_http_version 1.1;
        proxy_set_header Upgrade $http_upgrade;
        proxy_set_header Connection "upgrade";
        proxy_read_timeout 86400;
    }

    location /channels/ {
        proxy_read_timeout          120;
        proxy_pass http://127.0.0.1:15102;
    }
}

```



```
# Nginx тохиргооны файлыг туршиж үзээд дахин эхлүүлэх
sudo nginx -t
sudo nginx -s reload


```

### event тохиргоо

Дараах контент бүхий шинэ site/websocket/config.js файл үүсгэнэ үү. Мөн энэ файлын дагуу nginx тохиргооны файл дахь үйл явдал, сувгийн холбогдох портуудыг өөрчил. Үүний зэрэгцээ local_setting.py файл дахь EVENT_DAEMON_POST, EVENT_DAEMON_GET болон EVENT_DAEMON_POLL гэсэн гурван хувьсагчийн утгыг өөрчил.

```websocket/config.js```

```
module.exports = {
    get_host: '127.0.0.1',
    get_port: 15100,
    post_host: '127.0.0.1',
    post_port: 15101,
    http_host: '127.0.0.1',
    http_port: 15102,
    long_poll_timeout: 29000,
};


```



```

# ws хамаарлыг суулгана
npm install qu ws simplesets
pip3 install websocket-client

# Өөрчлөгдсөн тохиргоог хүчин төгөлдөр болгохын тулд програмыг дахин эхлүүлнэ үү
sudo supervisorctl status
sudo supervisorctl update
sudo supervisorctl restart bridged
sudo supervisorctl restart site
sudo nginx -s reload


```


# judge серверийг суулгана уу
Шүүлтийн арын хэсгийг суулгана уу


```

sudo apt install python3-dev python3-pip build-essential libseccomp-dev -y
pip3 install dmoj


```

Шүүлтийн систем нь шүүлтийн хэлийг дэмждэг


```
dmoj-autoconf # Гүйцэтгэлийн дараа дэмжигдсэн ажиллах хугацаа хэвлэгдэх болно

# Шинээр үүсгэсэн judge.yml файлын ажиллах цагийн хэсэг рүү дөнгөж хэвлэсэн ажиллах цагийг хуулна
# Энд байгаа id болон түлхүүрийн тохиргоо нь арын удирдлагын интерфейс дэх шүүлтийн серверийн тохиргоотой нийцэж болно.
id: <judge name>
key: <judge authentication key>
problem_storage_root:
  - /home/ubunut/problem
runtime:
  ...



```

supervisord тохиргоо




```
# judge.conf
[program:judge]
command=/home/ubuntu/dmojsite/bin/dmoj -c judge.yml localhost
directory=/home/ubuntu/site/
stopsignal=QUIT
stdout_logfile=/tmp/site.stdout.log
stderr_logfile=/tmp/site.stderr.log

```


Тохиргоог шинэчилж, хүчин төгөлдөр болохын тулд sudo supervisord шинэчлэлтийг ашиглан шүүлтийн серверийн онлайн статус арын удирдлагын интерфейс дээр онлайн байгааг олж мэдээрэй.


Баталгаажуулалт, дүгнэлт

   Энэ үед DMOJ-г суулгаж дуусна. Суулгах процессын үүднээс авч үзвэл OJ систем нь маш олон бүрэлдэхүүн хэсгүүдийг агуулдаг бөгөөд янз бүрийн тохиргоонууд нь нааш цааш өөрчлөгддөг.Хүмүүс санамсаргүйгээр тодорхой тохиргоог орхиж, програмыг хэвийн ажиллуулах боломжгүй болгодог. Мэдээж туршилтын явцад хэвийн ажиллаж болох ч supervisord болон nginx ашигласны дараа гэнэт ажиллахгүй. Дадлага хийх явцад, хэрэглэгчдийн өгсөн албан ёсны өөр өөр програмууд нь файлын зөвшөөрөл хангалтгүй, улмаар програм ажиллах боломжгүй болж магадгүй гэсэн асуудал надад гүн гүнзгий санагдаж байна. Удаан хугацаанд шидсэний эцэст аль алхмууд нь дутуу эсвэл файлын зам буруу байгааг олж мэдэхээ больсон.Дараа нь төслийн үндсэн лавлах нь гүйцэтгэх зөвшөөрөлгүй байсныг олж мэдсэн бөгөөд энэ нь хэд хэдэн асуудал үүсгэх болно. Хэрэв та хэрэглэгчийн удирдлага, файлын зөвшөөрлийн аюулгүй байдлын менежментийн талаар сайн ойлголттой бол түүнийг тохируулах албан ёсны практикийг дагаж мөрдөх ёстой бөгөөд энэ нь үйлдлийн системийн аюулгүй байдлыг хангаж чадна.

















# Node -ийн орчин суулгах

```
apt-get install curl gnupg2 -y
curl https://raw.githubusercontent.com/creationix/nvm/master/install.sh | bash

```


Now, activate all settings using the following command:

```
source ~/.bashrc

nvm --version
nvm install node
node --version
nvm install node --lts
nvm install 14.19.1
node --version
nvm ls
nvm ls-remote
nvm use 14.19.1
nvm run default --version

```





# Удирдах командууд

```
netstat -tulnp | grep LISTEN

```