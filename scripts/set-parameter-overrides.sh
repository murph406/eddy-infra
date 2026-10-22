echo "" >> scripts/.overrides

array=(
  Stage
  Project
  ApiGatewayUrl
)

for i in "${array[@]}"
do
    NAME=$(echo "$i")
    VAL=$(eval echo \${$i})
    echo "${NAME}=\"${VAL}\"" >> scripts/.overrides
done