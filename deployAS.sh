#get the branch name: customer/20190609, release/1.1.14
echo Enter the branch:

read varname

#copy existing prod config file and keep
yes | cp -rf appserver/config/mvne.js appserver/config/mvne.js.prod

#reset the git
#pull
#checkout to given version
eval $(ssh-agent -s)
ipt-mq | ssh-add ~/.ssh/ipt-mq
git reset --hard
git pull
git checkout -f $varname
git branch -l
echo $varname
#install npm packages, do config changes in the app
cd appserver
sudo npm install
yes | cp -rf config/mvne.js.prod config/mvne.js

#db migrate
/usr/local/bin/knex migrate:latest

#delete pm2 and start
/usr/local/bin/pm2 delete 0
/usr/local/bin/pm2 start app.json
#/usr/local/bin/pm2 start server.js --log-date-format 'DD-MM HH:mm:ss.SSS'

#verify
curl http://localhost:3333