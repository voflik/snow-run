if [[ -z ${snow_instance} ]];
then
    echo Set snow_instance ENV variable to something like dev123.service-now.com first! >&2
    exit
fi

echo -n User:
read user
echo -n Password:
read -s password

my_dir=$(dirname $0)
source $my_dir/env.sh

export login_token=$($my_dir/_get-sysparm_ck.sh)

if [[ -z $login_token ]]
then
  echo "Could not obtain login token to access service-now instance $snow_instance" >&2
  exit
fi;

curl https://${snow_instance}/login.do -b $SNOW_COOKIE_FILE --data "sysparm_ck=$login_token&user_name=$user&user_password=$password&ni.nolog.user_password=true&ni.noecho.user_name=true&ni.noecho.user_password=true&screensize=1920x1080&sys_action=sysverb_login" --compressed --cookie-jar $SNOW_COOKIE_FILE 

status=$?
if [[ $status -ne 0 ]];
then
    echo "SNOW Login not successful. curl returned $status" >&2
fi