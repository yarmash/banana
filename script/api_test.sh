#!/bin/bash

API_ENDPOINT="http://foodadvisor.ru/api"
CLIENT_ID=1
CLIENT_SECRET=7H8aV33pOit8Njf8HqWer81NPLM8aZd7
USER_ID=99
USERNAME=apitest
PASSWORD=0IVkssRZyG
#ACCESS_TOKEN=43a5d8380b3511e290a6b88008647b91
ACCESS_TOKEN=9a94bacc1c4911e29da3f19e08647b91
FB_ACCESS_TOKEN=AAAEL7zUtEdQBAEY2n3yDP0OB92OVJf61OurnQE8SVeOpRF2bda3tzV6ZA25EgupRZCAa4cwCwvFUXOoONcd51zzmLpuF5zhZBWnOX4kzwZDZD

AUTH_CLIENT=('-u' "$CLIENT_ID:$CLIENT_SECRET")
AUTH_TOKEN=('-H' "Authorization: Bearer $ACCESS_TOKEN")

CURL_OPTIONS=( '-H' 'Accept-Language: ru')

VERBOSE=0
TRACE=0

if [ $VERBOSE -eq "1" ]; then
    CURL_OPTIONS+=('-v')
fi

if [ $TRACE -eq "1" ]; then
    CURL_OPTIONS+=('--trace-ascii' '/dev/stdout')
fi

set -e

# Access token endpoint
curl "${CURL_OPTIONS[@]}" "${AUTH_CLIENT[@]}" -d "grant_type=password&username=$USERNAME&password=$PASSWORD" $API_ENDPOINT/login
echo

# Logout
#curl "${CURL_OPTIONS[@]}" "${AUTH_TOKEN[@]}" -X POST $API_ENDPOINT/logout
#echo

# Request password reset
#curl "${CURL_OPTIONS[@]}" "${AUTH_CLIENT[@]}" -d "login_or_email=doer@rambler.ru" "$API_ENDPOINT/user/resetPassword"
#echo

# Access token endpoint (via FB)
#curl "${CURL_OPTIONS[@]}" "${AUTH_CLIENT[@]}" -d fb_access_token=$FB_ACCESS_TOKEN $API_ENDPOINT/loginViaFB
#echo

# Register a new user
#curl "${CURL_OPTIONS[@]}" "${AUTH_CLIENT[@]}" -d "login=test1&password=test1234&full_name=Test1234&email=test@example.com" $API_ENDPOINT/user/register
#echo

# Conect user account to FB
#curl "${CURL_OPTIONS[@]}" "${AUTH_TOKEN[@]}" -d fb_access_token=$FB_ACCESS_TOKEN $API_ENDPOINT/user/connectFB
#echo

# Disconect user account from FB
#curl "${CURL_OPTIONS[@]}" "${AUTH_TOKEN[@]}" -X POST $API_ENDPOINT/user/disconnectFB
#echo

# Delete user
#curl "${CURL_OPTIONS[@]}" "${AUTH_TOKEN[@]}" -X POST $API_ENDPOINT/user/delete
#echo

# Get user profile
#curl "${CURL_OPTIONS[@]}" "${AUTH_TOKEN[@]}" "$API_ENDPOINT/user/profile?foo=bar"
#echo

# Update user profile
#curl "${CURL_OPTIONS[@]}" "${AUTH_TOKEN[@]}" --data-urlencode birthday= $API_ENDPOINT/user/update
#echo

# List countries
#curl "${CURL_OPTIONS[@]}" "${AUTH_TOKEN[@]}" $API_ENDPOINT/country/codes
#echo

# Search places
#curl "${CURL_OPTIONS[@]}" "${AUTH_TOKEN[@]}" "$API_ENDPOINT/place/search?q=bar"
#echo

# List cuisines
#curl "${CURL_OPTIONS[@]}" "${AUTH_TOKEN[@]}" "$API_ENDPOINT/cuisine/list"
#echo

# Add cuisine
#curl "${CURL_OPTIONS[@]}" "${AUTH_TOKEN[@]}" --data-urlencode "title=Сингапурская" $API_ENDPOINT/cuisine/add
#echo

# Delete cuisine
#curl "${CURL_OPTIONS[@]}" "${AUTH_TOKEN[@]}" -d cuisine_id=6 $API_ENDPOINT/cuisine/delete
#echo

# Search dishes
#curl "${CURL_OPTIONS[@]}" "${AUTH_TOKEN[@]}" "$API_ENDPOINT/dish/search?limit=18&order_by=likes_count&q="
#echo

# Update user avatar
#curl "${CURL_OPTIONS[@]}" "${AUTH_TOKEN[@]}" -F avatar=@/home/doer/avatars/gregory-house-face-palm.jpg $API_ENDPOINT/user/updateAvatar
#echo

# Change user password
#curl "${CURL_OPTIONS[@]}" "${AUTH_TOKEN[@]}" -d "new_password=v2X9zN7f3FRs&old_password=v2X9zN7f3FRs_" "$API_ENDPOINT/user/changePassword"
#echo

# Delete user avatar
#curl "${CURL_OPTIONS[@]}" "${AUTH_TOKEN[@]}" -X POST $API_ENDPOINT/user/deleteAvatar
#echo

# Add dish
#curl "${CURL_OPTIONS[@]}" "${AUTH_TOKEN[@]}" -F title=Cake -F place_id=14 -F cuisine_id=24 -F picture=@/home/doer/dishes/CranberryCake62.jpg $API_ENDPOINT/dish/add
#echo

# Delete a dish
#curl "${CURL_OPTIONS[@]}" "${AUTH_TOKEN[@]}" -d dish_id=277 $API_ENDPOINT/dish/delete
#echo

# Update dish
#curl "${CURL_OPTIONS[@]}" "${AUTH_TOKEN[@]}" -F title=Крендель -F place_id=14 -F dish_id=221 -F picture=@/home/doer/dishes/CranberryCake62.jpg $API_ENDPOINT/dish/update
#echo

# Get user followers
#curl "${CURL_OPTIONS[@]}" "${AUTH_TOKEN[@]}" "$API_ENDPOINT/user/followers?user_id=165"
#echo

# Get user followees
#curl "${CURL_OPTIONS[@]}" "${AUTH_TOKEN[@]}" $API_ENDPOINT/user/followees?user_id=87
#echo

# Follow a user
#curl "${CURL_OPTIONS[@]}" "${AUTH_TOKEN[@]}" -d "user_id=87" $API_ENDPOINT/user/follow
#echo

# Unfollow a user
#curl "${CURL_OPTIONS[@]}" "${AUTH_TOKEN[@]}" -d "user_id=87" $API_ENDPOINT/user/unfollow
#echo

# Get user places
#curl "${CURL_OPTIONS[@]}" "${AUTH_TOKEN[@]}" "$API_ENDPOINT/user/places"
#echo

# Get user dishes
#curl "${CURL_OPTIONS[@]}" "${AUTH_TOKEN[@]}" "$API_ENDPOINT/user/dishes?offset=0&limit=5&user_id=44&order_by=createdz"
#echo

# Get user's favorite dishes
#curl "${CURL_OPTIONS[@]}" "${AUTH_TOKEN[@]}" "$API_ENDPOINT/user/favorites?offset=0&limit=5&user_id=87"
#echo

# Get user's liked dishes
#curl "${CURL_OPTIONS[@]}" "${AUTH_TOKEN[@]}" "$API_ENDPOINT/user/likes?offset=0&limit=5"
#echo

# Flag a dish
#curl "${CURL_OPTIONS[@]}" "${AUTH_TOKEN[@]}" -d "dish_id=177&type_id=1" $API_ENDPOINT/dish/flag
#echo

# Favorite a dish
#curl "${CURL_OPTIONS[@]}" "${AUTH_TOKEN[@]}" -d "dish_id=145" $API_ENDPOINT/dish/favorite
#echo

# Unfavorite a dish
#curl "${CURL_OPTIONS[@]}" "${AUTH_TOKEN[@]}" -d "dish_id=145" $API_ENDPOINT/dish/unfavorite
#echo

# Like a dish
#curl "${CURL_OPTIONS[@]}" "${AUTH_TOKEN[@]}" -d "dish_id=145" $API_ENDPOINT/dish/like
#echo

#Unlike a dish
#curl "${CURL_OPTIONS[@]}" "${AUTH_TOKEN[@]}" -d "dish_id=145" $API_ENDPOINT/dish/unlike
#echo

# Get user info (profile+counters)
#curl "${CURL_OPTIONS[@]}" "${AUTH_TOKEN[@]}" "$API_ENDPOINT/user/info"
#echo

# Ping the API
#curl "${CURL_OPTIONS[@]}" "${AUTH_TOKEN[@]}" $API_ENDPOINT/ping
#echo

# Get dish comments
#curl "${CURL_OPTIONS[@]}" "${AUTH_TOKEN[@]}" $API_ENDPOINT/dish/comments?dish_id=122
#echo

# Add a dish comment
#curl "${CURL_OPTIONS[@]}" "${AUTH_TOKEN[@]}" -d dish_id=122 --data-urlencode "comment=Дайте две!" $API_ENDPOINT/comment/add
#$echo

# Resize an image
#curl "${CURL_OPTIONS[@]}" "${AUTH_TOKEN[@]}" -d "image_url=/files/e3/28/e328f1ea170d11e28eebd34908647b91&width=116&height=116" $API_ENDPOINT/image/resize
#echo

# Check login availability
#curl "${CURL_OPTIONS[@]}" "${AUTH_CLIENT[@]}" "$API_ENDPOINT/checkLogin?login=test112"
#echo

# Check email availability
#curl "${CURL_OPTIONS[@]}" "${AUTH_CLIENT[@]}" $API_ENDPOINT/checkEmail?email=e.yarmash@gmail.com
#echo

# Delete a place type
#curl "${CURL_OPTIONS[@]}" "${AUTH_TOKEN[@]}" -d type_id=2 $API_ENDPOINT/place/deleteType
#echo

# Add a place
#curl "${CURL_OPTIONS[@]}" "${AUTH_TOKEN[@]}" -d "type_id=14&title=test" $API_ENDPOINT/place/add
#echo

# Delete a place
#curl "${CURL_OPTIONS[@]}" "${AUTH_TOKEN[@]}" -d place_id=54 $API_ENDPOINT/place/delete
#echo

# Update place
#curl "${CURL_OPTIONS[@]}" "${AUTH_TOKEN[@]}" -d "place_id=46&title=test12345" $API_ENDPOINT/place/update
#echo

# Add a place type
#curl "${CURL_OPTIONS[@]}" "${AUTH_TOKEN[@]}" -F title=test -F picture=@/home/doer/dishes/CranberryCake62.jpg $API_ENDPOINT/place/addType
#echo

# Get user feed
#curl "${CURL_OPTIONS[@]}" "${AUTH_TOKEN[@]}" "$API_ENDPOINT/user/feed"
#echo

# Get list of events published to FB
#curl "${CURL_OPTIONS[@]}" "${AUTH_TOKEN[@]}" "$API_ENDPOINT/user/postedEvents"
#echo

# Update list of events published to FB
#curl "${CURL_OPTIONS[@]}" "${AUTH_TOKEN[@]}" -d "type_id=1&type_id=2&type_id=3&type_id=4" "$API_ENDPOINT/user/updatePostedEvents"
#echo
