for d in $(echo "SHOW DATABASES" | mysql | egrep -v "(mysql|Database|information_schema|performance_schema)"); do
    n="$d-$(date +%s).sql"
    echo -n "$d " && mysqldump -r $n $d && echo -n '.' && bzip2 $n && echo '.'
done
