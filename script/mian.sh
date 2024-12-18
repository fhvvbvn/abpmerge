#!/bin/sh

# 下载规则
curl -o i-1.txt https://filters.adtidy.org/ios/filters/3_optimized.txt
curl -o i-2.txt https://filters.adtidy.org/ios/filters/2_optimized.txt
curl -o i-3.txt https://filters.adtidy.org/extension/ublock/filters/14.txt
curl -o i-4.txt https://cdn.jsdelivr.net/gh/uBlockOrigin/uAssetsCDN@main/filters/filters.min.txt
curl -o i-5.txt https://ublockorigin.pages.dev/filters/privacy.min.txt

# 合并规则并去除重复项
cat i*.txt > i-mergd.txt
cat i-mergd.txt | grep -v '^!' | grep -v '^！' | grep -v '^# ' | grep -v '^# ' | grep -v '^\[' | grep -v '^@@' > i-tmpp.txt
sort -n i-tmpp.txt | uniq > i-tmp.txt

python rule.py i-tmp.txt

# 计算规则数
num=`cat i-tmp.txt | wc -l`

# 添加标题和时间
echo "[Adblock Plus 2.0]" >> i-tpdate.txt
echo "! Title: Scriptlet Rules" >> i-tpdate.txt
echo "! Version: `TZ=UTC-8 date +"%Y-%m-%d %H:%M:%S"`" >> i-tpdate.txt
echo "! Total count: $num" >> i-tpdate.txt
cat i-tpdate.txt i-tmp.txt > abpmerge.txt

cat "abpmerge.txt" | grep \
-e "scriptlet" \
-e "##+js" \
-e "!" \
> "scriptlet.txt"

# 删除缓存
rm i-*.txt

#退出程序
exit
