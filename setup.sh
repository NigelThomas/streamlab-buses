# setup.sh
HERE=$(cd `dirname $0`; pwd -P)

echo Setting up project $PROJECT_NAME in directory $HERE

cd $HERE
echo ... extract the SQL scripts needed from $HERE/${PROJECT_NAME}.slab

for script in main start stop
do
    echo ... ... extracting ${PROJECT_NAME}.${script}.sql
    cat ${PROJECT_NAME}.slab | jq -r ".projectModel.${script}Script" | sed -e 's/^!/-- /' > ${PROJECT_NAME}.${script}.sql
done

echo ... adjusting ${PROJECT_NAME}.main.sql
# workaround because schema may not be created at start
# also remove DROP commands

grep "CREATE OR REPLACE SCHEMA" ${PROJECT_NAME}.main.sql | uniq > /tmp/${PROJECT_NAME}.main.sql
grep -v DROP ${PROJECT_NAME}.main.sql >> /tmp/${PROJECT_NAME}.main.sql
mv /tmp/${PROJECT_NAME}.main.sql  ./${PROJECT_NAME}.main.sql


sqllineClient --run=${PROJECT_NAME}.main.sql

echo ... extracting StreamLab dashboards if any
mkdir -p /home/sqlstream/${PROJECT_NAME}/dashboards 2>/dev/null
cd dashboards

cat ../${PROJECT_NAME}.slab | jq -cr '.dashboards | keys[] as $k | "\($k)\n\(.[$k])"' | while read -r key
do
    fname=$(cat ../${PROJECT_NAME}.slab | jq --raw-output ".dashboards | .[$key].coll + \"-\" + .[$key].dash")
    read -r item
    printf '%s\n' "$item" | jq -r --indent 4 '.dashModel' > "./$fname.json"
    echo ... ... dashboard $fname extracted
done

