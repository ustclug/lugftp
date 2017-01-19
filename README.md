# FTP site of USTC LUG

## Feature

* Public Sharing
* Private uploading
* User's home (auth via LDAP)

## Supported Protocol

* HTTP/HTTPS (read only)
* FTP
* SFTP
* AFP

## Deployment

```shell
docker run -itd --restart=always \
    -p 20-22:20-22 \
    -p 80:80 \
	-p 548:548 \
    -p 40000-40050:40000-40050 \
    -v $LOCAL_DIR/data:/srv/ftp \
    -v $LOCAL_DIR/log:/var/log \
    -v $LOCAL_DIR/netatalk:/usr/var/netatalk \
    -v $LOCAL_DIR/home:/home \
    -e PRIVATE_PASSWD=secret \
    -e PASV_ADDRESS=$PUBLIC_IP_ADDRESS \
    ustclug/ftp
```

### Available Environment Variables

| Name             | Implication                              | Default Value |
| ---------------- | ---------------------------------------- | ------------- |
| PUBLIC_PASSWD    | Password of public account "ftp" (read only) | ftp           |
| PRIVATE_USERNAME | Private account name (write access)      | lug           |
| PRIVATE_PASSWD   | Password of private account              | password      |
| PASV_ADDRESS     | FTP PASV Mode Address                    | 127.0.0.1     |

## Usage

### AFP

1. Open "Finder"
2. In menu bar: ”GO” -> “Connect to Server” （Short Cut ⌘+K）
3. Server Address：`afp://ftp.ustclug.org/`
4. Connect
5. Connect As: Guest（or Registered User with credential） 
6. Enjoy
