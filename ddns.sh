
export CF_Key="xxx"
export CF_Email="xxx"

domain_name="$1"
if [ "$2" == "A" ]; then
    ip_address=$(curl -sL "https://ipv4.ping0.cc")
    record_type=A
else
    ip_address=$(curl -sL "https://ipv6.ping0.cc")
    record_type=AAAA
fi

echo "$(date)" >> $(pwd)/ddns.log

echo "IP地址  $ip_address" >> $(pwd)/ddns.log
echo "域名  $domain_name" >> $(pwd)/ddns.log

curl_head=(
    "X-Auth-Email: ${CF_Email}"
    "X-Auth-Key: ${CF_Key}"
    "Content-Type: application/json"
)

# 尝试使用完整的域名获取 zone_id
zone_id=$(curl -sS --request GET "https://api.cloudflare.com/client/v4/zones?name=$domain_name" --header "${curl_head[0]}" --header "${curl_head[1]}" --header "${curl_head[2]}" | jq -r '.result[0].id')

# 如果失败，移除域名的第一部分并重试
if [ "$zone_id" == "null" ] || [ -z "$zone_id" ]; then
    # 移除域名的第一部分
    zone1_domain_name="${domain_name#*.}"
    # 使用新的域名再次尝试获取 zone_id
    zone_id=$(curl -sS --request GET "https://api.cloudflare.com/client/v4/zones?name=$zone1_domain_name" --header "${curl_head[0]}" --header "${curl_head[1]}" --header "${curl_head[2]}" | jq -r '.result[0].id')
fi

echo "zoneID  $zone_id" >> $(pwd)/ddns.log

# 查找现有记录的ID
record_id=$(curl -s -X GET "https://api.cloudflare.com/client/v4/zones/$zone_id/dns_records?name=$domain_name" \
-H "X-Auth-Email: $CF_Email" \
-H "X-Auth-Key: $CF_Key" \
-H "Content-Type: application/json" | jq -r '.result[0].id')

# 检查 record_id 是否有效
if [ "$record_id" == "null" ]; then
  echo "没有找到记录ID。" >> $(pwd)/ddns.log
  exit 1
fi

echo "记录ID  $record_id" >> $(pwd)/ddns.log

# 更新记录
response=$(curl -s -X PUT "https://api.cloudflare.com/client/v4/zones/$zone_id/dns_records/$record_id" \
-H "X-Auth-Email: $CF_Email" \
-H "X-Auth-Key: $CF_Key" \
-H "Content-Type: application/json" \
--data "{\"type\":\"$record_type\",\"name\":\"$domain_name\",\"content\":\"$ip_address\",\"ttl\":1,\"proxied\":false}")

# 检查更新是否成功
if echo "$response" | jq .success | grep -q true; then
  echo "记录更新成功。" >> $(pwd)/ddns.log
else
  echo "记录更新失败。" >> $(pwd)/ddns.log
  echo "错误信息：" $(echo "$response" | jq .errors) >> $(pwd)/ddns.log
fi

