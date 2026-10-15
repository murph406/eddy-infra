echo "" >> scripts/parameter-overrides/.overrides

array=(
  Stage
  Project
  ApiGatewayUrl
)

for i in "${array[@]}"
do
    NAME=$(echo "$i")
    VAL=$(eval echo \${$i})
    echo "${NAME}=\"${VAL}\"" >> scripts/parameter-overrides/.overrides
done