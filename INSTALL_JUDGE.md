<details open>
<summary>1. Үйлдлийн систем, тохиргоо</summary>


### Ubuntu server 22.04 суулгана.

<ins>Docker, docker-compose  суулгах. </ins>
```
sudo apt update
sudo apt install make
sudo snap install docker 

```

### Шинээр суулгасан ubuntu сервер дээр дахаар тохиргоог хийнэ.

<ins>git -ээс татаж авах</ins>
```
git clone --recursive https://github.com/DMOJ/judge.git
cd judge/.docker
sudo make judge-tier1
```

</details>

---
<details>
<summary> 2. Тохиргоо хийх</summary>


<ins>judge.yml ийн тохиргоо </ins>
```
sudo docker run \
    --name judge \
    -p 192.168.1.203:9999:9999 \
    -v /mnt/problems:/problems \
    --cap-add=SYS_PTRACE \
    -d \
    --restart=always \
    dmoj/judge-tier1:latest \
    run -p 9999 -c /problems/judge.yml \
    192.168.1.203 "mainjudge" "OqbTrN88TVYGYziIirKmklwNIjdIad88X5knogLSUOVCMFKRZ+xm5WPh78ImmNNXEHNBhYrD6S9F4HUroDulm9ONyFKEy3m8tNkS"
	
```



<ins>judge.yml ийн тохиргоо </ins>
```
sudo docker run \
    --name judge2 \
    -p 127.0.0.1:9998:9998 \
    -v /mnt/problems:/problems \
    --cap-add=SYS_PTRACE \
    -d \
    --restart=always \
    dmoj/judge-tier2:latest \
    run -p 9999 -c /problems/judge2.yml \
    127.0.0.1 "tier2" "hkNhKXtYWu3ijeieJSXYNqI1ZvnneLK9cnp8jiX/2OVDuMS1WU6NaHUQKk9Z9lYUYg9Idurohs3irF5O3p9YwNkKbz7AnY7CmrjI"
	
```