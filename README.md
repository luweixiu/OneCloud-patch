# OneCloud-patch
玩客云补丁

# 添加mosdns插件 remove v2ray-geodata package from feeds
rm -rf feeds/packages/net/v2ray-geodata

git clone https://github.com/sbwml/luci-app-mosdns -b v5 package/mosdns
git clone https://github.com/sbwml/v2ray-geodata package/v2ray-geodata
make menuconfig # choose LUCI -> Applications -> luci-app-mosdns
make package/mosdns/luci-app-mosdns/compile V=s
