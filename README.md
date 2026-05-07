## immortalwrt源码
```shell
git clone -b v24.10.6 --single-branch --filter=blob:none https://github.com/immortalwrt/immortalwrt

cd immortalwrt

./scripts/feeds update -a

curl -SL https://github.com/luweixiu/OneCloud-patch/archive/refs/heads/v1.tar.gz | tar -zx --strip-components=1

./scripts/feeds update -a

./scripts/feeds install -a -f

```

## 添加mosdns插件

* 需要 Go 语言 1.25.x 或更高版本
```shell
rm -rf feeds/packages/lang/golang
git clone https://github.com/sbwml/packages_lang_golang -b 26.x feeds/packages/lang/golang
```
* 从数据源中移除 v2ray-geodata 包。
```shell
rm -rf feeds/packages/net/v2ray-geodata
git clone https://github.com/sbwml/luci-app-mosdns -b v5 package/mosdns
git clone https://github.com/sbwml/v2ray-geodata package/v2ray-geodata
```

### 单独编译MmsDNS
```shell
make package/mosdns/luci-app-mosdns/compile V=s
```
