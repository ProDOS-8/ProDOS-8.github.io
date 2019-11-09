st _includes/topbar.html _pages/releases/prodos-25.md _data/navigation.yml

read -p "When finished with update, press RETURN to run jekyll build and s3_website push"

jekyll build

s3_website push

