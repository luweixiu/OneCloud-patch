# 此仓库使用方法
```shell
git clone https://github.com/luweixiu/OneCloud-patch -b main 
```
# 添加mosdns插件

  * requires golang 1.25.x or latest version
  ```shell
  rm -rf feeds/packages/lang/golang
  git clone https://github.com/sbwml/packages_lang_golang -b 26.x feeds/packages/lang/golang
  ```

  ```shell
  # remove v2ray-geodata package from feeds
  rm -rf feeds/packages/net/v2ray-geodata

  git clone https://github.com/sbwml/luci-app-mosdns -b v5 package/mosdns
  git clone https://github.com/sbwml/v2ray-geodata package/v2ray-geodata

  make menuconfig # choose LUCI -> Applications -> luci-app-mosdns
  make package/mosdns/luci-app-mosdns/compile V=s
  ```
