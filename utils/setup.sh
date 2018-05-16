#!/bin/bash

read -p "Enter project name: " appname

git clone https://github.com/RubyFireStudio/phoenix-react-project-template $appname
cd $appname

echo "Set up $appname..."
grep -rl Reanix | xargs sed -i s@Reanix@$appname@g
grep --exclude={package.json,yarn.lock,.babelrc} -rl reanix | xargs sed -i s@reanix@$appname@g
find . -depth -exec rename 's/reanix/$appname/g' {} \; 

echo "Init git..."
rm -rf .git
git init
git add priv/static/favicon.ico -f
git add priv/static/images/phoenix.png -f

echo "Prepare backend ..."
mix deps.get
mix ecto.create
mix ecto.migrate

echo "Prepare frontend..."
(cd assets && yarn install)

echo "Complete."
echo
echo "Predefined admin user:"
echo "username: amdin"
echo "email: admin@admin.com"
echo "password: 12345678"
echo
echo "Ready to lanuch. Use the command:"
echo
echo "mix phx.server"
echo