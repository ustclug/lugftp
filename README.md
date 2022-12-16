# FTP site of USTC LUG

## Feature

* Public Sharing
* Private uploading
* User's home (auth via LDAP)

## Supported Protocol

* HTTP/HTTPS (read only)
* FTP
* FTPS
* SFTP
* ~~AFP~~ AFP support has been removed.

## Deployment

```shell
docker run -itd --restart=always \
    -p 20-22:20-22 \
    -p 80:80 \
    -p 40000-40050:40000-40050 \
    -v $LOCAL_DIR/data:/srv/ftp \
    -v $LOCAL_DIR/log:/var/log \
    -v $LOCAL_DIR/home:/home \
    -e PRIVATE_PASSWD=secret \
    -e PASV_ADDRESS=$PUBLIC_IP_ADDRESS \
    ustclug/ftp
```

Security note: Please bind mount `/etc/ssh` (`-v $LOCAL_DIR/ssh:/etc/ssh`) in production, as the container image has its own host SSH keypair public and may gets middle-man attack.

### Available Environment Variables

| Name             | Implication                              | Default Value |
| ---------------- | ---------------------------------------- | ------------- |
| PUBLIC_PASSWD    | Password of public account "ftp" (read only) | ftp           |
| PRIVATE_USERNAME | Private account name (write access)      | lug           |
| PRIVATE_PASSWD   | Password of private account              | password      |
| PASV_ADDRESS     | FTP PASV Mode Address                    | 127.0.0.1     |

