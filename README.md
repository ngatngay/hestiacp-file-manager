# HestiaCP File Manager

Thiết kế cho người dùng `root`

## Cấu hình

`IP` là địa chỉ ip vps của bạn.

```
nano /etc/apache2/conf.d/[IP].conf
```

Thêm dòng sau trên `</VirtualHost>` (có bao nhiêu thêm hết)

```
IncludeOptional /etc/apache2/conf.d/*.inc
```

## Cài đặt

```
bash <(curl -s https://raw.githubusercontent.com/ngatngay/hestiacp-file-manager/main/hst-file-manager.sh)
```

Truy cập:
- `[IP]/manager`
- `domain.com/manager` nếu có hostname.
