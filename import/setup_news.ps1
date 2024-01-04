
if (Test-Path "$env:USERPROFILE/data/news.ndjson" -PathType Leaf) {
  Write-Output "Card database already downloaded and extracted" 
}
else {
  Write-Output "Download news data from google drive"
  wget -O "$env:USERPROFILE/data/news.ndjson.gz" "https://drive.google.com/uc?id=1-3A7rU1QDWFbQnt4QTIge_7vfRaDMpKd&export=download&confirm=t&uuid=1b8625fb-98cb-4707-a18d-e395fe7a486a"

  Write-Output "Decompressing news data"
  gzip -d "$env:USERPROFILE/data/news.ndjson.gz"
}

docker run --rm `
  --network host `
  --env-file ../.env `
  -e XPACK_MONITORING_ENABLED=false `
  -v "$env:USERPROFILE/data:/data" `
  -v "${PWD}/logstash-news-v1.conf:/usr/share/logstash/logstash-news-v1.conf" `
  docker.elastic.co/logstash/logstash:8.9.2 `
  -f /usr/share/logstash/logstash-news-v1.conf
