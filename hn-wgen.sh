#!/bin/bash

limit=${1:-10}
baseUrl="https://hacker-news.firebaseio.com/v0"
topStoriesIds=$(curl -s "$baseUrl/topstories.json")
limitedIds=$(echo "$topStoriesIds" | jq -r ".[:$limit][]")

html_content=""
for id in $limitedIds; do
    story=$(curl -s "$baseUrl/item/$id.json")
    title=$(echo "$story" | jq -r '.title')
    url=$(echo "$story" | jq -r '.url')
    commentsUrl="https://news.ycombinator.com/item?id=$id"
    
    html_content+="<li><a href='$url'>$title</a> [<a href='$commentsUrl'>Comments</a>]</li>"$'\n'
done

cat << EOF
<ul>
$html_content
</ul>
EOF
