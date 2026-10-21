override_file=$(cat ./scripts/parameter-overrides/.overrides)
set -f 
IFS='
' 

overrides_split=($(cat ./scripts/parameter-overrides/.overrides))

for i in "${overrides_split[@]}"
do
    key=$(echo "$i" | awk -F= '{print $1}')
    value=$(echo "$i" | awk -F= '{print $2}' | sed 's/"//g')
    echo "$key=$value"
done

unset IFS
set +f
